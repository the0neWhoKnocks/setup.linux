##
# Usage:
# 1. Drop your full-res image in ~/.local/share/icons/hicolor/
# 2. Open that image in GIMP
# 3. In the top menu, NOX > (click) Gen Freedesktop Icons
# 4. Choose the icon type
# 5. (click) Generate
##

import gtk, os, subprocess
from gimpfu import *

def genFreeDesktopIcons(image, drawable):
  dupeImg = pdb.gimp_image_duplicate(image)
  display = pdb.gimp_display_new(dupeImg)
  
  dialog = gtk.Dialog("Generate Freedesktop Icons", None, gtk.DIALOG_MODAL, None)
  dialog.goodExit = False
  # label
  label = gtk.Label("Choose Icon Type")
  dialog.vbox.add(label)
  # combobox
  cb = gtk.combo_box_new_text()
  cb.append_text("actions")
  cb.append_text("animations")
  cb.append_text("apps")
  cb.append_text("categories")
  cb.append_text("devices")
  cb.append_text("emblems")
  cb.append_text("emotes")
  cb.append_text("intl")
  cb.append_text("mimetypes")
  cb.append_text("places")
  cb.append_text("status")
  cb.set_active(2)
  dialog.imgType = cb.get_active_text()
  dialog.vbox.add(cb)
  # buttons
  cancelBtn = gtk.Button("Cancel")
  def handleCancelClick(btn):
    dialog.hide()
  cancelBtn.connect("clicked", handleCancelClick)
  genBtn = gtk.Button("Generate")
  def handleGenClick(btn):
    dialog.goodExit = True
    dialog.imgType = cb.get_active_text()
    dialog.hide()
  genBtn.connect("clicked", handleGenClick)
  btnBox = gtk.HButtonBox()
  btnBox.pack_start(cancelBtn, True, True, 0)
  btnBox.pack_start(genBtn, True, True, 0)
  dialog.vbox.add(btnBox)
  # --
  dialog.show_all()
  dialog.run()
  dialogGoodExit = dialog.goodExit
  imgType = dialog.imgType
  print("[nox] User chose image type: "+ imgType)
  dialog.destroy()
  if not dialogGoodExit: return
  
  print("[nox] Generate folders")
  IMG_SIZES = ["16", "32", "48", "64", "128", "256", "512"]
  PATH__HOME = os.environ['HOME']
  PATH__ICONS = ".local/share/icons/hicolor"
  PATH__BASE = PATH__HOME +"/"+ PATH__ICONS
  # generate folder names
  imgFolderNames = []
  for size in IMG_SIZES:
    imgFolderNames.append(size +"x"+ size +"/"+ imgType)
  # ensure directories exist
  foldersStr = PATH__BASE +"/{"+ ",".join(imgFolderNames) +"}"
  print("[nox] Running mkdir with: '"+ foldersStr +"'")
  subprocess.call("mkdir -p "+ foldersStr, shell=True)
  
  print("[nox] Process Images")
  imgPath = pdb.gimp_image_get_filename(image)
  imgName = os.path.basename(imgPath)
  reversedFolders = list(reversed(imgFolderNames))
  for ndx, size in enumerate(reversed(IMG_SIZES)):
    filePath = PATH__BASE +"/"+ reversedFolders[ndx] +"/"+ imgName
    pdb.gimp_image_scale(dupeImg, int(size), int(size))
    drawable = pdb.gimp_image_get_active_drawable(dupeImg)
    pdb.gimp_file_save(dupeImg, drawable, filePath, filePath)
    print("[nox]   - "+ filePath)
  
  pdb.gimp_display_delete(display)
  print("[nox] Closed image")

register(
  "python_fu_nox_gen_freedesktop_icons", # name
  "Generate scaled icons that meet FreeDesktop specifications", # blurb
  "Generate scaled icons that meet FreeDesktop specifications", # help
  "Nox", # author
  "", # copyright
  "2022", # date
  "<Image>/NOX/Gen Freedesktop Icons", # menu path
  "*", # image types
  [], # params
  [], # results
  genFreeDesktopIcons # function
)

main()
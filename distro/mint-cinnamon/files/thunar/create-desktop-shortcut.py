#!/usr/bin/env python3

##
# Debug script:
# - Run `tail -f ~/.xsession-errors`
# - Execute the action from Thunar, close the newly opened window to see any
#   printed output from the script.
##

import os, sys
from pathlib import Path

filePath = sys.argv[1]
parentPath = os.path.dirname(filePath)
fileName = Path(filePath).stem
KEY__BIN_PATH = 'binPath'
KEY__COMMENT = 'comment'
KEY__ICON_PATH = 'iconPath'
KEY__NAME = 'name'
KEY__VERSION = 'version'
inputs = [
  f"Version|{KEY__VERSION}",
  f"Bin Path|{KEY__BIN_PATH}",
  f"Name|{KEY__NAME}",
  f"Comment|{KEY__COMMENT}",
  f"Icon Path|{KEY__ICON_PATH}"
]

# Build input fields ===========================================================
entries = []
for i, label in enumerate(inputs):
  entries.append(f"--add-entry=\"{label.split('|')[0]}\"")
entries = ' '.join(entries)

# Open the form for the User to fill out =======================================
# The `span` uses [pango markup styling](https://docs.gtk.org/Pango/pango_markup.html).
cmd = os.popen(f'\
  zenity \
  --window-icon="/usr/share/icons/Mint-Y/categories/32/applications-utilities.png" \
  --title="Create Desktop Shortcut" \
  --forms \
  --title="" \
  --separator=";" \
  --text="<span face=\\"DejaVu Sans Mono\\" size=\\"80%\\">[Tokens]\n %p% = The parent path of the\n       executable.\n %e% = The full executable path.\n %n% = The name of the executable\n       without it\'s extension.</span>" \
  {entries} \
')
formVals = cmd.read().strip() # strip last newline, otherwise the last input will have a \n tacked on to the value.
exitCode = cmd.close()
if exitCode != None: sys.exit() # User canceled

# Parse the `zenity` output into key:value data ================================
vals = {
  KEY__BIN_PATH: '/bin/bash',
  KEY__COMMENT: 'This App does stuff.',
  KEY__ICON_PATH: '/usr/share/icons/Mint-Y/categories/32/applications-utilities.png',
  KEY__NAME: 'App Name',
  KEY__VERSION: '1.0',
}
for i, val in enumerate(formVals.split(';')):
  key = inputs[i].split('|')[1]
  if val: vals[key] = val.replace('%p%', parentPath).replace('%e%', filePath).replace('%n%', fileName)

# Create the shortcut file =====================================================
payload = (
  "[Desktop Entry]\n"
  f"Version={vals[KEY__VERSION]}\n"
  "Type=Application\n"
  "Terminal=false\n"
  f"Exec={vals[KEY__BIN_PATH]}\n"
  f"Name={vals[KEY__NAME]}\n"
  f"Comment={vals[KEY__COMMENT]}\n"
  f"Icon={vals[KEY__ICON_PATH]}\n"
)
fP = f"{parentPath}/{vals[KEY__NAME].lower().replace(' ', '-')}.desktop"
with open(fP, 'w') as f: f.write(payload)
os.chmod(fP, 0o775) # `0o` converts it to an octal

# Inform User where to place the file ==========================================
# I could automate this, but this gives the User the ability to make edits, and
# move the file when they're happy with it.
msg = "\
Once you're happy that the file is behaving as expected, move it to:\
\n\n\
~/.local/share/applications/ \
"
os.system(f'printf "{msg}" | zenity --width=400 --height=200 --window-icon="/usr/share/icons/Mint-Y/status/32/dialog-information.png" --title="Finalize Shortcut Creation" --text-info --font="DejaVu Sans Mono"')

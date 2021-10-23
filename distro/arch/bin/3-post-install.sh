#!/usr/bin/env bash

DIR__CONFIGS="${HOME}/.config/post-install"
FILE__CONFIG__HARDWARE="${DIR__CONFIGS}/hardware.conf"
FILE__CONFIG__PACKAGES__AUR="${DIR__CONFIGS}/packages--aur.conf"
FILE__CONFIG__PACKAGES__OFFICIAL="${DIR__CONFIGS}/packages--official.conf"
FILE__CONFIG__SETTINGS="${DIR__CONFIGS}/settings.conf"
FILE__CONFIG__USER_SCRIPTS="${DIR__CONFIGS}/user-scripts.conf"
DIALOG_KEY=$RANDOM

# ensure directory exists
mkdir -p "${DIR__CONFIGS}"

function loadListItems {
  listItems=()
  while read line; do
    if [[ "${line}" == *"# "* ]]; then
      listItems+=(FALSE)
      listItems+=("$(echo "${line}" | awk -F '#\\s' '{ printf "[ %s ]\n", $2 }')")
      listItems+=('')
    elif [[ "${line}" == *" | "* ]]; then
      listItems+=("$(echo "${line}" | awk -F '\\s+\\|\\s+' '{ print $1 }')")
      listItems+=("$(echo "${line}" | awk -F '\\s+\\|\\s+' '{ print $2 }')")
      listItems+=("$(echo "${line}" | awk -F '\\s+\\|\\s+' '{ print $3 }')")
    fi
  done < "${1}"
}

loadListItems './manifests/packages--official.txt'
yad --plug=$DIALOG_KEY --tabnum=1 \
  --image="emblem-package" \
  --text="Choose official packages to install." \
  --list \
  --grid-lines=both \
    --column='':CHK \
    --column=Package \
    --column=Description \
    --checklist \
    "${listItems[@]}" \
  1> "${FILE__CONFIG__PACKAGES__OFFICIAL}" &

loadListItems './manifests/packages--aur.txt'
yad --plug=$DIALOG_KEY --tabnum=2 \
  --image="x-package-repository" \
  --text="Choose AUR packages to install." \
  --list \
  --grid-lines=both \
    --column='':CHK \
    --column=Package \
    --column=Description \
    --checklist \
    "${listItems[@]}" \
  1> "${FILE__CONFIG__PACKAGES__AUR}" &

loadListItems './manifests/scripts--user.txt'
yad --plug=$DIALOG_KEY --tabnum=3 \
  --image="applications-utilities" \
  --text="Choose which User scripts to install." \
  --list \
  --grid-lines=both \
    --column='':CHK \
    --column=Script \
    --column=Description \
    --checklist \
    "${listItems[@]}" \
  1> "${FILE__CONFIG__USER_SCRIPTS}" &

yad --plug=$DIALOG_KEY --tabnum=4 \
  --image="applications-system" \
  --text="Configure your Desktop." \
  --form \
    --field="Dock":CB "cairo-dock!plank!latte-dock" \
    --field="Wallpaper":CB "Milky Way!Shell!Pastel Hills!Elarun" \
  1> "${FILE__CONFIG__SETTINGS}" &

yad --plug=$DIALOG_KEY --tabnum=5 \
  --image="folder-publicshare" \
  --text="Add commonly used folder structure." \
  --list \
  --grid-lines=both \
    --column='':CHK \
    --column=Folder \
    --checklist \
    TRUE 'Backups' \
    TRUE 'Projects' \
    TRUE '  ├─  3D' \
    TRUE '  ├─  Code' \
    TRUE '  ├─  Img' \
    TRUE '  └─  Vid' \
    TRUE 'Torrents' \
    TRUE 'VirtualBox ISOs' \
  1> "${FILE__CONFIG__SETTINGS}" &

yad --plug=$DIALOG_KEY --tabnum=6 \
  --image="audio-card" \
  --text="If you have dedicated hardware, you may need to install these packages." \
  --list \
    --radiolist \
    --column='':RD \
    --column=Device \
    FALSE 'GPU | AMD' \
    FALSE 'GPU | Nvidia' \
  1> "${FILE__CONFIG__HARDWARE}" &

yad \
  --window-icon="system-software-install" \
  --title="Post Install" \
  --width=800 \
  --height=500 \
  --center \
  --notebook \
    --key=$DIALOG_KEY \
    --tab="Official Packages" \
    --tab="AUR Packages" \
    --tab="User Scripts" \
    --tab="Settings" \
    --tab="Folders" \
    --tab="Hardware" \
    --active-tab=${1:-1} 

# # from within <REPO>/distro/arch/bin
# ./dist/user-script.sh --install "${PWD}/dist/backup.sh"
# ./dist/user-script.sh --uninstall "backup"
# 
# ./dist/user-script.sh --install "${PWD}/dist/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
# ./dist/user-script.sh --uninstall "lan-shares"
# 
# ./dist/user-script.sh --install "${PWD}/dist/user-script.sh"
# ./dist/user-script.sh --uninstall "user-script"

# Settings
# - Desktop
#   - wallpaper
#   - dock
# - GPU
#   - amd
#   - nvidia

# For KDE, current wallpaper is referenced in `~/.config/plasma-org.kde.plasma.desktop-appletsrc`
# ```
# [Containments][1][Wallpaper][org.kde.image][General]
# Image=file:///usr/share/wallpapers/MilkyWay/contents/images/5120x2880.png
# ```
# Custom wallpapers are stored in `~/.local/share/wallpapers`

# TODO: if certain extra packages were chosen, print out examples.. or dump a file with examples

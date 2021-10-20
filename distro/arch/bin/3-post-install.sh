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

yad --plug=$DIALOG_KEY --tabnum=1 \
  --image="emblem-package" \
  --text="Choose official packages to install." \
  1> "${FILE__CONFIG__PACKAGES__OFFICIAL}" &

yad --plug=$DIALOG_KEY --tabnum=2 \
  --image="x-package-repository" \
  --text="Choose AUR packages to install." \
  1> "${FILE__CONFIG__PACKAGES__AUR}" &

yad --plug=$DIALOG_KEY --tabnum=3 \
  --image="applications-utilities" \
  --text="Choose which User scripts to install." \
  1> "${FILE__CONFIG__USER_SCRIPTS}" &

yad --plug=$DIALOG_KEY --tabnum=4 \
  --image="applications-system" \
  --text="Choose what settings to import." \
  1> "${FILE__CONFIG__SETTINGS}" &

yad --plug=$DIALOG_KEY --tabnum=5 \
  --image="folder-publicshare" \
  --text="Add commonly used folder structure." \
  1> "${FILE__CONFIG__SETTINGS}" &

yad --plug=$DIALOG_KEY --tabnum=6 \
  --image="audio-card" \
  --text="If you have dedicated hardware, you may need to install these packages." \
  1> "${FILE__CONFIG__HARDWARE}" &

yad --plug=$DIALOG_KEY --tabnum=7 \
  --image="list-add" \
  --text="Not neccessary, but fun to play with." \
  1> "${FILE__CONFIG__HARDWARE}" &

yad \
  --window-icon="system-software-install" \
  --title="Post Install" \
  --center \
  --notebook \
    --key=$DIALOG_KEY \
    --tab="Official Packages" \
    --tab="AUR Packages" \
    --tab="User Scripts" \
    --tab="Settings" \
    --tab="Folders" \
    --tab="Hardware" \
    --tab="Extras" \
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

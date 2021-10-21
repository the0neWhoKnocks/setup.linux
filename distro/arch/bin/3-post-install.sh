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
  # echo "${1}"
  # cat "${1}"
  # echo "TRUE blah 'badf as df adsf'"
  # return ($( \
  #   cat "${1}" \
  # ))
  # listItems=('TRUE' blah 'asd fasd fa sdf')
  
  listItems=()
  # local fileData=$(cat "${1}")
  
  # IFS=""
  
  # while IFS="" read -r p || [ -n "$line" ]; do
  #   printf '%s\n' "$line"
  # done < "${1}"
  while read line; do
    if [[ "${line}" == *"# "* ]]; then
      listItems+=(FALSE)
      listItems+=("$(echo "${line}" | awk -F '#\\s' '{ printf "[ %s ]\n", $2 }')")
      listItems+=('')
    elif [[ "${line}" == *" | "* ]]; then
      listItems+=(TRUE)
      listItems+=("$(echo "${line}" | awk -F '\\s\\|\\s' '{ print $1 }')")
      listItems+=("$(echo "${line}" | awk -F '\\s\\|\\s' '{ print $2 }')")
    fi
    # listItems+=($(echo "${line}" | awk -F '\\s\\|\\s' '{ printf "TRUE \"%s\" \"%s\"\n", $1, $2 }'))
    # echo "-- $line --"
  done < "${1}"
  # exit
  
  # for line in "${fileData}"; do
  #   if [[ "${line}" == *" | "* ]]; then
  #     echo "-- ${line} --"
  #     listItems+=TRUE
  #     listItems+="$(echo "${line}" | awk -F '\\s\\|\\s' '{ print $1 }')"
  #     listItems+="$(echo "${line}" | awk -F '\\s\\|\\s' '{ print $2 }')"
  #   fi
  #   # listItems+=($(echo "${line}" | awk -F '\\s\\|\\s' '{ printf "TRUE \"%s\" \"%s\"\n", $1, $2 }'))
  #   # temp=($(echo "${line}" | awk -F '\\s\\|\\s' '{ printf "TRUE \"%s\" \"%s\"\n", $1, $2 }'))
  #   # echo "${line}" | awk '{ split($0, temp, "\\s\\|\\s"); print temp[0], temp[1] }'
  #   # echo "${temp[0]}"
  #   # echo "${temp[1]}"
  #   # echo "${line}"
  # done
  # exit
  # 
  # listItems=($( \
  #   cat "${1}" | \
  #   awk -F '\\s\\|\\s' '{ printf "TRUE \"%s\" \"%s\"\n", $1, $2 }'
  # ))
}

# listItems=$(
#   cat "packages--official.txt" | \
#   awk -F '\\s\\|\\s' '{ printf "TRUE %s \"%s\"\n", $1, $2 }'
# )
# echo "${listItems}" | yad --plug=$DIALOG_KEY --tabnum=1 \
# listItems=$(loadListItems 'packages--official.txt')

# for var in "${listItems[@]}"; do
#   echo "-- ${var}"
# done
# exit

# echo "${listItems[@]}"
# exit
loadListItems 'packages--official.txt'
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
  --width=800 \
  --height=500 \
  --center \
  --notebook \
    --key=$DIALOG_KEY \
    --tab="Official Packages" \
    # --tab="AUR Packages" \
    # --tab="User Scripts" \
    # --tab="Settings" \
    # --tab="Folders" \
    # --tab="Hardware" \
    # --tab="Extras" \
    # --active-tab=${1:-1} 

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

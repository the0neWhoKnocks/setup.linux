#!/usr/bin/env bash

DIR__CONFIGS="${HOME}/.config/post-install"

# ensure directory exists
mkdir -p "${DIR__CONFIGS}"

#!/usr/bin/env bash

GUI=$(cat ./3-post-install-gui.html)
outputFile=''

function closeDialog {
  # NOTE: 'YAD_PID' is not set when using 'html'
  pkill yad
}

# NOTE: Reason for 'JSC_SIGNAL_FOR_GC' https://bugs.webkit.org/show_bug.cgi?id=223069
echo "$GUI" | JSC_SIGNAL_FOR_GC=30 stdbuf -oL -eL yad \
  --window-icon="system-software-install" \
  --title="Post Install" \
  --width=800 \
  --height=500 \
  --center \
  --html \
    --print-uri \
  --no-buttons \
2>&1 | while read -r line; do
  if [[ "${line}" != *"CONSOLE LOG"* ]]; then
    if [[ "${line}" == "[CLOSE]" ]]; then
      closeDialog
    elif [[ "${line}" == *"[FILE:"* ]]; then
      outputFile=$(echo "${line}" | awk -F'"' '{ print $2 }')
      outputFile="${DIR__CONFIGS}/${outputFile}"
      touch "${outputFile}"
      echo "" > "${outputFile}"
    elif [[ "${outputFile}" != '' ]]; then
      echo "$line" >> "${outputFile}"
    fi
  fi
done

# TEMP: just verifying
echo "${DIR__CONFIGS}"
ls -la "${DIR__CONFIGS}"

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

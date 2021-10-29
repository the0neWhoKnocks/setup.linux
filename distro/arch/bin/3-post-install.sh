#!/usr/bin/env bash

DIR__CONFIGS="${HOME}/.config/post-install"

# ensure directory exists
mkdir -p "${DIR__CONFIGS}"

GUI=$(cat ./3-post-install-gui.html)
outputFile=''

function closeDialog {
  # NOTE: 'YAD_PID' is not set when using 'html'
  pkill yad
}

# NOTE: Reason for 'JSC_SIGNAL_FOR_GC' https://bugs.webkit.org/show_bug.cgi?id=223069
echo "$GUI" | yad \
  --window-icon="system-software-install" \
  --title="Post Install" \
  --width=900 \
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
      if [[ "${line}" == *'${PWD}'* ]]; then
        line=$(echo "${line}" | sed "s|\${PWD}|${PWD}|g")
      fi
      
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


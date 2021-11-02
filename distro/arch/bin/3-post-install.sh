#!/usr/bin/env bash

DIR__CONFIGS="${HOME}/.config/post-install"
REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "${REPO_PATH}")"

# kill the previous dir once this has initialized
if [ -d "/root/${REPO_NAME}" ]; then
  sudo rm -rf "/root/${REPO_NAME}"
fi

# ensure directory exists
mkdir -p "${DIR__CONFIGS}"

GUI=$(cat ./3-post-install-gui.html)
outputFile=''

# NOTE: uncomment below for debugging purposes
# (
#   echo "PWD=${PWD}"
#   echo "DIR__CONFIGS=${DIR__CONFIGS}"
#   echo "REPO_PATH=${REPO_PATH}"
#   echo "GUI=${GUI}"
# ) > ~/Desktop/post-install.log

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
      # swap out variable references
      if [[ "${line}" == *'${PWD}'* ]]; then
        line=$(echo "${line}" | sed "s|\${PWD}|${PWD}|g")
      elif [[ "${line}" == *'${REPO_PATH}'* ]]; then
        line=$(echo "${line}" | sed "s|\${REPO_PATH}|${REPO_PATH}|g")
      fi
      
      echo "$line" >> "${outputFile}"
    fi
  fi
done

# TEMP: just verifying
echo "${DIR__CONFIGS}"
ls -la "${DIR__CONFIGS}"

if [ -f "${HOME}/.config/autostart/post-install.desktop" ]; then
  rm "${HOME}/.config/autostart/post-install.desktop"
fi

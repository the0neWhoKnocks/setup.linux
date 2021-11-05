#!/usr/bin/env bash

DIR__CONFIGS="${HOME}/.config/post-install"
PATH__OUTPUT_FILE="${DIR__CONFIGS}/install.sh"
REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "${REPO_PATH}")"
GUI=$(cat ./3-post-install-gui.html)

# kill the previous dir once this has initialized
if [ -d "/root/${REPO_NAME}" ]; then
  sudo rm -rf "/root/${REPO_NAME}"
fi

# ensure directory exists
mkdir -p "${DIR__CONFIGS}"

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

rm -f "${PATH__OUTPUT_FILE}"
IFS='' # maintain whitespace from output
echo "${GUI}" | sed "s|_FILENAME_|${PATH__OUTPUT_FILE}|g" | yad \
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
      touch "${outputFile}"
      echo "" > "${outputFile}"
    elif [[ "${outputFile}" != '' ]]; then
      # swap out variable references
      if [[ "${line}" == *'${PWD}'* ]]; then
        line=$(echo "${line}" | sed "s|\${PWD}|${PWD}|g")
      fi
      if [[ "${line}" == *'${REPO_PATH}'* ]]; then
        line=$(echo "${line}" | sed "s|\${REPO_PATH}|${REPO_PATH}|g")
      fi
      if [[ "${line}" == *'${REPO_NAME}'* ]]; then
        line=$(echo "${line}" | sed "s|\${REPO_NAME}|${REPO_NAME}|g")
      fi
      if [[ "${line}" == *'~'* ]]; then
        line=$(echo "${line}" | sed "s|~|${HOME}|g")
      fi
      
      echo "$line" >> "${outputFile}"
    fi
  fi
done

if [ -f "${PATH__OUTPUT_FILE}" ] && [[ "$(cat "${PATH__OUTPUT_FILE}")" != '' ]]; then
  echo;
  echo " Installation script written to: '${PATH__OUTPUT_FILE}'"
  echo " Starting installation..."
  echo;
  
  chmod +x "${PATH__OUTPUT_FILE}"
  konsole -e /bin/bash --rcfile "${PATH__OUTPUT_FILE}"
fi

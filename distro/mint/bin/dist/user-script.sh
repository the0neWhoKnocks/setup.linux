#!/usr/bin/env bash

PATH__USER_APPS="${HOME}/.local/share/applications"

function absScriptPath {
  echo "/usr/local/bin/${1}"
}

function setLauncherVars {
  LAUNCHER_NAME="${1}.desktop"
  PATH__USER_APPS_LAUNCHER="${PATH__USER_APPS}/${LAUNCHER_NAME}"
}

function stripExt {
  echo "$(echo "${1}" | sed 's/\.sh//')"
}

function notify {
  notify-send -t 3000 --icon="${1:-'data-information'}" "${2}"
}

# NOTE: for `help`
# # from within <REPO>/distro/arch/bin
# ./dist/user-script.sh --install "${PWD}/dist/backup.sh"
# ./dist/user-script.sh --uninstall "backup"
# 
# ./dist/user-script.sh --install "${PWD}/dist/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
# ./dist/user-script.sh --uninstall "lan-shares"
# 
# ./dist/user-script.sh --install "${PWD}/dist/user-script.sh"
# ./dist/user-script.sh --uninstall "user-script"

if [[ "${1}" == '--install' ]]; then
  # parse ordered args
  PATH__SCRIPT="${2}"
  LAUNCHER__NAME="${3}"
  LAUNCHER__COMMENT="${4}"
  LAUNCHER__ICON="${5}"
  LAUNCHER__CMD_FLAGS="${6}"
  
  NAME__SCRIPT="$(stripExt "$(basename "${PATH__SCRIPT}")")"
  PATH__USR_SCRIPT="$(absScriptPath "${NAME__SCRIPT}")"
  
  # symlink source to a global path for easy access via terminal
  sudo ln -s "${PATH__SCRIPT}" "${PATH__USR_SCRIPT}"
  # ensure script permissions
  sudo chmod +x "${PATH__USR_SCRIPT}"
  
  if [[ "${LAUNCHER__NAME}" != '' ]]; then
    setLauncherVars "${NAME__SCRIPT}"
    
    # output '.desktop' launcher file
    {
      echo "[Desktop Entry]"
      echo "Version=1.0"
      echo "Name=${LAUNCHER__NAME}"
      echo "Comment=${LAUNCHER__COMMENT}"
      echo "Exec=${PATH__USR_SCRIPT} ${LAUNCHER__CMD_FLAGS}"
      echo "Icon=${LAUNCHER__ICON}"
      echo "Terminal=false"
      echo "Type=Application"
      echo "Categories=Utility;Application;"
    } > "${PATH__USER_APPS_LAUNCHER}"
    
    # set launcher permissions
    chmod +x "${PATH__USER_APPS_LAUNCHER}"
    
    # add launcher shortcut to Dekstop
    ln -s "${PATH__USER_APPS_LAUNCHER}" "${HOME}/Desktop/"
  fi
  
  if [ $? -eq 0 ]; then
    notify "${LAUNCHER__ICON}" "Installed '${NAME__SCRIPT}'"
  else
    notify "${LAUNCHER__ICON}" "Error installing '${NAME__SCRIPT}'"
  fi
elif [[ "${1}" == '--uninstall' ]]; then
  NAME__SCRIPT="$(stripExt "${2}")"
  PATH__USR_SCRIPT="$(absScriptPath "${NAME__SCRIPT}")"
  setLauncherVars "${NAME__SCRIPT}"
  
  sudo rm -f "${PATH__USR_SCRIPT}" "${PATH__USER_APPS_LAUNCHER}" "${HOME}/Desktop/${LAUNCHER_NAME}"
  
  if [ $? -eq 0 ]; then
    notify "" "Uninstalled '${NAME__SCRIPT}'"
  else
    notify "" "Error uninstalling '${NAME__SCRIPT}'"
  fi
fi

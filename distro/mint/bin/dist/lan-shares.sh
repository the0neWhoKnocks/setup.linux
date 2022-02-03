#!/usr/bin/env bash

if ! command -v nmap &> /dev/null; then
  echo " ╭──────────────────────────────────╮ "
  echo " │ Install missing dependency: nmap │ "
  echo " ╰──────────────────────────────────╯ "
  sudo apt install nmap
fi

SCRIPT_NAME=$(basename "${0}" | sed 's/\.sh$//')
CONFS_PATH="${HOME}/.config/${SCRIPT_NAME}"
PATH__USER_APPS="${HOME}/.local/share/application"

mkdir -p "${CONFS_PATH}"

export ICON__APP="drive-multidisk"
export LAUNCHER_NAME="${SCRIPT_NAME}.desktop"
export PATH__SCRIPT="${0}"
export PATH__USR_SCRIPT="/usr/local/bin/${SCRIPT_NAME}"
export FILE__CONF="${CONFS_PATH}/mount.conf"
export FILE__IP_LIST="${CONFS_PATH}/ips.conf"
export FILE__LAUNCHER="${PATH__USER_APPS}/${LAUNCHER_NAME}"
export DEFAULT__DOMAIN='WORKGROUP'
export DEFAULT__MOUNT_DIR='/media'
export EXIT_CODE__CANCELED=1
export EXIT_CODE__ESC=252
export EXIT_CODE__RESCAN=100
export EXIT_CODE__SUCCESS=0
export EXIT_CODE__TIMEOUT=70

# ==============================================================================

mountShares=false
if [[ "${1}" == '-m' ]] || [[ "${1}" == "--mount" ]]; then
  mountShares=true
fi

unMountShares=false
if [[ "${1}" == '-u' ]] || [[ "${1}" == "--unmount" ]]; then
  unMountShares=true
fi

configureApp=false
if [[ "${1}" == "-c" ]] || [[ "${1}" == "--configure" ]]; then
  configureApp=true
fi

showGUI=false
if [[ "${1}" == '-gui' ]]; then
  showGUI=true
fi

# ==============================================================================

function closeDialog {
  kill -USR1 $YAD_PID
}
export -f closeDialog

function notify {
  notify-send -t 3000 --icon="${1}" "${2}"
}
export -f notify

function handleError () {
  exitCode=$?
  
  if
    [[ "${exitCode}" == "${EXIT_CODE__CANCELED}" ]] ||
    [[ "${exitCode}" == "${EXIT_CODE__ESC}" ]] ||
    [[ "${exitCode}" == "${EXIT_CODE__TIMEOUT}" ]]
  then
    echo;
    echo " [ EXIT ] ${1}"
    echo;
    
    exit
  fi
}
export -f handleError

function scanNetwork {
  networkIPs=$( \
    # get a list of all mapped items on the LAN
    nmap -sP 192.168.1.0/24 | \
    # filter just the info that's needed
    grep "Nmap scan report for" | \
    # filter just the IPs
    grep -o -E "192[.0-9]+"
  )
  
  echo "${networkIPs}" > "${FILE__IP_LIST}"
}
export -f scanNetwork

function buildIPOpts {
  local networkIPs=$(cat "${FILE__IP_LIST}")
  
  local ipOpts=$(echo "${networkIPs}" | sed -z 's/\n/!/g' | sed 's/!$//')
  if [[ "${SHARE__SERVER_IP}" != '' ]]; then
    # set previously selected item in list (prepend with '^')
    ipOpts=$(echo "${ipOpts}" | sed "s/${SHARE__SERVER_IP}/^${SHARE__SERVER_IP}/")
  fi
  
  echo "${ipOpts}"
}
export -f buildIPOpts

function rescanNetwork {
  notify "${ICON__APP}" "Scanning Network"
  
  scanNetwork
  
  openConfigDialog
}
export -f rescanNetwork

function openConfigDialog {
  # import config variables
  [ -f "${FILE__CONF}" ] && source "${FILE__CONF}"
  
  if [ ! -f "${FILE__IP_LIST}" ]; then
    scanNetwork
  fi
  ipOpts=$(buildIPOpts)
  
  local previousError=''
  if [[ "${1}" != '' ]]; then
    previousError="<span color='#FF0000'>${1}</span>"
  fi
  
  local formData; 
  formData=$( \
    sudo yad \
      --width=470 \
      --center \
      --image=drive-harddisk \
      --window-icon=drive-harddisk \
      --title="Configure Shares" \
      --text="${previousError}" \
      --form \
        --field="Username" "${SHARE__USER:-}" \
        --field="Password" "${SHARE__PASS:-}" \
        --field="Server IP":CBE "${ipOpts}" \
        --field="Domain" "${SHARE__DOMAIN:-$DEFAULT__DOMAIN}" \
        --field="Mount Directory":DIR "${SHARE__MOUNT_DIR:-$DEFAULT__MOUNT_DIR}" \
        --field="Share Name" "${SHARE__SHARE_NAME:-}" \
      --button="Exit:${EXIT_CODE__CANCELED}" \
      --button="Re-Scan Network:${EXIT_CODE__RESCAN}" \
      --button="Save:${EXIT_CODE__SUCCESS}" \
  )
  handleError "You canceled out of adding config data."
  
  if [[ "${exitCode}" == "${EXIT_CODE__RESCAN}" ]]; then
    rescanNetwork
    return
  fi
  
  # using IFS and var expansion to parse the piped data (and maintain empty values)
  local oldIFS="${IFS}"
  IFS="|"
  formData=($formData)
  IFS="${oldIFS}"
  
  # map all data to vars
  SHARE__USER="${formData[0]}"
  SHARE__PASS="${formData[1]}"
  SHARE__SERVER_IP="${formData[2]}"
  SHARE__DOMAIN="${formData[3]}"
  SHARE__MOUNT_DIR="${formData[4]}"
  SHARE__SHARE_NAME="${formData[5]}"
  
  # proceed only if the user hasn't canceled
  if [[ "$?" == "${EXIT_CODE__SUCCESS}" ]]; then
    verifyConfigData
    
    saveConfigData
  fi
}
export -f openConfigDialog

function verifyConfigData {
  local error=''
  
  # ensure the user filled everything out
  if \
    [[ "${SHARE__USER}" == '' ]] || \
    [[ "${SHARE__PASS}" == '' ]] || \
    [[ "${SHARE__SERVER_IP}" == '' ]] || \
    [[ "${SHARE__DOMAIN}" == '' ]] || \
    [[ "${SHARE__MOUNT_DIR}" == '' ]] || \
    [[ "${SHARE__SHARE_NAME}" == '' ]]
  then
    error="You need to fill out all fields"
  fi
  
  # since the dir is the start dir, ensure the User picked another dir
  if [[ "${SHARE__MOUNT_DIR}" == "${DEFAULT__MOUNT_DIR}" ]]; then
    error="You need to create a sub-directory within the default \n'${DEFAULT__MOUNT_DIR}' folder."
  fi
  
  # inform the User of any errors
  if [[ "${error}" != '' ]]; then
    openConfigDialog "<span foreground='#000000' background='#ff0000'><b> ERROR </b></span>   ${error}"
  fi
}
export -f verifyConfigData

function saveConfigData {
  # construct and output config file
  {
    echo "SHARE__USER=\"${SHARE__USER}\""
    echo "SHARE__PASS=\"${SHARE__PASS}\""
    echo "SHARE__LOCAL_UID=\"${UID}\""
    echo "SHARE__SERVER_IP=\"${SHARE__SERVER_IP}\""
    echo "SHARE__DOMAIN=\"${SHARE__DOMAIN}\""
    echo "SHARE__MOUNT_DIR=\"${SHARE__MOUNT_DIR}\""
    echo "SHARE__SHARE_NAME=\"${SHARE__SHARE_NAME}\""
  } > "${FILE__CONF}"
  
  chmod 0600 "${FILE__CONF}"
}
export -f saveConfigData

function unMountShares {
  # import config variables
  source "${FILE__CONF}"
  
  if [ "$(ls -A ${SHARE__MOUNT_DIR})" ]; then
    sudo umount -l "${SHARE__MOUNT_DIR}"
    
    if [[ "${?}" == "${EXIT_CODE__SUCCESS}" ]]; then
      notify "${ICON__APP}" "Network Shares Un-Mounted"
    else
      notify "${ICON__APP}" "Error Un-Mounting Network Shares"
    fi
  else
    notify "${ICON__APP}" "Network Shares Already Un-Mounted"
  fi
}
export -f unMountShares

function mountShares {
  # import config variables
  source "${FILE__CONF}"
  
  if [ "$(ls -A ${SHARE__MOUNT_DIR})" ]; then
    notify "${ICON__APP}" "Network Shares Already Mounted"
  else
    # NOTE: Add `-v` flag to get verbose mount output in case something goes wrong
    sudo mount -t cifs -o uid="${SHARE__LOCAL_UID}",gid="${SHARE__LOCAL_UID}",username="${SHARE__USER}",password="${SHARE__PASS}",domain="${SHARE__DOMAIN}" "//${SHARE__SERVER_IP}/${SHARE__SHARE_NAME}" "${SHARE__MOUNT_DIR}"
    
    if [[ "${?}" == "${EXIT_CODE__SUCCESS}" ]]; then
      notify "${ICON__APP}" "Network Shares Mounted"
    else
      notify "${ICON__APP}" "Error Mounting Network Shares"
    fi
  fi
}
export -f mountShares

function openGUI {
  # import config variables
  source "${FILE__CONF}"
  
  GUI__ICON=drive-multidisk
  GUI__TITLE="LAN Shares"
  
  function guiBtn {
    label="${1}"
    icon="${2}"
    tooltip="${3}"
    
    echo " <span size='xx-large'>${label}</span>!${icon}!${tooltip}":FBTN
  }
  
  yad \
    --title "${GUI__TITLE}" \
    --center \
    --text="${GUI__TITLE}" \
    --image="${GUI__ICON}" \
    --window-icon="${GUI__ICON}" \
    --width=300 \
    --no-buttons \
    --form \
      --field="$(guiBtn 'Mount' 'package-install' 'Mount your shares')" "bash -c mountShares" \
      --field="$(guiBtn 'Un-Mount' 'package-remove' 'Un-mount your shares')" "bash -c unMountShares" \
      --field="$(guiBtn 'Config' 'preferences-system' 'Configure this App')" "bash -c openConfigDialog" \
      --field="$(guiBtn 'Exit' 'emblem-error' 'Exit App')" "bash -c closeDialog"
}
export -f openGUI

# ==============================================================================

configExists=false
if [ -f "${FILE__CONF}" ]; then
  configExists=true
  source "${FILE__CONF}"
fi

# Configure
if ! $configExists || $configureApp; then
  openConfigDialog
fi

if [[ "${1}" == "-u" ]]; then
  unMountShares
fi

if [[ "${1}" == "-m" ]]; then
  mountShares
fi

if $showGUI; then
  openGUI
fi

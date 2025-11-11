#!/usr/bin/env bash

# NOTE: YAD
# - source: https://github.com/v1cont/yad
# - general opts: https://yad-guide.ingk.se/general-options/general-options.html
# - dialog types: https://yad-guide.ingk.se/
# - marginal styling of items with Pango: https://docs.gtk.org/Pango/pango_markup.html

if ! command -v nmap &> /dev/null || ! command -v yad &> /dev/null; then
  deps=(appmenu-gtk3-module nmap yad)
  
  # If run within a shell, the script should have SHLVL 2 or greater. When run 
  # by double clicking, or from a desktop launcher, it should be 1.
  if [ $SHLVL -ge 2 ]; then 
    echo " ╭─────────────────────────────────╮ "
    echo " │ Installing missing dependencies │ "
    echo " ╰─────────────────────────────────╯ "
    sudo apt install ${deps[@]}
  else
    pass=''
    
    if [[ "$(sudo -n false 2>&1)" == *"password is required"* ]]; then 
      depsStr=$(printf '  - %s\n' "${deps[@]}")
      pass=$(zenity --entry \
        --title="Missing Dependencies" \
        --text="Enter your password to install missing dependencies:\\n${depsStr}" \
        --entry-text "" \
        --hide-text
      )
    fi
    
    notify-send -t 3000 --hint="int:transient:1" --icon="info" "Installing Dependencies"
    { echo "${pass}"; } | sudo -S apt install -y ${deps[@]}
    
    if [ $? -ne 0 ]; then
      zenity --error --text="There was a problem installing the dependencies."
      exit 0
    else
      notify-send -t 3000 --hint="int:transient:1" --icon="info" "Dependencies Installed"
    fi
  fi
fi

SCRIPT_NAME=$(basename "${0}" | sed 's/\.sh$//')
CONFS_PATH="${HOME}/.config/${SCRIPT_NAME}"
PATH__USER_APPS="${HOME}/.local/share/application"

mkdir -p "${CONFS_PATH}"

export ICON__APP="drive-multidisk"
export ICON__THEME="breeze-dark"
export LAUNCHER_NAME="${SCRIPT_NAME}.desktop"
export PATH__SCRIPT="${0}"
export PATH__USR_SCRIPT="/usr/local/bin/${SCRIPT_NAME}"
export FILE__CONF_PATTERN="mount__*.conf"
export FILE__IP_LIST="${CONFS_PATH}/ips.conf"
export FILE__LAUNCHER="${PATH__USER_APPS}/${LAUNCHER_NAME}"
export DEFAULT__DOMAIN='WORKGROUP'
export DEFAULT__MOUNT_DIR='/mnt'
export EXIT_CODE__CANCELED=1
export EXIT_CODE__EDIT_CONFIG=102
export EXIT_CODE__ESC=252
export EXIT_CODE__MOUNT=104
export EXIT_CODE__NEW_CONFIG=103
export EXIT_CODE__OPEN_GUI=101
export EXIT_CODE__RESCAN=100
export EXIT_CODE__SUCCESS=0
export EXIT_CODE__TIMEOUT=70
export EXIT_CODE__UNMOUNT=105

# ==============================================================================

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
  keep="${3:-1}"
  notify-send -t 3000 --hint="int:transient:${keep}" --icon="${1}" "$(echo -e "${2}")"
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

function buildComboBoxOpts {
  local lines=$(echo "${1}" | sort)
  
  local opts=$(echo "${lines}" | sed -z 's/\n/!/g' | sed 's/!$//')
  
  # set previously selected item in list (prepend with '^')
  if [[ "${2}" != '' ]]; then
    opts=$(echo "${opts}" | sed "s/${2}/^${2}/")
  fi
  
  echo "${opts}"
}
export -f buildComboBoxOpts

function rescanNetwork {
  notify "${ICON__APP}" "Scanning Network"
  
  scanNetwork
  
  openConfigDialog
}
export -f rescanNetwork

function parseFormData {
  # using IFS and var expansion to parse the piped data (and maintain empty values)
  local oldIFS="${IFS}"
  IFS="|"
  formData=($1)
  IFS="${oldIFS}"
  echo ${formData[@]}
}
export -f parseFormData

function openConfigDialog {
  # import config variables
  local editingConf=false
  if [ -f "${CONFS_PATH}/${currConf}" ]; then
    source "${CONFS_PATH}/${currConf}"
    editingConf=true
  else
    SHARE__USER=""
    SHARE__PASS=""
    SHARE__SERVER_IP=""
    SHARE__DOMAIN=""
    SHARE__MOUNT_DIR=""
    SHARE__SHARE_NAME=""
    SHARE__DISABLED=""
  fi
  
  if [ ! -f "${FILE__IP_LIST}" ]; then
    scanNetwork
  fi
  ipOpts=$(buildComboBoxOpts "$(cat "${FILE__IP_LIST}")" "${SHARE__SERVER_IP}")
  
  local previousError=''
  if [[ "${1}" != '' ]]; then
    previousError="<span color='#FF0000'>${1}</span>"
  fi
  
  local exitBtnCode=EXIT_CODE__CANCELED
  [ $editingConf ] && exitBtnCode=$EXIT_CODE__OPEN_GUI
  
  local formData;
  formData=$( \
    sudo yad \
      --width=470 \
      --center \
      --icon-theme="${ICON__THEME}" \
      --image=drive-harddisk \
      --window-icon=drive-harddisk \
      --title="Configure Shares" \
      --text="${previousError}" \
      --form \
        --focus-field=1 \
        --field="Username" "${SHARE__USER:-}" \
        --field="Password" "${SHARE__PASS:-}" \
        --field="Server IP":CBE "${ipOpts}" \
        --field="Domain" "${SHARE__DOMAIN:-$DEFAULT__DOMAIN}" \
        --field="Mount Directory":CDIR "${SHARE__MOUNT_DIR:-$DEFAULT__MOUNT_DIR}" \
        --field="Share Name" "${SHARE__SHARE_NAME:-}" \
        --field="Disabled":CHK "${SHARE__DISABLED:-FALSE}" \
      --button="Back:${EXIT_CODE__OPEN_GUI}" \
      --button="Re-Scan Network:${EXIT_CODE__RESCAN}" \
      --button="Save:${EXIT_CODE__SUCCESS}" \
  )
  handleError "You canceled out of adding config data."
  
  if [[ "${exitCode}" == "${EXIT_CODE__RESCAN}" ]]; then
    rescanNetwork
    return
  fi
  
  if [[ "${exitCode}" == "${EXIT_CODE__OPEN_GUI}" ]]; then
    openGUI
    return
  fi
  
  # using IFS and var expansion to parse the piped data (and maintain empty values)
  formData=($(parseFormData "$formData"))
  
  # map all data to vars
  SHARE__USER="${formData[0]}"
  SHARE__PASS="${formData[1]}"
  SHARE__SERVER_IP="${formData[2]}"
  SHARE__DOMAIN="${formData[3]}"
  SHARE__MOUNT_DIR="${formData[4]}"
  SHARE__SHARE_NAME="${formData[5]}"
  SHARE__DISABLED="${formData[6]}"
  
  # proceed only if the user hasn't canceled
  if [[ "$?" == "${EXIT_CODE__SUCCESS}" ]]; then
    verifyConfigData
    
    saveConfigData
    
    openGUI
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
  local mDir=$(basename "${SHARE__MOUNT_DIR}")
  local mDir="${mDir//' '/'_'}" # replace spaces
  local mDir="${mDir//'/'/'_'}" # replace slashes
  local conf="${CONFS_PATH}/${FILE__CONF_PATTERN//'*'/${mDir}__${SHARE__SHARE_NAME}}"
  local conf="${conf,,}" # convert to lowercase
  
  # construct and output config file
  {
    echo "SHARE__USER=\"${SHARE__USER}\""
    echo "SHARE__PASS=\"${SHARE__PASS}\""
    echo "SHARE__LOCAL_UID=\"${UID}\""
    echo "SHARE__SERVER_IP=\"${SHARE__SERVER_IP}\""
    echo "SHARE__DOMAIN=\"${SHARE__DOMAIN}\""
    echo "SHARE__MOUNT_DIR=\"${SHARE__MOUNT_DIR}\""
    echo "SHARE__SHARE_NAME=\"${SHARE__SHARE_NAME}\""
    echo "SHARE__DISABLED=\"${SHARE__DISABLED}\""
  } > "${conf}"
  
  chmod 0600 "${conf}"
}
export -f saveConfigData

function unMountShares {
  for conf in "${confs[@]}"; do
    # import config variables
    source "${CONFS_PATH}/${conf}"
    
    if [ "$(ls -A ${SHARE__MOUNT_DIR})" ]; then
      err="$(sudo umount -l "${SHARE__MOUNT_DIR}" 2>&1 > /dev/null)"
      
      if [[ "${?}" == "${EXIT_CODE__SUCCESS}" ]]; then
        local mDir=$(basename "${SHARE__MOUNT_DIR}")
        notify "${ICON__APP}" "Share '${mDir} | ${SHARE__SHARE_NAME}' Un-Mounted"
      else
        notify "${ICON__APP}" "Error Un-Mounting Share '${SHARE__SHARE_NAME}'\r${err}" 0
      fi
    else
      notify "${ICON__APP}" "Share '${SHARE__SHARE_NAME}' Wasn't Mounted"
    fi
  done
}
export -f unMountShares

function mountShares {
  for conf in "${confs[@]}"; do
    # import config variables
    source "${CONFS_PATH}/${conf}"
    
    if [[ "${SHARE__DISABLED}" == "TRUE" ]]; then
      continue
    fi
    
    if [ "$(ls -A ${SHARE__MOUNT_DIR})" ]; then
      notify "${ICON__APP}" "Share '${SHARE__SHARE_NAME}' Already Mounted"
    else
      # NOTE: Add `-v` flag to get verbose mount output in case something goes wrong
      # NOTE: Putting a share in /media or /home/<USER> can interfer with `systemd`s auto-mount functionality.
      
      # Only allow the current User read,write,execute access.
      USER_ACCESS=0700
      
      # `credentials=$HOME/.creds/share.txt`
      #    ```
      #    username=<NAME>
      #    password=<PASS>
      #    ```
      # - Would be an option `-o`
      # - Won't work in `fstab` since User's Home wouldn't be available until after login.
      
      # Dialects are not versions of samba or CIFS. They are the underlying protocol of the SMB system
      SMB_DIALECT=3.0
      
      err="$(sudo mount -t cifs \
        -o uid="${SHARE__LOCAL_UID}",gid="${SHARE__LOCAL_UID}",username="${SHARE__USER}",password="${SHARE__PASS}",dir_mode=$USER_ACCESS,file_mode=$USER_ACCESS,domain="${SHARE__DOMAIN}",vers=$SMB_DIALECT,iocharset=utf8 \
        "//${SHARE__SERVER_IP}/${SHARE__SHARE_NAME}" \
        "${SHARE__MOUNT_DIR}" 2>&1 > /dev/null)"
      
      if [[ "${?}" == "${EXIT_CODE__SUCCESS}" ]]; then
        local mDir=$(basename "${SHARE__MOUNT_DIR}")
        notify "${ICON__APP}" "Share '${mDir} | ${SHARE__SHARE_NAME}' Mounted"
      else
        notify "${ICON__APP}" "Error Mounting Share '${SHARE__SHARE_NAME}'\r${err}" 0
      fi
    fi
  done
}
export -f mountShares

function openGUI {
  GUI__ICON=drive-multidisk
  GUI__TITLE="LAN Shares"
  
  function guiBtn {
    label="${1}"
    icon="${2}"
    tooltip="${3}"
    
    echo " <span size='xx-large'>${label}</span>!${icon}!${tooltip}":FBTN
  }
  
  loadConfs
  local confOpts=$(buildComboBoxOpts "$(printf "%s\n" "${confs[@]}")")
  
  formData=$(yad \
    --title "${GUI__TITLE}" \
    --center \
    --text="${GUI__TITLE}" \
    --icon-theme="${ICON__THEME}" \
    --image="${GUI__ICON}" \
    --window-icon="${GUI__ICON}" \
    --width=300 \
    --form \
      --field="Config: ":CB " -- !${confOpts}" \
    --button="Edit Config":$EXIT_CODE__EDIT_CONFIG \
    --button="New Config":$EXIT_CODE__NEW_CONFIG \
    --button="Mount":$EXIT_CODE__MOUNT \
    --button="Un-Mount":$EXIT_CODE__UNMOUNT
  )
  
  case $? in
    $EXIT_CODE__EDIT_CONFIG)
      formData=($(parseFormData "$formData"))
      currConf="${formData[0]}"
      openConfigDialog
      ;;
    
    $EXIT_CODE__MOUNT)
      mountShares
      ;;
    
    $EXIT_CODE__NEW_CONFIG)
      currConf=''
      openConfigDialog
      ;;
    
    $EXIT_CODE__UNMOUNT)
      unMountShares
      ;;
  esac
}
export -f openGUI

function loadConfs {
  IFS=$'\n'
  confs=($(find "${CONFS_PATH}" -type f -name "${FILE__CONF_PATTERN}"))
  unset IFS
  
  if [ ${#confs[@]} -ne 0 ]; then
    for i in ${!confs[@]}; do
      confs[i]="${confs[i]//"${CONFS_PATH}/"/$timestamp}"
    done
  fi
}
export -f loadConfs

# ==============================================================================

configExists=false
loadConfs
if [ ${#confs[@]} -ne 0 ]; then
  configExists=true
  showGUI=true
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

#!/bin/bash

outputPath="${HOME}/Desktop"
rawSysInfo="$(dmesg | grep "DMI:" | sed -n 's|.*DMI: ||p' | sed -n 's|/.*||p')"
formattedSysInfo="${rawSysInfo// /_}"
rawOSInfo="$(cat /etc/os-release)"
osName="$(echo "$rawOSInfo" | sed -nr 's|^NAME="([^"]+)"|\1|p')"
osVersion="$(echo "$rawOSInfo" | sed -nr 's|^VERSION_ID="([^"]+)"|\1|p')"
osInfoStr="${osName} ${osVersion}"
formattedOSInfo="${osInfoStr// /_}"
# NOTE: Using the unicode 'Modifier Left Colon' instead of the standard
# character so it's safe on all platforms.
outputName="[$(date +"%Y-%m-%d_%H꞉%M꞉%S")]_[${formattedSysInfo}]_[${formattedOSInfo}]_[${USER}]_backup"

function error {
  echo;
  echo " [ERROR] ${1}"
  echo;
}

function outputToCurrentLine {
  cut -b1-$(tput cols) | sed -u 'i\\o033[2K' | stdbuf -o0 tr '\n' '\r'; echo
}

function replaceLastLineWith {
  echo -e '\e[1A\e[K'"$1"
}

createBackup=false
displayHelp=false
restoreBackup=false
remainingArgs=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -c|--create)
      createBackup=true
      shift 1
      ;;
    -f|--files)
      files=$2
      shift 2
      ;;
    -h|--help)
      displayHelp=true
      shift
      ;;
    -n|--output-name)
      outputName=$2
      shift 2
      ;;
    -p|--output-path)
      outputPath=$2
      shift 2
      ;;
    -r|--restore)
      restoreBackup=true
      restoreBackupPath=$2
      shift 2
      ;;
    *)
      remainingArgs+=("$1")
      shift
      ;;
  esac
done

# just display help
if $displayHelp || ! $createBackup && ! $restoreBackup; then
  echo;
  echo " Usage: backup [OPTION]..."
  echo " Archives specified files or paths within a User's Home directory."
  echo;
  echo "   -c, --create       Create a backup."
  echo "   -f, --files        Space or newline delimited file or folder paths."
  echo "   -h, --help         Displays this message."
  echo "   -n, --output-name  [Optional] The name of the backup file."
  echo "   -p, --output-path  [Optional] The path where the backup will be written."
  echo "   -r, --restore      Restore a backup."
  echo;
  echo " Example:"
  echo '   backup --create --files ".ssh .zshrc"'
  echo '   backup --create --files "$(cat ${HOME}/files-list.txt)"'
  echo '   backup --create --files "$(${HOME}/files-list.sh)"'
  echo '   backup --create --output-path "${HOME}/some/other/path" --files ".ssh .zshrc"'
  echo '   backup --create --output-name "some-other-name" --files ".ssh .zshrc"'
  echo '   backup --restore "${HOME}/backup.tar.bz2"'
  echo;
  
  exit 0
fi

set -- "${remainingArgs[@]}"

if $createBackup; then
  filesLength=${#files[@]}
  
  if [ $filesLength -gt 0 ]; then
    echo "[CREATE] Backup"
    
    BACKUP_FILE="${outputPath}/${outputName}.tar.bz2"
    
    (
      cd "${HOME}"
      echo "[TAR] Archive and compress files in \"${PWD}\""
      
      echo "${files}" | tar \
        --preserve-permissions \
        --bzip2 \
        --verbose \
        --create --file="${BACKUP_FILE}" \
        --files-from - | outputToCurrentLine
      
      # if [ $? -ne 0 ]; then
      #   # tar creates an empty file even when it fails
      #   rm "${BACKUP_FILE}"
      # fi
      
      replaceLastLineWith '[DONE]'
    )
  else
    error "No 'files' provided."
  fi
elif $restoreBackup; then
  if [[ "${restoreBackupPath}" != '' ]]; then
    echo "[RESTORE] Backup"
    
    (
      cd "${HOME}"
      echo "[TAR] Decompress and un-archive files in \"${PWD}\""
      
      sudo tar \
        --extract \
        --overwrite \
        --verbose \
        --file="${restoreBackupPath}" | outputToCurrentLine
      
      dconf load / < ./settings-backup.dconf
      # `dconf reset -f /` will reset all to default
      
      replaceLastLineWith '[DONE]'
    )
  else
    error "No backup file path provided."
  fi
else
  error "Missing 'create/restore' option."
fi

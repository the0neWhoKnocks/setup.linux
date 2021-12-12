#!/bin/bash

outputPath="${HOME}/Desktop"
outputName="$(date +"%Y-%m-%d_%H-%M-%S").user.${USER}.data.backup"

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
      
      # If there are any dconf files, apply them.
      # I'm specifically looking for files at the root of Home, and formatted 
      # with underscores and hopefully named by the export/load path.
      # Example: `~/com_gexperts_Tilix.dconf` would go to `/com/gexperts/Tilix/`
      find . -maxdepth 1 -name '*_*.dconf' | while read dconf; do
        parsed=$(echo "$dconf" | sed 's|_|/|g' | sed 's|./|/|' | sed 's|.dconf|/|')
        dconf load "${parsed}" < "${dconf}"
      done
      
      replaceLastLineWith '[DONE]'
    )
  else
    error "No backup file path provided."
  fi
else
  error "Missing 'create/restore' option."
fi

#!/bin/bash

outputPath="${HOME}/Desktop"
outputName="$(date +"%Y-%m-%d_%H-%M-%S").user.${USER}.data.backup"

displayHelp=false
remainingArgs=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      displayHelp=true
      shift
      ;;
    -f|--files)
      echo "${2}"
      files=$2[@]
      files=("${!files}")
      shift 2
      ;;
    -on|--output-name)
      outputName=$2
      shift 2
      ;;
    -op|--output-path)
      outputPath=$2
      shift 2
      ;;
    *)
      remainingArgs+=("$1")
      shift
      ;;
  esac
done

# just display help
if $displayHelp; then
  echo;
  echo "Usage: backup [OPTION]..."
  echo "Archives specified files or paths."
  echo;
  echo "  -h, --help          Displays this message"
  echo "  -f, --files         The initially selected index for the options"
  echo "  -on, --output-name  Limit how many options are displayed"
  echo "  -op, --output-path  An Array of options for a User to choose from"
  echo;
  echo "Example:"
  echo "  foodOptions=(\"pizza\" \"burgers\" \"chinese\" \"sushi\" \"thai\" \"italian\" \"shit\")"
  echo;
  echo "  getChoice -q \"What do you feel like eating?\" -o foodOptions -i \$((\${#foodOptions[@]}-1)) -m 4"
  echo "  printf \"\\n First choice is '\${selectedChoice}'\\n\""
  echo;
  echo "  getChoice -q \"Select another option in case the first isn't available\" -o foodOptions"
  echo "  printf \"\\n Second choice is '\${selectedChoice}'\\n\""
  echo;
fi

echo "${files}"

# set -- "${remainingArgs[@]}"
# local filesLength=${#files[@]}
# 
# if ! type 7z &> /dev/null; then
#   echo "Installing 7zip since it's not currently installed"
#   sudo pacman -S --noconfirm p7zip
# fi
# 
# BACKUP_NAME="${outputPath}/${outputName}.zip"
# 
# (cd $HOME && 7z a "$BACKUP_NAME" -p "$@" -x '!*.DS_Store')

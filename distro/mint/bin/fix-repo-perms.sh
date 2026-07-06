#!/usr/bin/env bash

# Description: If only mode (file permission) changes are detected in a git repo, reset the repo.
# Usage: ./fix-repo-perms.sh "${HOME}/Projects/Code/Apps"

parDir="$1"

for currDirPath in $parDir/*/; do
  currDirPath=${currDirPath%*/} # remove the trailing "/"
  currDir="${currDirPath##*/}"
  
  if [ -d "${currDirPath}/.git" ]; then
    (
      cd "${currDirPath}"
      
      trackedChanges=$(git --no-pager diff -G. "${currDirPath}/"*)
      untrackedChanges=$(git ls-files --others --exclude-standard)
      
      if test "$trackedChanges" == "" && test "$untrackedChanges" == ""; then
        git reset -q --hard HEAD 
        echo " [RESET]   ${currDir}"
      else
        echo " [IGNORED] ${currDir}"
      fi
    )
  fi
done

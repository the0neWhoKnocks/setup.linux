#!/usr/bin/env bash

(
  cd "${HOME}"

  # Create a list of all the installed packages
  dpkg -l > pkgs.list
  
  # Create backup of everything using dconf
  SETTINGS_BACKUP="./settings-backup.dconf"
  SETTINGS_BACKUP_IMGS="./settings-backup-imgs"
  dconf dump / > "${SETTINGS_BACKUP}"
  # Back up images that are referenced in the backup
  rm -rf "${SETTINGS_BACKUP_IMGS}"
  mkdir -p "${SETTINGS_BACKUP_IMGS}"
  grep -e "'.*\.jpg'" "${SETTINGS_BACKUP}" | cut -d "'" -f 2 | sed 's|file://||' | while read imgPath; do
    parsedPath=$(echo "${imgPath}" | sed "s|~|_HOME_/|" | sed "s|${HOME}|/_HOME_|" | sed "s|/||")
    mkdir -p "${SETTINGS_BACKUP_IMGS}/$(dirname "${parsedPath}")"
    cp "${imgPath}" "${SETTINGS_BACKUP_IMGS}/${parsedPath}"
  done
  
  list=(
    # ┎────────┒
    # ┃ System ┃
    # ┖────────┚
    /etc/sddm.conf.d
    /usr/share/sddm/themes/breeze/theme.conf.user
    
    # ┎──────┒
    # ┃ Home ┃
    # ┖──────┚
    # Atom
    ~/.var/app/io.atom.Atom/data/{packages,config.cson,keymap.cson,snippets.cson,styles.less}
    # Chrome and Chromium
    $(find ~/.config/chromium \( -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    $(find ~/.config/chromium/Default -mindepth 1 -maxdepth 1 -not -path "*Cache*" -printf "\"%p\"\n" | sort)
    $(find ~/.config/google-chrome \( -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    $(find ~/.config/google-chrome/Default -mindepth 1 -maxdepth 1 -not -path "*Cache*" -printf "\"%p\"\n" | sort)
    # Cinnamon
    ~/.cinnamon
    ~/.local/share/cinnamon
    # # Blender
    # $(find .config/blender/ -path '*/config' -printf "\"%p\"\n")
    # Dock
    ~/.config/cairo-dock
    # Gimp
    $(find ~/.config/GIMP -maxdepth 1 -mindepth 1 -type d -printf "\"%p\"\n")
    # Handbrake
    ~/.config/ghb/preferences.json
    ~/.config/ghb/presets.json
    # icons
    ~/.icons
    ~/.local/share/icons
    # Inkscape
    ~/.config/inkscape/preferences.xml
    # Insomnia
    ~/.config/Insomnia
    # Launcher
    ~/.config/ulauncher
    # LSD
    ~/.config/lsd/config.yaml
    # Nemo
    $(find ~/.config -path '*/gtk-*/bookmarks' -printf "\"%p\"\n")
    ~/.config/nemo
    ~/.local/share/nemo
    # # OBS Studio
    # ~/.config/obs-studio
    # Passwords
    ~/.local/share/keyrings
    # Shares
    ~/.config/lan-shares
    # Sticky Notes
    ~/.config/sticky
    # VLC
    ~/.config/vlc/skins
    ~/.config/vlc/vlc-qt-interface.conf
    # Xed
    ~/.local/share/{gtksourceview-3.0,gtksourceview-4}/styles
  
    # User stuff
    ~/.bash_history
    ~/.face
    ~/.gitconfig
    ~/.history
    ~/.nvidia-settings-rc
    ~/.oh-my-zsh
    ~/.profile
    ~/.ssh
    ~/.vimrc
    ~/.zshrc
    $(find ~/Pictures/{app-icons,avatars,wallpapers} -maxdepth 1 -type f -printf "\"%p\"\n")
    ~/pkgs.list
    ~/settings-backup.dconf
    ~/settings-backup-imgs
  )
  
  # ensure items are surrounded in quotes for paths with spaces
  echo "${list[@]}" | xargs -n 1 printf "%s\n"
)

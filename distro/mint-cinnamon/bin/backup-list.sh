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
    /var/lib/AccountsService/icons/${USER}
    
    # ┎──────┒
    # ┃ Home ┃
    # ┖──────┚
    # Albert
    ~/.config/albert
    # autostart
    ~/.config/autostart
    # Chrome and Chromium
    # The only files/folders that really matter in your profile are:
    # 📁 Accounts
    # 📁 Extension* (all of'm) 
    # 📁 Session Storage
    # 📁 Sessions
    # 📄 Bookmarks
    # 📄 Cookies (maybe, may cause issues)
    # 📄 Favicons
    # 📄 Login Data
    # 📄 Login Data for Account
    # 📄 Preferences
    $(find ~/.config/chromium \( -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    $(find ~/.config/chromium/Default -mindepth 1 -maxdepth 1 -not -path "*Cache*" -printf "\"%p\"\n" | sort)
    $(find ~/.config/google-chrome \( -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    $(find ~/.config/google-chrome/Default -mindepth 1 -maxdepth 1 -not -path "*Cache*" -printf "\"%p\"\n" | sort)
    # # Blender
    # $(find .config/blender/ -path '*/config' -printf "\"%p\"\n")
    # Dock
    ~/.config/cairo-dock
    # Gimp
    $(find ~/.config/GIMP -maxdepth 1 -mindepth 1 -type d -printf "\"%p\"\n")
    # Handbrake
    ~/.config/ghb/preferences.json
    ~/.config/ghb/presets.json
    # Hydrapaper
    ~/.config/hydrapaper.json
    # icons
    # ~/.icons
    ~/.local/share/icons
    # Inkscape
    ~/.config/inkscape/preferences.xml
    # Insomnia
    ~/.config/Insomnia
    # Kid3
    ~/.config/Kid3
    # LSD
    ~/.config/lsd/config.yaml
    # # OBS Studio
    # ~/.config/obs-studio
    # OS
    ~/.config/cinnamon
    ~/.config/cinnamon-monitors.xml
    ~/.config/mimeapps.list
    ~/.config/powerdevilrc
    ~/.config/powermanagementprofilesrc
    ~/.local/share/cinnamon
    # Pulse Audio
    /etc/pulse/daemon.conf
    ~/.config/pulse
    # ~/.config/pavucontrol.ini
    # Redshift
    ~/.config/redshift.conf
    # Sayonara
    ~/.config/sayonara
    # Shares
    ~/.config/lan-shares
    # Sticky Notes
    ~/.config/sticky
    # Thunar
    ~/.config/Thunar
    # Tumbler (thumbnailer)
    ~/.config/tumbler
    # VLC
    ~/.config/vlc/skins
    ~/.config/vlc/vlc-qt-interface.conf
    # VS Code
    ~/.config/Code/User
    ~/.vscode
    # Xed
    ~/.local/share/{gtksourceview-3.0,gtksourceview-4}/styles
  
    # User stuff
    ~/.bash_history
    ~/.gitconfig
    ~/.gitignore_global
    ~/.history
    # ~/.nvidia-settings-rc
    ~/.oh-my-zsh
    ~/.profile
    ~/.vimrc
    ~/.zshrc
    $(find ~/Pictures/{avatars,wallpapers} -maxdepth 1 -type f -printf "\"%p\"\n")
    ~/pkgs.list
    ~/settings-backup.dconf
    ~/settings-backup-imgs
    # Shared file manager stuff
    $(find ~/.config -path '*/gtk-*/bookmarks' -printf "\"%p\"\n")
    # Passwords
    ~/.gnupg
    ~/.local/share/keyrings
    ~/.ssh
  )
  
  # ensure items are surrounded in quotes for paths with spaces
  echo "${list[@]}" | xargs -n 1 printf "%s\n"
)

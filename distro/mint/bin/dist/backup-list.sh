#!/usr/bin/env bash

(
  cd "${HOME}"

  # NOTE: got some of the paths from: https://github.com/Prayag2/konsave/blob/master/konsave/conf_kde.yaml

  # Cinnamon GUI settings (panels, etc.)
  dconf dump "/org/cinnamon/" > ~/org_cinnamon.dconf
  # terminal settings
  dconf dump "/com/gexperts/Tilix/" > ~/com_gexperts_Tilix.dconf

  list=(
    # Atom
    .atom
    # Chrome and Chromium
    $(find .config/chromium \( -name 'Default' -o -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    $(find .config/google-chrome \( -name 'Default' -o -name 'Profile*' -o -name 'Local State' \) -printf "\"%p\"\n")
    # Cinnamon
    .cinnamon
    .local/share/cinnamon
    org_cinnamon.dconf
    # Fonts
    .fonts
    # Flameshot
    .config/flameshot/flameshot.ini
    # Gimp
    .config/GIMP/2.10
    # Handbrake
    .config/ghb/preferences.json
    .config/ghb/presets.json
    # icons
    .icons
    .local/share/icons
    # Inkscape
    .config/inkscape/preferences.xml
    # Insomnia
    .config/Insomnia
    # # Keyboard
    # .xbindkeysrc
    # Krita
    .config/kritarc
    .local/share/krita
    # LSD
    .config/lsd/config.yaml
    # Nemo
    .config/gtk-3.0/bookmarks
    .config/nemo
    .local/share/nemo
    # Notepadqq
    .config/Notepadqq/Notepadqq.ini
    # OBS Studio
    .config/obs-studio
    # Passwords
    .local/share/keyrings
    # Steam
    .steam/steam/config
    .steam/steam/userdata
    # Terminal
    com_gexperts_Tilix.dconf
    # VLC
    .config/vlc/vlc-qt-interface.conf
    
    # User stuff
    .gitconfig
    .history
    .oh-my-zsh
    .ssh
    .xprofile
    .zshrc
    $(find Pictures/avatars -maxdepth 1 -type f -printf "\"%p\"\n")
    $(find Pictures/wallpapers -maxdepth 1 -type f -printf "\"%p\"\n")
  )
  
  # ensure items are surrounded in quotes for paths with spaces
  echo "${list[@]}" | xargs -n 1 printf "%s\n"
)

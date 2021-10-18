#!/usr/bin/bash

args=(
  # 3D
  blender
  # Browsers
  chromium
  firefox
  # Development
  diff-so-fancy
  docker
  docker-compose
  filezilla
  meld
  notepadqq
  tilix
  virtualbox
  virtualbox-host-modules-arch
  virtualbox-guest-iso
  zsh
  # Gaming
  discord
  # Image
  flameshot
  gimp
  inkscape
  krita
  # Music player
  qmmp
  # UI
  cairo-dock
  cairo-dock-plug-ins
  cairo-dock-plug-ins-extras
  # Utils
  baobab
  bat
  btop
  filelight
  fzf
  lsd
  mc
  p7zip
  speedtest-cli
  # Video
  audacity
  mkvtoolnix-gui
  obs-studio
  peek
  # Video player
  vlc
)

# update all installed packages (including kernel)
sudo pacman -Syu
# install packages
sudo pacman -S --needed "${args[@]}"

# [Fun/useful but not needed]
# figlet
#   - figlet Hello World
# lolcat
# neofetch
# 
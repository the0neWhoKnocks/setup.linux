#!/usr/bin/bash

args=(
  # Browsers
  google-chrome
  # Development
  virtualbox-ext-oracle
  # Music file manipulation
  puddletag
  # System snapshots
  timeshift
  # Utils
  ascii-image-converter
  p7zip-gui
  qview
  # Video productions
  subtitleedit
)

yay -S --noredownload "${args[@]}"

# [Fun/useful but not needed]
# cmatrix
# figlet-fonts && figlet-fonts-extra
#  - font previews: http://www.figlet.org/examples.html
#  - figlet -f alligator Hello World
#  - figlet -f banner3-D Hello World | lolcat
#  - figlet -f colossal Nox | lolcat
#  - figlet -f cosmic Hello World | lolcat
#  - figlet -f cricket Hello World | lolcat
#  - figlet -f epic Hello World | lolcat
#  - figlet -f isometric3 Hello World | lolcat
#  - figlet -f larry3d Hello World | lolcat
#  - figlet -f nancyj-fancy Hello World | lolcat
#  - figlet -f rowancap Hello World | lolcat --seed=10
#  - figlet -f slant Hello World | lolcat --seed=60
# hollywood
# shell-color-scripts
#  - colorscript -e 1
#  - colorscript -e 6
#  - colorscript -e 16
#  - colorscript -e 31
#  - colorscript -e 32
#  - colorscript -e 39
#  - colorscript -e 41

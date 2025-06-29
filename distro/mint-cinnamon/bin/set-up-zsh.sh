#!/usr/bin/env bash

if ! command -v zsh &> /dev/null; then
  echo " ╭─────────────╮ "
  echo " │ Install ZSH │ "
  echo " ╰─────────────╯ "
  
  sudo apt install zsh
fi

echo " ╭───────────────────╮ "
echo " │ Install Oh-My-ZSH │ "
echo " ╰───────────────────╯ "
# Install
rm -rf "${HOME}/.oh-my-zsh"
CHSH=no RUNZSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RCFILE="${HOME}/.zshrc"
DEFAULT__ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
PATH__OMZ_CUSTOM="${ZSH_CUSTOM:-"${DEFAULT__ZSH_CUSTOM}"}"
PATH__ZSH_THEME="${PATH__OMZ_CUSTOM}/themes/zsh-theme-boom"
PATH__OMZ_PLUGINS="${PATH__OMZ_CUSTOM}/plugins"

# Add external plugins
if [ ! -d "${PATH__OMZ_PLUGINS}/zsh-autosuggestions" ]; then
  (
    cd "${PATH__OMZ_PLUGINS}"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
  )
fi
sed -i '/plugins=(/,/)/c\plugins=(\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)' "${RCFILE}"

# Add my theme
if [ ! -d "${PATH__ZSH_THEME}" ]; then
  (
    mkdir -p "${PATH__ZSH_THEME}"
    cd "${PATH__ZSH_THEME}"
    git clone https://github.com/the0neWhoKnocks/zsh-theme-boom.git .
    git remote set-url origin git@github.com:the0neWhoKnocks/zsh-theme-boom.git
    git checkout linux
  )
fi

# set theme
sed -i -E 's|ZSH_THEME=".*"|ZSH_THEME="zsh-theme-boom/skin"|' "${RCFILE}"

# add custom fonts
TTF_DIR=/usr/share/fonts/truetype
sudo mkdir -p "${TTF_DIR}"
sudo cp "${PATH__ZSH_THEME}/fonts/Fantasque Sans Mono Regular Nerd Font Complete Mono Windows Compatible.ttf" "${TTF_DIR}"
# update font cache (headless systems likely won't have this)
if command -v fc-cache &> /dev/null; then
  sudo fc-cache -fv
fi

# SHELL is usually only set during session login, so update it for clarity
sudo chsh -s "$(which zsh)" "${USER}" && export SHELL="$(which zsh)" && zsh

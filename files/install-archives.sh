#!/usr/bin/env bash

pkgs=(
  "Blender, 5.2.0, https://www.blender.org/download/release/Blender5.2/blender-5.2.0-linux-x64.tar.xz/"
  "BTop, 1.4.7, https://github.com/aristocratos/btop/releases/download/v1.4.7/btop-x86_64-unknown-linux-musl.tar.gz"
  "Godot, 4.7.1, https://github.com/godotengine/godot/releases/download/4.7.1-stable/Godot_v4.7.1-stable_linux.x86_64.zip"
  "JMKVPropEdit, 1.5.2, https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip"
  "VideOCR-GPU, 1.2.1, https://github.com/timminator/VideOCR/releases/download/v1.2.1/VideOCR-GPU-v1.2.1-Linux.tar.xz"
)

ARCH_DIR=$HOME/Downloads/archives
for item in "${pkgs[@]}"; do
  pkg=$(echo "$item" | awk -F', ' '{ print $1 }')
  version=$(echo "$item" | awk -F', ' '{ print $2 }')
  url=$(echo "$item" | awk -F', ' '{ print $3 }')
  outputPath="${HOME}/.local/lib/${pkg}/v${version}/"
  
  file="$(basename "${url}")"
  if [[ "$file" != *"${version}"* ]]; then
    lower_pkg="${pkg,,}"
    file="${file/${lower_pkg}/${lower_pkg}-v${version}}"
  fi
  
  downloaded_pkg="${ARCH_DIR}/${file}"
  
  echo "${pkg}"
  
  if [ ! -d "$outputPath" ]; then
    mkdir -p "${outputPath}"
    echo "  [CREATED] '${outputPath}'"
    
    if [ ! -f "$downloaded_pkg" ]; then
      wget --no-clobber "${url}" -P "${ARCH_DIR}/" -O "${file}"
      echo "  [DOWNLOADED] ${file}"
    fi
      
    if [[ "${file}" == *.zip ]]; then
      unzip -qq "${ARCH_DIR}/${file}" -d "${outputPath}"
    else
      tar --strip 1 --extract --file "${ARCH_DIR}/${file}" --directory="${outputPath}"
    fi
    echo "  [EXTRACTED] '${file}'"
  fi
done
#!/usr/bin/env bash
set -e

# NOTE: If a download page doesn't have a direct file link, run 
# `curl -I -s -L "YOUR_URL" | grep -Ei 'Location:|Content-Disposition:'`
# to see if it prints out a direct link.

pkgs=(
  "Blender, 5.3.0, https://mirror.blender.org/release/Blender5.3/blender-5.3.0-linux-x64.tar.xz" # Click the Download link, ignore the pop-up, click the 'download manually' link to expand and get an actual URL.
  "BTop, 1.4.7, https://github.com/aristocratos/btop/releases/download/v1.4.7/btop-x86_64-unknown-linux-musl.tar.gz"
  "Godot, 4.7.2, https://godot-releases.nbg1.your-objectstorage.com/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip" # Open Network tab in DevTools, click Download button, the actual file URL should appear in the Network list.
  "JMKVPropEdit, 1.5.2, https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip"
  "VideOCR-GPU, 1.2.1, https://github.com/timminator/VideOCR/releases/download/v1.2.1/VideOCR-GPU-v1.2.1-Linux.tar.xz"
)

ARCH_DIR=$HOME/Downloads/archives
if [ ! -d "$ARCH_DIR" ]; then
  mkdir -p "$ARCH_DIR"
fi

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
  
  if [ ! -d "$outputPath" ] || [ -z "$(ls -A "$outputPath")" ]; then
    mkdir -p "${outputPath}"
    echo "  [CREATED] '${outputPath}'"
    
    if [ ! -f "$downloaded_pkg" ]; then
      wget -q --show-progress -O "$downloaded_pkg" --no-clobber "${url}"
      tput cuu1 && tput ed # clear previous line
      echo "  [DOWNLOADED] ${file}"
    fi
      
    if [[ "${file}" == *.zip ]]; then
      unzip -qq "$downloaded_pkg" -d "${outputPath}"
    else
      tar --strip 1 --extract --file "$downloaded_pkg" --directory="${outputPath}"
    fi
    echo "  [EXTRACTED] '${file}'"
  else
    echo "  [SKIPPED] v${version} is already installed"
  fi
done
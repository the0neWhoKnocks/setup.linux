#!/usr/bin/env bash

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'printf "\\n [ERROR] \"${last_command}\" command failed with exit code $?.\\n\\n"; return' ERR


PATH__SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "/root/instvars.sh"

# set timezone
timedatectl set-timezone "${TIMEZONE}"
timedatectl set-ntp true
timedatectl status

# set locale info
LOCALE="en_US.UTF-8"
sed -i "/^#${LOCALE} UTF-8/s/^#//g" /etc/locale.gen
locale-gen && echo LANG="${LOCALE}" > /etc/locale.conf && export LANG="${LOCALE}"

# set keymaps
localectl set-keymap $(echo "${COUNTRY_ISO}" | awk '{ print tolower($0) }')

# set the computer's human-readable name
echo "${COMPUTER_NAME}" > /etc/hostname
(
  echo '::1        localhost'
  echo '127.0.0.1  localhost'
  echo "127.0.0.1  ${COMPUTER_NAME}"
) >> /etc/hosts

# set `root`'s password
(
  echo "${ROOT__PASSWORD}"
  echo "${ROOT__PASSWORD}"
) | passwd

# enable parrallel downloads to speed things up
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
# enable multi-lib packages
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# update package databases
pacman -Syu

# set up boot loader
pacman -S --noconfirm --needed grub efibootmgr
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# add non-root User
useradd -m "${NON_ROOT__USERNAME}"
(
  echo "${NON_ROOT__PASSWORD}"
  echo "${NON_ROOT__PASSWORD}"
) | passwd "${NON_ROOT__USERNAME}"
# Allow elevated privelages
pacman -S --noconfirm --needed sudo
# make it so the User doesn't require a password for `sudo` commands
echo "${NON_ROOT__USERNAME} ALL = NOPASSWD: ALL" | (EDITOR='tee -a' visudo)

# add base packages
pacman -S --noconfirm --needed \
  xorg `# Install display server` \
  networkmanager nmap `# Install network tools` \
  dolphin `# file browser` \
  konsole `# terminal` \
  plasma `# Desktop theme` \
  sddm `# display manager (login screen)` \
  sddm-kcm `# KDE integration for sddm` \
  xf86-input-synaptics `# better touchpad options` \
  appmenu-gtk-module yad `# GUI dialog for scripts` \
  git `# needed for install script`

# remove packages
pacman -R --noconfirm \
  discover `# kill annoying 'Updates Available' messages.`

# enable services during boot
# Enable Desktop
systemctl enable sddm.service
# Enable Network
systemctl enable NetworkManager.service

# create Swap
SWAP_FILE_PATH="/swapfile"
RAM_SIZE=$(cat /proc/meminfo | grep MemTotal | awk '{ printf("%.0fG\n", $2/1024/1000) }')
fallocate -l "${RAM_SIZE}" "${SWAP_FILE_PATH}"
chmod 600 "${SWAP_FILE_PATH}"
mkswap "${SWAP_FILE_PATH}"
swapon "${SWAP_FILE_PATH}"
# maintain changes
cp /etc/fstab /etc/fstab.bak
echo "${SWAP_FILE_PATH} none swap sw 0 0" | tee -a /etc/fstab

# set up Hibernate
OS_DISK=$(fdisk -l | grep Linux | awk '{ print $1 }')
SWAP_DEVICE=$(lsblk -dno UUID "${OS_DISK}")
SWAP_OFFSET=$( \
  # print list
  filefrag -v "${SWAP_FILE_PATH}" | \
  # trim the first 3 lines
  sed -e '1,3d' | \
  # select the first row
  grep "   0:" | \
  # select the 4th column
  awk 'NF { print $4 }' | \
  # remove the trailing dots
  sed 's/[.]//g'
)
sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=\".*\"/s/\"$/ resume=UUID=${SWAP_DEVICE} resume_offset=${SWAP_OFFSET}\"/g" /etc/default/grub
sed -i "/^HOOKS=(.*)/s/udev/udev resume/" /etc/mkinitcpio.conf

# skip Grub menu on boot
sed -i "/^GRUB_DEFAULT=0/c\GRUB_DEFAULT=saved" /etc/default/grub
sed -i "/^GRUB_TIMEOUT=5/c\GRUB_TIMEOUT=0" /etc/default/grub
sed -i "/^GRUB_TIMEOUT_STYLE=menu/c\GRUB_TIMEOUT_STYLE=hidden" /etc/default/grub
sed -i "/^#GRUB_SAVEDEFAULT=true/s/^#//g" /etc/default/grub

# update Grub
grub-mkconfig -o /boot/grub/grub.cf
# build ramdisk env.
mkinitcpio -p linux

# copy the repo over for the User, and the final installation step
REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "${REPO_PATH}")"
PATH__CONFIG="/home/${NON_ROOT__USERNAME}/.config"
mkdir -p "${PATH__CONFIG}/autostart/"
cp -R "/root/${REPO_NAME}" "/home/${NON_ROOT__USERNAME}/"
UPDATED_REPO_PATH="/home/${NON_ROOT__USERNAME}/${REPO_NAME}"
LAUNCHER="${PATH__CONFIG}/autostart/post-install.desktop"
(
  echo '[Desktop Entry]'
  echo "Exec=(cd '${UPDATED_REPO_PATH}/distro/arch/bin' && ./3-post-install.sh)"
  echo 'Icon=dialog-scripts'
  echo 'Name=Post Install'
  echo 'Type=Application'
  echo 'X-KDE-AutostartScript=true'
) > "${LAUNCHER}"
chmod +x "${LAUNCHER}"
chown -R "${NON_ROOT__USERNAME}:${NON_ROOT__USERNAME}" \
  "${PATH__CONFIG}" \
  "${UPDATED_REPO_PATH}" \
  "${LAUNCHER}"

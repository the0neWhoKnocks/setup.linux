#!/usr/bin/env bash

PATH__SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${PATH__SCRIPT_DIR}/utils/get-input.sh"

# set timezone
timedatectl set-timezone America/Los_Angeles
timedatectl set-ntp true
timedatectl status

# set locale info
LOCALE="en_US.UTF-8"
sed -i "/^#${LOCALE} UTF-8/s/^#//g" /etc/locale.gen
locale-gen && echo LANG="${LOCALE}" > /etc/locale.conf && export LANG="${LOCALE}"

# set the computer's human-readable name
getInput "Enter computer's name"
COMPUTER_NAME="${inputValue}"
echo "${COMPUTER_NAME}" > /etc/hostname
printf "\n::1         localhost\n127.0.0.1   localhost\n127.0.0.1   ${COMPUTER_NAME}\n" >> /etc/hosts

# set `root`'s password
echo "Enter password for the 'root' User"
passwd

# update package databases
pacman -Syy

# set up boot loader
pacman -S --noconfirm grub efibootmgr
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# add non-root User
getInput "Enter non-root username"
USERNAME="${inputValue}"
useradd -m "${USERNAME}"
passwd "${USERNAME}"
# Allow elevated privelages
pacman -S --noconfirm sudo
# make it so the User doesn't require a password for `sudo` commands
echo "${USERNAME} ALL = NOPASSWD: ALL" | (EDITOR='tee -a' visudo)

# add base packages
pacman -S --noconfirm \
  # Install display server
  xorg \
  # Install network tools
  networkmanager \
  nmap \
  # file browser
  dolphin \
  # terminal
  konsole \
  # Desktop theme
  plasma \
  # display manager (login screen)
  sddm \
  # KDE integration for sddm
  sddm-kcm \
  # better touchpad options
  xf86-input-synaptics \
  # GUI dialog for scripts
  appmenu-gtk-module \
  yad

# remove packages
pacman -R --noconfirm \
  # kill annoying 'Updates Available' messages.
  discover

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

# leave chroot
exit

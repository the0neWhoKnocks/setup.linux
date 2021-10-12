#!/usr/bin/env bash

# Installing via pacman only works as `root`. This ensures `sudo` is utilized
# if the current User isn't `root`.
currUid=$(id -u)
function _sudo () {
  [[ "${currUid}" != "0" ]] && set -- command sudo "$@"
  "$@"
}

STEP_FILE="/tmp/set-up-arch--step"
function goToStep {
  currentStep=$1
  cmd=$(sed -n "/$currentStep:/{:a;n;p;ba};" $0 | grep -v ':$')
  eval "$cmd"
  exit
}

# TODO: maybe delete
# getInput "Enter the network name to connect to"
# echo "${inputValue}"
function getInput {
  # echo "${1}: "
  read -p "${1}: " inputValue
}

function saveStep {
  touch "${STEP_FILE}"
  echo "${1}" > "${STEP_FILE}"
}

# ==============================================================================

# Ensure `wget` is available
if ! command -v wget &> /dev/null; then
  echo "'wget' wasn't detected, installing."
  _sudo pacman -S --noconfirm wget
fi

# Ensure choice selection script is available
if [ ! -f /tmp/get-choice.sh ]; then
  echo "'get-choice.sh' missing, downloading."
  wget -qO- https://raw.githubusercontent.com/the0neWhoKnocks/shell-menu-select/master/get-choice.sh > /tmp/get-choice.sh
  chmod +x /tmp/get-choice.sh
fi

source /tmp/get-choice.sh

initialStep=${1:-"_internet_"}
if [ -d "${STEP_FILE}" ]; then
  initialStep=$(cat "${STEP_FILE}")
  echo "Previous step detected, resuming at '${initialStep}' step"
fi
goToStep $initialStep

# ==============================================================================
_internet_:

opts=("Yes" "No")
getChoice -q "Are you using Wireless internet?" -o opts

# NOTE: When testing locally (not in a Live env.) you most likely won't have the
# `iwctl` and will need to install `iwd`. If running on an already installed
# system, you may have conflicts with NetworkManager service so the last step
# where it actually connects won't work (it'll say it's connected, but there'll
# be no internet).
if [[ "${selectedChoice}" == "Yes" ]]; then
  wirelessDeviceNames=($( \
    # get network devices
    iwctl device list | \
    # remove the first 4 lines from the output
    sed -e '1,4d' | \
    # return the first column with whitespace and blank lines removed
    awk 'NF { print $1 }'
  ))
  getChoice -q "Select Wireless Device" -o wirelessDeviceNames -m 6
  WIRELESS_DEVICE_NAME="${selectedChoice}"
  
  wirelessNetworks=($( \
    # get the current list of networks
    iwctl station "${WIRELESS_DEVICE_NAME}" scan && \
    # print the list of networks
    iwctl station "${WIRELESS_DEVICE_NAME}" get-networks | \
    # remove the first 4 lines from the output
    sed -e '1,4d' | \
    # return the first column with whitespace and blank lines removed
    awk 'NF { print $1 }'
  ))
  getChoice -q "Select Wireless Network" -o wirelessNetworks -m 6
  WIRELESS_NETWORK="${selectedChoice}"
  
  iwctl station "${WIRELESS_DEVICE_NAME}" connect "${WIRELESS_NETWORK}"
  
  if ping -c 1 "archlinux.org" &> /dev/null; then
    echo "Wireless network connected and external network reachable"
  else
    echo "[ERROR] Ping failed on '${WIRELESS_NETWORK}'"
    exit 1
  fi
fi

# ==============================================================================
_partition_:

if [ -d "/sys/firmware/efi/efivars" ]; then
  echo "UEFI system detected"
  
  fullDisksList=$( \
    # list all disks
    _sudo fdisk -l | \
    # filter just the lines with the disk names
    grep "Disk /" | \
    # ignore airoot,loop,rom and filter just the name and size columns
    awk '!/airoot|loop|rom/ { print $2,$3,$4 }' | \
    # remove colons and commas
    sed 's/[:,]//g'
  )
  printf "\nAvailable Disks:\n${fullDisksList}"
  
  disks=($( \
    echo "${fullDisksList}" | \
    # filter just the name
    awk '{ print $1 }'
  ))
  getChoice -q "\nSelect Disk to Format:" -o disks -m 4
  SELECTED_DISK="${selectedChoice}"
  
  # just printing formatting commands since there are no non-interactive commands
  echo;
  echo "fdisk ${SELECTED_DISK}"
  echo "  Wipe drive with 'd' (hit ENTER until all drives are gone)"
  echo "  Create EFI partition with 'n'"
  echo "    partition #: 1"
  echo "    1st sector: (blank)"
  echo "    2nd sector: +512M"
  echo "  Change partition type with 't'"
  echo "    Enter '1' for EFI System"
  echo "  Create root partition with 'n'"
  echo "    partition #: 2"
  echo "    1st sector: (blank)"
  echo "    2nd sector: (blank)"
  echo "  Finalize changes with 'w'"
  echo;
  echo "Create file systems with: mkfs.fat -F32 ${SELECTED_DISK}1 && mkfs.ext4 ${SELECTED_DISK}2"
  echo;
  echo "Once done, run command again to pick up at next step."
  echo;
  
  export SELECTED_DISK="${SELECTED_DISK}"
  saveStep "_install_linux_"
  exit 0
else
  echo "[ERROR] It appears that UEFI is not enabled, you'll have to figure out what to do."
  saveStep "_partition_"
  exit 1
fi

# ==============================================================================
_install_linux_:

# Back up mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Use reflector to update the list with the fastest download mirrors
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Mount the root partition (where Linux will install)
mount "${SELECTED_DISK}2" /mnt

# Install Linux and anything else you need for initial setup
pacstrap /mnt base linux linux-firmware vim

# Maintain filesystem mounts after boot
genfstab -U /mnt >> /mnt/etc/fstab

# ==============================================================================
_finalize_:

# enter the new install
arch-chroot /mnt

# set timezone
timedatectl set-timezone America/Los_Angeles
timedatectl set-ntp true
timedatectl status

# TODO

# ==============================================================================

# clean up any setup files
rm -f "${STEP_FILE}"

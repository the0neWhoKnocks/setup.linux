#!/usr/bin/env bash

PATH__SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PATH__SELECTED_DISK='/tmp/selected-disk'

source "${PATH__SCRIPT_DIR}/utils/get-choice.sh"
source "${PATH__SCRIPT_DIR}/utils/get-input.sh"
source "${PATH__SCRIPT_DIR}/utils/go-to-step.sh"

# user specified data
getInput "Enter computer's name (no spaces, use dashes)"
COMPUTER_NAME="${inputValue}"
getInput "Enter non-root username"
NON_ROOT__USERNAME="${inputValue}"
getInput "Enter non-root password"
NON_ROOT__PASSWORD="${inputValue}"
getInput "Enter root password"
ROOT__PASSWORD="${inputValue}"
# automated data
IP_DATA=$(curl -s https://ifconfig.co/json | sed -E 's/[":,]//g')
COUNTRY_ISO=$(echo "${IP_DATA}" | grep country_iso | awk '{ print $2 }')
TIMEZONE=$(echo "${IP_DATA}" | grep time_zone | awk '{ print $2 }')

initialStep=${1:-"_partition_"}
if [ -f "${STEP_FILE}" ]; then
  initialStep=$(cat "${STEP_FILE}")
  echo "Previous step detected, resuming at '${initialStep}' step"
fi
goToStep $initialStep

# ==============================================================================
_partition_:

if [ -d "/sys/firmware/efi/efivars" ]; then
  fullDisksList=$( \
    # list all disks
    fdisk -l | \
    # filter just the lines with the disk names
    grep "Disk /" | \
    # ignore airoot,loop,rom and filter just the name and size columns
    awk '!/airoot|loop|rom/ { printf "%s (%s %s)\n", $2, $3, $4 }' | \
    # remove colons and commas
    sed 's/[:,]//g'
  )
  echo " ┌──────────────┐ "
  echo " │ Format Disks │ "
  echo " └──────────────┘ "
  printf "\nAvailable Disks:\n${fullDisksList}\n"

  disks=($( \
    echo "${fullDisksList}" | \
    # filter just the name
    awk '{ print $1 }'
  ))
  getChoice -q "\nSelect Disk to Format:" -o disks -m 4
  SELECTED_DISK="${selectedChoice}"
  
  # unmount in case it was previously mounted
  umount /mnt
  # clear the partition table
  wipefs -a "${SELECTED_DISK}"
  # create new partitions
  (
    echo n     # Add a new partition
    echo p     # Primary partition (EFI boot)
    echo 1     # Partition number
    echo       # First sector (Accept default)
    echo +512M # Last sector
    echo y     # Remove partition signature if it exists (won't be prompted on a new disk)
    echo t     # Change partition type
    echo ef    # Set to EFI system
    echo n     # Add a new partition
    echo p     # Primary partition (Linux boot)
    echo 2     # Partition number
    echo       # First sector (Accept default)
    echo       # Last sector (Accept default)
    echo y     # Remove partition signature if it exists (won't be prompted on a new disk)
    echo w     # Finalize and write changes
  ) | fdisk "${SELECTED_DISK}"
  # create file systems
  mkfs.fat -F32 "${SELECTED_DISK}1"
  mkfs.ext4 "${SELECTED_DISK}2"
  fdisk -l
  sleep 2
else
  # NOTE: There's an EFI section in `2-chroot-setup` that should be addressed as well.
  echo "[ERROR] It appears that UEFI is not enabled, you'll have to figure out what to do."
  saveStep "_partition_"
  exit 1
fi

# ==============================================================================
_install_linux_:

# enable parrallel downloads to speed things up
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Back up mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Use reflector to update the list with the fastest download mirrors
echo " ┌───────────────────────┐ "
echo " │ Updating Mirror Links │ "
echo " └───────────────────────┘ "
reflector \
  --age 48 \
  --country "${COUNTRY_ISO}" \
  --fastest 12 \
  --number 12 \
  --latest 10 \
  --save /etc/pacman.d/mirrorlist

# Mount the root partition (where Linux will install)
mount "${SELECTED_DISK}2" /mnt

# Install Linux and anything else you need for initial setup
pacstrap /mnt \
  base linux linux-firmware `# Linux kernel` \
  vim `# text editor`

# NOTE: Anything that should persist on the new FS, should be copied over after
# 'pacstrap' runs, otherwise it'll be stomped on.

# Copy over updated files
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/
cp /etc/pacman.conf /mnt/etc/

# Save vars for later use
instVars=(
  "COMPUTER_NAME='${COMPUTER_NAME}'"
  "COUNTRY_ISO='${COUNTRY_ISO}'"
  "NON_ROOT__PASSWORD='${NON_ROOT__PASSWORD}'"
  "NON_ROOT__USERNAME='${NON_ROOT__USERNAME}'"
  "ROOT__PASSWORD='${ROOT__PASSWORD}'"
  "TIMEZONE='${TIMEZONE}'"
)
printf "%s\n" "${instVars[@]}" > /mnt/tmp/instvars.sh
echo " ┌────────────┐ "
echo " │ Vars Saved │ "
echo " └────────────┘ "
ls /mnt/tmp

# Maintain filesystem mounts after boot
genfstab -U /mnt >> /mnt/etc/fstab

# ==============================================================================
_finalize_:

REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "${REPO_PATH}")"

echo "${REPO_PATH} | ${REPO_NAME}"

# change repo remote over to SSH
(
  cd "${REPO_PATH}" \
  && git remote set-url origin git@github.com:the0neWhoKnocks/setup.linux.git \
)

# copy over repo to new partition
cp -r "${REPO_PATH}" "/mnt/tmp/"
ls -la "/mnt/tmp"

NEXT_SCRIPT="$(find "/mnt/tmp/${REPO_NAME}/distro/arch" -name "2-chroot-setup.sh")"
ls -la "$(dirname "${NEXT_SCRIPT}")"

# run chroot setup
arch-chroot /mnt "${NEXT_SCRIPT}"
if [ $?--ne 0 ]; then
  echo "[ERROR] chroot failed"
  exit 1
fi

# ==============================================================================

# clean up any setup files
rm -f \
  "${STEP_FILE}" \
  "/mnt/tmp/instVars.sh"

shutdown -r

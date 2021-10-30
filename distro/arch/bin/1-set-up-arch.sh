#!/usr/bin/env bash

PATH__SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PATH__SELECTED_DISK='/tmp/selected-disk'

source "${PATH__SCRIPT_DIR}/utils/get-choice.sh"
source "${PATH__SCRIPT_DIR}/utils/go-to-step.sh"

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
  printf "\nAvailable Disks:\n${fullDisksList}\n"

  disks=($( \
    echo "${fullDisksList}" | \
    # filter just the name
    awk '{ print $1 }'
  ))
  getChoice -q "\nSelect Disk to Format:" -o disks -m 4
  SELECTED_DISK="${selectedChoice}"
  
  # just printing the formatting commands since there are no non-interactive commands
  echo;
  echo " ╭─ "
  echo " │ > fdisk ${SELECTED_DISK} "
  echo " ╰─ "
  echo "  Wipe drive with '[ d ]' (hit ENTER until all drives are gone)"
  echo "  Create EFI partition with '[ n ]'"
  echo "    partition #: 1"
  echo "    1st sector: (blank)"
  echo "    2nd sector: +512M"
  echo "  Change partition type with '[ t ]'"
  echo "    Enter 'l' to get a list of types"
  echo "    Enter '1' (or 'ef') for EFI System"
  echo "  Create root partition with '[ n ]'"
  echo "    partition #: 2"
  echo "    1st sector: (blank)"
  echo "    2nd sector: (blank)"
  echo "  Finalize changes with '[ w ]'"
  echo;
  echo "Create file systems with:"
  echo " ╭─ "
  echo " │ > mkfs.fat -F32 ${SELECTED_DISK}1 && mkfs.ext4 ${SELECTED_DISK}2 "
  echo " ╰─ "
  echo;
  echo "Once done, run this script again to pick up at next step."
  echo;
  
  echo "${SELECTED_DISK}" > "${PATH__SELECTED_DISK}"
  saveStep "_install_linux_"
  exit 0
else
  echo "[ERROR] It appears that UEFI is not enabled, you'll have to figure out what to do."
  saveStep "_partition_"
  exit 1
fi

# ==============================================================================
_install_linux_:

# load previous selection
SELECTED_DISK=$(cat "${PATH__SELECTED_DISK}")

# Back up mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Use reflector to update the list with the fastest download mirrors
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Mount the root partition (where Linux will install)
mount "${SELECTED_DISK}2" /mnt

# Install Linux and anything else you need for initial setup
pacstrap /mnt \
  # Linux kernel
  base linux linux-firmware \
  # text editor
  vim

# Maintain filesystem mounts after boot
genfstab -U /mnt >> /mnt/etc/fstab

# ==============================================================================
_finalize_:

REPO_PATH="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "${REPO_PATH}")"

# change repo remote over to SSH
(
  cd "${REPO_PATH}" \
  && git remote set-url origin git@github.com:the0neWhoKnocks/setup.linux.git \
)

# copy over repo to new partition
cp -r "${REPO_PATH}" "/mnt/tmp/"

NEXT_SCRIPT="$(find "/mnt/tmp/${REPO_NAME}/distro/arch" -name "2-chroot-setup.sh" | sed 's/\/mnt//')"

# run chroot setup
arch-chroot /mnt "${NEXT_SCRIPT}"

# ==============================================================================

# clean up any setup files
rm -f "${STEP_FILE}"

restart now

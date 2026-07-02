# Mint: Cinnamon

This setup is for creative/development tasks. Before blindly installing everything listed, go over the **Software Details** sections to see if the software could be useful.

- [Pre-Install](#pre-install)
- [Install](#install)
- [Initial Boot](#initial-boot)
- [Set Up Display](#set-up-display)
- [Installing / Updating the Kernel](#installing--updating-the-kernel)
- [Software Sources](#software-sources)
- [System Tweaks](#system-tweaks)
- [Create Common Directories](#create-common-directories)
- [Don't Require Password for Sudo](#dont-require-password-for-sudo)
- [Install Base Software](#install-base-software)
  - [How to download packages from Launchpad](#how-to-download-packages-from-launchpad)
  - [How to set up a local mirror for packages](#how-to-set-up-a-local-mirror-for-packages)
- [Clone This Repo](#clone-this-repo)
- [Set Up Shell](#set-up-shell)
- [Set Up Repos](#set-up-repos)
- [Set Up Shares](#set-up-shares)
  - [Mount Share On Boot](#mount-share-on-boot)
    - [Using fstab to Mount Share On Demand](#using-fstab-to-mount-share-on-demand)
  - [Mount Share On-Demand](#mount-share-on-demand)
- [Install Software](#install-software)
  - [Via Software Manager or CLI](#via-software-manager-or-cli)
  - [Via Flatpak](#via-flatpak)
  - [Via deb](#via-deb)
  - [Via Archives](#via-archives)
  - [Via CLI (slightly complex)](#via-cli-slightly-complex)
- [Configure Software](#configure-software)
  - [General System Settings](#general-system-settings)
  - [Panel Settings](#panel-settings)
    - [Back up Panels](#back-up-panels)
    - [Restore Panels](#restore-panels)
    - [Reset Panels](#reset-panels)
  - [Headset Settings](#headset-settings)
- [Install Hardware](#install-hardware)
  - [Label Printer](#label-printer)
- [Make Extra Internal Drives Available](#make-extra-internal-drives-available)
- [Back Up or Restore Data](#back-up-or-restore-data)
  - [Backing up data](#backing-up-data)
    - [Back up with TimeShift (system files)](#back-up-with-timeshift-system-files)
    - [Back up with FreeFileSync (granular, any files you want)](#back-up-with-freefilesync-granular-any-files-you-want)
  - [Restoring data](#restoring-data)
    - [Restore with TimeShift](#restore-with-timeshift)
    - [Restore with FreeFileSync](#restore-with-freefilesync)
    - [Reset repos after restore](#reset-repos-after-restore)
  - [Create an encrypted USB drive to back up sensitive data](#create-an-encrypted-usb-drive-to-back-up-sensitive-data)
- [Useful Keyboard Shortcuts](#useful-keyboard-shortcuts)
- [Useful Commands](#useful-commands)
- [Useful Places](#useful-places)
- [Theming](#theming)
  - [GTK Themes and Apps](#gtk-themes-and-apps)
  - [Icons](#icons)
    - [Installing Raster Icons](#installing-raster-icons)
    - [Installing Vector Icons](#installing-vector-icons)
    - [Refreshing Icon Cache](#refreshing-icon-cache)
    - [Creating \& Adding Raster Icons](#creating--adding-raster-icons)
- [Troubleshooting](#troubleshooting)
  - [System boots to blank screen after failed update](#system-boots-to-blank-screen-after-failed-update)
  - [System going to sleep after a few seconds on the Login screen](#system-going-to-sleep-after-a-few-seconds-on-the-login-screen)
  - [Kernel Panic error after choosing "recommended" nvidia driver](#kernel-panic-error-after-choosing-recommended-nvidia-driver)
  - ["error: out of memory" on boot right after grub menu](#error-out-of-memory-on-boot-right-after-grub-menu)
  - [Chrome Saved Passwords Not Showing Up in Settings](#chrome-saved-passwords-not-showing-up-in-settings)
  - [How to Free Up Space?](#how-to-free-up-space)
  - [File Managers randomly freeze when transfering CIFS files](#file-managers-randomly-freeze-when-transfering-cifs-files)
  - [System Freezes/Locks When Entering Suspend](#system-freezeslocks-when-entering-suspend)
  - [Can't Boot Past Grub Menu](#cant-boot-past-grub-menu)
  - ["Couldn't Connect to Accessibility Bus" Warnings When Opening/Starting Something From CLI](#couldnt-connect-to-accessibility-bus-warnings-when-openingstarting-something-from-cli)
  - [USB Drive Slow to Eject or Suffers Data Loss](#usb-drive-slow-to-eject-or-suffers-data-loss)
  - [Steam Not Recognizing Bluetooth Controller](#steam-not-recognizing-bluetooth-controller)

---

## Pre-Install

I use [Ventoy](https://www.ventoy.net/en/index.html) to install my distros, so just download the distro and drop it in the designated `isos` folder on your formatted USB drive. 

> **Issue: Ventoy won't boot**
> **Solution:** In order to allow Ventoy to load, you'll have to disable Secure Boot in the Bios. In some cases, to change the Secure Boot setting, you'll need to set a supervisor password. Once the password is set the Secure Boot option will no longer be grayed out and can be disabled.

> **Issue: Can't install Linux due to RST being enabled**
> **Solution:** Go into the Bios. Location may vary, for me I found it under Main &gt; Sata Mode &gt; Changed it from `RST Premium with Optane` to `AHCI`.

---

## Install

1. Once the distro boots into it's live environment, double-click the **Install** item that should be on the Desktop.
1. When setting up the OS, choose **Something Else** to manually set up partitions.
1. In the disks table, select the same disk (it's root item, not any partitions if they exist).
    - Click **New Partition Table**
    - Select the **free space** entry (sometimes there's a `1 MB` free space item, dont use that).
        ```
        1,000 MB
        EFI
        ```
    - Select the **free space** entry
        ```
        50,000 MB (could be 3,000, but i made it match my RAM size to account for sleep)
        swap
        ```
    - Select the **free space** entry
        ```
        (use remaining space)
        ext4
        Mount point = /
        ```
1. In the disks table, select the disk where you want the `home` folder.
    - Click **New Partition Table**
    - Select the **free space** entry
        ```
        (use all space)
        ext4
        Mount point = /home
        ```
 - I have multiple drives, so find the drive where you'll install the OS and set that in the **Device for boot loader installation** drop-down.
 - Click **Install Now**
1. On the **Who are you?** page, I chose to **Encrypt my home folder**.


---

## Initial Boot

There's a splash screen that can hide potential issues during boot, so disable it while settings things up.
```sh
sudo vi /etc/default/grub
# Replace `splash` in GRUB_CMDLINE_LINUX_DEFAULT with `nosplash`

sudo update-grub
```

---

## Set Up Display

I've had mixed results with Driver Manager (for installing the video driver), so this is the manual way of doing what it does.
- Check what video driver is currently being used
    ```sh
    lspci -k | grep -EA3 'VGA|3D|Display' | grep 'Kernel driver in use'
    # Should output a line with `nouveau` or `nvidia`.
    ```
    
    If using an `nvidia` driver, you can find the version with
    ```sh
    cat /proc/driver/nvidia/version | grep -E 'Kernel Module  [0-9]+'
    # or
    nvidia-smi | grep -E 'Driver Version: [0-9]+'
    
    # Should output a line with a highlighted number, which is the major version.
    ```
- List available drivers to install
    ```sh
    ubuntu-drivers devices | grep 'driver  ' | grep -v '-server - '
    # Should output lines like
    # driver   : nvidia-driver-<VERSION> - distro non-free recommended
    # driver   : nvidia-driver-<VERSION> - distro non-free
    # --
    # driver   : xserver-xorg-video-nouveau - distro free builtin
    ```
    
    Generally use the `recommended` driver, then try the versions below it if you have issues.
- Install the driver
    ```sh
    sudo apt install <DRIVER>
    # <DRIVER> being something like `nvidia-driver-450` or `xserver-xorg-video-nouveau`
    ```
    
    If you want to uninstall a driver
    ```sh
    sudo apt remove nvidia-driver-<VERSION> && sudo apt autoremove
    ```

<br />
<br />

If you have multiple monitors, launch **Display**
- Select your main monitor and toggle it to `Set as Primary` if it isn't already set.
- Set the `Rotation` of other monitors if they're rotated.
- Drag monitors roughly into the correct positions.
- Apply, keep changes, rinse-and-repeat while adjusting monitor positions.
- Under **Settings** I also unchecked `Enable fractional scaling controls`. Not sure if it was actually hurting anything, but I disabled at during some troubleshooting and things have been stable so it stays off for now.

<br/>

Notes:
- If you have a dock that has one monitor hooked up, and another monitor is hooked up to a laptop, you may want to stick with the `nouveau` driver. It's the only one that's given me stable performance with a second monitor (via a dock).

---

## Installing / Updating the Kernel

I usually handle the kernel update via the Update Manager. Just be careful not to reboot before recompiling the NVidia modules (if you're using an NVidia video driver).

The theory is that after a kernel upgrade the new kernel is not active before the system is rebooted. To recompile the nvidia modules the new kernel needs to be active so this hasn’t been done as part of the upgrade process. So when one reboots after a kernel upgrade, the nvidia module is not able to communicate with the kernel (which usually leads to a user not being able to boot to the Desktop). The solution is to simply upgrade the `linux-headers-<VERSION>` which will automatically trigger a recompile of the nvidia kernels.
    ```sh
    sudo apt -y install "linux-headers-$(uname -r)"
    ```
    
    The drivers should start working again even without a reboot.
    ```sh
    # list installed driver
    dkms status
    # <ndvidia_driver_ver>, <kernel_ver>
    ```

---

## Software Sources

1. Open `Software Sources` and set your Main and Base to the fastest/closest source.
1. Click the `Update the APT cache` button.

---

## System Tweaks

- There's a limit of 15 characters for the `hostname` for `netbios`. You can run `testparm -s` to see if your hostname length is ok (when it's not you'll see `WARNING: The 'netbios name' is too long`).
    ```sh
    hostnamectl set-hostname '<NEW_NAME>'
    ```
- Since Mint 22, they've swapped out the audio driver from `pulseaudio` to `pipewire`. Unfortunately, using `pipewire` causes my audio to quickly flip from speaker to headphones, even when no headphones are plugged in. When I was playing audio it behaved as expected, the rest of the time the speaker icon was constantly blinking. This is how you roll back to `pulseaudio`.
    ```sh
    apt purge pipewire pipewire-bin
    # pulseaudio gets installed automatically during the removal.
    systemctl enable --user pulseaudio
    sudo reboot
    ```
    The above should just work, but in case it doesn't:
    ```sh
    # Verify it's running
    systemctl status --user pulseaudio
    # If it's not running
    systemctl start --user pulseaudio
    
    # Try rebooting again
    ```
- If you want to stick with the default Display Manager (`lightDM`) and you work with monitors hooked up to a closed laptop, you'll want to make these changes. If you don't, anytime the login comes up after a reboot you'll have about 15 seconds before the system suspends, or if you Log Off or Switch User the system suspends immediately.
    ```sh
    sudo mkdir -p /etc/systemd/logind.conf.d
    sudo nano /etc/systemd/logind.conf.d/90-ignore-lid-closed.conf
    ```
    ```
    [Login]
    HandleLidSwitchExternalPower=ignore
    # Dictates how your Linux laptop behaves when the lid is closed while connected
    # to a docking station or external monitor.
    HandleLidSwitchDocked=ignore
    ```
    ```sh
    sudo systemctl restart systemd-logind
    ```

---

## Create Common Directories

```sh
mkdir -v -p ~/{.ssh,Downloads/{archives,debs},Projects/{3D,Code/{Apps,Games,Gists,Scripts},Img,Vid},Software} && chmod 700 ~/.ssh
```

---

## Don't Require Password for Sudo

```sh
echo "${USER} ALL = NOPASSWD: ALL" | (sudo EDITOR='tee -a' visudo)
```

---

## Install Base Software

Note: If you're not able to add extra repositories via `add-apt-repository`, refer to the troubleshooting section below.

```sh
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update && sudo apt install -y apt-transport-https git tilix vim
```

<details>
  <summary>Expand for Software Details</summary>
  
  | Package | Description |
  | ------- | ----------- |
  | [apt-transport-https](https://manpages.ubuntu.com/manpages/bionic/man1/apt-transport-https.1.html) | Allows the use of repositories accessed via the HTTP Secure protocol (HTTPS), also referred to as HTTP over TLS |
  | [git](https://git-scm.com/about) | Version control |
  | [tilix](https://github.com/gnunn1/tilix) | A tiling terminal emulator for Linux using GTK+ 3 |
  | [vim](https://www.vim.org/) | Configurable text editor for CLI |
</details>

<details>
  <summary>Expand for add-apt-repository Troubleshooting</summary>
  
  The repositories may be down. You can check these URLs to see if it's a you or them problem:
  - https://launchpad.net
  - https://status.canonical.com/

  If launchpad appears to be down, you can try connecting via a VPN and see if it's down in other locales. I've had luck connecting through France.
  
  Once launchpad does come back up for you, you can future proof things a bit by either downloading the packages from launchpad or setting up an `apt-mirror`.
  
  ### How to download packages from Launchpad
  
  1. [Open up launchpad](https://launchpad.net/)
  1. Search for the ppa name, in this case we'll use `git-core`. The ppa name pattern is often `A/B` (`git-core/ppa`), when searching, use the `A` part of the name.
  1. There should be a `Personal package archives` section. In that section there'll be a list of links, in this case I chose the `Git stable releases`, but there may be other links available based on the ppa.
  1. Click on the `View package details` link in the `Overview of published packages` section.
  1. There'll be a `Series` column. If you don't know the codename of your OS, run `cat /etc/os-release | grep "UBUNTU_CODENAME"`. Mine is currently `Noble`, so I'll click the top-most package for that row.
  1. It should expand and there should be a list of `Package files` that you can download (`.deb` files). If it specifies an architecture I usually go for the `amd64` version.
  1. I download the files to `~/Downloads/debs/ppa`.

  ### How to set up a local mirror for packages
  
  It's actually quite involved and seems to eat up a lot of space, but [here are instructions](https://www.tecmint.com/setup-local-repositories-in-ubuntu/) on how to do it.
</details>

<details>
  <summary>Expand for Git Settings</summary>
  
  ```sh
  # Only required if you plan to push changes to a repo
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  
  # Create key for github (if you don't already have one)
  ssh-keygen -t ed25519 -C "<IDENTIFYING_COMMENT>" -f ~/.ssh/github
  # print out key so it can be copied
  cat ~/.ssh/github.pub
  ```
  Add new key to https://github.com/settings/keys
</details>

<details>
  <summary>Expand for Tilix Settings</summary>
  
  Open **Preferred Applications** and change Terminal to `Tilix`.
  
  To fix the warning you get when you open Preferences:
  - In your `.bashrc` or `.zshrc` file add
     ```sh
     if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
       source /etc/profile.d/vte.sh
     fi
     ```
  - If `/etc/profile.d/vte.sh` doesn't exist run:
     ```sh
     sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
     ```
  
  Open Tilix **Preferences**
  
  ```
  ┎────────┒
  ┃ Global ┃
  ┖────────┚
    (check) Save and restore window state
    (check) Automatically copy text to clipboard when selecting

  ┎────────────┒
  ┃ Appearance ┃
  ┖────────────┚
    Theme variant: Dark

  ┎──────────────────────┒
  ┃ Shortcuts > Terminal ┃
  ┖──────────────────────┚
    Paste: Ctrl+V
    
  ┎────────────────────────────┒
  ┃ Profiles > Default > Color ┃
  ┖────────────────────────────┚
    (uncheck) Use theme colors for foreground/background
    Unfocused dim: 50%
  ```
</details>

<details>
  <summary>Expand for Vim Settings</summary>
  
  ```sh
  wget https://raw.githubusercontent.com/the0neWhoKnocks/setup.linux/main/distro/mint-cinnamon/files/.vimrc -P ~/
  ```
</details>
<br>

<details>
  <summary>[ Optional ] Expand for DisplayLink Install (for Targus dock)</summary>
  
  There are issues syncing monitors with DisplayLink on Linux especially when using Nvidia drivers.
  
  ```sh
  # Download and install DisplayLink driver
  wget https://cdn.targus.com/web/us/downloads/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu.zip -O ~/Downloads/driver__Targus_USB_DisplayLink.zip
  unzip ~/Downloads/driver__Targus_USB_DisplayLink.zip -d ~/Downloads/Targus/
  # Install deps
  sudo apt install dkms
  # The next step will prompt for a restart, skip it.
  sudo ~/Downloads/Targus/displaylink-driver-*.run
  # Patch udev entry, otherwise the system will freeze during boot
  sudo nano /opt/displaylink/udev.sh
  ```
  ```diff
  # find the `start_service` function around line 104, and change to:
  - systemctl start displaylink-driver
  + systemctl start --no-block displaylink-driver
  
  # save and exit
  ```
  ```sh
  # Clean-up
  rm -rf ~/Downloads/Targus
  # reboot and verify things work
  sudo reboot
  ```
  
  If you want to remove displaylink, run:
  ```sh
  sudo displaylink-installer uninstall
  ```
  
  I ran into an issue where the system would freeze at the boot logo if the dock's USB was plugged in (only after the driver was installed). With the USB unplugged everything was fine. During boot I noticed it was hanging on the `udev` service. I ran `ls -la /etc/udev/rules.d/` and the only rule in there was `99-displaylink.rules` which was executing `/opt/displaylink/udev.sh`. I came across a few posts to fix the freeze during boot:
  - [Post that calls out real fix which calls out `--no-block`](https://support.displaylink.com/forums/287786-displaylink-feature-suggestions/suggestions/41424121-avoid-boot-time-stall-due-to-udev-rules)
  - There was another that said to use `sudo systemctl mask systemd-udev-settle`. It worked, but it didn't target the issue specifically and could have masked other issues.
</details>

---

## Clone This Repo

This is only required if you want to use the helper scripts.

```sh
cd ~/Projects/Code/Scripts && git clone git@github.com:the0neWhoKnocks/setup.linux.git && cd setup.linux/distro/mint-cinnamon

(
  cd ./bin
  ./user-script.sh --install "${PWD}/user-script.sh"
)
```

---

## Set Up Shell

Install oh-my-zsh, plugins, and my custom theme (requires [this step](#clone-this-repo))
```sh
./bin/set-up-zsh.sh
```

<details>
  <summary>Expand for Extra Tilix Settings</summary>
  
  Print out colors to be manually added. Not needed if you have a `dconf` backup.
  ```sh
  cat ~/.oh-my-zsh/custom/themes/zsh-theme-boom/colors.sh
  ```
  
  Open Tilix **Preferences**
  ```
  ┎────────────────────┒
  ┃ Profiles > Default ┃
  ┖────────────────────┚
    ┎─────────┒
    ┃ General ┃
    ┖─────────┚
      (check) Custom font: FantasqueSansM Nerd Font Mono Regular 16

    ┎───────┒
    ┃ Color ┃
    ┖───────┚
      (updated colors to match my zsh theme)
  ```
</details>

---

## Set Up Repos

I have a private gist that contains a shell script with all the `git clone` commands so I don't have to deal with finding all the repo URLs and remembering where everything should be cloned to. 

---

## Set Up Shares

Only required if you need access to a network share.

Instead of allowing a file manager to wrap the connection in a FUSE buffer, we bind the remote share directly to the Linux filesystem. This reduces technical overhead and improves data integrity for high-bitrate media or database migrations.

| Mount Method | Protocol | Persistence	| Latency Profile |
| ------------ | -------- | ----------- | --------------- |
| File Manager (GUI) | gvfs / FUSE | Ephemeral (Session-based) | Medium (High Overhead) |
| Manual Terminal | Kernel CIFS | Temporary (Boot-volatile) | Ultra-Low (Direct) |
| fstab Entry | Kernel CIFS | High (System-wide) | Ultra-Low (Direct) |
| systemd-automount | Kernel CIFS | High (On-Demand) | N/A (Lazy loading) |

First create the folder(s) that the share will mount to:
```sh
# Make the folder(s)
sudo mkdir -p "/mnt/<FOLDER>"
# ex: sudo mkdir -p /mnt/monolith_{lib,user}

# Set permissions
sudo chown <USER>:<GROUP> "/mnt/<FOLDER>"
# ex: sudo chown $UID:$GID /mnt/monolith_{lib,user}
```

Ensure `cifs-utils` is installed:
```sh
dpkg -l | grep cifs-utils
# Install it, if it's not
sudo apt install cifs-utils
```

### Mount Share On Boot

Set up your secured credentials:
```sh
mkdir -p ~/.creds
touch ~/.creds/smb-<NAME>
chmod 600 ~/.creds/smb-<NAME>
nano ~/.creds/smb-<NAME>
```
```
username=<USER>
password=<PASS>
domain=<GROUP>
```

#### Using fstab to Mount Share On Demand

1. First, get your UID and GID by running: `id`.
1. Then, edit the 'fstab' file: `sudo nano /etc/fstab`.
    ```conf
    #
    # NAS Shares
    //<SERVER_IP>/<SHARE_NAME>  /mnt/<PATH>  cifs  credentials=/home/<USER>/.creds/smb-<NAME>,uid=<UID>,gid=<GID>,dir_mode=<DMODE>,file_mode=<FMODE>,iocharset=utf8,vers=3.11,x-systemd.automount,x-systemd.idle-timeout=2  0  0
    ```
    I used `idle-timeout=2` to account for a couple of things. One, when you Suspend the system it won't `umount` any current connections so the SMB session remains on the server. Two, there's no way to create a pre-suspend hook for systemctl to run `umount`, it just hangs the when you try to suspend. Using a timeout of `2` unmounts the share pretty much as soon as you close the last folder that's accessing a share. 
1. Verify the mount config works:
    ```sh
    # After you make changes to 'fstab', you need to reload 'systemctl':
    sudo systemctl daemon-reload
    
    # Mount all 'fstab' entries:
    sudo mount -a
    
    # If you want to alter a mount, unmount it:
    sudo umount -t cifs -l "/mnt/<PATH>"
    ```

Sources:
- https://www.fosslinux.com/92914/how-to-mount-smb-shares-on-linux-mint.htm

<details>
  <summary>Expand for fstab Syntax</summary>
  
  ```
  <DEVICE>  /mnt/<MOUNT_PATH>  <FS_TYPE>  <OPTS>  <DUMP>  <FSCK>
  ```
  
  | Column | Description |
  | ------ | ----------- |
  | <DEVICE> | The block device or remote file system to be mounted. |
  | <MOUNT_PATH> | The directory where the file system will be mounted to, a.k.a. the mountpoint. The directory must be created beforehand. |
  | <FS_TYPE> | The file system type. |
  | <OPTS> | The file system mount options. |
  | <DUMP> | Checked by the `dump` utility. This field is usually set to `0`, which disables the check. |
  | <FSCK> | Sets the order for file system checks at boot time. For the root device it should be `1`. For other partitions it should be `2`, or `0` to disable checking. |
</details>

<details>
  <summary>Expand for fstab Option Descriptions</summary>
  
  - https://man.archlinux.org/man/mount.8#FILESYSTEM-INDEPENDENT_MOUNT_OPTIONS
  - https://man.archlinux.org/man/mount.8#FILESYSTEM-SPECIFIC_MOUNT_OPTIONS
  - https://man.archlinux.org/man/mount.cifs.8.en
  
  
  Adjusting the `rsize` and `wsize` parameters to 1,048,576 bytes (1MB buffers). This allows the network stack to transmit much larger bursts of data per packet, drastically reducing the CPU overhead of the kernel during multi-terabyte dataset migrations.
  The default `rsize` and `wsize` values in the Linux CIFS module are typically 1MB for SMB 3.x connections, but older kernels or server configurations may negotiate lower values. Explicitly setting them to 1,048,576 ensures you always get maximum buffer sizes regardless of what the server advertises. On a gigabit link, I consistently see 110-115 MB/s with these settings versus 80-90 MB/s with default negotiation.
  
  
  | Option | Description |
  | ------ | ----------- |
  | `credentials` | This option specifies the location of the credential file we created earlier. because it is inside your encrypted home folder, nobody else can mount this. their attempt will fail with an error of not having permission to open the credentials file. |
  | `dir_mode` | If the server does not support the CIFS Unix extensions this overrides the default mode for directories. |
  | `file_mode` | If the server does not support the CIFS Unix extensions this overrides the default file mode. |
  | `gid` | Sets the gid that will own all files or directories on the mounted filesystem when the server does not provide ownership information. |
  | `iocharset` | Charset used to convert local path names to and from Unicode. |
  | `uid` | Sets the uid that will own all files or directories on the mounted filesystem when the server does not provide ownership information. |
  | `vers` | The `vers=3.11` flag is an essential security requirement in 2026. It ensures you are utilizing the most secure SMB dialect available, preventing downgrade attacks to legacy, unencrypted protocols that could expose your data on the local network. |
  | `x-systemd.automount` | Mount the partition only when it is first accessed, and the kernel will buffer all file access to it until it is ready. |
  | `x-systemd.idle-timeout` | Make systemd unmount the mount after it has been idle for X second(s). |
</details>

### Mount Share On-Demand

Like for a laptop that may not always be on your network. (requires [this step](#clone-this-repo))
```sh
(
  cd ./bin
  user-script --install "${PWD}/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
)
```
- Run the new Launcher that was added to the Desktop
  - Configure the settings for the share.
    - The mounted folder needs to be in `/mnt`, or it won't be automatically detected.

---

## Install Software

Here are some sources for finding alternatives to software you may have used on other OS's:
- https://alternativeto.net/platform/linux/
- https://www.linuxalt.com/

### Via Software Manager or CLI

```sh
(
  sudo apt-add-repository -y ppa:lucioc/sayonara
  sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
  sudo apt update
  sudo apt install -y \
    aegisub \
    bat \
    cheese \
    dconf-editor \
    featherpad \
    flameshot \
    git-gui \
    gparted \
    grsync \
    guvcview \
    inkscape \
    libnss3-tools \
    lolcat \
    meld \
    mkvtoolnix-gui \
    okular \
    p7zip-full \
    pavucontrol \
    peek \
    python-is-python3 \
    redshift redshift-gtk \
    remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-vnc \
    sayonara \
    simplescreenrecorder simplescreenrecorder-lib \
    solaar \
    soundconverter \
    sqlitebrowser \
    xclip \
    xserver-xorg-input-synaptics
)
```
These require a User to answer prompts
```sh
sudo apt install \
  ttf-mscorefonts-installer \
  wireshark
```

Optional
```sh
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
sudo apt install -y \
  figlet \
  grub-customizer \
  kid3-qt \
  obs-studio \
  plasma-sdk \
  python3-notify2 \
  sddm sddm-theme-breeze \
  steam \
  sticky
```

<details>
  <summary>Expand for Software Details</summary>
  
  PPA's can be found a couple of ways:
  1. https://launchpad.net/ubuntu/+ppas
  1. Or go to https://launchpad.net/PACKAGE_NAME, like https://launchpad.net/grub-customizer.
     - Click on the Maintainer's link
     - See if there's a **Personal package archives** section. If there is look for your package and click on the link.
     - I then look through the dates for the **Overview of published packages** section, to see if it's an up-to-date package and being maintained.
  
  | Package | Description |
  | ------- | ----------- |
  | [aegisub](https://aeg-dev.github.io/AegiSite/) | Subtitle editor |
  | [cheese](https://wiki.gnome.org/Apps/Cheese) | Allows you to take photos and videos with your webcam. |
  | [dconf-editor](https://apps.gnome.org/app/ca.desrt.dconf-editor/) | Tool to allow direct editing of the dconf configuration database. Sometimes allows for changing low-level settings not exposed in most GUIs. |
  | [featherpad](https://github.com/tsujan/featherpad) | Simple text editor. Nice and snappy on remote hosts. |
  | [flameshot](https://flameshot.org/) | Swiss army knife of screenshot tools |
  | [git-gui](https://git-scm.com/docs/git-gui/) | Handy when wanting to do per-line commit-staging |
  | [gparted](https://gparted.org/) | Disk partitioning |
  | [grsync](https://community.linuxmint.com/software/view/grsync) | A simple GUI for the `rsync` |
  | [guvcview](https://community.linuxmint.com/software/view/guvcview) | Capture images or video with webcam. (It's the only thing I've found that gives the option to mirror video) |
  | [inkscape](https://inkscape.org/) | Tool to create vector images (Adobe Illustrator alternative) |
  | [libnss3-tools](https://packages.ubuntu.com/focal/libnss3-tools) | Network Security Service tools (installs `certutil` which I use to install certs for Browsers) |
  | [lolcat](https://github.com/busyloop/lolcat) | Add rainbow colors to text in CLI |
  | [meld](https://meldmerge.org/) | Visual fill diff tool |
  | [mkvtoolnix-gui](https://www.matroska.org/downloads/mkvtoolnix.html) | A set of tools to create, alter and inspect Matroska (mkv) & WebM files |
  | [okular](https://okular.kde.org/) | Universal document viewer (PDFs, etc.) |
  | [p7zip-full](https://p7zip.sourceforge.net/) | Adds 7zip binaries for CLI |
  | [pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/) | PulseAudio Volume Control |
  | `python-is-python3` | This ensures the symlink for `python3` to `python` stays up to date during updates. |
  | [redshift](https://remmina.org/) | Adjusts the color temperature of your screen. |
  | [remmina](https://remmina.org/) | Remote Desktop client |
  | [sayonara](https://sayonara-player.com/) | Music player |
  | [simplescreenrecorder](https://www.maartenbaert.be/simplescreenrecorder/ ) | A simple screen recorder. Peek is depricated, so using this. |
  | [solaar](https://pwr-solaar.github.io/Solaar/) | Logitech unifying reciever peripherals manager for Linux |
  | [soundconverter](https://soundconverter.org/) | Converter for audio files |
  | [sqlitebrowser](https://sqlitebrowser.org/) | GUI to browse/edit SQL database files |
  | [ttf-mscorefonts-installer](https://linuxhint.com/ttf-mscorefonts-installer/) | Installer for Microsoft TrueType core fonts. Needed to display fonts properly in browsers |
  | [wireshark](https://www.wireshark.org/) (meta-package) | Network traffic sniffer |
  | [xclip](https://github.com/astrand/xclip) | Copy from CLI to clipboard |
  | [xserver-xorg-input-synaptics](https://packages.ubuntu.com/bionic/xserver-xorg-input-synaptics) | Enables smooth/inertial/kinetic scroll for touchpads on long documents/webpages (requires reboot) |
  
  | Package | Description |
  | ------- | ----------- |
  | [figlet](http://www.figlet.org/) | Generate text banners for CLI |
  | [grub-customizer](https://launchpad.net/grub-customizer) | Easily change and compile grub config |
  | [kid3-qt](https://kid3.kde.org/) | Audio tag editor (TagScanner alternative) |
  | [obs-studio](https://obsproject.com/) (non-flatpak) | Record or stream video |
  | [plasma-sdk](https://github.com/KDE/plasma-sdk) | Applications useful for Plasma development. I use it for Cuttlefish (an icon viewer) |
  | [python3-notify2](https://pypi.org/project/notify2/) | Send Desktop notifications via Python |
  | [sddm](https://github.com/sddm/sddm) | A modern display manager for X11 and Wayland. ( Alternate DM than the default lightdm) |
  | [sddm-theme-breeze](https://packages.debian.org/sid/sddm-theme-breeze) | Clean centered theme with avatar |
  | [Steam](https://store.steampowered.com/) | PC Gaming platform |
  | [sticky](https://github.com/linuxmint/sticky) | Post-it note app for your Desktop |
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  Webcam apps may require a system reboot for them to work correctly.
</details>

<details>
  <summary>Expand for Aegisub</summary>
  
  This isn't something I keep on all the time, but sometimes when editing subs this is handy for creating line breaks.
  - Open the system Keyboard > Layouts > Options > Non-breaking space input (set to Non-breaking space at the 2nd level), now you can hit SHIFT+SPACE to insert a non-breaking space.
</details>

<details>
  <summary>Expand for git-gui</summary>
  
  Create a shortcut:
  ```sh
  sudo nano /usr/share/applications/git-gui.desktop
  ```
  ```
  [Desktop Entry]
  Name=Git GUI
  Exec=git gui
  Icon=gitg
  Type=Application
  Categories=Utility;
  Comment=Launch the Git Graphical User Interface
  ```
</details>

<details>
  <summary>Expand for Steam settings</summary>
  
  1. Open Steam.
  1. Settings > Interface.
  1. On the "Interface" tab, find `Client Beta Participation`. There should be a dropdown menu with `no beta chosen` as the default option.
  1. Select the dropdown menu and select the `Steam Beta Update` option.
  1. Restart Steam.
  1. Settings > Compatibility.
      ```
      [X] Enable Steam Play for supported titles
      [X] Enable Steam Play for all other titles
      Run other titles with: Proton Experimental
      ```
</details>


### Via Flatpak

```sh
flatpak install flathub --system --noninteractive -y \
  codes.merritt.FeelingFinder \
  com.discordapp.Discord \
  com.rafaelmardojai.Blanket \
  fr.handbrake.ghb \
  hu.irl.cameractrls \
  org.gabmus.hydrapaper \
  org.gimp.GIMP \
  org.gimp.GIMP.Plugin.GMic/x86_64/3 \
  org.gimp.GIMP.Plugin.LiquidRescale/x86_64/2-40 \
  org.gimp.GIMP.Plugin.Resynthesizer/x86_64/3 \
  org.kde.glaxnimate \
  org.kde.iconexplorer \
  org.kde.kdenlive \
  org.localsend.localsend_app \
  org.videolan.VLC \
  rs.ruffle.Ruffle

(
  cd ~/Downloads/flatpak
  flatpak install --user \
    SubtitleEdit-linux-x64_v5.0.0-rc4.flatpak
)
```

<details>
  <summary>Expand for Software Details</summary>
  
  Useful commands:
  | Command | Description |
  | ------- | ----------- |
  | `flatpak info --show-location <APP_ID>` |  |
  | `flatpak list` | List what's installed along with info like `Application ID` and `Version`. Add `--app` or `--runtime` for grouped listings. |
  | `flatpak run <APP_ID>` | Start app from CLI (good for debugging). |
  | `flatpak search <APP_ID>` | Search for packages like `flatpak search org.gimp.GIMP.Plugin`. |
  | `flatpak uninstall --delete-data <APP_ID>` | Remove installed package. |
  | `flatpak update <APP_ID>` | Update package like `flatpak update org.gimp.GIMP`. |
  
  `bin` path for apps: `/var/lib/flatpak/exports/bin`.
  
  | Package | Software | Description |
  | ------- | -------- | ----------- |
  | [codes.merritt.FeelingFinder](https://flathub.org/apps/details/it.mijorus.smile) | Feeling Finder | Emoji picker |
  | [com.discordapp.Discord](https://discord.com/) | Blanket | Group text/voice/video communication |
  | [com.rafaelmardojai.Blanket](https://flathub.org/en/apps/com.rafaelmardojai.Blanket) | Blanket | plays a mix of ambient sounds |
  | [fr.handbrake.ghb ](https://handbrake.fr/) | Handbrake | Tool for converting video from nearly any format to a selection of modern, widely supported codecs |
  | [hu.irl.cameractrls](https://flathub.org/apps/details/hu.irl.cameractrls) | Camera Ctrls | Logi Tune alt for adjusting settings in Web apps |
  | [org.gabmus.hydrapaper](https://hydrapaper.gabmus.org/) | HydraPaper | Allows for different images on multiple monitors |
  | [org.gimp.GIMP](https://flathub.org/apps/details/org.gimp.GIMP) | GIMP | Image editor (alternative to Adobe Photoshop) |
  | [org.gimp.GIMP.Plugin.GMic](https://gmic.eu/download.html) | G'MIC | A large set of filters |
  | [org.gimp.GIMP.Plugin.Resynthesizer](https://github.com/bootchk/resynthesizer) | Resynthesizer | Content-aware removal of selected items |
  | [org.kde.glaxnimate](https://glaxnimate.mattbas.org/) | Glaxnimate | A simple and fast vector graphics animation program (alternative to Adobe Animate/Flash). |
  | [org.kde.iconexplorer](https://develop.kde.org/docs/features/additional-features/icons/) | Icon Explorer (Cuttlefish) | Simple GUI to look up icon names. |
  | [org.kde.kdenlive](https://kdenlive.org/features/) | Kdenlive | Video editor |
  | [org.localsend.localsend_app](https://localsend.org/) | LocalSend | Cross-platform file sharing |
  | [org.videolan.VLC](https://www.videolan.org/vlc/) | VLC | Multimedia player |
  | [rs.ruffle.Ruffle](https://flathub.org/en/apps/rs.ruffle.Ruffle) | Ruffle | Plays old Flash games & movies |
  | [SubtitleEdit](https://www.nikse.dk/subtitleedit) | Subtitle editing toolbox. |
</details>

<details>
  <summary>Expand for Discord Tweaks</summary>
  
  To make Discord not prompt for updates all the time
  ```sh
  nano ~/.var/app/com.discordapp.Discord/config/discord/settings.json
  
  # add:
  "SKIP_HOST_UPDATE": true
  ```
</details>

<details>
  <summary>Expand for FeelingFinder Tweaks</summary>
  
  Dunno how they came up with that name, but it doesn't cut it when searching in an App launcher.
  ```sh
  sudo nano /var/lib/flatpak/exports/share/applications/codes.merritt.FeelingFinder.desktop
  ```
  ```diff
  - Name=Feeling Finder
  + Name=Emoji Picker (Feeling Finder)
  + Keywords=Emoji;Picker;
  ```
</details>

<details>
  <summary>Expand for GIMP plugin notes</summary>
  
  | Plugin | Notes |
  | ------ | ----- |
  | G'MIC | Shows up at the bottom of the `Filters` menu as `G'MIC-QT...` |
  | Resynthesizer | Shows up under `Filters > Enhance` with items for `Heal Selection` and `Heal Transparency`. |
  
  Since G'MIC has a ton of options, I'll try to keep track of what I've found useful:
      - Deformations:
          - Seamcarve: Replacement for the `LiquidRescale` plugin since it doesn't seem to run on Linux.
      - Lights & Shadow:
          - Drop Shadow: Found this easier to use than the default filter.
</details>

<details>
  <summary>Expand for Handbrake notes</summary>
  
  Settings:
  ```
  [ General ]
  
    Number of previews: 30
  
  [ Advanced ]
  
    [x] Set a custom directory for Handbrake temporary files: ~/Rips/.hb_tmp
  ```
  
  Presets:
  - Select a category, right-click, choose `Set Default`.
  - Select a sub-item in that category, right-click, choose `Set Default`.
  
  Notes:
  - Config files are stored in: `~/.var/app/fr.handbrake.ghb/config/ghb`
  - If you need the most up-to-date version you may have to install via a custom PPA, this worked for me in the past.
      ```sh
      sudo add-apt-repository -y ppa:ubuntuhandbook1/handbrake
      sudo apt update
      sudo apt install -y handbrake
      ```
</details>

<details>
  <summary>Expand for Kdenlive Settings</summary>
  
  ```
  CTRL + SHIFT + ,
  
  [ Environment ]
    
    [ Default Apps ]
      Image editing: /var/lib/flatpak/app/org.gimp.GIMP/current/active/export/bin/org.gimp.GIMP
      Audio editing: /usr/bin/audacity
      Animation editing: /usr/bin/glaxnimate
  ```
</details>

<details>
  <summary>Expand for VLC</summary>
  
  I'm using the flatpak because there were issues with the `apt install` utilizing the NVidia GPU for hardware accelerated playback. Once I switched to the flatpak AV1 videos played (with hardware acceleration), and there were no errors in the CLI (if VLC was started via CLI).
  
  Note: I would prefer to use a custom skin, but all the skins have their tops hidden when the window is maximized.
  
  Customize Interface:
  ```
  Expanding Spacer
  [FB] Extended Panel
  [FB] Snapshot
  [FB] Information
  [FB] Playlist
  [FB] Fullscreen
  Spacer
  [FB] Previous
  [FB][BB] Play
  [FB] Next
  Spacer
  [FB] Loop / Repeat
  [FB] Random
  Expanding Spacer
  Volume
  ```
  
  Preferences:
  ```
  ┎───────────┒
  ┃ Interface ┃
  ┖───────────┚
    [ ] Use only one instance when started from file manager

  ┎───────┒
  ┃ Video ┃
  ┖───────┚
    Video snapshots
      Directory: ~/Pictures/vlc
  ```
</details>


### Via deb

```sh
(
  DEBS_DIR=~/Downloads/debs
  urls=(
    'https://github.com/sharkdp/bat/releases/download/v0.26.1/bat_0.26.1_amd64.deb'
    'https://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_143.0.7499.40-1_amd64.deb'
    'https://github.com/jgraph/drawio-desktop/releases/download/v25.0.2/drawio-amd64-25.0.2.deb'
    'https://packagecloud.io/github/git-lfs/packages/linuxmint/wilma/git-lfs_3.7.1_amd64.deb/download.deb?distro_version_id=294'
    'https://github.com/Kong/insomnia/releases/download/core%4012.6.0/Insomnia.Core-12.6.0.deb'
    'https://github.com/lsd-rs/lsd/releases/download/v1.2.0/lsd_1.2.0_amd64.deb'
    'https://github.com/subhra74/snowflake/releases/download/v1.0.4/snowflake-1.0.4-setup-amd64.deb'
    'https://update.code.visualstudio.com/1.124.0/linux-deb-x64/stable'
    'https://updates.torguard.biz/Software/Linux/torguard-latest-amd64.deb'
  )
  for url in "${urls[@]}"; do
    wget --content-disposition "${url}" -P "${DEBS_DIR}/"
  done
  
  sudo dpkg -i "${DEBS_DIR}/"*.deb
  sudo apt install -f -y
)
```

<details>
  <summary>Expand for Software Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [bat](https://github.com/sharkdp/bat) | Like `cat`, but displays a limited amount of a file and with syntax highlighting |
  | [Chrome](https://www.google.com/chrome/) | Browser |
  | [chromium](https://www.chromium.org/getting-involved/download-chromium/) | Browser without all the Chrome overhead |
  | [Draw.io](https://app.diagrams.net/) | [Desktop version](https://github.com/jgraph/drawio-desktop/) of the [Web-App](https://app.diagrams.net/) to draw flowcharts and diagrams. |
  | [git lfs](https://git-lfs.com/) | Allows for storing large files outside of git repos. |
  | [Insomnia](https://insomnia.rest/) | API development |
  | [lsd](https://github.com/Peltoche/lsd) | A Deluxe version of the `ls` command |
  | [Muon (Snowflake)](https://github.com/subhra74/snowflake) | SFTP Client (alternative to WinSCP) |
  | [TorGuard](https://torguard.net/downloads.php) | VPN client |
  | [VS Code](https://code.visualstudio.com/) | IDE, advanced text editor |
</details>

<details>
  <summary>Expand for Chrome Tweaks</summary>
  
  I'm sticking with a locked version for the time being so that I can keep using my extensions. If I want to go back to installing the newest, I'd need to switch to https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb.
  You can specify a versioned download by following this pattern: `https://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_<VERSION>-1_amd64.deb`. Also found this repo which seems to maintain old versions: https://github.com/NDViet/google-chrome-stable/releases.
  
  To stop making it prompt for updates:
  - Update all shortcuts and add
    ```sh
    --simulate-outdated-no-au="Tue, 31 Dec 2099 23:59:59 GMT"
    ```
    There may be a shortcut on your desktop and in `/usr/share/applications/google-chrome.desktop`.
    
    Search for `Exec` and add the argument to every instance. For the one that ends in `%U`, put it before `%U`.
</details>

<details>
  <summary>git lfs</summary>
  
  - Go to https://git-lfs.com/
      - You can install via PackageCloud which is a one-liner.
      - Or you can click on the "Installation" link, then the "Linux installation instructions" link, then the [small "packages" link](https://packagecloud.io/github/git-lfs). Then find the line that has something like `linuxmint/wilma` (`wilma` is the current major codename for Mint 22), click on that link. There should be a tiny `Download` button at the top right to [get the `.deb` file](https://packagecloud.io/github/git-lfs/packages/linuxmint/wilma/git-lfs_3.7.1_amd64.deb/download.deb?distro_version_id=294).
  - Run the installer.
  - Run `git lfs install` to initialize.
</details>

<details>
  <summary>Expand for TorGuard Tweaks</summary>
  
  For now, TorGuard requires Wireguard so install via: `sudo apt install wireguard`.
</details>


### Via Archives

```sh
(
  ARCH_DIR=~/Downloads/archives
  urls=(
    'https://github.com/aristocratos/btop/releases/download/v1.4.7/btop-x86_64-unknown-linux-musl.tar.gz'
    'https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip'
    'https://github.com/godotengine/godot/releases/download/4.0-stable/Godot_v4.0-stable_linux.x86_64.zip'
    'https://www.blender.org/download/release/Blender3.4/blender-3.4.1-linux-x64.tar.xz/'
    'https://github.com/timminator/VideOCR/releases/download/v1.2.1/VideOCR-GPU-v1.2.1-Linux.tar.xz'
  )
  for url in "${urls[@]}"; do
    wget --no-clobber "${url}" -P "${ARCH_DIR}/"
    file="$(basename "${url}")"
    version="$(basename $(dirname "${url}"))"
    pkg="$(echo "${file}" | awk -F '[-_]' -v name=1 '{print $name}')"
    outputPath="${HOME}/.local/bin/${pkg}/${version}/"
    mkdir -p "${outputPath}"
    
    if [[ "${file}" == *.zip ]]; then
      unzip "${ARCH_DIR}/${file}" -d "${outputPath}"
    else
      tar --strip 1 --extract --file "${ARCH_DIR}/${file}" --directory="${outputPath}"
    fi
  done
)
```

<details>
  <summary>Expand for Software Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [Blender](https://www.blender.org) | 3D asset creation |
  | [btop](https://github.com/aristocratos/btop) | Resource monitor that shows usage and stats for processor, memory, disks, network and processes |
  | [godot](https://godotengine.org/) | Game engine |
  | [jmkvpropedit](https://github.com/BrunoReX/jmkvpropedit) | A batch GUI for mkvpropedit. Allows for editing headers of multiple mkv files |
  | [VideoOCR](https://github.com/timminator/VideOCR) | Rips hard-coded subs from video. |
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  Have to run the install script for btop from within the directory
  ```sh
  (
    cd ~/.local/bin/btop/v1.4.7/
    ./install.sh
  )
  ```
  
  Has to be executable to run
  ```sh
  chmod +x ~/.local/bin/jmkvpropedit/v1.5.2/JMkvpropedit.jar
  
  # create a launcher
  user-script --install "${HOME}/.local/bin/jmkvpropedit/v1.5.2/JMkvpropedit.jar" "JMKVPropEdit" "Batch edit metadata for MKV files" "mkv-gui" "" "java -jar "
  ```
  
  ```sh
  cp files/godot/godot.desktop ~/.local/share/applications/
  chmod +x ~/.local/share/applications/godot.desktop
  cp files/godot/godot.svg ~/.icons/
  ```
  
  ```sh
  # may have to update the version path for `Exec=` in `.desktop`
  cp files/blender/blender.desktop ~/.local/share/applications/
  chmod +x ~/.local/share/applications/blender.desktop
  cp files/blender/blender.svg ~/.icons/
  ```
  
  ```sh
  mv ~/.local/bin/VideOCR-GPU-v1.2.1 ~/.local/lib/
  # Creates app shortcut
  ~/.local/lib/VideOCR-GPU-v1.2.1/install_videocr.sh
  # There's also an `uninstall_` script
  ```
</details>


### Via CLI (slightly complex)

For packages that require more than a simple `apt install`.

| Software | Description |
| -------- | ----------- |
| [Albert](https://albertlauncher.github.io/installation/linux/) | Launcher (alternative to Wox). |
| [docker](https://www.docker.com/why-docker/) | Containerize environments |
| [docker-compose](https://docs.docker.com/compose/) | Create config files for Docker containers |
| [FreeFileSync](https://freefilesync.org/) | A tool to wire up backups. Those backup configs can then be reversed to restore data. |
| [n](https://github.com/tj/n#third-party-installers) | NodeJS version management |
| [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) | Configure containers to leverage NVIDIA GPUs |
| [qemu](https://www.qemu.org/) | A machine emulator and virtualizer |


<details>
  <summary>Albert</summary>
  
  In the Installing page look for the `OBS software repo` link for downloads. This page also calls out what Ubuntu version corresponds with the Mint version.
  
  ```sh
  echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
  curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
  sudo apt update
  sudo apt install albert
  ```
  
  Settings:
  ```
  [ General ]
    Additional PATH entries: ~/.local/share/flatpak/exports/share/applications
    [ ] Telemetry
  
  [ Window ]
    [x] Enable history search
    [ ] Clear input line on hide
    [x] Always on top
    [x] Hide on focus out
    [x] Show centered
    Light theme : Nord Dark
    Dark theme  : Nord Dark
    [x] Display scrollbar
    
  [ Plugins ]
    [x] Applications
      [x] Ignore 'OnlyShowIn'/'NotShowIn'
      [x] Use 'Exec'
      [x] Use 'Keywords'
      [x] Use 'GenericName'
      Terminal: Tilix
    
    [x] Web Search
      [x] DuckDuckGo
      [x] Google
      [x] YouTube
  ```
</details>


<details>
  <summary>Docker</summary>
  
  ```sh
  (
    sudo apt install ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(cat /etc/os-release | grep "UBUNTU_CODENAME" | sed "s|UBUNTU_CODENAME=||") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
  )
  ```
  
  Move Docker's data folder (I create the `extra_data` mount later in this doc)
  ```sh
  sudo mkdir -p /mnt/extra_data/docker-data/containerd
  sudo docker stop $(docker ps -q) 2>/dev/null
  sudo systemctl stop docker docker.socket containerd
  sudo nano /etc/docker/daemon.json
  ```
  ```json
  {
    "data-root": "/mnt/extra_data/docker-data",
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "10m",
      "max-file": "3"
    }
  }
  ```
  ```sh
  sudo nano /etc/containerd/config.toml
  ```
  ```diff
  - #root = "/var/lib/containerd"
  + root = "/mnt/extra_data/docker-data/containerd"
  ```
  ```sh
  sudo systemctl daemon-reload
  sudo systemctl start docker
  ```
  
  Verify install
  ```sh
  systemctl is-enabled docker
  systemctl status docker
  sudo docker run hello-world
  sudo docker info | grep "Docker Root Dir"
  ```
  
  Notes:<br/>
  The [instructions for setting up the repo](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) are Ubuntu specific and call out `lsb_release -cs` which doesn't work on Mint. I created an alternative
  ```sh
  cat /etc/os-release | grep "UBUNTU_CODENAME" | sed "s|UBUNTU_CODENAME=||"
  ```
  I verified it was the correct name by going to https://download.docker.com/linux/ubuntu/dists/ to see the available names, and checking the Ubuntu releases https://wiki.ubuntu.com/Releases.
  
  [Docker Desktop](https://docs.docker.com/desktop/install/ubuntu/) now exists for Linux, but I've had issues with it:
  - Not being up-to-date
  - Trying to sell me something
  
  `docker-compose` has [been replaced](https://docs.docker.com/compose/compose-v2/) with `docker compose`. The new [compose spec](https://github.com/compose-spec/compose-spec/blob/master/spec.md) is more universal but it also deprecates some fields.
</details>

<details>
  <summary>FreeFileSync</summary>
  
  ```sh
  (
    cd "${HOME}/Downloads/archives"
    ver="14.9"
    tarFileName="FreeFileSync_${ver}_Linux_x86_64.tar.gz"
    runFileName="FreeFileSync_${ver}_Install.run"
    
    if [ -f "$tarFileName" ]; then rm "$tarFileName"; fi
    if [ -f "$runFileName" ]; then rm "$runFileName"; fi
    
    curl -L -O "https://freefilesync.org/download/${tarFileName}"
    tar zxvf "$tarFileName"
    chmod +x "$runFileName"
    
    "./$runFileName"
    
    rm "$runFileName"
  )
  ```
  
  Edit the `FreeFileSync.desktop` file that was created on the Desktop.
  ```diff
  - Exec="/opt/FreeFileSync/FreeFileSync" %F
  + Exec=sudo bash -c "export FFS_USER=<USER>; export FFS_HOME=/home/$FFS_USER; dconf dump / > ~/settings.dconf; /opt/FreeFileSync/FreeFileSync %F"
  ```
</details>

<details>
  <summary>Kodi</summary>
  
  Since I'm running Kodi on different devices and they're all pointing to a central database, I have to be careful when updating to ensure the DB doesn't get updated to something the other devices can't support. This process allows me to install a specific version of a back up.
  
  1. If you already have installed and created a flatpak of the version you want:
      ```sh
      (
        cd ~/Downloads/flatpak
        flatpak install --user kodi_v21.3.flatpak
      )
      ```
  1. This is the initial install. If the version matches what you're running, you won't have to install from the backup.
      ```sh
      # When installing for a User, the remote may not be available yet, so add it.
      flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      
      # Get the App id
      flatpak search kodi
      
      # Get the current commit in case a rollback is required
      flatpak remote-info --log flathub tv.kodi.Kodi
      # May be prompted to choose 'user'
      # Current commit for 21.3-Omega: 666823fee558df5f489af34509c379f9c5b1dfe00486a3e70e1aaed1fd90b453
      # Previous commit for 21.2-Omega: ca13415f2ed0762488b7a22ebce80c88bff6e24166a7511d19c60fa6796c5027
      
      # Install (For current User. Remove '--user' for system install).
      flatpak install --user flathub tv.kodi.Kodi
      # Lock the app so it requires manual updates.
      flatpak mask --user tv.kodi.Kodi && flatpak mask --user
      
      # User config data
      ~/.var/app/tv.kodi.Kodi/data/userdata/
      # IMPORTANT: If this folder already exists, rename it to `userdata.bak` before you start the App for the first time. Once you've verified the App version, then you can copy your settings over (or delete the current `userdata` and replace it with your backup).
      
      # Start the App
      flatpak run tv.kodi.Kodi
      ```
      Toggle Fullscreen/Windowed mode with `\`.
  1. In Kodi, go into `System Settings` (the cog icon), then `System Information > Summary`. At the bottom under `Version Info`, check the `Build`.
  1. Create a backup
      ```sh
      # Only needs to happen once:
      # The User remote has to have an id assigned.
      flatpak remote-modify --collection-id=org.flathub.Stable flathub
      
      # Get list of current runtimes (some Apps may use different ones), you will need the number listed for Branch
      flatpak list --runtime | grep "Freedesktop Platform"
      # Current branch is: 24.08
      
      # Determine runtime for App
      flatpak list --app --app-runtime org.freedesktop.Platform//<BRANCH>
      
      # Platform required for the backup util
      flatpak install --user flathub org.freedesktop.Platform/x86_64/<BRANCH>
      
      # Create a repo backup
      flatpak create-usb --user ~/Downloads/flatpak/ tv.kodi.Kodi
      
      # Build a flatpak - <REPO> <OUTPUT> <ID> <BRANCH>
      flatpak build-bundle ~/Downloads/flatpak/.ostree/repo ~/Downloads/flatpak/kodi_v21.3.flatpak tv.kodi.Kodi stable
      ```
</details>

<details>
  <summary>'n' NodeJS version manager</summary>
  
  May want to [verify this hasn't changed in the repo](https://github.com/tj/n#third-party-installers).
  ```sh
  curl -L https://bit.ly/n-install | bash
  ```
  The script will add an `export` line to your `.bashrc`. If you use another shell, copy that line to your `*rc` file and source your shell. Once that's done, you can choose and install the version of NodeJS that you want.
  ```sh
  # list available versions to download
  n ls-remote
  # install your preferred version
  n install 24.8.0
  # Check version
  node -v
  ```
</details>

<details>
  <summary>nvidia-container-toolkit</summary>
  
  ```sh
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

  sudo apt-get update

  export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.0-1
  sudo apt-get install -y \
  nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker
  ```
</details>

<details>
  <summary>Qemu / Virt Manager (Virtual Machine Manager)</summary>
  
  ```sh
  (
    sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
    sudo adduser $USER libvirt && sudo adduser $USER kvm && sudo adduser $USER libvirt-qemu
  )
  ```
  You'll have to log out/in for it to work with your current user, but you can test with
  ```sh
  sudo virt-manager
  ```
  
  Creating a Windows VM:
  - Create folders for VMs: `mkdir -p ~/VMs/pool`.
  - Download the drivers `.iso` so virtio can communicate with Windows. [This page](https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers) had a good overview of the drivers. That page led me to [a github page](https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md) with links to possible downloads. From there I found an [archive page with all the downloads](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/). There's also a section with a link to the [latest stable version](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/) (`stable-virtio`), which changes with each release.
  - Download the Windows `.iso` [from here](https://www.microsoft.com/en-us/software-download/windows11).
  - Open Virt Manager
  - Click `Create a new virtual machine`
      ```
      [ Step 1 ]
        [x] Local install media (ISO image or CDROM)
      
      [ Step 2 ]
        Choose ISO:
          - Click Browse
          - Click 'Browse Local' and pick the Windows .iso file
      
      [ Step 3 ]
        Memory: 16384
        CPU: 4
      
      [ Step 4 ]
        [x] Select or create custom storage, click 'Manage'
          - Click the 'VMs' pool in the left column (should be auto-created after selecting the .iso in Step 1)
          - Select the 'default' pool and click 'Stop Pool' (just doing this to prevent myself from creating stuff in there).
          - Click 'Create new volume'
            Name: Win11_<VERSION>  (current version is 25H2)
            Format: qcow2
            Capacity: 80.0 GiB  (Minimum disk space required to install Windows 11 is 64GiB, so assign 80GiB)
          - Select the new volume in the list, click 'Choose Volume'.
      
      [ Step 5 ]
        Name: Win11_<VERSION>
        [x] Customize configuration before install
      ```
  - If prompted with `Virtual Network is not active`, select `Yes` to activate.
  - Configuration
      ```
      [ Overview ]
        Chipset: Q35    (The Q35 chipset natively supports PCIe and provides improved PCI-E pass-through support)
        Firmware: UEFI  (Enables Secure Boot, which is required for Windows 11. When using the UEFI firmware, you can take internal snapshots while the guest is shut down but not while it is running.)
      
      [ CPUs ]
        [x] Copy host CPU configuration (host-passthrough)
      
      [ SATA Disk 1 ]
        Disk bus: VirtIO  (VirtIO is preferred as it is specifically designed for virtualization.)
        [ Advanced Options ]
          Cache mode: none     (Equivalent to direct disk access on your host. If you have an encrypted filesystem, you may get an error like "filesystem does not support O_DIRECT" when installing. In that case, change from "none" to "writeback".)
          Discard mode: unmap  (The qcow2 disk image will automatically shrink to reflect any newly freed space, such as from deleted files.)
      
      (Click 'Add Hardware' at bottom)
        - Storage
          [x] Select or create custom storage
          Manage:
            - Click the 'VMs' pool in the left column
            - Select the 'virtio-win-<VERSION>.iso'
          Device type: CDROM device
      
      [ NIC ]
        Network source: Virtual network 'default' : NAT
        Device model: virtio  (No processing overhead, and the performance of the guest virtual machine will naturally improve.)
      
      [ TPM vNone ]
        Type: Emulated
        Model: CRB
        Version: 2.0  (TPM is designed to provide hardware-based security-related functions, and Windows 11 requires TPM version 2.0.)
      ```
  - Click 'Begin Installation' (at the top left of the Configuration window). When it says "Push any key to boot from cd-rom" do that, otherwise you'll get stuck in a Bios and have to force quit.
      ```
      - Click "I don't have a product key"
      - Windows Pro N
      - Select location to install Windows 11
        - Load Driver > Browse > pick the virtio CD > viostor/w11/amd64
        - Select the driver that showed in the list.
        - Install
        - Load Driver > Browse > pick the virtio CD > NetKVM/w11/amd64
        - Select the driver that showed in the list.
        - Install
        - Select the disk that should now be in the list.
      - When you hit the country selection screen.
        - Press Shift + F10 to open a command prompt
          ---
          reg add HKLM\Software\Microsoft\Windows\CurrentVersion\OOBE /v HideOnlineAccountScreens /t REG_DWORD /d 1 /f
          ---
          Gets around having to use a Microsoft Account later in the setup.
      - Enter your Username and Password
      - For your security questions choose anything, and set 'na' for the answer.
      ```
</details>

<br/>

**Optional**

| Software | Description |
| -------- | ----------- |
| [lutris](https://lutris.net/) | Allows for playing games on Linux. Use to install [Origin](https://lutris.net/games/origin/) |

<details>
  <summary>Lutris</summary>
  
  ```sh
  (
    sudo add-apt-repository -y ppa:lutris-team/lutris
    sudo apt update
    sudo apt install lutris
  )
  ```
</details>

---

## Configure Software

At this point you should probably restart so things like the GPU driver and Display Manager can do their initial boot stuff. You may experience some odd boot stuff the first time around, and a second reboot may solve any quirks.

During boot you may see a bunch of lines printed in the terminal before the login screen appears. There may be some errors hidden in there. After you log in, you can check for errors by running
```sh
dmesg | grep -i "error\|warn\|fail"
```
<details>
  <summary>Expand to view common issues and solutions</summary>
  
  - **Issue: ACPI BIOS Error**
    <details>
      <summary>Expand for Solution</summary>
      
      Apparently this has been [a known issue](https://forums.linuxmint.com/viewtopic.php?f=42&t=371358) and can be ignored. 
      ```sh
      sudo nano /etc/default/grub
      # Replace `quiet` in the GRUB_CMDLINE_LINUX_DEFAULT with `loglevel=3`
      
      sudo update-grub
      ```
    </details>
</details>
<br>
<br>


If you have a previous backup that utilized `dconf`, you can restore it now which may save you some configuration time.
```sh
# Restore GNOME settings
dconf load / < ~/settings.dconf

# If you want to import keys for specific packages, the only thing I've found is to copy those sections to another `.dconf` file and run the same command above but with the new file. 
```
<br>


If you have any self-signed certificates that your browsers utilize, you'll need to install them now.
```sh
sudo apt-get install -y ca-certificates
sudo cp <CERT_NAME>.crt /usr/local/share/ca-certificates  # NOTE: I had a .pem file and when I checked if it was added in 'Passwords and Keys > Certificates > System Trust' - I couldn't find it. I renamed the .pem to .crt, re-ran update-ca-certificates, and it showed up.
sudo update-ca-certificates

# Bring in certs for browsers, can be a '.crt' or '.pem' file
certutil -d "sql:$HOME/.pki/nssdb" -A -t "CT,c,c" -n "<LABEL>" -i ~/Downloads/<CERT_NAME>.crt
# List imported certs
certutil -d "sql:$HOME/.pki/nssdb" -L
```
- In some cases, changes don't take effect right away. First try to exit and restart your Browsers. If that doesn't work, a restart may be required.
- In some cases a restart doesn't work, for example Browsers sometimes have their own certificate area where you have to manually add a cert. For example, in Chrome you can go to Settings > search for `cert` > click Security > click Manage Certificates > go to Authorities and add your cert.
<br>


If you have any back-ups of your keyrings, you'll need to install those especially if any Browsers have saved credentials locally and you're bringing those profiles over.  
- After initially copying over the `.local/share/keyrings` files, you'll need to open up the **System Monitor** and kill `gnome-keyring-daemon`.
   - If that doesn't work, then `systemctl --user stop gnome-keyring && systemctl --user start gnome-keyring`.
- Then open up **Passwords and Keys** and unlock the **Login** item. Then you can open up stuff like Chrome or anything that has locally saved passwords.
<br>


Control your monitor's temperature (limit blue light).
```sh
# NOTE: This file could conflict with the 'Inhibit' applet so just use 'Redshift'
cp -i ./files/redshift.conf ~/.config/
```
Launch **Redshift** (it starts `redshift-gtk` and adds it to the bottom bar). Right-click on it and check `Enabled` and `Autostart`.
<br>


<details>
  <summary>Expand for Session Management</summary>

  XFCE has this exposed where you can choose to save sessions and delete the ones that exist. Cinnamon has it hidden away.
  
  Launch **dconf Editor** and navigate to `/org/cinnamon/cinnamon-session/` toggle on the `auto-save-session` option.
</details>

<details>
  <summary>Expand for Update Manager</summary>
  
  ```
  [Edit > Preferences]
    [Options]
      - Uncheck "Refresh the list of updates automatically"
  ```
  
  Launch **Startup Applications**, find **Update Manager** and uncheck it.
</details>

<details>
  <summary>Expand for File Manager</summary>
  
  I've tried `dolphin`, `nemo`, and `thunar`.
  - `dolphin` had the benefit of natural sorting which all othe managers seem to lack currently, but it's slow to load and currently doesn't allow for excluding paths from thumbnail generation.
  - `nemo` ships with Cinnamon but it currently suffers from thumbnail generation issues (sometimes works, sometimes doesn't, or doesn't generate thumbs for all types).
      - Note that Nemo manages Cinnamon's desktop, so even if you're using a different file manager, Nemo can't be uninstalled. Also, if you need to restart it (like you may have restarted `explorer` on Windows), you can run:
          ```sh
          pkill nemo-desktop && nohup nemo-desktop &
          ```
  - `thunar` ships with XFCE. It's snappy, allows for **Custom Actions** via context menus that you can easily write yourself, and allows for defining rules for thumbnail generation.
  
  ---
  
  - Install Thunar and dependencies
      ```sh
      (
        sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
        sudo apt update
        sudo apt install fsearch thunar thunar-archive-plugin tumbler-plugins-extra
      )
      ```
  - Thunar uses `tumbler` for generating thumbnails. Most File Managers have options to not show thumbnails on network paths, but `cifs` mounts may not fall under that category even though they can be. This will instruct `tumbler` what paths to ignore in that case.
      ```sh
      (
        # Clear any generated thumbnails
        rm -rf  ~/.cache/thumbnails/*
        # Create rc file for tumbler
        mkdir -p ~/.config/tumbler
        cp /etc/xdg/tumbler/tumbler.rc ~/.config/tumbler
        # Exclude specific paths from having thumbnails generated
        vi ~/.config/tumbler/tumbler.rc
      )
      ```
      ```
      # Find all the instances of `Excludes=` and add the paths
      Excludes=<PATH1>;<PATH2>
      ```
      Kill the tumbler session via `pkill tumblerd`
  - To [use `folder.jpg` for folders](https://docs.xfce.org/xfce/thunar/4.14/tumbler#customized_thumbnailer_for_folders)
      - `sudo nano /usr/share/thumbnailers/folder.thumbnailer`
          ```
          [Thumbnailer Entry]
          Version=1.0
          Encoding=UTF-8
          Type=X-Thumbnailer
          Name=Folder Thumbnailer
          MimeType=inode/directory;
          Exec=/usr/bin/folder-thumbnailer %s %i %o %u
          ```
      - `sudo nano /usr/bin/folder-thumbnailer`
          ```
          #!/bin/bash
          
          convert -thumbnail "$1" "$2/folder.jpg" "$3" 1>/dev/null 2>&1 ||\
          convert -thumbnail "$1" "$2/.folder.jpg" "$3" 1>/dev/null 2>&1 ||\
          convert -thumbnail "$1" "$2/folder.png" "$3" 1>/dev/null 2>&1 ||\
          convert -thumbnail "$1" "$2/cover.jpg" "$3" 1>/dev/null 2>&1 ||\
          rm -f "$HOME/.cache/thumbnails/normal/$(echo -n "$4" | md5sum | cut -d " " -f1).png" ||\
          rm -f "$HOME/.thumbnails/normal/$(echo -n "$4" | md5sum | cut -d " " -f1).png" ||\
          rm -f "$HOME/.cache/thumbnails/large/$(echo -n "$4" | md5sum | cut -d " " -f1).png" ||\
          rm -f "$HOME/.thumbnails/large/$(echo -n "$4" | md5sum | cut -d " " -f1).png" ||\
          exit 1
          ```
      - `sudo chmod +x /usr/bin/folder-thumbnailer`
      - Close thunar via `thunar -q`, and kill the tumbler session via `pkill tumblerd`. Then re-open the folder and folders should now use the `folder.jpg/png`.
  
  ---
  
  Launch **FSearch**, go to:
  - `Edit > Preferences`
      ```
      [ Database ]
        (uncheck) Update database on start
        
        [ Include ]
          (add) /home/<USER>
      
      [ Search ]
      (check) Search in Path
      (check) Match Case
      ```
  
  ---
  
  If you want to batch edit Bookmarks, edit `~/.config/gtk-3.0/bookmarks`. It's much faster than manually adding new items, and if all you want to do is edit some paths - editing that file is your only option unless you want to delete and re-create the bookmark. The folder view updates as soon as you save as well.
  
  Example:
  ```txt
  file:///home/<USER>/Documents Documents
  file:///mnt/mount_folder/path/to/network/folder [Mount] Some Folder
  sftp://<USER>@<IP>/home/<USER> [SFTP] User Folder
  smb://WORKGROUP;<USER>@<IP>/<SHARE>/ [SMB] Share Folder
  ```
  
  ---
  
  Prepare custom actions:
  - You can add your own in Thunar by adding commands directly, but I prefer to use files
     ```sh
     mkdir -p ~/.config/Thunar/actions
     ```
  - Add your scripts (I symlink to ensure things keep in sync):
     ```sh
     ln -s "${PWD}/files/thunar/copy-filename.sh" ~/.config/Thunar/actions/
     ln -s "${PWD}/files/thunar/copy-full-path.sh" ~/.config/Thunar/actions/
     ln -s "${PWD}/files/thunar/create-desktop-shortcut.py" ~/.config/Thunar/actions/
     ln -s "${PWD}/files/thunar/open-as-root.sh" ~/.config/Thunar/actions/
     ln -s "${PWD}/files/thunar/view-metadata.py" ~/.config/Thunar/actions/
     ```
  - If you need to debug scripts, run `tail -f ~/.xsession-errors`, and try using your action.
  
  ---
  
  Launch **Thunar** and go to:
  - `Edit > Configure custom actions`
     - Fix the **Open in Terminal**. Just change it's **Command** to `tilix` (or your preferred terminal).
     - Fix the **Search** option that ships misconfigured with `catfish` which doesn't get automatically installed. Double-click on it:
        ```
        [Basic]
          Command: fsearch -s %f
          Keyboard Shortcut: Ctrl+F
        ```
     - (click) Add a new custom action
       ```
       [Basic]
         Name: Copy Filename
         Description: Copies a file's name without it's extension
         Command: ~/.config/Thunar/actions/copy-filename.sh %f
         Icon: edit-copy
       
       [Appearance Conditions]
         (check all items)
       ```
     - (click) Add a new custom action
       ```
       [Basic]
         Name: Copy Full Path
         Description: Copies a file's full path
         Command: ~/.config/Thunar/actions/copy-full-path.sh %f
         Icon: edit-copy
       
       [Appearance Conditions]
         (check all items)
       ```
     - (click) Add a new custom action
       ```
       [Basic]
         Name: Create Launcher
         Description: Creates a Launcher (.desktop file) so you can easily launch applications or scripts.
         Command: ~/.config/Thunar/actions/create-desktop-shortcut.py %f
         Icon: application-x-desktop
       
       [Appearance Conditions]
         [X] Text Files
         [X] Other Files
       ```
     - (click) Add a new custom action
       ```
       [Basic]
         Name: Open as Root
         Description: Open item with root privelages
         Command: ~/.config/Thunar/actions/open-as-root.sh %f
         Icon: applications-utilities (or system-run)
       
       [Appearance Conditions]
         [X] Directories
         [X] Text Files
         [X] Other Files
       ```
     - (click) Add a new custom action
       ```
       [Basic]
         Name: View Metadata
         Description: View metadata for a file
         Command: ~/.config/Thunar/actions/view-metadata.py %f %n
         Icon: dialog-information
       
       [Appearance Conditions]
         [X] Audio Files
         [X] Video Files
       ```
  - `Edit > Preferences`
     ```
     [Display]
       View new folders using: List View
       Show thumbnails: Local Files Only
       Date > Format: Custom, %Y-%m-%d
     
     [Behavior]
       (check) Show action to permanently delete files and folders
     ```
  - `View`
     - Location selector: `Toolbar style`
     - (check) Show Hidden Files
  - You may have to change the current view to Compact View. Then I `CTRL++` or `CTRL+-` to get the icons and text to a size I like.
</details>

<details>
  <summary>Expand for System Settings</summary>
  
  ### General System Settings
  
  ```
  [Appearance]
    
    [Backgrounds]
      [Images]
        (ignore this and set it via HydraPaper)
    
    [Font Selection]
      Default font: Ubuntu Regular 12
      Desktop font: Ubuntu Bold 12
      Document font: Sans Regular 12
      Monospace font: Monospace Regular 12
      Window title font: Ubuntu Medium 12
      Text scaling factor: 1.0
  
    [Themes]
      [Themes]
        Mouse Pointer: Bibata-Modern-Classic
        Applications: Mint-Y-Dark-Aqua
        Icons: Mint-L-Aqua
        Desktop: Mint-L-Dark-Aqua
        
      [Settings]
        Jump to position when clicking in a trough: (checked)
  
  ──────────────────────────────────────────────────────────────────────────────
  
  [Preferences]
    
    [Accessibility]
      [Keyboard]
        Use visual indicator on Caps and Num Lock (check) (if you don't want to use the 'betterlock' applet)
  
    [Account Details]
      Picture: (choose avatar)
      Name: (change to a preferred display name)
  
    [Applets]
      [Download]
        CinnVIIStartMenu
        Direct
        Lock keys indicator with notifications (betterlock)
        Panel Launchers
        Timeshift Spy 
        Trash
        User Applet
        Weather
        Wireguard
      
      [Manage]
        (select and Add the downloaded items)
        
        [Calendar]
          Use a custom date format: (checked)
          Date format: 【 %a.  %b. %e 】【%l: %M %p 】
        
        [CinnVIIStartMenu] (disable the Menu applet, and replace it with this by going into 'Panel edit mode' in the taskbar)
          [Menu]
            Menu layout: MATE-Menu
          
          [Panel]
            Use a custom icon and label: (checked)
            Icon: linuxmint-logo-simple-symbolic
            Text: enu
          
          [Sidebar]
            Separator below user account info box: (checked)
          
          [Quicklauncher]
            [Quicklauncher Applications]
              (Create a Tilix item, move it below the default Terminal, disable the default Terminal)
        
        [Grouped window list]
          [General]
            Group windows by applications: (uncheck)
          
          [Panel]
            Button label: Window title
            Show window count badges: (uncheck)
            
        
        [Lock keys indicator with notifications]
          Show num lock indicator: (checked)
          Show caps lock indicator: (checked)
          
        [Notifications]
          Show empty tray: (checked)
          (click 'Open notification settings')
            Remove notifications after their timeout is reached: (checked)
            Show notifications on the bottom: (checked)
            Notification duration (seconds): 2
            Media keys OSD size: Small
        
        [Power Manager]
          Display: Show percentage  
        
        [Weather]
          [Weather]
            Data service: Open-Mateo
            Forecast length (days): 7
          
          [Location]
            [Location settings]
              Manual Location: (checked)
            
            [Saved Locations]
              (add locations)
              (get the lat/lon from Google Maps, just right-click it'll be the first item, you only need to the 6th decimal for each value)
              City: <CITY>
              Country: <ABBREVIATED_STATE>
          
          [Presentation]
            Display current temperature in panel: (uncheck)
          
          [Other options]
            Temperature units: Fahrenheit
  
    [Desktop]
      Desktop Layout: No desktop icons
    
    [Hot Corners]
      Enable top left: Show the desktop
    
    [Preferred Applications]
      [Preferred applications]
        Web: Google Chrome
        Music: Sayonara Player
        Video: VLC media player
        File Manager: Thunar File Manager
        Terminal: Tilix
    
    [Screensaver]
      Delay before starting the screensaver: Never  (nothing else really works when running long CLI commands, I don't want it to lock in the middle of a process)
    
    [Startup Applications]
      Albert (check)
      mintwelcome (uncheck)
      Notes (check)
      Print Queue Applet (uncheck)
      Redshift (check)
      Solaar (check)
      Support for NVIDIA Prime (uncheck)
    
    [Windows]
      [Behavior]
        Location of newly opened windows: Center
        
      [Alt-Tab]
        Alt-Tab switcher style: Icons and window preview  (the 3D options seem to cause screen freezing issues)
        Delay before displaying: 100
      
  ──────────────────────────────────────────────────────────────────────────────
  
  [Hardware]
  
    [Mouse and Touchpad]
      [Touchpad]
        Click actions: Use multiple fingers for right and middle click
        Reverse scrolling direction: (uncheck)
        Speed: Roughly 65%
    
    [Network]
      [Wi-Fi]
        (disable while wired)
    
    [Power Management]
      [Power]
                                              |   on A/C   | on Battery
        ---------------------------------------------------------------
        Turn off the screen when inactive for:  15 minutes | 15 minutes
        Suspend when inactive for:                   Never | Never
        When the lid is closed:                 Do Nothing | Suspend
        ---------------------------------------------------------------
        When the battery is critically low: Shut down immediately
    
    [Sound]
      [Input]
        (Internal Microphone Built-in Audio)
          (click the speaker icon to mute/disable it)
      
      [Sounds]
        (customize system sounds)
  
  ──────────────────────────────────────────────────────────────────────────────
  
  [Administration]
  
    [Login Window] (only effects re-login from Suspend)
      [Appearance]
        Alignment: Center
        Background: /usr/share/backgrounds/linuxmint-wallpapers/mpiwnicki_sparkling.jpg
        GTK theme: Mint-L-Aqua
        Icon theme: Mint-L-Aqua
      
      [Users]
        Allow guest sessions: (checked)
  ```
  
  ---
  
  ### Panel Settings
  
  For the main Panel, I had an issue where icons randomly scaled up in size and couldn't be reset. To ensure the same sizes I:
  - Right-click the Panel and choose `Panel Settings`.
  - In the `Panel Appearance` section I click on `Right Zone`.
      ```
      Font Size: 12.0pt
      Colored Icon Size: 22px
      Symbolic Icon Size: 18
      ```
      Oddly, all those different sizes equate to the icons looking the same scale.
  
  Instead of installing a dock, you can create something similar via a Panel:
  - Right-click an empty area of the main bar, and choose `Add a new Panel`.
  - I clicked on the top Panel slot (highlighted in red).
  - Right-click the new Panel, choose `Panel Settings`.
      ```
      [ Panel Visibility ]
        Auto-hide panel: Intelligently hide panel
      
      [ Customize ]
        Panel height: 50
      ```
  - Right-click the Panel and toggle `Panel Edit Mode`, and then click `Applets`.
  - Go to the `Download` tab and search/add `Direct`. Then go back to the `Manage` tab.
  - I added these Applets, and dragged them to the specified Panel areas:
      ```
      (center)
        Panel Launchers
        Seperator
        Panel Launchers
        Direct
        Direct
        Direct
        Direct
        Direct
        Direct
        Seperator
        Panel Launchers
        Seperator
        Panel Launchers
      
      (right)
        User Applet
        Workspace Switcher
      ```
  - Configuration for the Panel Launcher is a bit glitchy. I tried to add custom items via the GUI but nothing appeared (*). Turns out you can import a JSON file with the items you want.
      - Create some `launchers-<NUMBER>.json` files on your Desktop (can be named anything and placed anywhere) (also, maybe create one with the proper formatting, then just copy and alter).
      - To get the names of the launchers, I mostly looked up items in the main system menu, right-clicked and chose `Add to desktop`. Then I'd run `ls -la ~/Desktop` to see the actual file names.
          - For location launchers (Home, Trash, etc), I had to create custom launchers.
              ```sh
              cd ~/.local/share/applications
              ```
              I'm using my custom Thunar action to create a launcher. Right-click any file, choose `Create Launcher`. You can also right-click on the Desktop and choose `Create a new launcher here` and then move it to `~/.local/share/applications`.
              ```
              Version: 1.0
              Exec: xdg-open trash:///
              Name: open_trash
              Comment: Opens a User's Trash folder
              Icon: user-trash-full
              ```
              ```
              Version: 1.0
              Exec: bash -c "xdg-open $HOME"
              Name: open_home
              Comment: Opens a User's Home folder
              Icon: user-home
              ```
              ```
              Version: 1.0
              Exec: bash -c "xdg-open $HOME/Music"
              Name: open_music
              Comment: Opens a User's Music folder
              Icon: folder-music
              ```
              ```
              Version: 1.0
              Exec: bash -c "xdg-open $HOME/Projects"
              Name: open_projects
              Comment: Opens a User's Projects folder
              Icon: mine__folders
              ```
              ```
              Version: 1.0
              Exec: systemctl suspend
              Name: sys_suspend
              Comment: Puts the system to sleep
              Icon: system-shutdown
              ```
      - After some trial and error, this format worked for me:
          ```json
          {
              "launcherList": {
                  "value": [
                      "<NAME1>.desktop",
                      "<NAME2>.desktop",
                      "<NAME3>.desktop:flatpak"
                  ]
              }
          }
          ```
          - Note: The import will fail silently if you have any malformed JSON. You can [validate on this site](https://jsonlint.com/).
          - Note: If you're adding a launcher for a Flatpak, you need to suffix it with `:flatpak`.
      - Right-click on an empty area of the Applet, you should see `Applet Preferences`. Click on that and then click `Configure`. Click the `More options` menu button (3 lines), then click `Import from a file`.
      - You should see your items replace the old items. The config files are stored in `~/.config/cinnamon/spices/panel-launchers@cinnamon.org/`.
      - (*) While troubleshooting something else, I found `~/.local/share/cinnamon/panel-launchers/` which had some orphaned custom launchers that were created. If I try to edit a launcher it generates the altered version there, but doesn't update the GUI. If I drag items around within the applet it seems to refresh then.
  - Configuration for the User Applet:
      ```
      Display the user Image on the Panel: On
      ```
  - Configuration for the Workspace Applet:
      ```
      Type of display: Simple buttons
      ```
  
  #### Back up Panels
  
  ```sh
  dconf dump /org/cinnamon/ > ~/cinnamon_backup.conf
  ```
  Custom launchers on your panel are not saved in the general dconf/settings backup and must be exported manually.
  - Right-click the custom launcher icon on your panel.
  - Select **Applet preferences** > **Configure**.
  - Click the three horizontal lines (more options) icon in the top right corner.
  - Select **Export to a file** and save it.
  You'd have to do this one at a time for everything, or just copy the `~/.config/cinnamon/spices` folder.
  
  #### Restore Panels
  
  First copy over the contents of your `~/.config/cinnamon/spices` backup, then:
  ```sh
  dconf load /org/cinnamon/ < ~/cinnamon_backup.conf
  ```
  
  #### Reset Panels
  
  If you completely deleted your panel and just want to fix it, run
  ```sh
  gsettings reset-recursively org.cinnamon
  # OR
  dconf reset -f /org/cinnamon/
  ```
  This will wipe custom settings and bring back the default panel.
  
  ---
  
  ### Headset Settings
  
  If you have a headset plugged in with a mic and you're hearing yourself in the headphones when you talk - that's loopback. There are a couple ways to disable it:
      - Open up the Sound Settings. In the Output tab, there'll likely be two sound devices for your headset. One will have a soundcard icon and the other will have a headset icon. You can click the speaker icon to mute a channel. Talk into your mic while muting a channel to see if you can still hear other sounds but not your own. If you still hear yourself, try the other device and repeat the talk/mute steps.
      - If nothing in the Sound Settings worked, you can try the CLI tool `alsamixer`. Once it's running in your CLI, hit `F6` to choose your sound device. Then arrow Left/Right to choose an output channel, and arrow Up/Down to change the volume.
</details>

<details>
  <summary>Expand for Cairo-Dock Settings</summary>
  
  If you want to switch from OpenGL go into `~/.config/cairo-dock/.cairo-dock` and update:
  ```diff
  - default_backend=opengl
  + default_backend=cairo
  ```
  
  To have it start on boot go into **Startup Applications**. `Add > Choose Applications > pick Cairo-Dock`.
  
  In order to add launchers to the dock, I go into the taskbar menu and search for the application. Once I find the application you can sometimes just drag it right to the dock, but more often than not I just right-click the app and choose `Add to desktop`. Then I can drag that launcher to the dock.
  
  Note that when a launcher is added to the dock, a copy of it is added to `~/.config/cairo-dock/current_theme/launchers`. So if a launcher needs to be updated, I'll generally just delete it and add the new one, but you can go in and manually edit the launcher in that folder.
  
  When manually creating a launcher I look to see if there's a good system icon via `cuttlefish` instead of pointing to an image. Some apps like system binaries may not have an icon, so you can find/create one and add it to the appropriate folder in `~/.local/share/icons`. More info on that in the [Theming](#theming) section.
    - After an update in Mint, I noticed some icons I was previously using were no longer available in the current theme. You can see what icon theme is in use under `Cairo-dock > Configuration > Appearance > Icons`. It seems to default to `_Custom Icons_` which is located at `/home/<USER>/.config/cairo-dock/current_theme/icons/`, and allows you to drop custom icons (SVG or PNG) directly in there. You can reference the files the same way as system icons, for example if you have `code.svg` you can reference it as `code` in the Launcher `Icon > Image's name or path` section. Missing icons may still exist within a different theme, so in a file browser you can open up `/usr/share/icons/` and search for the name that was previously being used, then just copy that file over to `<CAIRO>/current_theme/icons/`.
  
  Had an issue where Cairo wasn't using my default File Manager to open folders. It must be caching it somewhere because after I went into Default Applications, and changed my File Manager to something else, and then back to what I wanted, it started behaving.
</details>

<details>
  <summary>Expand for Grub Settings</summary>
  
  You can use **Grub Customizer** or CLI
  ```sh
  sudo nano /etc/default/grub
  ```
  ```diff
  # Decrease duration that grub menu displays
  - GRUB_TIMEOUT=10
  + GRUB_TIMEOUT=2
  ```
  ```sh
  sudo update-grub
  ```
</details>

<details>
  <summary>Expand for Inkscape Settings</summary>
  
  Keyboard Shortcuts
  | Keys | Description |
  | ---- | ----------- |
  | `CTRL+SHIFT+R` | Resize canvas to content |
  | `%` | Toggle snaps on/off |
  
  To move the tools on the right to the top, go to `View > (at bottom, change to) Custom`.
  
  Preferences
  ```
  [ Interface > Themeing ]
    GTK theme: Adwaita
    (check) Use dark theme
    change icon theme: multicolor
    (check) Use symbolic icons
  
  [ Behavior > Transforms ]
    (uncheck) Scale stroke width
  ```
</details>

<details>
  <summary>Expand for LSD Settings</summary>
  
  ```sh
  (
    mkdir -p ~/.config/lsd
    cp -i ./files/lsd/config.yaml ~/.config/lsd/
  )
  ```
</details>

<details>
  <summary>Expand for Qemu Settings</summary>
  
  - After the initial install, a reboot may be required to run `virsh` commands without `sudo`.
  - Verify things are running correctly with
     ```sh
     # list VMs - should be empty
     virsh -c qemu:///system list
     # make sure virtualization daemon is running
     systemctl status libvirtd.service
     ```
  - Start up virt-manager. If you run your quick launcher and type `virt`, an entry for `Virtual Machine Manager` should come up. Run it.
     - Go to Edit > Preferences
        ```
        [General]
          [X] Enable system tray icon
        ```
</details>

<details>
  <summary>Expand for Remmina Settings</summary>
  
  ```
  [ Preferences ]
    [ General ]
      Remmina data folder: ~/.local/remmina
    
    [ Applet ]
      [X] No tray icon (To close the app when you've closed all windows. May require you to kill the process the first time if you change this setting from the tray icon and all windows are already closed).
  ```
</details>

<details>
  <summary>Expand for Sayonara Settings</summary>
  
  ```
  [File > Preferences]
    [Application]
      (untick) Update notifications
    
    [User Interface]
      [General]
        (untick) Show large cover
      
      [Icons]
        (tick) Also apply this icon theme to the dark style (makes the volume icon look funny, but otherwise the icons in file picker are almost invisible, so it's required)
        (tick) ePapirus-Dark
    
    [Playlist]
      [Behavior]
        Start up:
          (tick) Load last track on startup
          (tick) Remember time of last track
      
      [Look]
        (tick) Show footer
        (untick) Show numbers
        (tick) Show covers
        Custom font color in dark theme: #2ad8ff
      
      [Row formatting]
        Row formatting: %nr% - %title%
      
    [Covers]
      (untick) Save found covers to database
      (untick) Fetch missing covers from internet
    
  [Plugins]
    (tick) Level (customize colors by mousing over and clicking button)
  
  [View]
    (untick) Show Library
    (untick) Show Large Cover
  ```
</details>

<details>
  <summary>Expand for SDDM Settings</summary>
  
  ```sh
  (
    # To configure the theme, create a custom config for sddm
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -i ./files/sddm/10-custom.conf /etc/sddm.conf.d/
    
    # Then a custom config for the theme, adjust values as you see fit (these changes will persist after theme updates)
    sudo cp -i ./files/sddm/theme.conf.user /usr/share/sddm/themes/breeze/
  )
  ```
  
  You can test the theme via: `sddm-greeter --test-mode --theme /usr/share/sddm/themes/breeze`. If there are errors, you may want to pick a different theme. To get out of the preview, `ALT + TAB` to your terminal and `CTRL + C` to kill the process.
  
  The backgrounds for a theme are set in `/usr/share/sddm/themes/<THEME>/theme.conf` on the `background=` line.
  Generally themes point to the global wallpapers so an image can be displayed for any user. Those wallpapers are in `/usr/share/wallpapers`.
  To more easily view all wallpapers I open that directory with a file manager, and do a search for `screenshot.jpg`, then I can just browse through the results, and find the path for the wallpaper I want.
  Once you have a wallpaper you like, create/update your config's background line, and you'll see the new image after a reboot. Note that you'll see your User wallpaper on the lock screen.
  
  If your user icon isn't showing up, look in `/var/lib/AccountsService/icons/` and see if an icon exists with your user name. If not, try picking and choosing an icon again from **Account Details**.
  
  If you have multiple monitors hooked up, things will likely be jacked up when the login screen appears. Here's how to fix it:
  ```sh
  # get info about connected monitors
  xrandr | grep -w connected
  # In my case the output was:
  # --------------------------
  ## HDMI-0 connected 1080x1920+1920+0 left (normal left inverted right x axis y axis) 531mm x 299mm
  ## DP-1 connected (normal left inverted right x axis y axis)
  ## DP-3 connected primary 1920x1080+0+423 (normal left inverted right x axis y axis) 531mm x 299mm
  # --------------------------
  # HDMI-0 is my secondary vertical monitor to the right of my primary DP-3. DP-1 is the closed laptop.
  
  # add rules so the login behaves
  sudo nano /usr/share/sddm/scripts/Xsetup
  # -------------------------------------
  xrandr --output DP-3 --auto --primary
  xrandr --output HDMI-0 --right-of DP-3 --rotate left --noprimary
  # -------------------------------------
  ```
  
  If `sddm` isn't behaving, you can revert to the default with `sudo dpkg-reconfigure lightdm`.
  
  Configuration doc: https://wiki.archlinux.org/title/SDDM#Configuration
  
  View the default config: `sddm --example-config | bat`
</details>

<details>
  <summary>Expand for Sticky Settings</summary>
  
  ```
  [ General ]
    [x] Tray Icon
    [ ] Show the main window automatically
  
  [ Backups ]
    [x] Automatic Backups
    Time between backups: 12
    Number to keep: 2
  
  [ Automatic Start ]
    [x] Start automatically
  ```
</details>

<details>
  <summary>Expand for VS Code Settings</summary>
  
  Extensions:
  - All Autocomplete https://marketplace.visualstudio.com/items?itemName=Atishay-Jain.All-Autocomplete
     - VSCode has the built-in `Word Based Suggestions` but it's not smart enough to handle variable suggestions during a destructured `import` if the variable is assigned to an Object.
  - Alphabetical Sorter https://marketplace.visualstudio.com/items?itemName=ue.alphabetical-sorter
  - Ascii Tree Generator https://marketplace.visualstudio.com/items?itemName=aprilandjan.ascii-tree-generator
  - Auto-Rename Tag https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag
  - Base IDE https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode
  - Better Todo Tree: https://marketplace.visualstudio.com/items?itemName=FanaticPythoner.better-todo-tree
  - Blueprint https://marketplace.visualstudio.com/items?itemName=teamchilla.blueprint
  - Change-case https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case
  - CSS Nesting Syntax Highlighting: https://marketplace.visualstudio.com/items?itemName=jacobcassidy.css-nesting-syntax-highlighting
  - DotENV https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv
  - Easy Snippet https://marketplace.visualstudio.com/items?itemName=inu1255.easy-snippet
  - ESLint https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint
  - File Icons https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons
  - File Utils https://marketplace.visualstudio.com/items?itemName=sleistner.vscode-fileutils
  - Git Commits https://marketplace.visualstudio.com/items?itemName=exelord.git-commits
  - Git Last Commit Message https://marketplace.visualstudio.com/items?itemName=JanBn.git-last-commit-message
  - git-rename https://marketplace.visualstudio.com/items?itemName=ambooth.git-rename
  - Indent one space https://marketplace.visualstudio.com/items?itemName=usernamehw.indent-one-space
  - Lint Lens https://marketplace.visualstudio.com/items?itemName=ghmcadams.lintlens
  - Markdown All in One https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
  - NGINX Configuration Language Support: https://marketplace.visualstudio.com/items?itemName=ahmadalli.vscode-nginx-conf
  - One Dark Pro theme https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme
  - Partial Diff https://marketplace.visualstudio.com/items?itemName=ryu1kn.partial-diff
  - select highlight in minimap https://marketplace.visualstudio.com/items?itemName=mde.select-highlight-minimap
  - Sort Lines https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines
  - Svelte for VS Code https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode
  - SVG Previewer https://marketplace.visualstudio.com/items?itemName=vitaliymaz.vscode-svg-previewer
  - Toggle Quotes https://marketplace.visualstudio.com/items?itemName=BriteSnow.vscode-toggle-quotes
  - VS DocBlockr https://marketplace.visualstudio.com/items?itemName=jeremyljackson.vs-docblock

  If things aren't behaving as expected after installing extensions (like config pages not loading), run `CTRL+SHIFT+P > Reload Window`.
  
  Settings:
  - View > Appearance > Secondary Side Bar
     - Go the Explorer view > (add) Open Editors
        - Move Open Editors to the Secondary Side Bar
     - Remove Chat from secondary panel - `CTRL + SHIFT + P` > (start typing `Hide Copilot`) and select the `Chat: Hide Copilot` option.
  - File > Preferences > Settings > User (or `CTRL + ,`)
     ```
     All Autocomplete: Max Items in Single List: 10
     All Autocomplete: Min Word Length: 5
     All Autocomplete: Show Current Document: (uncheck)
     Chat: (kill anything related to 'AI Chat' or 'Copilot')
     Diff Editor: Ignore Trim Whitespace (uncheck)
     Diff Editor: Render Side By Side: (uncheck)
     Dotenv: Enable Autocloaking: (unchecked)
     Editor: Accept Suggestion on Commit Character: (uncheck)
     Editor: Color Decorators: (uncheck)
     Editor: Detect Indentation: (uncheck)
     Editor: Folding Strategy: indentation
     Editor: Font Size: 14
     Editor: Hover:Delay: 1000
     Editor: Hover:Enabled: (uncheck)
     Editor: Insert Spaces: (check)
     Editor: Rulers: [80]
     Editor: Scroll Beyond Last Line: (uncheck)
     Editor: Show Tabs (off)
     Editor > Sticky Scroll: Enabled (uncheck)
     Editor: Tab Size: 2
     Editor: Token Color Customizations: (edit in JSON)
     Editor: Trim Auto Whitespace: (uncheck)
     Editor > Parameter Hints: Enabled: (uncheck)
     Explorer > Open Editors: Visible: 100
     Extensions: Auto Check Updates: (uncheck)
     Extensions: AUto Update: None
     Extensions: Ignore Recomendations: (check)
     Files: Exclude: (remove the pattern for `.git`)
     Javascript > Validate: Enable: (uncheck)
     Git: Close Diff On Operation: (check)
     Git: Input Validation: Off
     Markdown All In One: Math Enabled: (uncheck)
     Markdown All In One: Ordered List: Auto Renumber: (uncheck)
     Markdown All In One: Ordered List: Marker: one
     Markdown All In One: Toc Levels: 2..6
     Notebook > Sticky Scroll: Enabled (uncheck)
     SCM: Default View Mode: tree
     Search: Use Global Ignore Files: (check)
     Telemetry: Telemetry Level: off
     Terminal > Integrated: Font Family: FantasqueSansM Nerd Font Mono
     Terminal > Integrated > Sticky Scroll: Enabled (uncheck)
     Todo-tree > General: Tags
       (add) NOTE
     Todo-tree > Highlights: Background Colour Scheme
       (add) #FFFD8F
     Todo-tree > Highlights: Foreground Colour Scheme
       (add) black
     Typescript > Validate: Enable: (uncheck)
     Update Mode: manual
     Window: New Window Dimensions: inherit
     Window: Title: [${rootName}] ${activeEditorMedium}${separator}
     Window: Zoom Level: 1
     Workbench > Tree: Enable Sticky Scroll (uncheck) 
     ```
     - NOTE: Once you remove the `.git` exclusion it'll look like it's no longer excluded from version control. It will be, but for visual clarity you can do this:
        ```sh
        cp -i ./files/.gitignore_global ~/
        git config --global core.excludesFile ~/.gitignore_global
        ```
  - There are some settings that can only be set in the `settings.json`
     ```json
     "editor.tokenColorCustomizations": {
       "textMateRules": [
         {
           "scope": "markup.quote.markdown",
           "settings": {
             "foreground": "#bbba71"
           }
         },
         {
           "scope": "markup.inline.raw.string.markdown",
           "settings": {
             "foreground": "#62b9d3"
           }
         },
         {
           "scope": "markup.fenced_code.block.markdown",
           "settings": {
             "foreground": "#f379ce"
           }
         }
       ]
     },
     "blueprint.templatesPath": [
       "~/.config/Code/User/FileTemplates",
     ],
     "eslint.validate": ["javascript", "javascriptreact", "svelte"],
     "[css][html][javascript][svelte]": {
        "editor.suggest.showWords": false,
      },
     ```
  - File > Preferences > Keyboard Shortcuts (or `CTRL + k + s`) (or `CTRL+SHIFT+P`, `Preferences: Open Keyboard Shortcuts (JSON)`)
     ```
     # Toggle the 'Record Keys' button in the input.
     # Type `CTRL + d`, select the 'Add selection to next find match' entry, hit `DELETE`
     # Toggle 'Record Keys'
     # Search for 'Copy line down', set it's shortcut to `CTRL + d`

     # Toggle the 'Record Keys' button in the input.
     # Type `CTRL + s`, select the 'File: Save' entry, hit `DELETE`
     # Toggle 'Record Keys'
     # Search for 'Save All (workbench.action.files.saveall', set it's shortcut to `CTRL + s`
     
     # OS friendly line moving (ALT conflicts with system bindings and opens menus)
     Move Line Down: CTRL+UpArrow
     Move Line Up: CTRL+DownArrow
     ```
  - You can right-click on icons in the left bar to hide them.
  - Toggle the Activity Bar <code>CTRL + `</code>, drag the Search icon down to the panel so that the global searches have more space.
  - Right-click on the bottom Status Bar
     - Uncheck the second instance of Source Control
     - Uncheck Feedback
  - Disabled the Copilot status icon in bottom right of UI.
  - Only option for vertical "tabs" right now is to:
     - Go into View > Appearance > activate Secondary Side Bar. For some reason it doesn't remember your choice and you have to do this for every repo/project/folder you go into.
     - Drag the **Open Editors** over to the Secondary Side Bar. This action is remembered, and will now permanetely live in the Secondary Side Bar.
  - Install Python extension, but then remove auto-installed `isort` and `Jupyter` extensions. Seems to be a bug that'll spin up a few python processes for those extensions, and if you uninstall them, they keep running even after vscode is shut down, so you'll have to manually kill them. Open System Monitor, filter by `py`, the Process Name will be `python`, mouse over them to verify they were started by vscode. In some cases I'd have to delete `~/.config/Code/User/workspaceStorage/<HASH>` (sort by date, usually the newest one, but can verify by looking at the path in the `workspace.json` file)
     - Remove MS Python extensions, syntax highlighting seems to work without them.
     - Search for Typescript and disable everything under `Svelte > Plugin`
     - `~/.vscode/argv.json`, add `"disable-hardware-acceleration": true`
</details>

<details>
  <summary>Expand for Xed (Text Editor) Settings</summary>
  
  I was using `notepadqq` but it started taking a very long time to open.

  Xed comes default with Mint, but it requires a little customization.

  - Styles will come from https://github.com/trusktr/gedit-color-schemes
     - There are a few places where styles could possibly go. Run `ls -la /usr/share/gtksourceview-*/styles`, and take note of the folders that have a `styles.rng` file. For each one of those folders, you'll need to create a `.local` version where you'll dump the custom styles.
        ```sh
        # currently these folders match the above criteria
        mkdir -p ~/.local/share/{gtksourceview-3.0,gtksourceview-4}/styles
        ```
     - Now you can copy the contents of the repo's `gtksourceview-3.0/styles` folder over to the new folders.
        ```sh
        (
          wget https://github.com/trusktr/gedit-color-schemes/archive/refs/heads/master.zip -O ~/Downloads/geditcolors.zip
          unzip -j ~/Downloads/geditcolors.zip "gedit-color-schemes-master/gtksourceview-3.0/styles/*" -d ~/.local/share/gtksourceview-3.0/styles/
          unzip -j ~/Downloads/geditcolors.zip "gedit-color-schemes-master/gtksourceview-3.0/styles/*" -d ~/.local/share/gtksourceview-4/styles/
          rm ~/Downloads/geditcolors.zip
        )
        ```
  - Open a file with Xed (Text Editor)
     - Go to Edit > Preferences
        ```
        [Editor]
          (check) Display line numbers
          (check) Display overview map
          (check) Display right margin (set to 80)
          (check) Highlight the current line
          (check) Highlight matching brackets
          Tab width: 2
          (check) Automatic indentation
          (uncheck) Allow mouse wheel scrolling to change tabs
          
        [Theme]
          Twilight
        ```
</details>

<details>
  <summary>Expand for root Settings</summary>
  
  When running some commands via `sudo` you may notice things don't look or behave the same. Here are some things I copy over:
  ```sh
  (
    sudo cp -r ~/.config/lsd /root/.config/
    sudo cp ~/.vimrc /root/
  )
  ```
</details>

<br>
<br>

Now that things are set up, you should:
- Back things up
   ```sh
   # Back up GNOME settings
   dconf dump / > ~/settings.dconf
   ```
- Change Grub to something less noisy
   ```sh
   sudo nano /etc/default/grub
   ```
   ```diff
   - GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash loglevel=3"
   + GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3"
   ```
   ```sh
   sudo update-grub
   ```

---

## Install Hardware

### Label Printer

For the most part, the install was smooth, but there was a small hiccup.

1. Download and install driver (mine supplied a `.deb`).
    - If I need to uninstall the driver later I can run `apt search labelrange` (`labelrange` is the make), and then something like `apt remove labelrange-printer-driver`.
1. Power on the printer, and plug in it's supplied Bluetooth USB dongle. It should start to install the printer.
1. The hiccup during the install is that it defaults to an incorrect driver. To fix that:
    - Open up Printers.
    - In the Printers window, right-click the printer Select `Properties`.
    - In `Settings`, for the `Make and Model`, click `Change`.
    - It'll scan for drivers for a bit, it seems to default to an HP printer. Scroll the list until you find `LabelRange`.

Printer settings are stored here:
```
/etc/cups/ppd/*.ppd
/etc/cups/printers.conf
```
You can back up files with no problem, but if you want to restore files, you should take the cups server down first.
```sh
# Check if it's running
sudo service cups status
# Stop the server
sudo service cups stop
# Start the server
sudo service cups start
```  

---

## Make Extra Internal Drives Available

If you have extra internal drives, you'll need to format them, and then set them up to mount on boot.
- Open `gparted`
- Select the drive from the top-left drop-down.
- Select the allocated/unallocated space and Delete (if it's allocated), New (if it's unallocated). Format it to `ext4` (or whatever you feel like), and add a name/label to it.
- Apply the changes (the bottom should read `0 operations pending`).
- Get the `UUID` of a disk by running `blkid`.
- `sudo nano /etc/fstab`
- Add something like `UUID=<UUID>  /mnt/extra_data  ext4  defaults  0  0`
    ```
    <UUID>           The unique id of the disk (you can see the names in gparted)
    /mnt/extra_data  The location where it'll be mounted to.
    ext4             The filesystem format
    defaults         Use default options  
    0 0              Dump, check disk priority (zero is off)
    ```
- Create the mount folder `sudo mkdir -p /mnt/extra_data`.
- Verify the mount will work `sudo systemctl daemon-reload && sudo mount -a`.
- Take ownership of the mount `sudo chown "$USER:$USER" /mnt/extra_data`.


---

## Back Up or Restore Data

### Backing up data

#### Back up with TimeShift (system files)

1. Setup
    ```
    [Snapshot Type]
      RSYNC
      
    [Snapshot Location]
      (kept default root partition)
    
    [Snapshot Levels]
      Monthly: 1
      Weekly: 2
      Daily: 5
    
    [User Home Directories]
      (keep defaults)
    ```
1. Once the GUI comes up, click `Create`. Every snapshot after this will only be for changed folders and files.

The above settings keep 5 daily, 2 weekly, and 1 monthly snapshot. This gives you a 30-day rolling recovery window without consuming excessive disk space.

#### Back up with FreeFileSync (granular, any files you want)

Note: You may get `EACCESS` errors for certain system files/folders if not running as `root`. One way to get around that is to disable locking.
```sh
# run
code ~/.config/FreeFileSync/GlobalSettings.xml
```
```diff
- <LockDirectoriesDuringSync Enabled="true"/>
+ <LockDirectoriesDuringSync Enabled="false"/>
```
This could have unexpected syncing results if applications are running in the background so try to exit everything before starting a sync.

1. I created a folder on my backup drive called `Linux_Mint__Laptop__Pred`.
    - `Pred` is just a manufactures identifier in case I make a backup from another laptop also running Linux Mint.
1. Open up `FreeFileSync`
1. Set up a config: <br/>
    Generally these are my synchronization settings:
    ```
    [ Comparison ]
      Variant: File Content
    
    [ Filter ]
      Include:
        *:
      
      Exclude:
        */.Trash-*/
        */.recycle/
    
    [ Synchronization ]
      Variant: Mirror
      Delete and overwrite: Recycle bin
    ```
    You have to set them for every config, unless you start working on another config with previous config settings loaded. If you do start working from a previous config, be careful not to overwrite it. I generally click `Save As` when I know I'm starting on a new config.
    
    <br/>
    
    Note: System environment variables can be used in paths. So instead of hardcoded paths to a User directory like `/home/johndoe/stuff` you'd use `%HOME%/stuff`.
    ```
    [ Compare column ]
      Drag & drop (input): (You can directly input a path, or click 'Browse')
      (click the '+' to add another path, though sometimes it's better to add a top-level folder and exclude what you don't want)
    
    [ Synchronize ]
      Drag & drop (input): (You can directly input a path, or click 'Browse')
    ```
1. Run the backup
    - With a config loaded and selected, click the `Compare` button.
    - Take note of the icons in the Action column (swirling green arrows). If it's a trash icon, the files/folders will be deleted. Just be mindful of that before proceeding.
    - If things look good, click `Synchronize`.
1. If you want, you can zip up that backup folder and store it somewhere as a snapshot.


### Restoring data

#### Restore with TimeShift

If your system still boots, you can restore directly from the Timeshift GUI:
1. Select the snapshot you want.
1. Click Restore, and follow the prompts. The system will restart and apply the snapshot.

If your system will not boot:
1. Boot from a Linux Mint live USB.
1. Install Timeshift in the live environment, and use it to restore the snapshot to your installed system. The key is selecting the correct target partition during the restore wizard.

#### Restore with FreeFileSync

1. Load and select a config.
1. There's a `Swap Sides` button separating the Compare and Synchronization columns. Click on that to have your data go from the backup to the source.
1. Click `Compare`, review what will be changed.
1. If things look good, click `Synchronize`.
1. **Important**: Be sure not to save the config in the reversed state.

#### Reset repos after restore

Not sure if I had a bad backup, or the global permissions for my User folder changed, but after I restored my backup, my code repos had all their file permissions changed. Instead of going into each one and checking diffs to ensure I didn't have any untracked or modified files, I wrote a script to reset everything.
```sh
# Reset all the repos in the specified parent folder, that only have file permission changes.
./bin/fix-repo-perms.sh "${HOME}/Projects/Code/Apps"
```


### Create an encrypted USB drive to back up sensitive data

Followed [steps from this guide](https://linuxconfig.org/usb-stick-encryption-using-linux), and [this one](https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/). The second specifies the correct order of encrypting and then adding the FS.

1. Determine the name of the USB drive.
    1. Plug in the USB drive.
    1. Run `sudo fdisk -l`
    1. Each `Disk` listing has a `Disk model` section. If you have multiple drives plugged in by the same manufacturer, run `fdisk` before plugging in the drive, then plug it in and run `fdisk` and use the new drive in the list.
    1. In my case the file reference of the disk was `/dev/sdb` (which is listed on the first `Disk` line). You can't assume that name will be the same everytime you plug in the device to it's best to double check.
1. Partition the drive.
    1. `sudo fdisk /dev/sdb`
        ```
        Command (m for help): d
        
        Command (m for help): n
        Partition type
          p   primary (0 primary, 0 extended, 4 free)
          e   extended (container for logical partitions)
        Select (default p): p
        Partition number (1-4, default 1): 1
        First sector (2048-60063743, default 2048): [ENTER]
        Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-60063743, default 60063743): +8GB
        
        Command (m for help): n
        Partition type
          p   primary (0 primary, 0 extended, 4 free)
          e   extended (container for logical partitions)
        Select (default p): p
        Partition number (2-4, default 2): 2
        First sector (3907584-60063743, default 3907584): [ENTER]
        Last sector, +/-sectors or +/-size{K,M,G,T,P} (3907584-60063743, default 60063743): [ENTER]
        
        Command (m for help): w
        ```
    1. If you run `sudo fdisk -l`, you should see the new partions for your USB drive. The first partition will contain encrypted files, and the other will be for non-sensitive info.
1. Encrypt the the partition.
    ```sh
    sudo cryptsetup -h sha256 -c aes-xts-plain -s 256 luksFormat /dev/sdb1
    
    [enter a unique password]
    ```
1. Decrypt the encrypted partition.
    ```sh
    sudo cryptsetup luksOpen /dev/sdb1 usb_bup_pvt
    ```
    After executing, your encrypted partition will be available at `/dev/mapper/usb_bup_pvt`.
1. Add a filesytem to the partitions. Using `exFAT` because it can be read and written to by Linux, Windows and MacOS. Windows and Macs cannot even see ext4, and MacOS requires extra software to read NTFS. FAT32 is a no go due to file size restrictions, which exFAT doesn't have. Also the "extended File Allocation Table (exFAT)" builds on FAT32 and offers a lightweight system without all the overhead of NTFS.
    ```sh
    # Labels are limited to a length of 11 characters
    
    sudo mkfs.exfat -n "usb_bup_pvt" /dev/mapper/usb_bup_pvt
    sudo mkfs.exfat -n "usb_bup_pub" /dev/sdb2
    
    # View file systems and labels
    
    lsblk -f
    ```
1. Write random data to partition before proceeding with an encryption.
    ```sh
    sudo dd bs=4K if=/dev/urandom of=/dev/mapper/usb_bup_pvt status=progress
    ```
    It may take some time. Time depends on the entropy data generated by your system. Took a little over 5 minutes in my case.
1. Create a mount point and mount the partition.
    ```sh
    sudo mkdir -p /mnt/{usb_bup_pub,usb_bup_pvt}
    sudo chown -R "$USER:$USER" /mnt/{usb_bup_pub,usb_bup_pvt}
    sudo mount -o uid="$(echo $UID)",gid="$(echo $GID)" -t exfat /dev/mapper/usb_bup_pvt /mnt/usb_bup_pvt
    sudo mount -o uid="$(echo $UID)",gid="$(echo $GID)" -t exfat /dev/sdb2 /mnt/usb_bup_pub
    
    # verify mounts and usable space
    lsblk -f
    ```
1. Unmount the partition.
    ```sh
    sudo umount /mnt/{usb_bup_pub,usb_bup_pvt}
    sudo cryptsetup luksClose usb_bup_pvt
    ```

---

## Useful Keyboard Shortcuts

| Keys | Action |
| ---- | ------ |
| `ALT + click on a window + drag` | Moves a window |
| `ALT + right-click near window edge + drag up/down or left/right` | Resize a window |
| `CTRL+ALT+ESC` | Restart Cinnamon (keeps current session, may jumble window positions) |
| `CTRL+ALT+BACKSPACE` | Restart XOrg (exits to login) |

---

## Useful Commands

| Command | Description |
| ------- | ----------- |
| `sudo apt autoremove <PACKAGE>` | Can be used after a `apt remove <PACKAGE>` or in place of. A reason to use it after a `remove` would be to ensure that you don't accidentally remove something because a dependency wasn't tracked properly. But if you just added something and know that there won't be any conflicts use `autoremove`. |
| `sudo add-apt-repository --remove <REPO>` | It's a common one, but I always forget the syntax. You'd think there'd be a `remove-apt-repository`. |
| `apt search <QUERY>` | Search for available packages. There are [single letter codes](https://www.debian.org/doc/manuals/aptitude/ch02s02s02.en.html) next to the package names that tell you if something is already installed. Generally you'll only care about `i` (installed) or `p` (not installed) |
| `xev | grep keycode` | Prints out keycodes as you type |
| `xprop | grep WM_CLASS` | (click on an open window) prints the window class of an app. Aids in finding things on the system |

---

## Useful Places

```sh
# Applications (launcher) folders
/usr/share/applications
/var/lib/flatpak/exports/share/applications

# Logs
/var/log

# Network Interface configs
/etc/netplan

# System audio
/usr/share/sounds
```

---

## Theming

### GTK Themes and Apps

Recommended tools:
- `GtkInspector`
   ```sh
   # If `libgtk-3-dev` isn't installed, do so
   sudo apt install libgtk-3-dev
   
   # Enable with
   gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
   ```
- Color picker
   ```sh
   sudo apt install gpick
   # although I magically have mate-color-select installed as well...
   ```

File locations:
- CSS
    ```
    ~/.config/gtk-3.0/colors.css # color definitions
    ~/.config/gtk-3.0/gtk.css # just imports `colors.css`
    /usr/share/themes/<THEME>/gtk-3.0/gtk.css # theme specific styling/overrides
    ```

Sources:
- https://gtkthemingguide.vercel.app/#/getting_started
  - Source: https://github.com/surajmandalcell/Gtk-Theming-Guide/blob/master/getting_started.md
- https://docs.gtk.org/gtk3/css-properties.html

Updating Styles:
- With an App focused (I right-clicked the bottom panel and opened Panel Preferences), hit `CTRL+SHIFT+I` and it should open with that App's items listed in the Objects view. If that doesn't work you can try running the App in the CLI prefixed with `GTK_DEBUG=interactive`. You may be in the Details view, if so click on the Show All Objects button (top left).
- You can click on items in that view, and they'll blink/highlight if they're viewable. Once you find an item, double-click on it to open it's Details view. There's a drop-down, switch it to `CSS Nodes`. There you can find `ID`s, `Style Classes`, `CSS Property`s, and `Location`s. You can use `ID`s and `Style Classes` as you would ids and classes in CSS. `Location` is useful to determine if there's a hardcoded value in a CSS file somewhere, or if it's being controlled dynamically `<data>:##:##`.
- With the info from that view, go to the `CSS` view. Anything you add in there will take effect immediately. Test it with something like
   ```css
   #PanelWindow {
     background-color: #FF00FF;
   }
   ```
  Most items you can just select their Properties, then inspect from there.
- Add your custom styles to `~/.config/gtk-3.0/custom.css`, then open `~/.config/gtk-3.0/gtk.css` and add `@import "custom.css";`. For changes to take effect I logged out and back in.
- When you're done, you may want to disable the `GtkInspector` key bindings so you don't get any unexpected keyboard conflicts
   ```sh
   gsettings set org.gtk.Settings.Debug enable-inspector-keybinding false
   ```


### Icons

- [Icon Theme Spec](https://specifications.freedesktop.org/icon-theme/latest/)
- [Icon Naming Spec](https://specifications.freedesktop.org/icon-naming/latest/)

```
/usr/share/icons      # Global icons  (Apps installed for every User)
~/.local/share/icons  # User icons    (Apps installed for a specific User, or custom icons used for whatever)
```
There should be a theme folder in the `icons` folder which contains folders for the supported sizes.
```
<PARENT>/icons/hicolor  (hicolor is a default, and usually safe to drop your stuff in)
  ┣━ /16x16     (Status bar and context menus)
  ┣━ /24x24     (Toolbar and small menus)
  ┣━ /32x32     (Panel icons and menus)
  ┣━ /48x48     (Standard application icon)
  ┣━ /64x64     (File manager and panels)
  ┣━ /128x128   (Application menu and dock)
  ┣━ /256x256   (High-DPI displays)
  ┣━ /512x512   (Large preview and app store)
  ┗━ /scalable  (SVGs for perfect rendering at any size)
```
Within the size folders, there are categories.
```
/512x512
  ┣━ /actions     (Icons which are generally used in menus and dialogs for interacting with the user.)
  ┣━ /animations  (Animated images used to represent loading web sites, or other background processing which may be less suited to more verbose progress reporting in the user interface. Animations should be a PNG with frames which are the size of the directory the animation is in, tiled in a WxH grid. Implementations should determine the number of frames by dividing the image into it's frames, and iterating from left to right, wrapping to the first frame, after rendering the last.)
  ┣━ /apps        (Icons that describe what an application is, for use in the Programs menu, window decorations, and the task list. These may or may not be generic depending on the application and its purpose. Applications which are to be considered part of the base desktop, such as the calculator or terminal, should use the generic icons specified in this specification, while more advanced applications such as web browsers and office applications should use branded icons which still give the user an idea of what function the application provides.)
  ┣━ /categories  (Icons that are used for categories in the Programs menu, or the Control Center, for separating applications, preferences, and settings for display to the user.)
  ┣━ /devices     (Icons for hardware that is contained within or connected to the computing device. Naming for extended devices in this group, is of the form <primary function>-<manufacturer>-<model>. This allows ease of fallback to the primary function device name, or ones more targeted for a specific series of models from a manufacturer. For example, a theme author may want to provide icons for different phones. The specific model icons could be named “phone-samsung-t809”, “phone-motorola-rokr”, and “phone-motorola-pebl”. However, the theme must provide a phone icon in the theme's style, so that devices not matching these models, will still have an appropriate icon. An exception to this rule is that the “media” icons do not need to include manufacturer names, as they are generic items, and may be available from many manufacturers. As a result, for media, the specific icons are to differentiate between different specific types of media. For exmaple, an artist may wish to provide icons for BluRay, DVD, HD-DVD, CD-ROM, and variations thereof. The specific media type icons should be named in the form, <primary function>-<specific format>. Some examples are “media-optical”, “media-optical-bd” and “media-optical-dvd”.)
  ┣━ /emblems     (Icons for tags and properties of files, that are displayed in the file manager. This context contains emblems for such things as “read-only” or “photos”.)
  ┣━ /emotes      (Icons for emotions that are expressed through text chat applications such as :-) or :-P in IRC or instant messengers.)
  ┣━ /intl        (Icons for international denominations such as flags.)
  ┣━ /mimetypes   (Icons for different types of data, such as audio or image files.)
  ┣━ /places      (Icons used to represent locations, either on the local filesystem, or through remote connections. Folders, trash, and workgroups are some examples.)
  ┗━ /status      (Icons for presenting status to the user. This context contains icons for warning and error dialogs, as well as for the current weather, appointment alarms, and battery status.)
```
The format for naming icons is `<NOUN>-<ADJ/VERB>`, so the item descriptor and either it's state or action.
```
app-active
app-exiting
```

#### Installing Raster Icons

To install raster (.png) icons, you'd run:
```sh
# The default 'mode' depends on who's running the command. So in most cases 'mode' can be omitted, and if you run the command with 'sudo' then 'mode' will be 'system', otherwise it'll be 'user'.
# The default 'theme' is 'hicolor', but is present here for the example.
# The 'size' is the folder where it'll be installed.
# The default 'context' is 'apps', but is present here for the example.
# The source path of the icon.
# The optional new name of the icon.

xdg-icon-resource install --mode user --theme hicolor --size 16 --context apps "./myicons/fu-16.png" "app-fu" 
```

#### Installing Vector Icons

To install vector (.svg) icons, it's a manual process. So far I've found that I can just dump them into `~/.local/share/icons/hicolor/scalable/<CATEGORY>/` (generally I add to the `app` category folder).
Cool thing about vector icons, you can add `-symbolic` to the end (`app-symbolic.svg`) and the system will automatically change the color of the icon to match the theme.

#### Refreshing Icon Cache

There have been times where some Apps don't recognize my newly added icons, and I have to tell the system to refresh. Oddly, this command runs as root on the system-wide folder, but somehow refreshes icons in `.local` as well (I tried calling it on specific nested folders system/local and nothing changes, it always has to be within `/usr/share/icons/`).
```sh
sudo update-icon-caches /usr/share/icons/*
```

#### Creating & Adding Raster Icons

Before creating or finding my own icons I open up `cuttlefish` to see if there's something that'll work for me. If not, you can add a single icon in `~/.local/share/icons/`.
For better compatibility (like having it show up in `cuttlefish`) I created a GIMP plugin to generate folders and the different sized icons.
1. Close GIMP if it's running
1. Symlink the plugin over `ln -s $PWD/files/gimp/nox_gen-freedesktop-icons.py ~/.config/GIMP/2.10/plug-ins/`
1. The first time testing it, you can open GIMP via the terminal to see if there are any errors while loading.
1. Add your full resolution icon to `~/.local/share/icons/hicolor/`. I tend to prefix my icons with `mine__` so I easily know what I've added.
1. Open that image in GIMP
1. In the top menu, go to NOX > (click) Gen Freedesktop Icons
1. Choose the icon type
1. (click) Generate
1. In `cuttlefish` you should now be able to look up your icon, and use that icon name where ever.

---

## Troubleshooting

### System boots to blank screen after failed update
<details>
  <summary>Expand for Solution</summary>
  
  Updated the kernel and GPU driver, the output froze for over half an hour while it was supposedly compiling something for the kernel so I had to do a forced shutdown. During the boot, the OS logo popped up, then eventually went to a blank screen.
  
  - I rebooted and spammed `F11` until the boot menu appeared.
  - Choose the last functional kernel.
  - This should get you back into a functional state where you can log in.
  - I then opened a terminal and ran `sudo dpkg --configure -a` to finish the updates that previously failed. Some may take a while, just let them do their thing.
  - Reboot and verify that the new kernel is being used after you log in again.
</details>
<br>
<br>

### System going to sleep after a few seconds on the Login screen
<details>
  <summary>Expand for Solution</summary>
  
  The issue only happened when my system was docked and the lid was closed and I was using an external monitor.
  
  Normally you'd go into **Power Management** and set what the system should do when the lid is closed. Turns out that it has no effect in the Login screen, rather it's controlled by `logind`.
  
  First check what files are effecting `logind`:
  ```sh
  systemd-analyze cat-config systemd/logind.conf
  ```
  If you don't see any files with settings pertaining to `HandleLidSwitchExternalPower`, create a new one:
  ```sh
  sudo cp -i ./files/laptop-login.conf /usr/lib/systemd/logind.conf.d/
  # Save changes and run
  sudo systemctl restart systemd-logind
  ```
</details>
<br>
<br>

### Kernel Panic error after choosing "recommended" nvidia driver
<details>
  <summary>Expand for Solution</summary>
  
  To fix the panic, during boot I chose Advanced in the Grub menu. In that sub-menu I went down the list of available `recovery-mode` options until one booted.
  
  From the menu I chose the Root shell option. Then I ran `ubuntu-drivers devices` (displays what Driver Manager shows). I found the bad driver name and ran:
  ```sh
  (
    apt purge nvidia-driver-525
    apt autoremove
    reboot
  )
  ```
  You should then be able to boot normally with the default `nouveau` driver. Open up Driver Manager and reinstall the nvidia driver that matches your kernel.
  
  To find the driver that matches your kernel, run `uname -r` to view the current kernel. Then compare that against the available nvidia drivers in Driver Manager. For me it was recommending `nvidia-driver-525` when my kernel was `5.15.0-56-generic`. So it should've been recommending `nvidia-driver-515`.
</details>

### "error: out of memory" on boot right after grub menu
<details>
  <summary>Expand for Solution</summary>
  
  Seems to be linked to using nvidia drivers https://bugs.launchpad.net/oem-priority/+bug/1842320.
  Add this to your Grub config, save and reboot.
  ```
  GRUB_GFXMODE=640x360
  ```
  
  If that doesn't work, I also purged all nvidia packages via Synaptic Package Manager. Had to manually find all `nvidia` packages with a `version` matching what was installed. Rebooted, and the system should now be using the `nouveau` driver. Use Driver Manager to install the `nvidia` driver again.
</details>

### Chrome Saved Passwords Not Showing Up in Settings
<details>
  <summary>Expand for Solution</summary>
  
  First, close Chrome while you're troubleshooting.
  
  Possible reasons for this:
  1. The `Login Data` file is missing from `~/.config/google-chrome/<Default|Profile>/` or it's read/write protected. Look at the other file permissions in a folder you haven't touched, and copy those. 
  1. The passwords in the database (`Login Data` is a sqlite3 file) were encoded with a system key that aren't on your new system. It should be stored in `~/.local/share/keyrings`.
  1. There's a corrupted value in `Login Data`. If Chrome can't read a value, it automatically considers everything broken and won't display anything. If you run [fix-chrome-creds.py](./bin/fix-chrome-creds.py) it'll create a fixed file on your desktop, and output all the values so you can see what may be broken, or worse case manually input the passwords. Example `./bin/fix-chrome-creds.py -f "~/.config/google-chrome/<PROFILE>/Login Data" -p "<KEY>"`. `<KEY>` would come from `Passwords and Keys > Login > Chrome Safe Storage`.
</details>

### How to Free Up Space?
<details>
  <summary>Expand for Solution</summary>
  
  ```sh
  # There could be other folders in `.cache` that you may want to investigate.
  # Deleting folders or their contents while certain Apps are running could cause issues.
  rm -rf  ~/.cache/{thumbnails}/*
  ```
</details>

### File Managers randomly freeze when transfering CIFS files
<details>
  <summary>Expand for Solution</summary>
  
  Had random issues in file managers when transfering lots of small files at once. Basically I'd start a transfer, the manager would hang, couldn't close the transfer dialog and would have to kill the manager's proccess.
  
  When I added `vers=1.0` (like `sudo mount -t cifs -o vers=1.0`) the issue no longer happened but transfers were slower, and version `1.0` is less secure.
  
  After weeks of random troubleshooting I found an option in TrueNAS Scale, within each SMB share.
  - Select a share to bring up it's properties panel
  - Click **Advanced Options**
  - Scroll down and check **Enable SMB2/3 Durable Handles**
  - Save changes
</details>

### System Freezes/Locks When Entering Suspend
<details>
  <summary>Expand for Solution</summary>
  
  - Went into **Update Manager** > View > Linux Kernels > chose the oldest in the available `5.15` series (`5.15.0-25`). Waited for it to install, rebooted, used the Grub menu during boot to choose the older kernel. Tested suspend and logging out/in and things seem to be working now.
  - To ensure it doesn't boot to the bad kernel:
     - Launch **Update Manager** > View > Linux Kernels. Click on the bad installed kernel, click `Remove`.
     - That kernel probably just popped up in the Update Manager as an available update. Right-click it and choose `Ignore the current update for this package`. If you mistakenly ignored the wrong package, go into Edit > Preferences > Blacklist, and remove what you ignored.
  
  If the need to manually download and add an older kernal arise: https://askubuntu.com/a/700221
</details>

### Can't Boot Past Grub Menu
<details>
  <summary>Expand for Solution</summary>
  
  Recently updated my GPU driver and after I rebooted I kept getting an "out of memory" error from `initramfs`. No matter what I tried there was no way to get to a terminal or recover anything, everything just crapped out.
  
  Luckily you can use a Live ISO to recover:
  - I loaded into Mint via VenToy
  - Started a Terminal in Mint
     ```sh
     # mounting a ZFS pool takes a little extra work
     (
       # the root pool where you normally boot into
       sudo zpool import -R /mnt rpool
       # the boot pool where Grub lives
       sudo zpool import -R /mnt/ bpool
       sudo mount -t exfat UUID=7B55-ECA0 /mnt/boot/efi
       # mount certain system folders so things can run normally
       for i in dev dev/pts proc sys; do sudo mount -v --bind /$i /mnt/$i; done
       sudo mount -v --bind /mnt/boot/efi/grub /mnt/boot/grub
     )
     # load into the pool like it's a new root system
     sudo chroot /mnt
     
     # if you can't install packages due to mirrors not being resolvable
     sudo nano /etc/resolv.conf
       # add
       nameserver 8.8.8.8
     
     # if mirrors are out of date
     sudo nano /etc/apt/sources.list.d/official-packages-repositories.list
     
     # patch initramfs to keep it's file size down (fix 'out of memory')
     sudo nano /etc/initramfs-tools/initramfs.conf
       # update existing items to:
       MODULES=dep
       COMPRESS=xz
     
     # remove driver (adding or removing automatically re-builds initramfs)
     sudo apt remove nvidia-driver-515
     sudo apt autoremove
     # list available drivers
     ubuntu-drivers devices
     # install driver
     sudo apt install nvidia-driver-525
     # make sure Grub references any new files that may have been generated
     sudo update-grub
     
     exit
     
     # if you need to make any file back-ups, do so now while things are mounted
     
     reboot
     ```
  - The Grub menu wouldn't load after my changes, instead it was just the Grub console.
     ```sh
     # list available drives
     grub> ls
     # find which drive has the boot pool (without the slash it may print the label of `bpool`, otherwise look for a BOOT folder and make sure there isn't Windows stuff in it).
     grub> ls (hd2,gpt3)/
     
     # load things up
     # set root=(hd#,gpt#)
     grub> set root=(hd2,gpt3)
     # linux /BOOT/ubuntu_######/@/vmlinuz root=ZFS=rpool/ROOT/ubuntu_###### boot=zfs
     grub> linux /BOOT/ubuntu_1yyx7k/@/vmlinuz root=ZFS=rpool/ROOT/ubuntu_1yyx7k boot=zfs
     # initrd /BOOT/ubuntu_######/@/initrd.img
     grub> initrd /BOOT/ubuntu_1yyx7k/@/initrd.img
     grub> boot
     ```
  
  If you need to back things up to a flash drive:
  ```sh
  # FAT drives have a limit of around 4GB per file, so split into `4294967295` chunks
  # [Export]
  sudo tar -cvzf - /mnt/home/<USER>/ | split -b 4294967295 - "/media/mint/<FLASH_ID>/backup.tar.gz.part"
  
  # [Import]
  cd <DEST_FOLDER>
  cat /<FLASH_ID>/backup.tar.gz.part.* | tar xzvf -
  ```
</details>

### "Couldn't Connect to Accessibility Bus" Warnings When Opening/Starting Something From CLI
<details>
  <summary>Expand for Solution</summary>
  
  The fix is to `export` this variable:
  ```sh
  # `NO_AT_BRIDGE` to hide GTK "couldn't connect to accessibility bus" warnings (usually when running 'open'). It's been a known issue for a long time https://bugs.launchpad.net/ubuntu/+source/at-spi2-core/+bug/1193236.
  export NO_AT_BRIDGE=1
  ```
  
  The comment's not neccessary (for whatever file you dump it in), but it could be useful when trying to remember why you added it.
  
  There are different schools of thought as to where to add the `export`. Personally I added it to my `.*rc` file, but it can be added to these locations as well:
  
  | File | Description |
  | ---- | ----------- |
  | `/etc/profile` | Global exports. Executes first. Available to all shells. Just add the `export` line. |
  | `/etc/profile.d/<FILENAME>` | Global exports. Anything in `profile.d` is loaded by `/etc/profile`. Available to all shells. `<FILENAME>` could be something like `01_accessibility_bus_fix.sh`, and in that file you'd add the `export` line. The leading number is just to ensure execution order. |
  | `~/.profile` | User exports. Available to all shells. Just add the `export` line. |
  | `~/.*rc` | User exports. Available to specific shell. Just add the `export` line to your Shell's `rc` file. So `.zshrc`, `.bashrc`, etc. |
        
</details>

### USB Drive Slow to Eject or Suffers Data Loss
<details>
  <summary>Expand for Solution</summary>
  
  Linux has a caching/buffering layer when writing files to a disk. Basically the file manager's copy progress dialog is inaccurate and none of them display the actual written to disk progress, but instead display the written to RAM progress. So if you safely eject the disk, it'll disappear from the system tray list making you think it's safe to remove, but if you are viewing the drive in the **Disks** tool you may see a spinner indicating that something is still going on. Basically if you don't wait for the tray notification saying that it's ok to remove the drive, you may suffer data loss or an unreadable drive.
  
  If you want accurate copy progress you have to alter the automount options for USB disks to either `flush` (which is the fastest) or `sync`. Unfortunately `flush` isn't supported by all disks so I was only able to try `sync` which was much slower than just transferring and waiting.
  
  To change the automount rules:
  - Run:
      ```sh
      # First run `mount` on the mounted drive to see what it's defaults are
      mount | grep <DISK_LABEL>
      
      # You may have to create/copy the mount_options.conf if it doesn't exist
      sudo cp /etc/udisks2/mount_options.conf.example /etc/udisks2/mount_options.conf
      ```
  - Open `mount_options.conf` and add the appropriate value.
      ```sh
      sudo nano /etc/udisks2/mount_options.conf
      ```
      ```
      [defaults]
      defaults=rw,nosuid,nodev,noatime,sync
      
      # or
      
      [defaults]
      defaults=rw,nosuid,nodev,noatime,flush
      ```
  - Eject, remove, and then re-insert your drive. The changes should be applied.
      ```sh
      # Run mount again to verify changes.
      mount | grep <DISK_LABEL>
      ```
  
  Further debugging can achieved by running these commands:
  ```sh
  # udev is the hotplug management daemon. Run the below to see what happens when you plug in a device.
  udevadm monitor --udev
  
  # The path for User rules is:
  /etc/udev/rules.d/
  # If you add a new rules file, reload the rules with:
  sudo udevadm control --reload-rules
  
  # The path for System rules is:
  /usr/lib/udev/rules.d/
  
  # Print info about your mounted drive (get the generated name from Disks)
  udisksctl info -b /dev/<DRIVE>
  
  # To see what happens when you plug a drive in, first plug the drive in, then run:
  udevadm test -a add $(udevadm info -q path -n /dev/<DRIVE>)
  ```
</details>


### Steam Not Recognizing Bluetooth Controller 
<details>
  <summary>Expand for Solution</summary>
  
  In my case I had to turn on the controller before starting Steam for it to detect it and map controls to games.
</details>

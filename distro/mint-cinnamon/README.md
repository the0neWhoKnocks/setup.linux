# Mint: Cinnamon

This setup is for creative/development tasks. Before blindly installing everything listed, go over the **Software Details** sections to see if the software could be useful.

- [Pre-Install](#pre-install)
- [Install](#install)
- [Initial Boot](#initial-boot)
- [Set Up Display](#set-up-display)
- [Create Common Directories](#create-common-directories)
- [Don't Require Password for Sudo](#dont-require-password-for-sudo)
- [Install Base Software](#install-base-software)
- [Clone This Repo](#clone-this-repo)
- [Set Up Shell](#set-up-shell)
- [Set Up Repos](#set-up-repos)
- [Set Up Shares](#set-up-shares)
- [Install Software](#install-software)
  - [Via Software Manager or CLI](#via-software-manager-or-cli)
  - [Via Flatpak](#via-flatpak)
  - [Via deb](#via-deb)
  - [Via Archives](#via-archives)
  - [Via CLI](#via-cli)
- [Configure Software](#configure-software)
- [Back Up or Restore Data](#back-up-or-restore-data)
- [Useful Keyboard Shortcuts](#useful-keyboard-shortcuts)
- [Useful Commands](#useful-commands)
- [Useful Places](#useful-places)
- [Theming](#theming)
  - [GTK Themes and Apps](#gtk-themes-and-apps)
  - [Icons](#icons)
- [Troubleshooting](#troubleshooting)

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
1. Choose the option to **Erase disk**, which should then ask you to choose the file system. I chose **ZFS**.
1. The next screen prompts to choose the disk to install to. I want to dual-boot Windows and Linux and am installing Linux to a freshly installed unformatted drive.

---

## Initial Boot

There's a splash screen that can hide potential issues during boot, so disable it while settings things up.
```sh
sudo vi /etc/default/grub
# Replace `splash` in GRUB_CMDLINE_LINUX_DEFAULT with `nosplash`

sudo update-grub
```

System Reports may prompt to install things like GPU drivers and language packs. If it doesn't (it's set to wait 40 seconds after login), launch the Driver Manager, see if there's a "recommended" one like `nvidia-driver-515` (just make sure it matches your kernel number `uname -r`).
- **IMPORTANT**: If you have a dock that has one monitor hooked up, and another monitor is hooked up to a laptop, you'll want to stick with the `nouveau` driver. It's the only one that's given me stable performance with a second monitor.

Open the **Update Manager**, if there are updates for the GPU driver or kernel, install them.

---

## Set Up Display

If you have multiple monitors, launch **Display**
- Select your main monitor and toggle it to `Set as Primary` if it isn't already set.
- Set the `Rotation` of other monitors if they're rotated.
- Drag monitors roughly into the correct positions.
- Apply, keep changes, rinse-and-repeat while adjusting monitor positions.
- Under **Settings** I also unchecked `Enable fractional scaling controls`. Not sure if it was actually hurting anything, but I disabled at during some troubleshooting and things have been stable so it stays off for now.

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

```sh
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
  sudo vim /opt/displaylink/udev.sh
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
      (check) Custom font: FantasqueSansMono NF Regular 16

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

This an on-demand approach, like for a laptop that may not always be on your network. (requires [this step](#clone-this-repo))
```sh
(
  cd ./bin
  ./user-script.sh --install "${PWD}/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
)
```
- Run the new Launcher that was added to the Desktop
  - Configure the settings for the share.
    - The mounted folder needs to be in `/media`, or it won't be automatically detected.

---

## Install Software

Here are some sources for finding alternatives to software you may have used on other OS's:
- https://alternativeto.net/platform/linux/
- https://www.linuxalt.com/

### Via Software Manager or CLI

```sh
(
  sudo add-apt-repository -y ppa:alex-p/aegisub
  sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
  sudo add-apt-repository -y ppa:kdenlive/kdenlive-stable
  sudo apt-add-repository -y ppa:lucioc/sayonara
  sudo apt update
  sudo apt install -y aegisub cairo-dock cairo-dock-gnome-integration-plug-in cheese chromium dconf-editor flameshot git-gui grsync grub-customizer guvcview handbrake hydrapaper inkscape kdenlive kid3-qt lolcat meld mkvtoolnix-gui okular p7zip-full peek python-is-python3 python3-notify2 sayonara solaar soundconverter sticky vlc xclip xserver-xorg-input-synaptics
  # remove some stuff that tagged along
  sudo apt remove hypnotix kwalletmanager
)
```
These require a User to answer prompts
```sh
sudo apt install sddm sddm-theme-breeze ttf-mscorefonts-installer wireshark
```

Optional
```sh
sudo apt install -y figlet obs-studio pavucontrol plasma-sdk
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
  | [cairo-dock](http://glx-dock.org/) | Customizable icon dock |
  | [cairo-dock-gnome-integration-plug-in](https://packages.ubuntu.com/bionic/x11/cairo-dock-gnome-integration-plug-in) | GNOME integration plug-in for Cairo-dock. Needed for things like emptying trash |
  | [cheese](https://wiki.gnome.org/Apps/Cheese) | Allows you to take photos and videos with your webcam. |
  | [chromium](https://www.chromium.org/getting-involved/download-chromium/) | Browser without all the Chrome overhead |
  | [dconf-editor](https://apps.gnome.org/app/ca.desrt.dconf-editor/) | Tool to allow direct editing of the dconf configuration database. Sometimes allows for changing low-level settings not exposed in most GUIs. |
  | [flameshot](https://flameshot.org/) | Swiss army knife of screenshot tools |
  | [git-gui](https://git-scm.com/docs/git-gui/) | Handy when wanting to do per-line commit-staging |
  | [grsync](https://community.linuxmint.com/software/view/grsync) | A simple GUI for the `rsync` |
  | [grub-customizer](https://launchpad.net/grub-customizer) | Easily change and compile grub config |
  | [guvcview](https://community.linuxmint.com/software/view/guvcview) | Capture images or video with webcam. (It's the only thing I've found that gives the option to mirror video) |
  | [handbrake](https://handbrake.fr/) | Tool for converting video from nearly any format to a selection of modern, widely supported codecs |
  | [hydrapaper](https://hydrapaper.gabmus.org/) | Allows for different images on multiple monitors |
  | [inkscape](https://inkscape.org/) | Tool to create vector images (Adobe Illustrator alternative) |
  | [kdenlive](https://kdenlive.org/en/features/) | Video editor |
  | [kid3-qt](https://kid3.kde.org/) | Audio tag editor (TagScanner alternative) |
  | [lolcat](https://github.com/busyloop/lolcat) | Add rainbow colors to text in CLI |
  | [meld](https://meldmerge.org/) | Visual fill diff tool |
  | [mkvtoolnix-gui](https://www.matroska.org/downloads/mkvtoolnix.html) | A set of tools to create, alter and inspect Matroska (mkv) & WebM files |
  | [okular](https://okular.kde.org/) | Universal document viewer (PDFs, etc.) |
  | [p7zip-full](https://p7zip.sourceforge.net/) | Adds 7zip binaries for CLI |
  | [peek](https://github.com/phw/peek) | Simple screen recorder with an easy to use interface. Captures a specific parts of the screen, and can output '.apng', '.gif', '.mp4', and '.webm' |
  | `python-is-python3` | This ensures the symlink for `python3` to `python` stays up to date during updates. |
  | [python3-notify2](https://pypi.org/project/notify2/) | Send Desktop notifications via Python |
  | [sayonara](https://sayonara-player.com/) | Music player |
  | [sddm](https://github.com/sddm/sddm) | A modern display manager for X11 and Wayland. ( Alternate DM than the default lightdm) |
  | [sddm-theme-breeze](https://packages.debian.org/sid/sddm-theme-breeze) | Clean centered theme with avatar |
  | [solaar](https://pwr-solaar.github.io/Solaar/) | Logitech unifying reciever peripherals manager for Linux |
  | [soundconverter](https://soundconverter.org/) | Converter for audio files |
  | [sticky](https://github.com/linuxmint/sticky) | Post-it note app for your Desktop |
  | [ttf-mscorefonts-installer](https://linuxhint.com/ttf-mscorefonts-installer/) | Installer for Microsoft TrueType core fonts. Needed to display fonts properly in browsers |
  | [vlc](https://www.videolan.org/vlc/) | Multimedia player |
  | [wireshark](https://www.wireshark.org/) (meta-package) | Network traffic sniffer |
  | [xclip](https://github.com/astrand/xclip) | Copy from CLI to clipboard |
  | [xserver-xorg-input-synaptics](https://packages.ubuntu.com/bionic/xserver-xorg-input-synaptics) | Enables smooth/inertial/kinetic scroll for touchpads on long documents/webpages (requires reboot) |
  
  | Package | Description |
  | ------- | ----------- |
  | [figlet](http://www.figlet.org/) | Generate text banners for CLI |
  | [obs-studio](https://obsproject.com/) (non-flatpak) | Record or stream video |
  | [pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/) | PulseAudio Volume Control |
  | [plasma-sdk](https://github.com/KDE/plasma-sdk) | Applications useful for Plasma development. I use it for Cuttlefish (an icon viewer) |
  | [sqlitebrowser](https://sqlitebrowser.org/) | A GUI based SQL toolkit |
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  Webcam apps may require a system reboot for them to work correctly.
</details>


### Via Flatpak

```sh
flatpak install flathub codes.merritt.FeelingFinder org.gimp.GIMP org.gimp.GIMP.Plugin.GMic org.gimp.GIMP.Plugin.LiquidRescale org.gimp.GIMP.Plugin.Resynthesizer
```

<details>
  <summary>Expand for Software Details</summary>
  
  List what's currently installed `flatpak list`.
  
  Search for packages with `flatpak search <PACKAGE>`, like `flatpak search org.gimp.GIMP.Plugin`.
  
  `bin` path for apps: `/var/lib/flatpak/exports/bin`.
  
  | Package | Software | Description |
  | ------- | -------- | ----------- |
  | [codes.merritt.FeelingFinder](https://flathub.org/apps/details/it.mijorus.smile) | Feeling Finder | Emoji picker |
  | [hu.irl.cameractrls](https://flathub.org/apps/details/hu.irl.cameractrls) | Camera Ctrls | Logi Tune alt for adjusting settings in Web apps |
  | [org.gimp.GIMP](https://flathub.org/apps/details/org.gimp.GIMP) | GIMP | Image editor (alternative to Adobe Photoshop) |
  | [org.gimp.GIMP.Plugin.GMic](https://gmic.eu/download.html) | G'MIC | A large set of filters |
  | [org.gimp.GIMP.Plugin.LiquidRescale](https://github.com/glimpse-editor/Glimpse/wiki/How-to-Install-the-Liquid-Rescale-Plugin#install-liquid-rescale-on-linux) | LiquidRescale | Scale an image, but don't scale selected items |
  | [org.gimp.GIMP.Plugin.Resynthesizer](https://github.com/bootchk/resynthesizer) | Resynthesizer | Content-aware removal of selected items |
</details>

<details>
  <summary>Expand for GIMP Tweaks</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) | Makes GIMP look like Photoshop |
  
  
  ```sh
  (
    mv ~/.config/GIMP/2.10 ~/.config/GIMP/2.10.bak
    wget "https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.by.Diolinux.v2020.1.for.Flatpak.zip" -O ~/Downloads/archives/PhotoGIMP_v2020.1.zip
    unzip ~/Downloads/archives/PhotoGIMP_v2020.1.zip -d ~/Downloads/archives/
    cd ~/Downloads/archives/PhotoGIMP.by.Diolinux.v2020.1.for.Flatpak
    rsync -r ./.local/share/applications/ ~/.local/share/applications/
    rsync --mkpath -r ./.local/share/icons/hicolor/ ~/.local/share/icons/hicolor/
    rsync -r ./.var/app/org.gimp.GIMP/config/GIMP/2.10 ~/.config/GIMP/
    cd ../ && rm -rf PhotoGIMP.by.Diolinux.v2020.1.for.Flatpak
  )
  ```
</details>

<details>
  <summary>Expand for FeelingFinder Tweaks</summary>
  
  Dunno how they came up with that name, but it doesn't cut it when searching in an App launcher.
  ```sh
  sudo vim /var/lib/flatpak/exports/share/applications/codes.merritt.FeelingFinder.desktop
  ```
  ```diff
  - Name=Feeling Finder
  + Name=Emoji Picker (Feeling Finder)
  + Keywords=Emoji;Picker;
  ```
</details>



### Via deb

```sh
(
  DEBS_DIR=~/Downloads/debs
  urls=(
    'https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/amd64/albert_0.17.6-0_amd64.deb'
    'https://github.com/sharkdp/bat/releases/download/v0.22.1/bat_0.22.1_amd64.deb'
    'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
    'https://discord.com/api/download?platform=linux&format=deb'
    'https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website'
    'https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb'
    'https://github.com/subhra74/snowflake/releases/download/v1.0.4/snowflake-1.0.4-setup-amd64.deb'
    'https://update.code.visualstudio.com/1.73.1/linux-deb-x64/stable'
    'https://torguard.net/downloads/new/torguard-latest-amd64.deb'
  )
  for url in "${urls[@]}"; do
    wget --content-disposition "${url}" -P "${DEBS_DIR}/"
  done
  
  sudo dpkg -i "${DEBS_DIR}/"*.deb
  sudo apt install -f -y
)
```

Optional
```
https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
```

<details>
  <summary>Expand for Software Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [Albert](https://albertlauncher.github.io/) | Launcher (alternative to Wox). In the Installing page look for look for the `OBS software repo` link for downloads. |
  | [bat](https://github.com/sharkdp/bat) | Like `cat`, but displays a limited amount of a file and with syntax highlighting |
  | [Chrome](https://www.google.com/chrome/) | Browser |
  | [Discord](https://discord.com/) | Group text/voice/video communication |
  | [Insomnia](https://insomnia.rest/) | API development |
  | [lsd](https://github.com/Peltoche/lsd) | A Deluxe version of the `ls` command |
  | [Snowflake](https://github.com/subhra74/snowflake) | SFTP Client (alternative to WinSCP) |
  | [TorGuard](https://torguard.net/downloads.php) | VPN client |
  | [VS Code](https://code.visualstudio.com/) | IDE, advanced text editor |
  
  | Software | Description |
  | -------- | ----------- |
  | [Steam](https://store.steampowered.com/) | PC Gaming platform |
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  To make Discord not prompt for updates all the time
  ```sh
  vim ~/.config/discord/settings.json
  
  # add:
  "SKIP_HOST_UPDATE": true
  ```
  
  TorGuard requires Wireguard `sudo apt install wireguard`
</details>


### Via Archives

```sh
(
  ARCH_DIR=~/Downloads/archives
  urls=(
    'https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz'
    'https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip'
    'https://github.com/godotengine/godot/releases/download/4.0-stable/Godot_v4.0-stable_linux.x86_64.zip'
    'https://www.blender.org/download/release/Blender3.4/blender-3.4.1-linux-x64.tar.xz/'
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
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  Have to run the install script for btop from within the directory
  ```sh
  (
    cd ~/.local/bin/btop/v1.2.13/btop/
    ./install.sh
  )
  ```
  
  Has to be executable to run
  ```sh
  chmod +x ~/.local/bin/jmkvpropedit/v1.5.2/JMkvpropedit.jar
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
</details>


### Via CLI

For packages that require more than a simple `apt install`.

**Docker**
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
Verify install
```sh
systemctl is-enabled docker
systemctl status docker
sudo docker run hello-world
```

**'n' NodeJS manager**  
May want to [verify this hasn't changed in the repo](https://github.com/tj/n#third-party-installers).
```sh
curl -L https://bit.ly/n-install | bash
```
The script will add an `export` line to your `.bashrc`. If you use another shell, copy that line to your `*rc` file and source your shell. Once that's done, you can choose and install the version of NodeJS that you want.
```sh
# list available versions to download
n ls-remote
# install your preferred version
n install 18
# Check version
node -v
```

**qemu**
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

Optional
```sh
(
  # ┎────────┒
  # ┃ lutris ┃
  # ┖────────┚
  sudo add-apt-repository -y ppa:lutris-team/lutris
  sudo apt update
  sudo apt install lutris
)
```

<details>
  <summary>Expand for Software Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [docker](https://www.docker.com/why-docker/) | Containerize environments |
  | [docker-compose](https://docs.docker.com/compose/) | Create config files for Docker containers |
  | [n](https://github.com/tj/n#third-party-installers) | NodeJS version management |
  | [qemu](https://www.qemu.org/) | A machine emulator and virtualizer |
  
  | Software | Description |
  | -------- | ----------- |
  | [lutris](https://lutris.net/) | Allows for playing games on Linux. Use to install [Origin](https://lutris.net/games/origin/) |
</details>

<details>
  <summary>Expand for Docker Notes</summary>
  
  The [instuctions for setting up the repo](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) are Ubuntu specific and call out `lsb_release -cs` which doesn't work on Mint. I created an alternative
  ```sh
  cat /etc/os-release | grep "UBUNTU_CODENAME" | sed "s|UBUNTU_CODENAME=||"
  ```
  I verified it was the correct name by going to https://download.docker.com/linux/ubuntu/dists/ to see the available names, and checking the Ubuntu releases https://wiki.ubuntu.com/Releases.
  
  [Docker Desktop](https://docs.docker.com/desktop/install/ubuntu/) now exists for Linux, but I've had issues with it:
  - Not being up-to-date
  - Trying to sell me something
  
  `docker-compose` has [been replaced](https://docs.docker.com/compose/compose-v2/) with `docker compose`. The new [compose spec](https://github.com/compose-spec/compose-spec/blob/master/spec.md) is more universal but it also deprecates some fields.
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
      sudo vim /etc/default/grub
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
sudo cp <CERT_NAME>.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
```
- In some cases, changes don't take effect right away and a restart may be required.
- In some cases a restart doesn't work, for example Browsers sometimes have their own certificate area where you have to manually add a cert. For example, in Chrome you can go to Settings > search for `cert` > click Security > click Manage Certificates > go to Authorities and add your cert.
<br>


If you have any back-ups of your keyrings, you'll need to install those especially if any Browsers have saved credentials locally and you're bringing those profiles over.  
- After initially copying over the `.local/share/keyrings` files, you'll need to open up the **System Monitor** and kill `gnome-keyring-daemon`.
   - If that doesn't work, then `systemctl --user stop gnome-keyring && systemctl --user start gnome-keyring`.
- Then open up **Passwords and Keys** and unlock the **Login** item. Then you can open up stuff like Chrome or anything that has locally saved passwords.
<br>


Control your monitor's temperature (limit blue light). For now `redshift` and `redshift-gtk` come pre-installed so just do the below.
```sh
# NOTE: This file could conflict with the 'qredshift' applet so just use 'Redshift'
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
</details>

<details>
  <summary>Expand for File Manager</summary>
  
  I've tried `dolphin`, `nemo`, and `thunar`.
  - `dolphin` had the benefit of natural sorting which all othe managers seem to lack currently, but it's slow to load and currently doesn't allow for excluding paths from thumbnail generation.
  - `nemo` ships with Cinnamon but it currently suffers from thumbnail generation issues (sometimes works, sometimes doesn't, or doesn't generate thumbs for all types).
  - `thunar` ships with XFCE. It's snappy, allows for **Custom Actions** via context menus that you can easily write yourself, and allows for defining rules for thumbnail generation.
  
  ---
  
  Install Thunar and dependencies
  ```sh
  (
    sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
    sudo apt update
    sudo apt install fsearch thunar thunar-archive-plugin tumbler-plugins-extra
  )
  ```
  
  Thunar uses `tumbler` for generating thumbnails. Most File Managers have options to not show thumbnails on network paths, but `cifs` mounts may not fall under that category even though they can be. This will instruct `tumbler` what paths to ignore in that case.
  ```sh
  (
    # Clear any generated thumbnails
    rm -rf  ~/.cache/thumbnails/*
    # Create rc file for tumbler
    mkdir ~/.config/tumbler
    cp /etc/xdg/tumbler/tumbler.rc ~/.config/tumbler
    # Exclude specific paths from having thumbnails generated
    vi ~/.config/tumbler/tumbler.rc
  )
  ```
  ```
  # Find all the instances of `Excludes=` and add the paths
  Excludes=<PATH1>;<PATH2>
  ```
  `tumblerd` can't be restarted so you have to log out/in
  
  ---
  
  Launch **FSearch**, go to:
  - `Edit > Preferences`
     ```
     [Database]
       (uncheck) Update database on start
       
       [Include]
         (add) /home/<USER>
     ```
  - `Search`
     ```
     (check) Search in Path
     (check) Match Case
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
  
  ```
  [Appearance]
    
    [Backgrounds]
      [Images]
        Vera > Sparkling
    
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
        Icons: Mint-Y-Legacy-Dark-Aqua
        Desktop: Mint-Y-Legacy-Dark-Aqua
        
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
        Lock keys indicator with notifications (betterlock)
        Weather
      
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
        
        [Grouped window list]
          [General]
            Group windows by applications: (uncheck)
          
          [Panel]
            Button label: Window title
            Show window count numbers: (uncheck)
            
        
        [Lock keys indicator with notifications]
          Show caps lock indicator: (checked)
          Show num lock indicator: (checked)
          
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
            Data service: OpenWeatherMap
            Forecast length (days): 7
          
          [Location]
            (add locations in Saved Locations)
            (get the lat/lon from Google Maps, just right-click it'll be the first item, you only need to the 6th decimal for each value)
            (for the City I went with '<CITY>, <ABBREVIATED_STATE>')
            (timezone America/Los_Angeles)
            (Once items are added you can click on the panel item, and at the top of the forecast there'll be a location with horizontal arrows. Click on an arrow to go to a saved location)
  
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
      Cairo-Dock (check)
      mintwelcome (uncheck)
      Print Queue Applet (uncheck)
      Redshift (check)
      Solaar (check)
      Support for NVIDIA Prime (uncheck)
    
    [Windows]
      [Alt-Tab]
        Alt-Tab switcher style: Icons and window preview  (the 3D options seem to cause screen freezing issues)
        Delay before displaying: 200  (when switching quickly, no need for extra overhead)
      
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
        Background: (choose image)
        GTK theme: Mint-Y-Legacy-Dark-Aqua
        Icon theme: Mint-Y-Legacy-Dark-Aqua
      
      [Users]
        Allow guest sessions: (checked)
  ```
</details>

<details>
  <summary>Expand for Albert Settings</summary>
  
  I use `QML Box Model` so that SVG icons show up clearly.
  ```
  ┎─────────┒
  ┃ General ┃
  ┖─────────┚
    Hot key: Ctrl+Space
    Frontend: QML Box Model
    Terminal: Tilix
    Autostart on login: (checked)
    Style: BoxModel (click the button next to it)
      item_title_fontsize: 30
      item_description_fontsize: 20
      font_name: Ubuntu Mono
    Apply theme: DarkMagenta
    Display scrollbar: (check)
  
  ┎────────────┒
  ┃ Extensions ┃
  ┖────────────┚
    [X] Applications
    [X] WebSearch
  ```
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
  
  Had an issue where Cairo wasn't using my default File Manager to open folders. It must be caching it somewhere because after I went into Default Applications, and changed my File Manager to something else, and then back to what I wanted, it started behaving.
</details>

<details>
  <summary>Expand for Grub Settings</summary>
  
  You can use **Grub Customizer** or CLI
  ```sh
  sudo vim /etc/default/grub
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
        (tick) Mint-Y-Dark
    
    [Playlist]
      [Behavior]
        Start up:
          (tick) Load temporary playlists
          (tick) Load last track on startup
          (tick) Remember time of last track
      
      [Look]
        (tick) Show footer
        (untick) Show numbers
        (tick) Show covers
        Custom font color in dark theme: #2ad8ff
        Playlist item text: %nr% - %title%
      
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
  
  You can test the theme via: `sddm-greeter --test-mode --theme /usr/share/sddm/themes/breeze`. If there are errors, you may want to pick a different theme.
  
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
  sudo vim /usr/share/sddm/scripts/Xsetup
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
  
  Preferences
  ```
  [General]
    Tray icon: (checked)
    Show the main window automatically: (unchecked)
  
  [Automatic start]
    Start automatically: (checked)
    Show notes on the screen: (checked)
  ```
  
  Fix [issue when copying and pasting text results in jumbled paste](https://github.com/linuxmint/sticky/issues/80)
  - Download https://github.com/linuxmint/sticky/releases/download/master.mint21/packages.tar.gz
  - Re-install with unzipped `.deb`.
</details>

<details>
  <summary>Expand for VLC Settings</summary>
  
  Download custom skin (I've stopped doing this because the skins don't always behave. Leaving for reference.)
  ```sh
  mkdir ~/.config/vlc/skins
  wget http://www.videolan.org/vlc/download-skins2-go.php?url=subX.vlt -O ~/.config/vlc/skins/
  ```
  
  Preferences
  ```
  ┎───────────┒
  ┃ Interface ┃
  ┖───────────┚
    Use custom skin: ~/.config/vlc/skins/subX.vlt

  ┎───────┒
  ┃ Video ┃
  ┖───────┚
    Video snapshots
      Directory: ~/Pictures/vlc
      Format: jpg
  ```
</details>

<details>
  <summary>Expand for VS Code Settings</summary>
  
  Extensions:
  - Ascii Tree Generator https://marketplace.visualstudio.com/items?itemName=aprilandjan.ascii-tree-generator
  - All Autocomplete https://marketplace.visualstudio.com/items?itemName=Atishay-Jain.All-Autocomplete
     - VSCode has the built-in `Word Based Suggestions` but it's not smart enough to handle variable suggestions during a destructured `import` if the variable is assigned to an Object.
  - Alphabetical Sorter https://marketplace.visualstudio.com/items?itemName=ue.alphabetical-sorter
  - Auto-Rename Tag https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag
  - Base IDE https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode
  - Blueprint https://marketplace.visualstudio.com/items?itemName=teamchilla.blueprint
  - Change-case https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case
  - dotenv https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv
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
  - One Dark Pro theme https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme
  - Partial Diff https://marketplace.visualstudio.com/items?itemName=ryu1kn.partial-diff
  - select highlight in minimap https://marketplace.visualstudio.com/items?itemName=mde.select-highlight-minimap
  - Sort Lines https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines
  - Svelte for VS Code https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode
  - SVG Previewer https://marketplace.visualstudio.com/items?itemName=vitaliymaz.vscode-svg-previewer
  - Toggle Quotes https://marketplace.visualstudio.com/items?itemName=BriteSnow.vscode-toggle-quotes
  - VS DocBlockr https://marketplace.visualstudio.com/items?itemName=jeremyljackson.vs-docblock

  If things aren't behaving as expected after installing extensions (like config pages not loading), run `CTRL+SHIFT+P > Reload Window`.
  app
  Settings:
  - View > Appearance > Secondary Side Bar
     - Go the Explorer view > (add) Open Editors
        - Move Open Editors to the Secondary Side Bar
  - File > Preferences > Settings > User (or `CTRL + ,`)
     ```
     All Autocomplete: Max Items in Single List: 10
     All Autocomplete: Min Word Length: 5
     All Autocomplete: Show Current Document: (uncheck)
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
     SCM: Default View Mode: tree
     Search: Use Global Ignore Files: (check)
     Telemetry: Telemetry Level: off
     Terminal > Integrated: Font Family: FantasqueSansMono NF
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
   sudo vim /etc/default/grub
   ```
   ```diff
   - GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash loglevel=3"
   + GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3"
   ```
   ```sh
   sudo update-grub
   ```

---

## Back Up or Restore Data

I've created a couple helper scripts. One that generates a list of paths and files ([backup-list.sh](./bin/backup-list.sh)), and the other creates an archive based on the list ([backup.sh](./bin/backup.sh)).

Set up the script by adding an alias to your `*.rc` file
```sh
alias bup="<PATH_TO_REPO>/distro/mint-cinnamon/bin/backup.sh"
alias createbup='bup -c -f "$(${HOME}/<PATH_TO_REPO>/distro/mint-cinnamon/bin/backup-list.sh)"'
```
Backups will be output to the Desktop unless otherwise specified. Run `bup -h` for script options.

Restore a backup with
```sh
bup -r "<PATH_TO_BACKUP>"
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

- [Icon Theme Spec](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html)
- [Icon Naming Spec](https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html)
- Global icons (usually used by themes) are in `/usr/share/icons/<THEME>/<TYPE>/<SIZE>/`. So if there's an icon you like, but you want to modify it, that's where it may be.

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

**Issue: System going to sleep after a few seconds on the Login screen**
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

**Issue: Kernel Panic error after choosing "recommended" nvidia driver**
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

**Issue: "error: out of memory" on boot right after grub menu**
<details>
  <summary>Expand for Solution</summary>
  
  Seems to be linked to using nvidia drivers https://bugs.launchpad.net/oem-priority/+bug/1842320.
  Add this to your Grub config, save and reboot.
  ```
  GRUB_GFXMODE=640x360
  ```
  
  If that doesn't work, I also purged all nvidia packages via Synaptic Package Manager. Had to manually find all `nvidia` packages with a `version` matching what was installed. Rebooted, and the system should now be using the `nouveau` driver. Use Driver Manager to install the `nvidia` driver again.
</details>

**Issue: Chrome Saved Passwords Not Showing Up in Settings**
<details>
  <summary>Expand for Solution</summary>
  
  First, close Chrome while you're troubleshooting.
  
  Possible reasons for this:
  1. The `Login Data` file is missing from `~/.config/google-chrome/<Default|Profile>/` or it's read/write protected. Look at the other file permissions in a folder you haven't touched, and copy those. 
  1. The passwords in the database (`Login Data` is a sqlite3 file) were encoded with a system key that aren't on your new system. It should be stored in `~/.local/share/keyrings`.
  1. There's a corrupted value in `Login Data`. If Chrome can't read a value, it automatically considers everything broken and won't display anything. If you run [fix-chrome-creds.py](./bin/fix-chrome-creds.py) it'll create a fixed file on your desktop, and output all the values so you can see what may be broken, or worse case manually input the passwords. Example `./bin/fix-chrome-creds.py -f "~/.config/google-chrome/<PROFILE>/Login Data" -p "<KEY>"`. `<KEY>` would come from `Passwords and Keys > Login > Chrome Safe Storage`.
</details>

**Issue: How to Free Up Space?**
<details>
  <summary>Expand for Solution</summary>
  
  ```sh
  # There could be other folders in `.cache` that you may want to investigate.
  # Deleting folders or their contents while certain Apps are running could cause issues.
  rm -rf  ~/.cache/{thumbnails}/*
  ```
</details>

**Issue: PulseAudio Volume Notification Keeps Popping Up**
<details>
  <summary>Expand for Solution</summary>
  
  First you can debug Pulse's logs:
  ```sh
  systemctl --user stop pulseaudio.{socket,service}
  # Terminal #1
  LANG=C pulseaudio -vvvv --log-time=1 > ~/Desktop/pulseverbose.log 2>&1
  # Terminal #2 (or just stop the above process when you see the notification pop up)
  tail -f ~/Desktop/pulseverbose.log
  ```
  Most forums date this back to a long-standing issue with it detecting that the headphone jack is plugged in then unplugged. Sure enough I was seeing these random messages:
  ```
  [pulseaudio] module-alsa-card.c: Jack 'Headphone Jack' is now plugged in
  ```
  
  ```sh
  # stop the currently running service
  systemctl --user stop pulseaudio.{socket,service}
  # edit pulse's config
  sudo vim /etc/pulse/default.pa
  ```
  ```
  # Disable the below line
  load-module module-switch-on-port-available
  ```
  ```sh
  # start the service
  systemctl --user start pulseaudio.{socket,service}
  ```
  What the modules do:
  - `on-port-available` is the event that a port becomes usable, for example when you insert a mini jack.
  - `on-connect` is the event that a new device is connected which has an audio port, such as a usb dock.
  
  ---
  
  **NOTE: Turns out the below didn't work**. Pipewire didn't help at all, in fact it kept crashing after extended use. Keeping this here in case I need it in the future.
  
  Change from PulseAudio to Pipewire by [following these instructions](https://trendoceans.com/enable-pipewire-and-disable-pulseaudio-in-ubuntu/).
  ```sh
  # First check and see if it's already installed and running
  systemctl --user status pipewire pipewire-session-manager
  
  # If it's not installed
  sudo apt install pipewire
  # Install audio client and some libs
  sudo apt install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}
  # Install WirePlumber
  sudo apt install wireplumber gir1.2-wp-0.4 libwireplumber-0.4-{0,dev}
  
  # Kill PulseAudio
  systemctl --user --now disable pulseaudio.{socket,service}
  systemctl --user mask pulseaudio
  
  # Copy over Pipewire configs
  sudo cp -vRa /usr/share/pipewire /etc/
  
  # Start up Pipewire
  systemctl --user --now enable pipewire{,-pulse}.{socket,service}
  
  # Your system may require a log-off/in, or a reboot
  ```
  If you need/want Pipewire's equivelant to PulseEffects
  ```sh
  flatpak install flathub com.github.wwmm.easyeffects
  ```
</details>

**Issue: File Managers randomly freeze when transfering CIFS files**
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

**Issue: System Freezes/Locks When Entering Suspend**
<details>
  <summary>Expand for Solution</summary>
  
  - Went into **Update Manager** > View > Linux Kernels > chose the oldest in the available `5.15` series (`5.15.0-25`). Waited for it to install, rebooted, used the Grub menu during boot to choose the older kernel. Tested suspend and logging out/in and things seem to be working now.
  - To ensure it doesn't boot to the bad kernel:
     - Launch **Update Manager** > View > Linux Kernels. Click on the bad installed kernel, click `Remove`.
     - That kernel probably just popped up in the Update Manager as an available update. Right-click it and choose `Ignore the current update for this package`. If you mistakenly ignored the wrong package, go into Edit > Preferences > Blacklist, and remove what you ignored.
  
  If the need to manually download and add an older kernal arise: https://askubuntu.com/a/700221
</details>

**Issue: Can't Boot Past Grub Menu**
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
     sudo vim /etc/resolv.conf
       # add
       nameserver 8.8.8.8
     
     # if mirrors are out of date
     sudo vim /etc/apt/sources.list.d/official-packages-repositories.list
     
     # patch initramfs to keep it's file size down (fix 'out of memory')
     sudo vim /etc/initramfs-tools/initramfs.conf
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

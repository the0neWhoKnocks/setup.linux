# Mint

- [Pre-Install](#pre-install)
- [Install](#install)
- [Initial Boot](#initial-boot)
- [Create Common Directories](#create-common-directories)
- [Don't Require Password for Sudo](#dont-require-password-for-sudo)
- [Install Base Software](#install-base-software)
- [Clone This Repo](#clone-this-repo)
- [Set Up Shell](#set-up-shell)
- [Set Up Shares](#set-up-shares)
- [Install Software](#install-software)
   - [Via Software Manager or CLI](#via-software-manager-or-cli)
   - [Via Flatpak](#via-flatpak)
   - [Via deb](#via-deb)
   - [Via Archives](#via-archives)
   - [Via CLI](#via-cli)
- [Configure Software](#configure-software)
- [Back Up or Restore Data](#back-up-or-restor-data)
- [Troubleshooting](#Troubleshooting)

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

System Reports may prompt to install things like GPU drivers and language packs. If it doesn't (it's set to wait 40 seconds after login), launch the Driver Manager, see if there's a "recommended" one like `nvidia-driver-515` (just make sure it matches your kernel number `uname -r`).

Open the **Update Manager**, if there are updates for the GPU driver or kernel, install them.

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
  
  https://gist.github.com/the0neWhoKnocks/ece1903a179aeb16619768ba44570abe#vimrc
</details>

---

## Clone This Repo

This is only required if you want to use the helper scripts.

```sh
cd ~/Projects/Code/Scripts && git clone git@github.com:the0neWhoKnocks/setup.linux.git && cd setup.linux/distro/mint
```

---

## Set Up Shell

Install oh-my-zsh, plugins, and my custom theme
```sh
./bin/set-up-zsh.sh
```

<details>
  <summary>Expand for Tilix Settings</summary>
  
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

## Set Up Shares

Only required if you need access to a network share.

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

### Via Software Manager or CLI

```sh
sudo add-apt-repository ppa:alex-p/aegisub
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo add-apt-repository ppa:kdenlive/kdenlive-stable
sudo apt update
sudo apt install -y aegisub cairo-dock cairo-dock-gnome-integration-plug-in chromium elisa flameshot grub-customizer handbrake inkscape kdenlive kid3-qt lolcat meld mkvtoolnix-gui okular pavucontrol peek plasma-sdk pulseeffects sddm sddm-theme-breeze soundconverter ttf-mscorefonts-installer vlc wireshark xclip xserver-xorg-input-synaptics

# optional
sudo apt install -y figlet obs-studio
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
  | [chromium](https://www.chromium.org/getting-involved/download-chromium/) | Browser without all the Chrome overhead |
  | [elisa](https://invent.kde.org/multimedia/elisa) | Music player |
  | [flameshot](https://flameshot.org/) | Swiss army knife of screenshot tools |
  | [grub-customizer](https://launchpad.net/grub-customizer) | Easily change and compile grub config |
  | [handbrake](https://handbrake.fr/) | Tool for converting video from nearly any format to a selection of modern, widely supported codecs |
  | [inkscape](https://inkscape.org/) | Tool to create vector images (Adobe Illustrator alternative) |
  | [kdenlive](https://kdenlive.org/en/features/) | Kdenlive | Video editor |
  | [kid3-qt](https://kid3.kde.org/) | Audio tag editor (TagScanner alternative) |
  | [lolcat](https://github.com/busyloop/lolcat) | Add rainbow colors to text in CLI |
  | [meld](https://meldmerge.org/) | Visual fill diff tool |
  | [mkvtoolnix-gui](https://www.matroska.org/downloads/mkvtoolnix.html) | A set of tools to create, alter and inspect Matroska (mkv) & WebM files |
  | [okular](https://okular.kde.org/) | Universal document viewer (PDFs, etc.) |
  | [pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/) | PulseAudio Volume Control |
  | [peek](https://github.com/phw/peek) | Simple screen recorder with an easy to use interface. Captures a specific parts of the screen, and can output '.apng', '.gif', '.mp4', and '.webm' |
  | [plasma-sdk](https://github.com/KDE/plasma-sdk) | Applications useful for Plasma development. I use it for Cuttlefish (an icon viewer) |
  | [pulseeffects](https://github.com/wwmm/easyeffects) | Equalizer for PulseAudio |
  | [sddm](https://github.com/sddm/sddm) | A modern display manager for X11 and Wayland. ( Alternate DM than the default lightdm) |
  | [sddm-theme-breeze](https://packages.debian.org/sid/sddm-theme-breeze) | Clean centered theme with avatar |
  | [soundconverter](https://soundconverter.org/) | Converter for audio files |
  | [ttf-mscorefonts-installer](https://linuxhint.com/ttf-mscorefonts-installer/) | Installer for Microsoft TrueType core fonts. Needed to display fonts properly in browsers |
  | [vlc](https://www.videolan.org/vlc/) | Multimedia player |
  | [wireshark](https://www.wireshark.org/) (meta-package) | Network traffic sniffer |
  | [xclip](https://github.com/astrand/xclip) | Copy from CLI to clipboard |
  | [xserver-xorg-input-synaptics](https://packages.ubuntu.com/bionic/xserver-xorg-input-synaptics) | Enables smooth/inertial/kinetic scroll on long documents/webpages (requires reboot) |
  
  | Package | Description |
  | ------- | ----------- |
  | [figlet](http://www.figlet.org/) | Generate text banners for CLI |
  | [obs-studio](https://obsproject.com/) (non-flatpak) | Record or stream video |
</details>


### Via Flatpak

```sh
flatpak install flathub io.atom.Atom io.bassi.Amberol org.gimp.GIMP org.gimp.GIMP.Plugin.GMic org.gimp.GIMP.Plugin.LiquidRescale org.gimp.GIMP.Plugin.Resynthesizer
```

<details>
  <summary>Expand for Software Details</summary>
  
  List what's currently installed `flatpak list`.
  
  Search for packages with `flatpak search <PACKAGE>`, like `flatpak search org.gimp.GIMP.Plugin`.

  | Package | Software | Description |
  | ------- | -------- | ----------- |
  | [io.atom.Atom](https://atom.io/) | Atom | Hackable text editor |
  | [io.bassi.Amberol](https://flathub.org/apps/details/io.bassi.Amberol) | Amberol | Simple music player |
  | [org.gimp.GIMP](https://flathub.org/apps/details/org.gimp.GIMP) | GIMP | Image editor (alternative to Adobe Photoshop) |
  | [org.gimp.GIMP.Plugin.GMic](https://gmic.eu/download.html) | G'MIC | A large set of filters |
  | [org.gimp.GIMP.Plugin.LiquidRescale](https://github.com/glimpse-editor/Glimpse/wiki/How-to-Install-the-Liquid-Rescale-Plugin#install-liquid-rescale-on-linux) | LiquidRescale | Scale an image, but don't scale selected items |
  | [org.gimp.GIMP.Plugin.Resynthesizer](https://github.com/bootchk/resynthesizer) | Resynthesizer | Content-aware removal of selected items |
</details>

<details>
  <summary>Expand for Atom Notes</summary>
  
  With the sun-setting of Atom, the `.deb` has become unreliable so I've switched to flatpak.
  
  To be able to run from CLI more easily, create an alias in your *rc file
  ```
  alias atom="flatpak run io.atom.Atom"
  ```
  
  The backup paths are
  ```
  ~/.var/app/io.atom.Atom/data/
    packages
    config.json
    keymap.cson
    snippets.cson
    styles.less
  ```
</details>

<details>
  <summary>Expand for GIMP Settings</summary>
  
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


### Via deb

```sh
(
  DEBS_DIR=~/Downloads/debs
  urls=(
    'https://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_22.04/amd64/albert_0.17.6-0_amd64.deb'
    'https://github.com/sharkdp/bat/releases/download/v0.22.1/bat_0.22.1_amd64.deb'
    'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
    'https://discord.com/api/download?platform=linux&format=deb'
    'https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website'
    'https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb'
    'https://github.com/subhra74/snowflake/releases/download/v1.0.4/snowflake-1.0.4-setup-amd64.deb'
  )
  for url in "${urls[@]}"; do
    wget "${url}" -P "${DEBS_DIR}/"
  done
  
  sudo dpkg -i "${DEBS_DIR}/"*.deb
  sudo apt install -f
)

# optional URLs
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
  
  | Software | Description |
  | -------- | ----------- |
  | [Steam](https://store.steampowered.com/) | PC Gaming platform |
</details>


### Via Archives

```sh
(
  ARCH_DIR=~/Downloads/archives
  urls=(
    'https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz'
    'https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip'
  )
  for url in "${urls[@]}"; do
    wget --no-clobber "${url}" -P "${ARCH_DIR}/"
    file="$(basename "${url}")"
    version="$(basename $(dirname "${url}"))"
    pkg="$(echo "${file}" | awk -F '[-_]' -v name=1 '{print $name}')"
    outputPath="${HOME}/Software/${pkg}/${version}/"
    mkdir -p "${outputPath}"
    
    if [[ "${file}" == *.zip ]]; then
      unzip "${ARCH_DIR}/${file}" -d "${outputPath}"
    else
      tar --strip 1 --extract --file "${ARCH_DIR}/${file}" --directory="${outputPath}"
    fi
  done
)

# optional
https://www.blender.org/download/release/Blender3.3/blender-3.3.1-linux-x64.tar.xz
https://downloads.tuxfamily.org/godotengine/3.5.1/Godot_v3.5.1-stable_x11.64.zip
```

<details>
  <summary>Expand for Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [btop](https://github.com/aristocratos/btop) | Resource monitor that shows usage and stats for processor, memory, disks, network and processes |
  | [jmkvpropedit](https://github.com/BrunoReX/jmkvpropedit) | A batch GUI for mkvpropedit. Allows for editing headers of multiple mkv files |
  
  | Software | Description |
  | -------- | ----------- |
  | [Blender](https://www.blender.org) | 3D asset creation |
  | [godot](https://godotengine.org/) | Game engine |
</details>

<details>
  <summary>Expand for Tweaks</summary>
  
  ```sh
  # have to run the install script for btop from within the directory
  cd ~/Software/btop/v1.2.13/
  ./install.sh
  ```
  
  ```sh
  # make it executable to run
  chmod +x ~/Software/jmkvpropedit/v1.5.2/JMkvpropedit.jar
  ```
</details>


### Via CLI

```sh
# ┎────────┒
# ┃ Docker ┃
# ┖────────┚
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(cat /etc/os-release | grep "UBUNTU_CODENAME" | sed "s|UBUNTU_CODENAME=||") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
# Verify install
systemctl is-enabled docker
systemctl status docker
sudo docker run hello-world

# ┎────────────────────┒
# ┃ 'n' NodeJS manager ┃
# ┖────────────────────┚
curl -L https://bit.ly/n-install | bash
# The script will add an `export` line to your .bashrc. If you use another shell, copy that line to your *rc file and source your shell. 
n ls-remote # list available versions to download
n install 16
# Check version
node -v

# ┎──────┒
# ┃ qemu ┃
# ┖──────┚
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo adduser $USER libvirt && sudo adduser $USER kvm && sudo adduser $USER libvirt-qemu
# You'll have to log out/in for it to work with your current user, but you can test with
sudo virt-manager

# Optional ─────────────────────────────────────────────────────────────────────

# ┎────────┒
# ┃ lutris ┃
# ┖────────┚
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris
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
```
<br>

<details>
  <summary>Expand for Desktop Settings</summary>

  Right-click &gt; Customize

  Use the sliders on the bottom and side to change how icons are spaced. I usually reset both to zero, and do one tick over for the bottom, and two for the right slider.
</details>

<details>
  <summary>Expand for System Settings</summary>

  ```
  ┎─────────────────┒
  ┃ Account Details ┃
  ┖─────────────────┚
    Picture: (choose avatar)
    Name: (change to a preferred display name)
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎─────────┒
  ┃ Applets ┃
  ┖─────────┚
    ┎──────────┒
    ┃ Download ┃
    ┖──────────┚
      CinnVIIStartMenu
      Lock keys indicator with notifications
      QRedShift
    
    ┎────────┒
    ┃ Manage ┃
    ┖────────┚
      (select and Add the downloaded items)
      (disable the Menu applet, and replace it with CinnVIIStartMenu by going into 'Panel edit mode' in the taskbar)
      
      ┎──────────┒
      ┃ Calendar ┃
      ┖──────────┚
        Use a custom date format: (checked)
        Date format: %b. %e 【%a.】【%l: %M %p】
      
      ┎──────────────────┒
      ┃ CinnVIIStartMenu ┃
      ┖──────────────────┚
        [Menu]
          Menu layout: MATE-Menu
        
        [Panel]
          Use a custom icon and label: (checked)
          Icon: linuxmint-logo-simple-symbolic
          Text: enu
        
        [Sidebar]
          Separator below user account info box: (checked)
      
      ┎────────────────────────────────────────┒
      ┃ Lock keys indicator with notifications ┃
      ┖────────────────────────────────────────┚
        Show caps lock indicator: (checked)
        Show num lock indicator: (checked)
        
      ┎───────────────┒
      ┃ Notifications ┃
      ┖───────────────┚
        Show empty tray: (checked)
        
      ┎───────────┒
      ┃ QRedShift ┃
      ┖───────────┚
        [Settings]
          [Day Settings]
            Temperature (K): 4500
            Brightness: 70
            Gamma: 1.00
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎────────────────┒
  ┃ Font Selection ┃
  ┖────────────────┚
    Default font: Ubuntu Regular 12
    Desktop font: Ubuntu Bold 12
    Document font: Sans Regular 12
    Monospace font: Monospace Regular 12
    Window title font: Ubuntu Medium 12
    Text scaling factor: 1.0
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎─────────────┒
  ┃ Hot Corners ┃
  ┖─────────────┚
    Enable top left: Show the desktop
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎──────────────┒
  ┃ Login Window ┃
  ┖──────────────┚
    ┎────────────┒
    ┃ Appearance ┃
    ┖────────────┚
      Background: (choose image)
      Icon theme: Mint-Y-Dark-Aqua
    
    ┎───────┒
    ┃ Users ┃
    ┖───────┚
      Allow guest sessions: (checked)
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎────────────────────┒
  ┃ Mouse and Touchpad ┃
  ┖────────────────────┚
    ┎──────────┒
    ┃ Touchpad ┃
    ┖──────────┚
      Click actions: Use multiple fingers for right and middle click
      Reverse scrolling direction: (uncheck)
      Speed: Roughly 65%
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎──────────────────┒
  ┃ Power Management ┃
  ┖──────────────────┚
    ┎───────┒
    ┃ Power ┃
    ┖───────┚
      Turn off the screen when inactive for:  15 minutes | 15 minutes
      Suspend when inactive for:                   Never | Never
      When the lid is closed:                 Do Nothing | Suspend
  
  ──────────────────────────────────────────────────────────────────────────────
  
  ┎────────┒
  ┃ Themes ┃
  ┖────────┚
    ┎────────┒
    ┃ Themes ┃
    ┖────────┚
      Icons: Mint-Y-Dark-Aqua
      Applications: Mint-Y-Dark-Aqua
      Mouse Pointer: DMZ-White
      Desktop: Mint-Y-Dark-Aqua
      
    ┎──────────┒
    ┃ Settings ┃
    ┖──────────┚
      Jump to position when clicking in a trough: (checked)
    
  ──────────────────────────────────────────────────────────────────────────────
    
  ┎─────────┒
  ┃ Windows ┃
  ┖─────────┚
    ┎─────────┒
    ┃ Alt-Tab ┃
    ┖─────────┚
      Alt-Tab switcher style: Coverflow (3D)
  ```
</details>

<details>
  <summary>Expand for Albert Settings</summary>
  
  ```
  ┎─────────┒
  ┃ General ┃
  ┖─────────┚
    Hot key: Ctrl+Space
    Terminal: Tilix
    Autostart on login: (checked)
    Theme: Dark Magenta
  
  ┎────────────┒
  ┃ Extensions ┃
  ┖────────────┚
    [X] Applications
    [X] WebSearch
  ```
</details>

<details>
  <summary>Expand for Cairo-Dock Settings</summary>
  
  To have it start on boot go into **Startup Applications**. `Add > Choose Applications > pick Cairo-Dock`.
  
  In order to add launchers to the dock, I go into the taskbar menu and search for the application. Once I find the application you can sometimes just drag it right to the dock, but more often than not I just right-click the app and choose `Add to desktop`. Then I can drag that launcher to the dock.
  
  Note that when a launcher is added to the dock, a copy of it is added to `~/.config/cairo-dock/current_theme/launchers`. So if a launcher needs to be updated, I'll generally just delete it and add the new one, but you can go in and manually edit the launcher in that folder.
  
  When manually creating a launcher I look to see if there's a good system icon via Cuttlefish instead of pointing to an image. Some apps like system binaries may not have an icon, so I created a folder in `~/Pictures/app-icons` to house custom icons.
</details>

<details>
  <summary>Expand for Certificates</summary>
  
  In order to add your own self-signed certs
  ```sh
  sudo apt-get install -y ca-certificates
  sudo cp <CERT_NAME>.crt /usr/local/share/ca-certificates
  sudo update-ca-certificates
  ```
  
  - In some cases, changes don't take effect right away and a restart may be required.
  - In some cases a restart doesn't work, for example Browsers sometimes have their own certificate area where you have to manually add a cert. For example, in Chrome you can go to Settings > search for `cert` > click Security > click Manage Certificates > go to Authorities and add your cert.
</details>

<details>
  <summary>Expand for Grub Settings</summary>
  
  You can use **Grub Customizer** or CLI
  ```sh
  sudo vim /etc/default/grub
  # Decrease duration that grub menu displays: `GRUB_TIMEOUT=2`
  
  sudo update-grub
  ```
</details>

<details>
  <summary>Expand for LSD Settings</summary>
  
  ```sh
  mkdir -p ~/.config/lsd
  vim ~/.config/lsd/config.yaml
  ```
  ```yaml
  # == Classic ==
  # This is a shorthand to override some of the options to be backwards compatible
  # with `ls`. It affects the "color"->"when", "sorting"->"dir-grouping", "date"
  # and "icons"->"when" options.
  # Possible values: false, true
  classic: false

  # == Blocks ==
  # This specifies the columns and their order when using the long and the tree
  # layout.
  # Possible values: permission, user, group, size, size_value, date, name, inode
  blocks:
    - permission
    - user
    - group
    - size
    - date
    - name

  # == Color ==
  # This has various color options. (Will be expanded in the future.)
  color:
    # When to colorize the output.
    # When "classic" is set, this is set to "never".
    # Possible values: never, auto, always
    when: auto
    # How to colorize the output.
    # When "classic" is set, this is set to "no-color".
    # Possible values: default, <theme-file-name>
    # when specifying <theme-file-name>, lsd will look up theme file
    # XDG Base Directory if relative, e.g. ~/.config/lsd/themes/<theme-file-name>.yaml,
    # The file path if absolute
    theme: default

  # == Date ==
  # This specifies the date format for the date column. The freeform format
  # accepts an strftime like string.
  # When "classic" is set, this is set to "date".
  # Possible values: date, relative, '+<date_format>'
  # `date_format` will be a `strftime` formatted value. e.g. `date: '+%d %b %y %X'` will give you a date like this: 17 Jun 21 20:14:55
  # Format cheatsheet: https://strftime.org/
  date: '+%Y/%m/%d'

  # == Dereference ==
  # Whether to dereference symbolic links.
  # Possible values: false, true
  dereference: false

  # == Display ==
  # What items to display. Do not specify this for the default behavior.
  # Possible values: all, almost-all, directory-only
  # display: all

  # == Icons ==
  icons:
    # When to use icons.
    # When "classic" is set, this is set to "never".
    # Possible values: always, auto, never
    when: auto
    # Which icon theme to use.
    # Possible values: fancy, unicode
    theme: fancy
    # Separator between icon and the name
    # Default to 1 space
    separator: ' '


  # == Ignore Globs ==
  # A list of globs to ignore when listing.
  # ignore-globs:
  #   - .git

  # == Indicators ==
  # Whether to add indicator characters to certain listed files.
  # Possible values: false, true
  indicators: false

  # == Layout ==
  # Which layout to use. "oneline" might be a bit confusing here and should be
  # called "one-per-line". It might be changed in the future.
  # Possible values: grid, tree, oneline
  layout: oneline

  # == Recursion ==
  recursion:
    # Whether to enable recursion.
    # Possible values: false, true
    enabled: false
    # How deep the recursion should go. This has to be a positive integer. Leave
    # it unspecified for (virtually) infinite.
    # depth: 3

  # == Size ==
  # Specifies the format of the size column.
  # Possible values: default, short, bytes
  size: default

  # == Sorting ==
  sorting:
    # Specify what to sort by.
    # Possible values: extension, name, time, size, version
    column: name
    # Whether to reverse the sorting.
    # Possible values: false, true
    reverse: false
    # Whether to group directories together and where.
    # When "classic" is set, this is set to "none".
    # Possible values: first, last, none
    dir-grouping: first

  # == No Symlink ==
  # Whether to omit showing symlink targets
  # Possible values: false, true
  no-symlink: false

  # == Total size ==
  # Whether to display the total size of directories.
  # Possible values: false, true
  total-size: false

  # == Symlink arrow ==
  # Specifies how the symlink arrow display, chars in both ascii and utf8
  symlink-arrow: ⇒
  ```
</details>

<details>
  <summary>Expand for Nemo Settings</summary>
  
  Preferences
  ```
  ┎───────┒
  ┃ Views ┃
  ┖───────┚
    View new folders using: List View
    Sort favorites before other files: (uncheck)
    Default Zoom Level: (change all to) 66%
    Tree View Defaults: (uncheck) Show only folders
  
  ┎──────────┒
  ┃ Behavior ┃
  ┖──────────┚
    Click on a file's name twice to rename it: (check)
    Automatically close the device's tab, pane, or window when a device is unmounted or ejected: (check)
  
  ┎─────────┒
  ┃ Display ┃
  ┖─────────┚
    Show advanced permissions in the file property dialog: (check)
  
  ┎─────────┒
  ┃ Toolbar ┃
  ┖─────────┚
    (check) Refresh
    (check) Open in Terminal
    (check) New folder
    (check) Show Thumbnails
  
  ┎───────────────┒
  ┃ Context Menus ┃
  ┖───────────────┚
    [Selection]
      (check) Make Link
      (check) Copy to
      (check) Move to
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
  <summary>Expand for SDDM Settings</summary>
  
  To configure the theme, create a custom config for sddm:
  ```sh
  sudo mkdir -p /etc/sddm.conf.d
  sudo vim /etc/sddm.conf.d/10-custom.conf
  ```
  ```
  [General]
  Numlock=on
  
  [Theme]
  Current=breeze
  ```
  and then a custom config for the theme:
  ```sh
  sudo vim /usr/share/sddm/themes/breeze/theme.conf.user
  ```
  ```
  [General]
  background=/usr/share/wallpapers/Digital Stream Vanessa/contents/images/5034x2832.jpg
  ```
  
  You can test the theme via: `sddm-greeter --test-mode --theme /usr/share/sddm/themes/breeze`. If there are errors, you may want to pick a different theme.
  
  The backgrounds for a theme are set in `/usr/share/sddm/themes/<THEME>/theme.conf` on the `background=` line.
  Generally themes point to the global wallpapers so an image can be displayed for any user. Those wallpapers are in `/usr/share/wallpapers`.
  To more easily view all wallpapers I open that directory with a file manager, and do a search for `screenshot.jpg`, then I can just browse through the results, and find the path for the wallpaper I want.
  Once you have a wallpaper you like, create/update your config's background line, and you'll see the new image after a reboot. Note that you'll see your User wallpaper on the lock screen.
  
  If your user icon isn't showing up, look in `/var/lib/AccountsService/icons/` and see if an icon exists with your user name. If not, try picking and choosing an icon again from **Account Details**.
  
  If `sddm` isn't behaving, you can revert to the default with `sudo dpkg-reconfigure lightdm`.
  
  Configuration doc: https://wiki.archlinux.org/title/SDDM#Configuration
  
  View the default config: `sddm --example-config | bat`
</details>

<details>
  <summary>Expand for VLC Settings</summary>
  
  Download custom skin
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
        wget https://github.com/trusktr/gedit-color-schemes/archive/refs/heads/master.zip -O ~/Downloads/geditcolors.zip
        unzip -j ~/Downloads/geditcolors.zip "gedit-color-schemes-master/gtksourceview-3.0/styles/*" -d ~/.local/share/gtksourceview-3.0/styles/
        unzip -j ~/Downloads/geditcolors.zip "gedit-color-schemes-master/gtksourceview-3.0/styles/*" -d ~/.local/share/gtksourceview-4/styles/
        rm ~/Downloads/geditcolors.zip
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
          (un-check) Allow mouse wheel scrolling to change tabs
          
        [Theme]
          Twilight
        ```
</details>


<br>
<br>

Now that things are set up, you should back things up.
```sh
# Back up GNOME settings
dconf dump / > ~/settings.dconf
```

---

## Back Up or Restore Data

Set up the script by adding an alias to your `*.rc` file
```sh
alias bup="<PATH_TO_REPO>/distro/mint/bin/backup.sh"
alias createbup='bup -c -f "$(${HOME}/<PATH_TO_REPO>/distro/mint/bin/backup-list.sh)"'
```
Backups will be output to the Desktop unless otherwise specified.

Restore a backup with
```sh
bup -r "<PATH_TO_BACKUP>"
```

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
  sudo vim /usr/lib/systemd/logind.conf.d/laptop-login.conf
  ```
  ```
  [Login]
  # don't suspend on login screen when plugged in
  HandleLidSwitchExternalPower=ignore
  ```
</details>

**Issue: Kernel Panic error after choosing "recommended" nvidia driver**
<details>
  <summary>Expand for Solution</summary>
  
  To fix the panic, during boot I chose Advanced in the Grub menu. In that sub-menu I went down the list of available `recovery-mode` options until one booted.
  
  From the menu I chose the Root shell option. Then I ran `ubuntu-drivers devices` (displays what Driver Manager shows). I found the bad driver name and ran:
  ```sh
  apt purge nvidia-driver-525
  apt autoremove
  reboot
  ```
  You should then be able to boot normally with the default `nouveau` driver. Open up Driver Manager and reinstall the nvidia driver that matches your kernel.
  
  To find the driver that matches your kernel, run `uname -r` to view the current kernel. Then compare that against the available nvidia drivers in Driver Manager. For me it was recommending `nvidia-driver-525` when my kernel was `5.15.0-56-generic`. So it should've been recommending `nvidia-driver-515`.
</details>


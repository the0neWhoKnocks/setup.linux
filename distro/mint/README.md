# Mint
---

## Set Up ZSH

Install oh-my-zsh, plugins, and my custom theme
```sh
./bin/set-up-zsh.sh
```

Once the install is done

- Update your terminal's font to use the newly installed Fantasque
- Update the color scheme to the one in `~/.oh-my-zsh/custom/themes/zsh-theme-boom/colors.sh`. Normally just sourcing that file should work, but some terminals will override with their own colors.

---

## Don't Require Password for Sudo

```sh
echo "${USER} ALL = NOPASSWD: ALL" | (sudo EDITOR='tee -a' visudo)
```

---

## Set Up Shares

```sh
(
  cd ./bin/dist
  ./user-script.sh --install "${PWD}/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
)
```
- Run the new Launcher that was added to the Desktop
  - Configure the settings for the share.
    - The mounted folder needs to be in `/media`, or it won't be automatically detected.

---

## Create Common Directories

```sh
mkdir -v -p ~/{Projects/{3D,Code/{Apps,Games,Gists,Scripts},Img,Vid}}
```

---

## Install Software

### Via Software Manager (or apt install)

```sh
apt install aegisub cairo-dock cairo-dock-gnome-integration-plug-in chromium flameshot git grub-customizer handbrake inkscape kid3-qt meld mkvtoolnix-gui okular peek plasma-sdk sddm sddm-theme-breeze soundconverter tilix ttf-mscorefonts-installer vlc wireshark xclip xserver-xorg-input-synaptics

# optional
apt install figlet lolcat obs-studio
```

<details>
  <summary>Expand for Details</summary>
  
  | Package | Description |
  | ------- | ----------- |
  | [aegisub](https://aeg-dev.github.io/AegiSite/) | Subtitle editor |
  | [cairo-dock](http://glx-dock.org/) | Customizable icon dock |
  | [cairo-dock-gnome-integration-plug-in](https://packages.ubuntu.com/bionic/x11/cairo-dock-gnome-integration-plug-in) | GNOME integration plug-in for Cairo-dock. Needed for things like emptying trash |
  | [chromium](https://www.chromium.org/getting-involved/download-chromium/) | Browser without all the Chrome overhead |
  | [flameshot](https://flameshot.org/) | Swiss army knife of screenshot tools |
  | [git](https://git-scm.com/about) | Version control |
  | [grub-customizer](https://launchpad.net/grub-customizer) | Easily change and compile grub config |
  | [handbrake](https://handbrake.fr/) | Tool for converting video from nearly any format to a selection of modern, widely supported codecs |
  | [inkscape](https://inkscape.org/) | Tool to create vector images (Adobe Illustrator alternative) |
  | [kid3-qt](https://kid3.kde.org/) | Audio tag editor (TagScanner alternative) |
  | [meld](https://meldmerge.org/) | Visual fill diff tool |
  | [mkvtoolnix-gui](https://www.matroska.org/downloads/mkvtoolnix.html) | A set of tools to create, alter and inspect Matroska (mkv) & WebM files |
  | [okular](https://okular.kde.org/) | Universal document viewer (PDFs, etc.) |
  | [peek](https://github.com/phw/peek) | Simple screen recorder with an easy to use interface. Captures a specific parts of the screen, and can output '.apng', '.gif', '.mp4', and '.webm' |
  | [plasma-sdk](https://github.com/KDE/plasma-sdk) | Applications useful for Plasma development. I use it for Cuttlefish (an icon viewer) |
  | [sddm](https://github.com/sddm/sddm) | A modern display manager for X11 and Wayland. ( Alternate DM than the default lightdm) |
  | [sddm-theme-breeze](https://packages.debian.org/sid/sddm-theme-breeze) | Clean centered theme with avatar |
  | [soundconverter](https://soundconverter.org/) | Converter for audio files |
  | [tilix](https://github.com/gnunn1/tilix) | A tiling terminal emulator for Linux using GTK+ 3 |
  | [ttf-mscorefonts-installer](https://linuxhint.com/ttf-mscorefonts-installer/) | Installer for Microsoft TrueType core fonts. Needed to display fonts properly in browsers |
  | [vlc](https://www.videolan.org/vlc/) | Multimedia player |
  | [wireshark](https://www.wireshark.org/) (meta-package) | Network traffic sniffer |
  | [xclip](https://github.com/astrand/xclip) | Copy from CLI to clipboard |
  | [xserver-xorg-input-synaptics](https://packages.ubuntu.com/bionic/xserver-xorg-input-synaptics) | Enables smooth/inertial/kinetic scroll on long documents/webpages (requires reboot) |
  
  | Package | Description |
  | ------- | ----------- |
  | [figlet](http://www.figlet.org/) | Generate text banners for CLI |
  | [lolcat](https://github.com/busyloop/lolcat) | Add rainbow colors to text in CLI |
  | [obs-studio](https://obsproject.com/) (non-flatpak) | Record or stream video |
</details>


### Via Flatpak

TBD, may switch to `gimp gimp-plugin-registry`

```sh
flatpak install flathub org.gimp.GIMP org.gimp.GIMP.Plugin.GMic org.gimp.GIMP.Plugin.LiquidRescale org.gimp.GIMP.Plugin.Resynthesizer org.kde.kdenlive

# PhotoGIMP
(
  mv ~/.config/GIMP/2.10 ~/.config/GIMP/2.10.bak
  wget "https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.by.Diolinux.v2020.1.for.Flatpak.zip" -O ~/.config/GIMP/temp.zip
  unzip ~/.config/GIMP/temp.zip -d ~/.config/GIMP/temp/
  cd ~/.config/GIMP/temp/PhotoGIMP.by.Diolinux.v2020.1.for.Flatpak
  rsync -r ./.local/share/applications/ ~/.local/share/applications/
  rsync -r ./.local/share/icons/hicolor ~/.local/share/icons/hicolor/
  rsync -r ./.var/app/org.gimp.GIMP/config/GIMP/2.10 ~/.config/GIMP/
  cd ../..
  rm -rf ./temp ./temp.zip
)
```

<details>
  <summary>Expand for Details</summary>
  
  List what's currently installed `flatpak list`.
  
  Search for packages with `flatpak search <PACKAGE>`, like `flatpak search org.gimp.GIMP.Plugin`.

  | Package | Software | Description |
  | ------- | -------- | ----------- |
  | [org.gimp.GIMP](https://flathub.org/apps/details/org.gimp.GIMP) | GIMP | Image editor (alternative to Adobe Photoshop) |
  | [org.gimp.GIMP.Plugin.GMic](https://gmic.eu/download.html) | G'MIC | A large set of filters |
  | [org.gimp.GIMP.Plugin.LiquidRescale](https://github.com/glimpse-editor/Glimpse/wiki/How-to-Install-the-Liquid-Rescale-Plugin#install-liquid-rescale-on-linux) | LiquidRescale | Scale an image, but don't scale selected items |
  | [org.gimp.GIMP.Plugin.Resynthesizer](https://github.com/bootchk/resynthesizer) | Resynthesizer | Content-aware removal of selected items |
  | [org.kde.kdenlive](https://kdenlive.org/en/features/) | Kdenlive | Video editor |
  
  | Software | Description |
  | -------- | ----------- |
  | [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) | Makes GIMP look like Photoshop |
  
  https://www.gimp-forum.net/Thread-Resynthesizer-for-2-10-24-how-to-add-plugin?pid=22856#pid22856
</details>


### Via .deb

```sh
(
  DEBS_DIR="~/Downloads/deb"
  mkdir -p "${DEBS_DIR}"
  urls=(
    'https://github.com/atom/atom/releases/download/v1.63.1/atom-amd64.deb'
    'https://github.com/sharkdp/bat/releases/download/v0.22.1/bat_0.22.1_amd64.deb'
    'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
    'https://discord.com/api/download?platform=linux&format=deb'
    'https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website'
    'https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb'
    'https://github.com/subhra74/snowflake/releases/download/v1.0.4/snowflake-1.0.4-setup-amd64.deb'
    'https://github.com/Ulauncher/Ulauncher/releases/download/5.15.0/ulauncher_5.15.0_all.deb'
  )
  for url in "${urls[@]}"; do
    wget "${url}" -P "${DEBS_DIR}/"
  done
  
  sudo dpkg -i "${DEBS_DIR}/*.deb"
)

# optional URLs
https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
```

<details>
  <summary>Expand for Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [Atom](https://atom.io/) | Hackable text editor |
  | [bat](https://github.com/sharkdp/bat) | Like `cat`, but displays a limited amount of a file and with syntax highlighting |
  | [Chrome](https://www.google.com/chrome/) | Browser |
  | [Discord](https://discord.com/) | Group text/voice/video communication |
  | [Insomnia](https://insomnia.rest/) | API development |
  | [lsd](https://github.com/Peltoche/lsd) | A Deluxe version of the `ls` command |
  | [Snowflake](https://github.com/subhra74/snowflake) | SFTP Client (alternative to WinSCP) |
  | [ULauncher](https://ulauncher.io/) | Application launcher |
  
  | Software | Description |
  | -------- | ----------- |
  | [Steam](https://store.steampowered.com/) | PC Gaming platform |
</details>


### Via Archives

```sh
(
  mkdir -p ~/{Downloads/archives,Software}
  ARCH_DIR="~/Downloads/archives"
  urls=(
    'https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz'
    'https://github.com/BrunoReX/jmkvpropedit/releases/download/v1.5.2/jmkvpropedit-v1.5.2.zip'
  )
  for url in "${urls[@]}"; do
    wget "${url}" -P "${ARCH_DIR}/"
  done
  
  # TODO: extract archives to Software/<NAME>/<VERSION>
)

# optional
https://www.blender.org/download/release/Blender3.3/blender-3.3.1-linux-x64.tar.xz/
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


### Via CLI

```sh
##########
# docker #
##########
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo usermod -aG docker $USER
# verify install
systemctl is-enabled docker
systemctl status docker

##################
# docker-compose #
##################
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url  | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
chmod +x docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose

##########
# lutris #
##########
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris

######################
# 'n' NodeJS manager #
######################
# https://github.com/tj/n#third-party-installers
curl -L https://git.io/n-install | bash
n ls-remote # list available versions to download
n install 16

########
# qemu #
########
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo adduser $USER libvirt && sudo adduser $USER kvm && sudo adduser $USER libvirt-qemu
```

<details>
  <summary>Expand for Details</summary>
  
  | Software | Description |
  | -------- | ----------- |
  | [docker](https://www.docker.com/why-docker/) | Containerize environments |
  | [docker-compose](https://docs.docker.com/compose/) | Create config files for Docker containers |
  | [lutris](https://lutris.net/) | Allows for playing games on Linux. Use to install [Origin](https://lutris.net/games/origin/) |
  | [n](https://github.com/tj/n) | NodeJS version management |
  | [qemu](https://www.qemu.org/) | A machine emulator and virtualizer |
</details>

---

## Backup/Restore Data

Set up the script by adding an alias to your `*.rc` file
```sh
alias bup="<PATH_TO_REPO>/distro/mint/bin/dist/backup.sh"
alias createbup='bup -c -f "$(${HOME}/<PATH_TO_REPO>/distro/mint/bin/dist/backup-list.sh)"'
```
Backups will be output to the Desktop unless otherwise specified.

Restore a backup with
```sh
bup -r "<PATH_TO_BACKUP>"
```

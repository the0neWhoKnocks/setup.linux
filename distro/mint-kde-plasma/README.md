# Mint: KDE Plasma

I've switched to Plasma because Cinnamon was having some random lag issues that would crop up after little use. It was very noticeable when moving windows and scrolling.

- [Install KDE](#install-kde)
- [Remove Cinnamon](#remove-cinnamon)
- [System Settings](#system-settings)
  - [Appearance](#appearance)
    - [Global Theme](#global-theme)
    - [Application Style](#application-style)
    - [Plasma Style](#plasma-style)
    - [Colors](#colors)
    - [Window Decorations](#window-decorations)
    - [Fonts](#fonts)
    - [Icons](#icons)
    - [Cursors](#cursors)
    - [Splash Screen](#splash-screen)
  - [Workspace Behavior](#workspace-behavior)
    - [General Behavior](#general-behavior)
    - [Screen Edges](#screen-edges)
    - [Screen Locking](#screen-locking)
    - [Recent Files](#recent-files)
  - [Window Management](#window-management)
    - [Task Switcher](#task-switcher)
  - [Startup and Shutdown](#startup-and-shutdown)
    - [Login Screen](#login-screen)
    - [Autostart](#autostart)
  - [Applications](#applications)
    - [Default Applications](#default-applications)
    - [KDE Wallet](#kde-wallet)
  - [(Network) Settings](#network-settings)
    - [SSL Preferences](#ssl-preferences)
  - [Display and Monitor](#display-and-monitor)
    - [Display Configuration](#display-configuration)
    - [Night Color](#night-color)
- [Task Bar](#task-bar)
- [Desktop Appearance](#desktop-appearance)
  - [Wallpaper](#wallpaper)
  - [Icons](#icons-1)
- [Add a Dock](#add-a-dock)
- [Tweaks](#tweaks)
  - [Get Pipewire re-installed](#get-pipewire-re-installed)
  - [Don't start Discover on boot](#dont-start-discover-on-boot)
- [Sources](#sources)

---

## Install KDE

1. Install KDE:
    ```sh
    sudo apt install kde-plasma-desktop
    ```
    When the installer asks which display manager to use, pick `sddm`. If you later decide that you want to use a different Display Manager, run: `sudo dpkg-reconfigure sddm` (`sddm` is mentioned here because you have to input the current DM).
1. Reboot
1. Before logging in, choose `Plasma` for the session type.
1. Install Wayland support:
    ```sh
    sudo apt install plasma-workspace-wayland
    ```

---

## Remove Cinnamon

Once you're happy with things, you can remove Cinnamon and any Apps that were automatically installed.
```sh
sudo apt remove --purge cinnamon*
sudo apt remove nemo* xed* mint-meta-cinnamon
sudo apt autoremove
``` 

---

## System Settings

---

### Appearance

#### Global Theme

Breeze Dark

#### Application Style

Breeze

#### Plasma Style

Breeze

#### Colors

Breeze Dark

#### Window Decorations

Infinity-Solid-Aurorae

#### Fonts

```
General: Noto Sans 12pt
Fixed Width: Hack 12pt
Small: Noto Sans 10pt
Toolbar: Noto Sans 12pt
Menu: Noto Sans 12pt
Window title: Noto Sans 10pt
```

#### Icons

Breeze Dark

#### Cursors

Bibata-Modern-Classic

#### Splash Screen

1. Click **Get New**.
1. Find one you like and **Install** it, I went with `QuarkSplashDark`.
1. Once installed, click on it.
    - You can click the play button on each item to preview it. You can hit `ESC` or click to exit out of the preview. 

---

### Workspace Behavior

#### General Behavior

Clicking files or folders: Selects them
Clicking in scrollbar track: Scrolls to the clicked location

#### Screen Edges

(Top Left): Peek at Desktop

#### Screen Locking

(Image): Sparkling

#### Recent Files

Remember opened documents: Do not remember

---

### Window Management

#### Task Switcher

1. Click **Get New Task Switchers**.
1. Install **Thumbnail Switcher**.
1. Pick **Thumbnail Switcher** from the drop-down.

---

### Startup and Shutdown

#### Login Screen

1. Click **Get New SDDM Themes**.
1. Install **Dracula**.
1. Select **Dracula**.

#### Autostart

Add/remove any applications you want at login.

---

### Applications

#### Default Applications

Set up your defaults

#### KDE Wallet

Disable

---

### (Network) Settings

#### SSL Preferences

Add in any self signed CAs (certificate authorities)

---

### Display and Monitor

#### Display Configuration

If you have multiple monitors, this is where you configure their layout and position.

#### Night Color

```
Switching times: Always off
```
It doesn't enable itself at login. RedShift seems to be consistent so I'm still using it here.


---

## Task Bar

1. Right-click bottom bar in empty area, select **Configure Icons-only Task Manager**.
    ```
    [Behavior]
      Clicking grouped task: Shows small window previews
      Show only tasks:
        [x] From current screen
    ```

---

## Desktop Appearance

Right-click an empty area of a screen, pick **Configure Desktop and Wallpaper**.

### Wallpaper

Note that each screen has to be configured seperately (so right-click and configure each screen).
1. Click **Add Image**.
1. Pick the image you want for that screen.
1. Apply

### Icons

```
             Arrangement: Top to Bottom
                 Sorting: Manual
               Icon size: (3rd tick from the left, closer to Small)
             Label width: Narrow
              Text lines: 1
When hovering over icons: [ ] Show folder prefiew popups
                Previews: [ ] Show preview thumbnails
```

---

## Add a Dock

```sh
# Issue with Impulse plugin (wouldn't install with pipewire), requires install from weekly PPA (https://github.com/Cairo-Dock/cairo-dock-plug-ins/issues/19)
sudo add-apt-repository ppa:cairo-dock-team/weekly
sudo apt update
sudo apt install cairo-dock cairo-dock-plug-ins cairo-dock-gnome-session
```

---

## Tweaks

### Get Pipewire re-installed

```sh
sudo apt install pipewire pipewire-bin
# Enable Pipewire and verify it's running
systemctl enable --user pipewire
systemctl status --user pipewire
# Verify PulseAudio is now disabled
systemctl status --user pulseaudio
# Remove PulseAudio
apt purge pulseaudio

# Was seeing some errors in the PipeWire services so I installed this stuff
sudo apt install pipewire-audio-client-libraries pipewire-libcamera
systemctl --user --now restart pipewire pipewire-pulse wireplumber
systemctl --user status pipewire{,-pulse} wireplumber
```
The speaker icon in the system tray would blink on and off, it was switching from **Speakers** and **Headphones (unplugged)**. So I changed the **Profile** from `Analog Stereo Duplex` to `Pro Audio`.

### Don't start Discover on boot

```sh
cp /etc/xdg/autostart/org.kde.discover.notifier.desktop ~/.config/autostart/
nano ~/.config/autostart/org.kde.discover.notifier.desktop
```
At the bottom of the file add
```sh
Hidden=true
```

---

## Sources

- https://linuxcapable.com/how-to-install-kde-plasma-on-linux-mint/
- https://zonatsolutions.com/switch-from-cinnamon-to-kde-plasma-on-linux-mint-complete-step-by-step-guide/
- https://paranoidix.dk/blog/kde-discover-notification

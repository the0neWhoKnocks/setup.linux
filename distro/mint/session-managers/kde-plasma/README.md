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
    - [Desktop Session](#desktop-session)
  - [Applications](#applications)
    - [Default Applications](#default-applications)
    - [KDE Wallet](#kde-wallet)
  - [(Network) Settings](#network-settings)
    - [SSL Preferences](#ssl-preferences)
  - [Input Devices](#input-devices)
    - [Keyboard](#keyboard)
  - [Display and Monitor](#display-and-monitor)
    - [Display Configuration](#display-configuration)
    - [Night Color](#night-color)
- [Task Bar](#task-bar)
- [Desktop Appearance](#desktop-appearance)
  - [Wallpaper](#wallpaper)
  - [Icons](#icons-1)
- [Add a Dock](#add-a-dock)
  - [Cairo-Dock Settings](#cairo-dock-settings)
- [Tweaks](#tweaks)
  - [Get Pipewire re-installed](#get-pipewire-re-installed)
  - [Don't start Discover on boot](#dont-start-discover-on-boot)
- [Useful Keyboard Shortcuts](#useful-keyboard-shortcuts)
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

You may want to take a TimeShift snapshot before proceeding.

Once you're happy with things, you can remove Cinnamon and any Apps that were automatically installed.
```bash
# had to run in bash, zsh didn't expand the *
sudo apt remove --purge cinnamon* mate-* muffin* nemo* xed*
```

This will likely uninstall `xviewer` (the default image viewer), so you may have to adjust **System Settings** > **Applications** > **File Associations** > **image**. Click on an image extension and make sure that `Pix` is at the top of the **Application Preference Order**.

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

Lock Screen Automatically: (unchecked)
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

<details>
  <summary>Expand for SDDM Settings</summary>
  
  ```sh
  (
    # To configure the theme, create a custom config for sddm
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -i ./files/sddm/numlock.conf /etc/sddm.conf.d/
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

#### Autostart

Add/remove any applications you want at login.

#### Desktop Session

```
On login, launch apps that were open: Start with an empty session
```
Was getting an error from **Albert** after I rebooted `Failed creating IPC server: QLocalServer::listen: Address in use`. Seems it was trying to start the same session and was conflicting with the already assigned port.

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

### Input Devices

#### Keyboard

```
[Hardware]
  NumLock on Plasma Startup: Turn on
```

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

- Right-click bottom bar in empty area, select **Configure Icons-only Task Manager**.
    ```
    [Behavior]
      Clicking grouped task: Shows small window previews
      Show only tasks:
        [x] From current screen
    ```
- Click the (Up) arrow by the clock (Show Hidden Icons):
    - Click the **Configure System Tray** button.
        ```
             IBus Panel | Always Hidden
        Lock Key Status | Always Shown
              Clipboard | Disabled
        ```
    - If the **Lock Key Status** widget is missing
        ```sh
        sudo apt install plasma-widgets-addons
        kquitapp5 plasmashell && kstart5 plasmashell &
        ```
- Right-click the **Lock Key Status** widget and **Configure**.
    ```
    Show when activated: [x] Caps Lock
                         [x] Num Lock
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

### Cairo-Dock Settings

<details>
  <summary>Expand for Cairo-Dock Settings</summary>
  
  If you want to switch from OpenGL go into `~/.config/cairo-dock/.cairo-dock` and update:
  ```diff
  - default_backend=opengl
  + default_backend=cairo
  ```
  
  To have it start on boot go into **Startup Applications**. `Add > Choose Applications > pick Cairo-Dock`.
  
  In order to add launchers to the dock, I go into the taskbar menu and search for the application. Once you find the application you can sometimes just drag it right to the dock, but more often than not I just right-click the app and choose `Add to desktop`. Then I can drag that launcher to the dock.
  
  Note that when a launcher is added to the dock, a copy of it is added to `~/.config/cairo-dock/current_theme/launchers`. So if a launcher needs to be updated, I'll generally just delete it and add the new one, but you can go in and manually edit the launcher in that folder.
  
  When manually creating a launcher I look to see if there's a good system icon via `cuttlefish` instead of pointing to an image. Some apps like system binaries may not have an icon, so you can find/create one and add it to the appropriate folder in `~/.local/share/icons`. More info on that in the [Theming](#theming) section.
    - After an update in Mint, I noticed some icons I was previously using were no longer available in the current theme. You can see what icon theme is in use under `Cairo-dock > Configuration > Appearance > Icons`. It seems to default to `_Custom Icons_` which is located at `/home/<USER>/.config/cairo-dock/current_theme/icons/`, and allows you to drop custom icons (SVG or PNG) directly in there. You can reference the files the same way as system icons, for example if you have `code.svg` you can reference it as `code` in the Launcher `Icon > Image's name or path` section. Missing icons may still exist within a different theme, so in a file browser you can open up `/usr/share/icons/` and search for the name that was previously being used, then just copy that file over to `<CAIRO>/current_theme/icons/`.
  
  Once you have the dock configured the way you like it, go to **Configure** > **Themes** > **Save**.
  ```
                       Save as: my-cairo-theme
    Save current behavior also? (checked)
   Save current launchers also? (checked)
  Build a package of the theme? (checked)
  Directory in which the package will be saved: (your home folder)
  ```
  
  Had an issue where Cairo wasn't using my default File Manager to open folders. It must be caching it somewhere because after I went into Default Applications, and changed my File Manager to something else, and then back to what I wanted, it started behaving.
</details>

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

---

## Useful Keyboard Shortcuts

| Keys | Action |
| ---- | ------ |
| `OPT/START + click on a window + drag` | Moves a window (other `OPT` key doesn't work) |

---

## Sources

- https://linuxcapable.com/how-to-install-kde-plasma-on-linux-mint/
- https://zonatsolutions.com/switch-from-cinnamon-to-kde-plasma-on-linux-mint-complete-step-by-step-guide/
- https://paranoidix.dk/blog/kde-discover-notification

# TODO
---

Step 1
- Get User input at beginning of script
  - [ ] Automate the initial disk formatting `fdisk`
    - print list of disks
  - [ ] Get non-root User name and password
    ```sh
    (echo '<PASSWORD>'; echo '<PASSWORD>') | passwd <USERNAME>
    ```
  - [ ] Computer name
  - [ ] WiFi (if not hardwired)
  - [ ] Chosen locale/timezone (maybe get it from network info)

Step 3
- GUI
  - Settings
    - [ ] See if there's a way to display a preview of the wallpaper (doubt since I can't get local files to load).
    - [ ] See if there's a way to change the current desktop to the selected one via CLI.
    - [ ] Add a folder/file picker to pick a location of a backup file to restore.
  - [ ] If certain extra packages were chosen, print out examples.. or dump a file with examples.

General
- [ ] Normalize `dist` scripts so they all have `help` and examples

user-script.sh
- [ ] Don't `cp` scripts to `/usr/local/bin`, `ln` instead so I can maintain the scripts more easily from the repo.

backup.sh
- [ ] Allow for choosing output location (local or external)
- Locations
  - Atom
    - ~/.var/app/io.atom.Atom/data (figure out what's needed)
  - Cairo Dock
    - ~/.config/cairo-dock
      - /current_theme
        - /launchers
        - /cairo-dock-simple.conf
        - /cairo-dock.conf
  - Chromium
    - ~/.config/chromium/Default 
  - Dolphin
    - ~/.config/dolphinrc
    - ~/.local/share/kxmlgui5/dolphin/dolphinui.rc
  - Flameshot
    - ~/.config/flameshot/flameshot.ini 
  - General
    - autostart: ~/.config/autostart, ~/.config/autostart-scripts
  - Gimp
    - ~/.config/GIMP/<VERSION>/ (lots of files)
  - Google Chrome
    - ~/.config/google-chrome/Default
  - Handbrake
    - ~/.config/ghb
      - /preferences.json
      - /presets.json
    - ~/.var/app/fr.handbrake.ghb (maybe)
  - Icons
    - /usr/share/icons
    - ~/.icons
    - ~/.local/share/icons
  - Inkscape
    - ~/.config/inkscape/preferences.xml
  - KDE
    - KWin: ~/.config/kwinrc
    - Splash screen: ~/.config/ksplashrc
    - Timezone: ~/.config/ktimezonerc
    - Wallpaper: ~/.config/plasma-org.kde.plasma.desktop-appletsrc
      ```
      [Containments][<NUMBER>][Wallpaper][org.kde.image][General]
      Image=file:///usr/share/wallpapers/MilkyWay/contents/images/5120x2880.png
      # or
      Image=file:///home/<USER>/.local/share/wallpapers/<FILENAME>.jpg
      ```
  - Keyboard
    - ~/.xbindkeysrc
  - Krita
    - ~/.config/kritarc
    - ~/.local/share/krita (lot of stuff, layout settings may be in here)
  - KRunner
    - ~/.local/share/krunnerstaterc
  - Latte Dock
    - ~/.config/latte/My Layout.layout.latte
    - ~/.config/lattedockrc
  - LSD
    - ~/.config/lsd/config.yaml
  - Notepadqq
    - ~/.config/Notepadqq/Notepadqq.ini
  - NVidia
    - ~/.nvidia-settings-rc
  - OBS Studio
    - ~/.config/obs-studio (seems like everything but the `logs` folder)
  - Plank Dock
    - ~/.config/plank/*
  - Plasma
    - ~/.config/plasmarc
    - splashscreens: ~/.local/share/plasma/look-and-feel
    - themes: ~/.local/share/plasma/desktoptheme
  - Puddletag
    - ~/.config/puddletag/puddletag.conf
  - QMMP
    - ~/.qmmp/*
  - Sound Konverter
    - ~/.config/soundkonverterrc
    - ~/.local/share/soundkonverter/profiles.xml
  - Steam
    - ~/.local/share/Steam
      - library stuff: /appcache/librarycache
      - music: /music/_database
      - settings: 
        - /config/config.vdf
        - /config/libraryfolders.vdf
        - /config/loginusers.vdf
        - /controller_base/ (bunch of misc. files that a User may customize)
        - /userdata/ (??)
    - ~/.steam/steam.token
  - Terminal
    - ~/.gitconfig
    - ~/.history
    - ~/.oh-my-zsh (maybe)
    - ~/.ssh
    - ~/.xprofile (not used, but could be)
    - ~/.zsh_history
    - ~/.zshrc
  - Tilix
    ```sh
    # export
    dconf dump '/com/gexperts/Tilix/' > ~/tilix-settings.dconf

    # import
    dconf load '/com/gexperts/Tilix/' < ~/tilix-settings.dconf
    ```
  - User Scripts
    - Post Install: ~/.config/post-install
    - Shares: ~/.config/lan-shares
  - VirtualBox
    - ~/.config/VirtualBox/VirtualBox.xml
    - might want to back up isos, but they're huge...
  - VLC
    - ~/.config/vlc/vlc-qt-interface.conf
  - Wallpapers
    - /usr/share/wallpapers
    - ~/.local/share/wallpapers
  - [Unknown]
    - ~/.config/gtk-3.0/settings.ini (references theme stuff)
    - ~/.config/xsettingsd/xsettingsd.conf (references some theme stuff, not sure what uses it though)

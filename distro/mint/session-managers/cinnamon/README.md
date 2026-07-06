# Mint: Cinnamon

- [Settings](#settings)
  - [Session Management](#session-management)
  - [System Settings](#system-settings)
    - [General System Settings](#general-system-settings)
    - [Panel Settings](#panel-settings)
      - [Back up Panels](#back-up-panels)
      - [Restore Panels](#restore-panels)
      - [Reset Panels](#reset-panels)
  - [Software Settings](#software-settings)
    - [Xed (Text Editor) Settings](#xed-text-editor-settings)
- [Useful Keyboard Shortcuts](#useful-keyboard-shortcuts)

---

## Settings

If you have a previous backup that utilized `dconf`, you can restore it now which may save you some configuration time.
```sh
# Restore GNOME settings
dconf load / < ~/settings.dconf

# If you want to import keys for specific packages, the only thing I've found is to copy those sections to another `.dconf` file and run the same command above but with the new file. 
```

---

### Session Management

<details>
  <summary>Expand for Session Management</summary>

  XFCE has this exposed where you can choose to save sessions and delete the ones that exist. Cinnamon has it hidden away.
  
  Launch **dconf Editor** and navigate to `/org/cinnamon/cinnamon-session/` toggle on the `auto-save-session` option.
</details>

---

### System Settings

#### General System Settings

<details>
  <summary>Expand for General System Settings</summary>
    
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
</details>

---

#### Panel Settings
  
<details>
  <summary>Expand for Panel Settings</summary>
  
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
  
  ##### Back up Panels
  
  ```sh
  dconf dump /org/cinnamon/ > ~/cinnamon_backup.conf
  ```
  Custom launchers on your panel are not saved in the general dconf/settings backup and must be exported manually.
  - Right-click the custom launcher icon on your panel.
  - Select **Applet preferences** > **Configure**.
  - Click the three horizontal lines (more options) icon in the top right corner.
  - Select **Export to a file** and save it.
  You'd have to do this one at a time for everything, or just copy the `~/.config/cinnamon/spices` folder.
  
  ##### Restore Panels
  
  First copy over the contents of your `~/.config/cinnamon/spices` backup, then:
  ```sh
  dconf load /org/cinnamon/ < ~/cinnamon_backup.conf
  ```
  
  ##### Reset Panels
  
  If you completely deleted your panel and just want to fix it, run
  ```sh
  gsettings reset-recursively org.cinnamon
  # OR
  dconf reset -f /org/cinnamon/
  ```
  This will wipe custom settings and bring back the default panel.
</details>

---

### Software Settings

#### Xed (Text Editor) Settings

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

---

---

## Useful Keyboard Shortcuts

| Keys | Action |
| ---- | ------ |
| `ALT + click on a window + drag` | Moves a window |
| `ALT + right-click near window edge + drag up/down or left/right` | Resize a window |
| `CTRL+ALT+ESC` | Restart Cinnamon (keeps current session, may jumble window positions) |
| `CTRL+ALT+BACKSPACE` | Restart XOrg (exits to login) |

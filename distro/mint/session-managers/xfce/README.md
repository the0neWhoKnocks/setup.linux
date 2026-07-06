# Mint: XFCE
---

## Install Software

### Via Software Manager or CLI

```sh
(
  sudo apt update
  sudo apt install -y cairo-dock cairo-dock-xfce-integration-plug-in 
)
```

---

## Configure Software

<details>
  <summary>Expand for System Settings</summary>
  
  
  ```
  ┎──────────┒
  ┃ About Me ┃
  ┖──────────┚
    Picture: (choose avatar)
  ```
  ```
  ┎────────────┒
  ┃ Appearance ┃
  ┖────────────┚
    [Style]
      Mint-Y-Dark-Aqua
    
    [Icons]
      Mint-Y-Dark-Aqua
    
    [Fonts]
      Default Font: Ubuntu Regular 12
      Default Monospace Font: Monospace Regular 12
  ```
  ```
  ┎─────────┒
  ┃ Display ┃
  ┖─────────┚
    [Advanced]
      (create a 'Docked' profile once things are set up)
      Configure new displays when connected (checked)
      Automatically enable profiles when new display is connected (checked)
      Show popup to identify displays (checked)
    
    [General]
      Display 2 (main monitor plugged into laptop for GPU)
        Primary Display (checked)
        Reflection: None
      
      Display 3 (vertical monitor plugged into dock)
        Rotation: Left
    
    Wallpaper
      Just right-click each monitor (on the desktop) > Desktop Settings > choose a folder with images > pick an image and apply a style.
  ```
  ```
  ┎──────────────┒
  ┃ Login Window ┃
  ┖──────────────┚
    [Appearance]
      Background: (choose image)
      Icon theme: Mint-Y-Dark-Aqua
    
    [Users]
      Allow guest sessions: (checked)
      
    [Settings]
      Monitor: DP-3 (your main monitor)
  ```
  ```
  ┎────────────────────┒
  ┃ Mouse and Touchpad ┃
  ┖────────────────────┚
    [Devices]
      [Mouse]
        Acceleration: 3.5
      
      [Touchpad]
        Reverse scrolling direction: (uncheck)
        [X] Enable horizontal scrolling
    
    [Theme]: DMZ (White)
  ```
  ```
  ┎───────┒
  ┃ Panel ┃
  ┖───────┚
    ┎─────────┒
    ┃ Display ┃
    ┖─────────┚
      Row size: 36
    
    ┎────────────┒
    ┃ Appearance ┃
    ┖────────────┚
      Adjust size automatically: (unchecked)
      Fixed icon size: 24
    
    ┎───────┒
    ┃ Items ┃
    ┖───────┚
      [Whisker Menu]
        [General]
          Application icon size: Small
          Category icon size: Small
        
        [Appearance]
          [X] Position commands next to search entry
          Display: Icon and title
          Title: enu 
          Icon: linuxmint-logo-simple
        
        [Behavior]
          Default Category: Recently Used
        
        [Commands]
          [X] Suspend
      
      [Show Desktop]
      
      [Separator]
        Style: Separator
      
      [Separator]
        Style: Transparent
        [X] Expand
      
      [Window Buttons]
        Sorting order: None, allow drag-and-drop
      
      [Separator]
        Style: Transparent
        [X] Expand
      
      [Separator]
        Style: Separator
      
      [Generic Monitor]
        Command: <THIS_REPO>/distro/mint-xfce/bin/key-lock-status.sh
        Label: (uncheck)
        Period: 0.25
        Font: Monospace 9
        
      [Status Tray Plugin]
        Adjust size automatically: (checked)
        Square items: (unchecked)
      
      [XAapp Status Plugin]
      
      [Notification Plugin]
        [General]
          Show notifications on: primary display
          Theme: Greybird
          Default position: Bottom right
          Opacity: 100%
        
        [Applications]
          (If notifications aren't showing, check here)
        
        [Log]
          Log notifications: always (checked)
          Log applications: all
      
      [PulseAudio Plugin]
        [General]
          [X] Enable keyboard shortcuts for volume control
          [X] Show notifications when volume changes
        
        [Media Players]
          [X] Enable multimedia keys for playback control
      
      [Clock]
        Format: Custom Format: %b. %e 【%a.】【%l: %M %p】
  ```
  ```
  ┎───────────────┒
  ┃ Power Manager ┃
  ┖───────────────┚
    [General]
      When power button is pressed: Shutdown
      When sleep button is pressed: Suspend
      
    [System]
      Suspend when inactive for: Never | Never
      When laptop lid is closed: Suspend | Lock screen
    
    [Display]
      Switch off after: 15 minutes | 15 minutes
  ```
  ```
  ┎─────────────┒
  ┃ Screensaver ┃
  ┖─────────────┚
    [Screensaver]
      Theme: Pop art squares
      Activate screensaver when computer is idle: (checked)
      Regard the computer as idle after: 5 minutes
      
    [Lock Screen]
      Enable Lock Screen: (checked)
      Lock Screen with Screensaver: (checked)
      Lock the screen after the screensaver is active for: 0 minutes
      Lock Screen with System Sleep: (checked)
  ```
  ```
  ┎────────────────┒
  ┃ Window Manager ┃
  ┖────────────────┚
    [Style]
      Theme: Mint-Y-Dark-Aqua
      Title font: Ubuntu Medium 12
  ```
  ```
  ┎───────────────────────┒
  ┃ Window Manager Tweaks ┃
  ┖───────────────────────┚
    [Compositor]
      (uncheck) Show shadows under dock windows (to remove random shadow under Cairo-dock)
  ```
  
  Shortcuts
  | Keys | Action |
  | ---- | ------ |
  | `CTRL+ALT+d` | Hide/Show Desktop |
</details>

---

## Troubleshooting

**Issue: Not All Desktop Notifications are displayed**
<details>
  <summary>Expand for Solution</summary>
  
  Context: I had this issue when I switched from Cinnamon to XFCE.
  
  First make sure you have the proper packages installed.
  ```sh
  libnotify-bin
  libnotify4 # could be version based
  notification-daemon
  python3-notify2  # could be version based
  xfce4-notifyd
  ```
  For me, the `xfce4-notifyd` daemon wasn't installed. Once it was, I tested with `notify-send -t 3000 --icon=dialog-information "Test 1-2"`.
</details>

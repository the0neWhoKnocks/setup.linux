# Mint: KDE Plasma

I've switched to Plasma because Cinnamon was having some random lag issues that would crop up after little use. It was very noticeable when moving windows and scrolling.

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
- [Tweaks](#tweaks)
  - [Don't start Discover on boot](#dont-start-discover-on-boot)
- [Sources](#sources)

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
Switching times: Always on night color
Night color temperature: 4,000K 
```


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

## Tweaks

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
- https://paranoidix.dk/blog/kde-discover-notification

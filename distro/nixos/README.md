# NixOS

- [Install OS](#install-os)
- [Install Software](#install-software)
- [Modules](#modules)
  - [System](#system)
  - [User](#user)
- [Sources](#sources)

---

## Install OS

During the install it'll ask which Installer to use, I chose `Plasma (Linux LTS)`.
```
[Location]
  Los Angeles

[Keyboard]
  English (US)
  Default

[Users]
  Name: (name can contain capital letters, spaces, etc.)
  Log in name: (name should be lowercase, no spaces)
  Password: (whatever)
  [ ] Require strong passwords.
  [x] Use the same password for the administrator account.

[Desktop]
  Plasma

[Unfree Software]
  [x] Allow unfree software

[Partitions]
  [x] Erase disk  (should use Manual partitioning later)
```

---

## Install Software

There are a couple ways to check for configurable programs.
1. https://search.nixos.org/packages?channel=26.05
    - Search for a package name.
    - Click on package.
    - Click on the **NixOS Configuration** tab.
        - There'll be a code snippet you can copy and apply to your `configuration.nix` file.
        - Scroll down to the **NixOS options** section and click the link to view the options.
        - The options page will likely have a `program.<NAME>.enable` option. Click that option to expand and view it's source from the **Declared in** section - it's a good way to learn how to write your own modules by looking at all the other modules that exist.
1. Via the CLI:
    ```sh
    # List all available programs
    nixos-option programs
    
    # Target a specific program
    nixos-option programs.zsh
    ```

Check if there are configurable services.
```sh
nixos-option services
```

How to get files from git repo and apply them
```nix
{ pkgs, ... }: 
let
  gitRepo = builtins.fetchGit {
    url = "https://github.com/<USER>/<REPO>.git";
    # rev = "<COMMIT_SHA>";
    ref = "<BRANCH_NAME>";
  };
in {
  # Link the fetched git repository into a specific folder in /etc
  environment.etc."target-folder".source = gitRepo;
  
  # Copy contents of repo file to `/etc/custom-config.conf`.
  environment.etc."custom-config.conf".text = builtins.readFile "${gitRepo}/config/tmpl.conf";
}
```

---

## Modules

```sh
# Copy over modules from this repo
sudo mkdir -p /etc/nixos/modules
sudo cp ./modules/*.nix /etc/nixos/modules/

# Configure text editor
cp ./files/.nanorc ~/
sudo cp ~/.nanorc /root/

# Edit main config file
sudo nano /etc/nixos/configuration.nix

# Build config
sudo nixos-rebuild switch
```

### System

Update `/etc/nixos/configuration.nix`
```diff
imports = [
  # my stuff
+ ./modules/apps_nix.nix
+ ./modules/apps_flatpak.nix
+ ./modules/docker.nix
+ ./modules/shell.nix
];
```
```diff
+ mine.docker.enable = true;
+ #mine.docker.dataRoot = "/some/other/path";
+ mine.docker.users = [ "<USER>" ];
```

After `rebuild`, a reboot will be required to access `docker` without `sudo`.
```sh
sudo reboot
```

### User



---

## Sources

- https://wiki.nixos.org/
    - https://wiki.nixos.org/wiki/NixOS_system_configuration#Modularizing_your_configuration_with_modules
        - https://wiki.nixos.org/wiki/NixOS_modules
        - https://nixos.wiki/wiki/Declaration#Types

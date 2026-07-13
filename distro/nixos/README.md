# NixOS

- [Install OS](#install-os)
- [Install Software](#install-software)
  - [How to get files from a git repo and apply them](#how-to-get-files-from-a-git-repo-and-apply-them)
  - [Create files/folders with tmpfiles](#create-filesfolders-with-tmpfiles)
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

### How to get files from a git repo and apply them

Fetches an entire repo. Setting `source` creates a symlink to the downloaded resource that's stored in `/nix/store`.
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

Fetch a specific file from a repo. When using `fetchurl` you have to provide `hash` or `sha256`. There are two ways you can get the value:
- Use `sha256 = lib.fakeSha256`, build the main nix config file, wait for it to fail and display the actual value.
- Or run `nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url <FILE_URL>)`.
    - You may have to add this to your main config file to use raw `nix` commands:
        ```nix
        nix.settings.experimental-features = [ "nix-command" ];
        ```
```nix
{ lib, pkgs, ... }:

# ...

environment.etc = {
  "folder/file.conf" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/<USER>/<REPO>/refs/heads/<BRANCH>/folder/file.conf";
      sha256 = <SHA>;
    };
  };
};
```

### Create files/folders with tmpfiles

```nix
systemd.tmpfiles.rules = [
  # Create a symlink to a store resource.
  "L+ /var/some/folder - - - - ${STORE_VAR}"
];
```
Note: I was trying to create a symlink within a store path and it wasn't being created but there weren't any errors. You can run `sudo systemd-tmpfiles --create` which will execute the same thing the build command does, but it'll actually output an error if there's something wrong.

---

## Modules

```sh
# Copy over modules from this repo
sudo mkdir -p /etc/nixos/modules
sudo cp ./system/modules/*.nix /etc/nixos/modules/

# Configure text editor
cp ./files/.nanorc ~/
sudo cp ~/.nanorc /root/

# Edit main config file
sudo nano /etc/nixos/configuration.nix

# Build config
sudo nixos-rebuild switch
# or alias `build-config`
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

1. Copy over repo files:
    ```sh
    mkdir -p ~/.config/home-manager
    cp <REPO>/distro/nixos/home/home.nix ~/.config/home-manager/
    ```
1. Apply customizations:
    ```sh
    home-manager switch
    # or alias `build-home`
    ```

---

## Sources

- https://wiki.nixos.org/
    - https://wiki.nixos.org/wiki/NixOS_system_configuration#Modularizing_your_configuration_with_modules
        - https://wiki.nixos.org/wiki/NixOS_modules
        - https://nixos.wiki/wiki/Declaration#Types

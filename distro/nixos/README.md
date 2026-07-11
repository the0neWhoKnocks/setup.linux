# NixOS

- [Install OS](#install-os)
- [Install Software](#install-software)
- [Modules](#modules)
  - [Apps (Nix)](#apps-nix)
  - [Apps (Flatpak)](#apps-flatpak)
  - [Docker](#docker)
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

https://github.com/NixOS/nixpkgs/pull/77960

If you run `nixos-option programs` you will get a complete listing of all of the programs configurable in this fashion. There's also `nixos-option services`, which has a lot more stuff in it.

https://search.nixos.org/packages?channel=26.05&query=docker#show=docker
https://search.nixos.org/options?channel=26.05&query=zsh.ohmyzsh

https://nixos.wiki/wiki/Docker

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

### Apps (Nix)

Update `/etc/nixos/configuration.nix`
```diff
imports = [
  # my stuff
+ ./modules/apps_nix.nix
];
```

### Apps (Flatpak)

Update `/etc/nixos/configuration.nix`
```diff
imports = [
  # my stuff
+ ./modules/apps_flatpak.nix
];
```

### Docker

Update `/etc/nixos/configuration.nix`
```diff
imports = [
  # my stuff
+ ./modules/docker.nix
];
```
```diff
+ mine.docker.enable = true;
+ #mine.docker.dataRoot = "/some/other/path";
+ mine.docker.users = [ "<USER>" ];
```

After `rebuild`, a reboot will be required to access `docker` without `sudo`.


---

## Sources

- https://wiki.nixos.org/
    - https://wiki.nixos.org/wiki/NixOS_system_configuration#Modularizing_your_configuration_with_modules
        - https://wiki.nixos.org/wiki/NixOS_modules
        - https://nixos.wiki/wiki/Declaration#Types

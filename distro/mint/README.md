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

## Backup/Restore Data

Set up the script by adding an alias to your `*.rc` file
```sh
alias bup="<PATH_TO_REPO>/distro/mint/bin/dist/backup.sh"
alias createbup='bup -c -f "<PATH_TO_REPO>/distro/mint/bin/dist/backup-list.sh"'
```
Backups will be output to the Desktop unless otherwise specified.

Restore a backup with
```sh
bup -r "<PATH_TO_BACKUP>"
```

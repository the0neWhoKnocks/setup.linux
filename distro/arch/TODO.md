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

Backup
- [ ] Allow for choosing output location (local or external)

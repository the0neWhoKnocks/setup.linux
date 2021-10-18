#!/usr/bin/env bash

# TODO: create a tabbed installer GUI
# | Official Packages | AUR Packages | User Scripts | Settings |

# from within <REPO>/distro/arch/bin
./dist/user-script.sh --install "${PWD}/dist/backup.sh"
./dist/user-script.sh --uninstall "backup"

./dist/user-script.sh --install "${PWD}/dist/lan-shares.sh" "LAN Shares" "Utility to mount or unmount network shares" "drive-multidisk" "-gui"
./dist/user-script.sh --uninstall "lan-shares"

./dist/user-script.sh --install "${PWD}/dist/user-script.sh"
./dist/user-script.sh --uninstall "user-script"

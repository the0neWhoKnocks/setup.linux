# Arch Linux

- [Start](#start)
- [Wireless](#wireless)
- [Install](#install)

---

## Start

Boot into your Live image.

I use [Ventoy](https://github.com/ventoy/Ventoy/releases) to store multiple Linux imgs on one drive, with the ability to choose from a menu any distro I want.

At the time of writing, I used [ventoy v1.0.52](https://github.com/ventoy/Ventoy/releases/tag/v1.0.52), and [Arch Linux](https://archlinux.org/releng/releases/) [v2021.09.01](https://archlinux.org/releng/releases/2021.09.01/).

In order to boot into Ventoy, you may have to change the boot order of your BIOS. For my laptop I had to spam `F2` during boot.
- Verify the boot order has the drive with Ventoy, set first. I had that drive plugged in during boot.
- You may also have to disable Safe Boot, it works on some systems, and not on others.

---

## Wireless

If you're hardwired (Ethernet cable plugged in), you can skip this section.

Note: In a VM, wireless networks aren't available unless you have an external
device (like USB dongle).

In the terminal, run the below, swapping out `<...>` strings with your choices.
```sh
iwctl device list | sed -e '1,4d' | awk 'NF { print $1 }'
DEVICE_NAME="<DEVICE_NAME>"

iwctl station "${DEVICE_NAME}" scan && iwctl station "${DEVICE_NAME}" get-networks | sed -e '1,4d' | awk 'NF { print $1 }'
SSID="<SSID>"

iwctl station "${DEVICE_NAME}" connect "${SSID}"
```

---

## Install

You can verify your internet connection via:
```sh
ping -c 1 archlinux.org
```

Once you have an internet connection, run the below.
```sh
cd /tmp && git clone https://github.com/the0neWhoKnocks/setup.linux.git && cd setup.linux/distro/arch/bin

./1-set-up-arch.sh
```

---

## Development

To more quickly test layout and functionality of the GUI you can just load up `file://<REPO_PATH>/distro/arch/bin/3-post-install-gui.html` in a Browser and set the responsive layout (in DevTools) to `890 x 600` (or whatever the dimensions are in `3-post-install-gui.sh`).

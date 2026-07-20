# z13-fnlockd

Software Fn-lock daemon for the ASUS ROG Flow Z13 GZ302 keyboard cover on Linux.

## Why this exists

The GZ302 keyboard cover presents multiple HID interfaces with similar USB IDs:
keyboard, consumer keys, touchpad, mouse, and vendor/N-key devices. Broad input
remappers can grab the pointer interfaces and cause cursor glitches. This daemon
only opens the two keyboard event nodes:

- `/dev/input/by-id/usb-ASUSTeK_Computer_Inc._GZ302EA-Keyboard-event-if00`
- `/dev/input/by-id/usb-ASUSTeK_Computer_Inc._GZ302EA-Keyboard-if02-event-kbd`

It grabs those two devices, emits a virtual keyboard through uinput, and toggles
a software Fn-lock layer with `Fn+Esc`.

## Mapping

When software Fn-lock is ON:

- `F1` -> mute
- `F2` -> volume down
- `F3` -> volume up
- `F4` -> mic mute
- `F5` -> `asusctl profile next`
- `F6` -> `Meta+Shift+S`
- `F7` -> brightness down
- `F8` -> brightness up
- `F9` -> `Meta+P`
- `F10` -> `F21`
- `F11`, `F12` stay normal because no useful alternate event was observed

For simple keys, the physical `Fn+F*` event is inverted back to the normal F-key
while software Fn-lock is ON.

## Install from source

```bash
sudo ./install.sh
```

## Install from RPM/COPR

Once COPR is published:

```bash
sudo dnf copr enable ttenneb/z13-fnlockd
sudo dnf install z13-fnlockd
sudo systemctl enable --now z13-fnlockd
```

The RPM intentionally does not enable the service automatically. Start it with
`systemctl enable --now` after installation.

## Build RPM locally

```bash
sudo dnf install rpm-build rpmdevtools systemd-rpm-macros python3-evdev libnotify
rpmdev-setuptree
git archive --format=tar.gz --prefix=z13-fnlockd-0.1.1/ \
  -o ~/rpmbuild/SOURCES/z13-fnlockd-0.1.1.tar.gz v0.1.1
rpmbuild -ba z13-fnlockd.spec
```

The binary RPM will be under `~/rpmbuild/RPMS/noarch/`.

## Use

```bash
cat /run/z13-fnlockd/state
sudo journalctl -u z13-fnlockd -f
```

Press `Fn+Esc` to toggle.

## Disable / uninstall

Temporarily stop:

```bash
sudo systemctl stop z13-fnlockd
```

Permanently uninstall source install:

```bash
sudo ./uninstall.sh
```

Permanently uninstall RPM install:

```bash
sudo dnf remove z13-fnlockd
```

## Related Z13/Linux tools

- [`z13ctl`](https://github.com/dahui/z13ctl) / [`z13gui`](https://github.com/dahui/z13gui): lighting, battery limit, fan curves, profiles, TDP, undervolting, and Z13 hardware control.
- [`asusctl`](https://gitlab.com/asus-linux/asusctl): ASUS Linux control stack. On Fedora it is commonly installed from the `lukenukem/asus-linux` COPR.
- [`strix-halo-linux-setup`](https://github.com/th3cavalry/GZ302-Linux-Setup): broader Strix Halo/GZ302 setup and hardware workaround scripts.

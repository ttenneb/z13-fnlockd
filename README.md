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

## Install

```bash
sudo ./install.sh
```

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

Permanently uninstall:

```bash
sudo ./uninstall.sh
```

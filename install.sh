#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BIN=/usr/libexec/z13-fnlockd
SERVICE=/etc/systemd/system/z13-fnlockd.service
DOC_DIR=/usr/share/doc/z13-fnlockd
OLD_BIN=/usr/local/bin/z13-fnlockd
OLD_LIBEXEC=/usr/local/libexec/z13-fnlockd
OLD_STATE=/run/z13-fnlockd.state
QUIRKS=/etc/libinput/local-overrides.quirks

echo "Installing runtime dependency..."
dnf install -y python3-evdev libnotify >/dev/null

echo "Cleaning up earlier keyd experiment if present..."
systemctl disable --now keyd 2>/dev/null || true
rm -f /etc/keyd/gz302-fnlock.conf /etc/udev/hwdb.d/90-gz302-fnlock.hwdb
systemd-hwdb update 2>/dev/null || true
if [[ -f "$QUIRKS" ]] && grep -q 'MatchName=keyd\*keyboard' "$QUIRKS"; then
  rm -f "$QUIRKS"
fi

echo "Installing z13-fnlockd..."
install -D -m 0755 "$SCRIPT_DIR/z13-fnlockd" "$BIN"
install -D -m 0644 "$SCRIPT_DIR/z13-fnlockd.service" "$SERVICE"
install -D -m 0644 "$SCRIPT_DIR/README.md" "$DOC_DIR/README.md"
rm -f "$OLD_BIN" "$OLD_LIBEXEC" "$OLD_STATE"

python3 -m py_compile "$BIN"

systemctl daemon-reload
systemctl enable z13-fnlockd >/dev/null
systemctl restart z13-fnlockd

echo
systemctl --no-pager --full status z13-fnlockd || true
cat <<'EOF'

Installed.

Use:
  Fn+Esc toggles software Fn-lock.
  cat /run/z13-fnlockd/state

Logs:
  sudo journalctl -u z13-fnlockd -f

Disable temporarily:
  sudo systemctl stop z13-fnlockd

Uninstall:
  sudo /home/bennettgarcia/z13-fnlockd/uninstall.sh
EOF

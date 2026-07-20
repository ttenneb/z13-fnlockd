#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

systemctl disable --now z13-fnlockd 2>/dev/null || true
rm -f /etc/systemd/system/z13-fnlockd.service
rm -f /usr/libexec/z13-fnlockd
rm -f /usr/local/libexec/z13-fnlockd
rm -rf /usr/share/doc/z13-fnlockd
rm -rf /usr/local/share/doc/z13-fnlockd
rm -rf /run/z13-fnlockd
systemctl daemon-reload

echo "z13-fnlockd uninstalled."

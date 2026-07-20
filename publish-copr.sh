#!/usr/bin/env bash
set -euo pipefail

PROJECT=${1:-z13-fnlockd}
VERSION=${2:-v0.1.1}

if ! command -v copr-cli >/dev/null; then
  echo "copr-cli is required: sudo dnf install copr-cli" >&2
  exit 1
fi

if [[ ! -f "$HOME/.config/copr" ]]; then
  cat >&2 <<'EOF'
Missing ~/.config/copr.
Create an API token at https://copr.fedorainfracloud.org/api/ and save it to ~/.config/copr.
EOF
  exit 1
fi

if ! copr-cli get "$PROJECT" >/dev/null 2>&1; then
  copr-cli create "$PROJECT" \
    --chroot fedora-44-x86_64 \
    --description 'Software Fn-lock daemon for ASUS ROG Flow Z13 GZ302 keyboard cover on Linux' \
    --instructions 'sudo dnf copr enable ttenneb/z13-fnlockd && sudo dnf install z13-fnlockd && sudo systemctl enable --now z13-fnlockd'
fi

copr-cli buildscm "$PROJECT" \
  --clone-url https://github.com/ttenneb/z13-fnlockd.git \
  --commit "$VERSION" \
  --spec z13-fnlockd.spec \
  --type git

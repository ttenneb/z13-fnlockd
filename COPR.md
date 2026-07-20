# COPR publishing notes

Recommended COPR project name: `z13-fnlockd`.

## One-time setup

Install tools and configure your COPR API token from <https://copr.fedorainfracloud.org/api/>:

```bash
sudo dnf install copr-cli rpm-build rpmdevtools
mkdir -p ~/.config
$EDITOR ~/.config/copr
```

Create the project:

```bash
copr-cli create z13-fnlockd \
  --chroot fedora-44-x86_64 \
  --description 'Software Fn-lock daemon for ASUS ROG Flow Z13 GZ302 keyboard cover on Linux' \
  --instructions 'sudo dnf copr enable ttenneb/z13-fnlockd && sudo dnf install z13-fnlockd && sudo systemctl enable --now z13-fnlockd'
```

## Build from a GitHub release tag

After tagging a release, build from the spec in this repo:

```bash
copr-cli buildscm z13-fnlockd \
  --clone-url https://github.com/ttenneb/z13-fnlockd.git \
  --commit v0.1.1 \
  --spec z13-fnlockd.spec \
  --type git
```

## User install command

```bash
sudo dnf copr enable ttenneb/z13-fnlockd
sudo dnf install z13-fnlockd
sudo systemctl enable --now z13-fnlockd
```

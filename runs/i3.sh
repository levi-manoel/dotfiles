#!/usr/bin/env bash

set -euo pipefail

sudo dnf copr enable -y alternateved/i3status-rust
sudo dnf copr enable -y skidnik/clipmenu

sudo dnf install -y \
  i3 \
  rofi \
  i3lock \
  xss-lock \
  dunst \
  dex-autostart \
  network-manager-applet \
  picom \
  i3status-rust \
  clipmenu

systemctl --user enable clipmenud.service

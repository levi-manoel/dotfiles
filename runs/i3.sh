#!/usr/bin/env bash

set -euo pipefail

sudo dnf copr enable -y alternateved/i3status-rust

# sudo dnf install -y i3 i3blocks rofi dex i3lock i3status-rust
sudo dnf install -y i3status-rust

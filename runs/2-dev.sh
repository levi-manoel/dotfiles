#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y git tmux tldr fzf ripgrep

if [[ "${RUN_NO_DISPLAY:-0}" != "1" ]]; then
    sudo dnf install -y xclip brightnessctl playerctl flameshot blueman feh
fi

tldr --update

sudo usermod -aG video $USER


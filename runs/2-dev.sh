#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y git tmux tldr fzf ripgrep

if [[ "${RUN_NO_DISPLAY:-0}" != "1" ]]; then
    sudo dnf install -y \
      xclip \
      xsel \
      xinput \
      brightnessctl \
      playerctl \
      flameshot \
      blueman \
      feh \
      easyeffects
fi

tldr --update

sudo usermod -aG video $USER

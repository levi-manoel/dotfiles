#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y git tmux tldr xclip fzf ripgrep brightnessctl playerctl flameshot blueman feh

tldr --update

sudo usermod -aG video $USER


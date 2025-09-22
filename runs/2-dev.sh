#!/usr/bin/env bash

# Update system and install packages using yay
yay -Syu --noconfirm \
  git tmux tldr xclip fzf ripgrep brightnessctl playerctl flameshot blueman

# Update tldr cache
tldr --update


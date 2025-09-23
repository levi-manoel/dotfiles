#!/usr/bin/env bash

yay -Syu --noconfirm \
  git tmux tldr xclip fzf ripgrep rsync wget rsync meson cpio cmake

hyprpm update
hyprpm add https://github.com/outfoxxed/hy3
hyprpm enable hy3

tldr --update

curl -fsSL https://bun.sh/install | bash


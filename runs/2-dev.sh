#!/usr/bin/env bash

yay -Syu --noconfirm \
  git tmux tldr xclip fzf ripgrep rsync wget rsync

tldr --update

curl -fsSL https://bun.sh/install | bash


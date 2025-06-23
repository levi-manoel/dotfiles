#!/usr/bin/env bash

sudo apt -y install git tmux tldr xclip fzf ripgrep brightnessctl playerctl

tldr --update

sudo usermod -aG video $USER


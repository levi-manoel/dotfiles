#!/usr/bin/env bash

set -euo pipefail

wget --output-document /tmp/victor-nomo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/VictorMono.zip
wget --output-document /tmp/mona.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Monaspace.zip

mkdir -p "$HOME/tmp"

sudo dnf install -y unzip
mkdir -p /tmp/unziped-sources
mkdir -p "$HOME/.local/share/fonts"

unzip -o /tmp/victor-nomo.zip -d /tmp/unziped-sources
unzip -o /tmp/mona.zip -d /tmp/unziped-sources

mv /tmp/unziped-sources/*.ttf "$HOME/.local/share/fonts/"
fc-cache -fv

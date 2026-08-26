#!/usr/bin/env bash
#
# Nerd fonts + app font tweaks. unzip comes from packages.sh.

set -euo pipefail

wget --output-document /tmp/victor-nomo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/VictorMono.zip
wget --output-document /tmp/mona.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Monaspace.zip

mkdir -p "$HOME/tmp"
mkdir -p /tmp/unziped-sources
mkdir -p "$HOME/.local/share/fonts"

unzip -o /tmp/victor-nomo.zip -d /tmp/unziped-sources
unzip -o /tmp/mona.zip -d /tmp/unziped-sources

mv /tmp/unziped-sources/*.ttf "$HOME/.local/share/fonts/"
fc-cache -fv

# Chrome Preferences + Slack CSS inject (best-effort; Slack needs re-run after updates)
"$HOME/dev/personal/dotfiles/bin/set-app-fonts" || true

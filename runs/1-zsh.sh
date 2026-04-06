#!/usr/bin/env bash

set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
  sudo dnf install -y zsh util-linux-user
fi

ZSH_BIN="$(command -v zsh)"
hash -r || true

current_shell="$(getent passwd "$USER" | cut -d: -f7 || true)"
if [[ "$current_shell" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  export RUNZSH=no
  export CHSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


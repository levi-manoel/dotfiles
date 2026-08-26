#!/usr/bin/env bash
#
# Default shell + oh-my-zsh. Package install is in packages.sh.

set -euo pipefail

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

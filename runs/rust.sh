#!/usr/bin/env bash

set -euo pipefail

# spotatui (librespot/cpal) needs ALSA headers on Fedora
sudo dnf install -y alsa-lib-devel gcc

if ! command -v rustup >/dev/null 2>&1 && [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# shellcheck disable=SC1091
. "$HOME/.cargo/env"

if ! command -v spotatui >/dev/null 2>&1; then
  cargo install spotatui
fi

#!/usr/bin/env bash
#
# Enable repos/coprs, then one dnf install for base (+ optional display) packages.

set -euo pipefail

# --- repos (idempotent) ---
sudo dnf install -y dnf-plugins-core fedora-workstation-repositories

sudo dnf copr enable -y alternateved/i3status-rust
sudo dnf copr enable -y skidnik/clipmenu
sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y copart/dbeaver

sudo dnf config-manager setopt google-chrome.enabled=1

DOCKER_CE_REPO="https://download.docker.com/linux/fedora/docker-ce.repo"
if dnf config-manager addrepo --help 2>&1 | grep -qF 'from-repofile'; then
  sudo dnf config-manager addrepo --from-repofile="${DOCKER_CE_REPO}"
else
  sudo dnf config-manager --add-repo "${DOCKER_CE_REPO}"
fi

if [[ "${RUN_NO_DISPLAY:-0}" != "1" ]]; then
  curl -fsSL https://packagecloud.io/install/repositories/slacktechnologies/slack/script.rpm.sh | sudo bash
fi

# --- packages ---
base=(
  zsh
  util-linux-user
  git
  tmux
  tldr
  fzf
  ripgrep
  jq
  neovim
  unzip
  alsa-lib-devel
  gcc
  redis
  direnv
  earlyoom
  systemd-oomd-defaults
  lxqt-policykit
  udiskie
  power-profiles-daemon
  thermald
  switcheroo-control
  libva-nvidia-driver
  libva-intel-media-driver
  libva-utils
  docker-ce
  docker-ce-cli
  containerd.io
  docker-buildx-plugin
  docker-compose-plugin
)

display=(
  xclip
  xsel
  xinput
  brightnessctl
  playerctl
  flameshot
  blueman
  feh
  easyeffects
  obs-studio
  i3
  rofi
  i3lock
  xss-lock
  dunst
  dex-autostart
  network-manager-applet
  picom
  i3status-rust
  clipmenu
  ghostty
  google-chrome-stable
  dbeaver-ce
  slack
)

pkgs=("${base[@]}")
if [[ "${RUN_NO_DISPLAY:-0}" != "1" ]]; then
  pkgs+=("${display[@]}")
fi

sudo dnf install -y "${pkgs[@]}"

tldr --update || true

if [[ "${RUN_NO_DISPLAY:-0}" != "1" ]]; then
  systemctl --user enable clipmenud.service
fi

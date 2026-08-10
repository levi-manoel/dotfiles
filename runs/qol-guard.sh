#!/usr/bin/env bash
#
# QoL for Fedora i3 laptop:
#   polkit + udiskie, journal/coredump caps, SysRq REISUB,
#   power-profiles + thermald, NVIDIA VAAPI + switcheroo,
#   Dell BAT0 charge thresholds

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEM_DIR="${ROOT_DIR}/system"

sudo dnf -y install \
  lxqt-policykit \
  udiskie \
  power-profiles-daemon \
  thermald \
  switcheroo-control \
  libva-nvidia-driver \
  libva-intel-media-driver \
  libva-utils

# --- drop-in configs ---
sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/systemd/journald.conf.d/99-size.conf" \
  /etc/systemd/journald.conf.d/99-size.conf

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/systemd/coredump.conf.d/99-limit.conf" \
  /etc/systemd/coredump.conf.d/99-limit.conf

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/sysctl.d/99-qol.conf" \
  /etc/sysctl.d/99-qol.conf

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/systemd/system/battery-charge-threshold.service" \
  /etc/systemd/system/battery-charge-threshold.service

sudo sysctl --system >/dev/null
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload

sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now thermald.service
sudo systemctl enable --now switcheroo-control.service
sudo systemctl enable --now battery-charge-threshold.service

# Vacuum existing journal down toward the new cap
sudo journalctl --vacuum-size=300M >/dev/null || true

echo "qol-guard: polkit=$(rpm -q lxqt-policykit)"
echo "qol-guard: power=$(powerprofilesctl get 2>/dev/null || echo n/a) thermald=$(systemctl is-active thermald) switcheroo=$(systemctl is-active switcheroo-control)"
echo "qol-guard: bat thresholds=$(cat /sys/class/power_supply/BAT0/charge_control_start_threshold 2>/dev/null)/$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null)"
echo "qol-guard: sysrq=$(cat /proc/sys/kernel/sysrq) journal=$(journalctl --disk-usage 2>/dev/null | tr -s ' ')"
echo "qol-guard: reload i3 (or re-login) for polkit/udiskie/chrome desktop"

#!/usr/bin/env bash
#
# Drop-ins under /etc, systemd enables, and group membership.
# Packages themselves come from packages.sh.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEM_DIR="${ROOT_DIR}/system"

# --- oom-guard ---
sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/default/earlyoom" \
  /etc/default/earlyoom

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/sysctl.d/99-oom-guard.conf" \
  /etc/sysctl.d/99-oom-guard.conf

# --- qol-guard ---
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

sudo systemctl enable --now earlyoom.service
sudo systemctl enable --now systemd-oomd.socket systemd-oomd.service
sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now thermald.service
sudo systemctl enable --now switcheroo-control.service
sudo systemctl enable --now battery-charge-threshold.service
sudo systemctl enable --now docker
sudo systemctl enable --now redis

sudo journalctl --vacuum-size=300M >/dev/null || true

sudo usermod -aG docker "$USER"
sudo usermod -aG video "$USER"

echo "system: earlyoom=$(systemctl is-active earlyoom) systemd-oomd=$(systemctl is-active systemd-oomd)"
echo "system: power=$(powerprofilesctl get 2>/dev/null || echo n/a) thermald=$(systemctl is-active thermald) switcheroo=$(systemctl is-active switcheroo-control)"
echo "system: bat thresholds=$(cat /sys/class/power_supply/BAT0/charge_control_start_threshold 2>/dev/null)/$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null)"
echo "system: sysrq=$(cat /proc/sys/kernel/sysrq) journal=$(journalctl --disk-usage 2>/dev/null | tr -s ' ')"
echo "system: docker=$(systemctl is-active docker) redis=$(systemctl is-active redis)"
echo "system: log out/in for docker+video groups; reload i3 for polkit/udiskie/chrome desktop"

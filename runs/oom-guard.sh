#!/usr/bin/env bash
#
# Prevent freezes when RAM fills up:
#   1. earlyoom     — userspace killer before the kernel hangs
#   2. systemd-oomd — cgroup memory-pressure killer (Fedora default)
#   3. sysctl       — slightly friendlier OOM / zram behaviour

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEM_DIR="${ROOT_DIR}/system"

sudo dnf -y install earlyoom systemd-oomd-defaults

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/default/earlyoom" \
  /etc/default/earlyoom

sudo install -D -m 0644 \
  "${SYSTEM_DIR}/etc/sysctl.d/99-oom-guard.conf" \
  /etc/sysctl.d/99-oom-guard.conf

sudo sysctl --system >/dev/null

sudo systemctl enable --now earlyoom.service
sudo systemctl enable --now systemd-oomd.socket systemd-oomd.service

# Ensure user slices are managed by oomd (Fedora ships defaults via package).
if [[ -f /usr/lib/systemd/system/user@.service.d/20-systemd-oomd.conf ]] || \
   systemctl show -p DropInPaths user@1000.service 2>/dev/null | grep -q oomd; then
  :
fi

echo "oom-guard: earlyoom=$(systemctl is-active earlyoom) systemd-oomd=$(systemctl is-active systemd-oomd)"

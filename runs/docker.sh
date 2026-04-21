#!/usr/bin/env bash

set -euo pipefail

sudo dnf -y install dnf-plugins-core

# dnf5 (Fedora 41+): addrepo --from-repofile=…  |  dnf4: --add-repo …
DOCKER_CE_REPO="https://download.docker.com/linux/fedora/docker-ce.repo"
if dnf config-manager addrepo --help 2>&1 | grep -qF 'from-repofile'; then
  sudo dnf config-manager addrepo --from-repofile="${DOCKER_CE_REPO}"
else
  sudo dnf config-manager --add-repo "${DOCKER_CE_REPO}"
fi
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

sudo usermod -aG docker $USER

echo "Docker installed. You may need to log out/in for docker group to apply."

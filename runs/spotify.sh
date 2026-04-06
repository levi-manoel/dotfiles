#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-spotify.repo

sudo dnf install -y spotify-client spotify-ffmpeg

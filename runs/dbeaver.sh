#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y dnf-plugins-core
sudo dnf copr enable -y copart/dbeaver
sudo dnf install -y dbeaver-ce

#!/usr/bin/env bash

set -euo pipefail

sudo dnf copr enable -y scottames/ghostty
sudo dnf install -y ghostty

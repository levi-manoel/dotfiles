#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y fedora-workstation-repositories dnf-plugins-core
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install -y google-chrome-stable


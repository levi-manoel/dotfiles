#!/usr/bin/env bash

# Install base packages (pacman)
yay -S --noconfirm redis direnv npm
sudo npm install -g eslint

# Enable Redis
sudo systemctl enable --now redis

# Install Slack (AUR package, here with yay)
# yay -S --noconfirm slack-desktop

# Install Nix
# sh <(curl -L https://nixos.org/nix/install) --daemon
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon

# /nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable

# Install Google Cloud SDK
pushd "$HOME/dev/irancho"
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
rm google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
popd

# Install Cloud SQL Proxy
curl -L "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.17.1/cloud-sql-proxy.linux.amd64" \
  -o "$HOME/dev/irancho/cloud-sql-proxy"
chmod +x "$HOME/dev/irancho/cloud-sql-proxy"

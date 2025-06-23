#! /usr/bin/env bash

sudo apt -y install redis-server direnv

sudo systemctl start redis-server
sudo systemctl enable redis-server

sh <(curl -L https://nixos.org/nix/install) --daemon
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon

/nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable


#!/usr/bin/env bash

sudo apt -y install git redis-server tmux tldr

git config --global user.email "levimanoel.deob@gmail.com"
git config --global user.name "levi-manoel"

sudo systemctl start redis-server
sudo systemctl enable redis-server

tldr --update

sh <(curl -L https://nixos.org/nix/install) --daemon
nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable

sudo echo "trusted-users = root $USER" >> /etc/nix/nix.conf
sudo systemctl restart nix-daemon

 sudo usermod -aG video $USER


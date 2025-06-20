#!/usr/bin/env bash

sudo apt -y install git tmux tldr xclip fzf ripgrep #lxappearance

tldr --update

sh <(curl -L https://nixos.org/nix/install) --daemon
/nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable

sudo echo "trusted-users = root $USER" >> /etc/nix/nix.conf
sudo echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
sudo systemctl restart nix-daemon

sudo usermod -aG video $USER


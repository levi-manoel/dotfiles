#!/bin/bash

git_repo_bashrc="/home/levi/dev/personal/dotfiles/bash-config/.bashrc"
git_repo_nixos_config="/home/levi/dev/personal/dotfiles/nixos-config/configuration.nix"
git_repo_nixos_hardware="/home/levi/dev/personal/dotfiles/nixos-config/hardware.nix"
system_bashrc="/home/levi/.bashrc"
system_nixos_config="/etc/nixos/configuration.nix"
system_nixos_hardware="/etc/nixos/hardware-configuration.nix"

if cmp -s "$git_repo_bashrc" "$system_bashrc"; then
    printf '.bashrc is synchronized\n'
else
    printf '\n\n'
    cat $git_repo_bashrc | tee $system_bashrc
    printf '\n\n'
fi

if cmp -s "$git_repo_nixos_config" "$system_nixos_config"; then
    printf 'configuration.nix is synchronized\n'
else
    printf '\n\n'
    cat $git_repo_nixos_config | sudo tee $system_nixos_config
    printf '\n\n'
fi

if cmp -s "$git_repo_nixos_hardware" "$system_nixos_hardware"; then
    printf 'hardware.nix is synchronized\n'
else
    printf '\n\n'
    cat $git_repo_nixos_hardware | sudo tee $system_nixos_hardware
    printf '\n\n'
fi

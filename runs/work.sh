#! /usr/bin/env bash

mkdir -p $HOME/dev/irancho

sudo apt -y install redis-server direnv eslint

sudo systemctl start redis-server
sudo systemctl enable redis-server

curl -L -o /tmp/slack.deb "https://slack.com/intl/pt-br/downloads/instructions/linux?ddl=1&build=deb"
sudo apt install /tmp/slack.deb

sh <(curl -L https://nixos.org/nix/install) --daemon
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon

/nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable

pushd $HOME/dev/irancho
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
rm google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
popd

curl "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.17.1/cloud-sql-proxy.linux.amd64" -o $HOME/dev/irancho/cloud-sql-proxy
chmod +x $HOME/dev/irancho/cloud-sql-proxy


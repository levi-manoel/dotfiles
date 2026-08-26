#!/usr/bin/env bash
#
# Language/toolchains and work tooling that are not dnf packages.
# Order matters: nvm/npm before eslint; gcc (from packages.sh) before cargo.

set -euo pipefail

# --- node / go / bun ---
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
sudo wget --output-document /tmp/go.tar.gz https://go.dev/dl/go1.25.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz

# shellcheck disable=SC1091
. "$HOME/.nvm/nvm.sh"
nvm install 22

sudo npm i -g @vue/language-server
sudo npm install -g eslint

curl -fsSL https://bun.sh/install | bash

# --- rust / spotatui (needs alsa-lib-devel + gcc from packages.sh) ---
if ! command -v rustup >/dev/null 2>&1 && [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# shellcheck disable=SC1091
. "$HOME/.cargo/env"

if ! command -v spotatui >/dev/null 2>&1; then
  cargo install spotatui
fi

# --- nix / devenv ---
sh <(curl -L https://nixos.org/nix/install) --daemon
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon

/nix/var/nix/profiles/default/bin/nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable

# --- gcloud / cloud-sql-proxy / pulumi ---
mkdir -p "$HOME/dev/irancho"

pushd "$HOME/dev/irancho"
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
rm google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
popd

curl "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.17.1/cloud-sql-proxy.linux.amd64" \
  -o "$HOME/dev/irancho/cloud-sql-proxy"
chmod +x "$HOME/dev/irancho/cloud-sql-proxy"

curl -fsSL https://get.pulumi.com | sh

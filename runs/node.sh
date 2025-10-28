#!/usr/bin/env bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
sudo wget --output-document /tmp/go.tar.gz https://go.dev/dl/go1.25.3.linux-amd64.tar.gz

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz

\. "$HOME/.nvm/nvm.sh"

nvm install 22

curl -fsSL https://bun.sh/install | bash

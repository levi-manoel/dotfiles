#!/usr/bin/env bash

curl -L -o /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install /tmp/discord.deb


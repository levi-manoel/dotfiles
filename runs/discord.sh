#!/usr/bin/env bash

wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install /tmp/discord.deb

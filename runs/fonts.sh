#!/usr/bin/env bash

wget --output-document /tmp/victor-nomo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/VictorMono.zip
wget --output-document /tmp/mona.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Monaspace.zip

mkdir $HOME/tmp

sudo mkdir -p /tmp/unziped-sources
sudo mkdir -p /usr/local/share/fonts

sudo unzip /tmp/victor-nomo.zip -d /tmp/unziped-sources
sudo unzip /tmp/mona.zip -d /tmp/unziped-sources

sudo mv /tmp/unziped-sources/*.ttf /usr/local/share/fonts/ 
fc-cache -fv


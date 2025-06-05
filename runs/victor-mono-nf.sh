#!/usr/bin/env bash

wget --output-document /tmp/victor-nomo.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/VictorMono.zip

mkdir /tmp/unzipede-vm
unzip /tmp/victor-nomo.zip -d /tmp/unzipede-vm
mv /tmp/unzipede-vm/*.ttf /usr/local/share/fonts/ 

fc-cache -fv

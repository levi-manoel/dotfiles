#!/usr/bin/env bash

version="v0.12.0"
if [ ! -z $NVIM_VERSION ]; then
    version="$NVIM_VERSION"
fi

echo "version: \"$version\""

if [ ! -d $HOME/neovim ]; then
    git clone https://github.com/neovim/neovim.git $HOME/neovim
fi

sudo apt -y install cmake gettext lua5.1 liblua5.1-0-dev

git -C ~/neovim fetch --all
git -C ~/neovim checkout $version

make -C ~/neovim clean
make -C ~/neovim CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make -C ~/neovim install

wget --output-document /tmp/luarocks.tar.gz https://luarocks.org/releases/luarocks-3.11.0.tar.gz
tar zxpf /tmp/luarocks.tar.gz -C /tmp
cd /tmp/luarocks-3.11.0
./configure && make && sudo make install

luarocks install luacheck


#! /usr/bin/env bash

sudo apt -y install redis-server

sudo systemctl start redis-server
sudo systemctl enable redis-server


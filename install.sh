#!/bin/sh

sudo ./install/common/apt-packages.sh
sudo pip3 install -r ./install/common/requirements.txt
sudo pip install -r ./install/common/requirements.txt
./install/common/vim-plugins.sh

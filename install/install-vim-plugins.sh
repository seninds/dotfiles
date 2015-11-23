#!/bin/bash

declare -a VIM_PLUGINS_REPOS=("https://github.com/nvie/vim-flake8.git"
                              "https://github.com/klen/python-mode.git")

VIM_BUNDLE_DIR=~/.vim/bundle
for PLUGIN_REPO in "${VIM_PLUGINS_REPOS[@]}"; do
    $(cd $VIM_BUNDLE_DIR && git clone $PLUGIN_REPO)
done

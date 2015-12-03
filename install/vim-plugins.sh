#!/bin/bash

declare -a VIM_PLUGINS_REPOS=("https://github.com/nvie/vim-flake8"
                              "https://github.com/tell-k/vim-autopep8")

VIM_BUNDLE_DIR=~/.vim/bundle
for PLUGIN_REPO in "${VIM_PLUGINS_REPOS[@]}"; do
    LOCAL_REPO_PATH="$VIM_BUNDLE_DIR"/$(basename "$PLUGIN_REPO")
    if [ -e "$LOCAL_REPO_PATH" ]; then
        echo "updating repo '$PLUGIN_REPO' in '$LOCAL_REPO_PATH'..."
        git pull "$LOCAL_REPO_PATH"
    else
        echo "cloning repo '$PLUGIN_REPO' to '$LOCAL_REPO_PATH'..."
        git clone "$PLUGIN_REPO" "$LOCAL_REPO_PATH"
    fi
done

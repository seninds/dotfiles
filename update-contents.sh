#!/bin/bash

if ! cmp -s ~/.bashrc .bashrc ; then
    cp -f .bashrc ~
fi

if ! cmp -s ~/.vimrc .vimrc ; then
    cp -f .vimrc ~
fi

if [ ! -e ~/.bash ]; then
    cp -rf .bash ~
else
    REPO_FILES=$(find .bash -type f)
    for REPO_FILE in $REPO_FILES; do
        if [ ! -e $HOME/$REPO_FILE ] || ! cmp -s $REPO_FILE $HOME/$REPO_FILE ; then
            cp -f $REPO_FILE $HOME/$REPO_FILE
        fi
    done
fi

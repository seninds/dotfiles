#!/bin/sh

if [ -f ~/.bash/bash_env ]; then . ~/.bash/bash_env; fi
if [ -f ~/.bash/bash_aliases ]; then . ~/.bash/bash_aliases; fi
if [ -f ~/.bash/bash_prompt ]; then . ~/.bash/bash_prompt; fi
if [ -f ~/.bash/bash_functions ]; then . ~/.bash/bash_functions; fi
if [ -f ~/.bash/bash_svn ]; then . ~/.bash/bash_svn; fi
if [ -f ~/.bash/bash_custom ]; then . ~/.bash/bash_custom; fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

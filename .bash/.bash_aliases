#!/bin/sh

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Python
alias py='python'
alias ipy='ipython'

# CMake
alias cmake-dbg='cmake $1 -DCMAKE_BUILD_TYPE=DEBUG'
alias cmake-rls='cmake $1 -DCMAKE_BUILD_TYPE=RELEASE'

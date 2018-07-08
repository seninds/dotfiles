# ==============================================================================
# Description
#
# Sections:
# 1. Environment Configuration
# 2. Make Terminal Better
# 3. Process Management
# 4. Networking
# ==============================================================================

# ==============================================================================
# 1. Environment Configuration
# ==============================================================================

export EDITOR=vim
export BLOCKSIZE=1k

export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"

export PATH="$PATH:$HOME/bin:$GOBIN"

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

#-------------------------------------------------------------------------------
# SSH-AGENT
if command -v ssh-agent >/dev/null 2>&1 ; then
    SSH_ENV="$HOME/.ssh/env"

    function start_agent {
         echo "Initialising new SSH agent..."
         mkdir -p "$(dirname "${SSH_ENV}")"
         ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
         echo succeeded
         chmod 600 "${SSH_ENV}"
         source "${SSH_ENV}" > /dev/null
         ssh-add
    }

    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
         source "${SSH_ENV}" > /dev/null
         ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || start_agent
    else
         start_agent;
    fi
fi


# ==============================================================================
# 2. Make Terminal Better
# ==============================================================================

alias ll='ls -lAFGh'
alias la='ls -aAlFGh'

alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# ------------------------------------------------------------------------------
# Color Prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
else
	color_prompt=
fi
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt


# ==============================================================================
# 3. Process Management
# ==============================================================================

function find_pid () { lsof -t -c "$@" ; }
alias mem_hogs='ps wwaxm -o pid,stat,%mem,vsize,rss,time,command | head -10'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'


# ==============================================================================
# 4. Networking
# ==============================================================================
alias my_ip='curl ipecho.net/plain ; echo'
alias net_cons='lsof -i'
alias lsock='sudo /usr/sbin/lsof -i -P'
alias lsock_u='sudo /usr/sbin/lsof -nP | grep UDP'
alias lsock_t='sudo /usr/sbin/lsof -nP | grep TCP'
alias open_ports='sudo lsof -i | grep LISTEN'
alias show_blocked='sudo ipfw list'

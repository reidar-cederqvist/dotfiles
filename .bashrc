# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

SSH_AGENT_FILE="$HOME/.ssh_agent.run"
if [ ! -f "$SSH_AGENT_FILE" -o "$(pidof ssh-agent)" == "" ]; then
	killall -9 ssh-agent 2>/dev/null
	echo "$(ssh-agent)" > $SSH_AGENT_FILE
fi
eval $(cat $SSH_AGENT_FILE) 2>&1 >/dev/null

. ~/.prompt_colors.sh
export TERM=xterm

# Remove spaces from path
tmp=$(echo $PATH | tr ':' '\n' | grep -v ' ' | tr '\n' ':')
PATH=${tmp%:}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#repository_root="$HOME/.local/lib/python2.7/site-packages"
#. ${repository_root}/powerline/bindings/bash/powerline.sh
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	fi
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# some functions for stuff that is to advanced for alias

router(){
	if [ "$1" == "1" ]; then vlan="enp5s0.400";
	elif [ "$1" == "2" ]; then vlan="enp5s0.401";
	elif [ "$1" == "3" ]; then vlan="enp5s0.402";
	else
		return;
	fi
	sudo ifdown enp5s0.400 >/dev/null
	sudo ifdown enp5s0.401 >/dev/null
	sudo ifdown enp5s0.402 >/dev/null
	sudo ifup $vlan >/dev/null
}

iopa(){
	cd $HOME/git/iopsys || return 1
	git co devel || return 1
	git pull || return 1
	iopf || return 1
	iopg -c dg400 REIDAR || return 1
	mp || return 1
	iops || return 1
}

# Launch pfetch
if which pfetch 2>/dev/null >/dev/null; then
	pfetch
fi

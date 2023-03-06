# My zsh config. github.com/reidar-cederqvist

### EXPORT
export TERM="xterm-256color"                      # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="vim"

### "vim" as manpager
export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### SET VI MODE ###
bindkey -v

# If not running interactively, don't do anything
[[ $- != *i* ]]&& return

### PATH
if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then 
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ]; then
	PATH="$HOME/Applications:$PATH"
fi

if [ -d "/var/lib/flatpak/exports/bin/" ]; then
	PATH="/var/lib/flatpak/exports/bin/:$PATH"
fi

### SETTING OTHER ENVIRONMENT VARIABLES
if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
fi

### CHANGE TITLE OF TERMINALS
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
colorscript random

### BASH INSULTER (works in zsh though) ###
if [ -f /etc/bash.command-not-found ]; then
	. /etc/bash.command-not-found
fi

if [ -f $HOME/.bash_aliases ]; then
	. $HOME/.bash_aliases
fi

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init zsh)"

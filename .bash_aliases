#!/bin/bash
#~/.bash_aliases

alias exit='exit 0'
alias sudo='sudo -E'
alias iopf='./iop feeds_update'
alias iopu='./iop update_package'
alias iopg='./iop genconfig'
alias iopb='./iop bootstrap'
alias iops='./iop ssh_sysupgrade_latest 192.168.1.1'
alias scp='scp -O'
alias mp='make -j$(nproc)'
alias reboot='systemctl reboot'
alias shutdown='systemctl shutdown'
alias resetkb='setxkbmap -layout se -variant nodeadkeys'
alias c='clear'

# ls aliases
# Changing "ls" to "exa"
if which exa >/dev/null 2>/dev/null; then
	alias la='exa -a --color=always --group-directories-first'  # all files and dirs
	alias ll='exa -ahlF --color=always --group-directories-first'  # long format
	alias lt='exa -aT --color=always --group-directories-first' # tree listing
	alias l.='exa -a | egrep "^\."'
else
	alias ls='ls -al --color=always --group-directories-first' # my preferred listing
	alias la='ls -a --color=always --group-directories-first'  # all files and dirs
	alias ll='ls -ahlF --color=always --group-directories-first'  # long format
	alias lt='ls -aT --color=always --group-directories-first' # tree listing
	alias l.='ls -a | egrep "^\."'
fi

# Colorize output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# Edit dotfiles
alias ev='vim ~/.vimrc'
alias eb='vim ~/.bashrc'
alias ez='vim ~/.zshrc'
alias eba='vim ~/.bash_aliases'
alias ei='vim ~/.config/i3/config-template'
alias ea='vim ~/.config/alacritty/alacritty.yml'
alias eh='vim ~/.config/hypr/hyprland.conf'
alias ehp='vim ~/.config/hypr/hyprpaper.conf'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git aliases
alias gl="git log --tags --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=format-local:%y%m%d-%H%M"
alias gl1="git rev-parse HEAD"

# Gerrit remove all remotes except for origin
alias rmo='for o in $(git remote); do if [ "$o" != "origin" ]; then git remote remove $o; fi; done'

# do not overwrite files without -f flag
alias mv='mv -i'
alias cp='cp -i'

# Improved output
alias df='df -h'
alias free='free -m'
alias lsblk='lsblk -o name,mountpoint,label,size,uuid'
alias rename='perl-rename'

alias buildserver='ssh se-ci-sbs1.genexislocal.nl'

setup(){
	if dir="$(git rev-parse --git-dir 2>/dev/null)"; then
		git_home=${dir%%.git}
		git_home=${git_home:-.}
		pushd $git_home
		$HOME/gerrit-setup.sh
		popd >/dev/null
	else
		echo "Not a git directory"
	fi
}

# aliases for git --bare
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
source /usr/share/bash-completion/completions/git
__git_complete config __git_main

# scan image
alias scan600='scanimage -d escl:http://10.10.101.5:8080 --format jpeg --resolution 600dpi -x 210 -y 297 -o'
alias scanhd='scanimage -d escl:http://10.10.101.5:8080 --format jpeg --resolution 1200dpi -x 210 -y 297 -o'

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

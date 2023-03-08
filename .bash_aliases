#!/bin/bash
#~/.bash_aliases

alias exit='exit 0'
alias sudo='sudo -E'
alias sshgw='ssh root@192.168.1.1'
alias iopf='./iop feeds_update'
alias iopu='./iop update_package'
alias iopg='./iop genconfig'
alias iopb='./iop bootstrap'
alias iops='./iop ssh_sysupgrade_latest 192.168.1.1'
alias ci='versiontag="4.3.2.20" && sed -i -e "/CONFIG_TARGET_VERSION=/ s/=.*/=\"${versiontag}\"/" .config'
alias mp='make -j$(nproc)'
alias mj='make package/feeds/feed_inteno_juci/juci/compile'
alias mjp='make package/feeds/feed_inteno_juci/juci/compile -j9'
alias reboot='systemctl reboot'
alias shutdown='systemctl shutdown'
alias resetkb='setxkbmap -layout se -variant nodeadkeys'
alias c='clear'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -c'
# ls aliases
if which exa 2>&1 >/dev/null; then
	alias ls='exa'
	alias ll='exa -ahlF'
	alias la='exa -A'
	alias l='exa -CF'
else
	alias ll='ls -ahlF'
	alias la='ls -A'
	alias l='ls -CF'
fi
alias ev='vim ~/.vimrc'
alias eb='vim ~/.bashrc'
alias eba='vim ~/.bash_aliases'
alias ei='vim ~/.config/i3/config'
alias et='vim ~/.config/termite/config'
alias ssys='./iop ssh_sysupgrade_latest'
alias buildserver="ssh 10.10.1.31"
alias jenkins3="ssh inteno@10.10.1.17"
alias jenkins2="ssh inteno@10.10.1.31"
alias jenkins="ssh inteno@10.10.1.14"
alias lsblk='lsblk -o name,mountpoint,label,size,uuid'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias gl="git log --tags --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=format-local:%y%m%d-%H%M"
alias gl1="git rev-parse HEAD"
alias sshs="ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 admin@10.10.1.181"
alias rmo='for o in $(git remote); do if [ "$o" != "origin" ]; then git remote remove $o; fi; done'
alias mv='mv -i'
alias rm='rm -i'
mkpkg(){
	[ "`git remote -v 2>/dev/null | grep iopsys`" == "" ] && echo "no iopsys git" && return
	make package/$1/compile ${@:2}
}
alias testserver='ssh god@10.0.104.10'
iopa(){
	[ "$1" == "" ] && echo "usage: iopa <board>" && return 1
	iopf
	iopg -c $1 DEV
	mp
}
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
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
source /usr/share/bash-completion/completions/git
__git_complete config __git_main

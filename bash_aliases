#!/bin/bash
#~/.bash_aliases

alias iopf='./iop feeds_update'
alias iopu='./iop update_package'
alias iopg='./iop genconfig'
alias mp='rm -rf bin/* && make -j9'
alias mj='make package/feeds/feed_inteno_juci/juci/compile'
alias mjp='make package/feeds/feed_inteno_juci/juci/compile -j9'
alias reboot='systemctl reboot'
alias shutdown='systemctl shutdown'
alias resetkb='setxkbmap -layout se -variant nodeadkeys'
alias c='clear'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ev='vim ~/.vimrc'
alias eb='vim ~/.bashrc'
alias ei='vim ~/.config/i3/config'
alias buildserver="ssh 10.10.1.31"
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

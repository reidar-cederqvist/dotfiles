alias iopf='./iop feeds_update'
alias iopu='./iop update_package'
alias iopg='./iop genconfig'
alias mp='rm -rf bin/* && make -j9'
alias mj='make package/feeds/feed_inteno_juci/juci/compile'
alias mjp='make package/feeds/feed_inteno_juci/juci/compile -j9'
alias ll='ls -lah'
sett(){
	echo -en "\033]0;$1\a"
}
makepkg(){
	cd ~/iopsys
	[ "$1" == "" ] && echo "Need argument" && exit;
	make $(find package -name $1)/compile V=s
}

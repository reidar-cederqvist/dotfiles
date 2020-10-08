#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired configfiles in $DOTDIR
############################

DOTDIR="$HOME/dotfiles"

install_config_files(){
	dir=$DOTDIR/home
	olddir=$HOME/oldConfigs	# old config backup directory

	# create $olddir in homedir
	mkdir -p $olddir

	files=$(ls $dir)

	# backup existing config files in homedir to $olddir directory, then create symlinks 
	for file in $files; do
		target="$HOME/.$file"
		[ -h "$target" -a -e "$target" ] && continue		# symlink exist and works
		[ -h "$target" ] && rm -rf "$target"			# symlink is broken
		if [ -a "$target" ]
			then
				mv $target $olddir/$file.$(date '+%y-%m-%d').bak >/dev/null
		fi
		echo "installing $target"
		ln -s $dir/$file $target
	done
}

install_config_folders(){
	dir=$DOTDIR/config
	olddir=$HOME/oldConfigfolders	# old config folders backup directory
	confdir=$HOME/.config

	# create $olddir in homedir
	mkdir -p $olddir
	mkdir -p $confdir

	folders=$(ls $dir)

	# backup existing config folders in homedir to $olddir directory, then create symlinks 
	for folder in $folders; do
		target="$HOME/.config/$folder"
		[ -h "$target" -a -e "$target" ] && continue		# symlink exist and works
		[ -h "$target" ] && rm -rf "$target"			# symlink is broken
		if [ -a "$target" ]
			then
				mv $target $olddir/$folder.$(date '+%y-%m-%d').bak >/dev/null
		fi
		echo "installing $target"
		ln -s $dir/$folder $target
	done
}

install_programs(){
	# identify package manager (apt pacman)
	if command -v apt; then
		update="sudo apt update"
		query="dpkg -s"
		install="sudo apt install -yqq"
	elif command -v pacman; then
		update="sudo pacman -Syy"
		query="pacman -Qs"
		install="sudo pacman -Sq --noconfirm --needed"
	fi
	#install programs
	programsToInstall="
vim
lightdm
lightdm-gtk-greeter
i3
i3-wm
i3blocks
i3lock
compton
curl
conky-all
gnome-keyring
rofi
pasystray
feh
udiskie
network-manager-gnome
numlockx
pasystray"

	for pkg in $programsToInstall; do
		if ! $query $pkg >/dev/null 2>/dev/null
		then
			needed="$needed $pkg"
		fi
	done
	if [ -n "$needed" ]; then
		echo -n "install [ $needed ]? Y,n,e: "
		read ans
		if [ "$ans" == "e" ]; then
			read -e -p "Edit: " -i "$needed" newNeeded
			$install $newNeeded
		elif [ "$ans" == "" -o "$ans" == "y" ]; then
			$install $programsToInstall
		fi
	fi
}

install_vim-plug(){
	echo -n "install Vim-plug? [y]n: "
	read ans
	if [ "$ans" == "" -o "$ans" == "y" ]; then
		#download vim-plug
		echo installing Vim-plug
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
}

install_ssh_config(){
	if [ -a $DOTDIR/ssh_config ]
	then
		cp $DOTDIR/ssh_config $HOME/.ssh/config
	fi
}

set_keymap(){
	if ! grep -q 'nodeadkeys' $HOME/.profile; then
		cat <<EOF >> $HOME/.profile
if [ "\$DISPLAY" ]; then
	setxkbmap -layout se -variant nodeadkeys
fi
EOF
	fi
}

usage(){
	echo -e "$0 [action]"
	echo -e "actions:"
	echo -e "\tconfigure\t\tCopy config files and set keymap"
	echo -e "\tplug\t\tInstall Vim-plug"
	echo -e "\tinstall\t\tInstall some usefull programs"
}

main(){
	if [ $# -ne 1 ]; then
		usage
		exit 1
	fi

	case $1 in
		-h)
			usage
			exit 0
		;;
		configure|conf)
			set_keymap
			install_ssh_config
			install_config_files
			install_config_folders
		;;
		plug|p)
			install_vim-plug
		;;
		install|inst)
			install_programs
		;;
		*)
			usage
			exit 99
		;;
	esac
}

main $@

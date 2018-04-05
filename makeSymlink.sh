#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/oldDotfiles             # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="bashrc vimrc prompt_colors.sh gitconfig bash_aliases Xresources"

########## /Variables

# create dotfiles_old in homedir
mkdir -p $olddir

# change to the dotfiles directory
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
	if [ -a ~/.$file ]
		then
    	mv ~/.$file $olddir/ >/dev/null
	fi
    ln -s $dir/$file ~/.$file
done

programsToInstall="curl conky-all gnome-keyring rofi pasystray"
#install programs

echo -n "install $programsToInstall? [y]n: "
read ans
if [ "$ans" == "" -o "$ans" == "y" ]; then
	sudo apt-get install -yqq $programsToInstall
fi

if [ -z "$(ls ~/.vim/bundle/Vundle.vim 2>/dev/null)" ]; then
	echo -n "install Vundle? [y]n: "
	read ans
	if [ "$ans" == "" -o "$ans" == "y" ]; then
	#download vundle
		echo installing Vundle
		mkdir -p ~/.vim/bundle/
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
fi

#download juci
if [ -z "$(ls ~/git/juci 2>/dev/null)" ]; then
	echo -n "download juci? [y]n: "
	read ans
	if [ "$ans" == "" -o "$ans" == "y" ]; then
		echo downloading JUCI repo
		mkdir ~/git
		cd ~/git
		git clone git@public.inteno.se:juci juci
		cd ~/git/juci
		git checkout devel
		cp example-Makefile.local Makefile.local
	fi
fi

if [ -z "$(ls ~/git/iopsys 2>/dev/null)" ]; then
	echo -n "download iopsys? [y]n: "
	read ans
	if [ "$ans" == "" -o "$ans" == "y" ]; then
		cd ~/git
		echo downloading IOPSYS repo
		git clone git@public.inteno.se:iopsys iopsys
		cd iopsys
		git co devel
		./iop setup_host
		./iop bootstrap
	fi
fi

if [ -a ./ssh_config ]
	then
	cp ./ssh_config ~/.ssh/config
fi

loginfile="/etc/pam.d/login"
if [ "$(cat $loginfile | grep 'pam_gnome_keyring')" == "" ]; then
	sudo cp $loginfile /etc/pam.d.login.no-oldschool-convenience
	echo -e	'auth     optional  pam_gnome_keyring.so\n'\
	'session  optional  pam_gnome_keyring.so auto_start' |
		sudo tee -a $loginfile > /dev/null
fi

passwdfile="/etc/pam.d/passwd"
if [ "$(cat $passwdfile | grep 'pam_gnome_keyring')" == "" ]; then
	sudo cp $passwdfile /etc/pam.d.passwd.no-oldschool-convenience
	echo 'password  optional  pam_gnome_keyring.so' |
		sudo tee -a $passwdfile > /dev/null
fi

if [ "$(cat ~/.profile | grep 'gnome-keyring-daemon')" == "" ]; then
	echo '
if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --sh-syntax --exit-with-session)
fi
export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)' >> ~/.profile
fi

if ! grep 'nodeadkeys' $HOME/.profile; then
	echo "setxkbmap -layout se -variant nodeadkeys" >> $HOME/.profile
fi
echo "done creating symlinks"

#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/oldDotfiles             # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="bashrc vimrc prompt_colors.sh gitconfig bash_aliases"

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

programsToInstall="curl conky gnome-keyring"
#install programs

echo -n "install $programsToInstall? [y]n: "
read ans
if [ "$ans" == "" -o "$ans" == "y" ]; then
	sudo apt-get install -yqq $programsToInstall
fi

#download vundle
if [ -z "$(ls ~/.vim/bundle/Vundle.vim 2>/dev/null)" ]; then
	echo installing Vundle
	mkdir -p ~/.vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#download juci
if [ -z "$(ls ~/git/juci 2>/dev/null)" ]
	then
	echo downloading JUCI repo
	cd ~/git
	git clone git@public.inteno.se:juci juci
	cd ~/git/juci
	git checkout devel
	cp example-Makefile.local Makefile.local
fi

if [ -z "$(ls ~/git/iopsys 2>/dev/null)" ]
	then
	cd ~/git
	echo downloading IOPSYS repo
	git clone git@public.inteno.se:iopsys iopsys
	cd iopsys
	git co devel
	./iop setup_host
	./iop bootstrap
fi

if [ -a ./ssh_config ]
	then
	cp ./ssh_config ~/.ssh/config
fi

sudo cp /etc/pam.d/login /etc/pam.d.login.no-oldschool-convenience
sudo cp /etc/pam.d/passwd /etc/pam.d.passwd.no-oldschool-convenience
echo -e	'auth     optional  pam_gnome_keyring.so\n'\
'session  optional  pam_gnome_keyring.so auto_start' |
	sudo tee -a /etc/pam.d/login > /dev/null
echo 'password  optional  pam_gnome_keyring.so' |
	sudo tee -a /etc/pam.d/passwd > /dev/null
echo '
if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --sh-syntax --exit-with-session)
	export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
fi' >> ~/.profile

echo "done creating symlinks"

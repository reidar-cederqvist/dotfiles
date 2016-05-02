#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################
#Make sure this is run as root
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/oldDotfiles             # old dotfiles backup directory
files="bashrc vimrc tmux.conf Xresources gitconfig"    # list of files/folders to symlink in homedir

##########

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
#install curl
if [ -z "$(curl --version 2>/dev/null)" ]
	then
	echo 'installing curl'
	sudo apt-get install -yqq curl
fi
#download pathogen
if [ -z "$(ls ~/.vim/autoload)" ]
	then
	echo installing pathogen infect
	mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi
#download nerdtree
if [ -z "$(ls ~/.vim/bundle/nerdtree)" ]
	then
	echo instlaling nerdtree
	cd ~/.vim/bundle
	git clone https://github.com/scrooloose/nerdtree.git
fi
#download juci
if [ -z "$(ls ~/juci)" ]
	then
	echo downloading JUCI repo
	cd ~
	git clone git@public.inteno.se:juci.git juci && cd juci && cp example-Makefile.local Makefile.local
fi
if [ -z "$(ls ~/iopsys)" ]
	then
	cd ~
	echo downloading IOPSYS repo
	git clone git@public.inteno.se:iopsys-barrier-breaker iopsys && cd iopsys && git co devel && ./iop bootstrap
fi
if [ -a ./ssh_config ]
	then
	cp ./ssh_config ~/.ssh/config
fi
echo "done creating symlinks"

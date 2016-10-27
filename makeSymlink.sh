#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/oldDotfiles             # old dotfiles backup directory
files="bashrc vimrc prompt_colors.sh gitconfig bash_aliases"    # list of files/folders to symlink in homedir

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
#download vundle
if [ -z "$(ls ~/.vim/bundle/Vundle.vim 2>/dev/null)" ]; then
	echo installing Vundle
	mkdir -p ~/.vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#download juci
if [ -z "$(ls ~/juci 2>/dev/null)" ]
	then
	echo downloading JUCI repo
	cd ~
	git clone git@public.inteno.se:juci juci && cd ~/juci && cp example-Makefile.local Makefile.local
fi

if [ -z "$(ls ~/iopsys 2>/dev/null)" ]
	then
	cd ~
	echo downloading IOPSYS repo
	git clone git@public.inteno.se:iopsys iopsys && cd iopsys && git co devel && ./iop bootstrap
fi

if [ -a ./ssh_config ]
	then
	cp ./ssh_config ~/.ssh/config
fi

echo "done creating symlinks"

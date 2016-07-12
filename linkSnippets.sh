#!/bin/sh

if [ -d "../.vim/bundle/ultisnips"  ]; then
	echo it is there
	rm -rf ~/.vim/bundle/ultisnips/UltiSnips
	ln -s ~/dotfiles/UltiSnips ~/.vim/bundle/ultisnips/UltiSnips
else
	echo its not there
fi

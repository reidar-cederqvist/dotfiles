#!/bin/sh

if [ -d "../.vim/bundle/ultisnips"  ]; then
	rm -rf ~/.vim/bundle/ultisnips/UltiSnips
	ln -s ~/dotfiles/UltiSnips ~/.vim/bundle/ultisnips/UltiSnips
	echo snippets linked
else
	echo you must install ultisnips first
fi

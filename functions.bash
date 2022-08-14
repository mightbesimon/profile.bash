#!/bin/bash

################################################################
#######                 quality of life                  #######
################################################################
function stat() {
	GetFileInfo $1
	stat -x $1
}

function show() {
	tabs -4
	cat $1
	tabs
}

################################################################
#######                      config                       #######
################################################################
export EDITOR=code

function editor() {
	EDITOR=$1
}

function config() {
	if [[ $1 == bash ]]; then
		$EDITOR ~/.bash_profile
	fi
	if [[ $1 == git ]]; then
		$EDITOR ~/.gitconfig
	fi
	if [[ $1 == *ignore ]]; then
		$EDITOR ~/.gitignore
	fi
	if [[ $1 == python ]]; then
		$EDITOR ~/.config/pycodstyle
	fi
	if [[ $1 == flake8 ]]; then
		$EDITOR ~/.flake8
	fi
}

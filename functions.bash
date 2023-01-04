#!/bin/bash

################################################################
#######                 quality of life                  #######
################################################################
function show()
{
	tabs -4
	cat $1
	tabs
}

################################################################
#######                      config                      #######
################################################################
export EDITOR=code

function editor()
{
	EDITOR=$1
}

function config()
{
	case $1 in
		bash    ) $EDITOR ~/profile.bash/;;
		git     ) $EDITOR ~/.gitconfig ~/.gitignore;;
		python  ) $EDITOR ~/.config/pycodestyle;;
		flake8  ) $EDITOR ~/.flake8;;
		neofetch) $EDITOR ~/.config/neofetch/config.conf;;
		*) echo bash, git, python, flake8, neofetch;;
	esac
}

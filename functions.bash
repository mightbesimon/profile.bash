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

################################################################
#######                    easter egg                    #######
################################################################
function onthisday()
{
	# echo '╭─────────────╮'
	# echo '│ On this day │'
	# echo '╰─────────────╯'
	echo On this day:
	echo ============
	grep $1 /usr/share/calendar/calendar.birthday
	grep $1 /usr/share/calendar/calendar.computer
	grep $1 /usr/share/calendar/calendar.history
	echo
}

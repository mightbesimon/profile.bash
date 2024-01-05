#!/bin/bash

################################################################
#######                      config                      #######
################################################################
function config()
{
	case $1 in
		bash    ) $EDITOR ~/profile.bash/ ~/.bash_profile;;
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
	day=${1:-$(date +%m/%d)}
	echo '╭─────────────╮'
	echo '│ On this day │'
	echo '╰─────────────╯'
	grep $day /usr/share/calendar/calendar.birthday
	grep $day /usr/share/calendar/calendar.computer
	grep $day /usr/share/calendar/calendar.history
	echo
}

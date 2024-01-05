#!/bin/bash

################################################################
#######                      config                      #######
################################################################
function config()
{
	case $1 in
		bash    ) $EDITOR ~/.bash_profile $PROFILE;;
		git     ) $EDITOR ~/.gitconfig ~/.gitignore;;
		python  ) $EDITOR ~/.config/pycodestyle;;
		pip     ) $EDITOR ~/.config/pip/pip.conf;;
		neofetch) $EDITOR ~/.config/neofetch/config.conf;;
		*) echo 'bash, git, python, pip, neofetch';;
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

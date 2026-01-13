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

function log
{
	echo $BOLD'┃'$RESET$BG_BR_BLACK $@ $RESET
}

alias log_debug='echo -n $BLUE && log'
alias log_info='echo -n $GREEN && log'
alias log_warn='echo -n $YELLOW && log'
alias log_error='echo -n $RED && log'
alias log_crit='echo -n $PURPLE && log'
alias log_show='log_debug debug && log_info info && log_warn warning && log_error error && log_crit critial'

# function log_info() {
# 	echo "$BG_GREEN$BLACK ✓ $BG_BR_BLACK$BR_WHITE $@ $RESET"
# }

# function log_warn() {
# 	echo "$BG_RED$BLACK ✗ $BG_BR_BLACK$BR_WHITE $@ $RESET"
# }

################################################################
#######                    easter egg                    #######
################################################################
function onthisday
{
	export LC_TIME=fr_FR.UTF-8
	day=${1:-$(date +%m/%d)}
	week=$(date -jf %m/%d $day '+WEEK %V')
	fulldate=$(date -jf %m/%d $day '+le %A %d %B')
	# echo ╭──────┬$(repeat '─' 26)$BG_BR_BLACK${UNDERLINE}▏On this day▕$RESET$(repeat '─' 32)╮
	# echo ╭──────┬─$(repeat '─' 25)[On this day]$(repeat '─' 32)╮
	# echo '   '$UNDERLINE'             '$RESET
	# echo ╭─╢$UNDERLINE On this day ${RESET}╟$(repeat '─' 62)╮
	echo '  '$BLUE$UNDERLINE'             '$RESET
	echo ╭─$BLUE$BOLD$UNDERLINE'▏ON THIS DAY▕'$RESET$(repeat '─' 64)╮
	# grep $day $PROFILE/calender/birthday.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
	# echo ├──────┼─$(repeat '─' 70)┤
	grep $day $PROFILE/calender/computer.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
	# echo ├──────┼─$(repeat '─' 70)┤
	grep $day $PROFILE/calender/history.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
	# echo ├──────┼─$(repeat '─' 70)┤
	echo -n $BR_PURPLE
	grep $day $PROFILE/calender/private.txt 2> /dev/null | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{77\}\).*/\1│/"
	echo -n $RESET
	echo -n ╰─
	echo -n $BG_BR_GREEN$BLACK$BOLD $fulldate $RESET
	echo -n $(repeat '─' $((72-${#week}-${#fulldate})))
	echo -n $BG_BR_YELLOW$BLACK$BOLD $week $RESET
	echo -n ─╯
	echo && echo
	export LC_TIME=en_NZ.UTF-8
}

# function onthisday
# {
# 	local day=${1:-$(date +%m/%d)}
# 	local week=$(date -jf %m/%d $day '+WEEK %V')
# 	local fulldate=$(LC_TIME=fr_FR.UTF-8 date -jf %m/%d $day '+le %A %d %B')
# 	local format='s/^.....//;s/.*/&'$(repeat ' ' 70)'/;s/\(.\{79\}\).*/\1│/'
# 	local first=''
# 	local birthday=$(grep $day $PROFILE/calender/birthday.txt)
# 	local computer=$(grep $day $PROFILE/calender/computer.txt)
# 	local  history=$(grep $day $PROFILE/calender/history.txt)
# 	[[ $birthday ]] && first='birthday'
# 	echo '  '$BLUE$UNDERLINE'             '$RESET
# 	echo ╭─$BLUE$BOLD$UNDERLINE'▏ON THIS DAY▕'$RESET$(repeat '─' 64)╮
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	echo "$birthday" | sed "s/^.....//;s/.*/&$padding/;s/\(.\{79\}\).*/\1│/"
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	grep $day $PROFILE/calender/history.txt | sed "s/^.....//;s/.*/&$padding/;s/\(.\{79\}\).*/\1│/"
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	echo -n $BR_PURPLE
# 	grep $day $PROFILE/calender/private.txt 2> /dev/null | sed "s/^.....//;s/.*/&$padding/;s/\(.\{77\}\).*/\1│/"
# 	echo -n $RESET
# 	echo -n ╰─
# 	echo -n $BG_BR_GREEN$BLACK$BOLD $fulldate $RESET
# 	echo -n $(repeat '─' $((72-${#week}-${#fulldate})))
# 	echo -n $BG_BR_YELLOW$BLACK$BOLD $week $RESET
# 	echo -n ─╯
# 	echo $'\n'
# }

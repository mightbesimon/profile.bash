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
		*) echo bash, git, python, pip, neofetch;;
	esac
}

function log
{
	case $1 in
		debug) shift && echo -n $BLUE;;
		info ) shift && echo -n $GREEN;;
		warn*) shift && echo -n $YELLOW;;
		err* ) shift && echo -n $RED;;
		crit*) shift && echo -n $PURPLE;;
		show ) log debug debug && log info info && log warn warning && log error error && log crit critical && return;;
		# *) echo ${BLUE}debug$RESET, ${GREEN}info$RESET, ${YELLOW}warn${FAINT}ing$RESET, ${RED}err${FAINT}or$RESET, ${PURPLE}crit${FAINT}ical$RESET;;
	esac
	echo $BOLD'┃'$RESET$BG_BR_BLACK "$@" $RESET
	# echo ▍$RESET$BG_BR_BLACK "$@" $RESET
}

alias log_debug='echo -n $BLUE && log'
alias log_info='echo -n $GREEN && log'
alias log_warn='echo -n $YELLOW && log'
alias log_error='echo -n $RED && log'
alias log_crit='echo -n $PURPLE && log'
alias log_show='log_debug debug && log_info info && log_warn warning && log_error error && log_crit critial'

################################################################
#######                    easter egg                    #######
################################################################
# function onthisday
# {
# 	export LC_TIME=fr_FR.UTF-8
# 	day=${1:-$(date +%m/%d)}
# 	week=$(date -jf %m/%d $day '+WEEK %V')
# 	fulldate=$(date -jf %m/%d $day '+le %A %d %B')
# 	# echo ╭──────┬$(repeat '─' 26)$BG_BR_BLACK${UNDERLINE}▏On this day▕$RESET$(repeat '─' 32)╮
# 	# echo ╭──────┬─$(repeat '─' 25)[On this day]$(repeat '─' 32)╮
# 	# echo '   '$UNDERLINE'             '$RESET
# 	# echo ╭─╢$UNDERLINE On this day ${RESET}╟$(repeat '─' 62)╮
# 	echo '  '$BLUE$UNDERLINE'             '$RESET
# 	echo ╭─$BLUE$BOLD$UNDERLINE'▏ON THIS DAY▕'$RESET$(repeat '─' 64)╮
# 	# grep $day $PROFILE/calender/birthday.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	grep $day $PROFILE/calender/computer.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	grep $day $PROFILE/calender/history.txt | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
# 	# echo ├──────┼─$(repeat '─' 70)┤
# 	echo -n $BR_PURPLE
# 	grep $day $PROFILE/calender/private.txt 2> /dev/null | sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{77\}\).*/\1│/"
# 	echo -n $RESET
# 	echo -n ╰─
# 	echo -n $BG_BR_GREEN$BLACK$BOLD $fulldate $RESET
# 	echo -n $(repeat '─' $((72-${#week}-${#fulldate})))
# 	echo -n $BG_BR_YELLOW$BLACK$BOLD $week $RESET
# 	echo -n ─╯
# 	echo && echo
# 	export LC_TIME=en_NZ.UTF-8
# }

function header
{
	echo -n ╴$@╶
}

function _header
{
	echo ├──────┼$(repeat '─' $((69 - ${#1})))$(header $1)┤
}

function onthisday
{
	local day=${1:-$(date +%m/%d)}
	local week=$(date -jf %m/%d $day '+WEEK %V')
	local fulldate=$(LC_TIME=fr_FR.UTF-8 date -jf %m/%d $day '+le %A %d %B')
	local format="s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
	local first='nothing happened'
	local birthday="$(grep $day $PROFILE/calender/birthday.txt 2> /dev/null)"
	local computer="$(grep $day $PROFILE/calender/computer.txt 2> /dev/null)"
	local  history="$(grep $day $PROFILE/calender/history.txt  2> /dev/null)"
	#    { [[ $computer ]] && first='computer history'; } \
	# || { [[ $history  ]] && first='history'; } \
	# || { [[ $birthday ]] && first='birthday'; } \
	# || first='nothing happened'
	[[ $birthday ]] && first='birthday'
	[[ $history  ]] && first='history'
	[[ $computer ]] && first='computer history'
	# echo "$(repeat ' ' 9)$BLUE$UNDERLINE             $RESET"
	echo " $FAINT$UNDERLINE      $RESET  $BLUE$UNDERLINE             $RESET"
	echo ╭$FAINT$UNDERLINE'▏year'▕$RESET'┬─'$BLUE$BOLD$UNDERLINE'▏ON THIS DAY▕'$RESET$(repeat '─' $((55 - ${#first})))$(header $first)'╮'
	[[ $birthday && $first = birthday ]] && echo "$birthday" | sed "$format"
	[[ $computer && $first != 'computer history' ]] && _header 'computer history'
	[[ $computer ]] && echo "$computer" | sed "$format"
	[[ $history && $first != history ]] &&_header history
	[[ $history ]] && echo "$history" | sed "$format"
	[[ $first = 'nothing happened' ]] && echo "│      │$(repeat ' ' 22)quiet day in history$(repeat ' ' 29)│"
	############################################################
	local special=$(grep $day $PROFILE/calender/private.txt 2> /dev/null \
		| sed "s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{77\}\).*/\1│/")
	if [[ $special ]]
	then
		echo -n $RED'├'
		header speci┼l && header day && echo -n ─"$YELLOW"─
		header special && header day && echo -n ─"$GREEN"─
		header special && header day && echo -n ─"$BLUE"─
		header special && header day && echo -n ─"$PURPLE"─
		header special && header day
		echo ┤
		echo $CYAN"$special"$RESET
	fi
	############################################################
	echo -n ╰─
	echo -n $BG_BR_GREEN$BLACK$BOLD $fulldate $RESET
	repeat '─' $((72-${#week}-${#fulldate}))
	echo -n $BG_BR_YELLOW$BLACK$BOLD $week $RESET
	echo -n ─╯
	echo $'\n'
}

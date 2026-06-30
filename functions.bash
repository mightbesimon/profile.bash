#!/bin/bash

################################################################
#######                      config                      #######
################################################################
function config()
{
	case $1 in
		bash    ) $EDITOR ~/.profile $PROFILE;;
		git     ) $EDITOR ~/.gitconfig ~/.gitignore;;
		python  ) $EDITOR ~/.config/pycodestyle;;
		pip     ) $EDITOR ~/.config/pip/pip.conf;;
		*) echo 'bash|git|python|pip|neofetch';;
	esac
}

function log
{
	# TODO -d --debug, -i --info, -w --warn, -e --error, -c --critical
	# --show --help
	case $1 in
		-d|debug) shift && echo -n $BLUE ;;
		   imp* ) shift && echo -n $CYAN ;;
		-i|info ) shift && echo -n $GREEN ;;
		-w|warn*) shift && echo -n $YELLOW ;;
		-e|err* ) shift && echo -n $RED ;;
		-c|crit*) shift && echo -n $PURPLE ;;
		-f|fatal) echo $RED$BOLD'┃'$RESET$BG_RED$WHITE$BOLD ${@:2} $RESET && return ;;
		show|help)
			log important important
			log -d debug
			log -i info
			log -w warning
			log -e error
			log -c critical
			log -f FATAL
			return
			;;
		# *) echo ${BLUE}debug$RESET, ${GREEN}info$RESET, ${YELLOW}warn${FAINT}ing$RESET, ${RED}err${FAINT}or$RESET, ${PURPLE}crit${FAINT}ical$RESET;;
	esac
	echo $BOLD'┃'$RESET$BG_BR_BLACK $@ $RESET
	# echo ▍$RESET$BG_BR_BLACK "$@" $RESET
}

alias log_debug='echo -n $BLUE && log'
alias log_info='echo -n $GREEN && log'
alias log_warn='echo -n $YELLOW && log'
alias log_error='echo -n $RED && log'
alias log_crit='echo -n $PURPLE && log'

################################################################
#######                    easter egg                    #######
################################################################
function date_from
{
	date -jf %m/%d "$1" "$2" 2> /dev/null || date -d "$1" "$2"
}

function onthisday
{
	local day=${1:-$(date +%m/%d)}
	local week=$(date_from $day '+WEEK %V')
	local fulldate=$(LC_TIME=fr_FR.UTF-8 date_from $day '+%A %d %B %Y' | tr A-Z a-z)
	local format="s/^.....//;s/.*/&$(repeat ' ' 70)/;s/\(.\{79\}\).*/\1│/"
	local first='nothing happened'
	local birthday="$(grep $day $PROFILE/calendar/birthday.txt 2> /dev/null)"
	local computer="$(grep $day $PROFILE/calendar/computer.txt 2> /dev/null)"
	local  history="$(grep $day $PROFILE/calendar/history.txt  2> /dev/null)"
	local  special="$(grep $day $PROFILE/calendar/private.txt  2> /dev/null)"
	[[ $birthday ]] && first='birthday'
	[[ $history  ]] && first='history'
	[[ $computer ]] && first='computer history'
	[[ $computer && $history ]] && first='computer & history'
	echo " $FAINT$UNDERLINE      $RESET  $BLUE$UNDERLINE             $RESET"
	echo -n ╭$FAINT$UNDERLINE'▏year'▕$RESET
	echo -n ┬─$BLUE$BOLD$UNDERLINE'▏ON THIS DAY▕'$RESET
	echo $(repeat '─' $((55 - ${#first})))╴$first'╶╮'
	[[ $birthday && $first = birthday ]] && echo "$birthday" | sed "$format"
	[[ $computer && -z $history ]] && echo "$computer" | sed "$format"
	[[ $computer &&    $history ]] && echo "$computer" | sed "$format" | sed "\$s/^\(.\)\(.*\)\(..\)\$/\1$UNDERLINE\2$RESET\3/"
	[[                 $history ]] && echo "$history" | sed "$format"
	[[ $first = 'nothing happened' ]] && echo "│      │$(repeat ' ' 22)quiet day in history$(repeat ' ' 29)│"
	############################################################
	if [[ $special ]]
	then
		echo -n $RED
		echo -n ├╴special╶╴day╶─$YELLOW
		echo -n ─╴special╶╴day╶─$GREEN
		echo -n ─╴special╶╴day╶─$BLUE
		echo -n ─╴special╶╴day╶─$PURPLE
		echo -n ─╴special╶╴day╶┤$CYAN
		echo
		echo "$special" | sed "$(echo "$format" | tr 9 7)"
	fi
	############################################################
	echo -n $RESET
	echo -n ╰
	echo -n $BG_GREEN$BLACK$BOLD $fulldate $RESET
	repeat '─' $((73-${#week}-${#fulldate}))
	echo -n $BG_YELLOW$BLACK$BOLD $week $RESET
	echo -n ─╯
	echo $'\n'
}

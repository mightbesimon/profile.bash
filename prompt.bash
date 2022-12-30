#!/bin/bash

################################################################
#######                 helper functions                 #######
################################################################
function currentbranch()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function exitcode()
{
	(($skip)) && skip=0 && return
	echo $1$BLACK $2 $BG_BR_BLACK$BR_WHITE $(date '+%F %X') $RESET$'\n'
}

################################################################
#######                       main                       #######
################################################################
function preprompt()
{
	(($? == 0)) && exitcode $BG_GREEN ✓ || exitcode $BG_RED ✗
	PS1='\[$FAINT\][ \# | \u | \h ]\[$RESET\]\n \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\] 👉 '
	PS2='\[$FAINT\]  \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\]    '
}

export PROMPT_COMMAND=preprompt
export skip=1

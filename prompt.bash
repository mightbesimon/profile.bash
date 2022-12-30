#!/bin/bash

################################################################
#######                 helper functions                 #######
################################################################
function currentbranch()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function exitstatus()
{
	(($skip_exitstatus)) && skip_exitstatus=0 && return
	echo $1$BLACK $2 $BG_BR_BLACK$BR_WHITE $(date '+%F %X') $RESET$'\n'
}

################################################################
#######                       main                       #######
################################################################
function preprompt()
{
	(($? == 0)) && exitstatus $BG_GREEN ✓ || exitstatus $BG_RED ✗
	PS1='\[$FAINT\][\#]  \h → \u\[$RESET\]\n \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\] 👉 '
	PS2='\[$FAINT\]  \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\]    '
	skip_precommand=0
}

function precommand()
{
	(($skip_precommand)) && return
	[[ $BASH_COMMAND == $PROMPT_COMMAND ]] && skip_exitstatus=1 && return
	#
	skip_precommand=1
}

skip_exitstatus=1
skip_precommand=1

trap precommand DEBUG
export PROMPT_COMMAND=preprompt

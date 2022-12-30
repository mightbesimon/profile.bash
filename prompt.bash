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
	(($1 == 0)) && bg=$BG_GREEN || bg=$BG_RED
	(($1 == 0)) && chr=✓ || chr=✗

	echo $bg$BLACK $chr \
	     $BG_BR_BLACK$BR_WHITE $SECONDS''sec\
			 $BLACK''│\
			 $BR_WHITE''exit=$1\
			 $BLACK''│\
			 $BR_WHITE$COMMAND \
			 $BG_BLUE$BLACK $(date '+%F %X') $RESET
	echo
}

################################################################
#######                       main                       #######
################################################################
function preprompt()
{
	exitstatus $?
	skip_precommand=0
	PS1='\[$FAINT\][\#]  \h → \u\[$RESET\]\n \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\] 👉 '
	PS2='\[$FAINT\]  \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\]    '
}

function precommand()
{
	(($skip_precommand)) && return
	[[ $BASH_COMMAND == $PROMPT_COMMAND ]] && skip_exitstatus=1 && return
	COMMAND=$BASH_COMMAND
	SECONDS=0
	skip_precommand=1
}

skip_exitstatus=1
skip_precommand=1

trap precommand DEBUG
export PROMPT_COMMAND=preprompt

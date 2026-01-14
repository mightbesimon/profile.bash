#!/bin/bash

################################################################
#######                 helper functions                 #######
################################################################
function repeat
{
	printf %$2s | tr ' ' "$1"
}

function epochms
{
	perl -MTime::HiRes=time -e "printf '%u', time*1000"
}

# repeat() { printf %$2s | tr ' ' "$1"; }
# currentbranch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'; }
# currentvenv() { [ -n "$VIRTUAL_ENV" ] && echo " [$(basename "$VIRTUAL_ENV")]"; }

function exitstatus
{
	(($skip_exitstatus)) && skip_exitstatus=0 && return
	(($1 == 0)) && bg=$BG_GREEN || bg=$BG_RED
	(($1 == 0)) && chr=✓ || chr=✗

	local elapsed=$(formatmilliseconds $(($(epochms) - $start_ms)))
	# local padlen=$((40-${#SECONDS}-${#1}-${#COMMAND}))
	local escaped=${COMMAND//$'\n'/\\n}
	local padlen=$((43-${#elapsed}-${#1}-${#escaped}))
	local padded=$escaped$(repeat ' ' $padlen)
	# local trimlen=$((40-${#1}-${#SECONDS}))
	local trimlen=$((43-${#1}-${#elapsed}))
	local trimmed=$(head -c $trimlen <<< "$padded")

	echo -n $RESET$bg$BLACK$BOLD $chr $RESET
	echo -n $BG_BR_BLACK$BR_WHITE $elapsed' '
	echo -n $BLACK'┃ '
	echo -n $WHITE'exit='$BR_WHITE$1' '
	echo -n $BLACK'┃ '
	echo -n $BR_WHITE"$trimmed "
	# echo -n $BG_BLUE$BLACK $(date '+%F %X') $RESET
	echo -n $BG_BLUE$BLACK $(date '+%FT%X') $RESET
	# echo -n $BG_BLUE$BLACK $(date '+%d.%m.%Y %Hh%M:%S') $RESET
	echo
	echo $BR_BLACK$(repeat '-' $COLUMNS)$RESET
	# echo $(peach)
}

function formatmilliseconds
{
	local hours=$(($1 / 3600000))
	local minutes=$((($1 % 3600000) / 60000))
	local seconds=$((($1 % 60000) / 1000))
	local milliseconds=$(printf '%03u' $(($1 % 1000)))
	local output=$seconds.${milliseconds}s
	((minutes > 0)) && output="${minutes}m $output" && ((hours > 0)) && output="${hours}h $output"
	echo $output
}

################################################################
#######                       main                       #######
################################################################
function preprompt
{
	exitstatus $?
	skip_precommand=0
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/')
	VENV=$([ -n "$VIRTUAL_ENV" ] && echo " [$(basename "$VIRTUAL_ENV")]";)
	DIR=$(dirs)
	local ndirs=$(ls -l | grep -c ^d)
	local nfiles=$(ls -l | grep -c ^-)
	local nlinks=$(ls -l | grep -c ^l)
	local padlen=$((65 - ${#DIR}-${#BRANCH}-${#VENV}-${#ndirs}-${#nfiles}))
	((nlinks > 0)) && padlen=$((padlen - 10 - ${#nlinks}))
	while ((padlen < 0))
	do padlen=$((padlen - 80))
	done

	# if no branch and pwd short, arrow on same line
	# PS1=' \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]\n$ARROW \[$BLUE\]'
	PS1=" \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]"
	PS1=$PS1$(repeat ' ' $padlen)
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $ndirs\[$FAINT\] dirs\[$RESET\]"
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $nfiles\[$FAINT\] files\[$RESET\]"
	((nlinks > 0)) && PS1=$PS1"\[$BG_BLACK$PURPLE\] $nlinks\[$FAINT$PURPLE\] symlinks\[$RESET\]"
	PS1=$PS1'\n\[$YELLOW\]$ARROW \[$BLUE\]'
	# PS1='\[$RESET$FAINT\][\#] \h → \u\[$RESET\]\n'$PS1
	PS1="\[\e]2;\w$BRANCH$VENV\a\]"$PS1		# window title
	# PS2='\[$FAINT\]  \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]    \[$BLUE\]'
	# PS2='$ARROW '
	PS2=' \[$YELLOW$FAINT\]$ARROW\[$BLUE\]$RESET$BLUE'
}

function precommand
{
	(($skip_precommand)) && return
	[[ $BASH_COMMAND == $PROMPT_COMMAND ]] && skip_exitstatus=1 && return
	COMMAND=$BASH_COMMAND
	skip_precommand=1
	echo -n $RESET
	# SECONDS=0
	start_ms=$(epochms)
}

skip_exitstatus=1
skip_precommand=1

trap precommand DEBUG
export PROMPT_COMMAND=preprompt

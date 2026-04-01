#!/bin/bash

################################################################
#######                 helper functions                 #######
################################################################
function repeat
{
	printf '%*s' $2 | sed "s/ /$1/g"
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
	echo -n $BG_BLUE$BLACK $(date '+%FT%H:%M:%S') $RESET
	# echo -n $BG_BLUE$BLACK $(date '+%d.%m.%Y %Hh%M:%S') $RESET
	echo $BR_BLACK
	repeat '-' $COLUMNS
	echo $RESET
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
	# VENV=$([ -n "$VIRTUAL_ENV" ] && echo ' '[$(basename "$VIRTUAL_ENV")] | tr a-z A-Z)
	VENV=$([ -n "$VIRTUAL_ENV" ] && echo " $(basename "$VIRTUAL_ENV") " | tr a-z A-Z)
	# VENV=$(basename "$VIRTUAL_ENV" 2> /dev/null | tr a-z A-Z)
	DIR=$(dirs)
	local dotdsstore=$(ls -a | grep -c '^\.DS_Store$')
	local  ndirs=$(command ls -Al | grep -c ^d)
	local nfiles=$(command ls -Al | grep -c ^-)
	local nlinks=$(command ls -Al | grep -c ^l)
	local  nexes=$(command ls -Al | grep -c '^-\S*x')
	local padlen=$((65 - ${#DIR}-${#BRANCH}-${#VENV}-${#ndirs}-${#nfiles}))
	((nlinks    )) && padlen=$((padlen - 10 - ${#nlinks}))
	((nexes     )) && padlen=$((padlen - 6 - ${#nexes}))
	((dotdsstore)) && padlen=$((padlen - 10))
	((padlen < 0)) && padlen=$((padlen + $COLUMNS - 80))
	((padlen < 0)) && padlen=$((padlen + $COLUMNS))
	# ((padlen < 0)) && padlen=$((padlen - $COLUMNS + 80))
	# while ((padlen < 0))
	# do padlen=$((padlen + 80))
	# done

	# move to ls custom function
	# and output count socket, pipes
	local n_privilege_escalations=$(command ls -Al | grep -c '^\S*s')
	local               n_critial=$(command ls -Al | grep -c '^\S*S')
	local          n_world_writes=$(command ls -Al | grep -c '^........w.')
	((n_world_writes)) && ((${#DIR} > 1)) \
	&& log warn $n_world_writes 'world-writable file(s) or director(ies)'
	((n_privilege_escalations)) && ((${#DIR} > 1)) \
	&& log error $n_privilege_escalations 'file(s) with setuid/setgid bits'
	((n_critial)) && ((${#DIR} > 1)) \
	&& log crit $n_critial 'critical system files with malicious permissions'

	# if no branch and pwd short, arrow on same line
	# PS1=' \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]\n$ARROW \[$BLUE\]'
	# PS1=" \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]"
	PS1=" \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$RESET\]"
	PS1=$PS1$(repeat ' ' $padlen)
	PS1=$PS1'\[$BG_BLUE$BLACK\]$VENV\[$RESET\]'
	((dotdsstore)) && PS1=$PS1"\[$BG_BR_BLACK$WHITE$FAINT\].DS_Store\[$RESET$BG_BR_BLACK$BLACK\]┃\[$RESET\]"
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $ndirs\[$FAINT\] dirs\[$RESET\]"
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $nfiles\[$FAINT\] files\[$RESET\]"
	((nlinks)) && PS1=$PS1"\[$BG_BLACK$PURPLE\] $nlinks\[$FAINT\] symlinks\[$RESET\]"
	((nexes )) && PS1=$PS1"\[$BG_RED$BLACK$BOLD\] $nexes\[$RESET$BG_RED$BLACK\] exes\[$RESET\]"
	PS1=$PS1'\n\[$YELLOW\]$ARROW \[$BLUE\]'
	PS1='\[$RESET$FAINT\][\#] \h → \u\[$RESET\]\n'$PS1
	PS1="\[\e]2;\w$BRANCH$VENV\a\]"$PS1		# window title
	PS2='\[$YELLOW$FAINT\]$ARROW \[$RESET$BLUE\]'
}

function precommand
{
	(($skip_precommand)) && return
	[[ $BASH_COMMAND = $PROMPT_COMMAND ]] && skip_exitstatus=1 && return
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

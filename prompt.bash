#!/bin/bash

################################################################
#######                 helper functions                 #######
################################################################
function repeat
{
	# printf %$2s | tr ' ' "$1"
	printf '%*s' $2 | sed "s/ /$1/g"	# now supports multi char
}

function epochms
{
	perl -MTime::HiRes=time -e "printf '%u', time*1000"	# macos cannot use date -d
}

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
	# local output=$seconds.${milliseconds}s
	# ((minutes)) && output="${minutes}m $output" && ((hours)) && output="${hours}h $output"
	# # BUG 1h 0m 1s would display as 1s
	# echo $output
	((hours)) && echo -n $hours'h '
	((minutes)) && echo -n $minutes'm '
	echo $seconds.$milliseconds's'
}

function dircheck
{
	local contents=$(command ls -Al 2> /dev/null)
	local world_writes=$(grep -c '^........w.' <<< "$contents")
	local  escalations=$(grep -c '^\S*s' <<< "$contents")
	local      critial=$(grep -c '^\S*S' <<< "$contents")

	((${#DIR} > 1)) && ((world_writes)) \
	&& log warn $world_writes 'world-writable file(s) or director(ies), possible access control risk' \
	&& grep '^........w.' <<< "$contents"

	((${#DIR} > 1)) && ((escalations)) \
	&& log error $escalations 'file(s) with setuid/setgid bits, possible privilege escalation risk' \
	&& grep '^\S*s' <<< "$contents"

	((${#DIR} > 1)) && ((n_critial)) \
	&& log crit $critial 'critical system files with malicious permissions' \
	&& grep '^\S*S' <<< "$contents"

	return 0
}

################################################################
#######                       main                       #######
################################################################
function preprompt
{
	exitstatus $?
	skip_precommand=0
	local git_ms=$(epochms)
	git branch 2> /dev/null
	timer git_ms
	log warning git branch timer
	local sed_ms=$(epochms)
	echo | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/' 1> /dev/null
	timer sed_ms
	log warning sed timer
	local preprompt_ms=$(epochms)
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/')	# TODO use git branch --show-current
	# BRANCH=" [$(git branch --show-current 2> /dev/null)]"
	(( $(epochms) - preprompt_ms > 999 )) \
	&& timer preprompt_ms \
	&& log warning preprompt timer exceeded 1s
	# VENV=$([ -n "$VIRTUAL_ENV" ] && echo ' '[$(basename "$VIRTUAL_ENV")] | tr a-z A-Z)
	VENV=$([ "$VIRTUAL_ENV" ] && tr a-z A-Z <<< " $(basename "$VIRTUAL_ENV") ")
	# VENV=" $(basename "$VIRTUAL_ENV" 2> /dev/null | tr a-z A-Z) "
	DIR=$(dirs)
	HOST=$(hostname -s)
	local contents=$(command ls -Al 2> /dev/null)	# TODO display permission denied error
	local dotdsstore=$(grep -c '.DS_Store$' <<< "$contents")
	local  ndirs=$(grep -c ^d <<< "$contents")
	local nfiles=$(grep -c ^- <<< "$contents")
	local nlinks=$(grep -c ^l <<< "$contents")
	local  nexes=$(grep -c '^-\S*x' <<< "$contents")
	local padlen=$((65 - ${#DIR}-${#BRANCH}-${#VENV}-${#ndirs}-${#nfiles}))
	((nlinks    )) && padlen=$((padlen - 10 - ${#nlinks}))
	((nexes     )) && padlen=$((padlen -  6 - ${#nexes}))
	((dotdsstore)) && padlen=$((padlen - 10))
	local compact=$((padlen < 0))
	if ((compact))
	then
		local hist=$((1 + $(history 1 | cut -wf2)))
		local padlen=$((61 - ${#hist}-${#HOST}-${#USER}-${#VENV}-${#ndirs}-${#nfiles}))
		((nlinks    )) && padlen=$((padlen - 10 - ${#nlinks}))
		((nexes     )) && padlen=$((padlen -  6 - ${#nexes}))
		((dotdsstore)) && padlen=$((padlen - 10))
	fi
	# ((padlen < 0)) && local compact=1 || local compact=0
	# ((padlen < 0)) && local hist=$(history 1 | cut -wf2)
	# ((padlen < 0)) && padlen=$((61 - ${#hist}-${#HOST}-${#USER}-${#VENV}-${#ndirs}-${#nfiles}))
	# ((nlinks    )) && ((compact)) && padlen=$((padlen - 10 - ${#nlinks}))
	# ((nexes     )) && ((compact)) && padlen=$((padlen -  6 - ${#nexes}))
	# ((dotdsstore)) && ((compact)) && padlen=$((padlen - 10))

	# [[ $(dircheck) ]] && log warning dircheck

	# # if no branch and pwd short, arrow on same line
	# # PS1=' \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]\n$ARROW \[$BLUE\]'
	# # PS1=" \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$BLUE\]$VENV\[$RESET\]"
	# PS1=" \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$RESET\]"
	# PS1=$PS1$(repeat ' ' $padlen)
	# PS1=$PS1'\[$BG_BLUE$BLACK\]$VENV\[$RESET\]'
	# ((dotdsstore)) && PS1=$PS1"\[$BG_BR_BLACK$WHITE$FAINT\].DS_Store\[$RESET$BG_BR_BLACK$BLACK\]┃\[$RESET\]"
	# PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $ndirs\[$FAINT\] dirs\[$RESET\]"
	# PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $nfiles\[$FAINT\] files\[$RESET\]"
	# ((nlinks)) && PS1=$PS1"\[$BG_BLACK$PURPLE\] $nlinks\[$FAINT\] symlinks\[$RESET\]"
	# ((nexes )) && PS1=$PS1"\[$BG_RED$BLACK$BOLD\] $nexes\[$RESET$BG_RED$BLACK\] exes\[$RESET\]"
	# PS1=$PS1'\n\[$YELLOW\]$ARROW \[$BLUE\]'
	# # PS1='\[$RESET$FAINT\][\#] \h → \u\[$RESET\]\n'$PS1	# command number, hostname, username
	# PS1="\[\e]2;\w$BRANCH$VENV\a\]"$PS1		# window title
	# PS2='\[$YELLOW$FAINT\]$ARROW \[$RESET$BLUE\]'

	PS1="\[\e]2;\w$BRANCH$VENV\a\]"								# window title
	PS1=$PS1'\[$RESET$FAINT\][$HISTCMD] $HOST → $USER\[$RESET\]'	# command number, hostname, username
	((compact-1)) && PS1=$PS1"\n$APPLE \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$RESET\]"	# do not sqeeze
	PS1=$PS1$(repeat ' ' $padlen)
	PS1=$PS1'\[$BG_BLUE$BLACK\]$VENV\[$RESET\]'
	((dotdsstore)) && PS1=$PS1"\[$BG_BR_BLACK$WHITE$FAINT\].DS_Store\[$RESET$BG_BR_BLACK$BLACK\]┃\[$RESET\]"	# show if .DS_Store exists
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $ndirs\[$FAINT\] dirs\[$RESET\]"
	PS1=$PS1"\[$BG_BR_BLACK$WHITE\] $nfiles\[$FAINT\] files\[$RESET\]"
	((nlinks)) && PS1=$PS1"\[$BG_BLACK$PURPLE\] $nlinks\[$FAINT\] symlinks\[$RESET\]"
	((nexes )) && PS1=$PS1"\[$BG_RED$BLACK$BOLD\] $nexes\[$RESET$BG_RED$BLACK\] exes\[$RESET\]"
	((compact)) && PS1=$PS1"\n$APPLE \[$BOLD$PURPLE\]\w\[$GREEN\]$BRANCH\[$RESET\]"
	PS1=$PS1'\n\[$YELLOW\]$ARROW \[$BLUE\]'
	PS2='\[$YELLOW$FAINT\]$ARROW \[$RESET$BLUE\]'
}

function precommand
{
	((skip_precommand)) && return
	[[ $BASH_COMMAND = $PROMPT_COMMAND ]] && skip_exitstatus=1 && return
	COMMAND=$BASH_COMMAND
	skip_precommand=1
	echo -n $RESET

	# sync history across sessions
	history -a	# append to .bash_history
	history -n	# read new history from .bash_history

	# SECONDS=0
	start_ms=$(epochms)
}

################################################################
#######                       main                       #######
################################################################

# skip_exitstatus=1
# skip_precommand=1

# # trap precommand DEBUG
# # export PROMPT_COMMAND=preprompt
# [[ -z $(trap -p DEBUG) ]] && trap precommand DEBUG	# avoid overriding __vsc_preexec_all
# [[ $PROMPT_COMMAND != __vsc_prompt_cmd_original ]] && export PROMPT_COMMAND=preprompt	# avoid overriding __vsc_prompt_cmd_original
# [[ $PS1 ]] && trap 'exit 0' EXIT	# avoid vscode exit on failed command giving warning


function initprompt
{
	skip_exitstatus=1
	skip_precommand=1

	[[ $PROMPT_COMMAND != __vsc_prompt_cmd_original ]] && export PROMPT_COMMAND=preprompt	# avoid overriding __vsc_prompt_cmd_original
	[[ -z $(trap -p DEBUG) ]] && trap precommand DEBUG	# avoid overriding __vsc_preexec_all
	[[ $PS1 ]] && trap 'exit 0' EXIT	# avoid vscode exit on failed command giving warning
}

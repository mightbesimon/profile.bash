#!/bin/bash

################################################################
#######                     start up                     #######
################################################################
function epochms
{
	perl -MTime::HiRes=time -e "printf '%u', time*1000"
}
function timer
{
	printf $FAINT%3dms$RESET $(($(epochms)-$1))
	printf -v $1 '%s' $(epochms)	# update the new time for the next call
}
function logtime
{
	timelog+='     '
	timelog+=`timer $1`
	timelog+=`log ${@:2}`
	timelog+=$'\n'
}
session_ms=$(epochms)
step_ms=session_ms

################################################################
#######                     imports                      #######
################################################################
source $PROFILE/colour.bash
[[ $PROFILE_256 ]] && source $PROFILE/colour256.bash
source $PROFILE/path.bash
source $PROFILE/alias.bash
source $PROFILE/functions.bash
source $PROFILE/prompt.bash
source $PROFILE/llm.bash
# source $PROFILE/compile.bash

logtime step_ms profile imports complete


################################################################
#######                   completions                    #######
################################################################
source /opt/homebrew/completions/bash/brew 2> /dev/null		# brew itself
source /opt/homebrew/etc/profile.d/bash_completion.sh 2> /dev/null	# brew installed packages
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash 2> /dev/null	# git
source $HOME/.local/share/bash-completion/completions/docker 2> /dev/null	# docker and docker compose
source $PROFILE/completions.bash

logtime step_ms completions imports complete


################################################################
#######                    variables                     #######
################################################################
export EDITOR=code
export BROWSER=none
export TRASH=~/.Trash
export BASHRC=~/.bash_profile

[[ $(uname) = Darwin ]] && \
export APPLE= || export APPLE=⌘
export ARROW=❯
# export ARROW=→

logtime step_ms varaibles exports complete


################################################################
#######                    env config                    #######
################################################################
export BASH_SILENCE_DEPRECATION_WARNING=1
export PIP_DISABLE_PIP_VERSION_CHECK=1
export GPG_TTY=$(tty)	# github commit signing
export HISTSIZE=
export HISTFILESIZE=
# export HISTCONTROL=ignoredups:erasedups	# ignore duplicates and overwrite previous
export HISTIGNORE=ls:'* --help':'why *':'undo *':'translate *':'fr *'	# :'ask *'
shopt -s histappend				# append to history instead of overwriting
shopt -s dotglob				# include hidden files in globbing
shopt -s globstar 2> /dev/null	# allow ** recursive directories matching (for debian)
# TODO symlink to '~/Library/Application Support/eza'
export EZA_CONFIG_DIR=~/.config/eza
export LS_COLORS='ln=35:ex=31:di=34;1'

logtime step_ms environment configuration complete


################################################################
#######                 MAIN STARTS HERE                 #######
################################################################
tabs -4
# set +H
# neofetch 2> /dev/null
onthisday

initprompt
export PROFILE_LOADED=1

timer session_ms
log important bash profile activation complete \
	$RESET$FAINT$BLUE ${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}
echo -n "$timelog"

# temp
preprompt
skip_exitstatus=1
skip_precommand=1
timer session_ms
log debug preprompt timer
echo

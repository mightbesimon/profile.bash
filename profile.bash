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
	printf $FAINT'%2dms' $(($(epochms)-$1))
	printf -v $1 '%s' $(epochms)
}
session_ms=$(epochms)

################################################################
#######                     imports                      #######
################################################################
source $PROFILE/colour.bash
source $PROFILE/path.bash
source $PROFILE/alias.bash
source $PROFILE/functions.bash
source $PROFILE/prompt.bash
# source $PROFILE/compile.bash


################################################################
#######                    variables                     #######
################################################################
export EDITOR=code
export BROWSER=none
export TRASH=~/.Trash
export BASHRC=~/.bash_profile
# export ARROW=👉
# export ARROW=→
export ARROW=❯


################################################################
#######                  config tweeks                   #######
################################################################
export BASH_SILENCE_DEPRECATION_WARNING=1
export PIP_DISABLE_PIP_VERSION_CHECK=1
export GPG_TTY=$(tty)	# github commit signing


################################################################
#######                 MAIN STARTS HERE                 #######
################################################################
tabs -4
set +H
# neofetch 2> /dev/null
onthisday $(date +%m/%d)

# log 'bash profile activation complete'
timer session_ms
echo $RESET$CYAN$BOLD'┃'$RESET$BG_BR_BLACK bash profile activation complete $RESET
echo

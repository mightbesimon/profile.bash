#!/bin/bash

################################################################
#######                     imports                      #######
################################################################
source $PROFILE/colour.bash
source $PROFILE/path.bash
source $PROFILE/alias.bash
source $PROFILE/prompt.bash
source $PROFILE/functions.bash
source $PROFILE/compile.bash


################################################################
#######                    variables                     #######
################################################################
export EDITOR=code
export BROWSER=none


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
neofetch 2> /dev/null
onthisday $(date +%m/%d)

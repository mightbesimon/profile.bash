#!/bin/bash

################################################################
#######                     imports                      #######
################################################################
source ~/profile.bash/colour.bash
source ~/profile.bash/path.bash
source ~/profile.bash/alias.bash
source ~/profile.bash/prompt.bash
source ~/profile.bash/functions.bash
source ~/profile.bash/compile.bash


################################################################
#######                    variables                     #######
################################################################
export EDITOR=code
export BROWSER=none


################################################################
#######                  config tweeks                   #######
################################################################
export BASH_SILENCE_DEPRECATION_WARNING=1
export GPG_TTY=$(tty)	# github commit signing


################################################################
#######                 MAIN STARTS HERE                 #######
################################################################
echo
neofetch 2> /dev/null

onthisday $(date +%m/%d)

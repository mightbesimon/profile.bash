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
#######                   config tweeks                   #######
################################################################
export BASH_SILENCE_DEPRECATION_WARNING=1
export GPG_TTY=$(tty)	# github commit signing


################################################################
#######                 MAIN STARTS HERE                 #######
################################################################
echo
neofetch 2> /dev/null

TODAY=$(date +%m/%d)
echo 'On this day:'
echo '============'
grep $TODAY /usr/share/calendar/calendar.birthday
grep $TODAY /usr/share/calendar/calendar.computer
grep $TODAY /usr/share/calendar/calendar.history
echo

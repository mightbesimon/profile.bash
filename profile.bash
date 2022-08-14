#!/bin/bash

################################################################
#######                     imports                      #######
################################################################
source ~/profile.bash/colour.bash
source ~/profile.bash/path.bash
source ~/profile.bash/alias.bash
source ~/profile.bash/functions.bash
source ~/profile.bash/git.bash
source ~/profile.bash/compile.bash


################################################################
#######                   config tweeks                   #######
################################################################
export HOMEBREW_NO_AUTO_UPDATE=1
export BASH_SILENCE_DEPRECATION_WARNING=1
export GPG_TTY=$(tty)	# github commit signing


################################################################
#######                 MAIN STARTS HERE                 #######
################################################################
# easter egg
TODAY=$(date +%m/%d)
echo
echo 'On this day:'
echo '============'
grep $TODAY /usr/share/calendar/calendar.birthday
grep $TODAY /usr/share/calendar/calendar.computer
grep $TODAY /usr/share/calendar/calendar.history
echo

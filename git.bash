#!/bin/bash

################################################################################
#######                             aliases                              #######
################################################################################
alias fixgit='killall gpg-agent'
alias gitlog='git log --show-signature | subl -n'
alias gitbranch='git branch -vv'
alias gitadd='git add .'

################################################################################
#######                         directory branch                         #######
################################################################################
function currentbranch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function precmd() {
	case $BASH_COMMAND in $PROMPT_COMMAND) ;;
	*) ;;
	esac
}

function preprompt() {
	PS1='${FAINT}[ \u ]${RESET}\n📁 ${PURPLE}${BOLD}\w${GREEN}$(currentbranch)${RESET} \$ '
}

trap precmd DEBUG
PROMPT_COMMAND=preprompt

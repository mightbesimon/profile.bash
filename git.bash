#!/bin/bash

################################################################################
#######                             aliases                              #######
################################################################################
alias fixgit='killall gpg-agent'
alias gitlog='git log --show-signature | subl -n'
alias gitbranch='git branch -vv'
alias gitadd='git add .'
alias gitds='git rm --cached -f *.DS_Store'

################################################################################
#######                         directory branch                         #######
################################################################################
function currentbranch()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function preprompt()
{
	PS1='\[$FAINT\][ \# | \u | \h ]\[$RESET\]\n \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\] 👉 '
	PS2='\[$FAINT\]  \[$BOLD\]\[$PURPLE\]\w\[$GREEN\]$(currentbranch)\[$RESET\]    '
}

export PROMPT_COMMAND=preprompt

#!/bin/bash

################################################################
#######                 quality of life                  #######
################################################################
alias ls='ls -AhFG'
# TODO ls with icons and tighter column with
# TODO ls -l table with box drawing chars
alias mv='mv -iv'
# alias rm='rm -v'
alias rm='trash'
alias ds='/bin/rm -v .DS_Store'
alias x='chmod u+x'
# alias stat='stat -x'
alias tree='tree -aC --filelimit 24'
alias python='python3'
alias venv='source venv/bin/activate'
alias reload='source ~/.bash_profile && trap precommand DEBUG'
alias update='git -C $PROFILE pull'
alias doc=man

#alias clean='find . -name '.DS_Store' -type f -print -delete'
# cat ~/Library/Application\ Support/Code/User/workspaceStorage/*/workspace.json | grep file | sed -E 's/.*"folder": "file:\/\/([^"]+)".*/\1/'

cd() { builtin cd "$@" && ls -AhFG; } # todo, add -q flag to not run ls after cd
du() { /usr/bin/du -hd 0 $(/bin/ls -AF) | sort -h; } # bug: dir with space, ls for dir/ to indicate dir
trash() { mv -iv "$@" ~/.Trash; }	# if starts with . prepend h
todo() { :; }
mergedir() { todo; }
terminal() { todo; } #reload, update
profile() { todo; }
# alias term=terminal
# lm() { ollama run deepseek-r1:14b "$@"; }
# alias lmclear='rm ~/.ollama/history'
# see, peak, view
# list as ls with colours
# wordlist() english
# idea: python llm provider management
# audit
# undo
stat() { /usr/bin/stat -x $@ && echo && GetFileInfo $@; }
function pipenv
{
	PIPENV_PATH=$(which pipenv)
	[[ -z $PIPENV_PATH ]] && echo 'pipenv not installed' && return 1
	[[ -z $@ ]] && source "$($PIPENV_PATH --venv)/bin/activate" && return
	[[ $1 == help ]] && $PIPENV_PATH -h && return
	$PIPENV_PATH $@
}
function brew
{
	BREW_PATH=$(which brew)
	[[ -z $BREW_PATH ]] && echo 'brew not installed' && return 1
	[[ $1 == tree ]] && brew deps --tree --for-each $(brew leaves) && return
	$BREW_PATH $@
}
function pip
{
	PIP_PATH=$(which pip)
	[[ -z $PIP_PATH ]] && echo 'not inside virtual environment, use pip3' && return
	[[ $1 == tree ]] && which pipdeptree \
		|| (echo 'pipdeptree not installed anywhere' && return) \
		&& pipdeptree ${@:2} && return
	$PIP_PATH $@
}


################################################################
#######                     publish                      #######
################################################################
alias vsce='npx vsce'
alias firebase='npx firebase-tools'
alias pypi='rm -rv dist *.egg-info; python -m build && python -m twine upload dist/*'
# alias vscode='yo code'


################################################################
#######                       git                        #######
################################################################
alias fixgit='killall gpg-agent'
alias gitlog='git log --show-signature | subl -n'
alias gitbranch='git branch -vv'
alias gitadd='git add .'
alias gitds='git rm --cached -f *.DS_Store'

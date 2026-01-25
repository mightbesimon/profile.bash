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
alias ds='command rm -v .DS_Store'
# alias x='chmod u+x'
# alias tree='tree -aCFL 8 --filelimit 24 -I .git | tr └ ╰ | sed "s/─ \([^/]*\/\)/──┬╸\1/" | sed "s/─ /───╸/"'
# alias tree='tree -aCFL 8 --filelimit 24 -I .git | sed "s/─ /─╸/"'
alias python='python3'
# alias venv='source venv/bin/activate'
alias reload='source ~/.bash_profile || source ~/.profile && trap precommand DEBUG'
alias update='git -C $PROFILE pull'
alias doc=man
alias box="source $PROFILE/box.bash"

#alias clean='find . -name '.DS_Store' -type f -print -delete'
# cat ~/Library/Application\ Support/Code/User/workspaceStorage/*/workspace.json | grep file | sed -E 's/.*"folder": "file:\/\/([^"]+)".*/\1/'

cd() { builtin cd "$@" && ls -AhFG; } # todo, add -q flag to not run ls after cd
# du() { command du -hd 0 -- * .??* | sort -h; }
stat() { command stat -x "$@" && echo && GetFileInfo "$@"; }
tree() { command tree -aCFL 8 --filelimit 24 -I .git "$@" | sed 's/─ /─╸/'; }
# tree() { command tree -aCFL 8 --filelimit 24 -I .git "$@" | sed 's/─ /─'$RED'╸'$RESET/; }
# trash() { mv -iv "$@" ~/.Trash; }	# if starts with . prepend h
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
function du
{
	[[ -z "$@" ]] && command du -hd 0 -- * .??* | sort -h && return
	[[ -z "$2" ]] && command du -hd 0 -- "$1"* "$1".??* | sort -h && return
	command du -h "$@" | sort -h
}
function trash
{
	for item in "$@"
	do
		[[ $item = .DS_Store ]] && command rm -v .DS_Store
		[[ $item = .* ]] && mv -iv "$item" ~/.Trash/h"$item"
		mv -iv "$item" ~/.Trash;
	done
}
function pipenv
{
	# PIPENV_PATH=$(which pipenv)
	# [[ -z $PIPENV_PATH ]] && echo 'pipenv not installed' && return 1
	[[ -z "$@" ]] && source "$(command pipenv --venv)/bin/activate" && return
	[[ $1 = help ]] && command pipenv -h && return
	command pipenv "$@"
}
function brew
{
	# BREW_PATH=$(which brew)
	# [[ -z $BREW_PATH ]] && echo 'brew not installed' && return 1
	[[ $1 = tree ]] && brew deps --tree --for-each $(brew leaves) && return
	command brew "$@"
}
function pip
{
	PIP_PATH=$(which pip)
	[[ -z $PIP_PATH ]] && echo 'not inside virtual environment, use pip3' && return
	# TODO check pipdeptree is in venv
	# [[ $1 = tree ]] && which pipdeptree \
	# 	|| (echo 'pipdeptree not installed anywhere' && return) \
	# 	&& shift && pipdeptree $@ && return
	$PIP_PATH "$@"
}
function venv
{
	case $1 in
		create|init) python3 -m venv venv;;
		activate   ) source venv/bin/activate;;
		deactivate ) deactivate;;
		*) echo 'venv create|activate|delete';;
	esac
}
function quote
{
	"$@" | sed 's/^/'$RESET$FAINT'┃ '$RESET/
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

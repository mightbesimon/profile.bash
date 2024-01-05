#!/bin/bash

################################################################
#######                 quality of life                  #######
################################################################
alias ls='ls -ahFG'
alias x='chmod u+x'
alias stat='stat -x'
alias python='python3'
alias venv='source venv/bin/activate'
alias reload='source ~/.bash_profile && trap precommand DEBUG'
alias update='git -C $PROFILE pull'

cd() { builtin cd $@ && ls; }


################################################################
#######                     publish                      #######
################################################################
alias vsce='npx vsce'
alias firebase='npx firebase-tools'
alias react='npx create-react-app . --template typescript'
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

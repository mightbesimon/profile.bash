#!/bin/bash

################################################################################
#######                         quality of life                          #######
################################################################################
alias ls='ls -ahFG'
alias python=python3
alias venv='source venv/bin/activate'
alias reload='source ~/.bash_profile'


################################################################################
#######                             publish                              #######
################################################################################
alias vsce='npx vsce'
alias firebase='npx firebase-tools'
alias react='npx create-react-app . --template typescript'
alias vscode='yo code'
alias pypi='rm -rv dist *.egg-info; python -m build && python -m twine upload dist/*'


################################################################################
#######                               misc                               #######
################################################################################
alias getingeat='PATH=~/commands/bin:$PATH'
alias x='chmod u+x'
alias stat='stat -x'

#!/bin/bash

################################################################################
#######                             exports                              #######
################################################################################
export PATH="$HOME/Library/Python/3.9/bin:$PATH"	# pip installed package binaries
# todo symlink these to /usr/local/bin
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="/Applications/Sublime Merge.app/Contents/SharedSupport/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# brew for package management
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"


export PATH=$HOME/.docker/bin:$PATH		# docker and docker compose
export PATH=$HOME/.cargo/bin:$PATH		# rustup and cargo
export PATH=$HOME/.local/bin:$PATH		# claude code
export PATH=$HOME/.lmstudio/bin:$PATH	# lmstudio cli


# maven for java development
# export PATH=/opt/apache-maven-3.8.5/bin:$PATH

# mongodb community server
# export PATH=/opt/mongodb-macos-x86_64-5.0.8/bin:$PATH
# export PATH=/opt/mongodb-database-tools-macos-x86_64-100.5.2/bin:$PATH

################################################################################
#######                        binary executables                        #######
################################################################################
alias matlab='/Applications/matlab.app/bin/matlab -nodesktop -nosplash'
alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
# alias merge='/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge'


################################################################################
function path
{
	echo $(repeat '-' 40)
	echo 'current paths'
	echo $(repeat '-' 40)
	echo $PATH | tr ':' '\n'
	echo $(repeat '-' 40)
	echo built from
	grep PATH= ~/.bashrc | bat --paging=never --file-name ~/.bashrc
	grep PATH= ~/.profile | bat --paging=never --file-name ~/.profile
	grep PATH= /etc/profile | bat --paging=never --file-name /etc/profile
	grep PATH= /etc/bashrc | bat --paging=never --file-name /etc/profile
	grep PATH= /Users/simon/github/profile.bash/path.bash | bat --paging=never --file-name ${PROFILE}path.bash
	see /etc/paths
	echo $(repeat '-' 40)
	echo 'from /etc/paths.d/*'
	echo $(repeat '-' 40)
	cat /etc/paths.d/*
	echo
}

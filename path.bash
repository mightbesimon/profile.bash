#!/bin/bash

function addpath
{
	[[ :$PATH: != *:$1:* ]] && export PATH="$1:$PATH"
}

################################################################################
#######                             exports                              #######
################################################################################
# export PATH="$HOME/Library/Python/3.9/bin:$PATH"	# pip installed package binaries
addpath $HOME/Library/Python/3.9/bin	# pip installed package binaries

# todo symlink these to /usr/local/bin
# export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
# export PATH="/Applications/Sublime Merge.app/Contents/SharedSupport/bin:$PATH"
# export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
addpath '/Applications/Sublime Text.app/Contents/SharedSupport/bin'
addpath '/Applications/Sublime Merge.app/Contents/SharedSupport/bin'
addpath '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'


# brew for package management
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
# export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

addpath /opt/homebrew/bin
addpath /opt/homebrew/sbin


# export PATH=$HOME/.docker/bin:$PATH		# docker and docker compose
# export PATH=$HOME/.cargo/bin:$PATH		# rustup and cargo
# export PATH=$HOME/.local/bin:$PATH		# claude code
# export PATH=$HOME/.lmstudio/bin:$PATH	# lmstudio cli


addpath $HOME/.docker/bin		# docker and docker compose
addpath $HOME/.cargo/bin		# rustup and cargo
addpath $HOME/.local/bin		# claude code
addpath $HOME/.lmstudio/bin		# lmstudio cli


################################################################################
#######                        binary executables                        #######
################################################################################
alias matlab='/Applications/matlab.app/bin/matlab -nodesktop -nosplash'
alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
# alias merge='/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge'


################################################################################
function paths
{
	echo $(repeat '-' 40)
	echo 'current paths'
	echo $(repeat '-' 40)
	echo $PATH | tr ':' '\n'
	echo $(repeat '-' 40)
	echo built from
	grep -e '^export PATH=' ~/.bashrc | bat --paging=never --file-name ~/.bashrc
	grep -e '^export PATH=' ~/.profile | bat --paging=never --file-name ~/.profile
	grep -e '^export PATH=' /etc/profile | bat --paging=never --file-name /etc/profile
	grep -e '^export PATH=' /etc/bashrc | bat --paging=never --file-name /etc/bashrc
	grep -e '^export PATH=' ${PROFILE}path.bash | bat --paging=never --file-name ${PROFILE}path.bash
	bat /etc/paths --paging=never
	echo $(repeat '-' 40)
	echo 'from /etc/paths.d/*'
	echo $(repeat '-' 40)
	bat /etc/paths.d/* --paging=never
	echo
}
# function paths
# {
# 	local IFS=':'
# 	for item in $PATH
# 	do
# 		# echo $item
# 		grep "PATH=.*${item#$HOME}" ~/.bashrc && echo ~/.bashrc
# 		grep "PATH=.*${item#$HOME}" ~/.profile && echo ~/.profile
# 		grep "PATH=.*${item#$HOME}" /etc/profile && echo /etc/profile
# 		grep "PATH=.*${item#$HOME}" /etc/bashrc && echo /etc/bashrc
# 		grep "PATH=.*${item#$HOME}" ${PROFILE}path.bash && echo ${PROFILE}path.bash
# 	done
# }

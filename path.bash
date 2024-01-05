#!/bin/bash

################################################################################
#######                             exports                              #######
################################################################################
export PATH="~/Library/Python/3.9/bin:$PATH"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# brew for package management
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

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

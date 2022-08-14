#!/bin/bash

################################################################################
#######                             exports                              #######
################################################################################
export PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:${PATH}"

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


################################################################################
#######                            navigation                            #######
################################################################################
function github() {
	cd ~/github/$1
}

function desktop() {
	cd ~/Desktop/$1
}

function repo() {
	cd ~/HealthNow/Repositories/$1
}

# profile.bash

![screenshot](assets/screenshot.png)

## Installation

```bash
destdir=/opt/profile.bash/
git clone https://github.com/mightbesimon/profile.bash.git $destdir
open $destdir/assets/Mariana.terminal 2> /dev/null
touch ~/.hushlogin
echo "export PROFILE=$destdir" >> ~/.bash_profile
echo 'source $PROFILE/profile.bash' >> ~/.bash_profile
source ~/.bash_profile
```

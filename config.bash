#!/bin/bash

# todo, save some customisation options for the user to config



#

# temp code to go into alias.bash later
# trash() {
#     local trash_dir="$HOME/.Trash"
#     mkdir -p "$trash_dir" || return 1

#     local target base dest rc=0
#     for target in "$@"; do
#         base=$(basename "$target") || continue
#         if [[ $base = .* ]]; then
#             dest="$trash_dir/h$base"
#         else
#             dest="$trash_dir/$base"
#         fi

#         if ! command mv -iv -- "$target" "$dest"; then
#             rc=1
#         fi
#     done

#     return $rc
# }	# if starts with . prepend h

# du() {
#   /usr/bin/find . -mindepth 1 -maxdepth 1 -print0 |
#     /usr/bin/xargs -0 /usr/bin/du -hd 0 |
#     sort -h
# }

#!/bin/bash

# completions
# source /opt/homebrew/etc/profile.d/bash_completion.sh
# source /opt/homebrew/completions/bash/brew
# source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

function _brew_extended
{
	local cmd_extended='tree needs installed orphans poured built dups multiples disk'
	local extensions=$(echo $cmd_extended | tr ' ' '|')

	# first arg
	if [[ $COMP_CWORD -eq 1 ]]
	then
		__brew_complete_commands
		COMPREPLY+=( $(compgen -W "$cmd_extended" -- "${COMP_WORDS[COMP_CWORD]}") )
		return 0
	fi

	# custom commands
	case "${COMP_WORDS[1]}" in
		tree|needs|builds) __brew_complete_installed_formulae;;
		# installed|orphans|poured|built|dups|multiples|disk);;
		$extensions);;
		*) _brew;;
	esac

	return 0
}

complete -F _brew_extended brew -o bashdefault -o default

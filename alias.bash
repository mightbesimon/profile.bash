#!/bin/bash

################################################################
#######                 quality of life                  #######
################################################################
# alias ls='ls -AhF --color'
which eza &> /dev/null \
&& alias ls='eza' \
|| alias ls='command ls -AhFHD %FT%H:%M:%S --color'
alias l='command ls -AhFHD %FT%H:%M:%S --color'
alias ll='ls -l --git-repos'
# alias ld='ls -l --sort=size'	# eza --sort=size
alias lt='ls --tree --level=2'		# eza --tree --level=2
alias eza='eza -AF --links --git --time-style=relative --no-user'
[[ $TERM = *ghostty ]] && alias ls='eza --colour-scale=all --icons'
[[ $TERM_PROGRAM = vscode ]] && alias ls='eza --colour-scale=all --icons'
# TODO ls with icons and tighter column with
# TODO ls -l table with box drawing chars
alias grep='grep --colour=auto'
alias type='type -a'
alias which='type -a'
alias mv='mv -iv'
alias rm='trash'
alias rmf='command rm -rv'
alias ds='command rm -v .DS_Store'
# alias x='chmod u+x'
# alias tree='tree -aCFL 8 --filelimit 24 -I .git | tr └ ╰ | sed "s/─ \([^/]*\/\)/──┬╸\1/" | sed "s/─ /───╸/"'
# alias tree='tree -aCFL 8 --filelimit 24 -I .git | sed "s/─ /─╸/"'
alias python='python3'
alias reload='source ~/.profile 2> /dev/null || source ~/.bashrc 2> /dev/null'
alias update='git -C $PROFILE pull'
alias doc=man
alias box="source $PROFILE/box.bash"

#alias clean='find . -name '.DS_Store' -type f -print -delete'
# cat ~/Library/Application\ Support/Code/User/workspaceStorage/*/workspace.json | grep file | sed -E 's/.*"folder": "file:\/\/([^"]+)".*/\1/'

# cd() { builtin cd "$@" && ls -AhFG; } # todo, add -q flag to not run ls after cd
cd() {
	builtin cd "$@"
	command ls &> /dev/null \
	&& ls --grid --colour=always 2> /dev/null | tail \
	|| log error 'ls permission denied'
}
# du() { command du -hd 0 -- * .??* | sort -h; }
stat() { command stat -xt %FT%H:%M:%S "$@" && echo -n $CYAN && GetFileInfo "$@" 2> /dev/null; }
tree() { command tree -aCFL 8 --filelimit 24 -I .git "$@" | sed 's/─ /─╸/'; }
# tree() { command tree -aCFL 8 --filelimit 24 -I .git "$@" | sed 's/─ /─'$RED'╸'$RESET/; }
todo() { :; }
mergedir() { todo; }
terminal() { todo; } #reload, update
# profile() { todo; }
function profile
{
	case $1 in
		reload) source ~/.bash_profile 2> /dev/null || source ~/.profile && trap precommand DEBUG;;
		update) git -C $PROFILE pull;;
		mariana) open $PROFILE/assets/Mariana.terminal;;
		config) $EDITOR ~/.profile $PROFILE;;
		*) echo -n "profile ${UNDERLINE}reload${RESET}|${UNDERLINE}update${RESET}";;
	esac
}
# alias term=terminal
# see, peak, view
# list as ls with colours
# wordlist() english
# idea: python llm provider management
# audit
# undo
function disk
{
	[[ -z "$@" ]] && command du -hd 0 -- * | sort -h && return
	[[ -z "$2" ]] && command du -hd 0 -- "$1/*" | sort -h && return
	command du -h "$@" | sort -h
}
function trash
{
	for item in "$@"
	do
		# [[ $item = .DS_Store ]] && command rm -v .DS_Store
		# [[ $item = .* ]] && mv -iv "$item" ~/.Trash/DOT"$item"
		# mv -iv "$item" ~/.Trash;
		case $item in
			.DS_Store) command rm -v .DS_Store;;
			.*) mv -iv "$item" ~/.Trash/DOT"$item";;
			*) mv -iv "$item" ~/.Trash;;
		esac
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
	# [[ $1 = tree ]] && command brew deps --tree --for-each $(command brew leaves) && return
	# command brew "$@"
	echo "[$(date '+%FT%H:%M:%S')]" brew $@ >> ~/.brew_history
	# TODO only save install or uninstall,
	# TODO save output of command to maybe either ~/.brew_history or in ~/.brew/ dir
	case $1 in
		tree) HOMEBREW_NO_ENV_HINTS=1 command brew deps --tree --for-each ${2:-$(command brew leaves)} ${@:3};;
		needs) command brew uses --installed ${@:2};;
		builds) command brew uses --installed --include-build ${@:2};;
		# needs) #
		# 	command brew leaves | grep $2 1> /dev/null && echo 'package is a leaf' && return
		# 	for pkg in $(command brew leaves) #
		# 	do command brew deps $pkg | grep $2 1> /dev/null && echo $pkg
		# 	done
		# 	;;
		# needs) command brew deps --for-each $(command brew leaves) | grep -E "$(tr ' ' '|' <<< ${@:2})";;
		# build) command brew deps --installed --include-build | grep -E "$(tr ' ' '|' <<< ${@:2})";;
		installed) command brew list --installed-on-request ;;
		orphans  ) command brew leaves --installed-as-dependency ;;
		poured   ) command brew list --poured-from-bottle ;;
		built    ) command brew list --built-from-source ;;
		dups|mul*) command brew list --multiple --versions ;;
		disk     ) command du -hd 0 /opt/homebrew/Cellar/* \
			/Users/*/Library/Caches/Homebrew \
			/Users/*/Library/Logs/Homebrew | sort -h
			;;
		uninstall)
			command brew uninstall ${@:2}
			command brew cleanup -n ${@:2}
			echo brew cleanup ${@:2}
			;;
		*) command brew "$@";;
	esac
}
function pip
{
	PIP_PATH=$(command which pip)
	[[ -z $PIP_PATH ]] && echo 'not inside virtual environment, use pip3' && return
	# TODO check pipdeptree is in venv
	# [[ $1 = tree ]] && which pipdeptree \
	# 	|| (echo 'pipdeptree not installed anywhere' && return) \
	# 	&& shift && pipdeptree $@ && return
	command pip "$@"
}
function venv
{
	case $1 in
		i|init|c|create)
			python3 -m venv venv
			source venv/bin/activate
			COMMAND='python3 -m venv venv'
		;;
		a|activate  ) source venv/bin/activate;;
		d|deactivate) deactivate;;
		*)
			echo -n "venv ${UNDERLINE}i${RESET}nit|${UNDERLINE}c${RESET}reate|"
			echo "${UNDERLINE}a${RESET}ctivate|${UNDERLINE}d${RESET}eactivate"
			;;
	esac
}
alias va='venv activate'
alias vd='venv deactivate'
alias vc='venv init'
function quote
{
	"$@" | sed 's/^/'$RESET$FAINT'┃ '$RESET/
}
function see
{
	[[ $2 ]] && log warning one at a time please && return
	case $1 in
		*.json|*.yaml|*.yml|*.toml|*.xml|*.hcl|*.jsonl) otree "$1";;
		*.plist) plutil -p "$1";;
		*.csv) csview -w 80 -H -t;;
		*.zip) unzip -l "$1";;
		*) bat "$1" 2> /dev/null || ls -l "$1";;
	esac
	# bat "$@" 2> /dev/null || ls -l "$@";;
}
function key
{
	security find-generic-password -s $1 -w
}
function transcribe
{
	curl -X POST https://api.openai.com/v1/audio/transcriptions \
		--header 'Authorization: Bearer '$(key OPENAI_API_KEY) \
		--header 'Content-Type: multipart/form-data' \
		--no-buffer --no-progress-meter \
		--form file=@"$1" \
		--form model=gpt-4o-transcribe-diarize \
		--form response_format=diarized_json \
		--form chunking_strategy=auto \
		--form language=${2:-en} \
		--form stream=true \
	| grep --line-buffered '^data: {' \
	| sed -u 's/^data: //' \
	| jq -r --unbuffered \
		'select(.type == "transcript.text.segment")
		| "speaker \(.speaker): \(.text)"' \
	| tee "${1%.*}_transcribed.txt" \
	&& log info saved to file ${1%.*}_transcribed.txt
}
function llm
{
	local model=gpt-5.4-mini
	[[ $1 = -m ]] && model=$2 && shift 2

	local context="$([ -t 0 ] || cat /dev/stdin)"
	local sysprompt='
		You are an assistance inside a bash terminal.
		Do not use markdown format,
		use ansi colour codes only for important or example or code.
		You can use bullet points if needed, but keep the answer concise.
		Never ask for clarification,
		just give the best answer you can with the information provided.
		Each line should be less than 80 characters.
		Lines are limited so do not waste them.
	'
	local data="$(jq -n '{
		"stream": true,
		"model": $model,
		"input": [
			{"role": "user",      "content": $user_prompt },
			{"role": "system",    "content": $instruction },
			{"role": "system",    "content": $sys_prompt  },
			{"role": "developer", "content": $context     }
		]}' \
		--arg instruction "$1" \
		--arg user_prompt "${*:2}" \
		--arg sys_prompt  "$sysprompt" \
		--arg context     "$context" \
		--arg model       "$model" \
	)"
	curl -X POST https://api.openai.com/v1/responses \
		--header 'Authorization: Bearer '$(key OPENAI_API_KEY) \
		--header 'Content-Type: application/json' \
		--no-buffer --no-progress-meter \
		--data "$data" \
	| grep --line-buffered '^data:' \
	| sed -u 's/^data: //' \
	| jq -rj --unbuffered \
		'select(.type == "response.output_text.delta") | .delta'
		# final total tokens, test for this in last data block
	echo
}
function ask
{
	local instructions='
		Give an executive answer with minimal explanation,
		and if the answer is a command, give explanation of the flags.
		Keep answers to a maximum of 24 lines.
		Each line should be less than 80 characters.
		If you need to provide a longer answer,
		consider only the most important answer
		or providing a summary or skip the explanation.
	'
	llm "$instructions" $@
}
function translate
{
	llm 'translate to en_NZ' $@
}
function fr
{
	llm 'translate to fr_FR' $@
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

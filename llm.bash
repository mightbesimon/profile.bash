#!/bin/bash

function key
{
	security find-generic-password -s $1 -w
}
function llm
{
	local model=gpt-5.4
	[[ $1 = -m ]] && model=$2 && shift 2 # && log debug using $GREEN$model

	local context="$([ -t 0 ] || cat /dev/stdin)"
	local sysprompt='
		You are an assistance inside a bash terminal.
		Do not use markdown format,
		use ansi colour codes only for important or example or code.
		Do not make the entire response all the same colour,
		use the default colour for most text unless it is code,
		use blue instead cyan if possible but prefer purple orange green.
		Try use multiple colours instead of one colour over and over again.
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
function llm_output
{
	llm $@ \
	| tee >(sed -u 's/👉[^👈]*👈//g'> /dev/tty) \
	| sed -n 's/^👉 \(.*\) 👈$/\1/p'
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
	&& log info saved to file $BLUE${1%.*}_transcribed.txt \
	|| log error transcription not saved
}
function translate
{
	local target=en-NZ
	[[ $1 == -* ]] && target=${1#-} && shift

	llm -m gpt-5.4-mini "
		translate to language $target,
		keep format give no explanations,
		only use colour if long response" $@
}
alias fr='translate -fr'
alias de='translate -de'


function ask
{
	llm 'Give an executive answer with minimal explanation,
		and if the answer is a command, give explanation of the flags.
		Keep answers to a maximum of 24 lines.
		Each line should be less than 80 characters.
		If you need to provide a longer answer,
		consider only the most important answer
		or providing a summary or skip the explanation.' $@
}
function how
{
	llm 'Give an executive answer with minimal explanation,
		and if the answer is a command, give explanation of the flags.
		Keep answers to a maximum of 24 lines.
		Each line should be less than 80 characters.
		If you need to provide a longer answer,
		consider only the most important answer
		or providing a summary or skip the explanation.' how $@
	# TODO append how and take a suggestion
}
function undo
{
	SUGGESTED_COMMAND=$(llm -m gpt-5.4 '
		give the command to undo this command
		you can give alternatives or explanation or whatever you want but
		wrap your final answer like this format 👉 undo_command args 👈
		zero or one final answer only and no ANSI colour codes in final answer,
		putting ANSI colour code in the final answer format will not execute
		do NOT use the final answer format if you do not know
		what the command is or what the undo intent is or
		if there is no one command that can achieve undo.
		then just make some suggestions or explain there is no undo or ask,
		instead of forcing a bad suggestion.
	'<<< "$LASTCMD" \
	| tee >(sed -u 's/👉[^👈]*👈//g'> /dev/tty) \
	| sed -n 's/^👉 \(.*\) 👈$/\1/p' )

	[[ $SUGGESTED_COMMAND && $SUGGESTED_COMMAND != undo* ]] \
	&& log important suggested undo command $PURPLE$SUGGESTED_COMMAND && echo
}
function why
{
	$LASTCMD 2>&1 \
	| tee /dev/stderr \
	| llm 'explain why this command failed and how to fix it' "$LASTCMD"
}
function fix
{
	$LASTCMD 2>&1 \
	| tee /dev/stderr \
	| llm -m gpt-5.4 'fix this failed command' "$LASTCMD"
	# | tee /dev/tty \
	# | sed -n 's/^👉 \(.*\) 👈$/\1/p' \
}
function ok
{
	[[ $SUGGESTED_COMMAND ]] || return
	log debug executing $PURPLE$SUGGESTED_COMMAND
	$SUGGESTED_COMMAND
	COMMAND=$SUGGESTED_COMMAND
	SUGGESTED_COMMAND=
}

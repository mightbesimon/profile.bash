#!/bin/bash

function key
{
	security find-generic-password -s $1 -w
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

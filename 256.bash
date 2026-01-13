#!/bin/bash


# for idx in {16..231}
# do
# 	# echo -n $'\e[48;5;'$idx'm'[$idx]
# 	echo -n $'\e[48;5;'$idx'm'$(((idx-16)/36%6))$(((idx-16)/6%6))$(((idx-16)%6))
# 	if (( (idx - 3) % 6 == 0 )); then
# 		echo $RESET
# 	fi
# done

function grayscale()
{
	for idx in {232..255}
	do
		echo -n $'\e[48;5;'$idx'm '
	done
	echo $RESET
}

function hsl()
{
	local percent=101
	local discrete=5
	local tempval

	local h=$(($1 % 360))
	tempval=$(($2 / percent))
	local s=$(bc -l <<< "($2 - $percent*$tempval) / $percent")
	tempval=$(($2 / percent))
	local l=$(bc -l <<< "($3 - $percent*$tempval) / $percent")
	tempval=$(bc -l <<< "2 * $l - 1")
	local c=$(bc -l <<< "(1 - ${tempval#-}) * $s")
	tempval=$((h / 120))
	tempval=$(bc -l <<< "($h / 60) - 2*$tempval - 1")
	local x=$(bc -l <<< "$c * (1 - ${tempval#-} )")
	local m=$(bc -l <<< "$l - $c / 2")
	# echo $c $x $m

	local cc=$(printf %.0f $(bc -l <<< "($c + $m) * $discrete"))
	local xx=$(printf %.0f $(bc -l <<< "($x + $m) * $discrete"))
	local mm=$(printf %.0f $(bc -l <<< "$m * $discrete"))
	# echo $cc $xx $mm

	if (( h < 60 )); then
        r=$cc; g=$xx; b=$mm
    elif (( h < 120 )); then
        r=$xx; g=$cc; b=$mm
    elif (( h < 180 )); then
        r=$mm; g=$cc; b=$xx
    elif (( h < 240 )); then
        r=$mm; g=$xx; b=$cc
    elif (( h < 300 )); then
        r=$xx; g=$mm; b=$cc
    else
        r=$cc; g=$mm; b=$xx
    fi

	local idx=$(bc -l <<< "36*$r + 6*$g + $b + 16")
	echo -n $'\e[48;5;'$idx'm'

	cc=$(printf %.0f $(bc -l <<< "($c + $m) * ($discrete-1)+1"))
	xx=$(printf %.0f $(bc -l <<< "($x + $m) * ($discrete-1)"))
	mm=$(printf %.0f $(bc -l <<< "$m * ($discrete-1)+1"))
	if (( h < 60 )); then
        r=$cc; g=$xx; b=$mm
    elif (( h < 120 )); then
        r=$xx; g=$cc; b=$mm
    elif (( h < 180 )); then
        r=$mm; g=$cc; b=$xx
    elif (( h < 240 )); then
        r=$mm; g=$xx; b=$cc
    elif (( h < 300 )); then
        r=$xx; g=$mm; b=$cc
    else
        r=$cc; g=$mm; b=$xx
    fi
	idx=$(bc -l <<< "36*$r + 6*$g + $b + 16")
	echo -n $'\e[38;5;'$idx'm'
	# echo -n ${4:-' '}
	# echo -n $RESET
	# echo -n [${r#-}${g#-}${b#-}]
	# printf ' %3.2f' $h $s $l
	# echo -n ' |'
	# printf ' %3.2f' $c $x $m
	# echo -n ' |'
	# printf ' %3.0f' $cc $xx $mm
	# echo -n ' |'
	# printf ' %3.0f' $idx
	# echo
}

function hue()
{
	for (( v=0; v<720; v+=$((360/40)) ))
	do
		hsl $v 100
		echo -n ' '$RESET
	done
	echo
}

function lightness()
{
	for (( v=0; v<100; v+=$((100/10)) ))
	do
		hsl ${1:-0} 75 $v
	done
	echo
}

blocks='▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟'
symbols='✔✕★☆◼◻◆◇●○■□▲△▼▽►◄▶◀♠♣♥♦♪♫☼☽☾☀☁☂☃'
nicechars='x·•o+=#@%><aswemnvczYKMNETIOASDFGHLZXCVB/\:&-='
chars=',./[]\!@#$%^&()_+-={}|:<>?€‹›ﬁﬂ‡°·—±÷µ¶§©®™✓ÚÆ¿˘¯`~«…•ªº–≠¶§∞¢£™¡æ÷≥≤'
letters='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
input=$blocks$chars$symbols$letters$nicechars
input='▀▄'
input='▁▂▃▄▅▆▇█'
input='▉▊▋▌▍▎▏▐▕'
input='▖▝▞▗▚▘'
input='▀▄▐▌'
input='▁▔▕▏'
# input='▁▔▕▏▁▔▕▏┃━'
# input='▁▔▕▏▁▔▕▏▁▔▕▏▁▔▕▏▁▔▕▏▁▔▕▏▁▔▕▏▁▔▕▏┃━┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋╱╲╳╴╵╶╷╸╹╺╻╼╽╾'
input='▁▔▕▏'

function rainbow()
{
	local hs=9
	# local h=0
	local s=100
	local ss=-1
	local l=50
	local ll=1

	for (( row=0; row<${1:-1}; row++ ))
	do
		for col in $(seq 0 $((2*360/hs-1)))
		do
			# echo -n $h-$s-$l
			h=$((hs*col + RANDOM%(hs*2) - hs))
			# h=$((330 + RANDOM%(120) - 60))
			# s=((s + ss))
			# l=$((l + ll))
			# s=$((s + ss * (RANDOM % 2 + 1)))
			# l=$((l + ll * (RANDOM % 2 + 1)))
			s=$(((RANDOM % 25 + 75 + s*2) / 3 + ss ))
			l=$(((RANDOM % 20 + 40 + l*2) / 3 + ll ))
			hsl $h $s $l ${input:RANDOM%${#input}:1}
			echo -n ' '$RESET
			if (( col % (2*360/hs) == (2*360/hs)-1 ))
			then echo
			fi
			if (( 80 > s ))
			then ss=$((RANDOM % 3 + 1))
			elif (( s > 100-6 ))
			then ss=$((- RANDOM % 3 - 1))
			fi
			if (( 40 > l ))
			then ll=$((RANDOM % 3 + 1))
			elif (( l > 60 ))
			then ll=$((- RANDOM % 3 - 1))
			fi
		done
	done
}

function peach()
{
	local hs=2
	local ha=200
	local hb=360
	local s=100
	local ss=-1
	local l=50
	local ll=1

	for (( row=0; row<${1:-1}; row++ ))
	do
		for col in $(seq 0 $(((hb-ha)/hs-1)))
		do
			# echo -n $h-$s-$l
			h=$((ha+hs*col + RANDOM%(hs*2) - hs))
			# h=$((330 + RANDOM%(120) - 60))
			# s=((s + ss))
			# l=$((l + ll))
			# s=$((s + ss * (RANDOM % 2 + 1)))
			# l=$((l + ll * (RANDOM % 2 + 1)))
			s=$(((RANDOM % 25 + 75 + s*2) / 3 + ss ))
			l=$(((RANDOM % 20 + 40 + l*2) / 3 + ll ))
			hsl $h $s $l ${input:RANDOM%${#input}:1}
			echo -n ' '$RESET
			if (( col % ((hb-ha)/hs) == (hb-ha)/hs-1 ))
			then echo
			fi
			if (( 80 > s ))
			then ss=$((RANDOM % 3 + 1))
			elif (( s > 100-6 ))
			then ss=$((- RANDOM % 3 - 1))
			fi
			if (( 40 > l ))
			then ll=$((RANDOM % 3 + 1))
			elif (( l > 60 ))
			then ll=$((- RANDOM % 3 - 1))
			fi
		done
	done
}

# peach 6
function pulse()
{
	local i=0
	while :; do
		printf '  %s\r' "$(hsl $i 100 50)"rainbow"$RESET"
		i=$(( (i+10) % 360))
		# sleep .01
	done
}

pulse

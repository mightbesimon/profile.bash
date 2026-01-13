spinner='⠁⠂⠄⡀⡈⡐⡠⣀⣁⣂⣄⣌⣔⣤⣥⣦⣮⣶⣷⣿⡿⠿⢟⠟⡛⠛⠫⢋⠋⠍⡉⠉⠑⠡⢁'
spinner='━╍┅┉┅╍'
spinner='🙈🙉🙊🐵🙊🙉'
spinner='◜◠◝◞◡◟'
spinner='◜◠◝◝◞◡◟◟'
spinner='▖▌▘▀▝▐▗▄'
spinner='▖▖▌▘▘▀▝▝▐▗▗▄'
spinner='█▓▒░ ░▒▓'
spinner='🌕🌖🌗🌘🌑🌒🌓🌔'
spinner='🌑🌘🌗🌖🌕🌔🌓🌒'
spinner='🌎🌍🌏'
spinner='🌝🌛🌝🌜'
spinner='💌📩📨📥'
spinner='📁📂'
spinner='🔸🔅🔆🟠🔆🔅'
spinner='📄📑'
spinner='📁📂'
spinner='🔨🛠'
spinner='😠😡🤬'
spinner='🌤⛅️🌥🌦🌧⛈🌩🌨🌦🌥⛅️'
spinner='⭐️🌟'
spinner='💛💝💖💗💘💓💞💕💞💓💘💗💖💝'
spinner='🕛🕧🕐🕜🕑🕝🕒🕞🕓🕟🕔🕠🕕🕡🕖🕢🕗🕣🕘🕤🕙🕥🕚🕦'
spinner='⌛️⏳'
spinner='⢎⡰⢎⡡⢎⡑⢎⠱⠎⡱⢊⡱⢌⡱⢆⡱'
#🍺🍻🛁🛀📪📫📬📭📈📉📕📙📒📗📘
# ▖

# ▗

# ▘

# ▙

# ▚

# ▛

# ▜

# ▝

# ▞

# ▟

# ▐

# ▌

# ▄

# ▀
spinnersize=1
function spin
{
	local i=0
	while :; do
		printf '  %s\r' "${spinner:i:spinnersize}"
		i=$(( (i+spinnersize) % ${#spinner}))
		sleep ${1:-.2}
	done
}

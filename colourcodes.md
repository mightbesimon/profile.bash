# font variant

1	bold
2	dim
3	italics
4	underline
5	blink
7	invert text and background colour
8	invisible
9	strikethrough

# text colours	8-16 bits

39	Default
30	Black
31	Red
32	Green
33	Yellow
34	Blue
35	Magenta
36	Cyan
37	White
90	Bright Black
91	Bright Red
92	Bright Green
93	Bright Yellow
94	Bright Blue
95	Bright Magenta
96	Bright Cyan
97	Bright White

# background colours	8-16 bits

49	Default
40	Black
41	Red
42	Green
43	Yellow
44	Blue
45	Magenta
46	Cyan
47	White
100		Bright Black
101		Bright Red
102		Bright Green
103		Bright Yellow
104		Bright Blue
105		Bright Magenta
106		Bright Cyan
107		Bright White

# 256 bit colours

ESC[38;5;{ID}m	text
ESC[48;5;{ID}m	background

# 24 bit rgb colours

ESC[38;2;{r};{g};{b}m	text
ESC[48;2;{r};{g};{b}m	background

# ANSI Escape Sequence Code

```
\e[{seq}m
\e[{seq};{seq};{seq}m
```
## style variant

seq | description
--- | ---
`0` | reset
`1` | bold
`2` | dim
`3` | italics
`4` | underline
`5` | blink
`7` | invert fg bg colour
`8` | invisible
`9` | strikethrough

## 3-4 bit (8-16 colours)

colour  | fg dim | fg bright | bg dim | bg bright
------- |:------:|:---------:|:------:|:---------:
black   |  `30`  |   `90`    |  `40`  |   `100`
red     |  `31`  |   `91`    |  `41`  |   `101`
green   |  `32`  |   `92`    |  `42`  |   `102`
yellow  |  `33`  |   `93`    |  `43`  |   `103`
blue    |  `34`  |   `94`    |  `44`  |   `104`
magenta |  `35`  |   `95`    |  `45`  |   `105`
cyan    |  `36`  |   `96`    |  `46`  |   `106`
white   |  `37`  |   `97`    |  `47`  |   `107`
default |  `39`  |           |  `49`  |

## 8 bit (256 colours),  24 bit (rgb colours)

.          | 8 bit 256 colours |   24 bit rgb colours
---------- |:-----------------:|:----------------------:
foreground |  `\e[38;5;{ID}m`  | `\e[38;2;{r};{g};{b}m`
background |  `\e[48;5;{ID}m`  | `\e[48;2;{r};{g};{b}m`

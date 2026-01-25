#!/bin/bash

################################################################
#######                control characters                #######
################################################################
export     RESET=$'\e[0m'
export      BOLD=$'\e[1m'
export     FAINT=$'\e[2m'
export    ITALIC=$'\e[3m'
export UNDERLINE=$'\e[4m'
export     BLINK=$'\e[5m'
export    INVERT=$'\e[7m'
export   CONSEAL=$'\e[8m'

################################################################
#######            normal foreground colours             #######
################################################################
export  BLACK=$'\e[38;5;234m'
export    RED=$'\e[38;5;203m'
export  GREEN=$'\e[38;5;157m'
export YELLOW=$'\e[38;5;215m'
export   BLUE=$'\e[38;5;75m'
export PURPLE=$'\e[38;5;219m'
export   CYAN=$'\e[38;5;123m'
export  WHITE=$'\e[38;5;189m'

################################################################
#######            bright foreground colours             #######
################################################################
export  BR_BLACK=$'\e[38;5;236m'
export    BR_RED=$'\e[38;5;210m'
export  BR_GREEN=$'\e[38;5;194m'
export BR_YELLOW=$'\e[38;5;221m'
export   BR_BLUE=$'\e[38;5;117m'
export BR_PURPLE=$'\e[38;5;225m'
export   BR_CYAN=$'\e[38;5;123m'
export  BR_WHITE=$'\e[38;5;231m'

################################################################
#######            normal background colours             #######
################################################################
export  BG_BLACK=$'\e[48;5;234m'
export    BG_RED=$'\e[48;5;203m'
export  BG_GREEN=$'\e[48;5;157m'
export BG_YELLOW=$'\e[48;5;215m'
export   BG_BLUE=$'\e[48;5;75m'
export BG_PURPLE=$'\e[48;5;219m'
export   BG_CYAN=$'\e[48;5;123m'
export  BG_WHITE=$'\e[48;5;189m'

################################################################
#######            bright background colours             #######
################################################################
export  BG_BR_BLACK=$'\e[48;5;236m'
export    BG_BR_RED=$'\e[48;5;210m'
export  BG_BR_GREEN=$'\e[48;5;194m'
export BG_BR_YELLOW=$'\e[48;5;221m'
export   BG_BR_BLUE=$'\e[48;5;117m'
export BG_BR_PURPLE=$'\e[48;5;225m'
export   BG_BR_CYAN=$'\e[48;5;123m'
export  BG_BR_WHITE=$'\e[48;5;231m'

#!/bin/bash

################################################################
#######                    plaintext                     #######
################################################################

# filename=${1%.*}
# extension=${1##*.}
function compile()
{
	if [[ $1 == *.c ]]
	then
		gcc $1 -o ${1%.*}
	fi
	if [[ $1 == *.java ]]
	then
		javac $1
	fi
}

function run()
{
	if [[ $1 == *.c ]]
	then
		gcc $1 -o ${1%.*}
		./${1%.*}
	fi
	if [[ $1 == *.java ]]
	then
		javac $1
		java ${1%.*}
	fi
}

function build()
{
	if [[ $1 == *.java ]]
	then
		javac $1 -d build/
		java -cp build/ ${1%.*}
	fi
}

function buildjar()
{
	if [[ $1 == *.java ]]
	then
		javac $1 -d build/
		jar cvfe ${1%.*}.jar ${1%.*} -C build/ .
	fi
}

################################################################
#######                  compile OpenGL                  #######
################################################################
function compileGL()
{
	g++ $1 -o ${1%.*} -framework GLUT -framework OpenGL -Wno-deprecated
}

function runGL()
{
	g++ $1 -o ${1%.*} -framework GLUT -framework OpenGL -Wno-deprecated
	./${1%.*}
}

export CLICOLOR="yes"
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'

# FILE-TYPE =fb
# f is the foreground color
# b is the background color
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background

# search path for cd(1)
# CDPATH=.:$HOME
# Colour code
DIR=Dx
SYM_LINK=Gx
SOCKET=Fx
PIPE=dx
EXE=Cx
BLOCK_SP=Dx
CHAR_SP=Dx
EXE_SUID=hb
EXE_GUID=ad
DIR_STICKY=Ex
DIR_WO_STICKY=Ex

# Want to see fancy ls output? blank to disable it
ENABLE_FANCY="-F"

export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"

[ "$ENABLE_FANCY" == "-F" ] && alias ls='ls -GF' || alias 'ls=ls -G'

# now some handy stuff
alias l='ls'
alias ll='ls -la'
alias lm='ll|less'

# Setup  prompt green for users.
NORMAL="\[\e[0m\]"
GREEN="\[\e[1;32m\]"
RED="\[\e[1;31m\]"

if [ $(id -u) -eq 0 ];
then # you are root, make the prompt red
    #PS1="[\e[01;34m\u @ \h\e[00m]----[\e[01;34m$(pwd)\e[00m]\n\e[01;31m#\e[00m "
    PS1="$RED\u@\h [ $NORMAL\w$RED ]# $NORMAL"
else
    PS1="$GREEN\u@\h [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export MM_CHARSET=utf8

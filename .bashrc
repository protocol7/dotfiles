#!/bin/bash

command_exists() {
    command "$1" &> /dev/null ;
}

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
if command_exists uname;
then
  UNAMEX=$(uname)
fi
# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc


# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# fuck that you have new mail shit
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin:/opt/homebrew/bin/"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
  PATH="$HOME/bin:$PATH"

test -d "$HOME/src/sp/sptools" &&
  PATH="$HOME/src/sp/sptools:$PATH"

export PATH

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac


# enable en_US locale w/ utf-8 encodings if not already configured
LANG=en_US.UTF-8
LANGUAGE=en
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LANGUAGE LC_CTYPE LC_ALL

#export LC_CTYPE=en_US.UTF-8

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"

# history stuff
HISTCONTROL=ignoreboth
HISTFILESIZE=100000
HISTSIZE=100000


# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# See what we have to work with ...
HAVE_VIM=$(command -v vim)
HAVE_GVIM=$(command -v gvim)

# EDITOR
test -n "$HAVE_VIM" &&
    EDITOR=vim ||
    EDITOR=vi
export EDITOR

# PAGER
# Use vim as MANPAGER
# http://zameermanji.com/blog/2012/12/30/using-vim-as-manpager/
MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
#    MANPAGER="less -FiRswX"
else
    PAGER=more
#    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"
ACK_PAGER_COLOR="$PAGER"


# ----------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
# ----------------------------------------------------------------------

if [ "$UNAMEX" = "Darwin" ]; then
    test -x /usr/pkg -a ! -L /usr/pkg && {
        PATH="/usr/pkg/sbin:/usr/pkg/bin:$PATH"
        MANPATH="/usr/pkg/share/man:$MANPATH"
    }
fi

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

for COMPLETION in "$(brew --prefix)/etc/bash_completion.d/"*
do
  [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
done

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
if [ "$UNAMEX" = "Darwin" ]; then
  LS_COMMON="-hB"
else
  LS_COMMON="-hB --color"
fi

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# add colors to file listings
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
    alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll="ls -la"
alias l.="ls -d .*"

alias ..="cd .."
alias ...="cd ../.."

alias notes="cd ~/Documents/notes"

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# set up prompt
test -r ~/.shorten-path.bash &&
      . ~/.shorten-path.bash

# debug bash
#set -x

myprompt()
{
  # thanks to http://selena.deckelmann.usesthis.com/ for inspiration
  # must be done before shorten_path and __git_ps1
  if [ $? == 0 ];
  then
    HAPPY=':)'
  else
    HAPPY=':('
  fi

  if command_exists hostname;
  then
    if [[ `hostname` != ngn* ]]; then
      HOSTPS1=`hostname -s`
      HOSTPS1="${USER}@${HOSTPS1} "
    fi
  fi

  if [[ `type -t shorten_path` = "function" ]]; then
    SHORT_PATH=$(shorten_path "${PWD}" 25)
  else
    SHORT_PATH=${PWD}
  fi


  # show git branch if function exists, but not if we're in the dotfiles repo ($HOME)
  if [ "$(type -t __git_ps1)" = "function" -a "$(git rev-parse --show-toplevel 2>/dev/null)" != "$HOME" ]; then
    GIT_BRANCH=$(__git_ps1 "(%s")
  fi
  echo "${HOSTPS1}${SHORT_PATH}${GIT_BRANCH} ${HAPPY} "
}

PS1='$(myprompt)'

# use vi editing in bash
set -o vi

export GPG_DEFAULT_KEY="niklas@protocol7.com"

# get some nice colors in grep
alias grep='grep --color=auto'

# update bash history after each command
PROMPT_COMMAND="history -a"

alias c="code ."

function mkd {
  mkdir $1 && cd $1
}

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh
. ~/.asdf/plugins/java/set-java-home.bash

eval "$(/opt/homebrew/bin/brew shellenv xx)"

export MCFLY_DISABLE_MENU=TRUE
export MCFLY_INTERFACE_VIEW=BOTTOM
eval "$(mcfly init bash)"

# always end happy
true

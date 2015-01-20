## COMMENT ## {{{1
# Author: <lukas42singer (at) gmail (dot) com>
# Filename: ~/.bashrc
# Description: this is my .bashrc file, it contains the default
#              debian settings plus my personal settings.  feel
#              free to copy the file or parts of it.  don't blame
#              me if it doesn't fit your needs.
#
# My .bashrc is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# My .bashrc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with my .bashrc.  If not, see <http://www.gnu.org/licenses/>.
#

### THIS IS THE DEFAULT CONFIGURATION ### {{{1
### SOME OF THESE SETTINGS GET OVERWRITTEN
### IN THE SECTION OF MY PERSONAL SETTINGS
### BELOW.  BUT I KEEP THEM AS REFERENCE.
###########################################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### MY CONFIGURATION STARTS HERE ### {{{1

## functions {{{2

cond_add_path() {  #{{{3
  # conditionally add to path variable
  # adds the first argument to the path
  # if it is a directory
  if [ -d $1 ]; then  # if directory exists
    if [[ ":$PATH:" != *":$1:"* ]]; then  # if directory is not allready in path
      PATH=$PATH:$1
    fi
  fi
}

batt_stat_for_ps1() { #{{{3
  local BATTERY=/sys/class/power_supply/BAT1

  if [ -d $BATTERY ]; then
    # calc the percentage of battery
    local CHRG=`echo $(($(cat $BATTERY/energy_now)*100 / $(cat $BATTERY/energy_full)))`
    # trim it to 100% if it is greater than 99
    if [ "$CHRG" -gt "99" ]; then
      local CHRG=100
    fi

    # get the status of the battery
    case "$(cat $BATTERY/status)" in
      [Ff]ull)
        local BATSTT="="
        ;;
      [Cc]harging)
        local BATSTT="+"
        ;;
      [Dd]ischarging)
        local BATSTT="-"
        ;;
      *)
        local BATSTT="?"
        ;;
    esac

    echo -e "[$CHRG%$BATSTT]"
  else
    echo -e ""
  fi
}


## basic settings {{{2

# allows /**/ to complete optional nested directorys.
# f.e:  ~$ dev/**/*.py will find all *.py files in all
# in ~/dev/ and all of its subdirectorys.
shopt -s globstar

# disable <C-s> in terminal so that i can use it in vim
stty stop undef

## aliases {{{2

alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lah'

alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'

alias sb='source ~/.bashrc'

alias cls='clear'

alias dt='date'

alias apt-get='sudo apt-get'

alias md='mkdir -p'

## env settings {{{2
cond_add_path /opt/bin
cond_add_path $HOME/bin

## prompt {{{2
PS1=' $(batt_stat_for_ps1) \w \$ '

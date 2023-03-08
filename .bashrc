#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Source proxy environment if present
if [ -f "${HOME}/.proxy" ]; then
    source "${HOME}/.proxy"
fi

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-multiline'
export POWERLINE_LEFT_PROMPT="hostname scm cwd"
export POWERLINE_PROMPT_CHAR="\$"
export THEME_CHECK_SUDO=false

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. Used by the git plugin.
export GIT_HOSTING='git@github.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

export BASH_IT_CUSTOM=${HOME}/.bash_it_custom

# Create a command to manage dotfile changes.
alias dotfiles='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

# Load Bash It
source "$BASH_IT"/bash_it.sh

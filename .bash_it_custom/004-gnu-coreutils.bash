# shellcheck shell=bash
# vi: set ft=sh:

# Use GNU coreutils by default when available
if [[ "$(uname)" == "Darwin" ]] && [[ -x "$(command -v brew)" ]]; then
    gnu_libexec="$(brew --prefix)/opt/coreutils/libexec"
    if [ -d "$gnu_libexec" ]; then
        if [[ ! ":$PATH:" == *":$gnu_libexec/gnubin:"* ]]; then
            export PATH="$gnu_libexec/gnubin:$PATH"
        fi
        alias ls='ls --color=auto'
        if [ -z "$MANPATH" ]; then
            export MANPATH="$gnu_libexec/gnuman"
        elif [[ ! ":$MANPATH:" == *":$gnu_libexec/gnuman:"* ]]; then
            export MANPATH="$gnu_libexec/gnuman:$MANPATH"
        fi
    fi
    unset gnu_libexec
fi

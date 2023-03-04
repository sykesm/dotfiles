# vi: set ft=zsh:

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

if [[ -z "${HOMEBREW_PREFIX}" ]] || [[ ! ":$PATH:" == *":$HOMEBREW_PREFIX/bin:"* ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval $(/opt/homebrew/bin/brew shellenv)
    elif [[ -x /usr/local/Homebrew/bin ]]; then
        eval $(/usr/local/Homebrew/bin/brew shellenv)
    fi
fi

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

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

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
elif [[ -x /usr/local/Homebrew/bin ]]; then
    eval $(/usr/local/Homebrew/bin/brew shellenv)
fi

if [[ -d /usr/local/go ]]; then
    export PATH="$PATH:/usr/local/go/bin"
fi

# Baseline manpath
if [[ "$(uname)" == "Darwin" ]] && [[ -x /usr/libexec/path_helper ]]; then
    [[ -z "${MANPATH}" ]] && export MANPATH=""
    eval "$(/usr/libexec/path_helper -s | \grep MANPATH)"
    [[ -z "${MANPATH}" ]] && unset MANPATH
fi

# Use GNU coreutils by default when available
if [[ "$(uname)" == "Darwin" ]] && [[ -x "$(command -v brew)" ]]; then
    gnu_libexec="$(brew --prefix)/opt/coreutils/libexec"
    if [ -d "$gnu_libexec" ]; then
        export PATH="$gnu_libexec/gnubin:$PATH"
        alias ls='ls --color=auto'
        if [ -z "$MANPATH" ]; then
            export MANPATH="$gnu_libexec/gnuman"
        else
            export MANPATH="$gnu_libexec/gnuman:$MANPATH"
        fi
    fi
    unset gnu_libexec
fi

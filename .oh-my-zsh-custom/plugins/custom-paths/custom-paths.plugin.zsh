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

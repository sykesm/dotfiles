# vi: set ft=sh:

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
elif [[ -x /usr/local/Homebrew/bin ]]; then
    eval $(/usr/local/Homebrew/bin/brew shellenv)
fi

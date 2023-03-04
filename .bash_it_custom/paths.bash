# shellcheck shell=bash
# vi: set ft=sh:

# add $HOME/bin if not already on the path
if [[ ! ":$PATH:" == *":$HOME/bin:"* ]]; then
    export PATH="$PATH:$HOME/bin"
fi

# add /usr/local/sbin if not already on the path
if [[ ! ":$PATH:" == *":/usr/local/sbin:"* ]]; then
    export PATH="$PATH:/usr/local/sbin"
fi

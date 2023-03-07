# shellcheck shell=bash
# vi: set ft=sh:

if [ -d "$HOME/.config/nvm" ]; then
    export NVM_DIR="$HOME/.config/nvm"
elif [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
fi

if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
elif [ -x "$(command -v brew)" ] && [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
    source "$(brew --prefix nvm)/nvm.sh"
fi

if [ -x "$(command -v brew)" ] && [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ]; then
    source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
fi

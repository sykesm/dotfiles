# vi: set ft=zsh:

if [[ -x "$(command -v nvim)" ]]; then
    export VISUAL=nvim
elif [[ -x "$(command -v vim)" ]]; then
    export VISUAL=vim
elif [[ -x "$(command -v vi)" ]]; then
    export VISUAL=vi
fi

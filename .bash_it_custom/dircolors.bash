# shellcheck shell=bash
# vi: set ft=sh:

function setup_dircolors {
    local cmd="$1"
    if [[ -e "$HOME/.dir_colors" ]]; then
        eval "$("$cmd" "$HOME/.dir_colors")"
    elif [[ -e "$HOME/.dircolors" ]]; then
        eval "$("$cmd" "$HOME/.dircolors")"
    else
        eval "$("$cmd")"
    fi
}

function test_ls_args {
    local cmd="$1"
    local args=( "${@: 2}" )
    command "$cmd" "${args[@]}" /dev/null &>/dev/null
}

if [[ -x "$(command -v dircolors)" ]]; then
    setup_dircolors dircolors
elif [[ -x "$(command -v gdircolors)" ]]; then
    setup_dircolors gdircolors
fi

if test_ls_args gls --color; then
    alias ls='gls --color=auto'
elif test_ls_args ls --color; then
    alias ls='ls --color=auto'
fi

unset -f setup_dircolors
unset -f test_ls_args

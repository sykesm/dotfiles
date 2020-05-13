# shellcheck shell=zsh
# vi: set ft=sh:

# Test if we should support color
if [ -n "$TERM" ] && [ -t 1 ] && [ "$(tput colors)" -ge "8" ]; then
    color_terminal="true"
fi

# Color man pages
if [ -n "$color_terminal" ]; then
    # mb=begin blinking
    # md=begin bold
    # mr=begin reverse
    # mh=begin half-bright
    # me=end mode
    # so=begin standout-mode - info box
    # se=end standout-mode
    # us=begin underline
    # ue=end underline
    man() {
        \env LESS_TERMCAP_mb="$(tput bold; tput setaf 6)" \
            LESS_TERMCAP_md="$(tput bold; tput setaf 6)" \
            LESS_TERMCAP_me="$(tput sgr0)" \
            LESS_TERMCAP_so="$(tput smso)" \
            LESS_TERMCAP_se="$(tput rmso)" \
            LESS_TERMCAP_us="$(tput smul; tput setaf 2)" \
            LESS_TERMCAP_ue="$(tput rmul; tput sgr0)" \
            LESS_TERMCAP_mr="$(tput rev)" \
            LESS_TERMCAP_mh="$(tput dim)" \
            LESS_TERMCAP_ZN="$(tput ssubm)" \
            LESS_TERMCAP_ZV="$(tput rsubm)" \
            LESS_TERMCAP_ZO="$(tput ssupm)" \
            LESS_TERMCAP_ZW="$(tput rsupm)" \
            man "$@"
    }
fi

# vi: set ft=zsh:

# Tweak things if using oh-my-posh for the prompt command
if [[ -x "$(command -v oh-my-posh)" ]] && [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    unset PS1 PS2             # Prevent registration of git prompt handlers
    DISABLE_AUTO_TITLE=true   # Disable window title support
    omz_termsupport_cwd() { } # Remove OSC 7 cwd update

    posh_config="${XDG_CONFIG_HOME}/oh-my-posh/sykesm.yaml"
    if [[ -r "$posh_config" ]]; then
        eval "$(oh-my-posh init zsh --config "$posh_config")"
    else
        eval "$(oh-my-posh init zsh)"
    fi
fi

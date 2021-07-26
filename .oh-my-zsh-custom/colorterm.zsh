# vi: set ft=zsh:

LC_TERMINAL=${LC_TERMINAL:-$TERM_PROGRAM}
LC_TERMINAL=${LC_TERMINAL:-$LC_TERMINAL_PROGRAM}

if [[ -z "$COLORTERM" ]]; then
  if [[ "$LC_TERMINAL" == *"iTerm"* ]] || [[ "$LC_TERMINAL" == "alacritty" ]] || [[ "$LC_TERMINAL" == "Blink" ]]; then
    export COLORTERM="truecolor"
  elif [[ -n "$WT_SESSION" ]]; then
    export COLORTERM="truecolor"
  fi
fi

# vi: set ft=zsh:

if [[ -z "$COLORTERM" ]]; then
  if [[ "$TERM_PROGRAM" == *"iTerm"* ]] || [[ "$TERM_PROGRAM" == "alacritty" ]]; then
    export COLORTERM="truecolor"
  elif [[ -n "$WT_SESSION" ]]; then
    export COLORTERM="truecolor"
  fi
fi

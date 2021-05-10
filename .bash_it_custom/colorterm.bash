# shellcheck shell=bash
# vi: set ft=sh:

if [[ -z "$COLORTERM" ]]; then
  if [[ "$TERM_PROGRAM" == *"iTerm"* ]] || [[ "$TERM_PROGRAM" == "alacritty" ]]; then
    export COLORTERM="truecolor"
  elif [[ "$LC_TERMINAL" == *"iTerm"* ]] || [[ "$LC_TERMINAL" == "alacritty" ]]; then
    export COLORTERM="truecolor"
  elif [[ -n "$WT_SESSION" ]]; then
    export COLORTERM="truecolor"
  fi
fi

# vi: set ft=zsh:

if [[ "$(ulimit -Hn)" == "unlimited" ]] || (( $(ulimit -Hn) > 8192 )) ; then
  ulimit -Sn 8192 || true
else
  ulimit -Sn "$(ulimit -Hn)" || true
fi

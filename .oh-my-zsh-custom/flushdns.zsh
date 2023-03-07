# vim: ft=sh

if [[ "$(uname)" == "Darwin" ]]; then
    flushdns() {
        sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
    }
fi

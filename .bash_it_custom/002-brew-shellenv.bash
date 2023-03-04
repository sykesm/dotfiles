# vi: set ft=sh:
# shellcheck disable=SC2046

if [[ -z "${HOMEBREW_PREFIX}" ]] || [[ ! ":$PATH:" == *":${HOMEBREW_PREFIX}/bin:"* ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval $(/opt/homebrew/bin/brew shellenv)
    elif [[ -x /usr/local/Homebrew/bin ]]; then
        eval $(/usr/local/Homebrew/bin/brew shellenv)
    fi
fi

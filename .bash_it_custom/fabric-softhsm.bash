# shellcheck shell=bash
# vi: set ft=sh:

if [[ "$(uname)" == "Darwin" ]] && [[ -x "$(command -v brew)" ]]; then
    PKCS11_LIB="$(brew list -lv1 --formula softhsm 2>/dev/null | grep libsofthsm2.so)"
else
    PKCS11_LIB="$(find /usr/lib -name libsofthsm2.so | head -1)"
fi

if [[ -n "$PKCS11_LIB" ]]; then
    export PKCS11_LIB
    export PKCS11_PIN="98765432"
    export PKCS11_LABEL="ForFabric"
fi

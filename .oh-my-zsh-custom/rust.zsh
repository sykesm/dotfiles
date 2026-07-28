# vi: set ft=zsh:

if [[ "$(uname)" == "Darwin" ]] && [[ -x "$(command -v brew)" ]] && brew --prefix --installed rustup >/dev/null 2>&1; then
    export PATH="$(brew --prefix rustup)/bin:$PATH"
elif [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

if [[ -x "$(command -v rustc)" ]]; then
    rust_sysroot=$(rustc --print sysroot)
    if [[ -d "$rust_sysroot/lib/rustlib/src/rust/library/std" ]]; then
        export RUST_SRC_PATH="$rust_sysroot/lib/rustlib/src/rust/library"
    elif [[ -d "$rust_sysroot/lib/rustlib/src/rust/src/std" ]]; then
        export RUST_SRC_PATH="$rust_sysroot/lib/rustlib/src/rust/src"
    fi
    unset rust_sysroot
fi

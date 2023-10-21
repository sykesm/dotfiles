# vi: set ft=zsh:

if [[ -x "$(command -v chromium)" ]]; then
  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
  export PUPPETEER_EXECUTABLE_PATH="$(command -v chromium)"
fi

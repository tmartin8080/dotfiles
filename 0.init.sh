#!/usr/bin/env bash

xcode-select --install &>/dev/null

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update
brew upgrade

BREW_PREFIX=`brew --prefix`
HOMEBREW_BUNDLE_NO_LOCK=TRUE HOMEBREW_NO_INSTALL_CLEANUP=TRUE brew bundle --file="Brewfile"

if ! test -f "${BREW_PREFIX}/bin/sha256sum"; then
  ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

brew cleanup

if ! command -v asdf &>/dev/null; then
  echo "asdf does not exist"
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.10.0  &>/dev/null
fi
. $HOME/.asdf/asdf.sh

exit 0

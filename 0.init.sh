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

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# workaround for wxwidgets issue
brew unlink wxwidgets
brew tap laggardkernel/tap
# wget https://raw.githubusercontent.com/Homebrew/homebrew-core/7d7daebdadd1b7badf56bd87bce75f38e51c5795/Formula/wxwidgets.rb
brew install ./wxwidgets.rb
brew switch wxwidgets 3.1.5
brew pin wxwidgets

brew cleanup
brew autoremove

if ! command -v asdf &>/dev/null; then
  echo "asdf does not exist... installing"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0  &>/dev/null
fi

. "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/asdf.sh"

exit 0

#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

brew install bash
brew install bash-completion2

brew install zsh
brew install z

chsh -s "/bin/zsh";

## Install `wget` with IRI support.
brew install wget 
brew install curl 
brew install git 

## Install GnuPG to enable PGP-signing commits.
brew install gnupg

## Install more recent versions of some macOS tools.
brew install --HEAD neovim
brew install grep
brew install openssh
brew install screen
brew install gmp
brew install rg

## Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Neovim
brew install neovim --HEAD

## Remove outdated versions from the cellar.
brew cleanup

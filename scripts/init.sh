#!/usr/bin/env bash
# Initialize system dependencies
# Installs Homebrew, system packages, oh-my-zsh, and mise

set -e

echo "Installing Xcode command line tools..."
xcode-select --install &>/dev/null || true

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

echo "Updating Homebrew..."
brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)
echo "Installing packages from Brewfile..."
HOMEBREW_BUNDLE_NO_LOCK=TRUE HOMEBREW_NO_INSTALL_CLEANUP=TRUE brew bundle --file="Brewfile"

# Create sha256sum symlink if needed
if ! test -f "${BREW_PREFIX}/bin/sha256sum"; then
  echo "Creating sha256sum symlink..."
  ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed"
fi

# Legacy wxwidgets workaround - only run if wxwidgets.rb exists
if [ -f "./wxwidgets.rb" ]; then
  echo "Applying wxwidgets workaround (legacy)..."
  brew unlink wxwidgets 2>/dev/null || true
  brew tap laggardkernel/tap 2>/dev/null || true
  brew install ./wxwidgets.rb 2>/dev/null || true
  brew switch wxwidgets 3.1.5 2>/dev/null || true
  brew pin wxwidgets 2>/dev/null || true
fi

echo "Cleaning up Homebrew..."
brew cleanup
brew autoremove

# Install mise if not present
if ! command -v mise &>/dev/null; then
  echo "Installing mise..."
  curl https://mise.run | sh
else
  echo "mise already installed"
fi

echo "Activating mise..."
eval "$(mise activate bash)"

echo "System initialization complete!"

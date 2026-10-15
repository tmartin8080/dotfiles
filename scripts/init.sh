#!/usr/bin/env bash
# Initialize system dependencies
# Installs Homebrew, system packages, oh-my-zsh, and mise
#
# This script is idempotent — safe to run multiple times.

set -e

# Install Xcode command line tools (skip if already installed)
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode command line tools..."
  xcode-select --install
  echo "Waiting for Xcode CLI tools installation to complete..."
  echo "(You may need to accept the dialog that appeared.)"
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
else
  echo "Xcode command line tools already installed"
fi

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Ensure brew is on PATH for the rest of this script
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed"
fi

echo "Updating Homebrew..."
brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)

echo "Installing packages from Brewfile..."
HOMEBREW_BUNDLE_NO_LOCK=TRUE HOMEBREW_NO_INSTALL_CLEANUP=TRUE brew bundle --file="Brewfile"

# Create sha256sum symlink if needed (handle stale symlinks)
if [ -L "${BREW_PREFIX}/bin/sha256sum" ] && [ ! -e "${BREW_PREFIX}/bin/sha256sum" ]; then
  echo "Removing stale sha256sum symlink..."
  rm "${BREW_PREFIX}/bin/sha256sum"
fi
if [ ! -e "${BREW_PREFIX}/bin/sha256sum" ]; then
  if [ -f "${BREW_PREFIX}/bin/gsha256sum" ]; then
    echo "Creating sha256sum symlink..."
    ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
  else
    echo "Warning: gsha256sum not found, skipping sha256sum symlink"
  fi
else
  echo "sha256sum already available"
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed"
fi

echo "Cleaning up Homebrew..."
brew cleanup
brew autoremove

# Ensure ~/.local/bin is on PATH (where mise installs itself)
export PATH="$HOME/.local/bin:$PATH"

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

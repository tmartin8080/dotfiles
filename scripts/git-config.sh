#!/usr/bin/env bash
# Configure git global settings

set -e

GIT_USER=tmartin8080
GIT_EMAIL=troy@devato.com

echo "Configuring git for user: $GIT_USER <$GIT_EMAIL>"

# Configure pull to use rebase
git config --global pull.rebase true

# Set up global gitignore
echo "Setting up global gitignore..."
echo .DS_Store >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Configure git user
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Custom configs for convenience
git config --global --add --bool push.autoSetupRemote true
git config --global init.defaultBranch main
git config --global --add url."git@github.com:".insteadOf "https://github.com/"

echo "Git configuration complete!"

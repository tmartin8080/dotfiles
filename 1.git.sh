#!/usr/bin/env bash

set -e

GIT_USER=tmartin8080
GIT_EMAIL=troy@devato.com

# Rebase
git config --global pull.rebase true

# Ignore all DS_Store files
echo .DS_Store >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Configure git user
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Custom configs
git config --global --add --bool push.autoSetupRemote true
git config --global init.defaultBranch main

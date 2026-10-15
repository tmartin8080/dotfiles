#!/usr/bin/env bash
# Configure git global settings
#
# This script is idempotent — safe to run multiple times.

set -e

GIT_USER=tmartin8080
GIT_EMAIL=troy@devato.com

echo "Configuring git for user: $GIT_USER <$GIT_EMAIL>"

# Configure pull to use rebase
git config --global pull.rebase true

# Set up global gitignore (idempotent — only add entries not already present)
GITIGNORE_GLOBAL="$HOME/.gitignore_global"
touch "$GITIGNORE_GLOBAL"
for pattern in .DS_Store .claude/; do
  if ! grep -qxF "$pattern" "$GITIGNORE_GLOBAL"; then
    echo "$pattern" >> "$GITIGNORE_GLOBAL"
    echo "  Added '$pattern' to global gitignore"
  fi
done
git config --global core.excludesfile "$GITIGNORE_GLOBAL"

# Configure git user
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Custom configs for convenience
git config --global --add --bool push.autoSetupRemote true
git config --global init.defaultBranch main
git config --global --add url."git@github.com:".insteadOf "https://github.com/"

echo "Git configuration complete!"

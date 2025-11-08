#!/usr/bin/env bash
# Copy dotfiles to home directory
# Usage: ./copy-files.sh [--force|-f]

set -e

cd "$(dirname "${BASH_SOURCE}")/.."

echo "Pulling latest changes from git..."
git pull origin main

function doIt() {
	echo "Copying dotfiles to home directory..."
	rsync --exclude ".git/" \
		--exclude ".gitignore" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "scripts/" \
		--exclude "README.md" \
		--exclude "Makefile" \
		--exclude "justfile" \
		--exclude "Brewfile" \
		--exclude "Brewfile.lock.json" \
		--exclude "wxwidgets.rb" \
		--exclude "iterm2" \
		--exclude "backups/" \
		--exclude "*.sh" \
		-avh --no-perms . ~

	echo "Dotfiles copied successfully!"
	echo "Restarting zsh..."
	exec zsh
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	else
		echo "Copy cancelled."
		exit 0
	fi
fi

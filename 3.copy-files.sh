#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".gitignore" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".tool-versions" \
		--exclude "0.init.sh" \
		--exclude "1.git.sh" \
		--exclude "2.asdf.sh" \
		--exclude "3.copy-files.sh" \
		--exclude "README.md" \
		--exclude "Makefile" \
		--exclude "Brewfile" \
		--exclude "iterm2" \
		-avh --no-perms . ~;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

exec zsh

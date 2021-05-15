#!/usr/bin/env bash

GIT_USER=troy.martin
GIT_EMAIL=troy@devato.com

# Ignore all DS_Store files
echo .DS_Store >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Configure git user
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

#!/usr/bin/env bash
# Copy dotfiles to home directory and configure shell/editor files
# Usage: ./scripts/copy-files.sh [--dry-run|-n] [--force|-f] [--no-backup] [--no-pull] [--no-reload]
#
# This script is idempotent — safe to run multiple times.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

DRY_RUN=false
FORCE=false
NO_BACKUP=false
NO_PULL=false
NO_RELOAD=false

for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      DRY_RUN=true
      ;;
    --force|-f)
      FORCE=true
      ;;
    --no-backup)
      NO_BACKUP=true
      ;;
    --no-pull)
      NO_PULL=true
      ;;
    --no-reload)
      NO_RELOAD=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--dry-run|-n] [--force|-f] [--no-backup] [--no-pull] [--no-reload]"
      exit 1
      ;;
  esac
done

RSYNC_EXCLUDES=(
  --exclude ".git/"
  --exclude ".gitignore"
  --exclude ".DS_Store"
  --exclude ".osx"
  --exclude "scripts/"
  --exclude "README.md"
  --exclude "Makefile"
  --exclude "justfile"
  --exclude "Brewfile"
  --exclude "Brewfile.lock.json"
  --exclude "mise.toml"
  --exclude "wxwidgets.rb"
  --exclude "iterm2"
  --exclude "backups/"
  --exclude ".claude/"
  --exclude "*.sh"
)

if [ "$DRY_RUN" = true ]; then
  echo "==> Dry run - files that would be copied to $HOME:"
  rsync "${RSYNC_EXCLUDES[@]}" -avnh --no-perms . "$HOME"
  echo ""
  echo "==> Additional config sync (dry run):"
  echo "  mise.toml -> $HOME/.config/mise/config.toml"
  exit 0
fi

if [ "$FORCE" = true ]; then
  echo "==> Copying dotfiles to home directory (forced)..."
else
  echo "==> Copying dotfiles to home directory..."
fi

# Pull latest changes only if on main branch with a clean working tree
if [ "$NO_PULL" = false ]; then
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
  if [ "$CURRENT_BRANCH" = "main" ] && git diff --quiet && git diff --cached --quiet; then
    echo "==> Pulling latest changes from origin/main..."
    git pull origin main || echo "Warning: git pull failed, continuing with local files..."
  else
    echo "==> Skipping git pull (on branch '$CURRENT_BRANCH' or working tree has local changes)"
  fi
fi

if [ "$FORCE" = false ] && [ -t 0 ]; then
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Copy cancelled."
    exit 0
  fi
fi

# Create backup of existing files that differ from repo versions
if [ "$NO_BACKUP" = false ]; then
  TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
  BACKUP_DIR="$REPO_DIR/backups/$TIMESTAMP"
  BACKUP_COUNT=0

  while IFS= read -r file; do
    file="${file#./}"
    if [ -n "$file" ] && [ -f "$REPO_DIR/$file" ] && [ -f "$HOME/$file" ]; then
      if ! cmp -s "$REPO_DIR/$file" "$HOME/$file"; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
      fi
    fi
  done < <(find . -type f \
    -not -path './.git/*' \
    -not -path './scripts/*' \
    -not -path './iterm2/*' \
    -not -path './backups/*' \
    -not -path './.claude/*' \
    -not -name '.gitignore' \
    -not -name '.DS_Store' \
    -not -name '.osx' \
    -not -name 'README.md' \
    -not -name 'Makefile' \
    -not -name 'justfile' \
    -not -name 'Brewfile' \
    -not -name 'Brewfile.lock.json' \
    -not -name 'mise.toml' \
    -not -name 'wxwidgets.rb' \
    -not -name '*.sh')

  if [ $BACKUP_COUNT -gt 0 ]; then
    echo "==> Backed up $BACKUP_COUNT modified file(s) to backups/$TIMESTAMP"
  else
    echo "==> No existing files modified (skipping backup)"
  fi
fi

# Copy dotfiles to home directory
rsync "${RSYNC_EXCLUDES[@]}" -avh --no-perms . "$HOME"

# Remove accidental ~/mise.toml if left over from previous runs
if [ -f "$HOME/mise.toml" ] && cmp -s "$REPO_DIR/mise.toml" "$HOME/mise.toml"; then
  rm -f "$HOME/mise.toml"
fi

# Sync mise.toml to ~/.config/mise/config.toml
mkdir -p "$HOME/.config/mise"
if [ ! -f "$HOME/.config/mise/config.toml" ] || ! cmp -s "$REPO_DIR/mise.toml" "$HOME/.config/mise/config.toml"; then
  cp "$REPO_DIR/mise.toml" "$HOME/.config/mise/config.toml"
  echo "==> Synced mise.toml to $HOME/.config/mise/config.toml"
fi
if command -v mise &>/dev/null; then
  mise trust "$REPO_DIR/mise.toml" 2>/dev/null || true
  mise trust "$HOME/.config/mise/config.toml" 2>/dev/null || true
fi

# Ensure z datafile exists and includes this repo
if [ -d "$HOME/.z" ]; then
  rm -rf "$HOME/.z"
fi
if [ ! -f "$HOME/.z" ]; then
  touch "$HOME/.z"
fi
if ! grep -qF "${REPO_DIR}|" "$HOME/.z" 2>/dev/null; then
  echo "${REPO_DIR}|1|$(date +%s)" >> "$HOME/.z"
fi

# Ensure Neovim plugins are installed if nvim is available
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)" 2>/dev/null || true
fi
if command -v nvim &>/dev/null && [ -f "$HOME/.config/nvim/init.vim" ]; then
  if ! nvim --headless -c 'for [name, spec] in items(get(g:, "plugs", {})) | if !isdirectory(spec.dir) | cquit 1 | endif | endfor' -c 'qall' 2>/dev/null; then
    echo "==> Installing Neovim plugins via vim-plug..."
    nvim --headless "+PlugInstall --sync" +qall
    nvim --headless +qall
    echo "==> Neovim plugins installed!"
  else
    echo "==> Neovim plugins already installed"
  fi
fi

echo ""
echo "Dotfiles copied successfully!"

if [ "$FORCE" = false ] && [ "$NO_RELOAD" = false ] && [ -t 0 ]; then
  echo "Restarting zsh..."
  exec zsh
fi

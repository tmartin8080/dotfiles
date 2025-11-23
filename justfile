# Dotfiles Management
# Run 'just' or 'just --list' to see available commands

# Default recipe shows help
default:
    @just --list

# Complete setup - runs all setup steps in order
setup: init git mise copy-files
    @echo "Setup complete! Restart your shell or run: exec zsh"

# Initialize system dependencies (Homebrew, tools, oh-my-zsh)
init:
    @echo "==> Installing system dependencies..."
    @./scripts/init.sh

# Configure git settings (user, email, global config)
git:
    @echo "==> Configuring git..."
    @./scripts/git-config.sh

# Install development tools via mise
mise:
    @echo "==> Installing mise tools..."
    @./scripts/mise-install.sh

# Copy dotfiles to home directory
# Usage: just copy-files [--dry-run] [--force] [--no-backup]
# --dry-run: Show what would be copied without making changes
# --force: Skip confirmation prompt
# --no-backup: Skip automatic backup before copying
copy-files dry_run="" force="" no_backup="":
    #!/usr/bin/env bash
    set -e

    BACKUP_DIR=""
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
        --exclude "wxwidgets.rb"
        --exclude "iterm2"
        --exclude "backups/"
        --exclude ".claude/"
        --exclude "*.sh"
    )

    DRY_RUN_FLAG=""
    if [ "{{dry_run}}" == "--dry-run" ]; then
        DRY_RUN_FLAG="n"
        echo "==> Dry run - files that would be copied:"
    elif [ "{{force}}" == "--force" ]; then
        echo "==> Copying dotfiles to home directory (forced)..."
    else
        echo "==> Copying dotfiles to home directory..."
    fi

    # Only pull and prompt if not dry-run
    if [ "{{dry_run}}" != "--dry-run" ]; then
        cd "$(dirname "${BASH_SOURCE}")/../.."
        git pull origin main

        if [ "{{force}}" != "--force" ]; then
            read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Copy cancelled."
                exit 0
            fi
        fi

        # Create backup before copying (unless --no-backup flag is set)
        if [ "{{no_backup}}" != "--no-backup" ]; then
            BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
            echo ""
            echo "==> Creating backup in $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"

            # Get list of files that will be copied (exist in both source and destination)
            BACKUP_COUNT=0
            while IFS= read -r file; do
                # Remove leading './' from file path
                file="${file#./}"
                # Skip directories (rsync output ends directories with /)
                if [[ "$file" != */ ]] && [ -f ~/"$file" ]; then
                    # Create parent directory structure in backup
                    mkdir -p "$BACKUP_DIR/$(dirname "$file")"
                    cp ~/"$file" "$BACKUP_DIR/$file"
                    BACKUP_COUNT=$((BACKUP_COUNT + 1))
                fi
            done < <(rsync "${RSYNC_EXCLUDES[@]}" -avn --no-perms . ~ | grep -E '^[^/]*/' | sed 's/^[^ ]* //')

            if [ $BACKUP_COUNT -eq 0 ]; then
                echo "No existing files to backup (fresh install)"
                rmdir "$BACKUP_DIR" 2>/dev/null || true
                BACKUP_DIR=""
            else
                echo "Backed up $BACKUP_COUNT file(s) to $BACKUP_DIR"
            fi
        fi
    fi

    # Execute rsync with conditional dry-run flag
    rsync "${RSYNC_EXCLUDES[@]}" -av${DRY_RUN_FLAG}h --no-perms . ~

    if [ "{{dry_run}}" != "--dry-run" ]; then
        echo ""
        echo "Dotfiles copied successfully!"

        # Clean up backup after successful copy (unless --no-backup flag is set)
        if [ "{{no_backup}}" != "--no-backup" ] && [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
            echo ""
            echo "==> Cleaning up backup..."
            rm -rf "$BACKUP_DIR"
            echo "Backup removed: $BACKUP_DIR"
            echo ""
            echo "Note: Backups are automatically cleaned up after successful copy."
            echo "      To keep backups, use: just copy-files --no-backup"
            echo "      Or use: just backup (to backup without copying)"
        fi

        if [ "{{force}}" != "--force" ]; then
            echo ""
            echo "Restarting zsh..."
            exec zsh
        fi
    fi

# Update Homebrew and all installed packages
brew-update:
    @echo "==> Updating Homebrew..."
    brew update
    brew upgrade
    brew cleanup
    brew autoremove

# Update mise and all installed tools
mise-update:
    @echo "==> Updating mise tools..."
    mise upgrade
    mise prune

# Update everything (Homebrew, mise tools, dotfiles repo)
update: brew-update mise-update
    @echo "==> Pulling latest dotfiles from git..."
    git pull origin main
    @echo "Update complete!"

# Show current tool versions from mise
versions:
    @echo "==> Current tool versions:"
    @mise list

# Verify mise configuration
mise-doctor:
    @echo "==> Checking mise configuration..."
    mise doctor

# Clean up Homebrew caches and old versions
clean:
    @echo "==> Cleaning up..."
    brew cleanup -s
    rm -rf $(brew --cache)

# Show system information
info:
    @echo "==> System Information"
    @echo "OS: $(uname -s) $(uname -r)"
    @echo "Architecture: $(uname -m)"
    @echo "Homebrew: $(brew --version | head -n1)"
    @echo "Mise: $(mise --version)"
    @echo "Shell: $SHELL"
    @echo ""
    @echo "==> Homebrew Prefix: $(brew --prefix)"
    @echo ""
    @echo "==> Tool Versions:"
    @mise list

# Backup current dotfiles from home directory
backup:
    @echo "==> Backing up current dotfiles..."
    @mkdir -p backups/$(date +%Y%m%d-%H%M%S)
    @for file in .zshrc .vimrc .gitconfig .gitignore_global; do \
        if [ -f ~/$file ]; then \
            cp ~/$file backups/$(date +%Y%m%d-%H%M%S)/$file; \
            echo "Backed up $file"; \
        fi; \
    done
    @echo "Backup complete in backups/$(date +%Y%m%d-%H%M%S)"

# Check for outdated Homebrew packages
brew-outdated:
    @echo "==> Checking for outdated Homebrew packages..."
    @brew outdated

# Reinstall all Homebrew packages from Brewfile
brew-reinstall:
    @echo "==> Reinstalling Homebrew packages from Brewfile..."
    HOMEBREW_BUNDLE_NO_LOCK=TRUE HOMEBREW_NO_INSTALL_CLEANUP=TRUE brew bundle --file="Brewfile"

# Trust the local mise configuration
mise-trust:
    @echo "==> Trusting mise configuration..."
    @mise trust

# Validate the environment setup
validate:
    @echo "==> Validating environment setup..."
    @echo "Checking required tools..."
    @command -v brew >/dev/null 2>&1 && echo "✓ Homebrew installed" || echo "✗ Homebrew missing"
    @command -v mise >/dev/null 2>&1 && echo "✓ mise installed" || echo "✗ mise missing"
    @command -v git >/dev/null 2>&1 && echo "✓ git installed" || echo "✗ git missing"
    @command -v zsh >/dev/null 2>&1 && echo "✓ zsh installed" || echo "✗ zsh missing"
    @echo ""
    @echo "Checking mise tools..."
    @mise list 2>/dev/null || echo "✗ mise tools not installed"

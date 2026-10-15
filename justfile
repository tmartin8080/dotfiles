# Dotfiles Management
# Run 'just' or 'just --list' to see available commands

export PATH := env_var_or_default("HOME", "") + "/.local/bin:/opt/homebrew/bin:/usr/local/bin:" + env_var_or_default("PATH", "")

# Default recipe shows help
default:
    @just --list

# Complete setup - runs all setup steps in order (non-interactive, idempotent)
setup: init git mise
    @./scripts/copy-files.sh --force --no-reload --no-pull
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
# Usage: just copy-files [--dry-run|-n] [--force|-f] [--no-backup] [--no-pull] [--no-reload]
copy-files *args:
    @./scripts/copy-files.sh {{args}}

# Install or update Neovim plugins via vim-plug
nvim:
    #!/usr/bin/env bash
    set -e
    if command -v mise &>/dev/null; then
        eval "$(mise activate bash)" 2>/dev/null || true
    fi
    if ! command -v nvim &>/dev/null; then
        echo "==> Installing neovim via mise..."
        mise install neovim
        eval "$(mise activate bash)"
    fi
    echo "==> Installing/updating Neovim plugins..."
    nvim --headless "+PlugInstall --sync" +qall
    nvim --headless +qall
    echo "==> Neovim plugins ready!"

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
    #!/usr/bin/env bash
    set -e
    BACKUP_DIR="backups/$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up current dotfiles to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    for file in .zshrc .fzf.zsh .fzf.bash .vimrc .gitconfig .gitignore_global .config/nvim/init.vim .config/efm-langserver/config.yaml .config/mise/config.toml; do
        if [ -f "$HOME/$file" ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            cp "$HOME/$file" "$BACKUP_DIR/$file"
            echo "  Backed up $file"
        fi
    done
    echo "Backup complete in $BACKUP_DIR"

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
    #!/usr/bin/env bash
    set -e
    echo "==> Validating environment setup..."
    echo "Checking required tools..."
    command -v brew >/dev/null 2>&1 && echo "✓ Homebrew installed" || echo "✗ Homebrew missing"
    command -v mise >/dev/null 2>&1 && echo "✓ mise installed" || echo "✗ mise missing"
    command -v git >/dev/null 2>&1 && echo "✓ git installed" || echo "✗ git missing"
    command -v zsh >/dev/null 2>&1 && echo "✓ zsh installed" || echo "✗ zsh missing"
    if command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/etc/profile.d/z.sh" ]; then
        echo "✓ z installed ($(brew --prefix)/etc/profile.d/z.sh)"
    else
        echo "✗ z missing"
    fi
    if command -v mise >/dev/null 2>&1; then
        eval "$(mise activate bash)" 2>/dev/null || true
    fi
    if command -v nvim >/dev/null 2>&1; then
        echo "✓ neovim installed ($(nvim --version | head -n1))"
    else
        echo "✗ neovim missing"
    fi
    echo ""
    echo "Checking dotfiles in $HOME..."
    for f in .zshrc .fzf.zsh .fzf.bash .config/nvim/init.vim .config/efm-langserver/config.yaml .config/mise/config.toml; do
        if [ -f "$HOME/$f" ]; then
            echo "✓ ~/$f present"
        else
            echo "✗ ~/$f missing"
        fi
    done
    echo ""
    echo "Checking mise tools..."
    mise list 2>/dev/null || echo "✗ mise tools not installed"

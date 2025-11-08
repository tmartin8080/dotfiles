# Dotfiles

Personal dotfiles configuration for macOS development environment.

## Quick Setup

Complete setup with one command:
```bash
just setup
```

Or run individual steps:
```bash
just init          # Install Homebrew, system packages, oh-my-zsh
just git           # Configure git settings
just mise          # Install development tools via mise
just copy-files    # Copy dotfiles to home directory
```

## Available Commands

Run `just` or `just --list` to see all available commands:

- `just setup` - Complete setup (runs all steps)
- `just init` - Initialize system dependencies
- `just git` - Configure git settings
- `just mise` - Install mise tools
- `just copy-files` - Copy dotfiles (with confirmation)
- `just copy-files-force` - Copy dotfiles (no confirmation)
- `just update` - Update everything (Homebrew, mise, git repo)
- `just brew-update` - Update Homebrew and packages
- `just mise-update` - Update mise and tools
- `just versions` - Show current tool versions
- `just validate` - Validate environment setup
- `just info` - Show system information
- `just backup` - Backup current dotfiles
- `just copy-files-dry-run` - Preview what would be copied
- `just clean` - Clean up Homebrew caches

## Tool Versions

See `mise.toml` for current tool versions. Key tools:
- Python 3.13.9
- Go 1.25.4
- Erlang 28.1.1
- Elixir 1.19.2-otp-28
- Node 25.1.0
- Neovim 0.11.5
- Helm 3.19.0
- Terraform 1.13.5
- kubectl 1.34.1
- PostgreSQL 18.0

## Mac Apps

Recommended apps (install manually):
- [Iterm2](https://iterm2.com/)
- [Alfred](https://www.alfredapp.com/)
- [Magnet](https://apps.apple.com/ca/app/magnet/id441258766?mt=12)
- [DevSwatch](https://apps.apple.com/ca/app/devswatch/id1477857867?mt=12)

## iTerm2 Configuration

1. Load profile from `iterm2/devato.json`
2. Preferences -> Appearance -> General -> Theme -> Minimal
3. Preferences -> Appearance -> Dimming -> Disable Dim Background Windows
4. BG Color: 2B2D36

## Neovim Language Servers

From within nvim:
```
:LspInstall bash
:LspInstall elixir
:LspInstall efm
```

## Load Testing with WRK

```bash
brew install wrk
wrk -t4 -c100 -d30S --timeout 2000 "http://127.0.0.1:4000"
```

## Syntax Highlighting

Using nvim-treesitter for syntax highlighting.

## Migration from Make

This project now uses `just` instead of Make for task automation. The old Makefile and numbered bash scripts (0.init.sh, 1.git.sh, etc.) have been migrated to the justfile and moved to the scripts/ directory.

Benefits:
- Better help text and documentation
- More powerful recipe dependencies
- Cleaner syntax and error handling
- Additional utility commands (update, validate, backup, etc.)

## Notes

- Configuration uses mise for version management (migrated from asdf)
- Brewfile defines system packages
- Scripts are idempotent where possible
- Backup your existing dotfiles before running setup

## wxwidgets Brew Issue

Legacy workaround for Erlang compatibility (preserved for older systems):
- https://github.com/asdf-vm/asdf-erlang/issues/248
- https://github.com/erlang/otp/issues/5893

```bash
brew install wxwidgets
brew unlink wxwidgets
brew tap laggardkernel/tap
wget https://raw.githubusercontent.com/Homebrew/homebrew-core/7d7daebdadd1b7badf56bd87bce75f38e51c5795/Formula/wxwidgets.rb
brew install ./wxwidgets.rb
brew switch wxwidgets 3.1.5
brew pin wxwidgets
```

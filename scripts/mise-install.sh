#!/usr/bin/env bash
# Install development tools via mise

set -e

# Remove asdf if it exists
echo "Checking for asdf installation..."
if [ -d "$HOME/.asdf" ] || command -v asdf &>/dev/null; then
  echo "==> Removing asdf and all traces..."

  # Remove asdf directory
  if [ -d "$HOME/.asdf" ]; then
    echo "  • Removing asdf directory: ~/.asdf"
    # Change permissions to ensure all files can be deleted
    chmod -R u+w "$HOME/.asdf" 2>/dev/null || true
    rm -rf "$HOME/.asdf"
  fi

  # Remove asdf from shell configuration files
  for config_file in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile" "$HOME/.bash_profile"; do
    if [ -f "$config_file" ]; then
      # Check if file contains asdf references
      if grep -q "asdf" "$config_file"; then
        echo "  • Cleaning asdf references from: $config_file"
        # Create backup
        cp "$config_file" "${config_file}.asdf-backup"
        # Remove asdf source lines
        sed -i.bak '/asdf\.sh/d; /asdf\.bash/d; /asdf\.fish/d; /ASDF_/d' "$config_file"
        rm "${config_file}.bak"
      fi
    fi
  done

  # Remove asdf data directory
  if [ -d "$HOME/.asdf-data" ]; then
    echo "  • Removing asdf data directory: ~/.asdf-data"
    rm -rf "$HOME/.asdf-data"
  fi

  # Remove asdf config file
  if [ -f "$HOME/.asdfrc" ]; then
    echo "  • Removing asdf config: ~/.asdfrc"
    rm -f "$HOME/.asdfrc"
  fi

  echo "✓ asdf removal complete!"
  echo ""
else
  echo "✓ No asdf installation found"
  echo ""
fi

# Ensure mise is available
if ! command -v mise &>/dev/null; then
  echo "Error: mise is not installed. Run 'just init' first."
  exit 1
fi

echo "Activating mise..."
eval "$(mise activate bash)"

echo "Installing all tools from mise.toml..."
mise install

echo "Trusting the local mise.toml configuration..."
mise trust

echo "Mise tools installation complete!"
echo "Run 'mise list' to see installed versions"

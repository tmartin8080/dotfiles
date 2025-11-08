#!/usr/bin/env bash
# Install development tools via mise

set -e

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

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> mac-setup start"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Homebrew is not always added to PATH in the current shell immediately.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "==> Homebrew already installed"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: Homebrew was installed but 'brew' is not available in PATH."
  exit 1
fi

echo "==> Updating Homebrew..."
brew update

echo "==> Installing packages and applications from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# Official WireGuard GUI app.
# App Store authentication is required, so failure here should not abort
# the rest of the machine setup.
WIREGUARD_APP_ID="1451685025"

if command -v mas >/dev/null 2>&1; then
  if mas list 2>/dev/null | awk '{print $1}' | grep -qx "$WIREGUARD_APP_ID"; then
    echo "==> WireGuard app already installed"
  else
    echo "==> Installing official WireGuard app from the Mac App Store..."
    if ! mas install "$WIREGUARD_APP_ID"; then
      echo "WARNING: WireGuard GUI app could not be installed automatically."
      echo "         Sign in to the Mac App Store and install 'WireGuard' manually."
      echo "         WireGuard CLI tools (wg / wg-quick) are already installed."
    fi
  fi
fi

echo
echo "==> Checking Brewfile state..."
if brew bundle check --file="$SCRIPT_DIR/Brewfile"; then
  echo "==> Homebrew setup complete"
else
  echo "WARNING: Some Brewfile items are still missing."
fi

echo
echo "Next manual steps:"
echo "  1. Sign in to Slack"
echo "  2. Sign in to GitHub: gh auth login"
echo "  3. Configure Git name/email if needed"
echo "  4. Import the WireGuard tunnel configuration"
echo "  5. Open OrbStack once to finish its initial setup"

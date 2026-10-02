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

# -------------------------
# Dock
# -------------------------
# Keep the Dock minimal for the AI hands-on session:
# Finder -> Apps -> Safari -> Slack -> Notion -> Zoom
# -> Visual Studio Code -> ChatGPT -> Claude
#
# Finder and Trash are special Dock items managed by macOS, so dockutil does
# not need to add them explicitly.

if command -v dockutil >/dev/null 2>&1; then
  echo "==> Configuring Dock..."

  # Hide dynamically suggested/recent apps so the Dock stays predictable.
  defaults write com.apple.dock show-recents -bool false

  # Remove ordinary pinned apps/folders. Finder and Trash remain.
  dockutil --remove all --no-restart || true

  add_dock_app() {
    local app_path="$1"
    local app_name="$2"

    if [[ -d "$app_path" ]]; then
      dockutil --add "$app_path" --section apps --position end --no-restart
      echo "    Added: $app_name"
      return 0
    fi

    echo "WARNING: Dock item not found: $app_name ($app_path)"
    return 0
  }

  # macOS 26 Tahoe uses Apps.app. On older macOS versions, fall back to Launchpad.
  if [[ -d "/System/Applications/Apps.app" ]]; then
    add_dock_app "/System/Applications/Apps.app" "Apps"
  elif [[ -d "/System/Applications/Launchpad.app" ]]; then
    add_dock_app "/System/Applications/Launchpad.app" "Launchpad"
  elif [[ -d "/Applications/Launchpad.app" ]]; then
    add_dock_app "/Applications/Launchpad.app" "Launchpad"
  else
    echo "WARNING: Apps/Launchpad launcher was not found."
  fi

  # Safari is stored in different locations depending on macOS version.
  if [[ -d "/Applications/Safari.app" ]]; then
    add_dock_app "/Applications/Safari.app" "Safari"
  elif [[ -d "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app" ]]; then
    add_dock_app "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app" "Safari"
  else
    echo "WARNING: Safari was not found."
  fi

  add_dock_app "/Applications/Slack.app" "Slack"
  add_dock_app "/Applications/Notion.app" "Notion"
  add_dock_app "/Applications/zoom.us.app" "Zoom"
  add_dock_app "/Applications/Visual Studio Code.app" "Visual Studio Code"
  add_dock_app "/Applications/ChatGPT.app" "ChatGPT"
  add_dock_app "/Applications/Claude.app" "Claude"

  killall Dock 2>/dev/null || true
  echo "==> Dock configured"
else
  echo "WARNING: dockutil is not available; Dock setup skipped."
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
echo "  2. Sign in to Notion"
echo "  3. Sign in to Zoom"
echo "  4. Sign in to ChatGPT / Claude as needed"
echo "  5. Sign in to GitHub: gh auth login"
echo "  6. Configure Git name/email if needed"
echo "  7. Import the WireGuard tunnel configuration"
echo "  8. Open OrbStack once to finish its initial setup"

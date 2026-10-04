#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> mac-setup start"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

echo "==> Installing/updating packages and applications from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# -------------------------
# Dock
# -------------------------
# dockutil is intentionally temporary:
# install -> configure Dock -> uninstall.

DOCKUTIL_WAS_PRESENT=false

if command -v dockutil >/dev/null 2>&1; then
  DOCKUTIL_WAS_PRESENT=true
else
  echo "==> Installing dockutil temporarily..."
  brew install dockutil
fi

if command -v dockutil >/dev/null 2>&1; then
  echo "==> Configuring Dock..."

  # Keep the Dock predictable for the AI hands-on session.
  defaults write com.apple.dock show-recents -bool false

  # Remove ordinary pinned apps/folders. Finder and Trash remain.
  dockutil --remove all --no-restart || true

  add_dock_app() {
    local app_path="$1"
    local app_name="$2"

    if [[ -d "$app_path" ]]; then
      dockutil --add "$app_path" --section apps --position end --no-restart
      echo "    Added: $app_name"
    else
      echo "WARNING: Dock item not found: $app_name ($app_path)"
    fi
  }

  # macOS 26 Tahoe uses Apps.app. Older versions may still have Launchpad.
  if [[ -d "/System/Applications/Apps.app" ]]; then
    add_dock_app "/System/Applications/Apps.app" "Apps"
  elif [[ -d "/System/Applications/Launchpad.app" ]]; then
    add_dock_app "/System/Applications/Launchpad.app" "Launchpad"
  elif [[ -d "/Applications/Launchpad.app" ]]; then
    add_dock_app "/Applications/Launchpad.app" "Launchpad"
  else
    echo "WARNING: Apps/Launchpad launcher was not found."
  fi

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

# Remove dockutil only when this script installed it.
# If the user already had dockutil beforehand, leave it alone.
if [[ "$DOCKUTIL_WAS_PRESENT" == false ]] && brew list --formula dockutil >/dev/null 2>&1; then
  echo "==> Removing temporary dockutil..."
  brew uninstall dockutil
fi

echo
echo "==> Checking Brewfile state..."
if brew bundle check --file="$SCRIPT_DIR/Brewfile"; then
  echo "==> Homebrew setup complete"
else
  echo "WARNING: Some Brewfile items are still missing."
fi

# Copy local Desktop contents, including hidden files and nested folders.
mkdir -p "$SCRIPT_DIR/toDesktop"
(
  shopt -s nullglob dotglob
  desktop_items=("$SCRIPT_DIR/toDesktop/"*)

  if (( ${#desktop_items[@]} > 0 )); then
    echo "==> Copying toDesktop contents to Desktop..."
    mkdir -p "$HOME/Desktop"
    cp -Rp "$SCRIPT_DIR/toDesktop/." "$HOME/Desktop/"
  else
    echo "==> toDesktop is empty; Desktop copy skipped"
  fi
)

echo
echo "Next manual steps:"
echo "  1. Sign in to Slack"
echo "  2. Sign in to Notion"
echo "  3. Sign in to Zoom"
echo "  4. Sign in to ChatGPT / Claude as needed"
echo "  5. Sign in to GitHub: gh auth login"
echo "  6. Configure Git name/email if needed"
echo "  7. Open OrbStack once to finish its initial setup"

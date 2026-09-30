#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Brewfile ==="
if command -v brew >/dev/null 2>&1; then
  brew bundle check --file="$SCRIPT_DIR/Brewfile" || true
else
  echo "brew: NOT INSTALLED"
fi

echo
echo "=== CLI versions ==="

check_cmd() {
  local name="$1"
  shift
  if command -v "$name" >/dev/null 2>&1; then
    printf "%-14s " "$name"
    "$@" 2>/dev/null | head -n 1 || true
  else
    printf "%-14s %s\n" "$name" "MISSING"
  fi
}

check_cmd git git --version
check_cmd gh gh --version
check_cmd python3 python3 --version
check_cmd node node --version
check_cmd uv uv --version
check_cmd opencode opencode --version
check_cmd wg wg --version
check_cmd jq jq --version
check_cmd rg rg --version
check_cmd fzf fzf --version
check_cmd nmap nmap --version

echo
echo "=== Applications ==="

for app in \
  "/Applications/Visual Studio Code.app" \
  "/Applications/Slack.app" \
  "/Applications/OrbStack.app" \
  "/Applications/WireGuard.app"
do
  if [[ -d "$app" ]]; then
    echo "OK      $(basename "$app")"
  else
    echo "MISSING $(basename "$app")"
  fi
done

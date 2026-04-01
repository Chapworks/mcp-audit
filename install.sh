#!/usr/bin/env bash
set -euo pipefail

# tool-audit installer
# Installs audit-tools and wrong-tool skills for Claude Code

REPO="https://raw.githubusercontent.com/Chapworks/tool-audit/main"
SKILLS=("audit-tools.md" "wrong-tool.md")

# Determine install location
if [[ "${1:-}" == "--project" ]]; then
  DEST=".claude/commands"
  echo "Installing to project: $(pwd)/$DEST"
else
  DEST="$HOME/.claude/commands"
  echo "Installing globally: $DEST"
fi

mkdir -p "$DEST"

# If running from a cloned repo, copy local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/audit-tools.md" && -f "$SCRIPT_DIR/wrong-tool.md" ]]; then
  for skill in "${SKILLS[@]}"; do
    cp "$SCRIPT_DIR/$skill" "$DEST/$skill"
    echo "  ✓ $skill"
  done
else
  # Download from GitHub
  for skill in "${SKILLS[@]}"; do
    curl -fsSL "$REPO/$skill" -o "$DEST/$skill"
    echo "  ✓ $skill"
  done
fi

echo ""
echo "Installed. Restart Claude Code, then run:"
echo "  /audit-tools          — scan for tool conflicts"
echo "  /wrong-tool           — fix a misrouted tool call"

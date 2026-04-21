#!/usr/bin/env bash
# Captain's Log — local installer
# Run this after cloning the repo: ./install-local.sh
# Installs to all detected Claude environments.
set -e

SKILL_NAME="captains-log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SKILL="$SCRIPT_DIR/skills/captains-log/SKILL.md"

echo ""
echo "Captain's Log — local installer"
echo "────────────────────────────────"

# ── 1. Check local skill file exists ─────────────────────────────────────────

if [ ! -f "$LOCAL_SKILL" ]; then
  echo "Error: skill file not found at $LOCAL_SKILL"
  echo "Make sure you're running this from the captains-log-repo directory."
  exit 1
fi

CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_CODE="$HOME/.claude/skills"

INSTALLED=0

# ── Install function ──────────────────────────────────────────────────────────

install_to() {
  local SKILLS_DIR="$1"
  local DEST="$SKILLS_DIR/$SKILL_NAME"
  mkdir -p "$DEST"
  if [ -f "$DEST/SKILL.md" ]; then
    echo "  → Updating existing install..."
    rm -rf "$DEST"
    mkdir -p "$DEST"
  fi
  cp "$LOCAL_SKILL" "$DEST/SKILL.md"
  echo "  ✓ Installed to: $DEST"
  INSTALLED=1
}

# ── Claude Code ───────────────────────────────────────────────────────────────

if [ -d "$CLAUDE_CODE" ]; then
  echo "→ Claude Code detected."
  install_to "$CLAUDE_CODE"
fi

# ── Claude Desktop ────────────────────────────────────────────────────────────

if [ -d "$CLAUDE_DESKTOP" ]; then
  DESKTOP_SKILLS=$(find "$CLAUDE_DESKTOP" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  [ -z "$DESKTOP_SKILLS" ] && DESKTOP_SKILLS="$CLAUDE_DESKTOP/skills"
  echo "→ Claude Desktop detected."
  install_to "$DESKTOP_SKILLS"
fi

# ── Neither found — create Claude Code default ────────────────────────────────

if [ "$INSTALLED" -eq 0 ]; then
  echo "→ No Claude installation found. Creating Claude Code skills directory..."
  install_to "$CLAUDE_CODE"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

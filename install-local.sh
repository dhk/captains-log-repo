#!/usr/bin/env bash
# Captain's Log — local installer
# Run this after cloning the repo: ./install-local.sh
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

# ── 2. Locate or create the Claude skills directory ──────────────────────────

CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_CODE" ]; then
  SKILLS_DIR="$CLAUDE_CODE"
  echo "→ Claude Code detected."
elif [ -d "$CLAUDE_DESKTOP" ]; then
  SKILLS_DIR=$(find "$CLAUDE_DESKTOP" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  [ -z "$SKILLS_DIR" ] && SKILLS_DIR="$CLAUDE_DESKTOP/skills"
  echo "→ Claude Desktop detected."
else
  SKILLS_DIR="$CLAUDE_CODE"
  echo "→ No Claude installation found. Creating Claude Code skills directory..."
fi

mkdir -p "$SKILLS_DIR"

# ── 3. Install ────────────────────────────────────────────────────────────────

DEST="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "→ Existing install found. Updating..."
  rm -rf "$DEST"
fi

mkdir -p "$DEST"
cp "$LOCAL_SKILL" "$DEST/SKILL.md"

# ── 4. Done ───────────────────────────────────────────────────────────────────

echo ""
echo "✓ Captain's Log installed to:"
echo "  $DEST"
echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

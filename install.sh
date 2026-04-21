#!/usr/bin/env bash
# Captain's Log — remote installer
# Designed to be run via: curl -fsSL https://raw.githubusercontent.com/dhk/captains-log-repo/main/install.sh | bash
# Safe to run on a fresh machine. Creates any missing directories.
set -e

SKILL_NAME="captains-log"
REPO_RAW="https://raw.githubusercontent.com/dhk/captains-log-repo/main"

echo ""
echo "Captain's Log — installer"
echo "─────────────────────────"

# ── 1. Locate or create the Claude skills directory ──────────────────────────

CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_CODE" ]; then
  SKILLS_DIR="$CLAUDE_CODE"
  echo "→ Claude Code detected."
elif [ -d "$CLAUDE_DESKTOP" ]; then
  # Claude Desktop present — find the nested skills/ folder
  SKILLS_DIR=$(find "$CLAUDE_DESKTOP" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  if [ -z "$SKILLS_DIR" ]; then
    # Plugin dir exists but skills/ not yet created — create it at expected depth
    SKILLS_DIR="$CLAUDE_DESKTOP/skills"
    echo "→ Claude Desktop detected. Creating skills directory..."
  else
    echo "→ Claude Desktop detected."
  fi
else
  # Nothing found — default to Claude Code location and create it
  SKILLS_DIR="$CLAUDE_CODE"
  echo "→ No Claude installation found. Creating Claude Code skills directory..."
fi

mkdir -p "$SKILLS_DIR"

# ── 2. Install the skill ──────────────────────────────────────────────────────

DEST="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "→ Existing install found. Updating..."
  rm -rf "$DEST"
fi

mkdir -p "$DEST"

echo "→ Fetching skill from GitHub..."
curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$DEST/SKILL.md"

# ── 3. Done ───────────────────────────────────────────────────────────────────

echo ""
echo "✓ Captain's Log installed to:"
echo "  $DEST"
echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

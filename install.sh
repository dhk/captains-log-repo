#!/usr/bin/env bash
set -e

SKILL_NAME="captains-log"
REPO_RAW="https://raw.githubusercontent.com/dhk/captains-log-repo/main"

# Locate Claude skills directory
CLAUDE_SKILLS_MAC="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_SKILLS_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_SKILLS_MAC" ]; then
  SKILLS_DIR=$(find "$CLAUDE_SKILLS_MAC" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  if [ -z "$SKILLS_DIR" ]; then
    echo "Found Claude Desktop directory but couldn't locate skills/ subfolder."
    echo "Manual install: copy skills/captains-log/ into your Claude skills directory."
    exit 1
  fi
elif [ -d "$CLAUDE_SKILLS_CODE" ]; then
  SKILLS_DIR="$CLAUDE_SKILLS_CODE"
else
  echo "Could not locate Claude skills directory automatically."
  echo "Please enter your Claude skills directory path:"
  read -r SKILLS_DIR < /dev/tty
  if [ ! -d "$SKILLS_DIR" ]; then
    echo "Directory not found: $SKILLS_DIR"
    exit 1
  fi
fi

DEST="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "Existing installation found at: $DEST"
  echo "Overwrite? (y/n)"
  read -r CONFIRM < /dev/tty
  if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 0
  fi
  rm -rf "$DEST"
fi

mkdir -p "$DEST"

# Use local copy if running from the repo, otherwise fetch from GitHub
# BASH_SOURCE[0] is empty when piped via curl | bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
LOCAL_SKILL="$SCRIPT_DIR/skills/captains-log/SKILL.md"

if [ -n "$SCRIPT_DIR" ] && [ -f "$LOCAL_SKILL" ]; then
  cp "$LOCAL_SKILL" "$DEST/SKILL.md"
else
  curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$DEST/SKILL.md"
fi

echo ""
echo "✓ Captain's Log installed to:"
echo "  $DEST"
echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo ""
echo "First use: say 'take a note' or 'captains log demo' to get started."

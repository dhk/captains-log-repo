#!/usr/bin/env bash
# Captain's Log — install script
# Copies the skill into the Claude skills directory

set -e

SKILL_NAME="captains-log"
SKILL_SRC="$(cd "$(dirname "$0")/skills/captains-log" && pwd)"

# --- Locate the Claude skills directory ---

# Claude Desktop (macOS)
CLAUDE_SKILLS_MAC="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"

# Claude Code (looks for skills/ in common locations)
CLAUDE_SKILLS_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_SKILLS_MAC" ]; then
  # Find the skills/ subdirectory — it may be nested under a hash directory
  SKILLS_DIR=$(find "$CLAUDE_SKILLS_MAC" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  if [ -z "$SKILLS_DIR" ]; then
    echo "Found Claude Desktop directory but couldn't locate skills/ subfolder."
    echo "Expected path: $CLAUDE_SKILLS_MAC/.../skills/"
    echo ""
    echo "Manual install: copy skills/captains-log/ into your Claude skills directory."
    exit 1
  fi
elif [ -d "$CLAUDE_SKILLS_CODE" ]; then
  SKILLS_DIR="$CLAUDE_SKILLS_CODE"
else
  echo "Could not locate Claude skills directory automatically."
  echo ""
  echo "Please enter your Claude skills directory path:"
  read -r SKILLS_DIR
  if [ ! -d "$SKILLS_DIR" ]; then
    echo "Directory not found: $SKILLS_DIR"
    exit 1
  fi
fi

# --- Install ---

DEST="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "Existing installation found at: $DEST"
  echo "Overwrite? (y/n)"
  read -r CONFIRM
  if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 0
  fi
  rm -rf "$DEST"
fi

cp -r "$SKILL_SRC" "$DEST"

echo ""
echo "✓ Captain's Log installed to:"
echo "  $DEST"
echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo ""
echo "First use: just say 'take a note' or 'captains log demo' to get started."

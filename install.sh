#!/usr/bin/env bash
set -e

SKILL_NAME="captains-log"
REPO_RAW="https://raw.githubusercontent.com/dhk/captains-log-repo/main"

# Locate Claude skills directory
CLAUDE_SKILLS_MAC="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_SKILLS_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_SKILLS_MAC" ]; then
  SKILLS_DIR=$(find "$CLAUDE_SKILLS_MAC" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  [ -z "$SKILLS_DIR" ] && SKILLS_DIR="$CLAUDE_SKILLS_MAC/skills"
elif [ -d "$CLAUDE_SKILLS_CODE" ]; then
  SKILLS_DIR="$CLAUDE_SKILLS_CODE"
else
  # Neither exists — create the Claude Code default under $HOME
  SKILLS_DIR="$CLAUDE_SKILLS_CODE"
fi

mkdir -p "$SKILLS_DIR"

DEST="$SKILLS_DIR/$SKILL_NAME"
mkdir -p "$DEST"

# Use local copy if running from the repo, otherwise fetch from GitHub
# ${BASH_SOURCE[0]} is empty when piped via curl | bash, so we guard
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
LOCAL_SKILL="$SCRIPT_DIR/skills/captains-log/SKILL.md"

if [ -n "$SCRIPT_DIR" ] && [ -f "$LOCAL_SKILL" ]; then
  cp "$LOCAL_SKILL" "$DEST/SKILL.md"
else
  curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$DEST/SKILL.md"
fi

echo "✓ Captain's Log installed to: $DEST"
echo "Restart Claude Desktop or reload Claude Code to activate."

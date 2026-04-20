#!/usr/bin/env bash
# Captain's Log — uninstaller
set -e

SKILL_NAME="captains-log"

echo ""
echo "Captain's Log — uninstaller"
echo "───────────────────────────"

CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_CODE="$HOME/.claude/skills"

REMOVED=0

# Check Claude Code
if [ -d "$CLAUDE_CODE/$SKILL_NAME" ]; then
  rm -rf "$CLAUDE_CODE/$SKILL_NAME"
  echo "✓ Removed from Claude Code: $CLAUDE_CODE/$SKILL_NAME"
  REMOVED=1
fi

# Check Claude Desktop
if [ -d "$CLAUDE_DESKTOP" ]; then
  SKILLS_DIR=$(find "$CLAUDE_DESKTOP" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  if [ -n "$SKILLS_DIR" ] && [ -d "$SKILLS_DIR/$SKILL_NAME" ]; then
    rm -rf "$SKILLS_DIR/$SKILL_NAME"
    echo "✓ Removed from Claude Desktop: $SKILLS_DIR/$SKILL_NAME"
    REMOVED=1
  fi
fi

if [ "$REMOVED" -eq 0 ]; then
  echo "Nothing to remove — Captain's Log was not found in any Claude skills directory."
  exit 0
fi

echo ""
echo "Restart Claude Desktop or reload Claude Code to complete removal."
echo ""
echo "Note: your log files are not deleted. They live at your configured"
echo "log location (e.g. ~/Documents/captains-log/) and are yours to keep."
echo ""

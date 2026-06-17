#!/usr/bin/env bash
# Captain's Log — uninstaller
set -e

SKILL_NAME="captains-log"

echo ""
echo "Captain's Log — uninstaller"
echo "───────────────────────────"

CLAUDE_CODE="$HOME/.claude/skills"

if [ -d "$CLAUDE_CODE/$SKILL_NAME" ]; then
  rm -rf "$CLAUDE_CODE/$SKILL_NAME"
  echo "✓ Removed from Claude Code: $CLAUDE_CODE/$SKILL_NAME"
else
  echo "Nothing to remove — Captain's Log was not found in ~/.claude/skills/."
fi

echo ""
echo "Reload Claude Code to complete removal."
echo ""
echo "Note: your log files are not deleted. They live at your configured"
echo "log location (e.g. ~/Documents/captains-log/) and are yours to keep."
echo ""
echo "Claude Desktop users: remove the skill via Customize → Skills in the app."
echo ""

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

# ── 2. Install to Claude Code ─────────────────────────────────────────────────

DEST="$HOME/.claude/skills/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "→ Existing Claude Code install found. Updating..."
  rm -rf "$DEST"
fi

mkdir -p "$DEST"
cp "$LOCAL_SKILL" "$DEST/SKILL.md"
echo "✓ Installed to: $DEST"

# Update ~/.claude/CLAUDE.md so the skill loads across all projects
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SKILL_ENTRY="- captains-log (~/.claude/skills/captains-log/) — passive session note-taker. Captures state changes, decisions, and insights. Triggers on commits, \"log this\", \"take a note\", session end, and significant state changes."

if [ ! -f "$CLAUDE_MD" ]; then
  mkdir -p "$(dirname "$CLAUDE_MD")"
  cat > "$CLAUDE_MD" <<'EOF'
# Claude Code Global Config

## Skills
The following skills are available and should be consulted when relevant:
- captains-log (~/.claude/skills/captains-log/) — passive session note-taker. Captures state changes, decisions, and insights. Triggers on commits, "log this", "take a note", session end, and significant state changes.
EOF
  echo "✓ Created ~/.claude/CLAUDE.md with skill entry."
elif ! grep -q "captains-log" "$CLAUDE_MD"; then
  printf '\n## Skills\nThe following skills are available and should be consulted when relevant:\n%s\n' "$SKILL_ENTRY" >> "$CLAUDE_MD"
  echo "✓ Added captains-log entry to ~/.claude/CLAUDE.md."
else
  echo "→ ~/.claude/CLAUDE.md already references captains-log. Skipping."
fi

# ── 3. Claude Desktop ─────────────────────────────────────────────────────────

echo ""
echo "Claude Desktop users:"
echo "  Skills must be uploaded via the UI — there is no filesystem install path."
echo "  1. Use the captains-log.skill file in this repo, or download from:"
echo "     https://github.com/dhk/captains-log-repo/releases/latest"
echo "  2. In Claude Desktop: Customize → Skills → Upload Skill"
echo ""

# ── 4. Done ───────────────────────────────────────────────────────────────────

echo "Restart Claude Code or reload your project to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

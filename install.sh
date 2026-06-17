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

# ── 1. Install to Claude Code ─────────────────────────────────────────────────

DEST="$HOME/.claude/skills/$SKILL_NAME"

if [ -d "$DEST" ]; then
  echo "→ Existing Claude Code install found. Updating..."
  rm -rf "$DEST"
fi

mkdir -p "$DEST"
echo "→ Fetching skill from GitHub..."
curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$DEST/SKILL.md"
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

# ── 2. Claude Desktop ─────────────────────────────────────────────────────────

echo ""
echo "Claude Desktop users:"
echo "  Skills must be uploaded via the UI — there is no filesystem install path."
echo "  1. Download captains-log.skill from:"
echo "     https://github.com/dhk/captains-log-repo/releases/latest"
echo "  2. In Claude Desktop: Customize → Skills → Upload Skill"
echo ""

# ── 3. Done ───────────────────────────────────────────────────────────────────

echo "Restart Claude Code or reload your project to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

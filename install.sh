#!/usr/bin/env bash
# Captain's Log — remote installer
# Designed to be run via: curl -fsSL https://raw.githubusercontent.com/dhk/captains-log-repo/main/install.sh | bash
# Safe to run on a fresh machine. Installs to all detected Claude environments.
set -e

SKILL_NAME="captains-log"
REPO_RAW="https://raw.githubusercontent.com/dhk/captains-log-repo/main"

echo ""
echo "Captain's Log — installer"
echo "─────────────────────────"

CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
CLAUDE_CODE="$HOME/.claude/skills"

INSTALLED=0

# ── Install function ──────────────────────────────────────────────────────────

install_to() {
  local SKILLS_DIR="$1"
  local DEST="$SKILLS_DIR/$SKILL_NAME"
  mkdir -p "$DEST"
  if [ -d "$DEST" ] && [ -f "$DEST/SKILL.md" ]; then
    echo "  → Updating existing install..."
    rm -rf "$DEST"
    mkdir -p "$DEST"
  fi
  curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$DEST/SKILL.md"
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

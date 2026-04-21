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

install_skill() {
  local skills_dir="$1"
  local dest="$skills_dir/$SKILL_NAME"

  if [ -d "$dest" ]; then
    echo "→ Existing install found. Updating..."
    rm -rf "$dest"
  fi

  mkdir -p "$dest"

  echo "→ Fetching skill from GitHub..."
  curl -fsSL "$REPO_RAW/skills/captains-log/SKILL.md" -o "$dest/SKILL.md"

  echo "✓ Installed to: $dest"
}

INSTALLED=0

if [ -d "$CLAUDE_CODE" ]; then
  echo "→ Claude Code detected."
  install_skill "$CLAUDE_CODE"
  INSTALLED=1
fi

if [ -d "$CLAUDE_DESKTOP" ]; then
  DESKTOP_SKILLS=$(find "$CLAUDE_DESKTOP" -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)
  if [ -z "$DESKTOP_SKILLS" ]; then
    DESKTOP_SKILLS="$CLAUDE_DESKTOP/skills"
    echo "→ Claude Desktop detected. Creating skills directory..."
  else
    echo "→ Claude Desktop detected."
  fi
  install_skill "$DESKTOP_SKILLS"
  INSTALLED=1
fi

if [ "$INSTALLED" -eq 0 ]; then
  echo "→ No Claude installation found. Creating Claude Code skills directory..."
  install_skill "$CLAUDE_CODE"
fi

# ── 2. Done ───────────────────────────────────────────────────────────────────

echo ""
echo "Restart Claude Desktop or reload Claude Code to activate."
echo "First use: say 'take a note' or 'captains log demo' to get started."
echo ""

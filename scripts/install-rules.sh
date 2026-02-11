#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Plan Structure Plugin - Rules Installation${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Plugin's rules directory
PLUGIN_RULES="${CLAUDE_PLUGIN_ROOT}/rules"

# Project's .claude/rules directory
PROJECT_RULES=".claude/rules"

# Global rules directory (optional)
GLOBAL_RULES="$HOME/.claude/rules"

# Check install mode (controlled via environment variable)
INSTALL_MODE="${CLAUDE_PLUGIN_INSTALL_MODE:-project}"

if [ "$INSTALL_MODE" = "global" ]; then
  TARGET_DIR="$GLOBAL_RULES"
  echo -e "📦 Installing rules to: ${GREEN}~/.claude/rules${NC} (global)"
else
  TARGET_DIR="$PROJECT_RULES"
  echo -e "📦 Installing rules to: ${GREEN}.claude/rules${NC} (project)"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy rule files
INSTALLED_COUNT=0
for rule_file in "$PLUGIN_RULES"/*.md; do
  if [ -f "$rule_file" ]; then
    filename=$(basename "$rule_file")

    # Check if file already exists
    if [ -f "$TARGET_DIR/$filename" ]; then
      echo -e "⚠️  ${filename} already exists, skipping..."
    else
      cp "$rule_file" "$TARGET_DIR/"
      echo -e "✓ Installed ${GREEN}${filename}${NC}"
      INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    fi
  fi
done

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}  ${INSTALLED_COUNT} rule file(s) installed${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# CLAUDE.md update notice
if [ "$INSTALL_MODE" = "project" ] && [ ! -f ".claude/CLAUDE.md" ]; then
  echo -e "${BLUE}💡 Tip: Add the following to your CLAUDE.md:${NC}"
  echo ""
  echo "## Plan Structure"
  echo "See @.claude/rules/plan-structure.md for planning workflow"
  echo ""
fi

# Usage guide
echo -e "${BLUE}📚 Usage:${NC}"
echo "  /subdivide              - Subdivide latest plan"
echo "  /subdivide <plan-path>  - Subdivide specific plan"
echo ""

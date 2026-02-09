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

# Plugin의 rules 디렉토리
PLUGIN_RULES="${CLAUDE_PLUGIN_ROOT}/rules"

# 프로젝트의 .claude/rules 디렉토리
PROJECT_RULES=".claude/rules"

# 전역 rules 디렉토리 (선택적)
GLOBAL_RULES="$HOME/.claude/rules"

# 설치 모드 확인 (환경 변수로 제어 가능)
INSTALL_MODE="${CLAUDE_PLUGIN_INSTALL_MODE:-project}"

if [ "$INSTALL_MODE" = "global" ]; then
  TARGET_DIR="$GLOBAL_RULES"
  echo -e "📦 Installing rules to: ${GREEN}~/.claude/rules${NC} (global)"
else
  TARGET_DIR="$PROJECT_RULES"
  echo -e "📦 Installing rules to: ${GREEN}.claude/rules${NC} (project)"
fi

# 대상 디렉토리 생성
mkdir -p "$TARGET_DIR"

# 규칙 파일 복사
INSTALLED_COUNT=0
for rule_file in "$PLUGIN_RULES"/*.md; do
  if [ -f "$rule_file" ]; then
    filename=$(basename "$rule_file")

    # 이미 존재하는 파일 확인
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

# CLAUDE.md 업데이트 안내
if [ "$INSTALL_MODE" = "project" ] && [ ! -f ".claude/CLAUDE.md" ]; then
  echo -e "${BLUE}💡 Tip: Add the following to your CLAUDE.md:${NC}"
  echo ""
  echo "## Plan Structure"
  echo "See @.claude/rules/plan-structure.md for planning workflow"
  echo ""
fi

# 사용법 안내
echo -e "${BLUE}📚 Usage:${NC}"
echo "  /subdivide              - Subdivide latest plan"
echo "  /subdivide <plan-path>  - Subdivide specific plan"
echo ""

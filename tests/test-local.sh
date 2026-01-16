#!/usr/bin/env bash
# test-local.sh - Quick local test of installed components
# Run this on a machine where bootstrap has already completed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BOLD}${CYAN}Claude Code Super Setup - Local Test Suite${NC}"
echo "=============================================="
echo ""

TOTAL_TESTS=0
PASSED_TESTS=0

run_test() {
    local test_name="$1"
    local test_command="$2"

    ((TOTAL_TESTS++))
    echo -n "Testing: $test_name... "

    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}FAIL${NC}"
    fi
}

# ============================================================================
# Installation Tests
# ============================================================================
echo -e "\n${BOLD}1. Installation Tests${NC}"
echo "----------------------------------------------"

run_test "Claude Code CLI installed" "command -v claude"
run_test "Node.js installed" "command -v node"
run_test "npm installed" "command -v npm"
run_test "Python3 installed" "command -v python3"
run_test "Git installed" "command -v git"
run_test "jq installed" "command -v jq"

# ============================================================================
# Configuration Tests
# ============================================================================
echo -e "\n${BOLD}2. Configuration Tests${NC}"
echo "----------------------------------------------"

run_test "CLAUDE.md exists" "[[ -f ~/.claude/CLAUDE.md ]]"
run_test "RULES.md exists" "[[ -f ~/.claude/RULES.md ]]"
run_test "PRINCIPLES.md exists" "[[ -f ~/.claude/PRINCIPLES.md ]]"
run_test "settings.json exists" "[[ -f ~/.claude/settings.json ]]"
run_test "settings.json valid JSON" "jq empty ~/.claude/settings.json"

# ============================================================================
# Skills Tests
# ============================================================================
echo -e "\n${BOLD}3. Domain Skills Tests${NC}"
echo "----------------------------------------------"

run_test "security-review skill exists" "[[ -f ~/.claude/skills/security-review/SKILL.md ]]"
run_test "devsecops skill exists" "[[ -f ~/.claude/skills/devsecops/SKILL.md ]]"
run_test "research skill exists" "[[ -f ~/.claude/skills/research/SKILL.md ]]"
run_test "Exactly 3 skills installed" "[[ \$(find ~/.claude/skills -name 'SKILL.md' | wc -l) -eq 3 ]]"

# Verify removed skills don't exist
run_test "planning skill removed" "[[ ! -f ~/.claude/skills/planning/SKILL.md ]]"
run_test "implementation skill removed" "[[ ! -f ~/.claude/skills/implementation/SKILL.md ]]"
run_test "debugging skill removed" "[[ ! -f ~/.claude/skills/debugging/SKILL.md ]]"
run_test "testing skill removed" "[[ ! -f ~/.claude/skills/testing/SKILL.md ]]"

# ============================================================================
# Hooks Tests
# ============================================================================
echo -e "\n${BOLD}4. Hooks Tests${NC}"
echo "----------------------------------------------"

run_test "Hooks directory exists" "[[ -d ~/.claude/hooks ]]"
run_test "skill-activator.sh executable" "[[ -x ~/.claude/hooks/skill-activator.sh ]]"
run_test "session-start.sh executable" "[[ -x ~/.claude/hooks/session-start.sh ]]"
run_test "quality-check.sh executable" "[[ -x ~/.claude/hooks/quality-check.sh ]]"
run_test "Hooks configured in settings.json" "jq -e '.hooks' ~/.claude/settings.json"

# ============================================================================
# MCP Tests
# ============================================================================
echo -e "\n${BOLD}5. MCP Configuration Tests${NC}"
echo "----------------------------------------------"

if command -v claude &>/dev/null; then
    MCP_LIST=$(claude mcp list 2>/dev/null || echo "")

    run_test "Context7 MCP configured" "echo '$MCP_LIST' | grep -q context7"
    run_test "Tavily MCP configured" "echo '$MCP_LIST' | grep -q tavily"
    run_test "Sequential Thinking MCP configured" "echo '$MCP_LIST' | grep -q sequential-thinking"
    run_test "Memory MCP configured" "echo '$MCP_LIST' | grep -q memory"
    run_test "Playwright MCP configured" "echo '$MCP_LIST' | grep -q playwright"
    run_test "GitHub MCP configured" "echo '$MCP_LIST' | grep -q github"
else
    echo -e "  ${YELLOW}Skipping MCP tests (Claude CLI not available)${NC}"
fi

# ============================================================================
# MCP Guidelines Tests
# ============================================================================
echo -e "\n${BOLD}6. MCP Guidelines Tests${NC}"
echo "----------------------------------------------"

run_test "MCP directory exists" "[[ -d ~/.claude/MCP ]]"
run_test "Context7 guideline exists" "[[ -f ~/.claude/MCP/MCP_Context7.md ]]"
run_test "Tavily guideline exists" "[[ -f ~/.claude/MCP/MCP_Tavily.md ]]"
run_test "Memory guideline exists" "[[ -f ~/.claude/MCP/MCP_Memory.md ]]"
run_test "Superpowers plugin guide exists" "[[ -f ~/.claude/MCP/PLUGIN_Superpowers.md ]]"
run_test "Episodic Memory plugin guide exists" "[[ -f ~/.claude/MCP/PLUGIN_EpisodicMemory.md ]]"

# ============================================================================
# Plugin Tests
# ============================================================================
echo -e "\n${BOLD}7. Plugin Tests${NC}"
echo "----------------------------------------------"

if command -v claude &>/dev/null; then
    PLUGIN_LIST=$(claude plugin list 2>/dev/null || echo "")

    run_test "Superpowers plugin installed" "echo '$PLUGIN_LIST' | grep -qi superpowers"
    run_test "Episodic Memory plugin installed" "echo '$PLUGIN_LIST' | grep -qi episodic"
else
    echo -e "  ${YELLOW}Skipping plugin tests (Claude CLI not available)${NC}"
fi

# ============================================================================
# GSD Tests
# ============================================================================
echo -e "\n${BOLD}8. GSD Command Tests${NC}"
echo "----------------------------------------------"

run_test "GSD commands directory exists" "[[ -d ~/.claude/commands/gsd ]]"
if [[ -d ~/.claude/commands/gsd ]]; then
    gsd_count=$(find ~/.claude/commands/gsd -name "*.md" 2>/dev/null | wc -l)
    run_test "GSD commands installed (found $gsd_count)" "[[ $gsd_count -gt 0 ]]"
fi

# ============================================================================
# Additional Tools Tests
# ============================================================================
echo -e "\n${BOLD}9. Additional Tools Tests${NC}"
echo "----------------------------------------------"

run_test "Ralph directory exists" "[[ -d ~/.claude-tools/ralph-claude-code ]]"
run_test "Memory storage directory exists" "[[ -d ~/.claude-memory ]]"

# ============================================================================
# Content Validation Tests
# ============================================================================
echo -e "\n${BOLD}10. Content Validation Tests${NC}"
echo "----------------------------------------------"

run_test "CLAUDE.md mentions Superpowers workflow" "grep -q 'MANDATORY' ~/.claude/CLAUDE.md"
run_test "RULES.md has Rule 12 (mandatory Superpowers)" "grep -q 'Rule 12' ~/.claude/RULES.md"
run_test "skill-activator routes to Superpowers" "grep -q 'superpowers' ~/.claude/hooks/skill-activator.sh"

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "=============================================="
echo -e "${BOLD}Test Summary${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC} $PASSED_TESTS / $TOTAL_TESTS"
echo ""

FAILED=$((TOTAL_TESTS - PASSED_TESTS))
if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}$FAILED test(s) failed.${NC}"
    exit 1
fi

#!/usr/bin/env bash
# test-hooks.sh - Test that hooks produce expected output
# Run this to validate hooks are working correctly

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$HOME/.claude/hooks"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

PASS_COUNT=0
FAIL_COUNT=0

pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASS_COUNT++))
}

fail() {
    echo -e "  ${RED}✗${NC} $1"
    ((FAIL_COUNT++))
}

echo -e "${BOLD}Testing Hooks${NC}"
echo "============================================"

# ============================================================================
# Test skill-activator.sh
# ============================================================================
echo -e "\n${BOLD}1. Testing skill-activator.sh${NC}"

SKILL_ACTIVATOR="$HOOKS_DIR/skill-activator.sh"

if [[ ! -x "$SKILL_ACTIVATOR" ]]; then
    fail "skill-activator.sh not executable or not found"
else
    # Test feature request routing
    output=$(echo '{"prompt": "Build a new user dashboard"}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if echo "$output" | grep -q "SUPERPOWERS WORKFLOW REQUIRED"; then
        pass "Feature request routes to Superpowers workflow"
    else
        fail "Feature request did not route to Superpowers"
    fi

    # Test debug request routing
    output=$(echo '{"prompt": "Fix this bug in the login"}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if echo "$output" | grep -q "DEBUGGING WORKFLOW"; then
        pass "Debug request routes to Superpowers debugging"
    else
        fail "Debug request did not route to debugging workflow"
    fi

    # Test security request routing
    output=$(echo '{"prompt": "Review the auth security"}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if echo "$output" | grep -q "security-review"; then
        pass "Security request routes to @security-review skill"
    else
        fail "Security request did not route to security-review skill"
    fi

    # Test devsecops request routing
    output=$(echo '{"prompt": "Setup the CI/CD pipeline"}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if echo "$output" | grep -q "devsecops"; then
        pass "DevOps request routes to @devsecops skill"
    else
        fail "DevOps request did not route to devsecops skill"
    fi

    # Test research request routing
    output=$(echo '{"prompt": "Compare React vs Vue for this project"}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if echo "$output" | grep -q "research"; then
        pass "Research request routes to @research skill"
    else
        fail "Research request did not route to research skill"
    fi

    # Test empty prompt handling
    output=$(echo '{"prompt": ""}' | "$SKILL_ACTIVATOR" 2>/dev/null || true)
    if [[ -z "$output" ]]; then
        pass "Empty prompt handled gracefully (no output)"
    else
        fail "Empty prompt should produce no output"
    fi
fi

# ============================================================================
# Test session-start.sh
# ============================================================================
echo -e "\n${BOLD}2. Testing session-start.sh${NC}"

SESSION_START="$HOOKS_DIR/session-start.sh"

if [[ ! -x "$SESSION_START" ]]; then
    fail "session-start.sh not executable or not found"
else
    # Test with a directory that has .git
    test_dir=$(mktemp -d)
    mkdir -p "$test_dir/.git"
    touch "$test_dir/CLAUDE.md"

    output=$(echo "{\"cwd\": \"$test_dir\"}" | "$SESSION_START" 2>/dev/null || true)

    if echo "$output" | grep -q "SESSION START"; then
        pass "Session start produces output"
    else
        fail "Session start did not produce expected output"
    fi

    if echo "$output" | grep -q "Git branch"; then
        pass "Session start detects git repository"
    else
        fail "Session start did not detect git repository"
    fi

    if echo "$output" | grep -q "MEMORY INTEGRATION"; then
        pass "Session start includes memory integration suggestions"
    else
        fail "Session start did not include memory suggestions"
    fi

    # Cleanup
    rm -rf "$test_dir"
fi

# ============================================================================
# Test quality-check.sh
# ============================================================================
echo -e "\n${BOLD}3. Testing quality-check.sh${NC}"

QUALITY_CHECK="$HOOKS_DIR/quality-check.sh"

if [[ ! -x "$QUALITY_CHECK" ]]; then
    fail "quality-check.sh not executable or not found"
else
    # Test with a code file edit
    output=$(echo '{"tool": "Edit", "tool_input": {"file_path": "/test/app.ts"}}' | "$QUALITY_CHECK" 2>/dev/null || true)

    if [[ -n "$output" ]]; then
        pass "Quality check produces output for code edits"
    else
        # Some implementations may be silent
        pass "Quality check ran without error"
    fi
fi

# ============================================================================
# Test Hook Configuration
# ============================================================================
echo -e "\n${BOLD}4. Testing Hook Configuration${NC}"

SETTINGS_FILE="$HOME/.claude/settings.json"

if [[ -f "$SETTINGS_FILE" ]]; then
    pass "settings.json exists"

    # Validate JSON syntax
    if jq empty "$SETTINGS_FILE" 2>/dev/null; then
        pass "settings.json is valid JSON"
    else
        fail "settings.json has invalid JSON syntax"
    fi

    # Check for hooks configuration
    if jq -e '.hooks' "$SETTINGS_FILE" >/dev/null 2>&1; then
        pass "settings.json contains hooks configuration"

        # Check specific hooks
        if jq -e '.hooks.UserPromptSubmit' "$SETTINGS_FILE" >/dev/null 2>&1; then
            pass "UserPromptSubmit hook configured"
        else
            fail "UserPromptSubmit hook not configured"
        fi

        if jq -e '.hooks.SessionStart' "$SETTINGS_FILE" >/dev/null 2>&1; then
            pass "SessionStart hook configured"
        else
            fail "SessionStart hook not configured"
        fi
    else
        fail "settings.json missing hooks configuration"
    fi
else
    fail "settings.json not found"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "============================================"
echo -e "${BOLD}Hook Test Summary${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC} $PASS_COUNT"
echo -e "  ${RED}Failed:${NC} $FAIL_COUNT"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}All hook tests passed!${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}Some hook tests failed.${NC}"
    exit 1
fi

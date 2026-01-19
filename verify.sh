#!/usr/bin/env bash
# verify.sh - Verify Claude Code Super Setup installation
# Run this after bootstrap.sh to check everything is working

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

print_header "Claude Code Super Setup - Verification"

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

check_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASS_COUNT++))
}

check_fail() {
    echo -e "  ${RED}✗${NC} $1"
    ((FAIL_COUNT++))
}

check_warn() {
    echo -e "  ${YELLOW}!${NC} $1"
    ((WARN_COUNT++))
}

# ============================================================================
# System Tools
# ============================================================================
log_step "Checking System Tools"

if command_exists git; then
    check_pass "git installed ($(git --version | head -1))"
else
    check_fail "git not found"
fi

if command_exists curl; then
    check_pass "curl installed"
else
    check_fail "curl not found"
fi

if command_exists jq; then
    check_pass "jq installed"
else
    check_fail "jq not found"
fi

if command_exists rg; then
    check_pass "ripgrep installed"
else
    check_warn "ripgrep not found (optional but recommended)"
fi

if command_exists Xvfb; then
    check_pass "Xvfb installed (for headless browsers)"
else
    check_warn "Xvfb not found (needed for headless browser automation)"
fi

# ============================================================================
# Node.js
# ============================================================================
log_step "Checking Node.js"

if command_exists node; then
    node_version=$(node -v)
    check_pass "Node.js installed ($node_version)"

    # Check version is >= 18
    version_num=$(echo "$node_version" | sed 's/^v//' | cut -d. -f1)
    if [[ "$version_num" -ge 18 ]]; then
        check_pass "Node.js version >= 18"
    else
        check_fail "Node.js version < 18 (need 18+)"
    fi
else
    check_fail "Node.js not found"
fi

if command_exists npm; then
    npm_version=$(npm -v)
    check_pass "npm installed (v$npm_version)"
else
    check_fail "npm not found"
fi

# ============================================================================
# Python
# ============================================================================
log_step "Checking Python"

if command_exists python3; then
    python_version=$(python3 --version)
    check_pass "Python installed ($python_version)"
else
    check_fail "Python 3 not found"
fi

if python3 -m pip --version &>/dev/null; then
    pip_version=$(python3 -m pip --version | awk '{print $2}')
    check_pass "pip installed (v$pip_version)"
else
    check_fail "pip not found"
fi

# Check pythea package
if python3 -c "import pythea" &>/dev/null; then
    check_pass "pythea package installed"
else
    check_warn "pythea package not found (needed for Strawberry MCP)"
fi

# ============================================================================
# Claude Code CLI
# ============================================================================
log_step "Checking Claude Code CLI"

# Add common paths
export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

if command_exists claude; then
    claude_version=$(claude --version 2>/dev/null || echo "installed")
    check_pass "Claude Code CLI installed ($claude_version)"
else
    check_fail "Claude Code CLI not found"
    echo -e "    ${DIM}Try: curl -fsSL https://claude.ai/install.sh | bash${NC}"
fi

# ============================================================================
# MCP Servers
# ============================================================================
log_step "Checking MCP Servers"

if command_exists claude; then
    mcp_list=$(claude mcp list 2>/dev/null || echo "")

    if echo "$mcp_list" | grep -q "context7"; then
        check_pass "Context7 MCP configured"
    else
        check_warn "Context7 MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "browserbase"; then
        check_pass "Browserbase MCP configured"
    else
        check_warn "Browserbase MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "playwright"; then
        check_pass "Playwright MCP configured"
    else
        check_warn "Playwright MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "tavily"; then
        check_pass "Tavily MCP configured"
    else
        check_warn "Tavily MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "hallucination-detector"; then
        check_pass "Hallucination Detector MCP configured (Pythea/Strawberry)"
    else
        check_warn "Hallucination Detector MCP not configured (requires OPENAI_API_KEY)"
    fi

    if echo "$mcp_list" | grep -q "github"; then
        check_pass "GitHub MCP configured"
    else
        check_warn "GitHub MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "e2b"; then
        check_pass "E2B MCP configured"
    else
        check_warn "E2B MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "sequential-thinking"; then
        check_pass "Sequential Thinking MCP configured"
    else
        check_warn "Sequential Thinking MCP not configured"
    fi

    if echo "$mcp_list" | grep -q "memory"; then
        check_pass "Memory MCP configured"
    else
        check_warn "Memory MCP not configured"
    fi
else
    check_warn "Cannot check MCP servers (Claude CLI not available)"
fi

# Check memory directory
if [[ -d "$HOME/.claude-memory" ]]; then
    check_pass "Memory storage directory exists"
else
    check_warn "Memory storage directory not found (~/.claude-memory)"
fi

# ============================================================================
# Plugins
# ============================================================================
log_step "Checking Plugins"

if command_exists claude; then
    plugin_list=$(claude plugin list 2>/dev/null || echo "")

    if echo "$plugin_list" | grep -qi "superpowers"; then
        check_pass "Superpowers plugin installed"
    else
        check_warn "Superpowers plugin not found"
    fi

    if echo "$plugin_list" | grep -qi "episodic-memory"; then
        check_pass "Episodic Memory plugin installed"
    else
        check_warn "Episodic Memory plugin not found"
    fi

    # Check marketplace
    marketplace_list=$(claude plugin marketplace list 2>/dev/null || echo "")
    if echo "$marketplace_list" | grep -qi "superpowers-marketplace"; then
        check_pass "Superpowers marketplace configured"
    else
        check_warn "Superpowers marketplace not configured"
    fi
else
    check_warn "Cannot check plugins (Claude CLI not available)"
fi

# ============================================================================
# GSD Slash Commands
# ============================================================================
log_step "Checking GSD Slash Commands"

GSD_DIR="$HOME/.claude/commands/gsd"
if [[ -d "$GSD_DIR" ]]; then
    gsd_count=$(find "$GSD_DIR" -name "*.md" 2>/dev/null | wc -l)
    if [[ "$gsd_count" -gt 0 ]]; then
        check_pass "GSD slash commands installed ($gsd_count commands)"
    else
        check_warn "GSD directory exists but no commands found"
    fi
else
    check_warn "GSD commands not found (run: npx get-shit-done-cc --global)"
fi

# ============================================================================
# Configuration Files
# ============================================================================
log_step "Checking Configuration Files"

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if [[ -f "$CLAUDE_MD" ]]; then
    check_pass "CLAUDE.md exists at $CLAUDE_MD"
else
    check_warn "CLAUDE.md not found at $CLAUDE_MD"
fi

if [[ -f "$SCRIPT_DIR/.env" ]]; then
    check_pass ".env file exists"

    # Check for empty values
    if grep -q "^CONTEXT7_API_KEY=$" "$SCRIPT_DIR/.env"; then
        check_warn "CONTEXT7_API_KEY is empty in .env"
    fi
    if grep -q "^BROWSERBASE_API_KEY=$" "$SCRIPT_DIR/.env"; then
        check_warn "BROWSERBASE_API_KEY is empty in .env"
    fi
else
    check_warn ".env file not found (copy from .env.example)"
fi

# ============================================================================
# Playwright Browsers
# ============================================================================
log_step "Checking Playwright Browsers"

if command_exists npx; then
    # Check if chromium is installed
    chromium_path="$HOME/.cache/ms-playwright"
    if [[ -d "$chromium_path" ]] && ls "$chromium_path"/chromium-* &>/dev/null; then
        check_pass "Playwright Chromium browser installed"
    else
        check_warn "Playwright Chromium not found (run: npx playwright install chromium)"
    fi
else
    check_warn "Cannot check Playwright browsers (npx not available)"
fi

# ============================================================================
# Skills and Rules
# ============================================================================
log_step "Checking Skills and Rules"

if [[ -f "$HOME/.claude/RULES.md" ]]; then
    check_pass "RULES.md installed"
else
    check_warn "RULES.md not found"
fi

if [[ -f "$HOME/.claude/PRINCIPLES.md" ]]; then
    check_pass "PRINCIPLES.md installed"
else
    check_warn "PRINCIPLES.md not found"
fi

# Check skills directory - should have exactly 3 domain skills
SKILLS_DIR="$HOME/.claude/skills"
if [[ -d "$SKILLS_DIR" ]]; then
    skill_count=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l)
    if [[ "$skill_count" -eq 3 ]]; then
        check_pass "Domain skills installed (3 skills: security-review, devsecops, research)"
    elif [[ "$skill_count" -gt 0 ]]; then
        check_warn "Expected 3 domain skills, found $skill_count"
    else
        check_warn "Skills directory exists but no SKILL.md files found"
    fi

    # Verify specific domain skills exist
    if [[ -f "$SKILLS_DIR/security-review/SKILL.md" ]]; then
        check_pass "security-review skill exists"
    else
        check_warn "security-review skill missing"
    fi

    if [[ -f "$SKILLS_DIR/devsecops/SKILL.md" ]]; then
        check_pass "devsecops skill exists"
    else
        check_warn "devsecops skill missing"
    fi

    if [[ -f "$SKILLS_DIR/research/SKILL.md" ]]; then
        check_pass "research skill exists"
    else
        check_warn "research skill missing"
    fi
else
    check_warn "Skills directory not found"
fi

# Check MCP guidelines
MCP_DIR="$HOME/.claude/MCP"
if [[ -d "$MCP_DIR" ]]; then
    mcp_guide_count=$(find "$MCP_DIR" -name "*.md" 2>/dev/null | wc -l)
    if [[ "$mcp_guide_count" -gt 0 ]]; then
        check_pass "MCP guidelines installed ($mcp_guide_count files)"
    else
        check_warn "MCP directory exists but no guidelines found"
    fi
else
    check_warn "MCP guidelines directory not found"
fi

# ============================================================================
# Hooks
# ============================================================================
log_step "Checking Hooks"

HOOKS_DIR="$HOME/.claude/hooks"
if [[ -d "$HOOKS_DIR" ]]; then
    check_pass "Hooks directory exists"

    if [[ -x "$HOOKS_DIR/skill-activator.sh" ]]; then
        check_pass "skill-activator.sh installed and executable"
    else
        check_warn "skill-activator.sh missing or not executable"
    fi

    if [[ -x "$HOOKS_DIR/quality-check.sh" ]]; then
        check_pass "quality-check.sh installed and executable"
    else
        check_warn "quality-check.sh missing or not executable"
    fi

    if [[ -x "$HOOKS_DIR/session-start.sh" ]]; then
        check_pass "session-start.sh installed and executable"
    else
        check_warn "session-start.sh missing or not executable"
    fi
else
    check_warn "Hooks directory not found"
fi

# Check settings.json for hooks configuration
SETTINGS_FILE="$HOME/.claude/settings.json"
if [[ -f "$SETTINGS_FILE" ]]; then
    if grep -q '"hooks"' "$SETTINGS_FILE"; then
        check_pass "settings.json contains hooks configuration"
    else
        check_warn "settings.json exists but no hooks configured"
    fi
else
    check_warn "settings.json not found"
fi

# ============================================================================
# Additional Tools
# ============================================================================
log_step "Checking Additional Tools"

RALPH_DIR="$HOME/.claude-tools/ralph-claude-code"
if [[ -d "$RALPH_DIR" ]]; then
    check_pass "Ralph installed at $RALPH_DIR"
else
    check_warn "Ralph not found"
fi

if [[ -f "$HOME/.local/bin/start-xvfb.sh" ]]; then
    check_pass "Xvfb helper script installed"
else
    check_warn "Xvfb helper script not found"
fi

# ============================================================================
# Summary
# ============================================================================
print_separator

echo -e "${BOLD}Verification Summary:${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC}  $PASS_COUNT"
echo -e "  ${YELLOW}Warnings:${NC} $WARN_COUNT"
echo -e "  ${RED}Failed:${NC}  $FAIL_COUNT"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    if [[ $WARN_COUNT -eq 0 ]]; then
        echo -e "${GREEN}${BOLD}All checks passed!${NC}"
    else
        echo -e "${YELLOW}${BOLD}Setup complete with warnings.${NC}"
        echo -e "Review warnings above - some features may need manual setup."
    fi
else
    echo -e "${RED}${BOLD}Some checks failed.${NC}"
    echo -e "Review failed items above and run relevant scripts to fix."
fi

print_separator

# Exit with appropriate code
if [[ $FAIL_COUNT -gt 0 ]]; then
    exit 1
elif [[ $WARN_COUNT -gt 0 ]]; then
    exit 0
else
    exit 0
fi

#!/usr/bin/env bash
# 07-plugins.sh - Install Claude Code plugins via CLI
# This script automates plugin installation that was previously thought to require interactive /plugin commands
#
# Key insight: Claude Code has a CLI plugin system:
#   - claude plugin marketplace add <source>
#   - claude plugin install <plugin>@<marketplace>
#   - claude plugin list
#
# This enables FULL automation of plugin installation!

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing Claude Code Plugins"

require_internet
require_command claude "Run 04-claude-code.sh first"

# Ensure claude command is available
export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

# ============================================================================
# Superpowers Marketplace
# ============================================================================
log_step "Adding Superpowers Marketplace"
log_info "Superpowers provides structured skills, hooks, and workflows for Claude Code"
log_info "Repository: https://github.com/obra/superpowers-marketplace"

# Check if marketplace already exists
if claude plugin marketplace list 2>/dev/null | grep -q "superpowers-marketplace"; then
    log_info "Superpowers marketplace already added"
else
    log_substep "Adding superpowers-marketplace..."
    if claude plugin marketplace add obra/superpowers-marketplace 2>/dev/null; then
        log_success "Superpowers marketplace added"
    else
        log_warn "Failed to add superpowers-marketplace (may need manual: /plugin marketplace add obra/superpowers-marketplace)"
    fi
fi

# ============================================================================
# Superpowers Plugin
# ============================================================================
log_step "Installing Superpowers Plugin"
log_info "Superpowers provides:"
log_info "  - Structured development workflows"
log_info "  - Skills for planning, debugging, testing"
log_info "  - /superpowers:brainstorm, /superpowers:write-plan, /superpowers:execute-plan"

# Check if plugin already installed
if claude plugin list 2>/dev/null | grep -q "superpowers"; then
    log_info "Superpowers plugin already installed"
else
    log_substep "Installing superpowers plugin..."
    if claude plugin install superpowers@superpowers-marketplace 2>/dev/null; then
        log_success "Superpowers plugin installed"
    else
        log_warn "Failed to install superpowers (may need manual: /plugin install superpowers@superpowers-marketplace)"
    fi
fi

# ============================================================================
# Episodic Memory Plugin
# ============================================================================
log_step "Installing Episodic Memory Plugin"
log_info "Episodic Memory provides:"
log_info "  - Semantic search across past conversations"
log_info "  - Local vector embeddings + SQLite storage"
log_info "  - /search-conversations command"
log_info "  - Memory persistence across sessions"

# Check if plugin already installed
if claude plugin list 2>/dev/null | grep -q "episodic-memory"; then
    log_info "Episodic Memory plugin already installed"
else
    log_substep "Installing episodic-memory plugin..."
    if claude plugin install episodic-memory@superpowers-marketplace 2>/dev/null; then
        log_success "Episodic Memory plugin installed"
    else
        log_warn "Failed to install episodic-memory (may need manual: /plugin install episodic-memory@superpowers-marketplace)"
    fi
fi

# ============================================================================
# Enable Plugins
# ============================================================================
log_step "Enabling Plugins"

log_substep "Enabling superpowers..."
claude plugin enable superpowers 2>/dev/null || true

log_substep "Enabling episodic-memory..."
claude plugin enable episodic-memory 2>/dev/null || true

# ============================================================================
# Summary
# ============================================================================
print_separator
echo -e "${GREEN}Plugins configured:${NC}"
echo ""
claude plugin list 2>/dev/null || echo "  (Run 'claude plugin list' to see installed plugins)"
echo ""
echo -e "${YELLOW}Notes:${NC}"
echo "  - Restart Claude Code to activate plugins"
echo "  - Superpowers provides: /superpowers:brainstorm, /superpowers:write-plan"
echo "  - Episodic Memory provides: /search-conversations"
echo "  - Check with: claude plugin list"
echo ""
echo -e "${CYAN}Plugin Commands:${NC}"
echo "  - claude plugin list              # Show installed plugins"
echo "  - claude plugin marketplace list  # Show added marketplaces"
echo "  - claude plugin update <name>     # Update a plugin"
echo ""
echo -e "${CYAN}Inside Claude Code:${NC}"
echo "  - /superpowers:brainstorm         # Brainstorm before coding"
echo "  - /superpowers:write-plan         # Create implementation plan"
echo "  - /superpowers:execute-plan       # Execute plan in batches"
echo "  - /search-conversations           # Search past conversations"
print_separator

#!/usr/bin/env bash
# 06-tools.sh - Install additional tools (Ralph, GSD) for Claude Code
# Run as regular user (not root)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing Additional Tools"

require_internet
require_command node "Run 02-nodejs.sh first"
require_command npm "Run 02-nodejs.sh first"
require_command git "Run 01-system-deps.sh first"

# Ensure tools directory exists
TOOLS_DIR="$HOME/.claude-tools"
ensure_dir "$TOOLS_DIR"

# ============================================================================
# Get Shit Done (GSD)
# ============================================================================
log_step "Installing Get Shit Done (GSD)"
log_info "GSD provides spec-driven, context-managed workflows"
log_info "Repository: https://github.com/glittercowboy/get-shit-done"
log_info ""
log_info "GSD provides slash commands:"
log_info "  - /gsd:help         Show help"
log_info "  - /gsd:new-project  Start a new project"
log_info "  - /gsd:plan         Create implementation plan"
log_info "  - /gsd:execute      Execute the plan"

# Check if GSD commands already exist
if [[ -d "$HOME/.claude/commands/gsd" ]]; then
    log_info "GSD commands already installed at ~/.claude/commands/gsd"
    log_substep "Updating to latest version..."
fi

log_substep "Running GSD installer (non-interactive)..."
# Use --global flag for non-interactive installation
if npx get-shit-done-cc@latest --global 2>/dev/null; then
    log_success "GSD installed globally to ~/.claude/commands/gsd/"
else
    # Fallback: try without --global (older versions)
    log_warn "Trying alternative installation method..."
    if npx get-shit-done-cc 2>/dev/null <<< "y"; then
        log_success "GSD installed"
    else
        log_warn "GSD automatic installation may have failed"
        log_info "Manual install: npx get-shit-done-cc"
    fi
fi

# Verify installation
if [[ -d "$HOME/.claude/commands/gsd" ]]; then
    gsd_commands=$(ls "$HOME/.claude/commands/gsd/" 2>/dev/null | wc -l)
    log_success "GSD verified: $gsd_commands slash commands installed"
fi

# ============================================================================
# Ralph (Autonomous Dev Loop)
# ============================================================================
log_step "Installing Ralph"
log_info "Ralph enables continuous autonomous development cycles"
log_info "Repository: https://github.com/frankbria/ralph-claude-code"
log_info ""
log_info "Ralph is an EXTERNAL bash loop that runs OUTSIDE Claude Code:"
log_info "  - ralph            Start autonomous development loop"
log_info "  - ralph-monitor    Live monitoring dashboard"
log_info "  - ralph-setup      Initialize a new Ralph project"

RALPH_DIR="$TOOLS_DIR/ralph-claude-code"

if [[ -d "$RALPH_DIR" ]]; then
    log_info "Ralph directory already exists, updating..."
    cd "$RALPH_DIR"
    git pull origin main 2>/dev/null || git pull 2>/dev/null || true
else
    log_substep "Cloning Ralph repository..."
    if git clone https://github.com/frankbria/ralph-claude-code.git "$RALPH_DIR" 2>/dev/null; then
        log_success "Ralph repository cloned"
    else
        log_warn "Failed to clone Ralph repository"
        log_info "Manual: git clone https://github.com/frankbria/ralph-claude-code.git $RALPH_DIR"
    fi
fi

cd "$RALPH_DIR" 2>/dev/null || true

# Make scripts executable
if [[ -d "$RALPH_DIR" ]]; then
    log_substep "Setting up Ralph scripts..."

    # Find and make main scripts executable
    for script in ralph_loop.sh ralph_monitor.sh setup.sh ralph.sh; do
        if [[ -f "$RALPH_DIR/$script" ]]; then
            chmod +x "$RALPH_DIR/$script"
        fi
    done

    # Try running installer if it exists
    if [[ -f "$RALPH_DIR/install.sh" ]]; then
        log_substep "Running Ralph installer..."
        chmod +x "$RALPH_DIR/install.sh"
        "$RALPH_DIR/install.sh" 2>/dev/null || true
    fi

    log_success "Ralph scripts configured"
fi

cd "$PROJECT_ROOT"

# ============================================================================
# Create a convenience wrapper script
# ============================================================================
log_step "Creating convenience scripts"

# Ralph wrapper
RALPH_WRAPPER="$HOME/.local/bin/ralph"
mkdir -p "$(dirname "$RALPH_WRAPPER")"

cat > "$RALPH_WRAPPER" << RALPH_EOF
#!/usr/bin/env bash
# Ralph wrapper - autonomous development tool
# See: https://github.com/frankbria/ralph-claude-code

RALPH_DIR="$RALPH_DIR"

if [[ -f "\$RALPH_DIR/ralph.sh" ]]; then
    exec "\$RALPH_DIR/ralph.sh" "\$@"
elif [[ -f "\$RALPH_DIR/ralph" ]]; then
    exec "\$RALPH_DIR/ralph" "\$@"
else
    echo "Ralph not properly installed. Check: \$RALPH_DIR"
    exit 1
fi
RALPH_EOF

chmod +x "$RALPH_WRAPPER"
log_substep "Created: $RALPH_WRAPPER"

# ============================================================================
# Summary
# ============================================================================
print_separator
echo -e "${GREEN}Additional tools installed:${NC}"
echo ""
echo "  ${CYAN}Get Shit Done (GSD)${NC}"
echo "    - Provides spec-driven workflows with slash commands"
echo "    - Location: ~/.claude/commands/gsd/"
echo "    - Commands (inside Claude Code):"
echo "        /gsd:help         - Show help"
echo "        /gsd:new-project  - Initialize new project"
echo "        /gsd:plan         - Create implementation plan"
echo "        /gsd:execute      - Execute the plan"
echo ""
echo "  ${CYAN}Ralph${NC}"
echo "    - Autonomous development loops (runs OUTSIDE Claude Code)"
echo "    - Location: $RALPH_DIR"
echo "    - Wrapper: $RALPH_WRAPPER"
echo "    - Commands (in terminal):"
echo "        ralph             - Start autonomous loop"
echo "        ralph-monitor     - Live monitoring dashboard"
echo ""
echo -e "${YELLOW}Key Difference:${NC}"
echo "  - GSD = Slash commands INSIDE Claude Code"
echo "  - Ralph = Bash loop OUTSIDE Claude Code that invokes Claude repeatedly"
echo ""
echo -e "${CYAN}Documentation:${NC}"
echo "  - GSD: https://github.com/glittercowboy/get-shit-done"
echo "  - Ralph: https://github.com/frankbria/ralph-claude-code"
print_separator

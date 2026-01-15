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

log_substep "Running GSD installer..."
npx get-shit-done-cc 2>/dev/null || {
    log_warn "GSD installation via npx may have prompted for input"
    log_info "If it didn't complete, run manually: npx get-shit-done-cc"
}

log_success "GSD installation initiated"

# ============================================================================
# Ralph (Autonomous Dev Loop)
# ============================================================================
log_step "Installing Ralph"
log_info "Ralph enables continuous autonomous development cycles"
log_info "Repository: https://github.com/frankbria/ralph-claude-code"

RALPH_DIR="$TOOLS_DIR/ralph-claude-code"

if [[ -d "$RALPH_DIR" ]]; then
    log_info "Ralph directory already exists, updating..."
    cd "$RALPH_DIR"
    git pull origin main 2>/dev/null || git pull
else
    log_substep "Cloning Ralph repository..."
    git clone https://github.com/frankbria/ralph-claude-code.git "$RALPH_DIR"
    cd "$RALPH_DIR"
fi

if [[ -f "install.sh" ]]; then
    log_substep "Running Ralph installer..."
    chmod +x install.sh
    ./install.sh
    log_success "Ralph installed"
else
    log_warn "Ralph install.sh not found, manual setup may be required"
    log_info "Check: $RALPH_DIR"
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
echo "    - Provides spec-driven workflows"
echo "    - Uses: /gsd commands inside Claude Code"
echo ""
echo "  ${CYAN}Ralph${NC}"
echo "    - Autonomous development loops"
echo "    - Location: $RALPH_DIR"
echo "    - Wrapper: $RALPH_WRAPPER"
echo ""
echo -e "${YELLOW}Documentation:${NC}"
echo "  - GSD: https://github.com/glittercowboy/get-shit-done"
echo "  - Ralph: https://github.com/frankbria/ralph-claude-code"
print_separator

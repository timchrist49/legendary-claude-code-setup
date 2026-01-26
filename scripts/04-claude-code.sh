#!/usr/bin/env bash
# 04-claude-code.sh - Install Claude Code CLI
# Should NOT run as root (installs to user directory)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing Claude Code CLI"

require_internet

# Check if Claude Code is already installed
if command_exists claude; then
    current_version=$(claude --version 2>/dev/null || echo "unknown")
    log_info "Claude Code is already installed (version: $current_version)"

    if ! confirm "Reinstall Claude Code?" "n"; then
        log_info "Skipping Claude Code installation"
        exit 0
    fi
fi

log_step "Installing Claude Code via native binary installer"
log_info "This is the recommended installation method from Anthropic"

# Download and run the official installer
# Use process substitution to avoid consuming stdin (which breaks later prompts)
bash <(curl -fsSL https://claude.ai/install.sh)

# Add claude to PATH for current session
# NOTE: We do NOT source ~/.bashrc or ~/.profile here because:
# 1. They often contain `return` statements for non-interactive shells
# 2. A `return` inside a sourced file exits the CALLING script (this one)
# 3. This would cause bootstrap.sh to stop at Phase 4
# Instead, we directly set the PATH which is sufficient for verification
export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

log_step "Verifying installation"
if command_exists claude; then
    installed_version=$(claude --version 2>/dev/null || echo "installed")
    log_success "Claude Code installed successfully"
    echo -e "  Version: ${GREEN}$installed_version${NC}"
else
    log_warn "Claude Code may be installed but not in PATH"
    log_info "Try running: source ~/.bashrc && claude --version"
    log_info "Or start a new terminal session"
fi

print_separator
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run 'claude' to start Claude Code"
echo "  2. Authenticate with your Anthropic account or API key"
echo "  3. See docs/PLUGINS.md for plugin installation"
print_separator

#!/usr/bin/env bash
# bootstrap.sh - Main entry point for Claude Code Super Setup
# Usage: ./bootstrap.sh [options]
#
# This script orchestrates the complete setup of a production-ready
# Claude Code environment on Debian/Ubuntu systems.

set -euo pipefail

# ============================================================================
# Script Setup
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
CONFIG_DIR="$SCRIPT_DIR/config"

source "$SCRIPTS_DIR/utils.sh"

# ============================================================================
# Configuration
# ============================================================================
SKIP_SYSTEM_DEPS=false
SKIP_NODEJS=false
SKIP_PYTHON=false
SKIP_CLAUDE_CODE=false
SKIP_MCP=false
SKIP_TOOLS=false
SKIP_PLUGINS=false
INTERACTIVE=true
FULL_AUTO=false

# ============================================================================
# Help
# ============================================================================
show_help() {
    cat << EOF
Claude Code Super Setup
=======================

Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -y, --yes               Non-interactive mode (accept defaults)
    --full-auto             Full automatic installation (no prompts)

    --skip-system-deps      Skip system dependencies installation
    --skip-nodejs           Skip Node.js installation
    --skip-python           Skip Python installation
    --skip-claude-code      Skip Claude Code CLI installation
    --skip-mcp              Skip MCP server configuration
    --skip-tools            Skip additional tools (Ralph, GSD)
    --skip-plugins          Skip plugin installation (Superpowers, Episodic Memory)

    --only-system-deps      Only install system dependencies
    --only-nodejs           Only install Node.js
    --only-python           Only install Python
    --only-claude-code      Only install Claude Code CLI
    --only-mcp              Only configure MCP servers
    --only-tools            Only install additional tools
    --only-plugins          Only install plugins

Examples:
    $0                      Interactive installation (recommended)
    $0 -y                   Accept all defaults
    $0 --only-mcp           Only configure MCP servers
    $0 --skip-tools         Skip Ralph and GSD installation

Environment:
    Copy .env.example to .env and fill in your API keys before running.

For more information, see README.md
EOF
}

# ============================================================================
# Parse Arguments
# ============================================================================
ONLY_MODE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -y|--yes)
            INTERACTIVE=false
            shift
            ;;
        --full-auto)
            INTERACTIVE=false
            FULL_AUTO=true
            shift
            ;;
        --skip-system-deps)
            SKIP_SYSTEM_DEPS=true
            shift
            ;;
        --skip-nodejs)
            SKIP_NODEJS=true
            shift
            ;;
        --skip-python)
            SKIP_PYTHON=true
            shift
            ;;
        --skip-claude-code)
            SKIP_CLAUDE_CODE=true
            shift
            ;;
        --skip-mcp)
            SKIP_MCP=true
            shift
            ;;
        --skip-tools)
            SKIP_TOOLS=true
            shift
            ;;
        --skip-plugins)
            SKIP_PLUGINS=true
            shift
            ;;
        --only-system-deps)
            ONLY_MODE="system-deps"
            shift
            ;;
        --only-nodejs)
            ONLY_MODE="nodejs"
            shift
            ;;
        --only-python)
            ONLY_MODE="python"
            shift
            ;;
        --only-claude-code)
            ONLY_MODE="claude-code"
            shift
            ;;
        --only-mcp)
            ONLY_MODE="mcp"
            shift
            ;;
        --only-tools)
            ONLY_MODE="tools"
            shift
            ;;
        --only-plugins)
            ONLY_MODE="plugins"
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# ============================================================================
# Welcome Banner
# ============================================================================
print_header "Claude Code Super Setup"

echo -e "${CYAN}"
cat << 'BANNER'
   _____ _                 _         _____          _
  / ____| |               | |       / ____|        | |
 | |    | | __ _ _   _  __| | ___  | |     ___   __| | ___
 | |    | |/ _` | | | |/ _` |/ _ \ | |    / _ \ / _` |/ _ \
 | |____| | (_| | |_| | (_| |  __/ | |___| (_) | (_| |  __/
  \_____|_|\__,_|\__,_|\__,_|\___|  \_____\___/ \__,_|\___|

              S U P E R   S E T U P
BANNER
echo -e "${NC}"

echo -e "  ${BOLD}Production-ready Claude Code environment${NC}"
echo -e "  ${DIM}Debian/Ubuntu • MCP Servers • Plugins • Tools${NC}"
echo ""

# ============================================================================
# Pre-flight Checks
# ============================================================================
log_step "Running pre-flight checks"

# Check OS
if ! check_debian_based; then
    log_error "This script requires a Debian-based system (Debian, Ubuntu, etc.)"
    exit 1
fi
log_substep "Debian-based system detected"

# Check internet
if ! check_internet; then
    log_error "Internet connection required"
    exit 1
fi
log_substep "Internet connection available"

# Check if running as root
if check_root; then
    log_warn "Running as root"
    log_info "Some steps will be run as root, others require non-root"
    IS_ROOT=true
else
    IS_ROOT=false
    log_substep "Running as user: $USER"
fi

# Load .env if it exists
ENV_FILE="$SCRIPT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
    log_substep "Loading environment from .env"
    load_env_file "$ENV_FILE"
else
    log_warn "No .env file found"
    log_info "Copy .env.example to .env and add your API keys for full setup"
fi

# ============================================================================
# Run Single Component (--only-* mode)
# ============================================================================
if [[ -n "$ONLY_MODE" ]]; then
    case $ONLY_MODE in
        system-deps)
            log_step "Running only: System Dependencies"
            sudo bash "$SCRIPTS_DIR/01-system-deps.sh"
            ;;
        nodejs)
            log_step "Running only: Node.js"
            sudo bash "$SCRIPTS_DIR/02-nodejs.sh"
            ;;
        python)
            log_step "Running only: Python"
            sudo bash "$SCRIPTS_DIR/03-python.sh"
            ;;
        claude-code)
            log_step "Running only: Claude Code CLI"
            bash "$SCRIPTS_DIR/04-claude-code.sh"
            ;;
        mcp)
            log_step "Running only: MCP Servers"
            bash "$SCRIPTS_DIR/05-mcp-servers.sh"
            ;;
        tools)
            log_step "Running only: Additional Tools"
            bash "$SCRIPTS_DIR/06-tools.sh"
            ;;
        plugins)
            log_step "Running only: Plugins"
            bash "$SCRIPTS_DIR/07-plugins.sh"
            ;;
    esac
    log_success "Done!"
    exit 0
fi

# ============================================================================
# Confirmation
# ============================================================================
if $INTERACTIVE && ! $FULL_AUTO; then
    echo ""
    log_info "This will install:"
    [[ "$SKIP_SYSTEM_DEPS" != "true" ]] && echo "  • System dependencies (apt packages)"
    [[ "$SKIP_NODEJS" != "true" ]] && echo "  • Node.js 20.x"
    [[ "$SKIP_PYTHON" != "true" ]] && echo "  • Python 3 with pip"
    [[ "$SKIP_CLAUDE_CODE" != "true" ]] && echo "  • Claude Code CLI"
    [[ "$SKIP_MCP" != "true" ]] && echo "  • MCP Servers (Context7, Tavily, Browserbase, Playwright, Strawberry, GitHub, E2B, Sequential Thinking, Memory)"
    [[ "$SKIP_TOOLS" != "true" ]] && echo "  • Additional tools (Ralph, GSD)"
    [[ "$SKIP_PLUGINS" != "true" ]] && echo "  • Plugins (7 total: Superpowers, Episodic Memory, Official Anthropic)"
    echo ""

    if ! confirm "Proceed with installation?" "y"; then
        log_info "Installation cancelled"
        exit 0
    fi
fi

# ============================================================================
# Phase 1: System Dependencies (requires root)
# ============================================================================
if [[ "$SKIP_SYSTEM_DEPS" != "true" ]]; then
    log_step "Phase 1/7: System Dependencies"

    if $IS_ROOT; then
        bash "$SCRIPTS_DIR/01-system-deps.sh"
    else
        sudo bash "$SCRIPTS_DIR/01-system-deps.sh"
    fi
fi

# ============================================================================
# Phase 2: Node.js (requires root)
# ============================================================================
if [[ "$SKIP_NODEJS" != "true" ]]; then
    log_step "Phase 2/7: Node.js"

    if $IS_ROOT; then
        bash "$SCRIPTS_DIR/02-nodejs.sh"
    else
        sudo bash "$SCRIPTS_DIR/02-nodejs.sh"
    fi
fi

# ============================================================================
# Phase 3: Python (requires root)
# ============================================================================
if [[ "$SKIP_PYTHON" != "true" ]]; then
    log_step "Phase 3/7: Python"

    if $IS_ROOT; then
        bash "$SCRIPTS_DIR/03-python.sh"
    else
        sudo bash "$SCRIPTS_DIR/03-python.sh"
    fi
fi

# ============================================================================
# Phase 4: Claude Code CLI (user space)
# ============================================================================
if [[ "$SKIP_CLAUDE_CODE" != "true" ]]; then
    log_step "Phase 4/7: Claude Code CLI"

    if $IS_ROOT; then
        # If running as root with sudo, run as the actual user
        if [[ -n "${SUDO_USER:-}" ]]; then
            sudo -u "$SUDO_USER" bash "$SCRIPTS_DIR/04-claude-code.sh"
        else
            bash "$SCRIPTS_DIR/04-claude-code.sh"
        fi
    else
        bash "$SCRIPTS_DIR/04-claude-code.sh"
    fi
fi

# ============================================================================
# Phase 5: MCP Servers (user space)
# ============================================================================
if [[ "$SKIP_MCP" != "true" ]]; then
    log_step "Phase 5/7: MCP Servers"

    if $IS_ROOT; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            sudo -u "$SUDO_USER" bash "$SCRIPTS_DIR/05-mcp-servers.sh"
        else
            bash "$SCRIPTS_DIR/05-mcp-servers.sh"
        fi
    else
        bash "$SCRIPTS_DIR/05-mcp-servers.sh"
    fi
fi

# ============================================================================
# Phase 6: Additional Tools (user space)
# ============================================================================
if [[ "$SKIP_TOOLS" != "true" ]]; then
    log_step "Phase 6/7: Additional Tools"

    if $IS_ROOT; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            sudo -u "$SUDO_USER" bash "$SCRIPTS_DIR/06-tools.sh"
        else
            bash "$SCRIPTS_DIR/06-tools.sh"
        fi
    else
        bash "$SCRIPTS_DIR/06-tools.sh"
    fi
fi

# ============================================================================
# Phase 7: Plugins (user space)
# ============================================================================
if [[ "$SKIP_PLUGINS" != "true" ]]; then
    log_step "Phase 7/7: Plugins (7 total: Superpowers, Episodic Memory, Official Anthropic)"

    if $IS_ROOT; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            sudo -u "$SUDO_USER" bash "$SCRIPTS_DIR/07-plugins.sh"
        else
            bash "$SCRIPTS_DIR/07-plugins.sh"
        fi
    else
        bash "$SCRIPTS_DIR/07-plugins.sh"
    fi
fi

# ============================================================================
# Install Claude Configuration (Skills, Rules, MCP Guidelines)
# ============================================================================
log_step "Installing Claude Code configuration"

CLAUDE_DIR="$HOME/.claude"
if [[ -n "${SUDO_USER:-}" ]]; then
    CLAUDE_DIR="$(eval echo ~$SUDO_USER)/.claude"
fi

CLAUDE_CONFIG_SRC="$CONFIG_DIR/claude"

# Create directory structure
mkdir -p "$CLAUDE_DIR"/{MCP,skills,context}

# Function to install a config file
install_config_file() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [[ -f "$dest" ]]; then
        if $INTERACTIVE && confirm "  Overwrite $name?" "n"; then
            backup_file "$dest"
            sed "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$src" > "$dest"
            log_substep "$name updated"
        else
            log_substep "$name kept existing"
        fi
    else
        sed "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$src" > "$dest"
        log_substep "$name installed"
    fi
}

# Install main configuration files
log_info "Installing core configuration files..."
install_config_file "$CLAUDE_CONFIG_SRC/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "CLAUDE.md"
install_config_file "$CLAUDE_CONFIG_SRC/RULES.md" "$CLAUDE_DIR/RULES.md" "RULES.md"
install_config_file "$CLAUDE_CONFIG_SRC/PRINCIPLES.md" "$CLAUDE_DIR/PRINCIPLES.md" "PRINCIPLES.md"

# Install MCP guidelines
log_info "Installing MCP guidelines..."
mkdir -p "$CLAUDE_DIR/MCP"
for mcp_file in "$CLAUDE_CONFIG_SRC"/MCP/*.md; do
    if [[ -f "$mcp_file" ]]; then
        filename=$(basename "$mcp_file")
        cp "$mcp_file" "$CLAUDE_DIR/MCP/$filename"
        log_substep "MCP/$filename installed"
    fi
done

# Install skills
log_info "Installing skills..."
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$CLAUDE_CONFIG_SRC"/skills/*/; do
    if [[ -d "$skill_dir" ]]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$CLAUDE_DIR/skills/$skill_name"
        if [[ -f "$skill_dir/SKILL.md" ]]; then
            cp "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md"
            log_substep "skills/$skill_name/SKILL.md installed"
        fi
    fi
done

# Install context templates
log_info "Installing context templates..."
mkdir -p "$CLAUDE_DIR/context"
for template in "$CLAUDE_CONFIG_SRC"/context/*.template; do
    if [[ -f "$template" ]]; then
        filename=$(basename "$template")
        cp "$template" "$CLAUDE_DIR/context/$filename"
        log_substep "context/$filename installed"
    fi
done

# Install hooks for reliable skill activation
log_info "Installing hooks..."
mkdir -p "$CLAUDE_DIR/hooks"
for hook_file in "$CLAUDE_CONFIG_SRC"/hooks/*.sh; do
    if [[ -f "$hook_file" ]]; then
        filename=$(basename "$hook_file")
        cp "$hook_file" "$CLAUDE_DIR/hooks/$filename"
        chmod +x "$CLAUDE_DIR/hooks/$filename"
        log_substep "hooks/$filename installed"
    fi
done

# Install/merge settings.json for hooks configuration
log_info "Configuring hooks in settings.json..."
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
SETTINGS_SRC="$CLAUDE_CONFIG_SRC/settings.json"

if [[ -f "$SETTINGS_FILE" ]]; then
    # Save original settings to temp file for merging (backup_file uses timestamped path)
    SETTINGS_ORIG=$(mktemp)
    cp "$SETTINGS_FILE" "$SETTINGS_ORIG"
    # Backup existing settings
    backup_file "$SETTINGS_FILE"
    # Merge hooks into existing settings (requires jq)
    if command -v jq &> /dev/null; then
        # Deep merge the hooks section
        jq -s '.[0] * .[1]' "$SETTINGS_ORIG" "$SETTINGS_SRC" > "$SETTINGS_FILE"
        log_substep "settings.json merged with hooks"
    else
        log_warn "jq not found, copying settings.json (existing backed up)"
        cp "$SETTINGS_SRC" "$SETTINGS_FILE"
    fi
    rm -f "$SETTINGS_ORIG"
else
    cp "$SETTINGS_SRC" "$SETTINGS_FILE"
    log_substep "settings.json installed"
fi

log_success "Claude Code configuration installed at $CLAUDE_DIR"

# ============================================================================
# Final Summary
# ============================================================================
print_header "Installation Complete!"

echo -e "${GREEN}${BOLD}What was installed:${NC}"
echo ""
[[ "$SKIP_SYSTEM_DEPS" != "true" ]] && echo "  ✓ System dependencies (git, curl, ripgrep, xvfb, etc.)"
[[ "$SKIP_NODEJS" != "true" ]] && echo "  ✓ Node.js $(node -v 2>/dev/null || echo '(restart shell)')"
[[ "$SKIP_PYTHON" != "true" ]] && echo "  ✓ Python $(python3 --version 2>/dev/null | awk '{print $2}' || echo '3.x')"
[[ "$SKIP_CLAUDE_CODE" != "true" ]] && echo "  ✓ Claude Code CLI"
[[ "$SKIP_MCP" != "true" ]] && echo "  ✓ MCP Servers (Context7, Tavily, Browserbase, Playwright, Strawberry, GitHub, E2B, Sequential Thinking, Memory)"
[[ "$SKIP_TOOLS" != "true" ]] && echo "  ✓ Additional tools (Ralph, GSD)"
[[ "$SKIP_PLUGINS" != "true" ]] && echo "  ✓ Plugins (7 total: Superpowers, Episodic Memory, Official Anthropic)"
echo "  ✓ Claude configuration (CLAUDE.md, RULES.md, PRINCIPLES.md)"
echo "  ✓ MCP guidelines (9 files)"
echo "  ✓ Skills (planning, implementation, debugging, testing, research, security-review, devsecops)"
echo "  ✓ Hooks (skill-activator, quality-check, session-start)"
echo "  ✓ Context templates (PROJECT.md, STATE.md, ROADMAP.md)"
echo ""

echo -e "${YELLOW}${BOLD}Next Steps:${NC}"
echo ""
echo "  1. ${BOLD}Start a new terminal${NC} (or run: source ~/.bashrc)"
echo ""
echo "  2. ${BOLD}Authenticate Claude Code:${NC}"
echo "     $ claude"
echo "     (Follow prompts to log in with subscription or API key)"
echo ""
echo "  3. ${BOLD}Verify installation:${NC}"
echo "     $ claude mcp list         # Check MCP servers (9 total)"
echo "     $ claude plugin list      # Check plugins (Superpowers, Episodic Memory)"
echo ""
echo "  4. ${BOLD}Restart Claude Code${NC} to activate plugins"
echo ""
echo "  5. ${BOLD}For headless servers, start Xvfb:${NC}"
echo "     $ ~/.local/bin/start-xvfb.sh"
echo ""
echo -e "${GREEN}${BOLD}Everything is now automated!${NC}"
echo "  • 9 MCP servers installed"
echo "  • 7 Plugins installed (Superpowers, Episodic Memory + 5 Official Anthropic)"
echo "  • GSD slash commands (/gsd:*)"
echo "  • Ralph autonomous loop (external)"
echo ""

echo -e "${CYAN}Documentation:${NC}"
echo "  • Plugins guide:      $SCRIPT_DIR/docs/PLUGINS.md"
echo "  • MCP servers guide:  $SCRIPT_DIR/docs/MCP-SERVERS.md"
echo "  • Hooks guide:        $SCRIPT_DIR/docs/HOOKS.md"
echo "  • Security guide:     $SCRIPT_DIR/docs/SECURITY.md"
echo "  • Troubleshooting:    $SCRIPT_DIR/docs/TROUBLESHOOTING.md"
echo ""

print_separator
echo -e "${GREEN}${BOLD}Happy coding with Claude!${NC} 🚀"
print_separator

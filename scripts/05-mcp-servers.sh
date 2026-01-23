#!/usr/bin/env bash
# 05-mcp-servers.sh - Install and configure MCP servers for Claude Code
# Run as regular user (not root)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing MCP Servers"

require_internet
require_command node "Run 02-nodejs.sh first"
require_command npm "Run 02-nodejs.sh first"
require_command python3 "Run 03-python.sh first"

# Load environment variables if available
ENV_FILE="$PROJECT_ROOT/.env"
if [[ -f "$ENV_FILE" ]]; then
    load_env_file "$ENV_FILE"
fi

# Ensure claude command is available
export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

if ! command_exists claude; then
    log_error "Claude Code CLI not found. Run 04-claude-code.sh first"
    exit 1
fi

# ============================================================================
# Context7 MCP
# ============================================================================
log_step "Setting up Context7 MCP"
log_info "Context7 provides up-to-date, version-specific documentation"

CONTEXT7_API_KEY="${CONTEXT7_API_KEY:-}"
if [[ -z "$CONTEXT7_API_KEY" ]]; then
    log_warn "CONTEXT7_API_KEY not set"
    echo -e "  Get your API key at: ${CYAN}https://context7.com/dashboard${NC}"
    echo ""

    if confirm "Enter Context7 API key now?" "y"; then
        read -r -p "Context7 API Key: " CONTEXT7_API_KEY
    fi
fi

if [[ -n "$CONTEXT7_API_KEY" ]]; then
    log_substep "Adding Context7 MCP server..."
    claude mcp remove context7 2>/dev/null || true
    claude mcp add context7 \
        --env CONTEXT7_API_KEY="$CONTEXT7_API_KEY" \
        -- npx -y @upstash/context7-mcp
    log_success "Context7 MCP added"
else
    log_warn "Skipping Context7 (no API key provided)"
    log_info "Add later with: claude mcp add context7 --env CONTEXT7_API_KEY=YOUR_KEY -- npx -y @upstash/context7-mcp"
fi

# ============================================================================
# Browserbase MCP
# ============================================================================
log_step "Setting up Browserbase MCP"
log_info "Browserbase provides cloud browser control for research and automation"

BROWSERBASE_API_KEY="${BROWSERBASE_API_KEY:-}"
BROWSERBASE_PROJECT_ID="${BROWSERBASE_PROJECT_ID:-}"

if [[ -z "$BROWSERBASE_API_KEY" || -z "$BROWSERBASE_PROJECT_ID" ]]; then
    log_warn "Browserbase credentials not set"
    echo -e "  Get your credentials at: ${CYAN}https://browserbase.com${NC}"
    echo ""

    if confirm "Enter Browserbase credentials now?" "y"; then
        [[ -z "$BROWSERBASE_API_KEY" ]] && read -r -p "Browserbase API Key: " BROWSERBASE_API_KEY
        [[ -z "$BROWSERBASE_PROJECT_ID" ]] && read -r -p "Browserbase Project ID: " BROWSERBASE_PROJECT_ID
    fi
fi

if [[ -n "$BROWSERBASE_API_KEY" && -n "$BROWSERBASE_PROJECT_ID" ]]; then
    log_substep "Adding Browserbase MCP server..."
    claude mcp remove browserbase 2>/dev/null || true
    claude mcp add browserbase \
        --env BROWSERBASE_API_KEY="$BROWSERBASE_API_KEY" \
        --env BROWSERBASE_PROJECT_ID="$BROWSERBASE_PROJECT_ID" \
        -- npx -y @browserbasehq/mcp-server-browserbase
    log_success "Browserbase MCP added"
else
    log_warn "Skipping Browserbase (missing credentials)"
    log_info "Add later with: claude mcp add browserbase --env BROWSERBASE_API_KEY=... --env BROWSERBASE_PROJECT_ID=... -- npx -y @browserbasehq/mcp-server-browserbase"
fi

# ============================================================================
# Playwright MCP (with headless Debian/Ubuntu fix)
# ============================================================================
log_step "Setting up Playwright MCP"
log_info "Playwright provides browser automation for testing and UI interaction"

log_substep "Installing Playwright globally..."
npm install -g playwright 2>/dev/null || npm install -g playwright

log_substep "Installing Playwright browser binaries..."
npx playwright install chromium

log_substep "Cleaning up any stale browser processes..."
pkill -f chrome 2>/dev/null || true
pkill -f chromium 2>/dev/null || true
pkill -f playwright 2>/dev/null || true
rm -rf "$HOME/.cache/ms-playwright/mcp-chrome-"* 2>/dev/null || true

log_substep "Adding Playwright MCP server..."
claude mcp remove playwright 2>/dev/null || true
# Using Microsoft's official Playwright MCP package
# Env vars for headless operation on Linux servers
claude mcp add playwright \
    --env DISPLAY=:99 \
    --env PLAYWRIGHT_HEADLESS=true \
    --env PLAYWRIGHT_CHROMIUM_USE_HEADLESS_NEW=true \
    -- npx -y @playwright/mcp@latest

log_success "Playwright MCP added"

# ============================================================================
# Tavily MCP (Web Search)
# ============================================================================
log_step "Setting up Tavily MCP"
log_info "Tavily provides AI-powered web search for research and current information"

TAVILY_API_KEY="${TAVILY_API_KEY:-}"
if [[ -z "$TAVILY_API_KEY" ]]; then
    log_warn "TAVILY_API_KEY not set"
    echo -e "  Get your API key at: ${CYAN}https://tavily.com${NC}"
    echo ""

    if confirm "Enter Tavily API key now?" "y"; then
        read -r -p "Tavily API Key: " TAVILY_API_KEY
    fi
fi

if [[ -n "$TAVILY_API_KEY" ]]; then
    log_substep "Adding Tavily MCP server..."
    claude mcp remove tavily-mcp 2>/dev/null || true
    claude mcp add tavily-mcp \
        --env TAVILY_API_KEY="$TAVILY_API_KEY" \
        -- npx -y tavily-mcp@latest
    log_success "Tavily MCP added"
else
    log_warn "Skipping Tavily (no API key provided)"
    log_info "Add later with: claude mcp add tavily-mcp --env TAVILY_API_KEY=YOUR_KEY -- npx -y tavily-mcp@latest"
fi

# ============================================================================
# Strawberry/Pythea MCP (Hallucination Detection)
# Source: https://github.com/leochlon/pythea
# Requires: Python 3.12+, OPENAI_API_KEY
# ============================================================================
log_step "Setting up Strawberry MCP (Hallucination Detection)"
log_info "Strawberry detects procedural hallucinations using information theory"
log_info "Source: https://github.com/leochlon/pythea"

# Check for OpenAI API key (required for Strawberry)
OPENAI_API_KEY="${OPENAI_API_KEY:-}"
if [[ -z "$OPENAI_API_KEY" ]]; then
    log_warn "OPENAI_API_KEY not set"
    echo -e "  Strawberry requires OpenAI API for verification"
    echo -e "  Get your API key at: ${CYAN}https://platform.openai.com/api-keys${NC}"
    echo ""

    if confirm "Enter OpenAI API key now?" "n"; then
        read -r -p "OpenAI API Key: " OPENAI_API_KEY
    fi
fi

if [[ -n "$OPENAI_API_KEY" ]]; then
    # Check for Python 3.12+
    if command_exists python3.12; then
        PYTHON_CMD="python3.12"
    elif python3 --version 2>/dev/null | grep -qE "3\.1[2-9]"; then
        PYTHON_CMD="python3"
    else
        log_warn "Strawberry requires Python 3.12+, skipping"
        PYTHON_CMD=""
    fi

    if [[ -n "$PYTHON_CMD" ]]; then
        PYTHEA_DIR="$HOME/.claude-tools/pythea"
        PYTHEA_VENV="$PYTHEA_DIR/.venv"

        log_substep "Cloning Pythea repository..."
        if [[ -d "$PYTHEA_DIR" ]]; then
            cd "$PYTHEA_DIR"
            git pull origin main 2>/dev/null || true
        else
            mkdir -p "$(dirname "$PYTHEA_DIR")"
            git clone https://github.com/leochlon/pythea.git "$PYTHEA_DIR" 2>/dev/null || {
                log_warn "Failed to clone Pythea repository"
                PYTHEA_DIR=""
            }
        fi

        if [[ -n "$PYTHEA_DIR" && -d "$PYTHEA_DIR" ]]; then
            cd "$PYTHEA_DIR"

            log_substep "Creating Python 3.12 virtual environment..."
            $PYTHON_CMD -m venv "$PYTHEA_VENV" 2>/dev/null || {
                log_warn "Failed to create venv"
                PYTHEA_VENV=""
            }

            if [[ -n "$PYTHEA_VENV" && -d "$PYTHEA_VENV" ]]; then
                log_substep "Installing Pythea with MCP support..."
                "$PYTHEA_VENV/bin/pip" install --upgrade pip 2>/dev/null
                "$PYTHEA_VENV/bin/pip" install -e ".[mcp]" 2>/dev/null || {
                    log_warn "Failed to install Pythea"
                }
                # Install MCP SDK (required for the MCP server)
                "$PYTHEA_VENV/bin/pip" install 'mcp[cli]' 2>/dev/null || true

                # Verify installation
                if "$PYTHEA_VENV/bin/python" -c "import strawberry; print('ok')" 2>/dev/null; then
                    # IMPORTANT: cd back to home before adding MCP to avoid project scoping
                    cd "$HOME"
                    log_substep "Adding Strawberry MCP server (hallucination-detector)..."
                    claude mcp remove hallucination-detector 2>/dev/null || true
                    claude mcp remove strawberry 2>/dev/null || true
                    claude mcp add hallucination-detector \
                        --env OPENAI_API_KEY="$OPENAI_API_KEY" \
                        -- "$PYTHEA_VENV/bin/python" -m strawberry.mcp_server
                    log_success "Strawberry MCP added as 'hallucination-detector'"
                    log_info "Usage: Ask Claude to 'Use detect_hallucination on [your answer]'"
                else
                    log_warn "Pythea installation verification failed"
                fi
            fi
        fi

        cd "$PROJECT_ROOT" 2>/dev/null || true
    fi
else
    log_warn "Skipping Strawberry MCP (no OpenAI API key)"
    log_info "Add OPENAI_API_KEY to .env and re-run to enable hallucination detection"
fi

# ============================================================================
# GitHub MCP (Repository Operations)
# ============================================================================
log_step "Setting up GitHub MCP"
log_info "GitHub MCP provides repo management, PR workflows, and issue tracking"

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
if [[ -z "$GITHUB_TOKEN" ]]; then
    log_warn "GITHUB_TOKEN not set"
    echo -e "  Create a token at: ${CYAN}https://github.com/settings/tokens${NC}"
    echo -e "  Required scopes: repo, read:org, read:user"
    echo ""

    if confirm "Enter GitHub token now?" "y"; then
        read -r -p "GitHub Token: " GITHUB_TOKEN
    fi
fi

if [[ -n "$GITHUB_TOKEN" ]]; then
    log_substep "Adding GitHub MCP server..."
    claude mcp remove github 2>/dev/null || true
    claude mcp add github \
        --env GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
        -- npx -y @modelcontextprotocol/server-github
    log_success "GitHub MCP added"
else
    log_warn "Skipping GitHub MCP (no token provided)"
    log_info "Add later with: claude mcp add github --env GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_TOKEN -- npx -y @modelcontextprotocol/server-github"
fi

# ============================================================================
# E2B MCP (Sandboxed Code Execution)
# ============================================================================
log_step "Setting up E2B MCP"
log_info "E2B provides isolated sandbox environments for safe code execution"

E2B_API_KEY="${E2B_API_KEY:-}"
if [[ -z "$E2B_API_KEY" ]]; then
    log_warn "E2B_API_KEY not set"
    echo -e "  Get your API key at: ${CYAN}https://e2b.dev${NC}"
    echo ""

    if confirm "Enter E2B API key now?" "y"; then
        read -r -p "E2B API Key: " E2B_API_KEY
    fi
fi

if [[ -n "$E2B_API_KEY" ]]; then
    log_substep "Adding E2B MCP server..."
    claude mcp remove e2b 2>/dev/null || true
    claude mcp add e2b \
        --env E2B_API_KEY="$E2B_API_KEY" \
        -- npx -y @e2b/mcp-server
    log_success "E2B MCP added"
else
    log_warn "Skipping E2B (no API key provided)"
    log_info "Add later with: claude mcp add e2b --env E2B_API_KEY=YOUR_KEY -- npx -y @e2b/mcp-server"
fi

# ============================================================================
# Sequential Thinking MCP (Problem Decomposition)
# ============================================================================
log_step "Setting up Sequential Thinking MCP"
log_info "Sequential Thinking provides structured problem-solving through thought sequences"

log_substep "Adding Sequential Thinking MCP server..."
claude mcp remove sequential-thinking 2>/dev/null || true
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
log_success "Sequential Thinking MCP added"

# ============================================================================
# Memory MCP (Persistent Memory Across Sessions)
# ============================================================================
log_step "Setting up Memory MCP"
log_info "Memory MCP provides persistent memory across sessions via local knowledge graph"

# Create memory directory
MEMORY_DIR="$HOME/.claude-memory"
mkdir -p "$MEMORY_DIR"

log_substep "Adding Memory MCP server..."
claude mcp remove memory 2>/dev/null || true
claude mcp add memory -- npx -y @modelcontextprotocol/server-memory --memory-path "$MEMORY_DIR"
log_success "Memory MCP added (storage: $MEMORY_DIR)"

# ============================================================================
# Xvfb Setup Script (for Playwright headless)
# ============================================================================
log_step "Creating Xvfb startup helper"

XVFB_SCRIPT="$HOME/.local/bin/start-xvfb.sh"
mkdir -p "$(dirname "$XVFB_SCRIPT")"

cat > "$XVFB_SCRIPT" << 'XVFB_EOF'
#!/usr/bin/env bash
# Start Xvfb virtual display for headless browser automation

DISPLAY_NUM="${1:-99}"

# Check if Xvfb is already running on this display
if pgrep -f "Xvfb :$DISPLAY_NUM" > /dev/null 2>&1; then
    echo "Xvfb already running on display :$DISPLAY_NUM"
else
    echo "Starting Xvfb on display :$DISPLAY_NUM"
    Xvfb ":$DISPLAY_NUM" -screen 0 1920x1080x24 > /dev/null 2>&1 &
    sleep 1
    echo "Xvfb started (PID: $!)"
fi

export DISPLAY=":$DISPLAY_NUM"
echo "DISPLAY=$DISPLAY"
XVFB_EOF

chmod +x "$XVFB_SCRIPT"
log_substep "Created: $XVFB_SCRIPT"

# ============================================================================
# Validation - Check MCP Connection Status
# ============================================================================
log_step "Validating MCP Server Connections"
log_info "Health-checking 9 MCP servers (this takes 30-60 seconds)..."
log_info "Please wait - connecting to each server..."
echo ""

# Start a background spinner to show progress
spin_pid=""
if [[ -t 1 ]]; then  # Only if stdout is a terminal
    (
        spinner='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        i=0
        while true; do
            printf "\r  [%c] Checking servers..." "${spinner:i++%${#spinner}:1}"
            sleep 0.1
        done
    ) &
    spin_pid=$!
fi

# Get the MCP list output with timeout (90 seconds max)
MCP_OUTPUT=""
if command -v timeout &> /dev/null; then
    MCP_OUTPUT=$(timeout 90 claude mcp list 2>&1 || echo "TIMEOUT_OR_ERROR")
else
    MCP_OUTPUT=$(claude mcp list 2>&1 || echo "ERROR")
fi

# Stop the spinner
if [[ -n "$spin_pid" ]]; then
    kill "$spin_pid" 2>/dev/null || true
    wait "$spin_pid" 2>/dev/null || true  # wait returns 143 for killed process, suppress it
    printf "\r                              \r"  # Clear the spinner line
fi

# Count connected vs failed
CONNECTED=0
FAILED=0
FAILED_SERVERS=""

check_mcp_status() {
    local server_name="$1"
    local display_name="${2:-$1}"
    if echo "$MCP_OUTPUT" | grep -q "$server_name.*Connected"; then
        ((CONNECTED++))
        echo -e "  ${GREEN}✓${NC} $display_name - Connected"
    elif echo "$MCP_OUTPUT" | grep -q "$server_name.*Failed"; then
        ((FAILED++))
        FAILED_SERVERS="$FAILED_SERVERS $display_name"
        echo -e "  ${RED}✗${NC} $display_name - Failed to connect"
    elif echo "$MCP_OUTPUT" | grep -q "$server_name"; then
        echo -e "  ${YELLOW}?${NC} $display_name - Status unknown"
    else
        echo -e "  ${YELLOW}-${NC} $display_name - Not found in config"
    fi
}

echo "MCP Server Status:"
check_mcp_status "context7" "context7"
check_mcp_status "tavily" "tavily-mcp"
check_mcp_status "browserbase" "browserbase"
check_mcp_status "playwright" "playwright"
check_mcp_status "github" "github"
check_mcp_status "e2b" "e2b"
check_mcp_status "sequential-thinking" "sequential-thinking"
check_mcp_status "memory" "memory"
check_mcp_status "hallucination-detector" "hallucination-detector"

echo ""
echo -e "  ${GREEN}Connected:${NC} $CONNECTED"
echo -e "  ${RED}Failed:${NC} $FAILED"

if [[ "$MCP_OUTPUT" == "TIMEOUT_OR_ERROR" ]]; then
    log_warn "Health check timed out or failed"
    log_info "Servers were added successfully - run 'claude mcp list' to verify later"
elif [[ $FAILED -gt 0 ]]; then
    log_warn "Some MCP servers failed to connect:$FAILED_SERVERS"
    log_info "This may be due to missing API keys or network issues"
    log_info "Run 'claude mcp list' for detailed status"
fi

# ============================================================================
# Summary
# ============================================================================
print_separator
echo -e "${GREEN}MCP Servers configured:${NC}"
echo ""
# Show the cached output instead of running claude mcp list again
echo "$MCP_OUTPUT" | grep -E "^[a-z].*:" | head -15 || echo "  (Run 'claude mcp list' to see configured servers)"
echo ""
echo -e "${YELLOW}Notes:${NC}"
echo "  - For Playwright on headless servers, run: ~/.local/bin/start-xvfb.sh"
echo "  - Verify with: claude mcp list"
echo "  - Test MCPs by asking Claude to use them"
echo ""
echo -e "${CYAN}MCP Servers:${NC}"
echo "  npm packages:"
echo "    - context7: @upstash/context7-mcp (Documentation lookup)"
echo "    - tavily-mcp: tavily-mcp@latest (Web search)"
echo "    - browserbase: @browserbasehq/mcp-server-browserbase (Cloud browser)"
echo "    - playwright: @playwright/mcp@latest (Local browser - Microsoft official)"
echo "    - github: @modelcontextprotocol/server-github (Repository operations)"
echo "    - e2b: @e2b/mcp-server (Sandboxed code execution)"
echo "    - sequential-thinking: @modelcontextprotocol/server-sequential-thinking"
echo "    - memory: @modelcontextprotocol/server-memory (Persistent memory)"
echo ""
echo "  Python packages:"
echo "    - hallucination-detector: Pythea/Strawberry (Requires OPENAI_API_KEY)"
echo "      Source: https://github.com/leochlon/pythea"
echo "      Usage: 'Use detect_hallucination on [your answer]'"
print_separator

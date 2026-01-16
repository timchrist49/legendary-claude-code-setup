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
    claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key "$CONTEXT7_API_KEY"
    log_success "Context7 MCP added"
else
    log_warn "Skipping Context7 (no API key provided)"
    log_info "Add later with: claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_KEY"
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
claude mcp add playwright \
    --env DISPLAY=:99 \
    --env PLAYWRIGHT_HEADLESS=true \
    --env PLAYWRIGHT_CHROMIUM_USE_HEADLESS_NEW=true \
    --env DEBIAN_FRONTEND=noninteractive \
    -- npx -y @playwright/mcp@latest --isolated --no-sandbox

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
# Pythea/Strawberry MCP (Hallucination Detection)
# ============================================================================
log_step "Setting up Pythea/Strawberry MCP"
log_info "Strawberry provides procedural hallucination detection"

log_substep "Installing pythea package..."
python3 -m pip install pythea --break-system-packages 2>/dev/null || \
    python3 -m pip install pythea

# Verify the package is installed
if python3 -c "import pythea; print('pythea ok')" 2>/dev/null; then
    log_substep "Adding Strawberry MCP server..."
    claude mcp remove strawberry 2>/dev/null || true
    claude mcp add strawberry -- python3 -m strawberry.mcp_server
    log_success "Strawberry MCP added"
else
    log_warn "pythea package installation may have failed"
    log_info "Try manually: python3 -m pip install pythea"
    log_info "Then: claude mcp add strawberry -- python3 -m strawberry.mcp_server"
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
# Summary
# ============================================================================
print_separator
echo -e "${GREEN}MCP Servers configured:${NC}"
echo ""
claude mcp list 2>/dev/null || echo "  (Run 'claude mcp list' to see configured servers)"
echo ""
echo -e "${YELLOW}Notes:${NC}"
echo "  - For Playwright on headless servers, run: ~/.local/bin/start-xvfb.sh"
echo "  - Verify with: claude mcp list"
echo "  - Test MCPs by asking Claude to use them"
echo ""
echo -e "${CYAN}Available MCP Servers:${NC}"
echo "  - context7: Documentation lookup"
echo "  - tavily-mcp: Web search and research"
echo "  - browserbase: Cloud browser automation"
echo "  - playwright: Local browser automation"
echo "  - strawberry: Hallucination detection"
echo "  - github: Repository operations, PRs, issues"
echo "  - e2b: Sandboxed code execution"
echo "  - sequential-thinking: Problem decomposition"
echo "  - memory: Persistent memory across sessions"
print_separator

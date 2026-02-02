#!/usr/bin/env bash
# 08-permissions.sh - Generate comprehensive permissions settings for Claude Code
# Creates settings.local.json with auto-approval for common operations
#
# Usage: Called during bootstrap.sh after plugin installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/utils.sh"

print_header "Configuring Auto-Approval Permissions"

# Get the actual user (not root) if running with sudo
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo "~$ACTUAL_USER")
CLAUUDE_DIR="$ACTUAL_HOME/.claude"
SETTINGS_FILE="$CLAUUDE_DIR/settings.local.json"

log_info "This script configures permissions to eliminate approval prompts"
log_info "while maintaining security through explicit allowlists"
log_info ""
log_info "Philosophy: Auto-approve common development operations"
log_info "  - Git operations (clone, commit, push, etc.)"
log_info "  - Build tools (npm, pip, python, node)"
log_info "  - File operations (read, write, edit)"
log_info "  - All Superpowers skills and workflows"
log_info "  - All GSD commands"
log_info "  - All installed MCP tools"

# ============================================================================
# Detect installed MCP servers
# ============================================================================
log_step "Detecting installed MCP servers"

declare -A MCP_TOOLS=(
    ["context7"]="mcp__context7__resolve-library-id,mcp__context7__query-docs"
    ["tavily"]="mcp__tavily__tavily_search,mcp__tavily__tavily_extract,mcp__tavily__tavily_research"
    ["browserbase"]="mcp__browserbase__browserbase_session_create,mcp__browserbase__browserbase_stagehand_navigate"
    ["playwright"]="mcp__playwright__browser_navigate,mcp__playwright__browser_click"
    ["strawberry"]="mcp__hallucination-detector__detect_hallucination,mcp__hallucination-detector__audit_trace_budget"
    ["github"]="mcp__github__create_pull_request,mcp__github__list_issues"
    ["e2b"]="mcp__e2b__run_code"
    ["sequential-thinking"]="mcp__sequential-thinking__sequentialthinking"
    ["memory"]="mcp__memory__create_entities,mcp__memory__create_relations,mcp__memory__search_nodes"
)

INSTALLED_MCP_TOOLS=()
if [[ -f "$CLAUUDE_DIR/mcp-config.json" ]]; then
    for server in "${!MCP_TOOLS[@]}"; do
        if jq -e ".mcpServers.\"$server\"" "$CLAUUDE_DIR/mcp-config.json" &>/dev/null; then
            INSTALLED_MCP_TOOLS+=("${MCP_TOOLS[$server]}")
            log_substep "Found: $server"
        fi
    done
fi

# ============================================================================
# Build permissions array
# ============================================================================
log_step "Building permissions array"

# Start with existing permissions if file exists
EXISTING_PERMISSIONS=()
if [[ -f "$SETTINGS_FILE" ]]; then
    mapfile -t EXISTING_PERMISSIONS < <(jq -r '.permissions.allow[] // empty' "$SETTINGS_FILE" 2>/dev/null)
    log_info "Found ${#EXISTING_PERMISSIONS[@]} existing permissions"
fi

# Build comprehensive allowlist
PERMISSIONS=(
    # ============================================================================
    # Git Operations
    # ============================================================================
    "Bash(git init:*)"
    "Bash(git config:*)"
    "Bash(git add:*)"
    "Bash(git commit:*)"
    "Bash(git push:*)"
    "Bash(git pull:*)"
    "Bash(git clone:*)"
    "Bash(git status:*)"
    "Bash(git diff:*)"
    "Bash(git log:*)"
    "Bash(git show:*)"
    "Bash(git branch:*)"
    "Bash(git checkout:*)"
    "Bash(git merge:*)"
    "Bash(git reset:*)"
    "Bash(git remote:*)"
    "Bash(git:*)"

    # ============================================================================
    # Build Tools - npm/yarn/pnpm
    # ============================================================================
    "Bash(npm install:*)"
    "Bash(npm update:*)"
    "Bash(npm run:*)"
    "Bash(npm:*)"
    "Bash(yarn:*)"
    "Bash(pnpm:*)"
    "Bash(npx:*)"

    # ============================================================================
    # Build Tools - Python
    # ============================================================================
    "Bash(pip install:*)"
    "Bash(pip list:*)"
    "Bash(pip:*)"
    "Bash(pip3 install:*)"
    "Bash(pip3:*)"
    "Bash(python:*)"
    "Bash(python3:*)"
    "Bash(python -m:*)"
    "Bash(python3 -m:*)"
    "Bash(python -m pytest:*)"
    "Bash(pytest:*)"

    # ============================================================================
    # Build Tools - Node.js
    # ============================================================================
    "Bash(node:*)"
    "Bash(npx playwright install:*)"

    # ============================================================================
    # File Operations
    # ============================================================================
    "Bash(mkdir:*)"
    "Bash(touch:*)"
    "Bash(cp:*)"
    "Bash(mv:*)"
    "Bash(rm:*)"
    "Bash(chmod:*)"
    "Bash(chown:*)"
    "Bash(find:*)"
    "Bash(ls:*)"
    "Bash(cat:*)"
    "Bash(head:*)"
    "Bash(tail:*)"
    "Bash(grep:*)"
    "Bash(sed:*)"
    "Bash(awk:*)"

    # ============================================================================
    # Development Tools
    # ============================================================================
    "Bash(curl:*)"
    "Bash(wget:*)"
    "Bash(jq:*)"
    "Bash(source:*)"
    "Bash(echo:*)"
    "Bash(pwd:*)"
    "Bash(cd:*)"
    "Bash(readlink:*)"
    "Bash(pkill:*)"
    "Bash(kill:*)"
    "Bash(bash:*)"
    "Bash(sh:*)"

    # ============================================================================
    # Claude Code CLI
    # ============================================================================
    "Bash(claude:*)"
    "Bash(claude plugin:*)"
    "Bash(claude mcp:*)"
    "Bash(claude --version)"

    # ============================================================================
    # Infrastructure Tools (optional)
    # ============================================================================
    "Bash(docker:*)"
    "Bash(docker-compose:*)"
    "Bash(kubectl:*)"
    "Bash(terraform:*)"

    # ============================================================================
    # Superpowers Skills
    # ============================================================================
    "Skill(superpowers:brainstorming)"
    "Skill(superpowers:writing-plans)"
    "Skill(superpowers:executing-plans)"
    "Skill(superpowers:subagent-driven-development)"
    "Skill(superpowers:systematic-debugging)"
    "Skill(superpowers:test-driven-development)"
    "Skill(superpowers:verification-before-completion)"
    "Skill(superpowers:receiving-code-review)"
    "Skill(superpowers:requesting-code-review)"
    "Skill(superpowers:finishing-a-development-branch)"
    "Skill(superpowers:using-git-worktrees)"
    "Skill(superpowers:using-superpowers)"
    "Skill(superpowers:dispatching-parallel-agents)"

    # ============================================================================
    # GSD Commands
    # ============================================================================
    "Skill(gsd:new-project)"
    "Skill(gsd:plan)"
    "Skill(gsd:execute)"
    "Skill(gsd:help)"
    "Skill(gsd:map-codebase)"
    "Skill(gsd:execute-phase)"
    "Skill(gsd:plan-phase)"
    "Skill(gsd:debug)"
    "Skill(gsd:check-todos)"
    "Skill(gsd:progress)"
    "Skill(gsd:verify-work)"
    "Skill(gsd:resume-work)"
    "Skill(gsd:pause-work)"
    "Skill(gsd:complete-milestone)"
    "Skill(gsd:audit-milestone)"
    "Skill(gsd:add-phase)"
    "Skill(gsd:remove-phase)"
    "Skill(gsd:insert-phase)"
    "Skill(gsd:research-phase)"
    "Skill(gsd:discuss-phase)"
    "Skill(gsd:list-phase-assumptions)"
    "Skill(gsd:plan-milestone-gaps)"
    "Skill(gsd:add-todo)"
    "Skill(gsd:quick)"
    "Skill(gsd:set-profile)"
    "Skill(gsd:settings)"
    "Skill(gsd:update)"
    "Skill(gsd:join-discord)"

    # ============================================================================
    # Domain Skills
    # ============================================================================
    "Skill(security-review)"
    "Skill(devsecops)"
    "Skill(research)"
)

# Add detected MCP tools
for tool in "${INSTALLED_MCP_TOOLS[@]}"; do
    IFS=',' read -ra TOOLS <<< "$tool"
    for t in "${TOOLS[@]}"; do
        PERMISSIONS+=("$t")
    done
done

# Add common MCP patterns (in case detection didn't catch them)
PERMISSIONS+=(
    "mcp__context7__*"
    "mcp__tavily__*"
    "mcp__browserbase__*"
    "mcp__playwright__*"
    "mcp__hallucination-detector__*"
    "mcp__github__*"
    "mcp__e2b__*"
    "mcp__sequential-thinking__*"
    "mcp__memory__*"
    "mcp__plugin_episodic-memory_episodic-memory__*"
)

# ============================================================================
# Merge with existing permissions (preserving user customizations)
# ============================================================================
FINAL_PERMISSIONS=()
# Add new permissions
for perm in "${PERMISSIONS[@]}"; do
    # Skip if already exists (exact match)
    if [[ ! " ${EXISTING_PERMISSIONS[*]} " =~ " ${perm} " ]]; then
        FINAL_PERMISSIONS+=("$perm")
    fi
done
# Keep all existing permissions (never remove)
for perm in "${EXISTING_PERMISSIONS[@]}"; do
    FINAL_PERMISSIONS+=("$perm")
done

# ============================================================================
# Generate JSON
# ============================================================================
log_step "Generating settings.local.json"

# Create JSON array
PERMISSIONS_JSON=$(printf '%s\n' "${FINAL_PERMISSIONS[@]}" | jq -R . | jq -s .)

# Create full settings JSON
SETTINGS_JSON=$(jq -n \
    --argjson permissions "$PERMISSIONS_JSON" \
    '{
        permissions: {
            allow: $permissions
        }
    }')

# Backup existing file
if [[ -f "$SETTINGS_FILE" ]]; then
    backup_file "$SETTINGS_FILE"
fi

# Write new settings
echo "$SETTINGS_JSON" > "$SETTINGS_FILE"

log_success "Created $SETTINGS_FILE"
log_info "Configured ${#FINAL_PERMISSIONS[@]} permissions for auto-approval"

# ============================================================================
# Summary
# ============================================================================
print_separator
echo -e "${GREEN}Permissions Configuration Complete${NC}"
echo ""
echo -e "${CYAN}What was configured:${NC}"
echo "  - Git operations (clone, commit, push, etc.)"
echo "  - Build tools (npm, pip, python, node)"
echo "  - File operations (read, write, edit)"
echo "  - All Superpowers skills"
echo "  - All GSD commands"
echo "  - All detected MCP tools"
echo ""
echo -e "${CYAN}File created:${NC}"
echo "  - $SETTINGS_FILE"
echo ""
echo -e "${YELLOW}Notes:${NC}"
echo "  - Existing permissions were preserved"
echo "  - To review permissions: cat $SETTINGS_FILE"
echo "  - To add more permissions, edit the file directly"
echo "  - Or use: claude-permissions-review (coming soon)"
print_separator

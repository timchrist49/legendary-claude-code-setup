#!/usr/bin/env bash
# permission-helper.sh - Hook to predict and auto-approve permissions
# Runs before skill-activator to eliminate permission prompts
#
# Usage: Configured in settings.json as UserPromptSubmit hook

set -euo pipefail

# Files
SETTINGS_FILE="$HOME/.claude/settings.local.json"
SUGGESTIONS_LOG="$HOME/.claude/permission-suggestions.log"
ERRORS_LOG="$HOME/.claude/permission-helper-errors.log"
MAX_LOG_ENTRIES=100

# ============================================================================
# Read input from stdin (JSON)
# ============================================================================
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""' | tr '[:upper:]' '[:lower:]')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Debug mode (set CLAUDE_PERMISSION_DEBUG=1 to enable)
if [[ "${CLAUDE_PERMISSION_DEBUG:-}" == "1" ]]; then
    echo "[DEBUG] Permission helper triggered" >&2
    echo "[DEBUG] Prompt: $PROMPT" >&2
fi

# ============================================================================
# Suggest GSD commands based on prompt context
# ============================================================================
suggest_gsd_command() {
    local prompt="$1"
    local suggestion=""

    if echo "$prompt" | grep -qiE "(new project|start project|initialize project|setup project)"; then
        suggestion="For structured project setup, consider using /gsd:new-project"
    elif echo "$prompt" | grep -qiE "(plan|planning|design|architecture)"; then
        suggestion="For implementation planning, consider using /gsd:plan or /superpowers:write-plan"
    elif echo "$prompt" | grep -qiE "(execute|implement|build|create feature)"; then
        suggestion="For task execution, consider using /gsd:execute or /superpowers:execute-plan"
    elif echo "$prompt" | grep -qiE "(debug|fix|bug|error|broken)"; then
        suggestion="For debugging, consider using /superpowers:systematic-debugging"
    fi

    if [[ -n "$suggestion" ]]; then
        echo -e "\n💡 $suggestion\n"
    fi
}

# ============================================================================
# Suggest Ralph for autonomous loops
# ============================================================================
suggest_ralph() {
    local prompt="$1"

    if echo "$prompt" | grep -qiE "(loop|autonomous|keep trying|until done|iterate|repeat)"; then
        echo -e "\n💡 For autonomous development loops that run until completion, try the 'ralph' command in a separate terminal.\n"
    fi
}

# ============================================================================
# Log permission suggestion
# ============================================================================
log_suggestion() {
    local permission="$1"
    local context="$2"

    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local entry="{\"timestamp\":\"$timestamp\",\"permission\":\"$permission\",\"context\":\"$context\"}"

    # Append to log
    echo "$entry" >> "$SUGGESTIONS_LOG"

    # Rotate log if too large
    local entry_count
    entry_count=$(wc -l < "$SUGGESTIONS_LOG" 2>/dev/null || echo "0")
    if [[ "$entry_count" -gt "$MAX_LOG_ENTRIES" ]]; then
        # Keep last MAX_LOG_ENTRIES entries
        tail -n "$MAX_LOG_ENTRIES" "$SUGGESTIONS_LOG" > "${SUGGESTIONS_LOG}.tmp"
        mv "${SUGGESTIONS_LOG}.tmp" "$SUGGESTIONS_LOG"
    fi
}

# ============================================================================
# Main execution
# ============================================================================

# Trap errors to prevent hook from blocking Claude Code
trap 'echo "[ERROR] Permission helper failed: $(date -u)" >> "$ERRORS_LOG"; exit 0' ERR

# Output suggestions based on prompt content
suggest_gsd_command "$PROMPT"
suggest_ralph "$PROMPT"

# Exit successfully (let Claude Code continue)
exit 0

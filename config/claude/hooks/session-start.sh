#!/usr/bin/env bash
# session-start.sh - SessionStart hook for context loading
# Loads project context files at the beginning of each session
#
# Usage: Called automatically via SessionStart hook
# Input: JSON via stdin with cwd (current working directory)

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract current working directory
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

if [[ -z "$CWD" ]]; then
    CWD="$(pwd)"
fi

# Build context message
CONTEXT=""

# Check for project context files
if [[ -f "$CWD/.claude/PROJECT.md" ]]; then
    CONTEXT+="📁 Project context available: .claude/PROJECT.md\n"
fi

if [[ -f "$CWD/.claude/STATE.md" ]]; then
    CONTEXT+="📋 Session state available: .claude/STATE.md\n"
fi

if [[ -f "$CWD/.claude/ROADMAP.md" ]]; then
    CONTEXT+="🗺️ Roadmap available: .claude/ROADMAP.md\n"
fi

if [[ -f "$CWD/CLAUDE.md" ]]; then
    CONTEXT+="📄 Project CLAUDE.md loaded\n"
fi

# Check for recent git activity
if [[ -d "$CWD/.git" ]]; then
    BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null || echo "unknown")
    UNCOMMITTED=$(git -C "$CWD" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    CONTEXT+="🔀 Git branch: $BRANCH"
    if [[ "$UNCOMMITTED" -gt 0 ]]; then
        CONTEXT+=" ($UNCOMMITTED uncommitted changes)"
    fi
    CONTEXT+="\n"
fi

# Output context if any was found
if [[ -n "$CONTEXT" ]]; then
    echo -e "🚀 Session Context:\n$CONTEXT"
fi

exit 0

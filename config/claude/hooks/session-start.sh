#!/usr/bin/env bash
# session-start.sh - SessionStart hook for context loading
# Loads project context files and suggests memory queries at session start
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

# Get project name from directory
PROJECT_NAME=$(basename "$CWD")

# Build context message
CONTEXT=""
GSD_CONTEXT=false
KNOWN_PROJECT=false

# Check for project context files (GSD pattern)
if [[ -f "$CWD/.claude/PROJECT.md" ]]; then
    CONTEXT+="📁 Project context: .claude/PROJECT.md\n"
    GSD_CONTEXT=true
    KNOWN_PROJECT=true
fi

if [[ -f "$CWD/.claude/STATE.md" ]]; then
    CONTEXT+="📋 Session state: .claude/STATE.md\n"
    GSD_CONTEXT=true
fi

if [[ -f "$CWD/.claude/ROADMAP.md" ]]; then
    CONTEXT+="🗺️ Roadmap: .claude/ROADMAP.md\n"
fi

if [[ -f "$CWD/CLAUDE.md" ]]; then
    CONTEXT+="📄 Project CLAUDE.md loaded\n"
    KNOWN_PROJECT=true
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
    KNOWN_PROJECT=true
fi

# Memory integration suggestions
MEMORY_SUGGESTIONS=""

if [[ "$KNOWN_PROJECT" == "true" ]]; then
    MEMORY_SUGGESTIONS+="\n💾 MEMORY INTEGRATION:\n"
    MEMORY_SUGGESTIONS+="├── Search past sessions: /search-conversations \"$PROJECT_NAME\"\n"
    MEMORY_SUGGESTIONS+="├── Recall preferences: Query Memory MCP for user preferences\n"
    MEMORY_SUGGESTIONS+="└── Context ready: Apply stored conventions and decisions\n"
else
    MEMORY_SUGGESTIONS+="\n💾 MEMORY INTEGRATION:\n"
    MEMORY_SUGGESTIONS+="├── New project? Use /gsd:new-project to set up context\n"
    MEMORY_SUGGESTIONS+="├── Returning? Search: /search-conversations \"[topic]\"\n"
    MEMORY_SUGGESTIONS+="└── Recall preferences: Query Memory MCP\n"
fi

# Tool suggestions based on context
TOOL_SUGGESTIONS=""

if [[ "$GSD_CONTEXT" == "true" ]]; then
    TOOL_SUGGESTIONS+="\n🛠️ SUGGESTED TOOLS:\n"
    TOOL_SUGGESTIONS+="├── Continue work: Read STATE.md, resume from last checkpoint\n"
    TOOL_SUGGESTIONS+="├── Plan next task: /superpowers:brainstorm or /superpowers:write-plan\n"
    TOOL_SUGGESTIONS+="└── Execute plan: /superpowers:execute-plan\n"
else
    TOOL_SUGGESTIONS+="\n🛠️ SUGGESTED TOOLS:\n"
    TOOL_SUGGESTIONS+="├── New feature: /superpowers:brainstorm to clarify requirements\n"
    TOOL_SUGGESTIONS+="├── Research: Use Context7 + Tavily for current info\n"
    TOOL_SUGGESTIONS+="└── Complex planning: Use Sequential Thinking\n"
fi

# Output context if any was found
if [[ -n "$CONTEXT" ]]; then
    echo -e "🚀 SESSION START\n"
    echo -e "📂 Project: $PROJECT_NAME\n"
    echo -e "$CONTEXT"
    echo -e "$MEMORY_SUGGESTIONS"
    echo -e "$TOOL_SUGGESTIONS"
fi

exit 0

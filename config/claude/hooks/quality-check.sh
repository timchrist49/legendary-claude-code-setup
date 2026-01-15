#!/usr/bin/env bash
# quality-check.sh - PostToolUse hook for code quality
# Runs after Edit/Write operations to catch issues early
#
# Usage: Called automatically via PostToolUse hook (matcher: Edit|Write)
# Input: JSON via stdin with tool_input containing file_path

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract the file path that was edited
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# If no file path, exit silently
if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Run appropriate checks based on file type
case "$EXT" in
    ts|tsx|js|jsx)
        # TypeScript/JavaScript - check for common issues
        if command -v npx &> /dev/null; then
            # Try to run TypeScript check if tsconfig exists
            PROJECT_DIR=$(dirname "$FILE_PATH")
            while [[ "$PROJECT_DIR" != "/" ]]; do
                if [[ -f "$PROJECT_DIR/tsconfig.json" ]]; then
                    echo "📋 TypeScript check recommended: Run 'npx tsc --noEmit' in $PROJECT_DIR"
                    break
                fi
                PROJECT_DIR=$(dirname "$PROJECT_DIR")
            done
        fi
        ;;
    py)
        # Python - suggest type checking
        if command -v mypy &> /dev/null || command -v pyright &> /dev/null; then
            echo "📋 Python type check recommended for: $FILE_PATH"
        fi
        ;;
    rs)
        # Rust - suggest cargo check
        echo "📋 Rust check recommended: Run 'cargo check'"
        ;;
    go)
        # Go - suggest go vet
        echo "📋 Go check recommended: Run 'go vet ./...'"
        ;;
esac

# Always remind about testing
echo "💡 Remember: Run tests after significant changes"

exit 0

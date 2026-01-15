#!/usr/bin/env bash
# skill-activator.sh - UserPromptSubmit hook for reliable skill activation
# This hook ensures Claude evaluates available skills before proceeding
#
# Usage: Called automatically via UserPromptSubmit hook
# Input: JSON via stdin with prompt, session_id, etc.

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract the prompt text
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# If no prompt, exit silently
if [[ -z "$PROMPT" ]]; then
    exit 0
fi

# Output instruction for Claude to evaluate skills
# Using the "forced eval" approach for ~84% activation rate
cat << 'EOF'
🎯 SKILL EVALUATION REQUIRED

Before proceeding with the request, evaluate each available skill:

1. Check the skill descriptions in ~/.claude/skills/*/SKILL.md
2. For EACH skill, determine: Does this request match the skill's purpose?
3. State your evaluation: "Skill [name]: YES/NO - [one-line reason]"
4. If YES for any skill, activate it using: Skill(skill-name)
5. Then proceed with the user's request

Available skills to evaluate:
- planning: For new features, projects, or multi-step tasks before coding
- implementation: For writing, modifying, or refactoring code
- debugging: For investigating bugs, errors, or unexpected behavior
- testing: For writing tests, TDD, or test-related work
- research: For gathering information or making technology decisions

Evaluate now, then proceed.
EOF

exit 0

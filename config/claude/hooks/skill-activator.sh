#!/usr/bin/env bash
# skill-activator.sh - UserPromptSubmit hook for workflow activation
# Routes to Superpowers workflows OR domain skills based on request type
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

# Convert prompt to lowercase for pattern matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Detect request type and route appropriately
ROUTE=""
SKILL=""

# Pattern matching for request types
if echo "$PROMPT_LOWER" | grep -qE '(build|create|add|implement|make|develop|feature|new)'; then
    ROUTE="superpowers"
    ACTION="feature"
elif echo "$PROMPT_LOWER" | grep -qE '(fix|bug|error|issue|debug|broken|not working|crash)'; then
    ROUTE="superpowers"
    ACTION="debug"
elif echo "$PROMPT_LOWER" | grep -qE '(plan|design|architect|strategy|roadmap)'; then
    ROUTE="superpowers"
    ACTION="plan"
elif echo "$PROMPT_LOWER" | grep -qE '(security|auth|password|encrypt|vulnerability|owasp|penetration|xss|sql injection|csrf)'; then
    ROUTE="skill"
    SKILL="security-review"
elif echo "$PROMPT_LOWER" | grep -qE '(deploy|ci/cd|docker|kubernetes|pipeline|devops|infrastructure|github actions)'; then
    ROUTE="skill"
    SKILL="devsecops"
elif echo "$PROMPT_LOWER" | grep -qE '(research|compare|evaluate|which|best|recommend|options|alternatives)'; then
    ROUTE="skill"
    SKILL="research"
fi

# Output routing guidance
if [[ "$ROUTE" == "superpowers" ]]; then
    case "$ACTION" in
        "feature")
            cat << 'EOF'
🚀 SUPERPOWERS WORKFLOW REQUIRED

This is a feature/implementation request. Follow the MANDATORY workflow:

1. FIRST: Use /superpowers:brainstorm
   - Clarify requirements before ANY coding
   - Present design options for approval

2. THEN: Use /superpowers:write-plan
   - Create detailed implementation plan
   - Include file paths, code snippets, tests

3. FINALLY: Use /superpowers:execute-plan
   - Execute in reviewed batches
   - Use sub-agents for parallel work if needed

⚠️ DO NOT skip straight to coding. Brainstorm first.
EOF
            ;;
        "debug")
            cat << 'EOF'
🐛 SUPERPOWERS DEBUGGING WORKFLOW REQUIRED

This is a debugging request. Use structured debugging:

Use /superpowers:systematic-debugging
- Step 1: Reproduce the issue
- Step 2: Isolate the cause
- Step 3: Fix with minimal changes
- Step 4: Verify the fix

⚠️ DO NOT guess at fixes. Follow the systematic process.
EOF
            ;;
        "plan")
            cat << 'EOF'
📋 SUPERPOWERS PLANNING WORKFLOW REQUIRED

This is a planning request. Follow the structured approach:

1. Use /superpowers:brainstorm to clarify the scope
2. Use /superpowers:write-plan to create detailed plan
3. Use Sequential Thinking for complex analysis

⚠️ DO NOT create ad-hoc plans. Use the structured workflow.
EOF
            ;;
    esac
elif [[ "$ROUTE" == "skill" ]]; then
    cat << EOF
🎯 DOMAIN SKILL ACTIVATED: @${SKILL}

Load and follow the skill guidance from:
~/.claude/skills/${SKILL}/SKILL.md

This skill provides domain expertise for this type of request.
After applying the skill, use Superpowers workflows for implementation.
EOF
else
    # No specific route detected, provide general guidance
    cat << 'EOF'
💡 WORKFLOW REMINDER

For feature work: Use /superpowers:brainstorm → /superpowers:write-plan → /superpowers:execute-plan
For debugging: Use /superpowers:systematic-debugging
For security: Load @security-review skill
For deployments: Load @devsecops skill
For research: Load @research skill
EOF
fi

exit 0

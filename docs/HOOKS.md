# Hooks System

This document explains the hooks installed by Claude Code Super Setup and how they ensure reliable skill activation and code quality.

## The Problem

Claude Code skills are designed to be "model-invoked" - Claude should automatically decide when to use them based on their descriptions. However, research shows that **without hooks, skills only activate 20-50% of the time**.

## The Solution

We install three hooks that run automatically:

1. **skill-activator.sh** - Forces skill evaluation before each request
2. **quality-check.sh** - Suggests quality checks after file edits
3. **session-start.sh** - Loads project context at session start

## Hook Details

### 1. Skill Activator (UserPromptSubmit)

**When:** Before Claude processes your message

**What it does:**
- Injects instructions requiring Claude to evaluate each available skill
- Uses the "forced eval" approach that achieves ~84% activation rate
- Claude must state YES/NO for each skill before proceeding

**Example output:**
```
🎯 SKILL EVALUATION REQUIRED

Before proceeding with the request, evaluate each available skill:
- planning: For new features, projects, or multi-step tasks before coding
- implementation: For writing, modifying, or refactoring code
...
```

### 2. Quality Check (PostToolUse)

**When:** After Claude uses Edit or Write tools

**What it does:**
- Detects file type from extension
- Suggests appropriate quality checks (TypeScript, Python, Rust, Go)
- Reminds about running tests

**Example output:**
```
📋 TypeScript check recommended: Run 'npx tsc --noEmit' in /project
💡 Remember: Run tests after significant changes
```

### 3. Session Start (SessionStart)

**When:** At the beginning of each Claude Code session

**What it does:**
- Checks for project context files (PROJECT.md, STATE.md, ROADMAP.md)
- Shows current git branch and uncommitted changes
- Provides session context summary

**Example output:**
```
🚀 Session Context:
📁 Project context available: .claude/PROJECT.md
📋 Session state available: .claude/STATE.md
🔀 Git branch: feature/new-auth (3 uncommitted changes)
```

## Configuration

Hooks are configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/skill-activator.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/quality-check.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

## Available Hook Events

| Event | When it Fires | Common Uses |
|-------|--------------|-------------|
| `UserPromptSubmit` | Before processing user message | Add context, validate prompts, skill activation |
| `PreToolUse` | Before a tool runs | Block dangerous operations |
| `PostToolUse` | After a tool completes | Linting, formatting, quality checks |
| `SessionStart` | When session begins | Load context, environment setup |
| `Stop` | When Claude finishes responding | Notifications, summaries |
| `Notification` | When Claude sends an alert | Custom notifications |

## Customizing Hooks

### Disabling a Hook

Remove or comment out the hook in `~/.claude/settings.json`.

### Adding a Custom Hook

1. Create your script in `~/.claude/hooks/`:
```bash
#!/usr/bin/env bash
# my-hook.sh
INPUT=$(cat)  # Read JSON from stdin
# Your logic here
echo "Output to add to context"
exit 0
```

2. Make it executable:
```bash
chmod +x ~/.claude/hooks/my-hook.sh
```

3. Add to settings.json:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/my-hook.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Input Format

Hooks receive JSON via stdin. Example for UserPromptSubmit:
```json
{
  "prompt": "the user's message",
  "session_id": "uuid",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "permission_mode": "default",
  "hook_event_name": "UserPromptSubmit"
}
```

### Hook Output

- **Exit code 0**: Success, stdout added to context
- **Exit code non-0**: Hook failed, may block operation
- **JSON output**: Use `additionalContext` field for discrete injection:
```json
{
  "decision": "block",
  "reason": "Explanation shown to user",
  "hookSpecificOutput": {
    "additionalContext": "Context added silently"
  }
}
```

## Troubleshooting

### Hooks Not Running

1. Check file permissions: `ls -la ~/.claude/hooks/`
2. Verify settings.json syntax: `cat ~/.claude/settings.json | jq .`
3. Check for errors: Run Claude Code with `--debug` flag

### Skill Activation Still Inconsistent

The forced eval approach achieves ~84% activation. For critical tasks:
- Explicitly invoke: `Skill(skill-name)` in your prompt
- Or prefix with: "Use the planning skill to..."

### Hook Slowing Down Sessions

- Keep hooks lightweight (< 100ms)
- Avoid network calls in UserPromptSubmit
- Use background processing for heavy tasks

## References

- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks)
- [Skills Activation Research](https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably)
- [6 Months of Hardcore Use](https://dev.to/diet-code103/claude-code-is-a-beast-tips-from-6-months-of-hardcore-use-572n)

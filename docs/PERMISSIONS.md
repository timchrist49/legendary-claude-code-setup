# Permissions System

## Overview

The Legendary Claude Code Setup includes an autonomous permissions system that eliminates approval prompts while maintaining security through explicit allowlists.

## How It Works

### Component 1: Comprehensive Permissions Settings

The `08-permissions.sh` script generates `~/.claude/settings.local.json` with 100+ pre-approved operations:

- **Git operations**: clone, commit, push, pull, branch, etc.
- **Build tools**: npm, yarn, pnpm, pip, python, node
- **File operations**: mkdir, touch, cp, mv, rm, chmod
- **Superpowers skills**: All workflows (brainstorm, write-plan, execute-plan, etc.)
- **GSD commands**: All 30+ GSD slash commands
- **MCP tools**: All installed MCP servers (Context7, Tavily, etc.)

### Component 2: Permission Helper Hook

The `permission-helper.sh` hook runs before each prompt to:

1. Analyze the prompt context
2. Suggest appropriate GSD commands (e.g., `/gsd:new-project` for new projects)
3. Suggest Ralph for autonomous loop workflows
4. Log any permission suggestions for later review

### Component 3: Permission Suggestion System

When a permission isn't in the allowlist, it's logged to `~/.claude/permission-suggestions.log`. Use `claude-permissions-review` to review and batch-approve suggestions.

## Usage

### Initial Setup

Permissions are automatically configured during `./bootstrap.sh`. No manual action needed.

### Reviewing Suggestions

```bash
claude-permissions-review          # Interactive review
claude-permissions-review --auto   # Auto-approve all
```

### Manually Adding Permissions

Edit `~/.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(custom-command:*)",
      "Skill(custom:skill)"
    ]
  }
}
```

## Security Philosophy

**Auto-approve common, safe operations:**
- Development tools (git, npm, python)
- File operations within project directory
- Skills and workflows (non-destructive)

**Explicit approval for risky operations:**
- System-level commands (rm -rf /, etc.)
- Network operations to unknown hosts
- Credential access

## Troubleshooting

### Permission prompts still appearing

1. Check if permission is in allowlist:
   ```bash
   cat ~/.claude/settings.local.json | jq '.permissions.allow'
   ```

2. Restart Claude Code after changing settings

3. Check permissions suggestions log:
   ```bash
   cat ~/.claude/permission-suggestions.log
   ```

### Ralph command not found

The PATH should be configured automatically. If not:

```bash
# Add to ~/.bashrc manually
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## File Locations

| File | Purpose |
|------|---------|
| `~/.claude/settings.local.json` | Auto-approval permissions |
| `~/.claude/hooks/permission-helper.sh` | Suggestion hook |
| `~/.claude/permission-suggestions.log` | Denied permission log |
| `~/.local/bin/claude-permissions-review` | Review command |
| `~/.claude/permission-helper-errors.log` | Error log |

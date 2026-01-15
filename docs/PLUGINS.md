# Claude Code Plugins Guide

> Plugins extend Claude Code with additional skills, workflows, and capabilities.

## Important Note

**Plugins must be installed inside Claude Code**, not from the shell. Start Claude Code first:

```bash
claude
```

Then run the `/plugin` commands inside the Claude Code interface.

## Plugin Marketplace Setup

First, add the Superpowers marketplace:

```
/plugin marketplace add obra/superpowers-marketplace
```

This gives you access to the curated collection of plugins.

## Recommended Plugins

### 1. Superpowers (Essential)

The core workflow plugin that provides structured development practices.

**Install:**

```
/plugin install superpowers@superpowers-marketplace
```

**Verify:**

```
/help
```

You should see:
- `/superpowers:brainstorm` - Interactive design refinement
- `/superpowers:write-plan` - Create implementation plan
- `/superpowers:execute-plan` - Execute plan in batches

**Usage:**

```
/superpowers:brainstorm
# Claude will guide you through requirements clarification

/superpowers:write-plan
# Creates a detailed implementation plan

/superpowers:execute-plan
# Executes the plan in controlled batches
```

**Documentation:** [github.com/obra/superpowers](https://github.com/obra/superpowers)

### 2. Episodic Memory (Recommended)

Provides cross-session memory so Claude remembers decisions and patterns.

**Install:**

```
/plugin install episodic-memory@superpowers-marketplace
```

**How it works:**

- Automatically stores important decisions and patterns
- Retrieves relevant memories when working on similar tasks
- Helps maintain consistency across sessions

**Documentation:**
- [Blog post explaining the concept](https://blog.fsck.com/2025/10/23/episodic-memory/)
- [Plugin listing](https://www.claudepluginhub.com/plugins/obra-episodic-memory)

### 3. SuperClaude (Optional - Advanced)

A more comprehensive framework that modifies Claude Code behavior.

**Warning:** SuperClaude modifies your MCP configuration. Back up first!

**Backup:**

```bash
curl -o /tmp/backup-claude.sh https://raw.githubusercontent.com/SuperClaude-Org/SuperClaude_Plugin/main/scripts/backup-claude-config.sh
chmod +x /tmp/backup-claude.sh
/tmp/backup-claude.sh
```

**Install (inside Claude Code):**

```
/plugin marketplace add SuperClaude-Org/SuperClaude_Plugin
/plugin install sc@superclaude
```

**Documentation:** [github.com/SuperClaude-Org/SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework)

## Additional Plugins Available

From the Superpowers marketplace:

| Plugin | Install Command | Description |
|--------|-----------------|-------------|
| Elements of Style | `/plugin install elements-of-style@superpowers-marketplace` | Writing guidance |
| Developing for Claude Code | `/plugin install superpowers-developing-for-claude-code@superpowers-marketplace` | Plugin development skills |

## Plugin Management

### List Installed Plugins

```
/plugin list
```

### Uninstall a Plugin

```
/plugin uninstall PLUGIN_NAME
```

### Update a Plugin

```
/plugin update PLUGIN_NAME@MARKETPLACE
```

### View Plugin Help

```
/help PLUGIN_NAME
```

## Troubleshooting

### Plugin Not Found

Ensure you've added the marketplace first:

```
/plugin marketplace add obra/superpowers-marketplace
```

### Commands Not Showing in /help

Try restarting Claude Code:

```bash
# Exit Claude Code and restart
claude
```

### Plugin Conflicts

If you experience issues after installing multiple plugins:

1. Note which plugins are installed: `/plugin list`
2. Uninstall conflicting plugins one by one
3. Test after each uninstall to identify the conflict

### Resetting Plugin State

If plugins are misbehaving:

```bash
# Backup first
cp -r ~/.claude ~/.claude.backup

# Remove plugin cache (paths may vary)
rm -rf ~/.claude/plugins/cache/*

# Restart Claude Code
claude
```

## Best Practices

1. **Start with Superpowers** - It's the foundation for structured development
2. **Add Episodic Memory** - Improves consistency across sessions
3. **Be cautious with SuperClaude** - It's powerful but modifies core behavior
4. **Read plugin docs** - Each plugin has specific usage patterns
5. **Test incrementally** - Install one plugin at a time and verify it works

## Creating Your Own Plugins

See the "Developing for Claude Code" plugin:

```
/plugin install superpowers-developing-for-claude-code@superpowers-marketplace
```

This provides skills and documentation for creating your own plugins.

## References

- [Superpowers Marketplace](https://github.com/obra/superpowers-marketplace)
- [Superpowers Core](https://github.com/obra/superpowers)
- [Claude Plugin Hub](https://www.claudepluginhub.com)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)

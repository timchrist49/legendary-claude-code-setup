# Quick Reference Guide

> All keywords, triggers, and commands at a glance.

## Everything Is Automated!

You don't need to memorize keywords. The hooks and CLAUDE.md automatically route your requests to the right tools. Just describe what you need naturally.

---

## Slash Commands (User-Invoked)

### Superpowers Workflow
| Command | Purpose |
|---------|---------|
| `/superpowers:brainstorm` | Clarify requirements before coding |
| `/superpowers:write-plan` | Create detailed implementation plan |
| `/superpowers:execute-plan` | Execute plan in reviewed batches |
| `/superpowers:systematic-debugging` | Reproduce → Isolate → Fix → Verify |

### GSD (Get Shit Done)
| Command | Purpose |
|---------|---------|
| `/gsd:new-project` | Initialize project with PROJECT.md, STATE.md, ROADMAP.md |
| `/gsd:plan` | Create implementation plan |
| `/gsd:execute` | Execute the plan |
| `/gsd:help` | Show all GSD commands |

### Plugins
| Command | Purpose |
|---------|---------|
| `/search-conversations` | Search past Claude Code sessions (Episodic Memory) |
| `/code-review` | Run automated code review |

---

## Auto-Triggered Tools (No Keywords Needed)

These tools activate automatically based on context:

| When You... | Claude Automatically Uses |
|-------------|---------------------------|
| Ask about unfamiliar libraries | Context7 + Tavily |
| Need current information | Tavily web search |
| Work on security/auth/payment | Hallucination detector (Strawberry) |
| Plan complex features (>3 parts) | Sequential Thinking |
| Start a session on a known project | Episodic Memory + Memory MCP |
| Say "I prefer X" or state a preference | Memory MCP (stores it) |
| Make architecture decisions | Memory MCP (stores rationale) |
| Work on untrusted code | E2B sandbox |
| Work on UI/frontend | frontend-design plugin |
| Need PR review | code-review plugin |
| Finish coding session | code-simplifier suggestions |

---

## Natural Language Triggers

You can also use natural language to trigger specific tools:

### MCP Servers
```
"Use Context7 to find Next.js 15 docs"
"Search for current AI coding assistants" → Tavily
"Create a PR for this branch" → GitHub MCP
"Run this in a sandbox" → E2B
"Use sequential thinking to plan this" → Sequential Thinking
"Remember that I prefer TypeScript" → Memory MCP
"Use Browserbase to scrape this URL" → Browserbase
"Use Playwright to test this UI" → Playwright
"Verify this with Strawberry" → Hallucination detector
```

### Skills
```
"Review this code for security vulnerabilities" → security-review skill
"Set up CI/CD for this project" → devsecops skill
"Research the best approach for X" → research skill
```

### Plugins
```
"Recommend automations for this project" → claude-code-setup
"Update CLAUDE.md with our decisions" → claude-md-management
"Review this pull request" → code-review
"Simplify this code" → code-simplifier
"Create a dashboard UI" → frontend-design
```

---

## Verification Commands

```bash
# Check MCP servers
claude mcp list

# Check plugins
claude plugin list

# Check hooks are configured
cat ~/.claude/settings.json | jq '.hooks'

# Verify Claude Code
claude --version
```

---

## File Locations

| File | Purpose |
|------|---------|
| `~/.claude/CLAUDE.md` | Main context (auto-loaded every session) |
| `~/.claude/RULES.md` | 14 behavioral rules |
| `~/.claude/PRINCIPLES.md` | Development principles |
| `~/.claude/settings.json` | Hooks configuration |
| `~/.claude/hooks/` | 3 automation scripts |
| `~/.claude/skills/` | 3 domain skills |
| `~/.claude/MCP/` | MCP & plugin guidelines |
| `~/.claude-memory/` | Memory MCP storage |

---

## Hook Triggers

| Hook | When It Runs | What It Does |
|------|--------------|--------------|
| `session-start.sh` | Every session start | Loads PROJECT.md context, suggests memory queries |
| `skill-activator.sh` | Every user prompt | Routes to Superpowers or domain skills |
| `quality-check.sh` | After Edit/Write | Suggests quality checks |

---

## Emergency Commands

```bash
# Reload shell after installation
source ~/.bashrc

# Restart Claude Code
# Just exit and run 'claude' again

# Start Xvfb for headless Playwright
~/.local/bin/start-xvfb.sh

# Check for errors in hooks
cat ~/.claude/hooks/*.sh

# Reset plugin state
cp -r ~/.claude ~/.claude.backup
rm -rf ~/.claude/plugins/cache/*
```

---

## Summary

1. **Just describe what you need** - hooks route automatically
2. **Use `/superpowers:*` for any feature work** - this is enforced
3. **Use `/gsd:*` for project management** - roadmaps, plans, execution
4. **MCPs trigger automatically** - based on context
5. **Plugins activate when relevant** - no keywords needed

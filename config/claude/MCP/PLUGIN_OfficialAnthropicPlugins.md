# Official Anthropic Plugins

> 5 plugins from anthropics/claude-plugins-official marketplace

## Installation

These plugins are installed automatically via `claude plugin install {name}@claude-plugins-official`.

## Plugins

### 1. claude-code-setup

**Purpose:** Analyzes codebases and recommends tailored Claude Code automations.

**What It Recommends:**
- MCP Servers - External integrations (context7 for docs, Playwright for frontend)
- Skills - Packaged expertise (Plan agent, frontend-design)
- Hooks - Automatic actions (auto-format, auto-lint, block sensitive files)
- Subagents - Specialized reviewers (security, performance, accessibility)
- Slash Commands - Quick workflows (/test, /pr-review, /explain)

**Usage:**
```
"recommend automations for this project"
"help me set up Claude Code"
"what hooks should I use?"
```

**Note:** This skill is read-only - it analyzes but doesn't modify files.

---

### 2. claude-md-management

**Purpose:** Manages CLAUDE.md files for project context.

**Usage:**
```
"update CLAUDE.md with our decisions"
"add this pattern to CLAUDE.md"
```

---

### 3. code-review

**Purpose:** Automated PR code review using multiple specialized agents with confidence-based scoring.

**Command:** `/code-review`

**Features:**
- 5 parallel Sonnet agents analyzing different aspects
- CLAUDE.md compliance checking
- Bug detection
- Historical context analysis
- PR history review
- Code comment analysis

**Usage:**
```
/code-review                    # Run automated review
"review this PR"
"check this code for issues"
```

---

### 4. code-simplifier

**Purpose:** Simplifies and refines code for clarity, consistency, and maintainability while preserving exact functionality.

**Key Principles:**
1. **Preserve Functionality** - Never changes what code does, only how it does it
2. **Apply Project Standards** - Follows CLAUDE.md coding standards
3. **Enhance Clarity** - Simplifies structure without over-compacting

**When to Use:**
- After long coding sessions
- Before creating pull requests
- After complex refactors

**Usage:**
```
"run code-simplifier on the changes we made today"
"simplify this code while preserving functionality"
"clean up these changes before we create the PR"
```

**Note:** Runs on Opus and focuses on recently modified code by default.

---

### 5. frontend-design

**Purpose:** Generates distinctive, production-grade frontend interfaces that avoid generic AI aesthetics.

**What It Creates:**
- Bold aesthetic choices
- Distinctive typography and color palettes
- High-impact animations and visual details
- Context-aware implementation

**Usage:**
```
"Create a dashboard for a music streaming app"
"Build a landing page for an AI security startup"
"Design a settings panel with dark mode"
```

**Auto-Trigger:** Claude automatically uses this skill for frontend work.

**Reference:** See the [Frontend Aesthetics Cookbook](https://github.com/anthropics/claude-cookbooks/blob/main/coding/prompting_for_frontend_aesthetics.ipynb) for detailed guidance.

---

## Auto-Trigger Rules

| Plugin | Auto-Activated When |
|--------|---------------------|
| claude-code-setup | User asks about setting up Claude Code, hooks, automations |
| claude-md-management | User wants to update project context |
| code-review | `/code-review` command or PR review requested |
| code-simplifier | User asks to simplify/clean up code |
| frontend-design | Any frontend/UI implementation work |

## Best Practices

1. **code-simplifier + code-review**: Run simplifier first, then review
2. **frontend-design**: Give clear aesthetic direction for best results
3. **claude-code-setup**: Run on new projects to get recommendations
4. **Always review changes** before committing (especially code-simplifier)

# Superpowers Plugin Guidelines

> Superpowers provides structured development workflows with skills, hooks, and slash commands.

## Purpose

Superpowers transforms Claude Code into a methodical development partner that:
- Brainstorms before coding
- Plans before implementing
- Executes in reviewed batches
- Follows consistent patterns

## Key Commands

### /superpowers:brainstorm
**When to use:** Starting any non-trivial feature or task

```
TRIGGERS:
├── User describes a new feature
├── Requirements are unclear
├── Multiple approaches possible
├── Complex task starting
└── "Let's build X" requests

WHAT IT DOES:
├── Asks clarifying questions
├── Explores requirements
├── Identifies edge cases
├── Surfaces assumptions
└── Creates shared understanding
```

**Example prompts:**
```
"Let's brainstorm the authentication system"
"I want to add a dashboard - brainstorm with me"
/superpowers:brainstorm "payment integration"
```

### /superpowers:write-plan
**When to use:** Before implementing anything complex

```
TRIGGERS:
├── After brainstorming completes
├── Multi-file changes needed
├── Feature spans multiple components
├── User says "plan this out"
└── Task requires >30 minutes work

WHAT IT DOES:
├── Creates structured implementation plan
├── Breaks work into atomic tasks
├── Identifies dependencies
├── Sets verification checkpoints
└── Writes plan to markdown file
```

**Example prompts:**
```
"Write a plan for the user registration feature"
/superpowers:write-plan "API refactoring"
"Plan the database migration"
```

### /superpowers:execute-plan
**When to use:** When you have a plan ready to implement

```
TRIGGERS:
├── Plan file exists
├── User approves the plan
├── Ready to start coding
└── "Execute the plan" request

WHAT IT DOES:
├── Works through plan in batches
├── Pauses for review at checkpoints
├── Tracks progress in plan file
├── Commits after each batch
└── Handles errors gracefully
```

**Example prompts:**
```
"Execute the plan we created"
/superpowers:execute-plan
"Start working on the plan"
```

## Workflow Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                 SUPERPOWERS WORKFLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. BRAINSTORM (/superpowers:brainstorm)                    │
│     └─► Clarify requirements                                 │
│     └─► Identify constraints                                 │
│     └─► Surface assumptions                                  │
│                                                              │
│  2. PLAN (/superpowers:write-plan)                          │
│     └─► Create implementation plan                           │
│     └─► Break into atomic tasks                              │
│     └─► Set checkpoints                                      │
│                                                              │
│  3. EXECUTE (/superpowers:execute-plan)                     │
│     └─► Work in batches                                      │
│     └─► Review at checkpoints                                │
│     └─► Track progress                                       │
│                                                              │
│  4. VERIFY                                                   │
│     └─► Test each batch                                      │
│     └─► Commit working code                                  │
│     └─► Update plan status                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Integration with Other Tools

### With GSD
```
/gsd:new-project          # Set up project context
/superpowers:brainstorm   # Clarify the first feature
/superpowers:write-plan   # Plan implementation
/superpowers:execute-plan # Do the work
Update STATE.md           # Track progress (GSD pattern)
```

### With Sequential Thinking
```
For complex architecture decisions:
1. Use Sequential Thinking to analyze options
2. Use /superpowers:brainstorm to validate with user
3. Use /superpowers:write-plan for implementation
```

### With Memory MCP
```
During brainstorm:
└─► Store important decisions to Memory MCP

During execution:
└─► Recall preferences from Memory MCP
└─► Apply learned patterns
```

## When to Use vs Skip

### USE Superpowers for:
- New features
- Complex refactoring
- Multi-component changes
- Unclear requirements
- Anything taking >1 hour

### SKIP Superpowers for:
- Simple bug fixes
- One-line changes
- Documentation updates
- Formatting changes
- User explicitly wants speed

## Auto-Invocation Triggers

Claude should AUTOMATICALLY suggest Superpowers when:

```
BRAINSTORM triggers:
├── "I want to build..."
├── "Let's add a feature for..."
├── "Can you help me with..."
├── Complex feature descriptions
└── Multiple requirements mentioned

WRITE-PLAN triggers:
├── After brainstorm completes
├── "How should we implement this?"
├── Multi-step task described
├── "Plan out the..."
└── Feature affects multiple files

EXECUTE-PLAN triggers:
├── Plan file exists and is approved
├── "Let's start coding"
├── "Implement the plan"
└── User confirms readiness
```

## Best Practices

1. **Always brainstorm first** for non-trivial work
2. **Keep plans atomic** - each task should be <30 minutes
3. **Review at checkpoints** - don't skip verification
4. **Update plan status** - mark completed tasks
5. **Store decisions** - use Memory MCP for learnings

---

*Superpowers transforms ad-hoc coding into methodical development.*

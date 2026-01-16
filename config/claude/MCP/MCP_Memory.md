# Memory MCP Guidelines

> Memory MCP provides persistent memory across sessions via a local knowledge graph.

## Purpose

Store and recall information across Claude Code sessions:
- User preferences and coding style
- Project-specific patterns and decisions
- Architectural choices and rationale
- Learned conventions and shortcuts

## When to Use

**AUTOMATICALLY store when user mentions:**
- Preferences ("I prefer tabs over spaces", "Always use TypeScript")
- Project conventions ("We use kebab-case for files")
- Important decisions ("We chose PostgreSQL because...")
- Personal info relevant to work ("My timezone is PST")

**AUTOMATICALLY recall when:**
- Starting a new session on a known project
- User asks about past decisions
- Implementing something similar to previous work
- Applying learned conventions

## Available Tools

### create_entities
Store new information as entities in the knowledge graph.
```
Use for:
├── User preferences
├── Project patterns
├── Technology decisions
├── Team conventions
└── Important learnings
```

### create_relations
Link entities together to form a knowledge graph.
```
Use for:
├── Connecting related concepts
├── Building context chains
├── Mapping dependencies
└── Creating decision trees
```

### search_nodes
Search for stored information.
```
Use for:
├── Recalling preferences
├── Finding past decisions
├── Looking up conventions
├── Retrieving learned patterns
```

### open_nodes
Retrieve specific entities by name.
```
Use for:
├── Direct lookups
├── Verifying stored info
├── Checking existing knowledge
└── Updating known entities
```

### delete_entities
Remove outdated or incorrect information.
```
Use for:
├── Correcting mistakes
├── Removing stale info
├── Updating changed preferences
└── Cleaning up duplicates
```

## Memory Categories

### User Preferences
```
Store:
├── Code style (tabs/spaces, quotes, semicolons)
├── Framework preferences (React, Vue, etc.)
├── Tool preferences (npm, yarn, pnpm)
├── Communication style
└── Timezone and availability
```

### Project Knowledge
```
Store:
├── Architecture decisions (and WHY)
├── Naming conventions
├── File structure patterns
├── API design choices
└── Database schema decisions
```

### Technical Patterns
```
Store:
├── Error handling approaches
├── Testing strategies
├── Deployment procedures
├── Security practices
└── Performance optimizations
```

### Session Continuity
```
Store:
├── Current task context
├── Pending decisions
├── Blockers encountered
├── Next steps planned
└── Open questions
```

## Usage Patterns

### Starting a Session
```
1. Search for user preferences
2. Search for project-specific knowledge
3. Recall any pending tasks/decisions
4. Apply learned conventions
```

### During Work
```
1. Store important decisions made
2. Record rationale for choices
3. Note user feedback/corrections
4. Save learned patterns
```

### Ending a Session
```
1. Store current progress
2. Record next steps
3. Note any blockers
4. Save new learnings
```

## Best Practices

### 1. Be Selective
```
GOOD: Store meaningful preferences and decisions
BAD:  Store every minor interaction

Examples:
✓ "User prefers functional components in React"
✗ "User asked about React once"
```

### 2. Include Context
```
GOOD: "Chose PostgreSQL for ACID compliance in financial app"
BAD:  "Using PostgreSQL"
```

### 3. Keep Updated
```
When preferences change:
1. Delete old entity
2. Create new entity with updated info
3. Note the change reason
```

### 4. Organize with Relations
```
Connect related entities:
├── User → prefers → TypeScript
├── Project → uses → Next.js
├── Next.js → configured_with → App Router
└── TypeScript → strict_mode → enabled
```

## Integration with Other Tools

```
MEMORY WORKFLOW:
├── Session Start → Recall context
├── Research (Tavily) → Store findings
├── Decisions (Sequential Thinking) → Store rationale
├── Implementation → Store patterns learned
├── Session End → Store progress
└── Next Session → Recall everything

WITH OTHER MCPs:
├── Context7 → Store version-specific findings
├── Tavily → Store research conclusions
├── Strawberry → Store verification results
└── E2B → Store tested configurations
```

## Privacy Considerations

Memory is stored locally in `~/.claude-memory/`. Consider:
- Don't store sensitive credentials
- Don't store API keys or tokens
- Be mindful of PII
- Clear project-specific data when needed

## Example Entities

```json
{
  "entity": "user_preferences",
  "content": {
    "code_style": "2-space indent, single quotes, no semicolons",
    "frameworks": ["Next.js", "Tailwind CSS", "Prisma"],
    "testing": "Vitest with Testing Library",
    "package_manager": "pnpm"
  }
}

{
  "entity": "project_acme_app",
  "content": {
    "architecture": "Monorepo with Turborepo",
    "database": "PostgreSQL on Supabase",
    "auth": "NextAuth.js with GitHub OAuth",
    "decisions": [
      "Chose App Router for better caching",
      "Using Zod for runtime validation"
    ]
  }
}
```

---

*Memory MCP is your persistent knowledge base. Use it to build context over time.*

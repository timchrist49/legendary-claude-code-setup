# Episodic Memory Plugin Guidelines

> Episodic Memory provides semantic search across past Claude Code conversations.

## Purpose

Episodic Memory enables Claude to:
- Search past conversations for relevant context
- Find previous decisions and their rationale
- Recall discussions about specific topics
- Avoid repeating solved problems

## Key Command

### /search-conversations
**When to use:** Need context from past Claude Code sessions

```
WHAT IT DOES:
├── Searches all past Claude Code sessions
├── Uses semantic/vector search (not just keywords)
├── Finds relevant discussions
├── Returns context with timestamps
└── Works across ALL projects
```

**Example prompts:**
```
/search-conversations "authentication implementation"
"Search for our discussion about the API design"
"What did we decide about the database schema?"
"Find when we debugged the payment issue"
```

## Memory MCP vs Episodic Memory

**CRITICAL DISTINCTION:**

```
┌─────────────────────────────────────────────────────────────┐
│                    MEMORY SYSTEM CHOICE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  MEMORY MCP (create_entities)                               │
│  └─► STORE new information                                   │
│      • "Remember I prefer TypeScript"                        │
│      • "Store this architecture decision"                    │
│      • "Save that we chose PostgreSQL"                       │
│                                                              │
│  EPISODIC MEMORY (/search-conversations)                    │
│  └─► FIND past information                                   │
│      • "What did we discuss about auth?"                     │
│      • "Find our API design conversation"                    │
│      • "When did we solve the caching issue?"               │
│                                                              │
│  BOTH (at session start)                                     │
│  └─► Full context recall                                     │
│      • Episodic: relevant past discussions                   │
│      • Memory: stored preferences and decisions              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

| Action | Use This | Tool/Command |
|--------|----------|--------------|
| Store preference | Memory MCP | `create_entities` |
| Find past discussion | Episodic Memory | `/search-conversations` |
| Store decision | Memory MCP | `create_entities` |
| Search old sessions | Episodic Memory | `/search-conversations` |
| Start known project | BOTH | Memory + Episodic |

## When to Use

### AUTOMATICALLY use Episodic Memory when:

```
TRIGGERS:
├── User asks "what did we decide about..."
├── User references "our previous discussion"
├── Starting work on previously discussed topic
├── Debugging issue that may have occurred before
├── User mentions past session context
├── "Remember when we..."
├── "Find our conversation about..."
└── Need context from past work
```

### Search Patterns

**Topic-based search:**
```
/search-conversations "authentication"
/search-conversations "database design"
/search-conversations "error handling"
```

**Decision-based search:**
```
"Find when we decided on the tech stack"
"What architecture did we choose for notifications?"
"Search for the API versioning discussion"
```

**Problem-based search:**
```
"Find when we debugged the login issue"
"Search for memory leak discussion"
"What did we do about the performance problem?"
```

## Integration Patterns

### Session Start Pattern
```
1. Check for PROJECT.md, STATE.md (GSD context)
2. Search Episodic Memory for relevant past discussions
3. Query Memory MCP for user preferences
4. Combine context for current session
```

### Debugging Pattern
```
1. User reports issue
2. Search Episodic Memory: "similar issue" or error message
3. Find past debugging sessions
4. Apply learned solutions
5. Store new learnings to Memory MCP
```

### Feature Development Pattern
```
1. User requests feature
2. Search Episodic Memory: "similar feature" discussions
3. Find past architectural decisions
4. Apply consistent patterns
5. Use Superpowers for structured implementation
```

## How It Works

### Storage
- Conversations stored locally with vector embeddings
- Uses SQLite for fast queries
- Indexes automatically when sessions end
- No external API calls

### Search
- Semantic search (understands meaning, not just keywords)
- Returns relevant conversation snippets
- Includes timestamps and context
- Ranks by relevance

## Best Practices

1. **Search before starting** - Check for relevant past context
2. **Be specific** - More specific queries get better results
3. **Combine with Memory MCP** - Store important findings
4. **Don't rely solely on search** - Memory MCP for explicit preferences
5. **Use at project start** - Build context from past sessions

## Example Workflow

```
USER: "Let's work on the user dashboard"

CLAUDE's process:
1. /search-conversations "user dashboard"
   └─► Finds past discussions about dashboard design

2. /search-conversations "dashboard components"
   └─► Finds architectural decisions

3. Query Memory MCP for user preferences
   └─► Recalls: "prefers Tailwind CSS", "uses React Query"

4. Combine context
   └─► "Based on our past discussions, you wanted..."

5. /superpowers:brainstorm
   └─► Clarify current requirements
```

## Auto-Invocation Triggers

Claude should AUTOMATICALLY use Episodic Memory when:

```
IMMEDIATE TRIGGERS:
├── "What did we decide about..."
├── "Remember when we..."
├── "Our previous discussion about..."
├── "Find our conversation about..."
└── User references past context

CONTEXTUAL TRIGGERS:
├── Starting work on known topic
├── Debugging recurring issue
├── User mentions past session
├── Similar problem to past work
└── Architecture question for existing project
```

---

*Episodic Memory is your searchable history of all Claude Code sessions.*

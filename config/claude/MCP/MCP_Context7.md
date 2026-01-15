# Context7 MCP Guidelines

> Context7 provides up-to-date, version-specific documentation for libraries and frameworks.

## When to Use

**ALWAYS use Context7 for:**
- Library/framework API documentation
- Installation and setup instructions
- Configuration formats and options
- Method signatures and parameters
- Best practices from official docs
- Version-specific information

**DO NOT use for:**
- General coding questions
- Current news or events
- Information not in library docs
- Opinions or recommendations

## Usage Patterns

### Basic Documentation Lookup
```
"Use Context7 to find the [library] docs for [feature]"
"Check Context7 for how to configure [setting] in [framework]"
```

### Version-Specific Queries
```
"Use Context7 to find Next.js 15 App Router documentation"
"What's the Prisma 5.x schema syntax according to Context7?"
```

### API Reference
```
"Use Context7 to look up the [method] API in [library]"
"Find the [component] props in React documentation via Context7"
```

## Best Practices

### 1. Be Specific About Versions
```
GOOD: "Context7: Next.js 15 server actions"
BAD:  "Context7: Next.js server actions"
```

### 2. Include Library Name
```
GOOD: "Context7: Express.js middleware configuration"
BAD:  "Context7: middleware configuration"
```

### 3. Verify Against Local Code
```
After Context7 lookup:
1. Check project's package.json for actual version
2. If versions differ, note the discrepancy
3. Prefer project's version constraints
```

## Conflict Resolution

When Context7 docs conflict with local code:

1. **Check package.json** - What version is actually installed?
2. **Check lock file** - What's the resolved version?
3. **Note the conflict** - "Context7 shows X for v2, but project uses v1"
4. **Prefer local reality** - Working code > documentation

## Error Handling

If Context7 fails or returns no results:

1. **Try alternative query** - Rephrase with different terms
2. **Fall back to Tavily** - Search the web for documentation
3. **Note the gap** - "Context7 had no docs for X, verified via Tavily"

## Integration with Other Tools

```
DOCUMENTATION WORKFLOW:
├── Context7 → Official library docs
├── Tavily → Current articles, tutorials, Stack Overflow
├── Browserbase → Official website if needed
└── Strawberry → Verify claims from any source
```

---

*Context7 is the primary source for library documentation. Always try it first.*

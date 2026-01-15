# Tavily MCP Guidelines

> Tavily provides AI-powered web search for research and current information.

## When to Use

**ALWAYS use Tavily for:**
- Current news and announcements
- Pricing and availability information
- Recent blog posts and tutorials
- Stack Overflow solutions
- GitHub issues and discussions
- Comparison articles
- Current best practices

**DO NOT use for:**
- Official library documentation (use Context7)
- Static reference material
- Information that requires login
- Content behind paywalls

## Available Tools

### tavily-search
General web search with AI-powered relevance ranking.
```
Use cases:
├── "Search for latest [topic] news"
├── "Find tutorials on [subject]"
├── "Research [technology] alternatives"
└── "Look up [error message] solutions"
```

### tavily-extract
Extract content from specific URLs.
```
Use cases:
├── "Extract the main content from [URL]"
├── "Get the article text from [blog post]"
└── "Pull the documentation from [page]"
```

### tavily-crawl
Crawl websites for structured data.
```
Use cases:
├── "Crawl [site] documentation section"
├── "Get all pages under [URL path]"
└── "Map the structure of [website]"
```

## Usage Patterns

### Current Information
```
"Use Tavily to search for the latest [product] pricing"
"Search for recent [framework] release announcements"
```

### Problem Solving
```
"Use Tavily to find solutions for [error message]"
"Search for '[specific issue]' GitHub issues"
```

### Research
```
"Use Tavily to research alternatives to [technology]"
"Search for '[topic]' best practices 2025"
```

## Best Practices

### 1. Include Time Context
```
GOOD: "Tavily search: Next.js 15 features 2025"
BAD:  "Tavily search: Next.js features"
```

### 2. Use Specific Queries
```
GOOD: "Tavily: 'TypeError: Cannot read property' React useState"
BAD:  "Tavily: React error"
```

### 3. Verify Multiple Sources
```
When researching:
1. Search with primary query
2. Cross-reference with alternative terms
3. Note conflicting information
4. Prefer official sources
```

## Source Evaluation

Rate sources by reliability:

| Source Type | Reliability | Notes |
|-------------|-------------|-------|
| Official docs | Highest | But may be outdated |
| GitHub repos | High | Check stars, activity |
| Stack Overflow | Medium | Check votes, dates |
| Blog posts | Medium | Check author, date |
| Forums | Lower | Verify independently |

## Integration with Other Tools

```
RESEARCH WORKFLOW:
├── Context7 → Library docs (try first)
├── Tavily → Current info, tutorials, issues
├── Browserbase → Interactive research
└── Strawberry → Verify findings

VERIFICATION:
1. Find info via Tavily
2. Cross-check with Context7 if library-related
3. Run Strawberry check if high-stakes claim
```

## Error Handling

If Tavily returns poor results:

1. **Refine query** - Add more specific terms
2. **Try exact phrases** - Use quotes for exact match
3. **Add constraints** - Include year, site, type
4. **Fall back to Browserbase** - Direct web access

---

*Tavily is for current, web-based information. Context7 is for library docs.*

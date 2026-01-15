# Browserbase MCP Guidelines

> Browserbase provides cloud browser control for web research, extraction, and automation.

## When to Use

**ALWAYS use Browserbase for:**
- Interactive web research
- Screenshot capture
- Data extraction from dynamic sites
- Login-required content (when permitted)
- JavaScript-rendered pages
- Form interaction
- Multi-step web workflows

**DO NOT use for:**
- Simple documentation lookup (use Context7)
- Basic web search (use Tavily)
- Local browser testing (use Playwright)
- API-accessible data

## Key Capabilities

### Navigation
```
- Open URLs
- Click elements
- Fill forms
- Navigate pages
```

### Extraction
```
- Get page content
- Extract specific elements
- Capture screenshots
- Download files
```

### Interaction
```
- Click buttons
- Fill input fields
- Select dropdowns
- Handle popups
```

## Usage Patterns

### Web Research
```
"Use Browserbase to open [URL] and extract the main content"
"Navigate to [site] and capture a screenshot of the pricing page"
```

### Data Extraction
```
"Use Browserbase to extract the table data from [URL]"
"Get the list of [items] from [page]"
```

### Interactive Tasks
```
"Use Browserbase to fill out the search form on [site]"
"Navigate through the [workflow] on [website]"
```

## Best Practices

### 1. Be Specific About Targets
```
GOOD: "Extract the h1 heading and first paragraph from [URL]"
BAD:  "Get the content from [URL]"
```

### 2. Handle Dynamic Content
```
Browserbase waits for:
├── Page load completion
├── JavaScript execution
├── Dynamic content rendering

Specify if needed:
"Wait for the [element] to appear before extracting"
```

### 3. Respect Rate Limits
```
AVOID:
├── Rapid successive requests
├── Aggressive scraping
├── Bypassing anti-bot measures

INSTEAD:
├── Space out requests
├── Use Tavily for search
├── Respect robots.txt
```

## Security Considerations

```
NEVER use Browserbase to:
├── Store credentials
├── Access unauthorized content
├── Scrape personal data
├── Bypass security measures

ALWAYS:
├── Get explicit permission for login tasks
├── Handle extracted data responsibly
├── Log what was accessed
├── Delete sensitive screenshots
```

## Error Handling

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Page not loading | Check URL, try Tavily instead |
| Element not found | Wait longer, check selector |
| Blocked by site | Use Tavily, respect robots.txt |
| Timeout | Simplify request, try again |

## Integration with Other Tools

```
WEB RESEARCH WORKFLOW:
├── Tavily → Quick search for URLs/info
├── Browserbase → Deep dive into specific pages
├── Context7 → Verify against official docs
└── Strawberry → Validate extracted claims

USE CASE ROUTING:
├── "Current price of X" → Tavily (faster)
├── "Extract table from page" → Browserbase
├── "Test UI workflow" → Playwright (local)
```

---

*Browserbase is for interactive web tasks. Use Tavily for simple searches.*

# Playwright MCP Guidelines

> Playwright provides local browser automation for testing and UI workflows.

## When to Use

**ALWAYS use Playwright for:**
- UI testing and verification
- Repeatable automation workflows
- Local development testing
- Screenshot comparisons
- E2E test scenarios
- Form submission testing
- Multi-page flow testing

**DO NOT use for:**
- Web research (use Browserbase/Tavily)
- One-time data extraction (use Browserbase)
- Documentation lookup (use Context7)

## Headless Server Setup

On headless Debian/Ubuntu servers, start Xvfb first:

```bash
# Start virtual display
~/.local/bin/start-xvfb.sh

# Or manually
export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 &
```

## Key Capabilities

### Navigation
```
- Navigate to URLs
- Click elements
- Fill forms
- Wait for conditions
```

### Testing
```
- Assert element states
- Compare screenshots
- Verify content
- Check accessibility
```

### Automation
```
- Record workflows
- Replay interactions
- Generate reports
- Handle multiple tabs
```

## Usage Patterns

### Basic Testing
```
"Use Playwright MCP to open [URL] and take a screenshot"
"Test that clicking [button] navigates to [page]"
```

### Form Testing
```
"Use Playwright to fill the login form with test credentials"
"Verify the form validation shows error for invalid email"
```

### E2E Flows
```
"Use Playwright to test the complete checkout flow"
"Automate the user registration process and verify success"
```

## Best Practices

### 1. Use Stable Selectors
```
GOOD selectors (in order of preference):
├── data-testid="login-button"
├── role="button" with name
├── Unique IDs
├── Semantic elements

AVOID:
├── Brittle CSS classes
├── XPath with indexes
├── Generated class names
```

### 2. Wait for State
```
ALWAYS wait for:
├── Element visibility
├── Network idle
├── Animation completion
├── Page load

AVOID:
├── Fixed sleep() calls
├── Assuming instant state
```

### 3. Isolate Tests
```
EACH test should:
├── Start from clean state
├── Not depend on other tests
├── Clean up after itself
├── Be repeatable
```

## Error Handling

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| "Cannot open display" | Start Xvfb first |
| Element not found | Wait for visibility, check selector |
| Timeout | Increase timeout, check network |
| Sandbox error | Use --no-sandbox flag |
| Stale element | Re-query after navigation |

## Integration with Other Tools

```
TESTING WORKFLOW:
├── Playwright → Automated UI tests
├── Strawberry → Verify test coverage claims
├── Context7 → Check testing patterns
└── Tavily → Research testing approaches

USE CASE ROUTING:
├── "Verify UI works" → Playwright
├── "Extract data once" → Browserbase
├── "Find documentation" → Context7
├── "Research solutions" → Tavily
```

## Headless Configuration

The MCP is configured with these environment variables:
```
DISPLAY=:99
PLAYWRIGHT_HEADLESS=true
PLAYWRIGHT_CHROMIUM_USE_HEADLESS_NEW=true
```

Additional flags:
- `--isolated` - Isolated browser context
- `--no-sandbox` - Required for root execution

## Cleanup

After testing sessions:
```bash
# Kill stale processes
pkill -f chrome || true
pkill -f chromium || true
pkill -f playwright || true

# Clean temp files
rm -rf ~/.cache/ms-playwright/mcp-chrome-* || true
```

---

*Playwright is for repeatable testing. Use Browserbase for one-time web tasks.*

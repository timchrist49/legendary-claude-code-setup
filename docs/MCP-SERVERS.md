# MCP Servers Guide

> Model Context Protocol (MCP) servers extend Claude Code with external tools and data sources.

## Overview

MCP servers are configured via the `claude mcp` command and provide Claude with access to:

- Documentation sources (Context7)
- Web search (Tavily)
- Browser automation (Browserbase, Playwright)
- Verification tools (Strawberry)

## Managing MCP Servers

### List Configured Servers

```bash
claude mcp list
```

### Add a Server

```bash
claude mcp add SERVER_NAME -- COMMAND ARGS
```

### Remove a Server

```bash
claude mcp remove SERVER_NAME
```

### Test a Server

Inside Claude Code, ask it to use the server:

```
"Use Context7 to find documentation for React hooks"
```

---

## Context7 MCP

**Purpose:** Provides up-to-date, version-specific documentation for libraries and frameworks.

**Why it matters:** Prevents Claude from using outdated API information or deprecated methods.

### Setup

1. Get API key at [context7.com/dashboard](https://context7.com/dashboard)

2. Add the server:
   ```bash
   claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY
   ```

### Usage

```
"Use Context7 to confirm how to set up Next.js 15 with App Router"
"What's the correct Prisma schema syntax according to Context7?"
"Use Context7 to find the latest React Query installation steps"
```

### Documentation

- [GitHub: upstash/context7](https://github.com/upstash/context7)
- [Blog: Context7 MCP](https://upstash.com/blog/context7-mcp)

---

## Tavily MCP

**Purpose:** AI-powered web search for research and current information.

**Why it matters:** Enables Claude to search the web for up-to-date information, news, and research beyond its training data.

### Setup

1. Get API key at [tavily.com](https://tavily.com)

2. Add the server:
   ```bash
   claude mcp add tavily-mcp \
     --env TAVILY_API_KEY=YOUR_API_KEY \
     -- npx -y tavily-mcp@latest
   ```

### Usage

```
"Search the web for the latest news on AI regulations"
"Use Tavily to find current pricing for AWS Lambda"
"Research the latest Next.js 15 features using web search"
```

### Features

- **tavily-search**: General web search with AI-powered relevance
- **tavily-extract**: Extract content from specific URLs
- **tavily-crawl**: Crawl websites for structured data
- **tavily-map**: Map website structure

### Documentation

- [Tavily Website](https://tavily.com)
- [Tavily MCP on npm](https://www.npmjs.com/package/tavily-mcp)

---

## Browserbase MCP

**Purpose:** Cloud browser control for web research, extraction, and automation.

**Why it matters:** Allows Claude to browse the web, take screenshots, and extract data from websites.

### Setup

1. Get credentials at [browserbase.com](https://browserbase.com)

2. Add the server:
   ```bash
   claude mcp add browserbase \
     --env BROWSERBASE_API_KEY=YOUR_KEY \
     --env BROWSERBASE_PROJECT_ID=YOUR_PROJECT \
     -- npx -y @browserbasehq/mcp-server-browserbase
   ```

### Usage

```
"Use Browserbase to open example.com and extract the main heading"
"Take a screenshot of google.com using Browserbase"
"Use Browserbase to research the pricing page of [company]"
```

### Documentation

- [GitHub: browserbase/mcp-server-browserbase](https://github.com/browserbase/mcp-server-browserbase)
- [Setup Guide](https://docs.browserbase.com/integrations/mcp/setup)

---

## Playwright MCP

**Purpose:** Local browser automation for testing and UI workflows.

**Why it matters:** Enables Claude to automate browser interactions, run tests, and verify UI behavior.

### Setup

1. Install Playwright and browsers:
   ```bash
   npm install -g playwright
   npx playwright install chromium
   ```

2. Install system dependencies (for headless):
   ```bash
   sudo apt install -y libnss3 libgtk-3-0 libgbm1 xvfb
   ```

3. Add the server:
   ```bash
   claude mcp add playwright \
     --env DISPLAY=:99 \
     --env PLAYWRIGHT_HEADLESS=true \
     --env PLAYWRIGHT_CHROMIUM_USE_HEADLESS_NEW=true \
     --env DEBIAN_FRONTEND=noninteractive \
     -- npx -y @playwright/mcp@latest --isolated --no-sandbox
   ```

### Usage (Headless Server)

Before using Playwright on a headless server, start Xvfb:

```bash
~/.local/bin/start-xvfb.sh
```

Then in Claude Code:

```
"Use Playwright MCP to open example.com and take a screenshot"
"Run a browser test to verify the login form works"
"Use Playwright to automate filling out the contact form"
```

### Troubleshooting

**Browser not launching:**

```bash
# Clean up stale processes
pkill -f chrome || true
pkill -f chromium || true
pkill -f playwright || true
rm -rf ~/.cache/ms-playwright/mcp-chrome-* || true

# Reinstall browser
npx playwright install chromium
```

**Display errors:**

```bash
# Start Xvfb
export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 &
```

### Documentation

- [npm: @playwright/mcp](https://www.npmjs.com/package/@playwright/mcp)
- [Playwright Docs](https://playwright.dev)

---

## Strawberry MCP (Pythea)

**Purpose:** Procedural hallucination detection to verify Claude's reasoning.

**Why it matters:** Helps catch errors before they make it into production code.

### Setup

1. Install the Python package:
   ```bash
   pip install pythea
   ```

2. Add the server:
   ```bash
   claude mcp add strawberry -- python3 -m strawberry.mcp_server
   ```

### Usage

```
"Run Strawberry hallucination check on this implementation plan"
"Before finalizing, verify my reasoning with Strawberry"
"Use Strawberry to audit the trace budget for this solution"
```

### When to Use

- Before deploying security-sensitive code
- When making claims about billing or payments
- For complex architectural decisions
- When uncertain about a technical claim

### Documentation

- [GitHub: leochlon/pythea](https://github.com/leochlon/pythea)

---

## Server Configuration Reference

### Via CLI (Recommended)

```bash
# Basic
claude mcp add NAME -- COMMAND ARGS

# With environment variables
claude mcp add NAME \
  --env VAR1=value1 \
  --env VAR2=value2 \
  -- COMMAND ARGS

# Remove
claude mcp remove NAME
```

### Configuration File

MCP servers are stored in `~/.claude/` config files. You can also edit `~/.claude/settings.json` directly, but using `claude mcp` commands is recommended.

Example structure:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_KEY"]
    }
  }
}
```

---

## Best Practices

1. **Use Context7 for docs** - Always verify library APIs and configuration
2. **Browserbase for research** - Web scraping, screenshots, data extraction
3. **Playwright for testing** - UI automation and verification
4. **Strawberry for verification** - High-stakes decisions and security

## Common Issues

### Server Not Responding

```bash
# Check if server is configured
claude mcp list

# Remove and re-add
claude mcp remove SERVER_NAME
claude mcp add SERVER_NAME -- ...
```

### Missing Dependencies

```bash
# For Node.js servers
npm install -g @package/name

# For Python servers
pip install package-name
```

### Authentication Errors

- Verify API keys in `.env` file
- Check keys haven't expired
- Ensure correct environment variables are set

## References

- [Claude Code MCP Documentation](https://docs.anthropic.com/claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io)

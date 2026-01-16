# MCP Servers Guide

> Model Context Protocol (MCP) servers extend Claude Code with external tools and data sources.

## Overview

This setup includes **9 MCP servers**:

| Server | Purpose | API Key Required? |
|--------|---------|-------------------|
| Context7 | Documentation lookup | Yes |
| Tavily | Web search | Yes |
| Browserbase | Cloud browser | Yes |
| Playwright | Local browser | No |
| Strawberry | Hallucination detection | No |
| GitHub | Repository operations | Yes |
| E2B | Sandboxed execution | Yes |
| Sequential Thinking | Problem decomposition | No |
| Memory | Persistent cross-session memory | No |

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

## GitHub MCP

**Purpose:** Repository operations, PR workflows, and issue management.

**Why it matters:** Allows Claude to manage GitHub repos, create PRs, and handle issues without leaving the CLI.

### Setup

1. Create a Personal Access Token at [github.com/settings/tokens](https://github.com/settings/tokens)
   - Required scopes: `repo`, `read:org`, `read:user`

2. Add the server:
   ```bash
   claude mcp add github \
     --env GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_TOKEN \
     -- npx -y @modelcontextprotocol/server-github
   ```

### Usage

```
"Create a PR for this feature branch"
"List open issues with label 'bug'"
"Check CI status for PR #123"
"Search for files containing 'deprecated' in the repo"
"Create a new issue for the login bug we discussed"
```

### Available Tools

- `search_repositories` - Find repos by query
- `get_file_contents` - Read files from repos
- `create_or_update_file` - Write files to repos
- `push_files` - Push multiple files
- `create_issue` - Open new issues
- `list_issues` - Query issues
- `create_pull_request` - Open PRs
- `list_commits` - View commit history
- `create_branch` - Create new branches

### Documentation

- [npm: @modelcontextprotocol/server-github](https://www.npmjs.com/package/@modelcontextprotocol/server-github)

---

## E2B MCP

**Purpose:** Sandboxed code execution in isolated cloud environments.

**Why it matters:** Run untrusted code, test migrations, and validate scripts without risking your local system.

### Setup

1. Get API key at [e2b.dev](https://e2b.dev)

2. Add the server:
   ```bash
   claude mcp add e2b \
     --env E2B_API_KEY=YOUR_API_KEY \
     -- npx -y @e2b/mcp-server
   ```

### Usage

```
"Run this Python script in a sandbox to test it safely"
"Execute the migration script in an isolated environment first"
"Test this shell command without affecting my system"
"Validate the build script in a clean environment"
```

### Available Tools

- `create_sandbox` - Create new isolated environment
- `execute_code` - Run code in sandbox
- `install_packages` - Install dependencies
- `read_file` - Read files from sandbox
- `write_file` - Write files to sandbox
- `run_command` - Execute shell commands
- `close_sandbox` - Terminate sandbox

### Best Practices

- Use E2B for any code you haven't verified
- Test destructive operations in sandbox first
- Validate migration scripts before production
- Close sandboxes promptly (billing consideration)

### Documentation

- [E2B Website](https://e2b.dev)
- [npm: @e2b/mcp-server](https://www.npmjs.com/package/@e2b/mcp-server)

---

## Sequential Thinking MCP

**Purpose:** Structured problem decomposition through dynamic thought sequences.

**Why it matters:** Enables systematic analysis of complex problems, architecture planning, and trade-off analysis.

### Setup

No API key required:

```bash
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

### Usage

```
"Use sequential thinking to plan this architecture"
"Break down this problem step by step"
"Analyze the trade-offs between these three approaches"
"Help me think through the database schema design"
```

### When to Use

- Multi-step architectural decisions
- Complex debugging scenarios
- Trade-off analysis between approaches
- Problems with unclear scope
- Planning before implementation

### How It Works

1. Start with initial problem assessment
2. Break into logical thought steps
3. Each step can build on, question, or revise previous steps
4. Adjust total steps as understanding develops
5. Branch into alternative approaches when needed
6. Converge on verified solution

### Documentation

- [GitHub: modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)

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

## Memory MCP

**Purpose:** Persistent memory across Claude Code sessions via a local knowledge graph.

**Why it matters:** Enables Claude to remember user preferences, project decisions, and context across sessions without external services.

### Setup

No API key required:

```bash
mkdir -p ~/.claude-memory
claude mcp add memory -- npx -y @modelcontextprotocol/server-memory --memory-path ~/.claude-memory
```

### Usage

```
"Remember that I prefer TypeScript over JavaScript"
"Recall my project preferences"
"Store that we chose PostgreSQL for ACID compliance"
"What decisions have we made about the architecture?"
```

### Available Tools

- `create_entities` - Store new information
- `create_relations` - Link entities together
- `search_nodes` - Search stored information
- `open_nodes` - Retrieve specific entities
- `delete_entities` - Remove outdated info

### What to Store

| Category | Examples |
|----------|----------|
| Preferences | Code style, frameworks, testing approach |
| Decisions | Architecture choices with rationale |
| Patterns | Project-specific conventions |
| Context | Current task state, next steps |

### Data Location

Memory is stored locally in `~/.claude-memory/` as a knowledge graph. No external API calls are made.

### Best Practices

1. **Be selective** - Store meaningful info, not every interaction
2. **Include rationale** - Store WHY, not just WHAT
3. **Keep updated** - Delete outdated preferences
4. **Organize well** - Use relations to connect related entities

### Documentation

- [npm: @modelcontextprotocol/server-memory](https://www.npmjs.com/package/@modelcontextprotocol/server-memory)

---

## MCP Tool Selection Matrix

| Need | Primary Tool | Fallback |
|------|-------------|----------|
| Library/API docs | Context7 | Tavily search |
| Current news/info | Tavily search | Browserbase |
| Web scraping | Browserbase | Playwright |
| UI testing | Playwright | Browserbase |
| Verify claims | Strawberry | Context7 + Tavily |
| PR/Issue management | GitHub | Bash (gh CLI) |
| Run untrusted code | E2B | Docker sandbox |
| Complex planning | Sequential Thinking | Planning skill |
| Cross-session memory | Memory | STATE.md files |

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

---

## Best Practices

1. **Use Context7 for docs** - Always verify library APIs and configuration
2. **Use Tavily for research** - Current information, news, pricing
3. **Use GitHub for repo ops** - PRs, issues, CI status
4. **Use E2B for untrusted code** - Test before running locally
5. **Use Sequential Thinking for planning** - Complex architecture decisions
6. **Use Browserbase for research** - Web scraping, screenshots
7. **Use Playwright for testing** - UI automation and verification
8. **Use Strawberry for verification** - High-stakes decisions and security
9. **Use Memory for persistence** - Preferences, decisions, project knowledge

---

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

---

## References

- [Claude Code MCP Documentation](https://docs.anthropic.com/claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io)
- [MCP Server Directory](https://mcpservers.org)

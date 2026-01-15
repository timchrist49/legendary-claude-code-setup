# Claude Code Super Setup

> One-command bootstrap for a production-ready Claude Code environment on Debian/Ubuntu.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This repository provides automated setup for Claude Code with carefully selected tools, plugins, and MCP servers designed for rapid MVP/SaaS development.

**What's included:**

- **Claude Code CLI** - Anthropic's official agentic coding tool
- **MCP Servers**
  - [Context7](https://github.com/upstash/context7) - Up-to-date documentation in prompts
  - [Tavily](https://tavily.com) - AI-powered web search
  - [Browserbase](https://github.com/browserbase/mcp-server-browserbase) - Cloud browser automation
  - [Playwright](https://playwright.dev/) - Browser automation & testing
  - [Strawberry/Pythea](https://github.com/leochlon/pythea) - Hallucination detection
- **Plugins** (manual install inside Claude Code)
  - [Superpowers](https://github.com/obra/superpowers) - Structured development workflow
  - [Episodic Memory](https://www.claudepluginhub.com/plugins/obra-episodic-memory) - Cross-session memory
- **Tools**
  - [Ralph](https://github.com/frankbria/ralph-claude-code) - Autonomous dev loops
  - [Get Shit Done](https://github.com/glittercowboy/get-shit-done) - Spec-driven workflows

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/claude-code-super-setup.git
cd claude-code-super-setup
```

### 2. Configure API Keys

```bash
cp .env.example .env
nano .env  # Add your API keys
```

Required keys:
- `CONTEXT7_API_KEY` - Get from [context7.com/dashboard](https://context7.com/dashboard)
- `TAVILY_API_KEY` - Get from [tavily.com](https://tavily.com)
- `BROWSERBASE_API_KEY` & `BROWSERBASE_PROJECT_ID` - Get from [browserbase.com](https://browserbase.com)

### 3. Run Bootstrap

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

For non-interactive installation:

```bash
./bootstrap.sh -y
```

### 4. Install Plugins (Inside Claude Code)

After bootstrap completes, start Claude Code and run:

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
/plugin install episodic-memory@superpowers-marketplace
```

### 5. Verify Installation

```bash
./verify.sh
```

## Requirements

- **OS**: Debian 11+ / Ubuntu 20.04+
- **Privileges**: sudo access for system packages
- **Internet**: Required for downloads
- **Claude Access**: Claude Pro/Max subscription or API key

## Directory Structure

```
claude-code-super-setup/
├── bootstrap.sh           # Main entry point
├── verify.sh              # Installation verification
├── .env.example           # Environment template
├── scripts/
│   ├── utils.sh           # Shared utilities
│   ├── 01-system-deps.sh  # System packages
│   ├── 02-nodejs.sh       # Node.js installation
│   ├── 03-python.sh       # Python installation
│   ├── 04-claude-code.sh  # Claude Code CLI
│   ├── 05-mcp-servers.sh  # MCP configuration
│   └── 06-tools.sh        # Ralph, GSD, etc.
├── config/
│   ├── CLAUDE.md.template # Rules template
│   └── mcp-config.example.json
└── docs/
    ├── PLUGINS.md         # Plugin installation guide
    ├── MCP-SERVERS.md     # MCP server documentation
    └── TROUBLESHOOTING.md # Common issues
```

## Usage Options

### Full Installation (Interactive)

```bash
./bootstrap.sh
```

### Full Installation (Non-Interactive)

```bash
./bootstrap.sh -y
```

### Install Specific Component

```bash
./bootstrap.sh --only-mcp        # Only configure MCP servers
./bootstrap.sh --only-tools      # Only install Ralph/GSD
./bootstrap.sh --only-claude-code # Only install Claude Code CLI
```

### Skip Specific Component

```bash
./bootstrap.sh --skip-tools      # Skip Ralph/GSD
./bootstrap.sh --skip-mcp        # Skip MCP configuration
```

## MCP Servers

After installation, verify MCP servers with:

```bash
claude mcp list
```

### Context7

Provides up-to-date documentation for libraries and frameworks.

```
"Use Context7 to find the latest docs for Next.js 15"
```

### Tavily

AI-powered web search for research and current information.

```
"Search the web for the latest AI coding assistants"
"Use Tavily to find current pricing for Vercel"
```

### Browserbase

Cloud browser for web research and automation.

```
"Use Browserbase to open example.com and extract the main heading"
```

### Playwright

Local browser automation for testing.

```
"Use Playwright MCP to take a screenshot of example.com"
```

For headless servers, start Xvfb first:

```bash
~/.local/bin/start-xvfb.sh
```

### Strawberry

Hallucination detection before finalizing code.

```
"Run Strawberry hallucination check on this implementation plan"
```

## Plugins

Plugins must be installed inside Claude Code (not via shell):

| Plugin | Command | Purpose |
|--------|---------|---------|
| Superpowers | `/plugin install superpowers@superpowers-marketplace` | Structured dev workflow |
| Episodic Memory | `/plugin install episodic-memory@superpowers-marketplace` | Cross-session memory |

See [docs/PLUGINS.md](docs/PLUGINS.md) for detailed instructions.

## Configuration

The `~/.claude/CLAUDE.md` file configures Claude Code behavior. The template includes:

- Default workflow (spec → plan → execute → test)
- Tool usage guidelines
- Anti-hallucination protocols
- Output style preferences

Edit as needed for your workflow.

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues.

Quick fixes:

```bash
# Reload shell after installation
source ~/.bashrc

# Verify Claude Code
claude --version

# Check MCP servers
claude mcp list

# Start Xvfb for headless Playwright
~/.local/bin/start-xvfb.sh
```

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [Anthropic](https://anthropic.com) - Claude Code
- [obra](https://github.com/obra) - Superpowers, Episodic Memory
- [Upstash](https://upstash.com) - Context7
- [Browserbase](https://browserbase.com) - Browser automation
- [Playwright](https://playwright.dev) - Browser testing
- [leochlon](https://github.com/leochlon) - Pythea/Strawberry
- [frankbria](https://github.com/frankbria) - Ralph
- [glittercowboy](https://github.com/glittercowboy) - Get Shit Done

## Links

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io)
- [Superpowers](https://github.com/obra/superpowers)
- [Context7](https://github.com/upstash/context7)

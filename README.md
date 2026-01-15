# Legendary Claude Code Setup

> One-command bootstrap for a **production-ready** Claude Code environment on Debian/Ubuntu.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What's Included

### 8 MCP Servers
| Server | Purpose |
|--------|---------|
| [Context7](https://context7.com) | Up-to-date documentation lookup |
| [Tavily](https://tavily.com) | AI-powered web search |
| [Browserbase](https://browserbase.com) | Cloud browser automation |
| [Playwright](https://playwright.dev) | Local browser automation & testing |
| [Strawberry/Pythea](https://github.com/leochlon/pythea) | Hallucination detection |
| [GitHub](https://github.com/modelcontextprotocol/servers) | PR/issue management, CI status |
| [E2B](https://e2b.dev) | Sandboxed code execution |
| [Sequential Thinking](https://github.com/modelcontextprotocol/servers) | Problem decomposition |

### 7 Skills (Auto-Activated via Hooks)
| Skill | Purpose |
|-------|---------|
| `planning` | Feature/project planning before coding |
| `implementation` | Code writing workflows |
| `debugging` | Bug investigation methodology |
| `testing` | TDD and test writing |
| `research` | Information gathering |
| `security-review` | OWASP checks, threat modeling |
| `devsecops` | CI/CD, Docker, deployment |

### 3 Automation Hooks
- **skill-activator.sh** - Forces skill evaluation (~84% activation rate)
- **quality-check.sh** - Suggests checks after file edits
- **session-start.sh** - Shows project context at startup

### Plugins (Manual Install)
- [Superpowers](https://github.com/obra/superpowers) - Structured development workflow
- [Episodic Memory](https://github.com/obra/episodic-memory) - Cross-session memory

### Additional Tools
- [Ralph](https://github.com/frankbria/ralph-claude-code) - Autonomous dev loops
- [Get Shit Done](https://github.com/glittercowboy/get-shit-done) - Spec-driven workflows

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/timchrist49/legendary-claude-code-setup.git
cd legendary-claude-code-setup
```

### 2. Configure API Keys

```bash
cp .env.example .env
nano .env  # Add your API keys
```

**Required API Keys:**
| Key | Get From | Required? |
|-----|----------|-----------|
| `CONTEXT7_API_KEY` | [context7.com/dashboard](https://context7.com/dashboard) | Yes |
| `TAVILY_API_KEY` | [tavily.com](https://tavily.com) | Yes |
| `BROWSERBASE_API_KEY` | [browserbase.com](https://browserbase.com) | Optional |
| `BROWSERBASE_PROJECT_ID` | [browserbase.com](https://browserbase.com) | Optional |
| `GITHUB_TOKEN` | [github.com/settings/tokens](https://github.com/settings/tokens) | Optional |
| `E2B_API_KEY` | [e2b.dev](https://e2b.dev) | Optional |

**GitHub Token Scopes:** `repo`, `read:org`, `read:user`

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

---

## Requirements

- **OS**: Debian 11+ / Ubuntu 20.04+
- **Privileges**: sudo access for system packages
- **Internet**: Required for downloads
- **Claude Access**: Claude Pro/Max subscription or API key

---

## Directory Structure

```
legendary-claude-code-setup/
├── bootstrap.sh              # Main entry point
├── verify.sh                 # Installation verification
├── .env.example              # Environment template
│
├── scripts/
│   ├── utils.sh              # Shared utilities
│   ├── 01-system-deps.sh     # System packages
│   ├── 02-nodejs.sh          # Node.js 20.x
│   ├── 03-python.sh          # Python 3 + pip
│   ├── 04-claude-code.sh     # Claude Code CLI
│   ├── 05-mcp-servers.sh     # 8 MCP servers
│   └── 06-tools.sh           # Ralph, GSD
│
├── config/claude/
│   ├── CLAUDE.md             # Main context file
│   ├── RULES.md              # 10 behavioral rules + security baselines
│   ├── PRINCIPLES.md         # Dev principles + Definition of Done
│   ├── MCP/                  # 8 MCP guideline files
│   ├── skills/               # 7 skill definitions
│   ├── hooks/                # 3 automation hooks
│   ├── context/              # Project templates
│   └── settings.json         # Hooks configuration
│
└── docs/
    ├── PLUGINS.md            # Plugin installation guide
    ├── MCP-SERVERS.md        # MCP documentation
    ├── HOOKS.md              # Hooks system guide
    ├── SECURITY.md           # Security hardening guide
    ├── PRODUCTION-ADDENDUM.md # Advanced production guide
    └── TROUBLESHOOTING.md    # Common issues
```

---

## What Gets Installed

After running `bootstrap.sh`, you'll have:

```
~/.claude/
├── CLAUDE.md                 # Auto-loaded every session
├── RULES.md                  # Behavioral rules
├── PRINCIPLES.md             # Development principles
├── MCP/                      # MCP guidelines (8 files)
├── skills/                   # Skills (7 directories)
├── hooks/                    # Automation hooks (3 scripts)
├── context/                  # Project templates
└── settings.json             # Hooks configuration
```

---

## Usage Options

### Full Installation
```bash
./bootstrap.sh        # Interactive
./bootstrap.sh -y     # Non-interactive
```

### Install Specific Components
```bash
./bootstrap.sh --only-mcp         # Only MCP servers
./bootstrap.sh --only-tools       # Only Ralph/GSD
./bootstrap.sh --only-claude-code # Only Claude Code CLI
```

### Skip Specific Components
```bash
./bootstrap.sh --skip-tools       # Skip Ralph/GSD
./bootstrap.sh --skip-mcp         # Skip MCP configuration
```

---

## MCP Servers

Verify installed servers:
```bash
claude mcp list
```

### Context7 - Documentation
```
"Use Context7 to find Next.js 15 docs"
"What's the correct config according to Context7?"
```

### Tavily - Web Search
```
"Search for current AI coding assistants"
"Use Tavily to research Vercel pricing"
```

### GitHub - Repository Operations
```
"Create a PR for this feature branch"
"List open issues with label 'bug'"
"Check CI status for this PR"
```

### E2B - Sandboxed Execution
```
"Run this script in a sandbox first"
"Test the migration in an isolated environment"
```

### Sequential Thinking - Problem Decomposition
```
"Use sequential thinking to plan this architecture"
"Break down this problem step by step"
```

### Browserbase - Cloud Browser
```
"Use Browserbase to extract data from this URL"
```

### Playwright - Local Browser
```
"Use Playwright to test this UI workflow"
```

For headless servers:
```bash
~/.local/bin/start-xvfb.sh
```

### Strawberry - Verification
```
"Run Strawberry check on this implementation plan"
```

---

## Skills System

Skills are automatically evaluated via hooks. Available skills:

| Skill | Triggers On |
|-------|-------------|
| `planning` | New features, projects, multi-step tasks |
| `implementation` | Writing, modifying, refactoring code |
| `debugging` | Investigating bugs, errors |
| `testing` | Writing tests, TDD |
| `research` | Gathering information, decisions |
| `security-review` | Auth, sensitive data, production prep |
| `devsecops` | CI/CD, Docker, deployment |

---

## Production Features

### Security Baselines
- OWASP Top 10 checks in RULES.md
- Infrastructure security guidelines
- Logging security requirements

### Definition of Done
Built into PRINCIPLES.md:
- Functionality checklist
- Quality checklist
- Security checklist
- Operations checklist
- Release checklist

### Production Readiness Checklist
- Application readiness
- Database readiness
- Security verification
- Observability setup
- Documentation requirements

See [docs/SECURITY.md](docs/SECURITY.md) for the full security hardening guide.

---

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

# Check hooks are configured
cat ~/.claude/settings.json
```

---

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Acknowledgments

- [Anthropic](https://anthropic.com) - Claude Code
- [obra](https://github.com/obra) - Superpowers, Episodic Memory
- [Upstash](https://upstash.com) - Context7
- [Tavily](https://tavily.com) - AI Search
- [Browserbase](https://browserbase.com) - Browser automation
- [E2B](https://e2b.dev) - Code sandboxing
- [Playwright](https://playwright.dev) - Browser testing
- [leochlon](https://github.com/leochlon) - Pythea/Strawberry
- [frankbria](https://github.com/frankbria) - Ralph
- [glittercowboy](https://github.com/glittercowboy) - Get Shit Done

---

## Links

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io)
- [Repository](https://github.com/timchrist49/legendary-claude-code-setup)

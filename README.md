# Legendary Claude Code Setup

> One-command bootstrap for a **production-ready** Claude Code environment on Debian/Ubuntu.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What's Included

### 9 MCP Servers
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
| [Memory](https://github.com/modelcontextprotocol/servers) | Persistent memory across sessions |

### 3 Domain Skills (Auto-Activated via Hooks)
| Skill | Purpose |
|-------|---------|
| `security-review` | OWASP checks, threat modeling, auth/payment security |
| `devsecops` | CI/CD, Docker, Kubernetes, deployment |
| `research` | Information gathering, technology decisions |

**Note:** Planning, implementation, debugging, and testing are handled by **Superpowers workflows**, not separate skills. This enforces structured development.

### 3 Automation Hooks
- **skill-activator.sh** - Routes to Superpowers workflows OR domain skills based on request
- **quality-check.sh** - Suggests checks after file edits
- **session-start.sh** - Shows project context and memory integration suggestions

### 7 Plugins (Fully Automated!)
| Plugin | Purpose |
|--------|---------|
| [Superpowers](https://github.com/obra/superpowers) | Structured development workflow, `/superpowers:*` commands |
| [Episodic Memory](https://github.com/obra/episodic-memory) | Semantic search across past conversations |
| claude-code-setup | Analyzes codebase, recommends Claude Code automations |
| claude-md-management | Manages CLAUDE.md project context files |
| code-review | Automated PR review with specialized agents |
| code-simplifier | Simplifies code for clarity while preserving functionality |
| frontend-design | Generates distinctive, production-grade UI interfaces |

All 7 plugins are installed automatically via `claude plugin install` commands.

### Autonomous Permissions System

Automatically configured permissions for seamless operation:

| Component | Purpose |
|-----------|---------|
| settings.local.json | 100+ pre-approved operations |
| permission-helper hook | Suggests GSD/Ralph when appropriate |
| claude-permissions-review | Review and add new permissions |

**No more "Proceed?" prompts** - Claude Code works autonomously on common development tasks.

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

### 4. Verify Installation

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
│   ├── 05-mcp-servers.sh     # 9 MCP servers
│   ├── 06-tools.sh           # Ralph, GSD
│   └── 07-plugins.sh         # 7 plugins (Superpowers, Episodic Memory + 5 Official)
│
├── config/claude/
│   ├── CLAUDE.md             # Main context file (mandatory Superpowers workflow)
│   ├── RULES.md              # 14 behavioral rules + security baselines
│   ├── PRINCIPLES.md         # Dev principles + Definition of Done
│   ├── MCP/                  # 9 MCP + 3 Plugin guideline files
│   ├── skills/               # 3 domain skills (security, devsecops, research)
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
    ├── QUICK-REFERENCE.md    # All keywords & triggers cheat sheet
    └── TROUBLESHOOTING.md    # Common issues
```

---

## What Gets Installed

After running `bootstrap.sh`, you'll have:

```
~/.claude/
├── CLAUDE.md                 # Auto-loaded (mandatory Superpowers workflow)
├── RULES.md                  # 14 behavioral rules
├── PRINCIPLES.md             # Development principles
├── MCP/                      # MCP + Plugin guidelines (11 files)
├── skills/                   # Domain skills (3 directories)
│   ├── security-review/      # OWASP, threat modeling
│   ├── devsecops/            # CI/CD, Docker, deployment
│   └── research/             # Technology decisions
├── hooks/                    # Automation hooks (3 scripts)
├── context/                  # Project templates
├── commands/gsd/             # GSD slash commands
├── plugins/                  # Superpowers, Episodic Memory
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

### Memory - Persistent Storage
```
"Remember that I prefer TypeScript"
"Recall my project preferences"
```

Memory stores data in `~/.claude-memory/`.

---

## Automation vs Manual Features

### Fully Automated (No Action Required)
| Feature | How It Works |
|---------|--------------|
| 9 MCP Servers | Installed via `claude mcp add` commands |
| 7 Plugins | Installed via `claude plugin install` commands |
| GSD Slash Commands | Installed via `npx get-shit-done-cc --global` |
| Skill Evaluation | Hook runs on every prompt, evaluates which skill applies |
| Session Context | Hook loads PROJECT.md, STATE.md at session start |
| Quality Suggestions | Hook suggests checks after file edits |

### Semi-Automated (Context-Triggered)
| Feature | When It Runs |
|---------|--------------|
| Sequential Thinking | Claude uses it for complex planning (>3 components) |
| Strawberry | Claude uses it for security-related code |
| Memory | Claude stores preferences you mention |
| Tavily/Context7 | Claude uses for unfamiliar libraries |
| E2B | Claude uses for untrusted code execution |
| Episodic Memory | Searches past conversations when relevant |

Rule 11 in RULES.md defines when each MCP should auto-invoke.

### External Tools (Runs Outside Claude Code)
| Feature | How It Works |
|---------|--------------|
| Ralph | Bash loop that invokes Claude repeatedly until task complete |
| ralph-monitor | Live monitoring dashboard for Ralph loops |

---

## Workflow Architecture

### Superpowers-First Workflow (MANDATORY)

**For ANY feature/implementation work, Claude MUST follow this workflow:**

```
1. /superpowers:brainstorm    → Clarify requirements BEFORE coding
2. /superpowers:write-plan    → Create detailed implementation plan
3. /superpowers:execute-plan  → Execute in reviewed batches

For debugging:
/superpowers:systematic-debugging → Reproduce → Isolate → Fix → Verify
```

This is enforced via:
- CLAUDE.md mandatory workflow rules
- RULES.md Rule 12 (mandatory Superpowers)
- skill-activator.sh hook (routes requests to Superpowers)

### Domain Skills (3 total)

Domain skills provide expertise that Superpowers doesn't cover:

| Skill | Triggers On | Purpose |
|-------|-------------|---------|
| `security-review` | Auth, payment, encryption, OWASP | Security analysis |
| `devsecops` | CI/CD, Docker, Kubernetes, deploy | Infrastructure |
| `research` | Compare, evaluate, recommend | Technology decisions |

**After loading a domain skill, Superpowers workflows are used for implementation.**

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

## Quick Reference

See [docs/QUICK-REFERENCE.md](docs/QUICK-REFERENCE.md) for all keywords, triggers, and commands.

---

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues.

Quick fixes:
```bash
# Reload shell after installation
source ~/.bashrc

# If Ralph command not found
source ~/.bashrc

# Review permission suggestions
claude-permissions-review

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

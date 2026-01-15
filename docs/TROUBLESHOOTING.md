# Troubleshooting Guide

> Solutions for common issues with Claude Code Super Setup.

## Quick Diagnostics

Run the verification script:

```bash
./verify.sh
```

This checks all components and reports issues.

---

## Installation Issues

### Bootstrap Script Fails

**Symptom:** Script exits with error during installation.

**Solutions:**

1. Check internet connection:
   ```bash
   curl -s https://google.com > /dev/null && echo "OK" || echo "No internet"
   ```

2. Run with verbose output:
   ```bash
   bash -x ./bootstrap.sh
   ```

3. Run individual scripts to isolate the issue:
   ```bash
   sudo bash scripts/01-system-deps.sh
   sudo bash scripts/02-nodejs.sh
   # etc.
   ```

### Permission Denied

**Symptom:** `Permission denied` errors.

**Solutions:**

1. Make scripts executable:
   ```bash
   chmod +x bootstrap.sh verify.sh scripts/*.sh
   ```

2. For system package installation, use sudo:
   ```bash
   sudo ./bootstrap.sh
   ```

3. For user-space tools (Claude Code, MCP), run as regular user:
   ```bash
   ./bootstrap.sh --only-claude-code
   ```

---

## Claude Code Issues

### Claude Command Not Found

**Symptom:** `claude: command not found` after installation.

**Solutions:**

1. Reload shell configuration:
   ```bash
   source ~/.bashrc
   # or
   source ~/.profile
   ```

2. Add to PATH manually:
   ```bash
   export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"
   ```

3. Start a new terminal session.

4. Verify installation location:
   ```bash
   ls -la ~/.claude/bin/
   ls -la ~/.local/bin/
   ```

### Authentication Failed

**Symptom:** Claude Code won't authenticate.

**Solutions:**

1. Clear credentials and re-authenticate:
   ```bash
   rm -rf ~/.claude/credentials*
   claude
   ```

2. Check subscription status at [claude.ai](https://claude.ai)

3. For API key authentication, verify the key:
   ```bash
   export ANTHROPIC_API_KEY=your_key
   claude
   ```

---

## Node.js Issues

### Node Version Too Old

**Symptom:** `Node.js version < 18` error.

**Solution:**

```bash
# Remove old Node.js
sudo apt remove nodejs

# Reinstall via script
sudo bash scripts/02-nodejs.sh
```

### npm Global Packages Fail

**Symptom:** Permission errors when installing npm packages.

**Solution:**

```bash
# Configure npm for user directory
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"

# Add to .bashrc
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
```

---

## MCP Server Issues

### MCP Server Not Found

**Symptom:** `claude mcp list` doesn't show expected servers.

**Solutions:**

1. Re-run MCP setup:
   ```bash
   bash scripts/05-mcp-servers.sh
   ```

2. Add servers manually:
   ```bash
   claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_KEY
   ```

### Context7 "Unauthorized" Error

**Symptom:** Context7 returns authentication errors.

**Solutions:**

1. Verify API key:
   ```bash
   # Check .env file
   grep CONTEXT7_API_KEY .env
   ```

2. Get new key at [context7.com/dashboard](https://context7.com/dashboard)

3. Re-add server with correct key:
   ```bash
   claude mcp remove context7
   claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key NEW_KEY
   ```

### Browserbase Connection Failed

**Symptom:** Browserbase server fails to connect.

**Solutions:**

1. Verify credentials:
   ```bash
   grep BROWSERBASE .env
   ```

2. Check project ID is correct at [browserbase.com](https://browserbase.com)

3. Re-add with correct credentials:
   ```bash
   claude mcp remove browserbase
   claude mcp add browserbase \
     --env BROWSERBASE_API_KEY=your_key \
     --env BROWSERBASE_PROJECT_ID=your_project \
     -- npx -y @browserbasehq/mcp-server-browserbase
   ```

### Tavily Search Errors

**Symptom:** Tavily MCP returns authentication or search errors.

**Solutions:**

1. Verify API key:
   ```bash
   grep TAVILY_API_KEY .env
   ```

2. Get new key at [tavily.com](https://tavily.com)

3. Re-add with correct key:
   ```bash
   claude mcp remove tavily-mcp
   claude mcp add tavily-mcp \
     --env TAVILY_API_KEY=your_key \
     -- npx -y tavily-mcp@latest
   ```

---

## Playwright Issues

### Browser Won't Launch

**Symptom:** Playwright fails with "browser not found" or crash.

**Solutions:**

1. Install browser:
   ```bash
   npx playwright install chromium
   ```

2. Install system dependencies:
   ```bash
   sudo npx playwright install-deps
   ```

3. Clean up stale processes:
   ```bash
   pkill -f chrome || true
   pkill -f chromium || true
   pkill -f playwright || true
   rm -rf ~/.cache/ms-playwright/mcp-chrome-* || true
   ```

### Display Errors (Headless Server)

**Symptom:** "Cannot open display" or similar errors.

**Solutions:**

1. Start Xvfb:
   ```bash
   ~/.local/bin/start-xvfb.sh
   ```

2. Or manually:
   ```bash
   export DISPLAY=:99
   Xvfb :99 -screen 0 1920x1080x24 &
   ```

3. Verify Xvfb is installed:
   ```bash
   which Xvfb || sudo apt install -y xvfb
   ```

### Sandbox Errors

**Symptom:** "Running as root without --no-sandbox is not supported"

**Solution:**

The MCP server should be configured with `--no-sandbox`. Verify:

```bash
claude mcp remove playwright
claude mcp add playwright \
  --env DISPLAY=:99 \
  --env PLAYWRIGHT_HEADLESS=true \
  -- npx -y @playwright/mcp@latest --isolated --no-sandbox
```

---

## Pythea/Strawberry Issues

### Module Not Found

**Symptom:** `ModuleNotFoundError: No module named 'pythea'`

**Solution:**

```bash
python3 -m pip install pythea --break-system-packages
```

Or use a virtual environment:

```bash
python3 -m venv ~/.venvs/pythea
source ~/.venvs/pythea/bin/activate
pip install pythea
```

### MCP Server Won't Start

**Symptom:** Strawberry MCP fails to start.

**Solutions:**

1. Verify package:
   ```bash
   python3 -c "import pythea; print('OK')"
   python3 -c "from strawberry import mcp_server; print('OK')"
   ```

2. Check for correct module path:
   ```bash
   python3 -m strawberry.mcp_server --help
   ```

---

## Plugin Issues

### Plugin Install Fails

**Symptom:** `/plugin install` command fails.

**Solutions:**

1. Ensure marketplace is added:
   ```
   /plugin marketplace add obra/superpowers-marketplace
   ```

2. Check exact plugin name:
   ```
   /plugin search superpowers
   ```

3. Try refreshing:
   ```
   /plugin marketplace refresh
   ```

### Plugin Commands Not Showing

**Symptom:** `/help` doesn't show expected plugin commands.

**Solutions:**

1. Restart Claude Code:
   ```bash
   # Exit and restart
   claude
   ```

2. Verify plugin is installed:
   ```
   /plugin list
   ```

3. Check for conflicts with other plugins.

---

## General Tips

### Logging

For detailed logs during installation:

```bash
bash -x ./bootstrap.sh 2>&1 | tee install.log
```

### Clean Slate

If everything is broken, start fresh:

```bash
# Backup current config
cp -r ~/.claude ~/.claude.backup

# Remove Claude Code
rm -rf ~/.claude
rm -rf ~/.local/bin/claude

# Reinstall
curl -fsSL https://claude.ai/install.sh | bash
```

### Getting Help

1. Run verify script for diagnostics:
   ```bash
   ./verify.sh
   ```

2. Check component-specific docs:
   - [Claude Code](https://docs.anthropic.com/claude-code)
   - [Context7](https://github.com/upstash/context7)
   - [Playwright](https://playwright.dev)

3. Report issues at respective GitHub repositories.

---

## Reference: Environment Variables

| Variable | Purpose | Where to get |
|----------|---------|--------------|
| `CONTEXT7_API_KEY` | Context7 documentation | [context7.com/dashboard](https://context7.com/dashboard) |
| `TAVILY_API_KEY` | Tavily web search | [tavily.com](https://tavily.com) |
| `BROWSERBASE_API_KEY` | Browserbase browser | [browserbase.com](https://browserbase.com) |
| `BROWSERBASE_PROJECT_ID` | Browserbase project | [browserbase.com](https://browserbase.com) |
| `ANTHROPIC_API_KEY` | Claude API (optional) | [console.anthropic.com](https://console.anthropic.com) |
| `DISPLAY` | X display for headless | Usually `:99` |

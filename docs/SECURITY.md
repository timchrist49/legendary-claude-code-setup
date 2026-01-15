# Security Hardening Guide

This document covers security best practices for production Claude Code deployments, including plugin security, MCP server hardening, and supply chain risk mitigation.

## Plugin Security

### Supply Chain Risks

Claude Code plugins and MCP servers can introduce significant security risks:

1. **Prompt Injection** - Malicious plugins can inject instructions that bypass safety measures
2. **Data Exfiltration** - Hooks can capture and transmit sensitive data
3. **Credential Theft** - Plugins may access environment variables containing secrets
4. **Code Execution** - Plugins with shell access can execute arbitrary commands

Reference: [Hijacking Claude Code via Injected Plugins](https://promptarmor.substack.com/p/hijacking-claude-code-via-injected)

### Plugin Hardening Checklist

```
[ ] Pin plugin versions/commits - never use "latest" in production
[ ] Prefer official/audited sources - avoid random registries
[ ] Review hook code before installation - hooks have significant power
[ ] Audit plugin permissions - check what tools/files they access
[ ] Run Claude Code as limited user - not root, minimal sudo
[ ] Use filesystem allowlisting (Roots) - restrict to workspace only
[ ] Keep secrets out of repos - use secrets manager or host-only .env
[ ] Separate dev/prod configs - never mount prod secrets in dev sessions
[ ] Monitor plugin updates - subscribe to security advisories
[ ] Regular security audits - review installed plugins quarterly
```

### Safe Plugin Sources

**Preferred (audited):**
- Official Anthropic plugins: https://github.com/anthropics/claude-plugins-official
- MCP reference servers: https://github.com/modelcontextprotocol/servers

**Use with caution:**
- Third-party marketplaces (audit before use)
- Community plugins (review code first)

### Dangerous Plugin Patterns

Avoid plugins that:
- Request `dangerouslySkipPermissions` without clear justification
- Install hooks without documentation
- Require broad filesystem access outside your project
- Request network access to unknown domains
- Store data in hidden directories without explanation

## MCP Server Security

### Filesystem MCP Best Practices

If using Filesystem MCP (note: Claude Code has native file access):

```json
{
  "roots": [
    "/home/user/projects/current-project"
  ]
}
```

- Always use Roots-based allowlisting
- Use `edit_file` with `dryRun: true` before applying edits
- Never allow access to `/`, `/etc`, `/root`, or home directories

### Network MCP Servers

For MCPs that make network requests (Tavily, Browserbase, etc.):

- Use environment variables for API keys, never hardcode
- Restrict allowed domains where possible
- Enable request logging for audit trails
- Use separate API keys for dev vs production

### Database MCP Servers

For PostgreSQL, Supabase, or other database MCPs:

- Use read-only credentials for exploration/debugging
- Create separate database users with minimal permissions
- Never use production credentials in development
- Enable query logging for audit trails
- Set query timeouts to prevent runaway operations

## Environment Security

### Secrets Management

```bash
# BAD - secrets in code
POSTGRES_URL="postgres://user:password@host/db"

# GOOD - secrets from environment
POSTGRES_URL="${POSTGRES_URL}"

# BETTER - secrets from secrets manager
POSTGRES_URL="$(vault kv get -field=url secret/postgres)"
```

### Environment Variable Hygiene

```bash
# .env file permissions (host only, never commit)
chmod 600 .env

# Verify .env is in .gitignore
grep -q "^\.env$" .gitignore || echo ".env" >> .gitignore

# Use .env.example for documentation (no real values)
cp .env .env.example
sed -i 's/=.*/=/' .env.example
```

### Least Privilege Execution

```bash
# Create dedicated user for Claude Code
sudo useradd -m -s /bin/bash claudecode
sudo -u claudecode claude

# Or use containers
docker run --user 1000:1000 -v $(pwd):/workspace claude-code
```

## Production Security Baselines

### Code Security

- [ ] No secrets in code (use env vars + secret scanning)
- [ ] Input validation on all external data
- [ ] Output encoding to prevent injection attacks
- [ ] Authentication required for all sensitive endpoints
- [ ] Authorization checks at every access point
- [ ] Rate limiting on public endpoints
- [ ] Secure headers (CSP, HSTS, X-Frame-Options, etc.)
- [ ] Dependencies pinned with lockfiles
- [ ] Automated vulnerability scanning in CI

### Infrastructure Security

- [ ] TLS everywhere (no plain HTTP)
- [ ] Secrets in secrets manager (not env files in production)
- [ ] Network segmentation (DB not public)
- [ ] Minimal container images (distroless/alpine)
- [ ] Non-root container users
- [ ] Read-only filesystems where possible
- [ ] Resource limits (CPU, memory, connections)
- [ ] Regular security updates

### Logging Security

- [ ] No sensitive data in logs (passwords, tokens, PII)
- [ ] Structured logging with request IDs
- [ ] Log aggregation with retention policy
- [ ] Alerting on security events
- [ ] Audit trail for data access

## MCP Inspector

Use MCP Inspector to validate servers before production deployment:

```bash
# Install inspector
npx @anthropic/mcp-inspector

# Test a server
npx @anthropic/mcp-inspector --server "npx -y @anthropic/mcp-server-filesystem"
```

Validate:
- Authentication works correctly
- Schema matches documentation
- Error handling is graceful
- Edge cases don't crash the server
- No unexpected data exposure

Reference: https://modelcontextprotocol.io/docs/tools/inspector

## Incident Response

### If You Suspect Compromise

1. **Isolate** - Disconnect affected systems from network
2. **Preserve** - Capture logs and state before remediation
3. **Revoke** - Rotate all credentials that may be exposed
4. **Investigate** - Determine scope and method of compromise
5. **Remediate** - Remove malicious code/plugins
6. **Notify** - Inform affected parties if data was exposed
7. **Improve** - Update security controls to prevent recurrence

### Security Contacts

- Claude Code security issues: security@anthropic.com
- MCP server vulnerabilities: Report to respective maintainers
- Plugin security concerns: Report to plugin authors + Anthropic

## References

- [MCP Security Best Practices](https://modelcontextprotocol.io/docs/concepts/security)
- [Claude Code Documentation](https://code.claude.com/docs)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)

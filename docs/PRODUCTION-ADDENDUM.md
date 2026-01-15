# Claude Code Production Setup Addendum (MCP + Plugins + Rules/Skills Best Practices)
_Date: 2026-01-15_

This addendum extends your "super setup" with **additional MCP servers**, **Claude Code plugins**, and **battle-tested best practices** for **CLAUDE.md / rules.md / skills.md** so Claude Code can reliably deliver **end-to-end production work** (planning → code → tests → CI/CD → infra → security → ops).

> **Note**: Key items from this addendum have been integrated into the core setup. This document is preserved for reference and future enhancements.

---

## 1) Recommended "production-grade" MCP server stack

### A. Core local developer capabilities (baseline)
These are the minimum for "build software from scratch" on a fresh server.

1) **Filesystem MCP**
- Why: lets Claude manage project files safely (read/write/edit/search) with directory allowlisting ("Roots") and tool annotations.
- Notes: prefer Roots-based allowlisting; use `edit_file` dry runs before applying edits.
- Reference: https://raw.githubusercontent.com/modelcontextprotocol/servers/main/src/filesystem/README.md
- **Status**: NOT INCLUDED - Claude Code has native file access

2) **Git MCP**
- Why: allows Claude to read/search/manipulate Git repos (diffs, history, branching flows).
- Reference: https://raw.githubusercontent.com/modelcontextprotocol/servers/main/README.md (reference servers list)
- **Status**: NOT INCLUDED - Claude Code has native git via Bash

3) **Fetch MCP**
- Why: a lightweight "web page fetch + convert" tool for quick docs retrieval when you *don't* need full browser automation.
- Reference: https://raw.githubusercontent.com/modelcontextprotocol/servers/main/README.md (reference servers list)
- **Status**: NOT INCLUDED - Tavily MCP covers this use case

4) **MCP Inspector (developer tool)**
- Why: test/debug your MCP servers (resources/prompts/tools) before wiring them into your main Claude Code workflows.
- Reference: https://modelcontextprotocol.io/docs/tools/inspector
- **Status**: DOCUMENTED in docs/SECURITY.md

---

### B. Version control + repo ops (production workflow)
1) **GitHub MCP**
- Why: end-to-end repo management (issues, PRs, searches, CI pipelines) without leaving Claude Code.
- Reference (package): https://www.npmjs.com/package/@modelcontextprotocol/server-github
- **Status**: INCLUDED in setup

2) **Claude Code IDE integration**
- Why: review diffs and apply changes directly in IDE; supports MCP, custom slash commands, and subagents.
- Reference: https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code

---

### C. Databases + backend platform
1) **PostgreSQL MCP**
- Why: schema introspection + queries from Claude for debugging and development loops.
- Reference: https://www.npmjs.com/package/@modelcontextprotocol/server-postgres
- **Status**: FUTURE ADDON (optional, stack-specific)

2) **Supabase MCP**
- Why: for fast MVPs that need database + auth + edge functions.
- Reference: https://mcpservers.org/ (featured "Supabase official")
- **Status**: FUTURE ADDON (optional, stack-specific)

---

### D. Infrastructure-as-Code, cloud, and platform ops
1) **Terraform MCP (HashiCorp)**
- Why: IaC discovery + registry integration + (optionally) HCP Terraform / Terraform Enterprise workspace ops.
- Important security note: if using streamable-http transport, restrict allowed origins.
- Reference: https://github.com/hashicorp/terraform-mcp-server
- **Status**: FUTURE ADDON (optional, IaC users only)

2) **Kubernetes MCP**
- Why: manage clusters (kubectl apply/exec/port-forward + Helm install/upgrade).
- Reference: https://hub.docker.com/mcp/server/kubernetes
- **Status**: FUTURE ADDON (optional, K8s users only)

3) **Helm MCP (optional, if not covered by your Kubernetes MCP implementation)**
- Why: query chart values / repos and chart metadata without installing Helm locally.
- Reference: https://github.com/zekker6/mcp-helm
- **Status**: FUTURE ADDON

4) **Cloud provider MCP servers (choose what you actually use)**
- Google official MCP servers (bundle): https://mcpservers.org/ ("Google MCP Servers official")
- AWS Labs MCP servers (entry point listed on Docker MCP catalog pages): see Docker MCP catalog "AWS Core" listing from Kubernetes server page.
- **Status**: FUTURE ADDON (cloud-specific)

---

### E. Browser automation and web research
1) **Playwright MCP**
- Why: deterministic UI automation for testing, scraping, and "operator-style" flows.
- **Status**: INCLUDED in setup

2) **Browserbase MCP**
- Why: managed/remote browser automation (useful when you want isolation from the host and stable headless sessions).
- Reference: https://mcpservers.org/ (featured "Browserbase official")
- **Status**: INCLUDED in setup

3) **Web search/scraping MCPs (pick one approach)**
- **Exa** (search for AIs): https://mcpservers.org/ (featured "Exa official")
- **Firecrawl** (scrape + search): https://mcpservers.org/ (featured "Firecrawl official")
- **Bright Data** (industrial-grade web extraction): https://mcpservers.org/ (featured "Bright Data sponsor")
- **Status**: NOT INCLUDED - Tavily MCP covers search needs

---

### F. Safe code execution and "sandboxing" for risky tasks
1) **E2B MCP**
- Why: run code in isolated sandboxes (great for generating/validating code, migrations, quick tests) without risking your host.
- Reference: https://mcpservers.org/ (featured "E2B official")
- **Status**: INCLUDED in setup

---

### G. Observability + ops (production readiness)
1) **Monitoring/observability MCP**
- Why: pull performance/errors into Claude during debugging and incident response.
- Example listing: https://mcpservers.org/ (featured "Scout Monitoring MCP sponsor")
- **Status**: FUTURE ADDON (monitoring-specific)

---

## 2) Plugins: what else to add + how to stay safe

### A. Prefer "known-good" plugin directories
Anthropic maintains an official plugin directory repo and describes the standard plugin structure:
- `.claude-plugin/plugin.json` (metadata)
- optional `.mcp.json`
- optional `commands/`, `agents/`, `skills/`
Reference: https://github.com/anthropics/claude-plugins-official

### B. Treat plugin marketplaces as a supply-chain risk
There are real-world demonstrations of malicious marketplaces/plugins using hooks and prompt injection to bypass protections and exfiltrate data.
Reference: https://promptarmor.substack.com/p/hijacking-claude-code-via-injected

**Hardening checklist (practical):**
- Pin plugin versions/commits; don't "latest" in production.
- Prefer audited/official sources; avoid random registries.
- Disable/avoid plugins that install "hooks" unless you've read the code.
- Run Claude Code in a least-privilege environment (separate user, minimal file access Roots, locked-down env vars).
- Keep secrets out of the repo; use a secrets manager or `.env` only on the host.
- Separate "dev" and "prod" Claude configs; never mount prod secrets into dev sessions.

**Status**: DOCUMENTED in docs/SECURITY.md

---

## 3) Sequential Thinking MCP: keep or remove?
The MCP reference servers include **Sequential Thinking** as a "dynamic problem-solving through thought sequences" tool.
Reference: https://raw.githubusercontent.com/modelcontextprotocol/servers/main/README.md

**Recommendation:**
- If your setup already enforces a strong planning loop via **CLAUDE.md** + your SuperClaude-style framework prompts, Sequential Thinking is **optional** (nice-to-have, not required).
- Keep it only if you want a reusable "forced decomposition" tool you can call explicitly for complex multi-step tasks.

**Status**: INCLUDED in setup

---

## 4) Best-practice structure for CLAUDE.md (production engineering mode)

A strong CLAUDE.md turns Claude Code into a predictable "engineering machine." You can implement this as:
- a repo-level `CLAUDE.md`
- plus a "global" profile (your bootstrap install can place a template in your home dir and copy into new repos)

### A. Minimal CLAUDE.md template (drop-in)
Use this skeleton and adapt per project:

1) **Operating principles**
- Always start with: (a) goals, (b) constraints, (c) assumptions, (d) risks.
- Prefer incremental changes; don't rewrite the world.
- Default to secure-by-design.

2) **Project architecture rules**
- Define: languages, frameworks, folder structure, config conventions.
- Define: API style (REST/GraphQL), auth model, error model.
- Define: DB migration strategy and schema ownership.

3) **Quality gates**
- Required: formatter + linter + typecheck + unit tests.
- Required: integration/e2e tests for critical flows.
- Required: "Definition of Done" checklist (see below).

4) **Security baselines**
- No secrets in code; use env + secret scanning.
- Default: input validation, authz checks, rate limits, secure headers.
- Dependencies pinned; automated vulnerability scanning in CI.
- Logging: no sensitive data; structured logs with request IDs.

5) **DevOps defaults**
- Local dev: Docker Compose for dependencies (db, redis, etc.)
- CI: build + test + lint + security scans.
- CD: staging then production; migrations gated; rollbacks described.
- Observability: metrics + logs + tracing; health endpoints.

6) **Release + documentation**
- "How to run" + "How to deploy" in README.
- ADRs for major architecture decisions.
- OpenAPI/Swagger for APIs (or equivalent).

**Status**: KEY ELEMENTS integrated into RULES.md and PRINCIPLES.md

### B. A "Definition of Done" checklist
- ✅ Feature implemented behind tests
- ✅ Lint/format/typecheck clean
- ✅ Threat model updated for auth/data flows
- ✅ No secrets, no debug keys, no unsafe CORS defaults
- ✅ CI green
- ✅ Basic monitoring hooks (errors + healthcheck) in place
- ✅ Docs updated

**Status**: INCLUDED in PRINCIPLES.md

---

## 5) Rules.md and Skills.md: how to design them for reliability

### A. Rules.md (behavior + safety + process)
Treat rules as "non-negotiables." Make them short, testable, and enforceable.
Examples:
- "Never run destructive commands without explicit approval."
- "For file edits, run a dryRun first and show diff."
- "For any auth-related change, include unit tests + threat model update."

**Status**: INCLUDED in RULES.md

### B. Skills.md (repeatable playbooks)
Treat skills as "do-this-every-time" playbooks for common outcomes.

**Recommended skill packs (production-ready):**
1) **Product/Planning** - Status: planning skill INCLUDED
2) **Backend/API** - Status: implementation skill INCLUDED
3) **Frontend** - Status: implementation skill INCLUDED
4) **DevSecOps** - Status: devsecops skill INCLUDED
5) **Security review** - Status: security-review skill INCLUDED
6) **Production ops** - Status: devsecops skill INCLUDED

---

## 6) Future Addons (not in core)
If your goal is "spin up a new server and start shipping MVPs fast," consider these addons:

1) **PostgreSQL MCP** (if using Postgres)
2) **Supabase MCP** (if using Supabase)
3) **Terraform MCP** (if using IaC)
4) **Kubernetes MCP** (if deploying to K8s)

These are stack-specific and should be optional addons, not core requirements.

---

## References (quick list)
- Claude Code MCP docs: https://code.claude.com/docs/en/mcp
- Anthropic plugin directory + structure: https://github.com/anthropics/claude-plugins-official
- Filesystem MCP README (features, roots, dryRun): https://raw.githubusercontent.com/modelcontextprotocol/servers/main/src/filesystem/README.md
- MCP reference server list (Everything/Fetch/Filesystem/Git/Memory/SequentialThinking/Time): https://raw.githubusercontent.com/modelcontextprotocol/servers/main/README.md
- Terraform MCP Server (HashiCorp): https://github.com/hashicorp/terraform-mcp-server
- Kubernetes MCP (Docker MCP Catalog): https://hub.docker.com/mcp/server/kubernetes
- MCP Inspector: https://modelcontextprotocol.io/docs/tools/inspector
- MCP server discovery hub (Context7, Supabase, Playwright, etc.): https://mcpservers.org/
- Plugin marketplace attack surface write-up: https://promptarmor.substack.com/p/hijacking-claude-code-via-injected

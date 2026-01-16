# Manual Workflow Test Checklist

> Step-by-step tests to verify Claude Code Super Setup works correctly.
> Run these tests after `./bootstrap.sh` and `./verify.sh` pass.

## Prerequisites

- [ ] Bootstrap completed successfully
- [ ] `./verify.sh` passes with no failures
- [ ] Claude Pro/Max subscription or API key configured
- [ ] API keys configured in `.env` (especially CONTEXT7_API_KEY, TAVILY_API_KEY)

---

## Test 1: Session Start Hook

**Objective:** Verify session-start.sh hook fires and shows context.

### Steps:
1. Navigate to a git repository:
   ```bash
   cd /path/to/any/git/project
   ```

2. Start Claude Code:
   ```bash
   claude
   ```

### Expected Output:
```
🚀 SESSION START

📂 Project: [project-name]

🔀 Git branch: [branch-name]

💾 MEMORY INTEGRATION:
├── Search past sessions: /search-conversations "[project]"
├── Recall preferences: Query Memory MCP for user preferences
└── Context ready: Apply stored conventions and decisions

🛠️ SUGGESTED TOOLS:
├── New feature: /superpowers:brainstorm to clarify requirements
├── Research: Use Context7 + Tavily for current info
└── Complex planning: Use Sequential Thinking
```

### Result:
- [ ] **PASS** - Session start output appears
- [ ] **FAIL** - No output or error

---

## Test 2: Superpowers Workflow Routing

**Objective:** Verify skill-activator routes feature requests to Superpowers.

### Steps:
1. In Claude Code session, type:
   ```
   Build a new user authentication system
   ```

### Expected Output:
Should see routing message before Claude responds:
```
🚀 SUPERPOWERS WORKFLOW REQUIRED

This is a feature/implementation request. Follow the MANDATORY workflow:

1. FIRST: Use /superpowers:brainstorm
   - Clarify requirements before ANY coding
   - Present design options for approval
...
```

### Result:
- [ ] **PASS** - Superpowers routing message appears
- [ ] **FAIL** - No routing message

---

## Test 3: Security Skill Routing

**Objective:** Verify security requests load the @security-review skill.

### Steps:
1. In Claude Code session, type:
   ```
   Review the authentication security for OWASP compliance
   ```

### Expected Output:
```
🎯 DOMAIN SKILL ACTIVATED: @security-review

Load and follow the skill guidance from:
~/.claude/skills/security-review/SKILL.md
```

### Result:
- [ ] **PASS** - Security skill routing message appears
- [ ] **FAIL** - No routing message

---

## Test 4: DevSecOps Skill Routing

**Objective:** Verify CI/CD requests load the @devsecops skill.

### Steps:
1. In Claude Code session, type:
   ```
   Setup a GitHub Actions CI/CD pipeline
   ```

### Expected Output:
```
🎯 DOMAIN SKILL ACTIVATED: @devsecops
```

### Result:
- [ ] **PASS** - DevSecOps skill routing message appears
- [ ] **FAIL** - No routing message

---

## Test 5: Research Skill Routing

**Objective:** Verify research requests load the @research skill.

### Steps:
1. In Claude Code session, type:
   ```
   Compare React vs Vue vs Svelte for this project
   ```

### Expected Output:
```
🎯 DOMAIN SKILL ACTIVATED: @research
```

### Result:
- [ ] **PASS** - Research skill routing message appears
- [ ] **FAIL** - No routing message

---

## Test 6: MCP Server - Context7

**Objective:** Verify Context7 MCP works for documentation lookup.

### Steps:
1. In Claude Code session, type:
   ```
   Use Context7 to find the Next.js 15 App Router documentation
   ```

### Expected Behavior:
- Claude should invoke Context7 MCP
- Should return actual documentation content
- Should NOT hallucinate

### Result:
- [ ] **PASS** - Context7 returns real documentation
- [ ] **FAIL** - Error or hallucinated content

---

## Test 7: MCP Server - Tavily

**Objective:** Verify Tavily MCP works for web search.

### Steps:
1. In Claude Code session, type:
   ```
   Use Tavily to search for the latest Claude Code updates in 2026
   ```

### Expected Behavior:
- Claude should invoke Tavily MCP
- Should return recent search results
- Should include source URLs

### Result:
- [ ] **PASS** - Tavily returns search results
- [ ] **FAIL** - Error or no results

---

## Test 8: MCP Server - Sequential Thinking

**Objective:** Verify Sequential Thinking MCP works for complex analysis.

### Steps:
1. In Claude Code session, type:
   ```
   Use Sequential Thinking to analyze the tradeoffs between microservices and monolith for a new startup
   ```

### Expected Behavior:
- Claude should invoke Sequential Thinking MCP
- Should show step-by-step analysis
- Should revise thoughts if needed

### Result:
- [ ] **PASS** - Sequential Thinking produces structured analysis
- [ ] **FAIL** - Error or unstructured response

---

## Test 9: MCP Server - Memory

**Objective:** Verify Memory MCP can store and recall information.

### Steps:
1. In Claude Code session, type:
   ```
   Remember that I prefer TypeScript over JavaScript for all projects
   ```

2. Then in a NEW session, type:
   ```
   What are my coding preferences?
   ```

### Expected Behavior:
- First command: Claude should store preference to Memory MCP
- Second command: Claude should recall the TypeScript preference

### Result:
- [ ] **PASS** - Memory stores and recalls correctly
- [ ] **FAIL** - Memory doesn't persist

---

## Test 10: Superpowers Plugin Commands

**Objective:** Verify Superpowers slash commands work.

### Steps:
1. In Claude Code session, type:
   ```
   /superpowers:brainstorm
   ```

### Expected Behavior:
- Superpowers brainstorm workflow should activate
- Claude should ask clarifying questions
- Should NOT proceed to coding without approval

### Result:
- [ ] **PASS** - Brainstorm workflow activates
- [ ] **FAIL** - Command not recognized or error

---

## Test 11: GSD Slash Commands

**Objective:** Verify GSD commands are available.

### Steps:
1. In Claude Code session, type:
   ```
   /gsd:help
   ```

### Expected Behavior:
- Should show GSD help information
- Should list available GSD commands

### Result:
- [ ] **PASS** - GSD help displays
- [ ] **FAIL** - Command not recognized

---

## Test 12: Episodic Memory Plugin

**Objective:** Verify Episodic Memory can search past conversations.

### Steps:
1. Have at least one previous Claude Code session
2. In Claude Code session, type:
   ```
   /search-conversations authentication
   ```

### Expected Behavior:
- Should search past conversations for "authentication"
- Should return relevant snippets if any exist

### Result:
- [ ] **PASS** - Search returns results or "no results" message
- [ ] **FAIL** - Command not recognized or error

---

## Test 13: Quality Check Hook

**Objective:** Verify quality-check.sh fires after file edits.

### Steps:
1. In Claude Code session, ask Claude to create or edit a file:
   ```
   Create a simple hello.ts file with a hello world function
   ```

### Expected Behavior:
- After the file is created/edited
- Quality check suggestions may appear

### Result:
- [ ] **PASS** - File created, hook runs (may be silent)
- [ ] **FAIL** - Error during file operation

---

## Test 14: End-to-End Feature Workflow

**Objective:** Verify the full Superpowers workflow works end-to-end.

### Steps:
1. In Claude Code session, type:
   ```
   Build a simple REST API endpoint that returns user profiles
   ```

2. Follow the workflow:
   - Claude should use /superpowers:brainstorm first
   - Then /superpowers:write-plan
   - Then /superpowers:execute-plan

### Expected Behavior:
- Brainstorm: Clarifies requirements
- Write Plan: Creates detailed plan file
- Execute Plan: Implements in batches with checkpoints

### Result:
- [ ] **PASS** - Full workflow completes
- [ ] **FAIL** - Skips steps or errors

---

## Summary

| Test | Status |
|------|--------|
| 1. Session Start Hook | [ ] Pass / [ ] Fail |
| 2. Superpowers Workflow Routing | [ ] Pass / [ ] Fail |
| 3. Security Skill Routing | [ ] Pass / [ ] Fail |
| 4. DevSecOps Skill Routing | [ ] Pass / [ ] Fail |
| 5. Research Skill Routing | [ ] Pass / [ ] Fail |
| 6. MCP - Context7 | [ ] Pass / [ ] Fail |
| 7. MCP - Tavily | [ ] Pass / [ ] Fail |
| 8. MCP - Sequential Thinking | [ ] Pass / [ ] Fail |
| 9. MCP - Memory | [ ] Pass / [ ] Fail |
| 10. Superpowers Commands | [ ] Pass / [ ] Fail |
| 11. GSD Commands | [ ] Pass / [ ] Fail |
| 12. Episodic Memory | [ ] Pass / [ ] Fail |
| 13. Quality Check Hook | [ ] Pass / [ ] Fail |
| 14. End-to-End Workflow | [ ] Pass / [ ] Fail |

**Total: ___/14 tests passed**

---

## Troubleshooting

### Hooks not firing
1. Check `~/.claude/settings.json` has hooks configured
2. Verify hook scripts are executable: `chmod +x ~/.claude/hooks/*.sh`
3. Check hook scripts exist in `~/.claude/hooks/`

### MCP servers not working
1. Run `claude mcp list` to verify servers are configured
2. Check API keys in `~/.claude/settings.json`
3. Verify network connectivity

### Plugins not recognized
1. Run `claude plugin list` to verify plugins installed
2. Try reinstalling: `claude plugin install superpowers@superpowers-marketplace`

### Skills not loading
1. Verify skill files exist in `~/.claude/skills/`
2. Check skill-activator.sh is being triggered

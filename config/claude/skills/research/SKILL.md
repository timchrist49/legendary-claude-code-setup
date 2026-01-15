---
name: research
description: Use when gathering information, comparing options, or making technology decisions
---

# Research Skill

Activate this skill when you need to gather information before acting.

## When to Use

- Evaluating technology options
- Understanding new libraries
- Finding best practices
- Debugging unfamiliar issues
- Making architectural decisions
- Comparing approaches

## Research Workflow

```
1. DEFINE    → What do you need to know?
2. GATHER    → Collect information from sources
3. EVALUATE  → Assess quality and relevance
4. SYNTHESIZE → Combine into actionable knowledge
5. DOCUMENT  → Record findings for reference
```

## Step 1: Define Research Questions

Before searching, clarify:

```
RESEARCH QUESTIONS:
├── What specific question needs answering?
├── What would a good answer look like?
├── What constraints exist?
├── What's the decision to be made?
└── What's the deadline/urgency?
```

Example:
```markdown
## Research: Authentication Library

### Questions
1. What JWT libraries work with Next.js 15?
2. Which has best TypeScript support?
3. What are security implications?

### Constraints
- Must work with App Router
- Need refresh token support
- Team familiar with jose

### Decision
Select JWT library for new auth system
```

## Step 2: Gather Information

Use MCP tools strategically:

```
INFORMATION SOURCES:
├── Context7 → Official library docs
├── Tavily → Current articles, comparisons
├── Browserbase → Interactive exploration
└── GitHub → Issues, discussions, examples
```

### Search Strategy

```
START BROAD:
├── "Next.js authentication 2025"
├── Look for overview articles
├── Identify key options

THEN NARROW:
├── "[specific library] Next.js App Router"
├── Compare specific features
├── Check GitHub issues

VERIFY:
├── Cross-reference multiple sources
├── Check documentation dates
├── Prefer official sources
```

## Step 3: Evaluate Sources

Rate source reliability:

```
RELIABILITY TIERS:
├── Official docs (highest)
├── GitHub README/issues
├── Reputable tech blogs
├── Stack Overflow (check dates/votes)
├── Random blog posts (lowest)

RED FLAGS:
├── No date on article
├── Outdated version references
├── No working code examples
├── Contradicts official docs
├── Single source claims
```

## Step 4: Synthesize Findings

Combine information:

```
SYNTHESIS FORMAT:
├── Summary of findings
├── Options identified
├── Pros/cons comparison
├── Recommendation with reasoning
└── Remaining uncertainties
```

### Comparison Template

```markdown
## Options Comparison

### Option A: [Name]
**Pros:**
- Pro 1
- Pro 2

**Cons:**
- Con 1
- Con 2

**Best for:** [Use case]

### Option B: [Name]
...

### Recommendation
[Option X] because [reasons].

### Uncertainties
- [ ] Need to verify X
- [ ] Should test Y
```

## Step 5: Document

Save research for reference:

```
DOCUMENTATION:
├── What was researched
├── Sources consulted
├── Findings
├── Decision made
└── Date (information ages)
```

Save to: `docs/research/YYYY-MM-DD-topic.md`

## Research Patterns

### Technology Selection
```
1. Define requirements
2. Identify candidates (Tavily search)
3. Check docs (Context7)
4. Compare features
5. Check issues/discussions
6. Run Strawberry verification
7. Make recommendation
```

### Problem Investigation
```
1. Define the problem clearly
2. Search for similar issues (Tavily)
3. Check library issues (GitHub)
4. Look for solutions
5. Verify solutions apply
6. Document findings
```

### Best Practices Research
```
1. Search current practices (Tavily)
2. Check official recommendations (Context7)
3. Look for case studies
4. Evaluate for your context
5. Document decision rationale
```

## MCP Tool Selection

```
TOOL ROUTING:
├── "What's the API for X?" → Context7
├── "What's the best X in 2025?" → Tavily
├── "What does X page say?" → Browserbase
├── "Is my conclusion valid?" → Strawberry
```

## Quality Checks

Before concluding research:

```
VERIFICATION:
├── Multiple sources agree?
├── Official docs checked?
├── Recent information?
├── Edge cases considered?
├── Strawberry verification (if high-stakes)?
```

## Research Pitfalls

```
AVOID:
├── Stopping at first result
├── Trusting outdated sources
├── Ignoring contradictions
├── Over-researching (analysis paralysis)
├── Not documenting findings
├── Assuming without verifying
```

## Related Skills

- @planning - For acting on research
- @implementation - For applying findings
- @debugging - Research for problem-solving

---

*Research before acting. Document findings. Verify high-stakes conclusions.*

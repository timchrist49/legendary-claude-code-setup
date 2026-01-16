---
name: implementation
description: Use when executing a plan or implementing a specific task with code changes
---

# Implementation Skill

Activate this skill when writing or modifying code.

## When to Use

- Executing a planned task
- Making code changes
- Adding features
- Fixing bugs
- Refactoring

## Prerequisites

Before implementing:

```
VERIFY YOU HAVE:
├── Clear requirements (or create them)
├── Identified target files
├── Understood existing patterns
├── Checked dependencies
└── Plan for verification
```

## Implementation Workflow

```
1. READ   → Understand existing code
2. PLAN   → Identify exact changes
3. TEST   → Write failing test (if TDD)
4. CODE   → Make minimal changes
5. VERIFY → Run tests, check behavior
6. COMMIT → Atomic, descriptive commit
```

## Step 1: Read Existing Code

Before changing any file:

```
READ CHECKLIST:
├── Read the target file(s)
├── Understand current patterns
├── Check related files
├── Note existing tests
└── Identify dependencies
```

**Never propose changes to code you haven't read.**

## Step 2: Plan Changes

Identify exactly what changes:

```
CHANGE SPECIFICATION:
├── File: [exact path]
├── Location: [function/line]
├── Current: [what exists]
├── New: [what will exist]
└── Why: [reason for change]
```

## Step 3: Test First (TDD)

When adding functionality:

```
TDD CYCLE:
1. Write a failing test
2. Run test, confirm it fails
3. Write minimal code to pass
4. Run test, confirm it passes
5. Refactor if needed
6. Confirm tests still pass
```

## Step 4: Make Changes

Follow these rules:

```
CODING RULES:
├── One logical change at a time
├── Follow existing patterns
├── Minimal diff (no unrelated changes)
├── No style changes to untouched code
├── No "improvements" not requested
└── Exact error handling as patterns show
```

### Code Quality Checklist

```
BEFORE COMPLETING:
├── Compiles/runs without errors?
├── Follows project conventions?
├── No hardcoded values?
├── Error handling appropriate?
├── No security vulnerabilities?
├── No console.log/print left behind?
└── Types/interfaces correct?
```

## Step 5: Verify Changes

After making changes:

```
VERIFICATION:
├── Run existing tests
├── Run new tests
├── Manual verification (if needed)
├── Check for regressions
└── Verify in isolation
```

Provide verification commands:
```bash
# Run tests
npm test

# Type check
npm run typecheck

# Lint
npm run lint

# Expected: All pass
```

## Step 6: Commit

Atomic commits with good messages:

```
COMMIT FORMAT:
type(scope): short description

- What changed
- Why it changed

Types: feat, fix, docs, refactor, test, chore
```

Example:
```bash
git add src/components/UserForm.tsx
git commit -m "feat(auth): add email validation to UserForm

- Added Zod schema for email validation
- Shows inline error for invalid format
- Blocks submission until valid"
```

## Error Handling

When implementation fails:

```
WHEN ERRORS OCCUR:
1. State the exact error
2. Include full error message
3. Explain what was attempted
4. Propose specific fix
5. Don't hide or minimize

DON'T:
├── Say "it should work"
├── Ignore warnings
├── Proceed despite errors
└── Make excuses
```

## Batch Limits

Keep changes manageable:

```
BATCH LIMITS:
├── Max 100 lines per file
├── Max 3 files per batch
├── One feature per batch
├── Verify between batches
```

## Tool Integration

**Use these tools automatically during implementation:**

```
BEFORE CODING:
├── Memory MCP → Recall preferences: "prefers TypeScript", "uses Tailwind"
├── Episodic Memory → Past patterns: /search-conversations "similar feature"
└── Context7 → API documentation for libraries

DURING CODING:
├── /superpowers:execute-plan → Structured batch execution
├── E2B → Test risky operations in sandbox first
└── Playwright → Verify UI behavior

AFTER CODING:
├── Strawberry → Verify security-related code
├── Memory MCP → Store new patterns/learnings
└── GitHub MCP → Create PR, check CI status
```

**Execution Pattern with Superpowers:**
```
1. User approves plan
2. /superpowers:execute-plan → Start execution
3. Work through tasks in batches
4. Pause at checkpoints for review
5. Run tests between batches
6. Update plan status as tasks complete
7. Commit after each successful batch
```

## Related Skills

- @planning - For creating the implementation plan
- @testing - For comprehensive test coverage
- @debugging - When things go wrong

---

*Small batches, frequent verification. Never large, unverified changes.*

---
name: debugging
description: Use when diagnosing and fixing bugs, errors, or unexpected behavior
---

# Debugging Skill

Activate this skill when something isn't working as expected.

## When to Use

- Error messages appear
- Tests are failing
- Behavior doesn't match expectations
- Performance issues
- Crashes or exceptions

## Debugging Workflow

```
1. REPRODUCE → Confirm the issue
2. ISOLATE   → Find the source
3. DIAGNOSE  → Understand the cause
4. FIX       → Make minimal correction
5. VERIFY    → Confirm fix works
6. PREVENT   → Add test to prevent regression
```

## Step 1: Reproduce

First, reliably reproduce the issue:

```
REPRODUCTION CHECKLIST:
├── Exact steps to trigger
├── Environment details
├── Input data
├── Expected outcome
├── Actual outcome
└── Error message (full text)
```

Document reproduction:
```markdown
## Bug Reproduction

### Steps
1. Step one
2. Step two
3. Bug occurs

### Environment
- OS:
- Node:
- Package versions:

### Expected
[What should happen]

### Actual
[What actually happens]

### Error
```
[Full error message]
```
```

## Step 2: Isolate

Narrow down the source:

```
ISOLATION TECHNIQUES:
├── Binary search (comment out half)
├── Add logging at key points
├── Check recent changes (git diff)
├── Test in isolation
├── Check inputs/outputs at boundaries
└── Use debugger breakpoints
```

Questions to answer:
```
├── Which file(s) are involved?
├── Which function(s)?
├── Which line(s)?
├── What data is present?
└── What's different from working case?
```

## Step 3: Diagnose

Understand the root cause:

```
COMMON CAUSES:
├── Null/undefined values
├── Type mismatches
├── Async timing issues
├── State management bugs
├── Missing error handling
├── Incorrect assumptions
├── External service changes
└── Configuration errors
```

### Use MCP Tools

```
FOR DIAGNOSIS:
├── Context7 → Check API documentation
├── Tavily → Search for similar issues
├── Strawberry → Verify your diagnosis
├── Playwright → Test actual behavior
```

## Step 4: Fix

Make the minimal fix:

```
FIX RULES:
├── Fix only the bug
├── No unrelated changes
├── No "while I'm here" improvements
├── Keep the diff small
├── Maintain existing patterns
```

### Fix Template

```markdown
## Bug Fix

### Root Cause
[Explanation of why bug occurred]

### Fix
[Specific change made]

### File(s) Changed
- path/to/file.ts (line X)

### Verification
[How to verify the fix]
```

## Step 5: Verify

Confirm the fix works:

```
VERIFICATION CHECKLIST:
├── Original issue resolved?
├── No new errors introduced?
├── Related functionality still works?
├── Tests pass?
├── Edge cases handled?
```

Provide verification:
```bash
# Verify fix
[command to test fix]

# Run related tests
npm test -- --grep "related tests"

# Expected: All pass, original issue gone
```

## Step 6: Prevent

Add regression test:

```
TEST REQUIREMENTS:
├── Test that would have caught this
├── Covers the specific scenario
├── Part of automated suite
└── Documents expected behavior
```

Example:
```typescript
test('should handle null user gracefully', () => {
  // This test prevents regression of bug #123
  const result = processUser(null);
  expect(result).toEqual({ error: 'User not found' });
});
```

## Common Patterns

### Null/Undefined Errors
```
CHECKS:
├── Optional chaining (user?.name)
├── Nullish coalescing (value ?? default)
├── Type guards (if (user))
├── Default values
```

### Async Issues
```
CHECKS:
├── Missing await
├── Promise rejection handling
├── Race conditions
├── Timeout handling
```

### Type Errors
```
CHECKS:
├── Type assertions
├── Runtime validation
├── Interface mismatches
├── Any type leakage
```

## When Stuck

If you can't find the issue:

```
ESCALATION:
1. Document everything tried
2. Search with Tavily for similar issues
3. Check GitHub issues for library
4. Ask for minimal reproduction
5. Consider if it's environment-specific
```

## Tool Integration

**Use these tools automatically during debugging:**

```
REPRODUCE PHASE:
├── Playwright → Automate reproduction steps
├── E2B → Reproduce safely in sandbox
└── Read error logs and stack traces

ISOLATE PHASE:
├── Episodic Memory → /search-conversations "similar error"
├── Episodic Memory → /search-conversations "bug fix [component]"
└── Check if this issue was solved before

DIAGNOSE PHASE:
├── Context7 → Check API documentation for correct usage
├── Tavily → Search for known issues, solutions
├── Strawberry → Verify your diagnosis is correct
└── Sequential Thinking → Complex multi-cause issues

FIX PHASE:
├── E2B → Test fix in sandbox before applying
├── Playwright → Verify fix with automated test
└── Run existing test suite

PREVENT PHASE:
├── Memory MCP → Store bug pattern and solution
├── Create regression test
└── Document in code comments if non-obvious
```

**Past Issue Search Pattern:**
```
1. Error: "Cannot read property 'user' of undefined"
2. /search-conversations "undefined user error"
3. Find past solution: "Added null check in AuthContext"
4. Apply similar fix
5. Store to Memory MCP: "Common issue: user object null before auth complete"
```

## Related Skills

- @implementation - For making the fix
- @testing - For adding regression tests
- @research - For finding similar issues

---

*Reproduce, isolate, fix, verify, prevent. Always add a regression test.*

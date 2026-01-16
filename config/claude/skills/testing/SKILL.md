---
name: testing
description: Use when writing tests, improving coverage, or setting up testing infrastructure
---

# Testing Skill

Activate this skill for all testing-related work.

## When to Use

- Writing new tests
- Adding test coverage
- Setting up test infrastructure
- Debugging failing tests
- TDD workflow

## Testing Philosophy

```
CORE BELIEFS:
├── Tests are documentation
├── Fast tests get run often
├── Flaky tests are worse than no tests
├── Test behavior, not implementation
└── 80% coverage > 100% coverage of wrong things
```

## Test Types

### Unit Tests
```
PURPOSE: Test individual functions/components in isolation
SPEED: Very fast (<100ms)
DEPENDENCIES: Mocked
USE FOR: Business logic, utilities, pure functions
```

### Integration Tests
```
PURPOSE: Test components working together
SPEED: Fast (<1s)
DEPENDENCIES: Some real, some mocked
USE FOR: API endpoints, database operations
```

### E2E Tests
```
PURPOSE: Test complete user flows
SPEED: Slower (seconds)
DEPENDENCIES: Real (or close to real)
USE FOR: Critical paths, user journeys
```

## Test Structure (AAA Pattern)

```typescript
test('should calculate total with discount', () => {
  // Arrange - Set up test data
  const items = [{ price: 100 }, { price: 50 }];
  const discount = 0.1;

  // Act - Execute the code
  const result = calculateTotal(items, discount);

  // Assert - Verify the outcome
  expect(result).toBe(135);
});
```

## TDD Workflow

```
RED-GREEN-REFACTOR:

1. RED: Write failing test
   └── Test describes desired behavior
   └── Run test, confirm it fails

2. GREEN: Write minimal code
   └── Only enough to pass the test
   └── No extra features
   └── Run test, confirm it passes

3. REFACTOR: Clean up
   └── Improve code quality
   └── Keep tests passing
   └── No new functionality
```

## What to Test

### DO Test
```
├── Business logic
├── Edge cases
├── Error conditions
├── Security boundaries
├── Data transformations
├── State transitions
└── API contracts
```

### DON'T Test
```
├── Framework code
├── Third-party libraries
├── Simple getters/setters
├── Implementation details
├── Private methods directly
└── Console output
```

## Test Quality Checklist

```
GOOD TEST:
├── Clear name describing behavior
├── Single assertion focus
├── Independent (no order dependency)
├── Repeatable (same result every time)
├── Fast (< 100ms for unit tests)
└── Meaningful (would catch real bugs)
```

## Naming Conventions

```
PATTERN: should [expected behavior] when [condition]

EXAMPLES:
├── "should return empty array when no items"
├── "should throw error when user is null"
├── "should calculate tax for US addresses"
├── "should retry failed requests 3 times"
```

## Mocking Guidelines

```
MOCK:
├── External APIs
├── Database calls (for unit tests)
├── Time-dependent code
├── Random number generators
├── File system operations

DON'T MOCK:
├── The code under test
├── Simple utilities
├── What you want to verify
```

## Coverage Guidelines

```
TARGETS:
├── Critical paths: 90%+
├── Business logic: 80%+
├── Utilities: 70%+
├── UI components: 60%+

AVOID:
├── 100% coverage for coverage's sake
├── Testing every line of vendor code
├── Counting console.log as covered
```

## Test Commands

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test
npm test -- --grep "pattern"

# Watch mode
npm test -- --watch

# Update snapshots
npm test -- --updateSnapshot
```

## Verification Commands

After writing tests:
```bash
# Verify tests pass
npm test

# Check coverage
npm test -- --coverage

# Expected output:
# ✓ All tests pass
# ✓ Coverage meets threshold
```

## Common Testing Patterns

### Testing Async Code
```typescript
test('should fetch user data', async () => {
  const user = await fetchUser(1);
  expect(user.name).toBe('John');
});
```

### Testing Errors
```typescript
test('should throw for invalid input', () => {
  expect(() => validate(null)).toThrow('Input required');
});
```

### Testing with Mocks
```typescript
test('should call API with correct params', () => {
  const mockApi = jest.fn().mockResolvedValue({ ok: true });
  await submitForm(data, mockApi);
  expect(mockApi).toHaveBeenCalledWith('/submit', data);
});
```

## Tool Integration

**Use these tools automatically for testing:**

```
TEST PLANNING:
├── Episodic Memory → /search-conversations "test patterns"
├── Memory MCP → Recall preferred testing frameworks
├── Context7 → Testing library documentation
└── Sequential Thinking → Complex test architecture

TEST EXECUTION:
├── Playwright → E2E and browser testing
├── E2B → Run tests in isolated sandbox
├── GitHub MCP → Check CI test results
└── Bash → Local test execution

TEST VERIFICATION:
├── Playwright → Automated UI verification
├── Browserbase → Cloud browser testing
└── E2B → Test potentially destructive operations
```

**E2E Testing with Playwright:**
```
WHEN TO USE PLAYWRIGHT:
├── Testing user flows end-to-end
├── Verifying UI behavior
├── Regression testing
├── Visual testing
└── Cross-browser testing

PATTERN:
1. Write Playwright test
2. Run locally to verify
3. Add to CI pipeline
4. Store patterns to Memory MCP
```

**Sandbox Testing with E2B:**
```
WHEN TO USE E2B:
├── Testing database migrations
├── Running destructive operations
├── Testing untrusted code
├── Validating build processes
└── Testing deployment scripts
```

## Related Skills

- @implementation - For writing the code being tested
- @debugging - When tests fail unexpectedly
- @planning - For test strategy planning

---

*Tests are executable documentation. Write them as if explaining behavior.*

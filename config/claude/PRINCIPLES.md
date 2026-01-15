# Development Principles

> Guiding principles for writing production-ready code.
> These shape HOW we build, not WHAT we build.

## YAGNI - You Aren't Gonna Need It

**Build only what's needed now.**

```
AVOID:
├── "Future-proofing" abstractions
├── Configurable options nobody asked for
├── Generic solutions for specific problems
├── Features "just in case"
└── Premature optimization

INSTEAD:
├── Solve the immediate requirement
├── Keep implementations simple
├── Add complexity only when proven necessary
├── Refactor when patterns emerge naturally
```

**Test:** Can you delete this code and still meet requirements? If yes, delete it.

## DRY - Don't Repeat Yourself

**Single source of truth for every piece of knowledge.**

```
APPLY DRY TO:
├── Business logic → One function
├── Configuration → One config file
├── Constants → One constants file
├── Type definitions → One types file
└── Validation rules → One validator

DON'T OVER-APPLY:
├── Similar code isn't always duplicate
├── 2-3 similar lines don't need abstraction
├── Context matters more than syntax
└── Premature abstraction is worse than duplication
```

**Test:** If this changes, how many places need updates? Should be 1.

## TDD - Test-Driven Development

**Write tests first, then code to pass them.**

```
RED-GREEN-REFACTOR CYCLE:
1. RED    → Write a failing test
2. GREEN  → Write minimal code to pass
3. REFACTOR → Clean up while tests pass

TEST PRIORITY:
├── Unit tests for business logic
├── Integration tests for APIs
├── E2E tests for critical paths
└── Skip tests for trivial code

WHAT TO TEST:
├── Happy paths
├── Edge cases
├── Error conditions
├── Security boundaries
```

**Test:** Can someone understand the expected behavior from tests alone?

## KISS - Keep It Simple, Stupid

**Simplicity is the ultimate sophistication.**

```
COMPLEXITY BUDGET:
├── Simple problem → Simple solution
├── Avoid clever code
├── Prefer boring technology
├── Readable > Compact
└── Explicit > Implicit

SIMPLICITY CHECKS:
├── Can a junior developer understand this?
├── Can you explain it in one sentence?
├── Are there unnecessary abstractions?
├── Is the control flow obvious?
```

## Fail Fast

**Detect and surface errors immediately.**

```
VALIDATION ORDER:
1. Validate inputs at system boundaries
2. Fail before side effects occur
3. Provide actionable error messages
4. Log enough context to debug

NEVER:
├── Silently swallow errors
├── Return null instead of throwing
├── Continue with invalid state
├── Hide failures from users
```

## Separation of Concerns

**Each module should do one thing well.**

```
BOUNDARIES:
├── UI ↔ Business Logic ↔ Data
├── Configuration ↔ Code
├── Secrets ↔ Source Control
└── Tests ↔ Implementation

SIGNS OF VIOLATION:
├── "And" in function names
├── Files over 300 lines
├── Functions over 50 lines
├── Multiple reasons to change
```

## Composition Over Inheritance

**Prefer combining simple pieces.**

```
BUILD WITH:
├── Small, focused functions
├── Pure functions where possible
├── Dependency injection
├── Interface-based design
└── Mixins/traits over deep hierarchies

AVOID:
├── Deep inheritance chains
├── God objects
├── Tight coupling
└── Hidden dependencies
```

## Defensive Programming

**Assume things will go wrong.**

```
DEFENSE LAYERS:
├── Input validation
├── Type checking
├── Null checks
├── Bounds checking
├── Timeout handling
└── Circuit breakers

TRUST BOUNDARIES:
├── Never trust user input
├── Validate external API responses
├── Sanitize database inputs
├── Verify file paths
```

## Commit Discipline

**Every commit should be atomic and deployable.**

```
COMMIT RULES:
├── One logical change per commit
├── All tests pass
├── Code compiles/runs
├── Meaningful commit message
└── No WIP commits to main

COMMIT MESSAGE FORMAT:
type(scope): short description

- What changed
- Why it changed
- Any breaking changes

Types: feat, fix, docs, refactor, test, chore
```

## Code Review Mindset

**Code is written once, read many times.**

```
WHEN WRITING:
├── Will reviewers understand this?
├── Are there obvious questions they'll ask?
├── Have I explained non-obvious decisions?
├── Is the diff minimal and focused?

WHEN REVIEWING:
├── Does it work? (tests prove it)
├── Is it readable?
├── Is it maintainable?
├── Are there security concerns?
├── Does it follow project patterns?
```

## Definition of Done

**A feature is DONE when ALL items are checked.**

```
FUNCTIONALITY:
├── [ ] Feature implemented as specified
├── [ ] Edge cases handled
├── [ ] Error states handled gracefully
└── [ ] Works across supported environments

QUALITY:
├── [ ] Unit tests written and passing
├── [ ] Integration tests for critical paths
├── [ ] Lint/format/typecheck clean
├── [ ] No new warnings introduced
└── [ ] Code reviewed (or self-reviewed critically)

SECURITY:
├── [ ] Threat model considered for auth/data flows
├── [ ] No secrets committed
├── [ ] No debug keys or unsafe defaults
├── [ ] Input validation in place
└── [ ] CORS/headers configured correctly

OPERATIONS:
├── [ ] CI pipeline passes
├── [ ] Monitoring hooks in place (errors + health)
├── [ ] Logging appropriate (no sensitive data)
├── [ ] Documentation updated if needed
└── [ ] Rollback plan exists for risky changes

RELEASE:
├── [ ] Changelog updated
├── [ ] Version bumped appropriately
├── [ ] Breaking changes documented
└── [ ] Stakeholders notified if needed
```

**A task is NOT done if any item is unchecked without explicit justification.**

## Production Readiness Checklist

**Before going live, verify:**

```
APPLICATION:
├── [ ] All environments configured (dev/staging/prod)
├── [ ] Environment variables documented
├── [ ] Health check endpoints working
├── [ ] Graceful shutdown implemented
└── [ ] Resource limits configured

DATABASE:
├── [ ] Migrations tested on production-like data
├── [ ] Indexes optimized for queries
├── [ ] Backups configured and tested
├── [ ] Connection pooling configured
└── [ ] Rollback migrations exist

SECURITY:
├── [ ] HTTPS only (TLS 1.2+)
├── [ ] Authentication/authorization working
├── [ ] Rate limiting enabled
├── [ ] Security headers configured
├── [ ] Secrets in secrets manager
└── [ ] Vulnerability scan passed

OBSERVABILITY:
├── [ ] Structured logging enabled
├── [ ] Metrics collection working
├── [ ] Alerts configured for critical errors
├── [ ] Distributed tracing (if applicable)
└── [ ] Dashboard for key metrics

DOCUMENTATION:
├── [ ] README with setup instructions
├── [ ] API documentation (OpenAPI/Swagger)
├── [ ] Architecture decision records
├── [ ] Runbook for common operations
└── [ ] Incident response procedure
```

---

*These principles guide decision-making when multiple valid approaches exist.*

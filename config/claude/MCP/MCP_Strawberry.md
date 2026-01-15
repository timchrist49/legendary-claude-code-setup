# Strawberry MCP Guidelines

> Strawberry (Pythea) provides procedural hallucination detection to verify reasoning.

## When to Use

**ALWAYS use Strawberry for:**
- High-stakes technical claims
- Security-related decisions
- Production deployment plans
- Financial/billing logic
- Authentication flows
- Data migration plans
- Performance claims

**Consider using for:**
- Complex implementation plans
- Architectural decisions
- Claims about external systems
- Unfamiliar technology assessments

## Key Capabilities

### detect_hallucination
Analyzes claims for potential hallucination.
```
Use cases:
├── Verify implementation plan accuracy
├── Check security claim validity
├── Validate API behavior claims
└── Assess reasoning chain soundness
```

### audit_trace_budget
Audits reasoning trace for completeness.
```
Use cases:
├── Ensure all edge cases considered
├── Verify decision chain completeness
├── Check for missing steps
└── Validate assumption coverage
```

## Usage Patterns

### Before Implementation
```
"Run Strawberry hallucination check on this implementation plan"
"Verify my reasoning for [architectural decision] with Strawberry"
```

### After Research
```
"Use Strawberry to validate these claims from my research"
"Check if my synthesis of [topic] is accurate"
```

### For Security
```
"Run Strawberry verification on this authentication flow"
"Verify the security implications of [change] with Strawberry"
```

## High-Risk Scenarios

### Authentication & Authorization
```
ALWAYS verify:
├── Auth flow correctness
├── Token handling
├── Permission checks
├── Session management
└── Password handling
```

### Payment & Billing
```
ALWAYS verify:
├── Price calculation logic
├── Currency handling
├── Tax computation
├── Refund logic
└── Subscription management
```

### Data Operations
```
ALWAYS verify:
├── Migration scripts
├── Data transformation
├── Backup procedures
├── Deletion logic
└── Privacy compliance
```

### Deployment
```
ALWAYS verify:
├── Environment configuration
├── Secret management
├── Rollback procedures
├── Health checks
└── Monitoring setup
```

## Best Practices

### 1. Be Specific About Claims
```
GOOD: "Verify: JWT tokens expire after 1 hour by default in jose library"
BAD:  "Verify my JWT implementation"
```

### 2. Include Context
```
GOOD: "Given [constraints], verify that [approach] is correct"
BAD:  "Is this correct?"
```

### 3. List Assumptions
```
BEFORE verification:
├── State all assumptions
├── Note what's verified vs assumed
├── Identify external dependencies
└── Flag uncertainty areas
```

## Interpretation

### High Confidence Results
```
Strawberry confirms:
├── Claim appears valid
├── Reasoning chain sound
├── No obvious gaps
└── Proceed with confidence
```

### Low Confidence Results
```
Strawberry flags:
├── Potential issues to investigate
├── Missing evidence
├── Reasoning gaps
└── Additional verification needed

RESPONSE:
1. Identify flagged areas
2. Gather more evidence
3. Use Context7/Tavily to verify
4. Re-run Strawberry if needed
```

## Integration with Other Tools

```
VERIFICATION WORKFLOW:
├── Context7 → Verify against official docs
├── Tavily → Cross-reference with web sources
├── Strawberry → Validate reasoning chain
└── Playwright → Test actual behavior

VERIFICATION CHAIN:
1. Make claim
2. Gather evidence (Context7/Tavily)
3. Verify reasoning (Strawberry)
4. Test behavior (Playwright)
5. Document confidence level
```

## When to Skip

Strawberry verification may be skipped for:
- Trivial changes (typo fixes, formatting)
- Well-tested patterns
- Changes with comprehensive tests
- Low-risk modifications

But when in doubt, verify.

---

*Strawberry is your verification safety net. Use it for anything high-stakes.*

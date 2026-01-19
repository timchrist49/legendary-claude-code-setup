# Hallucination Detector MCP (Strawberry/Pythea)

> Detects procedural hallucinations using information theory before they ship.
> MCP Server Name: `hallucination-detector`
> Source: https://github.com/leochlon/pythea

## Installation

The bootstrap script automatically installs this MCP. Manual installation:

```bash
# Clone repository
git clone https://github.com/leochlon/pythea.git ~/.claude-tools/pythea
cd ~/.claude-tools/pythea

# Create venv and install
python3.12 -m venv .venv
.venv/bin/pip install -e ".[mcp]"
.venv/bin/pip install 'mcp[cli]'

# Register MCP (requires OPENAI_API_KEY)
claude mcp add hallucination-detector \
  --env OPENAI_API_KEY=$OPENAI_API_KEY \
  -- ~/.claude-tools/pythea/.venv/bin/python -m strawberry.mcp_server
```

## When to Use

**ALWAYS use `detect_hallucination` for:**
- High-stakes technical claims
- Security-related decisions
- Production deployment plans
- Financial/billing logic
- Authentication flows
- Data migration plans
- Root cause analysis
- Implementation plans for critical systems

**Consider using for:**
- Complex implementation plans
- Architectural decisions
- Claims about external systems
- Unfamiliar technology assessments

## Key Tools

### detect_hallucination
Automatically splits an answer into claims and checks each against cited sources.

**Usage:**
```
Use detect_hallucination to verify this answer:

Answer: "The function returns 42 [S0] and handles errors gracefully [S1]."

Spans:
- S0: "def calculate(): return 42"
- S1: "try: ... except: raise"
```

### audit_trace_budget
More reliable - you provide pre-parsed claims with explicit citations.

**Usage:**
```
Use audit_trace_budget to verify these claims:

Steps:
1. "The function returns 42" citing S0
2. "Errors are re-raised, not handled" citing S1

Spans:
- S0: "def calculate(): return 42"
- S1: "try: ... except: raise"
```

## Understanding Results

```json
{
  "flagged": true,
  "summary": {"claims_scored": 2, "flagged_claims": 1, "flagged_idxs": [1]},
  "details": [
    {"idx": 0, "claim": "...", "flagged": false, "budget_gap": {"min": -2.1, "max": -1.5}},
    {"idx": 1, "claim": "...", "flagged": true, "budget_gap": {"min": 8.3, "max": 12.1}}
  ]
}
```

| `budget_gap` (bits) | Meaning | Action |
|---------------------|---------|--------|
| < 0 | Claim well-supported | Proceed ✓ |
| 0-2 | Minor extrapolation | Usually acceptable |
| 2-10 | Suspicious | Verify manually |
| > 10 | **Likely hallucination** | DO NOT proceed ✗ |

## Usage Patterns

### Before Implementation
```
"Use detect_hallucination to verify this implementation plan"
"Run hallucination check on my architectural decision"
```

### After Research
```
"Use detect_hallucination to validate these claims from my research"
"Check if my synthesis of [topic] is accurate"
```

### For Security
```
"Use detect_hallucination on this authentication flow"
"Verify the security implications of [change]"
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

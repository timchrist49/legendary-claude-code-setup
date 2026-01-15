---
name: security-review
description: Use when reviewing code for security vulnerabilities, implementing authentication/authorization, handling sensitive data, or preparing for production deployment
---

# Security Review Skill

Activate this skill when security analysis is needed. Follow this systematic approach.

## Step 1: Identify Security Surface

```
ANALYZE:
├── What sensitive data is handled?
├── What are the trust boundaries?
├── Who are the threat actors?
├── What are the attack vectors?
└── What is the blast radius if compromised?
```

Document findings before proceeding.

## Step 2: OWASP Top 10 Review

Check for each vulnerability class:

### A01: Broken Access Control
```
VERIFY:
├── [ ] Authentication required for sensitive endpoints
├── [ ] Authorization checks on every request
├── [ ] Deny by default policy
├── [ ] CORS configured restrictively
├── [ ] Rate limiting enabled
└── [ ] No privilege escalation paths
```

### A02: Cryptographic Failures
```
VERIFY:
├── [ ] Sensitive data encrypted at rest
├── [ ] TLS 1.2+ for data in transit
├── [ ] Passwords hashed with bcrypt/argon2
├── [ ] No deprecated algorithms (MD5, SHA1)
├── [ ] Keys rotated regularly
└── [ ] No hardcoded secrets
```

### A03: Injection
```
VERIFY:
├── [ ] Parameterized queries for SQL
├── [ ] Input validation on all fields
├── [ ] Output encoding for display
├── [ ] Command execution avoided/sanitized
├── [ ] Template injection prevented
└── [ ] LDAP/XPath injection prevented
```

### A04: Insecure Design
```
VERIFY:
├── [ ] Threat modeling done
├── [ ] Security requirements defined
├── [ ] Fail-secure defaults
├── [ ] Defense in depth
└── [ ] Least privilege principle
```

### A05: Security Misconfiguration
```
VERIFY:
├── [ ] Default credentials changed
├── [ ] Unnecessary features disabled
├── [ ] Error messages don't leak info
├── [ ] Security headers set
├── [ ] Permissions minimized
└── [ ] Debug mode disabled
```

### A06: Vulnerable Components
```
VERIFY:
├── [ ] Dependencies up to date
├── [ ] No known vulnerabilities
├── [ ] Automated scanning in CI
├── [ ] Minimal dependencies
└── [ ] Lock files committed
```

### A07: Authentication Failures
```
VERIFY:
├── [ ] Strong password policy
├── [ ] Brute force protection
├── [ ] Session management secure
├── [ ] MFA available for sensitive ops
├── [ ] Credential recovery secure
└── [ ] Session timeout implemented
```

### A08: Data Integrity Failures
```
VERIFY:
├── [ ] Software/updates verified
├── [ ] CI/CD pipeline secured
├── [ ] Serialization validated
├── [ ] Integrity checks on data
└── [ ] Signed commits/releases
```

### A09: Logging Failures
```
VERIFY:
├── [ ] Security events logged
├── [ ] Logs don't contain secrets
├── [ ] Log injection prevented
├── [ ] Alerting configured
├── [ ] Audit trail exists
└── [ ] Logs protected/retained
```

### A10: SSRF
```
VERIFY:
├── [ ] URL validation on server requests
├── [ ] Allowlist for external calls
├── [ ] Internal network protected
├── [ ] Metadata endpoints blocked
└── [ ] Response validation
```

## Step 3: Threat Modeling (STRIDE)

For each component, analyze:

| Threat | Question | Mitigation |
|--------|----------|------------|
| **S**poofing | Can identity be faked? | Authentication |
| **T**ampering | Can data be modified? | Integrity checks |
| **R**epudiation | Can actions be denied? | Audit logging |
| **I**nfo Disclosure | Can data leak? | Encryption |
| **D**enial of Service | Can service be blocked? | Rate limiting |
| **E**levation | Can privileges escalate? | Authorization |

## Step 4: Code Review Checklist

```
AUTHENTICATION:
├── [ ] Secure credential storage
├── [ ] Secure session management
├── [ ] Logout invalidates session
├── [ ] Password reset is secure

AUTHORIZATION:
├── [ ] Every endpoint protected
├── [ ] Role checks on backend
├── [ ] No client-side only auth
├── [ ] Resource ownership verified

DATA HANDLING:
├── [ ] Input validated/sanitized
├── [ ] Output encoded
├── [ ] Sensitive data masked
├── [ ] PII handled per policy

ERROR HANDLING:
├── [ ] Errors don't leak info
├── [ ] Failed ops logged
├── [ ] Graceful degradation
├── [ ] No stack traces to users
```

## Step 5: Document Findings

Create security report:

```markdown
## Security Review: [Component]

### Summary
- Scope: [what was reviewed]
- Risk Level: [Critical/High/Medium/Low]
- Date: [date]

### Findings
1. [Finding Title]
   - Severity: [Critical/High/Medium/Low]
   - Location: [file:line]
   - Description: [what's wrong]
   - Remediation: [how to fix]

### Recommendations
- [Priority actions]

### Sign-off
- [ ] All critical/high findings addressed
- [ ] Security team notified if needed
```

## Tools to Use

- **Strawberry MCP**: Verify security claims
- **Context7**: OWASP guidelines, framework security docs
- **Tavily**: Current CVEs, security advisories
- **E2B**: Test exploits safely in sandbox
- **GitHub MCP**: Check for security advisories on deps

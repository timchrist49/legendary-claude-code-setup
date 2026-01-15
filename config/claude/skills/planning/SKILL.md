---
name: planning
description: Use when starting a new feature, project, or multi-step task before writing code
---

# Planning Skill

Activate this skill when you need to plan before implementing.

## When to Use

- Starting a new feature or project
- Multi-step tasks (3+ steps)
- Complex refactoring
- Architectural changes
- Anything requiring coordination

## Planning Workflow

```
1. CLARIFY → Understand requirements fully
2. RESEARCH → Gather technical information
3. DESIGN → Create implementation plan
4. REVIEW → Validate plan before execution
5. DOCUMENT → Save plan for reference
```

## Step 1: Clarify Requirements

Ask clarifying questions until you have:

```
REQUIRED INFORMATION:
├── What is the goal? (specific outcome)
├── What are the constraints? (time, tech, resources)
├── What exists already? (current state)
├── What's the success criteria? (how to verify)
└── What's out of scope? (boundaries)
```

Create a short spec:
```markdown
## Feature: [Name]

### Goal
[One sentence describing the outcome]

### Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

### Constraints
- Constraint 1
- Constraint 2

### Out of Scope
- Not doing X
- Not doing Y
```

## Step 2: Research

Use MCP tools to gather information:

```
RESEARCH CHECKLIST:
├── Context7 → Library/framework docs
├── Tavily → Current best practices
├── Existing code → Patterns to follow
└── Dependencies → Version compatibility
```

Note findings in the plan.

## Step 3: Design Implementation Plan

Create a detailed plan:

```markdown
## Implementation Plan: [Feature Name]
Date: YYYY-MM-DD

### Overview
[2-3 sentences summarizing approach]

### Tasks

#### Task 1: [Name]
- Files: `path/to/file.ts`
- Action: [Specific changes]
- Verify: [How to test]
- Done: [Success criteria]

#### Task 2: [Name]
...

### Dependencies
- Package X (version)
- Package Y (version)

### Risks
- Risk 1: [Mitigation]
- Risk 2: [Mitigation]

### Verification
- [ ] All tests pass
- [ ] Manual verification steps
```

## Step 4: Review Plan

Before executing:

```
REVIEW CHECKLIST:
├── Is each task atomic? (one thing)
├── Is order correct? (dependencies)
├── Are files identified? (exact paths)
├── Is verification clear? (how to test)
├── Are risks addressed? (mitigations)
└── Run Strawberry check? (if high-stakes)
```

## Step 5: Document

Save the plan:
```
docs/plans/YYYY-MM-DD-feature-name.md
```

## Plan Granularity

Each task should be:
- **Atomic**: One logical change
- **Testable**: Can verify independently
- **Time-boxed**: ~15-30 minutes
- **Specific**: Exact files and changes

```
GOOD TASK:
"Add validation to UserForm component
 File: src/components/UserForm.tsx
 Action: Add Zod schema validation for email and name
 Verify: Form shows errors for invalid input
 Done: Invalid submissions blocked, errors displayed"

BAD TASK:
"Implement form validation"
```

## Execution Handoff

After planning, offer execution choice:

```
"Plan complete. How would you like to proceed?

1. Execute now - I'll implement task by task
2. Review first - Let's walk through the plan
3. Save for later - Plan saved to docs/plans/"
```

## Related Skills

- @implementation - For executing the plan
- @testing - For verification steps
- @debugging - If issues arise

---

*Never start coding without a plan. Plans prevent wasted effort.*

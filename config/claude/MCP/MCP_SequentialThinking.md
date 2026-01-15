# Sequential Thinking MCP Guidelines

## Purpose
Sequential Thinking provides structured problem decomposition through dynamic thought sequences, enabling systematic analysis of complex problems.

## When to Use
- Breaking down complex multi-step problems
- Planning architecture before implementation
- Analyzing trade-offs between approaches
- Debugging complex issues methodically
- Making decisions with multiple factors
- Validating hypotheses step by step

## Available Tools
- `sequentialthinking` - Execute a thought step in a sequence

## How It Works
1. Start with initial problem assessment
2. Break into logical thought steps
3. Each step can build on, question, or revise previous steps
4. Adjust total steps as understanding develops
5. Branch into alternative approaches when needed
6. Converge on verified solution

## Best Practices

### Problem Decomposition
1. State the problem clearly first
2. Identify constraints and assumptions
3. Break into independent sub-problems
4. Solve sub-problems systematically
5. Integrate solutions

### Thought Structure
- Each thought should be self-contained
- Reference previous thoughts explicitly
- Mark revisions and branches clearly
- Express uncertainty when present
- Don't skip logical steps

### When to Use vs Skip
**Use for:**
- Multi-step architectural decisions
- Complex debugging scenarios
- Trade-off analysis
- Problems with unclear scope

**Skip for:**
- Simple, single-step tasks
- Well-defined procedures
- Tasks with obvious solutions

## Example Usage
```
"Use sequential thinking to plan the authentication system"
"Break down this performance issue step by step"
"Analyze the trade-offs between these three approaches"
"Help me think through the database schema design"
```

## Integration with Other Tools
- Combine with Tavily for research-based decisions
- Use before implementation skills
- Feed conclusions into planning skill
- Document final decisions in ADRs

## Parameters
- `thought`: Current thinking step
- `thoughtNumber`: Position in sequence
- `totalThoughts`: Estimated total (adjustable)
- `nextThoughtNeeded`: Whether to continue
- `isRevision`: If revising earlier thought
- `branchId`: For exploring alternatives

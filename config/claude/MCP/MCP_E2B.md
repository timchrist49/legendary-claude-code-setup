# E2B MCP Guidelines

## Purpose
E2B provides isolated cloud sandbox environments for safe code execution, testing, and experimentation without risking the host system.

## When to Use
- Running untrusted or experimental code
- Testing code that might have side effects
- Executing database migrations in isolated environment
- Running security tests or fuzzing
- Validating build scripts before local execution
- Generating and testing code snippets
- Running computationally intensive tasks

## Available Tools
- `create_sandbox` - Create new isolated environment
- `execute_code` - Run code in sandbox
- `install_packages` - Install dependencies
- `read_file` - Read files from sandbox
- `write_file` - Write files to sandbox
- `run_command` - Execute shell commands
- `close_sandbox` - Terminate sandbox

## Best Practices

### Sandbox Lifecycle
1. Create sandbox for the task
2. Install required dependencies
3. Execute code/commands
4. Retrieve results
5. Close sandbox when done

### Safety
- Use E2B for any code you haven't verified
- Test destructive operations in sandbox first
- Validate migration scripts before production
- Run security tools in isolation

### Efficiency
- Reuse sandboxes for related operations
- Install dependencies once per session
- Close sandboxes promptly (billing consideration)

## Example Usage
```
"Run this Python script in a sandbox to test it safely"
"Execute the migration script in an isolated environment first"
"Test this shell command without affecting my system"
"Validate the build script in a clean environment"
```

## Supported Languages
- Python (3.10+)
- Node.js (18+)
- Bash
- Go
- Rust
- And more via custom templates

## Limitations
- Sandboxes have time limits (typically 24h)
- Network access may be restricted
- Large file transfers may be slow
- GPU access requires special templates
- State is not persistent across sandbox sessions

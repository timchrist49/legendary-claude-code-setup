# GitHub MCP Guidelines

## Purpose
GitHub MCP provides direct repository operations, PR workflows, and issue management without leaving Claude Code.

## When to Use
- Creating, reviewing, or merging pull requests
- Managing GitHub issues (create, update, close)
- Searching repositories for code or issues
- Viewing commit history and diffs
- Managing branches and releases
- Checking CI/CD status

## Available Tools
- `search_repositories` - Find repos by query
- `get_file_contents` - Read files from repos
- `create_or_update_file` - Write files to repos
- `push_files` - Push multiple files
- `create_issue` - Open new issues
- `list_issues` - Query issues
- `create_pull_request` - Open PRs
- `list_commits` - View commit history
- `create_branch` - Create new branches
- `fork_repository` - Fork repos

## Best Practices

### PR Workflow
1. Create a feature branch first
2. Push changes with descriptive commit messages
3. Create PR with clear title and description
4. Reference related issues with "Fixes #123"

### Issue Management
1. Use labels for categorization
2. Include reproduction steps for bugs
3. Link related PRs and issues
4. Update status as work progresses

### Security
- Never commit secrets or credentials
- Review diffs before pushing
- Use branch protection rules
- Require PR reviews for main branch

## Example Usage
```
"Create a new issue for the login bug we discussed"
"Open a PR to merge feature/auth into main"
"Search for files containing 'deprecated' in the repo"
"List all open issues with label 'bug'"
```

## Limitations
- Token must have appropriate scopes (repo, read:org)
- Rate limits apply (5000 requests/hour for authenticated)
- Cannot force push without explicit token permissions
- Large file operations may timeout

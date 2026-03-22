#!/usr/bin/env zsh
# PostToolUse hook: remind the agent to update README.md when structural changes
# are committed (new or removed files in skills/, commands/, or hooks/).
# Output is plain text — Claude Code displays it as a reminder after the tool call.

input=$(</dev/stdin)

# Only act on git commit calls
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
if ! echo "$cmd" | grep -qE '^git (commit|-C .* commit)'; then
  exit 0
fi

# Get the list of files changed in the latest commit
changed=$(git diff HEAD~1 --name-only 2>/dev/null)
if [[ -z "$changed" ]]; then
  exit 0
fi

# Check for structural changes that might require a README update
structural=$(echo "$changed" | grep -E '^(skills/[^/]+/[^/]+|commands/[^/]+\.md|hooks/[^/]+|resources\.md)$')
if [[ -z "$structural" ]]; then
  exit 0
fi

# Check if README.md was already updated in this commit
if echo "$changed" | grep -q '^README\.md$'; then
  exit 0
fi

echo "README check: the following structural files changed but README.md was not updated:"
echo "$structural" | sed 's/^/  /'
echo "Consider whether README.md needs updating (new skill, command, hook, or resource)."

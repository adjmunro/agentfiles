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

# Get all files changed in the latest commit
changed=$(git diff HEAD~1 --name-only 2>/dev/null)
if [[ -z "$changed" ]]; then
  exit 0
fi

# Check if README.md was already updated in this commit
if echo "$changed" | grep -qE '^README(\.md)?$'; then
  exit 0
fi

# Trigger if any files were added/deleted, or any markdown files were modified
structural=$(git diff HEAD~1 --diff-filter=AD --name-only 2>/dev/null)
modified_md=$(echo "$changed" | grep -E '\.md$' | grep -vE '^README(\.md)?$')

if [[ -z "$structural" && -z "$modified_md" ]]; then
  exit 0
fi

echo "README check: README.md was not updated, but the following changed:"
[[ -n "$structural" ]] && echo "  Added/deleted:" && echo "$structural" | sed 's/^/    /'
[[ -n "$modified_md" ]] && echo "  Modified markdown:" && echo "$modified_md" | sed 's/^/    /'
echo "Consider whether README.md needs updating."

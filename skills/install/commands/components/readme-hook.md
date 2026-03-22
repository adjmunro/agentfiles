# Component: readme-hook

Installs the post-tool-use hook that reminds the agent to update README.md when
a commit touches structural files (skills/, commands/, hooks/, resources.md).

Writes the hook script to `.claude/hooks/readme-check.sh` and registers it in
`.claude/settings.json`.

## DO

- Create `.claude/hooks/` if it does not exist
- Merge the hook registration without clobbering existing settings.json entries
- Check for idempotency: skip if already registered

## DO NOT

- Overwrite an existing `readme-check.sh` that is not from agentfiles — back it up first
- Remove existing hooks from `settings.json` when adding this one

---

## Phase 1 — Write Hook Script

Check whether `.claude/hooks/readme-check.sh` exists.
- If it contains `# PostToolUse hook: remind the agent to update README.md`: already installed — skip to Phase 2.
- If it exists with different content: back up to `.claude/hooks/readme-check.sh.bak`; print warning.
- If it does not exist: proceed.

Create `.claude/hooks/` if needed.

Write the following to `.claude/hooks/readme-check.sh`:

```zsh
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
```

Run `chmod 755 .claude/hooks/readme-check.sh`.

---

## Phase 2 — Register in settings.json

Read `.claude/settings.json`. If it does not exist, treat it as `{}`.

Check whether a `PostToolUse` hook with matcher `"Bash"` and command referencing `readme-check.sh`
already exists. If yes: print "readme-hook already registered — skipped".

Otherwise, merge the following into the `hooks.PostToolUse` array (create the key if absent):

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "zsh .claude/hooks/readme-check.sh"
    }
  ]
}
```

Write the updated settings.json.

Print: "✓ readme-hook registered in `.claude/settings.json`"

---

## Phase 3 — Report

```
✓ readme-hook installed
  Hook script:  .claude/hooks/readme-check.sh
  Registered:   PostToolUse → Bash
  Triggers on:  git commit calls that touch skills/, commands/, hooks/, resources.md
  Suppressed:   when README.md was already updated in the same commit
```

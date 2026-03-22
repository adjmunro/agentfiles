# Component: bash-guard

Installs the pre-tool-use hook that blocks redundant Bash calls and redirects the
agent to dedicated tools (Read, Grep, Glob) instead of cat, grep, rg, find, ls.

Writes the hook script to `.claude/hooks/pre-bash.sh` and registers it in
`.claude/settings.json`.

## DO

- Create `.claude/hooks/` if it does not exist
- Merge the hook registration into `.claude/settings.json` without clobbering existing entries
- Check for idempotency: skip if the hook is already registered

## DO NOT

- Overwrite an existing `pre-bash.sh` that is not from agentfiles (back it up first)
- Remove existing hooks from `settings.json` when adding this one

---

## Phase 1 — Write Hook Script

Check whether `.claude/hooks/pre-bash.sh` exists.
- If it contains `# PreToolUse hook: redirect redundant Bash calls`: already installed — skip to Phase 2.
- If it exists with different content: back up to `.claude/hooks/pre-bash.sh.bak`; print warning.
- If it does not exist: proceed.

Create `.claude/hooks/` if needed.

Write the following to `.claude/hooks/pre-bash.sh`:

```zsh
#!/usr/bin/env zsh
# PreToolUse hook: redirect redundant Bash calls to dedicated Claude Code tools.
# Output must be valid JSON. Exit 2 = block the tool call.

input=$(</dev/stdin)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""' | sed 's/^[[:space:]]*//')

block() {
  echo "{\"decision\": \"block\", \"reason\": \"$1\"}"
  exit 2
}

# Allow pipeline commands — dedicated tools don't support piping.
if echo "$cmd" | grep -q '|'; then
  echo "{}"
  exit 0
fi

tool=$(echo "$cmd" | awk '{print $1}')

# Redirect standalone file-reading commands → Read tool
if echo "$cmd" | grep -qE '^(cat|head|tail) '; then
  block "Use the Read tool instead of \`$tool\`. It provides structured output with line numbers and supports offset\/limit pagination for large files."
fi

# Redirect standalone search commands → Grep tool
if echo "$cmd" | grep -qE '^(grep|rg|egrep|fgrep) '; then
  block "Use the Grep tool instead of \`$tool\`. It provides structured results, output_mode control, and context lines."
fi

# Redirect standalone file discovery → Glob tool
if echo "$cmd" | grep -qE '^(find|fd) '; then
  block "Use the Glob tool instead of \`$tool\` for file discovery."
fi

# Redirect standalone directory listing → Glob tool
if echo "$cmd" | grep -qE '^ls( |$)'; then
  block "Use the Glob tool instead of \`ls\` for directory listing."
fi

echo "{}"
exit 0
```

Run `chmod 755 .claude/hooks/pre-bash.sh`.

---

## Phase 2 — Register in settings.json

Read `.claude/settings.json`. If it does not exist, treat it as `{}`.

Check whether a `PreToolUse` hook with matcher `"Bash"` and command referencing `pre-bash.sh`
already exists. If yes: print "bash-guard already registered in settings.json — skipped".

Otherwise, merge the following into the `hooks.PreToolUse` array (create the key if absent):

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "zsh .claude/hooks/pre-bash.sh"
    }
  ]
}
```

Write the updated settings.json.

Print: "✓ bash-guard registered in `.claude/settings.json`"

---

## Phase 3 — Report

```
✓ bash-guard installed
  Hook script:  .claude/hooks/pre-bash.sh
  Registered:   PreToolUse → Bash
  Blocks:       cat, head, tail → Read tool
                grep, rg → Grep tool
                find, fd → Glob tool
                ls → Glob tool
  Allows:       piped commands (| present)
```

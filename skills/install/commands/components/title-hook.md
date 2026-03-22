# Component: title-hook

Installs the session title hook that sets the terminal window/tab title to reflect
the current git context — repo name, branch, or open PR.

Writes the hook script to `.claude/hooks/title-update.sh` and registers it in
`.claude/settings.json` for both `SessionStart` and `UserPromptSubmit` events.

## DO

- Create `.claude/hooks/` if it does not exist
- Merge both hook registrations without clobbering existing settings.json entries
- Check for idempotency: skip each registration if already present

## DO NOT

- Overwrite an existing `title-update.sh` that is not from agentfiles — back it up first
- Remove existing hooks from `settings.json` when adding these

---

## Phase 1 — Write Hook Script

Check whether `.claude/hooks/title-update.sh` exists.
- If it contains `# Sets the Ghostty (or any OSC-compatible terminal) window/tab title`: already installed — skip to Phase 2.
- If it exists with different content: back up to `.claude/hooks/title-update.sh.bak`; print warning.
- If it does not exist: proceed.

Create `.claude/hooks/` if needed.

Write the following to `.claude/hooks/title-update.sh`:

```zsh
#!/usr/bin/env zsh
# Sets the Ghostty (or any OSC-compatible terminal) window/tab title
# to reflect the current Claude session context.
#
# Called from SessionStart and UserPromptSubmit hooks.
# Writes OSC 0 escape sequence to /dev/tty (not stdout, which is JSON).

input=$(</dev/stdin)
cwd=$(echo "$input" | jq -r '.cwd // ""')
event=$(echo "$input" | jq -r '.hook_event_name // ""')

[[ -n "$cwd" ]] && cd "$cwd" 2>/dev/null

set_title() {
  printf '\033]0;%s\007' "$1" > /dev/tty
}

# Derive a short repo name from the remote URL (handles HTTPS and SSH remotes)
repo=$(git remote get-url origin 2>/dev/null | sed 's/.*[/:]\([^/:]*\)\.git$/\1/; s/.*[/:]\([^/:]*\)$/\1/')
branch=$(git branch --show-current 2>/dev/null)

if [[ -z "$repo" ]]; then
  # Not a git repo — use the directory name
  set_title "$(basename "$cwd")"
  echo "{}"
  exit 0
fi

# On SessionStart, check for an open PR (gh is too slow for every prompt submit)
if [[ "$event" == "SessionStart" ]]; then
  pr_json=$(timeout 3 gh pr view --json number,title 2>/dev/null)
  if [[ -n "$pr_json" ]]; then
    pr_num=$(echo "$pr_json" | jq -r '.number')
    pr_title=$(echo "$pr_json" | jq -r '.title' | cut -c1-40 | sed 's/ *$//')
    set_title "$repo · PR #$pr_num · $pr_title"
    echo "{}"
    exit 0
  fi
fi

if [[ -z "$branch" || "$branch" == "main" || "$branch" == "master" || "$branch" == "develop" ]]; then
  set_title "$repo"
else
  # Humanise branch name:
  # Strip leading ticket prefix: "03-11-", "PROJ-123-", etc.
  # Strip conventional type prefix: feat/, fix/, refactor/, chore/, etc.
  # Replace separators with spaces and truncate.
  short=$(echo "$branch" \
    | sed 's/^[0-9][0-9]-[0-9][0-9]-//' \
    | sed 's/^[A-Z][A-Z]*-[0-9][0-9]*-//' \
    | tr '/_-' '   ' \
    | tr -s ' ' \
    | sed -E 's/^ *(feat|fix|refactor|chore|docs|test|build) //' \
    | cut -c1-28 \
    | sed 's/ *$//')
  set_title "$repo · $short"
fi

echo "{}"
exit 0
```

Run `chmod 755 .claude/hooks/title-update.sh`.

---

## Phase 2 — Register in settings.json

Read `.claude/settings.json`. If it does not exist, treat it as `{}`.

This hook needs two separate registrations. For each, check if it already exists
(matcher + command referencing `title-update.sh`) — if so, skip that registration.

**Registration 1 — SessionStart:**

Merge into `hooks.SessionStart` array:
```json
{
  "matcher": "",
  "hooks": [
    {
      "type": "command",
      "command": "zsh .claude/hooks/title-update.sh"
    }
  ]
}
```

**Registration 2 — UserPromptSubmit:**

Merge into `hooks.UserPromptSubmit` array:
```json
{
  "matcher": "",
  "hooks": [
    {
      "type": "command",
      "command": "zsh .claude/hooks/title-update.sh"
    }
  ]
}
```

Write the updated settings.json once (with both registrations applied).

Print: "✓ title-hook registered in `.claude/settings.json` (SessionStart + UserPromptSubmit)"

---

## Phase 3 — Report

```
✓ title-hook installed
  Hook script:  .claude/hooks/title-update.sh
  Registered:   SessionStart, UserPromptSubmit
  Sets title:   {repo}                           on main/master/develop
                {repo} · {short-branch}          on feature branches
                {repo} · PR #{n} · {title}       when a PR is open (SessionStart only)
                {dirname}                        outside git repos
  Requires:     jq, git  (gh optional — for PR detection)
```

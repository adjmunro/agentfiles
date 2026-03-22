# Component: sign-hook

Installs the batch commit-signing pre-push hook. Delegates to the
`install-sign-hook` command, reading it either from a local agentfiles checkout
or directly from GitHub.

## DO

- Prefer `$AGENTFILES_PATH` if it is set and valid (local read)
- Fall back to fetching `install-sign-hook.md` from `$AGENTFILES_URL` via WebFetch
- Execute the command with the current working directory as the target

## DO NOT

- Duplicate any logic from `install-sign-hook.md`

---

## Delegation

**If `$AGENTFILES_PATH` is set and valid:**
Read `$AGENTFILES_PATH/commands/install-sign-hook.md` and execute it, treating
the current working directory as `$ARGUMENTS`.

**Otherwise:**
Fetch `$AGENTFILES_URL/commands/install-sign-hook.md` via WebFetch and execute it,
treating the current working directory as `$ARGUMENTS`.

That command handles all of:
- Installing `~/.local/bin/git-sign-branch` (fetching the script from agentfiles if needed)
- Checking `$PATH`
- Detecting and backing up any existing pre-push hook
- Writing and making the new hook executable
- Verification

Report its output directly.

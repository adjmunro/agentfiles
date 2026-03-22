# Component: sign-hook

Delegates entirely to the existing `install-sign-hook` command. All logic for
resolving the repository, installing `git-sign-branch`, and writing the pre-push
hook lives there. This file is a thin handoff so the install dispatcher can
invoke it uniformly alongside the other components.

**Inputs:** `$TARGET`, `$AGENTFILES_ROOT`

## DO

- Pass `$TARGET` as the argument to `install-sign-hook`
- Report whatever that command reports, verbatim

## DO NOT

- Duplicate any logic from `install-sign-hook.md`
- Add steps before or after the delegation

---

## Delegation

Read `$AGENTFILES_ROOT/commands/install-sign-hook.md` now and execute it,
treating `$TARGET` as the `$ARGUMENTS` value for that command.

That command handles everything:
- Resolving the target repository
- Installing `~/.local/bin/git-sign-branch` from `$AGENTFILES_ROOT/scripts/sign-branch.sh`
- Checking whether `~/.local/bin` is on `$PATH`
- Detecting and backing up any existing pre-push hook
- Writing and making executable the new hook
- Verifying the installation

Report its output directly.

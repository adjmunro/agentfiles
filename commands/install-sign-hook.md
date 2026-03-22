---
argument-hint: "[repo-path] — defaults to the current directory"
---

# Install Sign Hook

Installs the batch commit-signing pre-push hook into a git repository.

After installation, running `git push` in that repository will automatically
sign all unsigned commits authored by the current git user before the push
goes out — with no extra steps required.

## What gets installed

1. **`~/.local/bin/git-sign-branch`** — the signing script (shared across all repos)
2. **`<repo>/.git/hooks/pre-push`** — a minimal hook that calls the script

The hook calls `git-sign-branch` rather than inlining the logic, so updating
the script in `~/.local/bin/` propagates to all repos that have the hook
installed without reinstalling.

## Steps

### 1. Resolve target repository

If `$ARGUMENTS` is provided, treat it as the repo path. Otherwise use the current
working directory. Verify it is a git repository (`git rev-parse --git-dir`).

### 2. Install `git-sign-branch` to `~/.local/bin/`

- Create `~/.local/bin/` if it does not exist.
- Copy `scripts/sign-branch.sh` from the agentfiles directory to
  `~/.local/bin/git-sign-branch`.
- Set permissions: `chmod 755 ~/.local/bin/git-sign-branch`.
- The agentfiles directory is the repository containing this command file.
  Resolve it as the parent of the directory containing this file
  (i.e., `$(dirname $0)/..` or equivalent).

### 3. Check PATH

Check whether `~/.local/bin` is in `$PATH`. If it is not, print a clear warning:

```
Warning: ~/.local/bin is not in your PATH.
Add the following to your ~/.zshrc:
  export PATH="$HOME/.local/bin:$PATH"
```

Do not abort — continue with the hook installation regardless.

### 4. Handle existing pre-push hook

Check whether `<repo>/.git/hooks/pre-push` already exists.

- If it already calls `git-sign-branch`, print "already installed" and stop.
- If it exists and does something else, back it up as `pre-push.bak` and print a
  warning that the original was preserved. Then install the new hook.
- If it does not exist, proceed with installation.

### 5. Install the pre-push hook

Write the following to `<repo>/.git/hooks/pre-push`:

```zsh
#!/usr/bin/env zsh
# Batch-sign unsigned commits before push.
# Installed by agentfiles install-sign-hook.
exec git-sign-branch
```

Set permissions: `chmod 755 <repo>/.git/hooks/pre-push`.

### 6. Verify

Run `git-sign-branch` from within the target repository with no arguments to
confirm it executes without error. An exit code of 0 (even with "nothing to sign")
confirms the installation is working.

Report what was installed and where.

## Removing the hook

To uninstall, delete `<repo>/.git/hooks/pre-push`.
To remove the script entirely, delete `~/.local/bin/git-sign-branch`.

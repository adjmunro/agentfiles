# Stacks and moved bases

A stack is a chain of branches, each built on the one below it. Rebasing one branch in a stack affects the branches above it. When a lower branch merges, and especially when it is squash-merged, the branches above it still carry the lower branch's original commits.

Before running anything below, tag a backup for **every** branch the command will rewrite, not only the current branch (SKILL.md step 3).

## Graphite (`gt`)

Use Graphite when `preflight.sh` reports `graphite: tracked`. Graphite records each branch's parent. If you rebase a tracked branch with raw `git rebase`, those records go stale.

| Goal | Command |
|---|---|
| Bring the stack up to date | `gt restack --no-interactive`. With no flags this restacks the whole stack, both the branches below and the ones above. Use `--upstack` to leave the branches below alone, or `--only` for just this branch. |
| Continue after resolving a conflict | Stage the files by name (`git add <path>` and `gt add <path>` both work), then `gt continue --no-interactive` |
| Give up | `gt abort --no-interactive` restores the branches |
| Re-parent onto a different branch | `gt move --onto <target> --no-interactive`. Only with the user's confirmation, because it rewrites Graphite's parent records. |

If the user names trunk ("rebase onto main") but the branch's parent is another branch in the stack, they almost always mean "bring my stack up to date with main". That means fast-forwarding trunk and then running `gt restack`. `gt move --onto main` would instead take the parent's commits out of this branch, so run it only if the user confirms that is what they want.

`gt restack` does not fetch. It rebases onto the parent's *local* tip. When trunk is behind its remote, update it first:
- `git fetch <remote> <trunk>:<trunk>` fast-forwards local trunk without checking it out. It refuses if the update is not a fast-forward, or if trunk is checked out somewhere.
- `gt sync` also fetches and restacks, but it offers to delete branches whose PRs have merged. Ask the user before running it.

Avoid `gt continue -a`, which stages everything, including untracked junk. `gt restack` has no `--exec`, so check each branch afterwards (SKILL.md step 6).

## gh stack (`gh stack`, GitHub CLI extension)

Use gh stack when `preflight.sh` reports `gh-stack: in a stack`. If a `gh-stack` skill is installed, load it, because it covers the non-interactive flags.

| Goal | Command |
|---|---|
| Fetch trunk and rebase the whole stack | `gh stack rebase` |
| Rebase only part of the stack | `gh stack rebase --upstack`, `--downstack` or `--no-trunk` |
| Continue after resolving a conflict | Stage the files, then `GIT_EDITOR=true gh stack rebase --continue` |
| Give up | `gh stack rebase --abort` restores every branch |

A conflict makes the command exit with code 3. `gh stack sync` pushes as well as rebasing, so use it only if the user asked to push. gh stack notices squash-merged lower branches and uses `--onto` for them on its own.

## Other tools

If the repository is clearly managed by another tool (git-branchless, Sapling, Jujutsu, spr, and so on), use that tool's restack or sync command. If you are unsure whether it is in use, ask.

## Plain git stacks

`preflight.sh` lists other local branches inside the range under `other-local-branches-inside-range`.

- Rebase from the **top** branch with `git rebase --update-refs <target>`. Every branch pointing into the range moves with it. This is the default when `rebase.updateRefs` is set. It will not move a branch that is checked out in another worktree.
- If the user wants only the current branch moved, use `--no-update-refs` and tell them that the branches below it now point at the old commits.

## The parent branch was merged or rewritten

Symptoms:
- The replay list in `preflight.sh` includes commits that belong to the parent branch.
- The early stops conflict with a target commit that already contains the same work, often a squash commit whose message lists those subjects.

`--cherry-mark` only detects commits whose patches are identical. It does **not** detect squash merges, rebase merges with edits, or a parent branch that was force-pushed.

Fix: replay only this branch's own commits.

```sh
git rebase --onto <target> <old-base>
```

`<old-base>` is the last commit that belongs to the parent, which is the commit just before this branch's first own commit. To find it:
- If the parent branch still exists locally with its pre-merge tip, `git merge-base --fork-point <parent> <branch>` often gives it. Otherwise use the parent's reflog.
- If the parent branch has been deleted, look in HEAD's reflog: `git reflog | grep 'moving from <parent> to'` shows its tip at the moment you left it. The merged PR's head commit on the hosting service also gives it.
- Otherwise read `git log --oneline <target>..<branch>` and choose the boundary by author, subject and content. State which commit you chose and why.

Pass the same `<old-base>` to `verify.sh`. A plain `git rebase <target>` that skips each parent commit as it stops can end in the same place, but it is noisier, and every skip needs its own evidence.

## Verifying a stack

Verify each rewritten branch separately, from the bottom of the stack up. For a branch whose parent was rebased too, run `verify.sh <branch-backup> <parent-new-tip> <parent-backup>`. The parent's backup tag is exactly the old base of that branch.

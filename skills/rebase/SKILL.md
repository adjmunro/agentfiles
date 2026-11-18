---
name: rebase
description: Use when the user asks to rebase or restack a Git branch onto another branch or ref, update a branch after its parent branch was merged or squash-merged, or resolve conflicts in a rebase that is already in progress, including branches managed by Graphite (gt) or gh stack. Also use when the user invokes /rebase.
---

# Rebase

Begin your first message or report after loading this skill with `🔀 rebase`, so the user can see it's running.

Replay a branch onto a new base so that the target's changes and the branch's intent both survive, then prove it by comparing the result against a backup.

The scripts are in this skill's `scripts/` directory. Run them as `sh <skill-dir>/scripts/<name>.sh`. They are POSIX `sh`, change no refs, index or working tree, and are safe to run at any time.

## Scope and consent

Invoking this skill authorises:
- rewriting the commits of the branch being rebased, plus the other branches in its stack when a stacking tool or `--update-refs` moves them;
- changing a replayed commit's content to resolve a conflict, or to make a mechanical fix for a break the rebase caused (a rename, an import path, a signature);
- leaving out commits whose changes are shown to be upstream already, whether by `--skip` or by an `--onto` boundary. Report each one with the evidence;
- creating and deleting the backup tags described below;
- `git fetch`, and fast-forwarding a local trunk with `git fetch <remote> <trunk>:<trunk>`, which refuses anything that is not a fast-forward.

Ask first before any of these:
- pushing;
- rewording, squashing, splitting or reordering commits, or dropping any commit that is not proven redundant;
- changing behaviour that neither side changed;
- stashing, committing or discarding uncommitted work;
- changing git config;
- re-parenting a branch in a stacking tool.

Urgency ("just get it done") does not turn an ask-first item into an allowed one. If you have to ask before you have started, leave the repository untouched. If you have to ask mid-rebase, leave it paused at the stop.

This skill sets no commit-message format and no history policy. When you do write a message or choose where a fix goes, follow the user's and the repository's own instructions (for example CLAUDE.md, AGENTS.md or CONTRIBUTING) and match the style in `git log`.

## 1. Survey

If the repository has a remote, run `git fetch` first. Then run `sh <skill-dir>/scripts/preflight.sh [<target>]` and work through its output against this table:

| Finding | Action |
|---|---|
| `operation-in-progress: rebase` | You are resuming. Tag `rebase.orig-head` as the backup (step 3). Check `rebase.non-pick-todo-lines` and `rebase.todo-remaining`: if the user edited the plan, keep their edits. Treat `rebase.old-base-guess` as a guess and confirm it against the commit list. The user may have half-resolved the current stop, so read the conflicted files as they stand before changing or regenerating them. Read the rest of the survey, which compares the original tip against `rebase.onto`, then go to step 5. |
| Any other operation in progress | Stop and ask. |
| `branch` is detached or unborn | Stop. Ask the user to check out a named branch. |
| `uncommitted-tracked-changes` > 0 | Ask whether to commit or stash them. Do not rely on `rebase.autoStash`: a stash that conflicts on pop is easy to miss. |
| `target: <not given>` | If Graphite or gh stack tracks the branch, its parent or trunk is the target. Otherwise propose `default-branch` and ask. |
| `target-vs-its-upstream` shows the local target is behind | If it is only behind: for a stacking tool, fast-forward the local trunk (`references/stacks.md`). Otherwise rebase onto the remote-tracking ref (for example `origin/main`) and say so. If it is ahead or has diverged, ask. |
| `already-on-target: yes` with no "but … is behind" | Nothing to do. Report that and stop. |
| `upstream` is set | The branch is published, and rewriting it will force others to reconcile. Say so in the report. |
| `commits-not-by-you` lists anyone | If the user asked you to rebase this branch and these commits are its own work, proceed and name the authors in the report. If they look like a parent branch's commits, see the next row. If the branch is shared with others who push to it, confirm first. |
| `possibly-already-upstream` lists commits, or the replay list includes a parent branch's commits | The parent was probably merged or squash-merged. Use `--onto` (`references/stacks.md`). |
| `graphite: tracked`, `gh-stack: in a stack`, or `other-local-branches-inside-range` is non-empty | Read `references/stacks.md` before going further. |
| `autosquash-commits-in-range` with `rebase.autoSquash=true` | Those `fixup!` commits will be folded in. Ask, or pass `--no-autosquash`. |
| `merge-commits-in-range` | Ask whether to keep them (`--rebase-merges`) or flatten them. |

Then read `files-changed-on-both-sides`, `target-commits-touching-those-files` (their full messages too) and `renames-and-deletes`. They show where the conflicts will be and why the target made its changes. If the two sides clearly contradict each other (see "Escalate" in `references/conflicts.md`), raise it now, before starting.

## 2. Choose the command

| Situation | Command |
|---|---|
| Graphite tracks the branch | `gt restack` (`references/stacks.md`) |
| gh stack tracks the branch | `gh stack rebase` (`references/stacks.md`) |
| The repo uses another stacking tool | That tool's own restack command. Mixing in raw `git rebase` leaves the tool's metadata stale. |
| Commits from an old base must not be replayed | `git rebase --onto <target> <old-base>` |
| Plain branch | `git rebase <target>`. Add `--update-refs` if other local branches in the range should move too (this is already the default when `rebase.updateRefs=true`). |

## 3. Back up

Tag every branch that will be rewritten:

```sh
git tag "backup/<branch>/$(date +%Y%m%d-%H%M%S)" <branch>
```

Use a tag and not a branch. `rebase.updateRefs`, `--update-refs` and stacking tools move any *branch* that points into the rebased range, so a backup branch at HEAD gets rewritten along with everything else. Tags are never moved.

For each branch, also record `onto` (the resolved target commit) and `old-base` (the `<old-base>` given to `--onto`, otherwise `git merge-base <branch> <target>`).

## 4. Run it without prompts

- Prefix git commands that might open an editor with `GIT_EDITOR=true`, unless the environment already sets it (`env.GIT_EDITOR` in the survey). After a conflict, `git rebase --continue` opens `core.editor`, and without a terminal that hangs.
- Pass `--no-interactive` to `gt` (a Graphite flag; plain `git` has no such option). Never run `git rebase -i` unless you also set `GIT_SEQUENCE_EDITOR` to a command that writes the todo list.
- Consider `--exec` when the project has a fast check command and the branch has several commits, for example `git rebase --exec '<check>' <target>`. The rebase then stops on the first commit the check fails, with HEAD at that commit. Fix the problem, run `git add` and `git commit --amend --no-edit`, then continue.
- **Sign as you go.** Add `-S` to every `git rebase` command (it works with `--onto`, `--exec` and `--update-refs`), so each replayed commit is signed. Don't rely on `commit.gpgsign`: it's deliberately left `false`, and don't change it.
- If signing fails (a GPG, SSH or 1Password agent error, usually a locked agent), run `git rebase --abort` and run the same rebase without `-S`. Then tell the user which commits are unsigned, so they can unlock the agent and have them signed before anything is pushed.

## 5. At each stop

Read `references/conflicts.md` at the first stop. It gives the resolution strategy for each kind of conflict. Then:

1. If you did not already read them in the survey, read the stopped commit (`git show REBASE_HEAD`, message included) and the target commits that touched each conflicted path (`git log <old-base>..<onto> -- <path>`, adding the old path for a rename).
2. Keep the sides straight. During a rebase, **ours** (`HEAD`, stage 2) is the target plus the commits replayed so far, and **theirs** (stage 3) is the commit being replayed. This is the reverse of a merge.
3. Resolve each file to what *this* commit intended. Do not jump ahead to the branch's final state, because later commits will then conflict or come out empty.
4. If the situation is listed under "Escalate" in `references/conflicts.md`, stop and ask before resolving it.
5. If nothing of this commit is left to apply because its intent is already upstream, run `git rebase --skip` (no staging needed). Record the commit and your evidence.
6. Otherwise stage the result with `git add` or `git rm`, check that no conflict markers remain, and run `GIT_EDITOR=true git rebase --continue`, or the stacking tool's continue command.
7. If a commit message now names something the target renamed, leave it alone unless it has become misleading. In that case, propose a rewording rather than doing it.

`git rebase --abort` returns everything to the starting state at any point.

## 6. Verify

A rebase that finishes without conflicts can still be wrong. For each rewritten branch, run:

```sh
sh <skill-dir>/scripts/verify.sh <backup> <onto> <old-base> [<branch>]
```

Pass `<branch>` whenever the branch is not the one checked out (for example the lower branches of a stack). The script checks that the rebase has finished, that `onto` is an ancestor of the result, and that no conflict markers remain. It compares the commits with `range-diff`, then compares the result's tree against a model three-way merge of `onto` and `backup` over `old-base`.

| Exit | Meaning | What you do |
|---|---|---|
| 0 | Identical to the model merge. | Nothing to review. |
| 1 | Differs only in files the model merge could not resolve. | Review each file with `git diff <model> <branch> -- <path>` and explain it using both sides' intent. |
| 2 | Also differs in files the model merge resolved cleanly. | This is expected after a semantic-conflict fix. Give a reason for every such file. If you cannot, the rebase is wrong: fix it. |
| 3 | Not finished, or broken. | Keep going until it passes. |

Every file git can merge by itself must come out byte-for-byte identical to the model unless you give a reason. The model trusts the `old-base` you pass. `verify.sh` lists the commits that an `--onto` boundary excluded, and your report must justify that boundary.

Then check for semantic conflicts, meaning code that applied cleanly but uses something the target renamed, removed or changed (`references/conflicts.md` §6):
- Run the project's usual build, test or lint commands if you can find them and they are affordable. If you cannot, say so.
- Check each rewritten branch, not only the checked-out one, for example in a temporary `git worktree add --detach`.
- A rebase rewrites many files within a second, so build caches that trust timestamps can report stale results. Use the tool's own cache bypass or clean command.
- Leave ignored files as you found them. Remove only caches your own checks created.

If you find a break after the rebase has finished, and the fix is mechanical, fold it into the commit that introduced the incompatible code: run `git commit --fixup=<sha>`, then `GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <onto>`, then `verify.sh` again. The `-i` is needed because git before 2.44 ignores `--autosquash` without it. If the user's or the project's instructions set a different policy for fixes, follow it. If the fix changes behaviour, ask first.

## 7. Clean up and report

Delete the backup tags when `verify.sh` exits 0, or when every difference has been explained and the checks pass (or were not available, and you said so). Include each deleted tag's SHA in the report, so the user can restore it: `git reset --keep <sha>` while on the branch, or `git branch -f <branch> <sha>` from anywhere else. Keep the backup and say so if anything is unexplained, a check failed, or you escalated a decision.

The report contains, in order:
1. The command used, the target, and its resolved SHA.
2. Commits replayed, skipped and dropped, with the evidence for each skip or drop.
3. One line per conflict: the file, what each side intended, and how you resolved it.
4. Any fix you folded into a commit, naming the commit and its author when that is someone other than the user.
5. The `verify.sh` result for each branch, and the checks you ran.
6. The backup's state: deleted (with SHA) or kept (with its name).
7. Next steps. If the branch was already pushed, it now needs a force push. Only push if the user asks. Then use `git push --force-with-lease=<branch>:<sha-the-remote-had-before>`, which refuses if someone else pushed in the meantime.

## Never

- Resolve source files with a blanket `-X ours`/`-X theirs`, or `checkout --ours`/`--theirs`. The one exception is taking a side before regenerating a generated file (`references/conflicts.md` §8).
- Bring back files, paths, syntax or APIs that the target deliberately removed or replaced, just so a patch applies.
- Skip a commit before showing that everything it did is already upstream.
- Delete a backup that verification has not cleared.
- Count "git says it succeeded" as verification.

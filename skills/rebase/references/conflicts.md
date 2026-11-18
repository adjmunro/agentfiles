# Conflict resolution during a rebase

The aim is to keep the intent of both sides. The target branch's structure (paths, names, formats, languages, sources of truth) wins, and the replayed commit's behaviour is re-expressed inside that structure. The exception is when one side deliberately makes the other redundant or invalid. In that case the losing side is dropped, and you give the evidence for dropping it.

The cases below are guidance, not rules. Look at what the code actually does before you apply one.

## Seeing the conflict

| Need | Command |
|---|---|
| What the replayed commit meant | `git show REBASE_HEAD` (read the message as well as the diff) |
| Why the target changed this path | `git log <old-base>..<onto> --follow -p -- <path>` |
| The markers with the common ancestor between the two sides | `git checkout --conflict=zdiff3 -- <path>`. This discards any partial edits to that file, including the user's. |
| Each version whole | `git show :1:<path>` (base), `:2:` (ours = target so far), `:3:` (theirs = replayed commit) |
| Where some code went | `git log -S'<distinctive line>' <old-base>..<onto>`, `git grep`, `git diff --color-moved <old-base> <onto>` |
| The real change behind whitespace noise | `git diff -w` |

Without the base section you cannot tell which side changed a line. Use the zdiff3 view whenever that is unclear.

## 1. Both sides made the same change

Examples: the same fix cherry-picked to both branches, or a parent branch squash-merged into the target.

Keep the target's version. Then check whether the replayed commit contains anything *beyond* the shared change. If it does, keep that part. The target's version may also contain review follow-ups that the branch never had (a squash merge often does). Taking "theirs" would silently revert those, so don't.

If the whole commit turns out to be redundant, run `git rebase --skip` and record the evidence. For a squash merge, the evidence is usually the squash commit's message listing the original subjects, together with a diff showing the target already contains the change.

## 2. Independent edits to the same lines

Example: the target renames `timeout` to `TIMEOUT_S`, and the branch changes its value from 30 to 60. The result is `TIMEOUT_S = 60`.

Combine the two edits. Each side changed a different aspect of the same line (name, type, value, argument, formatting), and both changes should survive. Then look for the same combination elsewhere: the branch may use `timeout` in places that did not conflict.

## 3. Both sides added entries

Examples: imports, list or registry entries, enum cases, changelog lines, routes, dependencies.

Keep both entries, and follow the file's ordering rule (alphabetical, chronological, grouped). If no rule is evident, or several rules fit, and nothing depends on the order, put the branch's entry after the target's and say so. Watch for collisions that git cannot see:

- **Sequential identifiers.** If both sides claimed the same migration number, version code, enum value, error code or port, renumber the branch's entry and update everything that refers to it.
- **Uniqueness.** Both sides may have added the same key with different values. Decide which value is correct instead of keeping both.

## 4. The target moved or renamed something the branch edited

Put the branch's edit where the code lives now. Do not revive the old location.

- **File renames.** Git usually follows these and places the conflict at the new path. It fails when the file was renamed and heavily rewritten in the same commit, and then reports a modify/delete conflict on the old path (see §5).
- **Symbol renames.** Apply the branch's change to the new name, and update any new uses the branch adds (see §6).
- **Code moved inside a file or between files, or a file split in two.** Git does not track this, so the conflict looks like a deletion. Use `git log -S` or `--color-moved` to find where the code went, then apply the edit there.
- **Format or language migrations.** Examples: a config file converted to another format, a build script rewritten in a different DSL, a module ported to another language, inline values moved into a central catalogue. Express the branch's change in the new form and in the new source of truth. Never restore the old form next to it.

If the branch has a good reason to keep the old location, check it before acting. One example is a branch that deliberately adds a *second*, distinct concept that only resembles the moved one.

## 5. One side modified what the other deleted

First find out why the target deleted it: `git log <old-base>..<onto> --diff-filter=D -- <path>`. Read that commit.

| The target deleted it because it was… | Then |
|---|---|
| moved or renamed | Apply the edit at the new location (§4). |
| replaced by a new implementation | Check whether the replacement already covers the branch's change. If it does, drop the change and give the evidence. If it doesn't, port the change to the replacement. |
| a feature that was removed | The branch's change is usually obsolete. Drop it and report it. |
| deleted in a way that looks wrong, given what the branch needs | Escalate. A rebase cannot revise the target, and resurrecting the file quietly undoes someone else's decision. |

For example, the target replaced a hand-written CSV exporter with the standard library's CSV writer, and the branch fixed quoting in the old exporter. The library writer already quotes correctly. That is easy to confirm by running it on a cell that contains a comma. Drop the fix and say why.

In the reverse case the branch deletes something the target modified, for example the target fixed a bug in a file the branch removes. The branch's deletion must now also carry the target's change. Check that whatever replaces the file includes the fix.

To resolve a modify/delete conflict by deleting, use `git rm <path>`. To keep the file, use `git add <path>`.

## 6. Semantic conflicts: clean text, broken code

Git only sees overlapping lines. These combinations apply cleanly and still break:

- The branch adds a new use of something the target renamed, removed or changed the signature of. In the other direction, the target adds new uses of something the branch changes.
- The target adds a required field, parameter or config key, and code the branch adds does not supply it.
- Both sides add a definition with the same name in different files.

How to find them:
- After each stop, and again at the end, compare the identifiers in the branch's added lines (`git diff <onto>...HEAD`) with what the target renamed or removed (`git diff <old-base> <onto>`). Search for the old names.
- Run the project's checks, or run the rebase with `--exec` so each commit is checked as it lands.

Fix each break in the commit that introduced the incompatible use. If that commit has already been replayed, use a fixup commit and autosquash (SKILL.md step 6). Mechanical adaptations are part of resolving the rebase. Behavioural changes need the user's agreement.

## 7. Reformatting on one side, logic change on the other

Examples: re-indenting, reordering, running a formatter, sorting imports.

Take the reformatted text and re-apply the logic change to it. `git diff -w` separates the real change from whitespace noise. Avoid `-X ignore-space-change` wherever whitespace carries meaning (Python, YAML, Makefiles, Markdown lists).

## 8. Generated files and lockfiles

Do not merge these by hand. Take the target's version (stage 2), then regenerate the file with the project's own tool from the merged inputs, such as the dependency manifest. If you cannot regenerate it, say so, and leave the file as the target's version plus a note. Blanket-taking one side is acceptable only in this case.

Binary files cannot be merged at all. Choose one side deliberately and report which.

## 9. The same area conflicts in commit after commit

Resolve each stop to what that commit intended. Don't pull later commits' changes forward. Replaying the same resolution many times is a sign to check with the user. Squashing the branch first, or enabling `rerere`, would help, and both need their agreement.

## Escalate

Stop. Show the user the situation and your recommended resolution, and wait for their decision, when any of these is true:

- Both sides changed the same logic in incompatible ways (for example two different fixes for one bug, or opposing behaviour), and neither commit message says which should win.
- A resolution would mean reverting or reworking a decision the target made (see §5, "deleted in a way that looks wrong").
- You cannot state the intent of either side from its commit message, its diff and the surrounding code.
- Resolving would require a behaviour change that neither side made.
- The remaining choices are drops you cannot prove: dropping a commit, dropping part of one, or dropping someone else's change.

Tell the user, for each file and hunk: what the target intended (with commit refs), what the replayed commit intended, the resolution you propose, how confident you are and why, and the alternative. The rebase stays paused safely while you wait.

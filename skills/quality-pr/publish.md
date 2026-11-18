# Publishing

## Before pushing

- **Base branch:** the closest parent branch that has been pushed. If the branch was cut from another feature branch, target that, not the default branch. Check with `git branch -r --contains $(git merge-base HEAD <candidate>)` and `git log --oneline --graph`. Don't assume `main`/`develop`.
- **Signing:** if any commit in `<base>..HEAD` is unsigned (`git log --format='%h %G? %an %s' <base>..HEAD`, where `N` means unsigned) and every commit there is ours, sign them all in place: `git rebase -f -S $(git merge-base HEAD <base>)` (`-f` rewrites even when nothing moves; the merge-base keeps the tree unchanged). If someone else authored any of them, ask first. Any other rebase (onto a moved base, restacking) follows the `rebase` skill: try with `-S`, and if signing fails, rebase without it. If signing fails, ask the user to unlock the agent (SSH/GPG) and sign before pushing. Never push unsigned as a workaround. Leave `commit.gpgsign` as it is (off on purpose).
- **Forcing:** if the branch is already on the remote and was rewritten, use `git push --force-with-lease`. Never use `--force`.
- **Title:** match recent PRs (`gh pr list --state all -L 10`), e.g. a release prefix plus the ticket key.

## Creating the PR

- **Always a draft:** `gh pr create --draft --assignee @me --base <base> --title ... --body-file body.md`. The user marks it ready; never run `gh pr ready`.
- **Assignee:** always the gh user the PR is for, which is normally the authenticated user (`@me`; check with `gh api user -q .login`). If the user works under several gh accounts, use the one tied to this repository's remote. On an existing PR: `gh pr edit <n> --add-assignee @me`.
- End the body with any attribution line the harness asks for.
- After creating it, bind and check its status with the session's PR tools if there are any.

## Counterpart PRs

Applies when the project names a counterpart repo (its `AGENTS.md`/`CLAUDE.md`, e.g. Android/KMP and iOS) and the change needs work in both.

- **Find it:** `gh pr list --repo <owner>/<other-repo> --state all --search "<ticket>"`, or a branch of the same name. If it's unclear whether it's the same work, ask.
- **Link both ways:** add `**Counterpart:**` to this PR's intro, and the reverse line to the other PR's intro, starting from its live body (`gh pr view`). Write `<owner>/<repo>#<n>`, never a bare `#<n>`, which resolves to this repo. If someone else authored the other PR, ask before editing its body.
- **Not there yet:** say so under "Not covered". Whenever either PR is opened or updated later, check again and link both ways once it exists.

## Stacked PRs (gh stack)

When a PR's base is another PR's branch, track the chain with the `gh stack` extension (`gh extension list`). GitHub then shows the stack on every PR in it, so the body never says what it's stacked on.

- **Make a stack from existing branches and PRs:**
  - `gh stack init --base <trunk> <bottom-branch> ... <top-branch>` adopts the branches locally. Branches checked out in other worktrees are fine.
  - `gh stack link <bottom-PR> ... <top-PR>` creates the stack on GitHub. Linking by PR number pushes nothing; branch names would be pushed.
- **Add a new PR on top:** create it as usual (`gh pr create --draft --base <parent-branch>`, with this skill's body), then `gh stack link <stack-number> <new-PR>`. The stack number is in the stack URL (`.../stack/<n>`). Avoid `gh stack submit`: it creates PRs with auto-generated bodies.
- **Restack** (a parent changed or moved):
  1. Run `gh stack rebase`, or `--upstack`/`--downstack`. The `rebase` skill covers conflicts.
  2. `gh stack rebase` can't sign, so then sign each rewritten branch in place (the Signing step above). If signing fails, leave them unsigned and tell the user.
  3. Push with `gh stack push`, which pushes atomically with a per-branch `--force-with-lease`.
  4. Each rewritten branch's tree has changed: rerun pre-flight for it and update its verification comment. Image tree hashes stay as they are. They record what each image was built from, and an image needs recapturing only if the change touched its screen.
- **Moving a PR into a stack:** rebase it onto the new parent with the `rebase` skill and `-S`. If an unrelated branch points into the range and `rebase.updateRefs` is on, pass `--no-update-refs`. Then push with `--force-with-lease=<branch>:<old-sha>`, run `gh pr edit <n> --base <parent-branch>`, then `gh stack init`/`link` as above.

## Verification comment

Local pre-flight results (provenance line and task table) go in **one** PR comment from `templates/verification-comment.md`, kept apart from the body. Its first line is the marker `<!-- quality-pr:verification -->`. New and changed tests are not results: they go in the body's Tests section.

- Find it: `gh api --paginate "repos/{owner}/{repo}/issues/<n>/comments" --jq '.[] | select(.user.login == "<me>" and (.body | startswith("<!-- quality-pr:verification -->"))) | .id'`
- None yet: `gh pr comment <n> --body-file verification.md`.
- Found: edit it in place, `gh api -X PATCH "repos/{owner}/{repo}/issues/comments/<id>" -F body=@verification.md`. Never post a second one; if there are several, update the newest and ask the user before deleting the rest.
- Update it every time the results change (a rerun, a new commit or tree). Replace the whole table, so it always describes one tree.
- Edits don't notify anyone, and @-mentioning the user in their own comment doesn't either (GitHub never notifies you of your own activity). If a result flips (✅ to ❌ or back), tell the user in the session.
- If an existing PR still has test results in its body, move them into the comment and remove them from the body. If its comment lists new/changed tests, move those into the body's Tests section.

## CI

- Read results from GitHub, not the CI provider's UI: `gh pr checks <n>`, or `gh api "repos/<owner>/<repo>/commits/<sha>/check-runs?per_page=100" --jq '.check_runs[] | "\(.conclusion) \(.name)"'`. Per-module test checks can all pass while the overall workflow fails. Look for the module/variant that has no check at all; that step probably failed before it produced a report.
- Reproduce the failing step locally with the same variant (CI often runs flavours the local pre-flight skips).
- Before blaming the branch, check the same checks on the last few PRs' head commits and run the failing task in a throwaway `git worktree` of the base branch. If it fails there too, it's pre-existing: say so on the PR and ask the user whether to fix it here or separately.

## Images (gh 2.103+)

Never commit images or push a branch to host them.

1. In `body.md`, reference each local file as markdown: `![In session](./2_insession.png)`.
2. Upload them with the body: `gh pr create ... --body-file body.md --attach ./1.png --attach ./2.png` (or `gh pr edit <n> --body-file body.md --attach ...`). gh uploads each file and rewrites its markdown ref to a `https://github.com/user-attachments/assets/...` URL. Run it from the directory the `./` paths are relative to.
3. When adding evidence to an existing PR, start from the live body (`gh pr view <n> --json body -q .body`) so earlier uploads and edits are kept, add the new markdown refs, and `gh pr edit` with `--attach` for just the new files.
4. `--attach` only rewrites markdown refs. To size the images in an evidence table, read the rewritten body (`gh pr view <n> --json body -q .body`), turn each `![alt](url)` into `<img src="url" width="210" alt="alt">` (see `evidence/ui.md`), and `gh pr edit <n> --body-file` it again.
5. If the user says the images are missing, an ad blocker that blocks GitHub's image hosts is the usual cause. It also breaks drag-and-drop uploads in the browser.

---
name: quality-pr
description: Prepare, open, or update a pull request that primes reviewers and proves the change works - a short context intro, a one-concern-per-row change table, new and changed tests, local pre-flight results, and on-device screenshots or network captures or before/after benchmarks where the change calls for them. Use whenever opening, drafting or updating a PR, or when asked for "a PR", "PR evidence" or "screenshots for the PR".
---

# Quality PR

Begin your first message or report after loading this skill with `🚢 quality-pr`, so the user can see it's running.

A PR primes its reviewers, then proves the change works. Collect only the evidence that helps a reviewer judge this change. Read only the files the routing below sends you to.

**Every PR has:** the intro, the concern table and the Tests section in the body (`templates/pr-body.md`), plus the verification comment (`templates/verification-comment.md`). Everything else depends on what the change touches.

## Order of work

1. **Pre-flight** - always. Read `preflight.md`.
2. **Open the draft PR early** (read `publish.md`), with the intro, the concern table and Tests, then post the pre-flight results as the verification comment. If the change has a counterpart PR in a paired repo (e.g. Android/KMP and iOS), link the two (`publish.md`, "Counterpart PRs"). If a draft already exists, work in its body, and update its verification comment in place (never a new one) whenever you rerun.
3. **Plan the evidence.** List each behaviour the change affects, then route. Skip any row that doesn't apply; don't collect evidence nobody needs.

   | The change... | Evidence | Read |
   |---|---|---|
   | affects anything a user sees (incl. error dialogs, empty/loading states) | "On device" screenshots | `evidence/ui.md`, plus `evidence/android.md` or `evidence/ios.md` |
   | makes or depends on network calls | "Network" captures | `evidence/network.md` |
   | needs one of those in a state the real backend won't give on demand | as above | `evidence/forcing-states.md` |
   | is meant to move a measurable metric significantly (build time, binary size, export/method count, start-up), or something in it predicts one gets worse (much more generated code, a new dependency or build step) | "Benchmarks" before/after table | `evidence/benchmarks.md` |
   | none of the above (mapping, parsing, tests only) | none beyond Tests and the verification comment | |

4. **Add evidence to the PR as you collect it** (`gh pr edit --body-file ... --attach ...`), one scenario at a time. Don't hold screenshots or tables locally to post at the end. Keep everything already there. Remove a piece only if it's invalidated (the code it shows changed, or it was captured wrong) or no longer relevant. That way nothing gets captured twice, and work survives an interrupted session.
5. **Write the body** from `templates/pr-body.md`, and keep it up to date as you go: intro, concern table, Tests, then any evidence sections. Delete the sections that don't apply. Run any `unslop`-style pass available over the prose.
6. **Finish:** signing, final push and status. See `publish.md`. Stacked PRs use gh stack (`publish.md`).

## Ground rules

- Never type a real user's password. Use the project's test-account mechanism (check its `AGENTS.md`/`CLAUDE.md`/README) or ask the user to sign in.
- In a git worktree, gitignored local files (test-account credentials, `local.properties`, keys) are missing. Check the main checkout and copy them across, never commit them, then rebuild.
- If a shared test account's sign-in is rejected, try one more at most, then stop. Repeated failures can lock shared accounts.
- A test account labelled read-only, "look but don't touch", shared or similar is read-only. Don't do anything that changes its data (payments, edits, nicknames, linking, settings) without the user's approval. Pick a different account for mutating scenarios.
- Anything that logs the app out costs a sign-in. Run logging-out scenarios last and batch anything that needs the user.
- Keep screenshots and captures in the scratchpad, never in the repo.
- Say in the PR how any forced state was produced. Never fake evidence silently.
- Commits and pushes need the user's go-ahead; "make a PR" covers pushing the branch.

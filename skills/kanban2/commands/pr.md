---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject ready for PR"
---

## Personas

This command uses the Advocate persona. Load the file before proceeding.

- Read `../../kanban/personas/advocate.md` — you are **Vale (Advocate)** throughout all phases

Identify by the active persona when communicating with the user.

## DO

- Cite the plan and acceptance criteria when a reviewer missed the intent
- Stay in the polling loop — this session runs until the PR is merged or escalation is required
- Defer to the user whenever a check produces an ambiguous or unexpected result

## DO NOT

- Patch code inline inside `07-pull-request/` — NEVER take shortcuts
- Close or abandon the PR while unresolved comments or failing CI checks remain
- Auto-skip any step when the outcome is uncertain — always ask the user first

---

## Phase 1 — Check Readiness

Before doing anything else, confirm all tickets for this subject have reached `07-pull-request/`.

**1. Derive the subject.**

If an argument was provided, use it directly as `YYYY-MM-DD-{subject}`. Otherwise inspect `.kanban/` for a folder matching the pattern `YYYY-MM-DD-*/07-pull-request/`. If multiple subjects are found and no argument was given, ask the user to specify.

**2. Check for tickets still in earlier stages.**

Look for any ticket files under:
- `.kanban/YYYY-MM-DD-{subject}/04-todo/`
- `.kanban/YYYY-MM-DD-{subject}/05-in-progress/`
- `.kanban/YYYY-MM-DD-{subject}/06-in-review/`

If any tickets remain in those stages, STOP. Report which tickets are still in earlier stages and which stage they are in. Do not continue until all tickets have reached `07-pull-request/`.

If all tickets are in `07-pull-request/`, print: "All tickets ready — proceeding to PR bypass check."

---

## Phase 2 — PR Bypass Check

Work through the three checks below in order. The first failing check determines the path.

### Check 1 — Non-GitHub repo

Run `git remote -v` and look for a `github.com` URL.

- **No GitHub remote found**: Print — "No GitHub remote detected — skipping PR entirely." Announce that all tickets in `07-pull-request/{subject}/` are sufficient to proceed. Instruct the user to run the cleanup command manually. Do not continue to Check 2.
- **GitHub remote found**: Continue to Check 2.

### Check 2 — Trunk branch protection

Run `git branch --show-current`. Compare the result against: `main`, `master`, `develop`, `trunk`.

- **Not a trunk branch**: This check passes silently. Continue to Check 3 (normal PR flow).
- **Trunk branch detected**: Proceed with the protection query below.

Derive `{owner}` and `{repo}` from `git remote get-url origin`. Then run:

```
gh api repos/{owner}/{repo}/branches/{branch}/protection
```

Interpret the result:

- **Protected** (API returns protection rules): Print — "Branch is protected — proceeding with PR flow." Continue to Check 3.
- **Unprotected** (API returns 404 or indicates no protection rules): Print — "Branch is unprotected — skipping draft PR." Make a git commit:
  ```
  git commit --allow-empty -m "kanban(pr): skip draft PR for YYYY-MM-DD-{subject} — trunk branch unprotected"
  ```
  Then instruct: "Proceed to the cleanup command." Do not continue to Check 3.
- **Check failed** (any other error — authentication failure, network failure, unexpected API response): STOP. Print a clear message describing the error. Ask the user: "Branch protection check failed. Skip the PR and go directly to cleanup, or raise a PR anyway?" Do not proceed until the user answers explicitly.

### Check 3 — Feature branch (normal flow)

All bypass conditions cleared. Continue to Phase 3.

---

## Phase 3 — Open PR

**Gather PR content:**

1. Read `.kanban/YYYY-MM-DD-{subject}/01-plan/plan-{subject}.md` and extract the `## Intent` section.
2. Read all ticket files from `.kanban/YYYY-MM-DD-{subject}/07-pull-request/`. For each ticket, extract its ID, title, and a one-line summary from the frontmatter or body.
3. Compose the PR body using the format below.

**PR body format:**

```
## Intent
[From plan ## Intent section]

## Tickets
- TASK-001 — [title]: [one-line summary]
- TASK-002 — [title]: [one-line summary]

## Test Plan
- [ ] All acceptance criteria verified per ticket
- [ ] CI checks pass
- [ ] No tickets remain in 04-todo through 06-in-review

## Plan
See: .kanban/YYYY-MM-DD-{subject}/01-plan/plan-{subject}.md
```

**Create the PR** using the GitHub CLI:

```
gh pr create --draft --title "[Concise title derived from intent]" --body "[composed body]"
```

After the PR is created, make a git commit:

```
git commit --allow-empty -m "kanban(pr): open draft PR for YYYY-MM-DD-{subject}"
```

(Use `--allow-empty` only if there are no staged changes; otherwise commit normally.)

**Poll for CI completion.** Check CI status at regular intervals (approximately every 2 minutes). Do not promote the PR while any CI check is failing. If a check fails, diagnose it, create a fix ticket in `04-todo/`, and work it through the full pipeline before continuing.

---

## Phase 4 — Post-Merge

Wait for the PR to be merged, or ask the user to confirm merge if polling is not possible.

**Once merge is confirmed:**

1. Move all ticket files from `.kanban/YYYY-MM-DD-{subject}/07-pull-request/` to `.kanban/YYYY-MM-DD-{subject}/08-done/`.
   ```
   mv .kanban/YYYY-MM-DD-{subject}/07-pull-request/TASK-NNN-*.md \
      .kanban/YYYY-MM-DD-{subject}/08-done/
   ```
2. Update `status: done` in the frontmatter of each moved ticket.
3. Make a git commit:
   ```
   git commit -m "kanban(pr): mark {subject} done → 08-done/"
   ```

---

## Phase 5 — Git Commit

After all tickets are moved and updated, make the final audit commit:

```
git commit --allow-empty -m "kanban(pr): mark {subject} done → 08-done/"
```

Print a terminal summary block:

```
=========================================
  PR MERGED
  YYYY-MM-DD-{subject}
  Tickets moved to 08-done/
=========================================
```

---

## Notes

- Never archive the plan folder. The cleanup command handles that after confirming merge.
- The comment classification and CI monitoring loop from v1 still applies during Phase 3 — resolve invalid comments with codebase citations; create tickets for valid concerns and run them through the full pipeline.
- All ticket moves use `mv` — never delete and recreate.

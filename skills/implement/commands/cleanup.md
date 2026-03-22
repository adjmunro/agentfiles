---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to archive"
---

## Personas

- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phases 1–2
- `../../personas/analytics/persona.md` — **Pulse (Analytics)** — active in Phase 6

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Verify every precondition before touching any file
- Confirm all tickets are in `08-done/` before proceeding to archive
- Move the subject folder; never copy-and-leave or delete-without-archiving
- Remove only empty stage directories inside the subject folder — never remove `08-done/` or `00-assets/`
- Commit the archive with the canonical git message

## DO NOT

- DO NOT proceed if any tickets remain in `04-todo/`, `05-in-progress/`, `06-in-review/`, or `07-pull-request/` for this subject
- DO NOT remove `08-done/` — it always has content and must survive the archive
- DO NOT remove `00-assets/` — preserve it even if empty (check for `.gitkeep`); it may contain referenced assets
- DO NOT skip the git commit — it is the final record that this subject is sealed

---

## Subject Derivation

If `[YYYY-MM-DD-{subject}]` is provided as an argument, use it directly.

If omitted, scan `.kanban/` for subject directories at the top level (not inside stage directories — the subject is the top-level directory). Ask the user which subject to archive before proceeding if multiple candidates exist.

The subject folder lives at: `.kanban/{subject}/` (e.g., `.kanban/2026-03-21-my-feature/`).

---

## Phase 1 — Completion Check

**Arden is active. Do not skip checks. Do not approve incomplete subjects.**

Check that ALL of the following stage directories inside the subject folder are empty (contain no ticket files):

- `.kanban/{subject}/04-todo/`
- `.kanban/{subject}/05-in-progress/`
- `.kanban/{subject}/06-in-review/`
- `.kanban/{subject}/07-pull-request/`

Check that `08-done/` is non-empty (contains at least one ticket file).

**Completion signal: zero tickets in `04-todo/` through `07-pull-request/`, non-zero tickets in `08-done/`.**

If any tickets remain in the earlier stages, list every blocking ticket by path and name. Then STOP — do not proceed to Phase 2.

Print:
```
STOP: {subject} is not complete.
Remaining tickets:
  - {path/TASK-NNN-name.md}
  ...
Run /implement work and /implement review to finish them first.
```

If Phase 1 passes (all earlier stages empty, `08-done/` non-empty), print:
```
Phase 1 PASS — all tickets are in 08-done/. Proceeding to Phase 2.
```

---

## Phase 2 — Audit Summary

Count all ticket files inside `.kanban/{subject}/08-done/`. Report:

- **Total tickets completed:** N
- **Tickets found:** list each by filename

Do a quick sanity check on each ticket's frontmatter `status` field — all should read `done`. If any ticket has a status other than `done`, flag it by name before continuing. This is advisory only (do not block archive for a stale status field) but name every anomaly.

Print a brief summary before moving on.

---

## Phase 3 — Clean Empty Directories

Remove all empty stage directories inside the subject folder. Target directories:

- `.kanban/{subject}/03-refinement/` — remove if empty
- `.kanban/{subject}/04-todo/` — remove if empty (must be empty by Phase 1)
- `.kanban/{subject}/05-in-progress/` — remove if empty (must be empty by Phase 1)
- `.kanban/{subject}/06-in-review/` — remove if empty (must be empty by Phase 1)
- `.kanban/{subject}/07-pull-request/` — remove if empty (must be empty by Phase 1)

**Always keep:**
- `.kanban/{subject}/08-done/` — always has content; never remove
- `.kanban/{subject}/00-assets/` — preserve even if empty; check for `.gitkeep` before deciding; do not remove

Use `rmdir` (not `rm -rf`) so that removal fails safely if a directory is non-empty.

Also preserve any loose docs at the subject root matching these patterns (they move with the subject folder automatically):
- `00-input-*`
- `01-research-*`
- `02-plan-*`

---

## Phase 4 — Archive

Move the entire subject folder to the archive directory.

**Archive path:** `.kanban/.archive/{subject}/`

- `.kanban/.archive/` is a hidden dot-directory. Create it if it does not exist:
  ```bash
  mkdir -p .kanban/.archive/
  ```

- Move the subject folder:
  ```bash
  mv .kanban/{subject}/ .kanban/.archive/{subject}/
  ```

The `{subject}` variable already contains the `YYYY-MM-DD-` date prefix (e.g., `2026-03-21-my-feature`). Do not prepend today's date again.

**Verify the archive before confirming success:**

Check that `.kanban/.archive/{subject}/08-done/` exists and contains the expected ticket files. If the move failed or `08-done/` is missing, STOP and report the error.

**Final state inside the archived folder (expected):**

```
.kanban/.archive/{subject}/
├── 08-done/          ← all completed tickets
├── 00-assets/        ← preserved (even if empty with .gitkeep)
└── [loose docs]      ← 00-input-*, 01-research-*, 02-plan-* (if present)
```

After the move, the subject is no longer live — it is archived. The original `.kanban/{subject}/` directory will no longer exist.

---

## Phase 5 — Git Commit

Stage all moved and removed files and commit with the canonical message:

```
kanban(cleanup): archive {subject}
```

Example:
```bash
git add -A .kanban/.archive/{subject}/
git add -u .kanban/{subject}/
git commit -m "kanban(cleanup): archive {subject}"
```

After the commit, proceed to Phase 6.

---

## Phase 6 — Reporting

**You are now Pulse.** Report the archive facts, then the metrics. Keep the metrics honest — one sprint isn't a trend, but it's still a data point worth naming.

After a successful archive, report:

- **Archived subject:** `{subject}`
- **Archive path:** `.kanban/.archive/{subject}/`
- **Tickets completed:** N total

**Metrics (derive from ticket frontmatter and git log):**

- **Tickets:** N total — N passed first review, N required multiple attempts
- **Failure rate:** N% of tickets failed at least one review
- **Average cycles per ticket:** N work→review loops (total loops / total tickets)
- **Any ticket stuck 3+ times:** list by ID if applicable

One sentence on what the numbers suggest — not a conclusion, a question worth asking next time.

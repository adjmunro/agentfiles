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
├── 08-done/              ← all completed tickets
├── 00-assets/            ← preserved (even if empty with .gitkeep)
├── 00-quality-{subject}.md  ← quality envelope (req 1.4 — must survive to archive)
└── [loose docs]          ← 00-input-*, 01-research-*, 02-plan-* (if present)
```

<!-- WHY 00-quality-{subject}.md is named here: the mv command carries the whole subject folder
     so the file moves automatically, but naming it explicitly ensures no cleanup step accidentally
     removes it and satisfies req 1.4 which requires the envelope to survive to .archive/.
     Removing this note would make it easy to "helpfully" delete the file thinking it's orphaned. -->

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

## Phase 6 — Reporting and Quality Envelope

**You are now Pulse.** Report the archive facts, metrics, and then write the quality envelope signals. Keep the metrics honest — one sprint isn't a trend, but it's still a data point worth naming.

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

---

### Phase 6a — Plan Drift Measurement

<!-- WHY this runs after the archive move (not before): git diff uses HEAD and the archived path,
     so the plan file must already be at .kanban/.archive/{subject}/02-plan-{subject}.md for the
     diff to resolve correctly. Running before the move would compare the live path, which may
     differ from the archived path once cleanup commits remove staged files. Satisfies req 3.1. -->

After reporting the summary metrics above, measure how much the plan file drifted from its creation to the archive commit.

**Step 1 — Find the first commit that created the plan file (req 3.2):**

```bash
git log --follow --diff-filter=A --format="%H %ai" -- .kanban/{subject}/02-plan-{subject}.md
```

This returns the commit SHA and date of the first commit that introduced the plan file. Take the first (oldest) result.

- If git is not available or the command fails: skip Steps 2–4 and write `Plan drift: unavailable (no git history)` in the envelope. Proceed to Phase 6b.
- If the command returns no output (plan file was never committed independently): write `Plan drift: unavailable (no git history)` and proceed to Phase 6b.

**Step 2 — Measure the diff against the archived copy (req 3.2):**

```bash
git diff {first_commit} HEAD -- .kanban/.archive/{subject}/02-plan-{subject}.md
```

Count lines added (`+` prefix) and lines removed (`-` prefix) in the diff output. Exclude any block that begins with `## Audit` — this is the audit block appended at the end of every plan and should not count as drift.

<!-- WHY exclude the audit block: the audit block is always appended at plan→ticket transition time,
     so it represents refinement process overhead, not genuine plan volatility. Including it would
     inflate drift classification for every subject regardless of actual planning stability. -->

**Step 3 — Classify drift magnitude (req 3.3):**

| Lines changed (added + removed, excluding audit block) | Magnitude |
|--------------------------------------------------------|-----------|
| 0                                                       | None      |
| 1–10                                                    | Minor     |
| 11–30                                                   | Moderate  |
| 31+                                                     | Significant |

<!-- WHY these thresholds: None = plan was followed exactly (ideal); Minor = normal clarification;
     Moderate = meaningful re-scoping during execution; Significant = plan was substantially
     rewritten, suggesting the ideation phase underspecified or the work revealed major unknowns.
     These feed MX-OQ3 (Plan Stability Rate) in the optimise skill. -->

**Step 4 — Append Plan Drift section to quality envelope (req 3.4):**

Append to `.kanban/.archive/{subject}/00-quality-{subject}.md`. If the file does not exist, create it. This is an append-only write — never overwrite existing content.

```markdown
## Plan Drift

First plan commit: {SHA} ({date})
Archive commit: {current HEAD SHA} ({date})
Lines added: {N} | Lines removed: {N}
Magnitude: None / Minor / Moderate / Significant
```

If git was unavailable or no creation commit was found, write instead:

```markdown
## Plan Drift

Plan drift: unavailable (no git history)
```

---

### Phase 6b — Subject Summary

<!-- WHY this runs last: Subject Summary is the final aggregate of all quality signals accumulated
     throughout the subject's lifecycle. It must be written after Plan Drift (Phase 6a) so the
     drift data is already present. It reads Interview Signals, Work Sessions, PR Responses, and
     Plan Drift sections from the envelope and distils them into one block. Satisfies req 1.2. -->

After writing the Plan Drift section, append a `## Subject Summary` block to `.kanban/.archive/{subject}/00-quality-{subject}.md`.

Read the quality envelope file and extract counts from each section:

- From `## Interview Signals`: total approved, overridden, rejected counts (sum across all Interview Signals entries if multiple exist)
- From `## Work Sessions`: count of "yes", "partially", "no" rated sessions
- From `## PR Responses`: count of total `### Response` entries across all tickets
- From `## Plan Drift`: the Magnitude value

Append this block:

```markdown
## Subject Summary

Generated: {ISO timestamp}

| Signal | Value |
|--------|-------|
| Interview acceptance | {N approved} / {N total recommendations} ({N}%) |
| Interview overrides | {N} |
| Interview rejections | {N} |
| Session satisfaction | {N yes} / {N rated} ({N}%) |
| PR rework cycles | {N total response entries} across {N tickets} |
| Plan drift | {Magnitude} ({N added} / {N removed} lines) |

<!-- Sections with no data are shown as "—" (not recorded or phase was skipped) -->
```

If a section is absent from the envelope (e.g. the subject skipped the interview phase), write `—` for those fields rather than omitting the row.

After appending the Subject Summary, stage and commit the updated quality envelope:

```bash
git add .kanban/.archive/{subject}/00-quality-{subject}.md
git commit -m "kanban(cleanup): append quality envelope summary for {subject}"
```

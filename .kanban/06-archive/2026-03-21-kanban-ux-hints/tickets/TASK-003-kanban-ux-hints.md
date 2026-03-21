---
id: "2026-03-21-kanban-ux-hints/TASK-003"
subject: "2026-03-21-kanban-ux-hints"
plan: "../../01-plan/2026-03-21-kanban-ux-hints/plan-kanban-ux-hints.md"
effort: low
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T10:00:00Z"
completed_at: "2026-03-21T10:30:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.1 — Audit all 9 command files against their current argument-hint values"
  - "Req 2.2 — Revise any hint that is vague, inaccurate, or doesn't match what the command accepts"
acceptance_criteria:
  - "All 9 command files have been read and compared against their actual argument behaviour"
  - "Any hint that was inaccurate or misleading has been updated with a more accurate value"
  - "Running `verify-kanban-ux-hints.sh` exits 0 (all checks pass — green)"
  - "`grep -rn 'argument-hint' .claude/skills/kanban/commands/` returns exactly 9 non-empty matches"
consecutive_failures: 0
---

## Context

All 9 command files already have `argument-hint` values — so this is a review and quality pass, not a gap-fill. The Scout identified `init.md` as a minor candidate for review (its hint says "subject name override" but init's primary purpose is creating the `.kanban/` folder structure, which might confuse users who expect the hint to describe what init does, not just its optional argument).

Once hints are reviewed and any updates committed, run the verification script from TASK-001 to confirm the full suite passes.

## Acceptance Criteria

- Each of the 9 command files has been opened and its `argument-hint` compared against its actual behaviour
- Files with accurate hints: no change made, but explicitly noted as reviewed
- Files with inaccurate or improvable hints: updated
- `verify-kanban-ux-hints.sh` exits 0 after all updates

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T10:30:00Z

**Req 2.1 — Audited all 9 command files:**

Read all 9 command files and evaluated each `argument-hint` against the command's actual argument behavior:

1. **init.md** — IMPROVABLE
   - Current: `[YYYY-MM-DD-<subject>] — optional subject name override; omit to auto-derive`
   - Issue: Hint emphasizes only the optional argument aspect but obscures init's primary purpose (creating the .kanban/ structure). Users may misunderstand what init does.
   - Updated to: `[YYYY-MM-DD-<subject>] — initialise .kanban/ structure; optional subject override, omit to auto-derive`
   - Why: Better conveys that init is an initialization command, with the subject argument as secondary/optional detail.

2. **capture.md** — ACCURATE
   - Hint correctly describes optional subject argument and auto-derive behavior. No changes.

3. **plan.md** — ACCURATE
   - Hint correctly describes optional subject argument and auto-derive behavior. No changes.

4. **todo.md** — ACCURATE
   - Hint correctly describes optional subject argument and auto-derive behavior. No changes.

5. **work.md** — ACCURATE
   - Hint correctly shows TASK-NNN path format and auto-select behavior. No changes.

6. **review.md** — ACCURATE
   - Hint correctly shows TASK-NNN pattern and auto-select from in-review behavior. No changes.

7. **pr.md** — IMPROVABLE
   - Current: `[YYYY-MM-DD-<subject>] — subject to raise PR for; omit to auto-derive`
   - Issue: Phrase "raise PR for" is generic and doesn't hint at the full scope (comment handling, CI monitoring, pre-flight checks).
   - Updated to: `[YYYY-MM-DD-<subject>] — subject for PR creation and review; omit to auto-derive`
   - Why: "creation and review" better conveys that pr.md manages the full PR lifecycle, not just opening it.

8. **cleanup.md** — ACCURATE
   - Hint correctly describes archiving behavior and auto-derive. No changes.

9. **next.md** — ACCURATE
   - Hint correctly describes argument format and list behavior when omitted. No changes.

**Req 2.2 — Updated inaccurate/improvable hints:**

Applied 2 updates as documented above. All changes are frontmatter-only (argument-hint values only); no logic, phases, personas, or command content was modified.

**Verification:**

Ran `bash scripts/verify-hints.sh` — all 10 checks pass (SKILL.md + 9 command files). Script exits 0.

All acceptance criteria satisfied:
- AC1: All 9 files read and compared ✓
- AC2: Updated init.md and pr.md with more accurate values ✓
- AC3: verify-hints.sh exits 0 ✓
- AC4: `grep -rn 'argument-hint' skills/kanban/commands/` returns exactly 9 matches ✓

Committed changes under `feat(003): audit and improve command file argument-hints`.

---

## Review — 2026-03-21 (Echo + Arden)

**Reviewers:** Echo (Examiner), Arden (Critic)
**Verdict: PASS**
**Score: 4/4 — 100%**

**AC1** — All 9 command files read and compared: SATISFIED. Work Log names each file individually with per-file assessment and explicit "no changes" notation for accurate hints.

**AC2** — Inaccurate/improvable hints updated: SATISFIED. `init.md` and `pr.md` updated; changes confirmed in source files. Remaining 7 explicitly noted as accurate.

**AC3** — `bash scripts/verify-hints.sh` exits 0: SATISFIED. Ran live; output 10/10 PASS, exit code 0.

**AC4** — Exactly 9 `argument-hint` matches in `skills/kanban/commands/`: SATISFIED. Grep confirms 9 matches across 9 files, one per file.

**Notes:** Minor ticket text inconsistency — AC3 references `verify-kanban-ux-hints.sh` but the script is named `verify-hints.sh`. Work Log and actual execution use the correct name. Not a substance issue.

Ticket moved to `05-pull-request`.

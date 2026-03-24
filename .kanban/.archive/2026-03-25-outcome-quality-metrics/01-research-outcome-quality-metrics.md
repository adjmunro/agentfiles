---
created_at: 2026-03-25T00:00:00Z
---

## Research: outcome-quality-metrics

**Date**: 2026-03-25T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

```
skills/
├── ideation/commands/
│   ├── interview.md          ← recommendation brief + user response recording
│   ├── plan.md               ← plan write + audit gate
│   └── tickets.md            ← ticket creation + promotion
├── implement/commands/
│   ├── _shared.md            ← ticket frontmatter schema (includes consecutive_failures)
│   ├── work/
│   │   ├── p6-work-log.md    ← appends work log to ticket append zone
│   │   └── p8-move-to-review.md
│   ├── review/
│   │   ├── p3-score.md       ← PASS/FAIL verdict with percentage
│   │   ├── p5-fail.md        ← increments consecutive_failures, escalates on repeat
│   │   └── p6-report.md
│   └── cleanup.md            ← Phase 6 prints metrics at archive time (Pulse)
└── optimise/commands/
    ├── optimise.md           ← orchestrator, 5-phase loop
    └── phases/
        └── p2-baseline.md    ← M1–M15 seed metrics + custom metric discovery
```

Archive location: `.kanban/.archive/{subject}/` (with 00-input, 01-research, 02-plan, 08-done/).

## Relevant Patterns

**`consecutive_failures` already exists** in the ticket frontmatter schema (`_shared.md`):
```yaml
consecutive_failures: 0
```
`review/p5-fail.md` increments it on each failed review. Same-error escalation fires after 2–3 identical failures. This is a partial outcome signal already in place — but it lives at ticket level and is never aggregated or fed to optimise.

**Cleanup Phase 6 already prints outcome metrics** at archive time (Pulse persona):
- Tickets passed first review
- Failure rate %
- Average work→review cycles per ticket
- Tickets stuck 3+ times

These are printed to terminal only — not written to a persistent file that optimise can read across subjects.

**Interview already records recommendations and user responses** in `00-input-{subject}.md` as `## Interview YYYYMMDD-HH:MM` blocks. The table includes `Status: Approved / Overridden: {user's choice}`. Rejection signals are not currently separated from overrides, and no signal is fed back into any metric system.

**Optimise custom metric discovery** (`p2-baseline.md`) explicitly asks: *"What does this workflow produce? Does any seed measure output quality? If not, define one."* and *"What would a user of this workflow complain about that no metric here would detect?"* — this is the integration point. Custom MX metrics defined here persist and re-apply on future runs.

**No deviation log exists** — there is no file type that records corrections, direction changes, or retroactive plan edits.

**No session-close rating mechanism** — work sessions end by moving the ticket to review; there is no prompting for user satisfaction.

**Plan file git history** is present and queryable. The plan file (`02-plan-{subject}.md`) is committed at creation (after audit) and again when amended. Git diff between first commit and archive commit = plan drift. Nothing currently reads this.

## Dependencies

- Git log/diff for plan drift measurement (git is always present in these repos)
- Ticket frontmatter `consecutive_failures` field — already in schema, no change needed
- `00-input-{subject}.md` Interview blocks — already the right format for acceptance tracking
- Cleanup Phase 6 report — already computes the right numbers, just doesn't persist them
- Optimise `p2-baseline.md` custom metric section — the intake point for outcome metrics

No external libraries or services required.

## Hazards

**The interview `Status` field conflates override and rejection.** Currently records both "user chose differently" and "user pushed back hard" as the same `Overridden: {choice}`. Distinguishing them requires the agent to interpret the user's phrasing — the user confirmed this is intentional: rejection is signalled by backtrack phrases ("Actually,", "don't do that, instead"), not by the outcome itself.

**Cleanup metrics are ephemeral.** They are printed but not written to a persistent file. Any outcome metric system that relies on historical data across subjects needs a file that survives the session.

**Plan drift measurement requires git.** Subjects not inside a git repo cannot produce plan drift scores. This is acceptable given all known use cases are git repos, but should be noted.

**Optimise currently has no access to per-subject data.** It targets a workflow *directory* (e.g., `skills/ideation/`), not runtime data. To incorporate outcome metrics, optimise would need a new data source — either a quality envelope file at the subject level or an aggregated log at the kanban level — and a new metric definition that knows how to read it.

**Risk of low signal volume.** Outcome metrics only become meaningful across many subjects. Early runs will have insufficient data to distinguish signal from noise. The system needs to accumulate silently before it produces actionable output.

## Recommended Approach

The most tractable path is a **per-subject quality envelope** — a new file type that accumulates outcome signals throughout a subject's lifecycle, survives to the archive, and is readable by optimise as an external data source.

Key design decisions that the interview should surface:

1. **File naming and format**: where does the quality envelope live within the subject directory? Options: `00-quality-{subject}.md` (alongside input/research/plan) vs `09-quality-{subject}.md` (post-done, clearly post-hoc) vs a section appended to the existing plan file.

2. **Who writes to it**: three different phases write signals — interview (acceptance tracking), plan/cleanup (plan drift), implement work (session close rating). Each phase appends to the same file. This is the append-only pattern already established in ticket files.

3. **Rejection heuristics**: the agent decides accept/override/reject based on phrasing. The user confirmed this. The heuristics need to be written into interview.md as a detection rule. Should the heuristics live in interview.md only, or also in a shared reference?

4. **Optimise integration**: outcome metrics need a custom MX definition in optimise that queries quality envelope files across archived subjects. This is a new capability (optimise currently reads only instruction/documentation files, not runtime data). Is this added to `p2-baseline.md` as a new metric category, or does it need a new optimise phase?

5. **Session-close rating**: the user proposed "yes / partially / no" written to the deviation log. Should this be agent-prompted (the agent asks at the end of each work session) or user-initiated (the user types `/rate` or similar)?

The interview should resolve 3–4 design decisions; the plan can determine the rest.

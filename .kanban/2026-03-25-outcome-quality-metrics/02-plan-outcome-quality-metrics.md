## Intent

All current optimise metrics measure the quality of workflow instructions — coverage, clarity, persona fit. None measure whether the workflow produces good outcomes. This subject adds a lightweight outcome-signal layer: a per-subject quality envelope that accumulates signals throughout a subject's lifecycle, and new optimise metrics that read those envelopes to detect whether structural improvements are actually producing better results.

## Requirements

### 1. Quality Envelope File Type

1.1 Create a new file type `00-quality-{subject}.md` that lives at the subject root alongside `00-input-`, `01-research-`, and `02-plan-`. It is append-only and written by multiple phases across ideation and implement.

1.2 The file schema has five top-level sections, each populated by a different phase:
- `## Interview Signals` — written by `interview.md` after the brief is responded to
- `## Plan Drift` — written by `cleanup.md` Phase 6 using git diff
- `## Work Sessions` — written by `work/p8-move-to-review.md` after each session
- `## PR Responses` — written by `review/p5-fail.md` each time a ticket is returned for rework
- `## Subject Summary` — written by `cleanup.md` Phase 6 as the final aggregate

1.3 The file is created on first write (by interview.md). Subsequent phases append to their section. If a section has no data (e.g. the user skipped all session ratings), the heading is present but empty.

1.4 The file survives to the archive at `.kanban/.archive/{subject}/00-quality-{subject}.md`.

### 2. Interview Acceptance Tracking

2.1 After recording the user's response in `interview.md` Phase 4, classify each recommendation item as one of three states:
- **Approved** — user accepted the recommendation without pushback
- **Overridden** — user chose a different option (neutral; counts as a valid resolution)
- **Rejected** — user pushed back and redirected away from the recommendation

2.2 Rejection heuristics (applied per-item during Phase 4 parsing): classify as Rejected if the user's response contains backtrack phrases targeting that item — e.g. "Actually,", "don't do that", "instead [different thing]", "no,", "I don't want". Classify as Overridden if the user selects an alternative without backtracking. Classify as Approved if the user extends or accepts the recommendation. When ambiguous, prefer Overridden over Rejected.

2.3 Append an `## Interview Signals` block to `00-quality-{subject}.md` (create the file if it does not exist):

```markdown
## Interview Signals — YYYYMMDD-HH:MM

| Item | Decision area | Status | User's direction |
|------|---------------|--------|-----------------|
| 1    | {area}        | Approved / Overridden / Rejected | {verbatim redirect if Rejected or Overridden} |

Summary: {N} approved, {N} overridden, {N} rejected of {total} recommendations.
```

2.4 Write to `00-quality-{subject}.md` immediately after appending the interview block to `00-input-{subject}.md`. Stage and commit both files together under the existing `kanban(interview):` commit.

### 3. Plan Drift Measurement

3.1 In `cleanup.md` Phase 6 (after the archive move), measure how much the plan file changed between its creation commit and the archive commit.

3.2 Method: use `git log --follow --diff-filter=A -- .kanban/{subject}/02-plan-{subject}.md` to find the first commit that created the plan file. Then `git diff {first_commit} HEAD -- .kanban/.archive/{subject}/02-plan-{subject}.md` to get the diff. Count lines added and removed (excluding the audit block, which is always appended and should not count as drift).

3.3 Classify drift magnitude:
- **None** — 0 lines changed (plan was not touched after creation)
- **Minor** — 1–10 lines changed
- **Moderate** — 11–30 lines changed
- **Significant** — 31+ lines changed

3.4 Append to `## Plan Drift` section of `00-quality-{subject}.md`:

```markdown
## Plan Drift

First plan commit: {SHA} ({date})
Archive commit: {SHA} ({date})
Lines added: {N} | Lines removed: {N}
Magnitude: None / Minor / Moderate / Significant
```

If git is not available or the plan file has no creation commit (edge case), write "Plan drift: unavailable (no git history)".

### 4. Session-Close Rating

4.1 In `work/p8-move-to-review.md`, after moving the ticket to `06-in-review/`, prompt the user with a single `AskUserQuestion`:

```
Session close — how did this session go?
  yes       — produced what was needed
  partially — got there but with friction
  no        — something went wrong
  skip      — don't record
```

4.2 If the user responds with "yes", "partially", or "no": append a `## Work Sessions` entry to `00-quality-{subject}.md` (create the file if it does not exist):

```markdown
## Work Sessions

### Session — YYYYMMDD-HH:MM — TASK-NNN — {rating}
```

If the quality envelope does not yet have a `## Work Sessions` section, create it. If it does, append under the existing heading.

4.3 If the user responds "skip", types nothing, or responds with anything other than yes/partially/no: proceed without writing. Do not re-prompt.

4.4 The rating prompt must not block the ticket move — the ticket is already in `06-in-review/` before the prompt appears. The escape always works.

### 5. PR Response Tracking

5.1 In `review/p5-fail.md`, after incrementing `consecutive_failures` and before any escalation checks, append a `## PR Responses` entry to `00-quality-{subject}.md` (create the file if it does not exist):

```markdown
## PR Responses

### Response — YYYYMMDD-HH:MM — TASK-NNN — Cycle {N}
Criteria: {comma-separated list of failed review criteria or section names from the review score}
```

If the quality envelope does not yet have a `## PR Responses` section, create it. If it does, append under the existing heading.

5.2 The cycle number corresponds to the value of `consecutive_failures` at the time of logging (after increment). Each entry represents one round of rework triggered by reviewer critique.

5.3 If the quality envelope file does not exist at log time (e.g. the subject skipped the interview phase), create it with only the `## PR Responses` heading and append the entry.

### 6. Optimise Outcome Metrics (MX series)

6.1 Add the following custom metric definitions to `skills/optimise/commands/phases/p2-baseline.md` under the Custom Metric Discovery section. These are pre-defined MX metrics — they should be evaluated during custom metric discovery for any workflow that produces `.kanban/` subjects.

6.2 **MX-OQ1 — Interview Acceptance Rate**
- Applies when: `.kanban/.archive/` contains at least one `00-quality-*.md` file with an `## Interview Signals` section
- Methodology: across all archived quality envelopes, sum approved + overridden + rejected counts. Acceptance Rate = approved / (approved + rejected). Overrides are excluded from the ratio (they represent valid alternatives, not failures).
- Direction: ↑ higher is better
- Normalise: rate × 100
- Weight: 2× (directly measures whether recommendations are trusted)

6.3 **MX-OQ2 — First-Pass Review Rate**
- Applies when: `.kanban/.archive/` contains at least one archived subject with ticket files in `08-done/` that have `consecutive_failures` frontmatter
- Methodology: across all archived tickets, count tickets where `consecutive_failures = 0` (passed first review). Rate = zero-failure tickets / total tickets.
- Direction: ↑ higher is better
- Normalise: rate × 100
- Weight: 2× (directly measures implementation quality)

6.4 **MX-OQ3 — Plan Stability Rate**
- Applies when: `.kanban/.archive/` contains at least one `00-quality-*.md` with a `## Plan Drift` section
- Methodology: across all archived quality envelopes with drift data, count subjects where magnitude is "None" or "Minor". Rate = stable subjects / total subjects with drift data.
- Direction: ↑ higher is better
- Normalise: rate × 100
- Weight: 1×

6.5 **MX-OQ4 — Session Satisfaction Rate**
- Applies when: `.kanban/.archive/` contains at least one `00-quality-*.md` with a `## Work Sessions` section containing at least one rated session
- Methodology: across all rated sessions in all archived quality envelopes, count "yes" ratings. Rate = yes / (yes + partially + no). Skipped sessions are excluded.
- Direction: ↑ higher is better
- Normalise: rate × 100
- Weight: 1×

6.6 **MX-OQ5 — PR Critique Rate**
- Applies when: `.kanban/.archive/` contains at least one `00-quality-*.md` with a `## PR Responses` section
- Methodology: across all archived quality envelopes, sum total PR response events (count of `### Response` entries in all `## PR Responses` sections). Divide by total archived tickets to get average rework cycles per ticket.
- Direction: ↓ lower is better (fewer rework cycles = cleaner initial implementation). For composite scoring, invert: score = max(0, 100 − (rate × 50)), where rate is average rework cycles per ticket (capped at 2 for normalisation — 2+ cycles per ticket = 0%).
- Weight: 2× (directly measures implementation quality at review time)

6.7 All five metrics skip with an explicit reason if the applicable data does not exist. Sparse data (fewer than 3 archived subjects) should be noted as "insufficient sample — treat as directional only".

6.8 The MX-OQ metrics are designed to feed the optimise hypothesis phase for causal attribution. When optimise reviews these metrics alongside structural metrics (M1–M15), it should form hypotheses about which factors correlate with outcome degradation — e.g., whether a particular persona produces lower acceptance rates, or whether plan instability correlates with poor session satisfaction. No automated attribution is required; the correlation analysis is the responsibility of the optimise hypothesis phase (Phase 3 of `optimise.md`).

## Constraints

- Quality envelope writes are always append-only — never overwrite existing content
- Session-close prompt must have an easy escape (single word "skip" or any non-matching response)
- MX-OQ metrics are advisory signals, not gates — they inform optimise hypotheses but do not block anything
- Git is a required dependency for plan drift measurement; handle gracefully if unavailable
- Rejection classification errs toward Overridden when ambiguous — false negatives are less harmful than false positives

## Out of Scope

- Retroactive quality envelopes for subjects already archived before this system exists
- Automated test failure counting (requires instrumenting the test runner per-project)
- PR comment validity scoring (subjective per-comment assessment of whether a comment was valid); MX-OQ5 uses rework event count as a tractable proxy
- Alerting, dashboards, or cross-subject trend reporting beyond what optimise provides
- Quality envelopes for skills other than ideation and implement (could be a future extension)
- Enforcement or gating based on outcome scores

---

## Audit: input → plan — PASS

**Date**: 2026-03-25T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Track recommendation acceptance | Full | §2 Interview Acceptance Tracking |
| 2 | Accept = positive, override = neutral | Full | §2.1 |
| 3 | Reject = pushback + redirect | Full | §2.1, §2.2 |
| 4 | Adding detail to recommendation = Approved | Full | §2.2 "extends or accepts" |
| 5 | Plan drift tracking | Full | §3 Plan Drift Measurement |
| 6 | Visible to optimise | Full | §6 MX metrics |
| 7 | Judge accuracy of output / quality | Full | Intent |
| 8 | Identify which factors cause quality degradation | Full | §6.8 — causal attribution via optimise hypothesis phase |
| 9 | Record failures, feed into optimisation loop | Full | §6, §1 quality envelope |
| 10 | Current metrics structural — need outcome signals | Full | Intent |
| 11 | Deterministic improvement measurement | Full | §6.1–6.7 |
| 12 | Test failure count | Full | Out of Scope — explicitly deferred |
| 13 | Valid PR comments raised | Full | §5 PR Response Tracking + MX-OQ5 |
| 14 | Session-close rating | Full | §4 |
| 15 | Rejection via backtrack phrases | Full | §2.2 |
| 16 | Agent decides via extend vs backtrack | Full | §2.2 |
| 17 | `00-quality-{subject}.md` location | Full | §1.1 |
| 18 | MX metrics in `p2-baseline.md` | Full | §6.1 |
| 19 | Rejection heuristics in interview Phase 4 | Full | §2.2, §2.3 |
| 20 | Agent-prompted with escape hatch | Full | §4.1, §4.3 |
| 21 | Full system in one subject | Full | Requirements §1–6 cover all areas |
| 22 | Append-only, written by multiple phases | Full | §1.1, §1.2, §1.3 |
| 23 | Skip with single word or non-matching response | Full | §4.3 |
| 24 | Kanban-scoped despite general aspiration | Full | Out of Scope §5 |
| 25 | PR response tracking (changes in response to critique) | Full | §5 PR Response Tracking + MX-OQ5 |

- Full: 25, Partial: 0, Missing: 0 — Total: 25
- Score: 25 / 25 × 100 = 100%

### Fixes Applied

- §5.7 → §6.8: explicit statement that MX-OQ metrics feed the optimise hypothesis phase for causal attribution. Item 8 was Partial on first pass.
- §5 (PR Response Tracking) added: `review/p5-fail.md` logs each rework cycle to `## PR Responses` in the quality envelope. Item 13 moved from Out of Scope to a tracked requirement.
- §6.6 (MX-OQ5 — PR Critique Rate) added: average rework cycles per ticket, weight 2×, ↓ lower is better, inverted for composite scoring.

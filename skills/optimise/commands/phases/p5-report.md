## Phase 5 — Report

**Persona: none (objective reporter)**

Re-read `research-log.md` (Intent Anchor). Compile all baseline and post-experiment scores.

Build the final comparison table for all applied metrics:

```markdown
## Final Results — <date>

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Directive Density | ... | ... | ... | ↑ / ↓ / — |
| ...    |          |      |       |        |
| **Composite** | X% | Y% | +Z pp | |
```

Use the full metric name in the Metric column — never the abbreviation alone (e.g., "Directive Density", not "DD"; "Intent-to-Output Traceability", not "IOT").

Then write three lists:

**What improved and why:**
- <metric>: <delta> — <mechanism that caused the improvement>

**What was dropped and why:**
- <hypothesis>: <reason it was disconfirmed or reverted>

**What remains to improve:**
- <metric>: still at <score> — <suggested next hypothesis if any>

### Novel Pattern Candidates

If any confirmed hypothesis used a novel pattern (not P1–P7), document it:

```markdown
## Novel Patterns Discovered — <date>

### NP<N> — <Pattern Name>
**Discovered in:** <target workflow>
**Problem it solved:** <description>
**Implementation:** <brief description of the change>
**Metrics it improved:** <list>
**Generalises to:** <what other workflow types would benefit>
**Seed candidate:** yes / no / maybe — <reasoning>
```

Promote any seed candidates to the Design Patterns section in
`commands/phases/p3-hypothesize.md` in a future optimisation run.

Append the full report to `research-log.md` under `## Final Results — <date>`.

### Research Log Archival

After appending the report, check the size of `research-log.md`:

- Estimate the approximate token count (characters ÷ 4, or line count × average tokens per line).
- If the log exceeds **15,000 tokens**, archive it:
  1. Create `research-log-archive-<date>.md` in the same directory. If `research-log-archive-<date>.md` already exists, use `research-log-archive-<date>b.md` (then `c`, etc.) to avoid overwriting prior archives. Copy all content from the log up to and including the previous run's `## Final Results` section into the archive file.
  2. Replace the archived content in `research-log.md` with a single header line: `## Archive: see research-log-archive-<date>.md for runs prior to <current run date>`.
  3. Keep the current run's Intent, Audit, Baseline, Hypotheses, and Final Results sections in the live log.
- If the log is under 15,000 tokens, no action needed — note "Log within size threshold; no archival required."

This keeps the live log within a single-context load (~15,000t) while preserving all historical data in the archive file.

Print a terminal summary in plain language — no metric abbreviations or internal IDs:

```
Optimisation complete.
Baseline: X%  →  Post: Y%  (+Z pp composite)

Confirmed: <count> experiments
Partial:   <count>
Dropped:   <count>

Strongest improvement: <full metric name> (+N pp)
Key change: <one plain-language sentence describing the most impactful experiment>

Full report written to: <path>/research-log.md
```

### Branch Cleanup

If a branch was checked out in Phase 4, delete it now:

```bash
git branch -d optimize/<target-dir-name>-<date>
```

If the branch was not yet merged to the main branch, merge it first, then delete it. If the target was not inside a git repo (no branch was created), skip this step.

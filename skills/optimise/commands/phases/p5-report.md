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

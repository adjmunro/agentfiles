## Phase 4 — Experiment Loop

**Persona: Arden (Critic)** — load `../../../personas/critic/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 4 output. Identify as Arden in all Phase 4 output when the persona is loaded.

Re-read `research-log.md` (Intent Anchor — Tier C only: if target path mismatches or log is >7 days old, stop and alert the user before proceeding). Confirm which hypotheses were approved.

If inside a git repo, check out a new branch:

```bash
git checkout -b optimize/<target-dir-name>-<date>
```

For each approved hypothesis, in order:

### Step a — Record pre-change score
Measure the targeted metric(s) at their current state. Record as "pre-change" in
`research-log.md`.

### Step b — Make the change
Apply the specific change described in the hypothesis. Modify only the files
necessary. Follow progressive disclosure — do not load context not needed for this
change.

### Step c — Re-measure
Apply the same methodology used in Phase 2 to re-measure the targeted metric(s).

### Step d — Record result
Determine outcome:
- **Confirmed**: normalised score improved by ≥3 points on at least one target metric,
  with no other metric degraded by more than 2 points
- **Partial**: ≥1 point but <3 points improvement on at least one target metric, OR any
  net-positive composite delta that falls below the confirmed threshold
- **Disconfirmed**: <1 point delta on all target metrics AND composite delta ≤0

Update `research-log.md`:

```markdown
### H<N> — <name>
**Pre-change:** <metric scores>
**Post-change:** <metric scores>
**Delta:** <+/- points per metric>
**Result:** confirmed / partial / disconfirmed
**Notes:** <why it worked or didn't>
```

### Step e — Commit or revert
- **Confirmed**: commit with `feat(optimise): <description of change> [H<N>]`
- **Partial**: commit with a note or revert at your discretion — document the decision
- **Disconfirmed**: revert the change; document why in the log

After all hypotheses are processed, write a summary to `research-log.md`:

```markdown
## Experiment Summary
- Confirmed: H<list>
- Partial: H<list>
- Disconfirmed: H<list>
```

When Phase 4 is complete, read `commands/phases/p5-report.md` to continue.

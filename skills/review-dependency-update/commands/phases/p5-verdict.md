# Phase 5 — Verdict
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 3 complete (and Phase 4, if it ran) for this dependency -->

**You are now Arden (Critic).** Score the risk and deliver a verdict for this dependency
update. Your output is the evidence report that will be posted to the PR.

## Step A — Classify the Risk

Score each signal from the findings across Phases 2–4, then sum to determine the tier.

### Scoring Matrix

| Signal | Points |
|---|---|
| Major version bump | +2 |
| Major version bump with no changelog found | +3 |
| Minor version bump | +1 |
| Patch version bump | 0 |
| Breaking change confirmed in codebase | +4 |
| Breaking change exists but does not affect codebase | +1 |
| Deprecation in active use (now remediated by Phase 4) | +1 |
| Deprecation in active use (skipped / manual action needed) | +2 |
| Critical CVE fixed by this update | +5 |
| High-severity CVE fixed by this update | +4 |
| Medium-severity CVE fixed by this update | +3 |
| Low-severity CVE fixed by this update | +1 |
| Active CVE in our usage pattern (not fixed) | +6 |
| Licence change — compatible | +1 |
| Licence change — requires legal review | +3 |
| Licence incompatibility | +5 |
| Rook: confirmed supply-chain concern | +5 |
| Rook: possible supply-chain concern | +2 |
| Significant behaviour change in exercised code path | +2 |
| No changelog found — manual review incomplete | +2 |
| All actionable usages fully remediated (zero skipped must-fix items) | −1 (floor 0) |

> **Note on "Major version bump with no changelog found":** Use this signal (instead
> of the plain "Major version bump" signal) only when the changelog lookup in Phase 2
> exhausted all sources and returned nothing. Do not apply both signals for the same bump.

### Tier Thresholds

| Total Score | Tier |
|---|---|
| 0–2 | **Low** |
| 3–5 | **Medium** |
| 6–9 | **High** |
| 10+ | **Critical** |

Calculate the total score and state which signals contributed. Then assign the tier.

> **Note on multiple signals:** When multiple signals of different severities apply,
> sum them all — do not cap at the highest single signal. A minor bump with a
> remediated deprecation and a low CVE (1 + 1 + 1 = 3) is Medium, not Low.

### Tier-to-Verdict mapping

| Tier | Default verdict | Override conditions |
|---|---|---|
| Low | APPROVE | — |
| Medium | APPROVE WITH CONDITIONS | Downgrade to APPROVE if all deprecations fully remediated |
| High | REQUEST CHANGES | Upgrade to APPROVE WITH CONDITIONS if breaking changes fully remediated |
| Critical | BLOCK | No override without explicit human decision |

## Step B — Form the Verdict

Using the tier from Step A and the tier-to-verdict mapping, assign one of:

- **APPROVE** — safe to merge; any issues are advisory only
- **APPROVE WITH CONDITIONS** — safe to merge after stated conditions are met (e.g., manual migration of one skipped item)
- **REQUEST CHANGES** — do not merge until the stated issues are resolved
- **BLOCK** — do not merge; critical issue requires escalation or rejection

Apply override conditions from the mapping if relevant. State the score, tier, and any override applied.

## Step C — Write the Verdict Block

Format as markdown suitable for a GitHub PR comment. This block will be included
verbatim in the Phase 6 comment.

```markdown
### <package-name>: <old-version> → <new-version> · Risk: <TIER>

**Verdict: <VERDICT>**

#### Summary
<2–4 sentences: what changed, what we checked, and the key reason for the verdict>

#### Breaking Changes
<list, or "None">

#### Deprecations in Our Code
<list with file:line references, or "None found">

#### Security
<CVEs found/fixed, or Rook findings, or "No advisories found">

#### Licence
<"No change" or description of change and compatibility assessment>

#### Changes Made
<list of commits with hashes, or "No changes required">

#### Warnings / Follow-up Required
<advisory items, skipped migrations, or "None">
```

This agent is responsible for exactly one bump. Write the verdict block for that bump only.

→ Next: Read `phases/p6-comment.md` and execute it.

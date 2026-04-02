# Phase 5 — Verdict
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 3 complete (and Phase 4, if it ran) for this dependency -->

**You are now Arden (Critic).** Score the risk and deliver a verdict for this dependency
update. Your output is the evidence report that will be posted to the PR.

## Step A — Classify the Risk

> **CI data source:** if Phase 4 ran, the CI status is in its Remediation Summary
> (Step E). If Phase 4 was **skipped** (no actionable usages found), read the CI
> Status section from `/tmp/dep-review-<PR-number>-session-brief.md` (or the
> in-prompt CI Status section if the file is unavailable) to obtain the Phase 1
> CI verdict for this bump before scoring.

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
| Multi-version span (≥3 intermediate versions skipped) | +1 |
| All actionable usages fully remediated (zero skipped must-fix items) | −1 (floor 0) |
| CI was failing at Phase 1; all failures now resolved by Phase 4 | 0 (no extra penalty) |
| CI was failing at Phase 1; failures remain unresolved (non-environment) | +4 |
| CI was failing at Phase 1; failures remain unresolved (test environment issue only) | +1 |
| CI was passing at Phase 1 (or no CI configured) | 0 |

> **Note on "Multi-version span":** Apply this signal when the upgrade traverses three
> or more intermediate versions (i.e., old → new spans at least two releases not
> previously reviewed). The signal reflects the increased probability that advisory
> signals were missed in intermediate releases. Do not apply it when the span is a
> single minor or patch hop.

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

> **CI hard block:** Regardless of tier, if CI is still failing with one or more
> unresolved failures that are **not** categorised as "Test environment issue", the
> verdict must be **REQUEST CHANGES** at minimum. A failing CI with unresolved
> API break, Migration required, Deprecation became removal, or Other failures cannot
> receive APPROVE or APPROVE WITH CONDITIONS. State the CI block reason explicitly
> in the verdict block.

> **Supply-chain integrity hard block:** Regardless of tier, if Rook reported a
> **Confirmed** supply-chain concern relating to **tag signing regression** (a package
> that previously signed its tags and now does not) or **tag-to-tarball mismatch**
> (the published registry artifact does not match the tagged source), the verdict
> must be **REQUEST CHANGES** at minimum. These signals indicate potential key
> compromise or package takeover — they cannot receive APPROVE or APPROVE WITH
> CONDITIONS even if all other signals are low-risk. State the integrity block reason
> explicitly in the verdict block.

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

> **Version span:** single  |  multi — <count> intermediate versions traversed: <v1>, <v2>, ...
> _(For multi-version spans: signals and advisories are aggregated across the full span,
> including intermediate releases. CVEs that existed in traversed versions are reported
> even if patched before the final version.)_

#### Summary
<2–4 sentences: what changed, what we checked, and the key reason for the verdict.
If a multi-version span was detected, explicitly state how many versions were traversed
and whether any signals originated from intermediate releases rather than the final one.>

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

#### CI Status
<"All checks passed" | "CI was failing; all failures resolved by Phase 4 remediation" |
"CI is still failing: <list of unresolved jobs with category and root cause>" |
"No CI configured">

#### Warnings / Follow-up Required
<advisory items, skipped migrations, or "None">
```

This agent is responsible for exactly one bump. Write the verdict block for that bump only.

→ Next: Read `phases/p6-comment.md` and execute it.

<!--
Fill in, then delete the comments.

Always present: the intro, the concern table and Tests.
Only where they help (SKILL.md, "Plan the evidence"):
  - On device: the change affects something a user sees.
  - Network: the change makes or depends on network calls.
  - Benchmarks: the change is expected to move a measurable metric significantly, on purpose or as a side effect (evidence/benchmarks.md).
  - Not covered: there are known gaps.
Delete a section that doesn't apply. Never pad it with "N/A".

Intro: it primes reviewers before they read anything else, so it comes first and stands out (a heading).
Keep the whole intro under about 70 words, or nobody reads it. Plain words; explain domain terms a reviewer might not know.
  - Heading: ticket link and what the ticket is about, in plain words (not just the ticket's title). With no ticket, just the plain-words summary.
  - Why: the problem or goal the ticket exists for, from the user's or business's side. Link any related ticket inline.
  - What changes: the outcome, in one sentence.
  - Reviewer(s) should focus on (optional): the one risky area or decision worth a close look.
  - Counterpart (only with a PR in the paired repo): `<owner>/<repo>#<n>` and its platform (publish.md, "Counterpart PRs").
  - No "stacked on" line: stacked PRs are tracked with gh stack, which shows the chain on GitHub (publish.md).
Example (alpheroltd/red-energy-droid#400):
  ### [PS-10171](…): Block sign-in while an account migrates to Kraken
  **Why:** While an account moves from Gentrack to Kraken, Self Service rejects every call for it with `ACCOUNT_PENDING_MIGRATION` ([CRPM-6520](…)). The app doesn't recognise that error yet.
  **What changes:** The app logs the customer out and shows "Upgrade in progress" (KR_UPG01-01a), using the API's message when there is one.
  **Review focus:** the logout path, especially the guard that stops a later 401 from replacing the dialog.

Concern table:
One concern per row, and only concerns of medium risk, impact or priority or higher: what a reviewer needs to weigh.
Leave out the rest (doc/agent notes, copy, renames, plumbing that follows from a row above); the diff shows them.
Cells: one short sentence, about 15 words. Code names in backticks instead of describing them.
Columns flex by concern type:
  - feature: Concern | Context (ticket, design, decision) | Change | Why
  - bug: Concern | Cause (history, what broke and when) | Fix | Why
  - refactor: Concern | Before | After | Why
Drop a column that's empty for every row.

Tests: new and changed tests, from the diff against the PR's base (the branch it merges into; its parent branch when stacked, not necessarily develop/main):
`gh pr diff <n>`, or `git diff <base>...HEAD` on test sources (three dots = since the merge-base). Classify per test, not per file:
  - new = a test function that didn't exist before (a modified file can hold only new tests);
  - changed = an existing test whose body, expectation, input or setup changed, or that was removed or renamed.
  - Shared helpers/fixtures that existing tests use count as changing those tests; a new helper only new tests use doesn't.
Changed tests need extra scrutiny: list every one in the warning block, with what it expected before, what it expects now, and why.
A test edited only for a rename or move is still listed, marked as such.
With no changed tests, replace the warning block with "**Changed:** None." With no new tests, write "**New:** None."
Local test results don't go here: they live in the verification comment (templates/verification-comment.md).

Spacing: GitHub collapses blank lines, so each lone `<br>` paragraph below is a spacer. Keep one before every `##` heading and one before the concern table.
-->

### [<TICKET>](<ticket url>): <what the ticket is about, in plain words>

**Why:** <the problem or goal, one or two short sentences.>
**What changes:** <the outcome, one sentence.>
**Review focus:** <optional: the one area to look at closely.>
**Counterpart:** <optional: <owner>/<repo>#<n> (<platform>).>

<br>

| Concern | Context | Change | Why |
|---|---|---|---|
| <one concern> | <ticket/design/history> | <what changed, code names in backticks> | <reasoning; the alternative you rejected> |

<br>

## Tests

> [!WARNING]
> **Changed:** these existing tests now expect something different. Check each still guards what it should.
> - `<Class>.<test>`: was <old expectation>, now <new>, because <reason>.

**New:**
- `<Class>` (<count>): <what it proves>.

<br>

## On device

<!-- UI changes only. Link the design frames, e.g. "Design: <screen code> in [Brand A](figma url) and [Brand B](figma url)." -->

<Build (`versionName` (`versionCode`), variant), device model + OS version, any forced state (one or two sentences, and that it's not in the PR), and the steps for each scenario as a short bullet list. Tree hashes go under the image labels, not here.>

<!-- One table, labels (with tree hash) in the header, images below. Phone screenshots width="210", 4 per row, 960px budget (evidence/ui.md). -->
| <State A><br><sub>tree `<tree>`</sub> | <State B><br><sub>tree `<tree>`</sub> | <State C><br><sub>tree `<tree>`</sub> |
|---|---|---|
| ![<State A>](./a.png) | ![<State B>](./b.png) | ![<State C>](./c.png) |

<br>

## Network

<!-- Network changes only. -->
| Time | Call | Status | Body |
|---|---|---|---|

<br>

## Benchmarks

<!-- Only when a metric is expected to move significantly (evidence/benchmarks.md). Keep the WARNING only if a row is 🔴, or 🟡 on a metric the change was meant to improve. -->
> [!WARNING]
> <Metric> got worse by <abs> (<rel>%) because <cause, or "cause unknown">.

<Machine, OS, tool versions, runs per side (usually one), cache state, timing noise threshold used.> Base `<sha>` (tree `<tree>`) vs head `<sha>` (tree `<tree>`).

| Metric | Before | After | Δ | Δ % | |
|---|---|---|---|---|---|
| Clean build `:app:assembleRelease` (lower is better) | 92.4 s | 71.8 s | −20.6 s | −22.3% | 🟢 |
| Release APK size | 18.42 MB | 19.61 MB | +1.19 MB | +6.5% | 🔴 |
| Cached build `:app:assembleRelease` | 6.1 s | 6.3 s | +0.2 s | +3.3% | ⚪ |

<details><summary>Commands</summary>

```
<exact command per metric>
```
</details>

<br>

## Not covered

<!-- Known gaps, follow-ups (with their own PR/ticket), platforms not checked. -->

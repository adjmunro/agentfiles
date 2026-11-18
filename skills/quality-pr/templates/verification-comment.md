<!-- quality-pr:verification -->
<!--
Keep the marker line above as the first line: it's how the comment is found and updated.
Local results only. New and changed tests go in the PR body (templates/pr-body.md), not here.
One row per task actually run locally, with the exact task name (incl. flavour/variant). Never write "all suites pass".
If Gradle reported a test task UP-TO-DATE, its inputs didn't change since the last run: keep that run's count and say so in one line under the table.
-->
## Local verification

Run locally, not on CI. CI results are in the PR's checks.

Ran at `<sha>` (tree `<tree>`), clean tree, <yyyy-mm-dd hh:mm TZ>.

| Task | Result | Tests |
|---|---|---|
| `:app:test<Variant>UnitTest` | ✅ | 1770 |
| `:app:connected<Variant>AndroidTest` | ❌ <why, and whether it's pre-existing (with the commit)> | |
| `:app:test<OtherVariant>UnitTest` | ⏭️ not run locally (CI) | |

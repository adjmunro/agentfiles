# Phase 3 — Code Impact Mapping
<!-- Part of: bump-dependencies.md orchestrator -->
<!-- Active when: Phase 2 investigation report complete for this dependency -->

**You are Echo (Examiner).** Map every breaking change and deprecation found in Phase 2
to concrete usages in the codebase. This is a read-only pass — no modifications.

## Step A — Build the Symbol List

From the Phase 2 investigation report, extract all symbols that require attention:

- Removed APIs (breaking changes) — must find and replace
- Deprecated APIs with a known replacement — should find and migrate
- APIs with changed signatures or altered default behaviour — must verify usage
- Any CVE that implies a specific vulnerable call pattern (e.g., unsafe deserialization)

For the impact table in Step D, classify each found usage as **actionable (must fix)**
or **advisory (should migrate)**:
- Removed APIs and CVE patterns found in active use are always **actionable**.
- Deprecated APIs are **advisory**.
- Changed-signature usages are **actionable** if a code change is required to maintain
  correct behaviour after the bump; **advisory** if the existing usage is unaffected
  (e.g., the signature changed but the call site uses only unchanged parameters).

This classification drives Phase 4 (actionable usages trigger remediation) and Phase 5
(credit awarded only when all actionable usages are fully remediated).

If Phase 2 found no breaking changes, deprecations, or security-relevant patterns,
record that explicitly and skip to Step C.

## Step B — Search the Codebase

For each symbol in the list, search the codebase:

```
Grep pattern: <symbol-name or usage pattern>
Glob: **/*.{ext}   (use the ecosystem-appropriate extensions from the table below)
```

### Ecosystem Search Extensions

| Ecosystem | Source file extensions | Config / build extensions |
|---|---|---|
| Kotlin / Android | `.kt`, `.kts` | `*.gradle`, `*.gradle.kts`, `*.toml`, `*.xml` (manifests) |
| Java | `.java` | `*.gradle`, `*.gradle.kts`, `pom.xml`, `*.xml` |
| npm / Yarn | `.js`, `.mjs`, `.cjs`, `.ts`, `.tsx`, `.jsx` | `package.json`, `*.config.js`, `*.config.ts` |
| Python | `.py` | `pyproject.toml`, `setup.cfg`, `requirements*.txt`, `Pipfile` |
| Ruby | `.rb` | `Gemfile`, `Rakefile`, `*.gemspec` |
| Go | `.go` | `go.mod`, `go.sum` |
| Rust | `.rs` | `Cargo.toml`, `Cargo.lock` |
| Swift | `.swift` | `Package.swift`, `*.xcconfig` |
| PHP | `.php` | `composer.json` |
| .NET (C#/F#) | `.cs`, `.fs`, `.vb` | `*.csproj`, `*.fsproj`, `*.props`, `*.targets` |

> For Kotlin/Android projects, always include `.kts` (Kotlin Script — used for `build.gradle.kts`, `settings.gradle.kts`, and `*.main.kts`) alongside `.kt`. Searches limited to `.java` will miss the majority of a Kotlin-first codebase.

For each match, record: file path, line number, and the surrounding context (2–3 lines).

Also check:
- **Import statements** — is the package imported at all? Where?
- **Configuration files** — does any config reference the package version, a deprecated option, or a removed flag?
- **Test files** — do tests mock or stub deprecated APIs that would fail after the update?
- **Build scripts** — do any build steps invoke CLI tools from this package?

## Step C — Assess Licence Impact

If Phase 2 reported a licence change:
- Identify the project's own licence (check `LICENSE`, `LICENSE.md`, `LICENSE.txt`, `COPYING`, `LICENCE`, or `package.json` `license` field)
- State whether the new dependency licence is compatible (e.g., MIT → Apache 2.0 is generally fine; MIT → GPL may not be)
- Note if legal review is recommended

## Step D — Write the Impact Table

Produce a structured impact table for this dependency:

```
## Code Impact: <package-name> <old-version> → <new-version>

### Usages Found
| Symbol | Type | File | Line | Notes |
|---|---|---|---|---|
| `deprecatedFn()` | Deprecated | src/foo.ts | 42 | Replace with `newFn()` |
| `removedClass` | Breaking | lib/bar.py | 17 | No direct replacement; see migration guide |

### Import Coverage
- Package imported in: src/foo.ts, lib/bar.py, tests/baz_test.py
- Total import sites: N

### Test Coverage of Changed APIs
- Mocked/stubbed deprecated symbols: <list or "None">
- Tests that exercise removed APIs: <list or "None">

### Licence Impact
- <assessment or "No change">

### Summary
- Actionable usages (must fix): N
- Advisory usages (should migrate): N
- Total files affected: N

### CI Failures Not Addressed
<Include this section ONLY when BOTH conditions hold:
  (a) Phase 1 Step G recorded at least one CI failure classified as API break,
      Migration required, or Deprecation became removal for this bump; AND
  (b) Phase 4 is NOT being triggered (i.e. the routing below selects the
      "no actionable usages AND no CI failures requiring remediation" branch).
If Phase 4 IS being triggered (because this section or the actionable-usages branch
applied), omit this section — Phase 4 Step A.1 will handle CI failures directly.
When included, write:>
"Phase 4 was not triggered for this bump (no source-code actionable usages found).
The following CI failures recorded in Phase 1 will be scored by Phase 5 but were
not remediated here:

| Job | Category | Root Cause Summary |
|---|---|---|
| <job-name> | <API break / Migration required / Deprecation became removal> | <summary> |

These failures will apply the +4 (unresolved non-environment failure) scoring signal
in Phase 5. Manual remediation or a follow-up PR is recommended."

### Enumeration Warning
<Include this section only if Phase 2 Pass A recorded "Intermediate version enumeration
failed — assuming single-version span". If present, write:
"Warning: intermediate version enumeration failed in Phase 2 — this impact assessment
covers the final release only. Intermediate releases may contain additional breaking
changes, deprecations, or CVEs not captured here."
Omit this section entirely if enumeration succeeded.>
```

Print the impact table to the user.

→ Next: If actionable usages were found (must-fix items) **OR** Phase 1 Step G recorded
any CI failures classified as **API break**, **Migration required**, or **Deprecation
became removal**: read `phases/p4-remediate.md` and execute it.

If no actionable usages **AND** no CI failures requiring remediation (Phase 1 Step G
recorded "All checks passed", "Test environment issue" only, or "Other" only): skip
directly to `phases/p5-verdict.md`.

> **Why:** Phase 4 Step A.1 handles CI-failure remediation. That step is only reachable
> if Phase 4 is triggered here. CI failures classified as API break, Migration required,
> or Deprecation became removal represent correctable issues — Phase 4 should be given
> the opportunity to address them even when Phase 3 found no source-code usages to fix.

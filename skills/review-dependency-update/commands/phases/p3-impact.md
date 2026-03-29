# Phase 3 — Code Impact Mapping
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 2 investigation report complete for this dependency -->

**You are Echo (Examiner).** Map every breaking change and deprecation found in Phase 2
to concrete usages in the codebase. This is a read-only pass — no modifications.

## Step A — Build the Symbol List

From the Phase 2 investigation report, extract all symbols that require attention:

- Removed APIs (breaking changes) — must find and replace
- Deprecated APIs with a known replacement — should find and migrate
- APIs with changed signatures or altered default behaviour — must verify usage
- Any CVE that implies a specific vulnerable call pattern (e.g., unsafe deserialization)

If Phase 2 found no breaking changes, deprecations, or security-relevant patterns,
record that explicitly and skip to Step C.

## Step B — Search the Codebase

For each symbol in the list, search the codebase:

```
Grep pattern: <symbol-name or usage pattern>
Glob: **/*.{ext}   (appropriate extensions for this ecosystem)
```

For each match, record: file path, line number, and the surrounding context (2–3 lines).

Also check:
- **Import statements** — is the package imported at all? Where?
- **Configuration files** — does any config reference the package version, a deprecated option, or a removed flag?
- **Test files** — do tests mock or stub deprecated APIs that would fail after the update?
- **Build scripts** — do any build steps invoke CLI tools from this package?

## Step C — Assess Licence Impact

If Phase 2 reported a licence change:
- Identify the project's own licence (check `LICENSE`, `LICENSE.md`, or `package.json` `license` field)
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
```

Print the impact table to the user.

→ Next: If actionable usages were found (must-fix items), read `phases/p4-remediate.md`
and execute it.
If no actionable usages, skip to `phases/p5-verdict.md`.

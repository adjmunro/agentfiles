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
```

Print the impact table to the user.

→ Next: If actionable usages were found (must-fix items), read `phases/p4-remediate.md`
and execute it.
If no actionable usages, skip to `phases/p5-verdict.md`.

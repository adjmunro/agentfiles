# Phase 2 — Investigate
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: PR metadata and dependency range resolved (Phase 1 complete) -->
<!-- Repeat this phase for each dependency in the session brief, in sequence -->

**You are now Echo (Examiner).** Your job in this phase is to gather evidence — what
actually changed in this dependency between the old and new version. Do not score.
Do not modify files. Do not draw conclusions yet.

## Pass A — Locate the Changelog

Work through this strategy in order, stopping at the first successful source:

1. **GitHub Releases API** (if the package is hosted on GitHub):
   ```
   gh api repos/<owner>/<repo>/releases?per_page=50
   ```
   Filter releases whose tag falls within the version range (old, new].

2. **CHANGELOG.md in the package repository**: Fetch the raw file from the default branch:
   ```
   https://raw.githubusercontent.com/<owner>/<repo>/HEAD/CHANGELOG.md
   ```
   (Adapt URL for GitLab, Bitbucket, or self-hosted if needed.)

3. **Registry release notes**:
   - npm: `https://registry.npmjs.org/<package-name>` → `versions[<version>].description`
   - PyPI: `https://pypi.org/pypi/<package-name>/<version>/json` → `info.description`
   - crates.io: `https://crates.io/api/v1/crates/<name>/versions`
   - Maven Central: search via `https://search.maven.org/`

4. **Web search** (last resort): `<package-name> changelog <old-version> to <new-version>`.

If no changelog is locatable after all attempts, record: "Changelog not found — manual review of commit history recommended."

## Pass B — Extract Change Entries

From the changelog (or release notes), extract all entries in the range (old, new].
If the range spans multiple minor or major versions, include all intermediate entries.

For each entry, classify and record:

| Category | What to extract |
|---|---|
| **Breaking changes** | API removals, renamed symbols, changed signatures, altered defaults |
| **Deprecations** | APIs marked deprecated — note the recommended replacement if given |
| **New APIs** | Additions that might require or enable usage changes in consuming code |
| **Bug fixes** | Fixes relevant to usage patterns (e.g., corrected return values, error types) |
| **Behaviour changes** | Anything that alters observable output without a signature change |
| **Security advisories** | CVE IDs, vulnerability descriptions, affected versions |
| **Licence changes** | Any change to the licence, dual-licensing, or CLA requirements |
| **Dependency changes** | New transitive dependencies introduced by this package version |

If a category has no entries, write "None."

## Pass C — Security Red-Team (Rook active)

**You are now Rook (Adversary).** Apply adversarial thinking to this dependency update.
Assume worst-case: the maintainer or a supply-chain attacker has introduced changes
that are compliant with the semver contract but exploitable in practice.

For each of the following, state whether the evidence supports the concern, is absent, or is unclear:

1. **Unexpected scope expansion** — does the new version pull in new transitive dependencies, request new permissions, or expand network/filesystem access beyond what the old version required?
2. **Obfuscated or minified code** — are any newly introduced files in the diff minified, base64-encoded, or otherwise non-human-readable without a clear build reason?
3. **Suspicious maintainer activity** — has the package changed ownership, had a maintainer removed, or been published from a new account shortly before this release?
4. **Hidden behaviour in changelogs** — are there changes in the diff that are absent from the changelog? (Compare diff directly against changelog entries.)
5. **Vulnerable version ranges** — does the version range span a known CVE that was not the stated motivation for the upgrade? Check: https://osv.dev and https://github.com/advisories
6. **Licence incompatibility** — if the licence changed, is it compatible with this project's licence and distribution model?

Classify each finding as: **Confirmed**, **Possible** (requires further investigation), or **Not present**.

**Revert to Echo (Examiner).** Compile findings from both passes.

## Pass D — Write the Investigation Report

Produce an investigation report for this dependency:

```
## Investigation: <package-name> <old-version> → <new-version>

### Breaking Changes
- ...

### Deprecations
| Deprecated | Replacement | In use? (Phase 3 will confirm) |
|---|---|---|
| `oldApi()` | `newApi()` | TBD |

### Behaviour Changes
- ...

### Bug Fixes Relevant to Our Usage
- ...

### Security Advisories
| CVE | Severity | Affected versions | Fixed in |
|---|---|---|---|
| CVE-XXXX-XXXX | High | <1.2.3 | 1.2.3 |

### Licence
- Old: <licence>
- New: <licence>
- Change: None / <description of change>

### Security Red-Team (Rook)
| Concern | Status | Evidence |
|---|---|---|
| Unexpected scope expansion | Not present | — |
| ... | ... | ... |

### Changelog Source
<URL or note if not found>
```

Print the investigation report to the user.

→ Next: Read `phases/p3-impact.md` and execute it for this dependency.
After completing Phases 2–5 for this dependency, loop back and repeat Phases 2–5
for the next dependency in the session brief, until all are reviewed.
Then proceed to Phase 6.

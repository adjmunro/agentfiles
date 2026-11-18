# Pre-flight

Nothing else starts until all of these hold on the code you're about to push.

1. **It builds, installs and runs without crashing.** Launch it, sign in, reach the main screen.
2. **All unit tests pass.**
3. **All instrumented/UI tests pass** (Android `connected*AndroidTest`, iOS UI test targets in the scheme).

## Finding the right tasks

Don't hard-code task names; they drift between projects and branches.
- Check the project's `AGENTS.md`/`CLAUDE.md`/README and any CI or agent tooling scripts for the canonical test commands and which variants matter (often only the dev/debug variants).
- Otherwise list them: `./gradlew tasks --all | grep -Ei 'UnitTest|AndroidTest|allTests'` (Android/KMP), or `xcodebuild -list -project <x>.xcodeproj` for iOS. A scheme's Test action decides which test targets run, so pick the scheme of the dev/debug configuration.
- iOS from the command line: if the project uses SwiftPM build-tool plugins or macros (e.g. SwiftLint, LicensePlist), add `-skipPackagePluginValidation -skipMacroValidation`. Xcode's GUI trusts them once; `xcodebuild` otherwise fails at "Validate plug-in".

## Running them cheaply

- Skip a rerun only if no code changed since the last passing run. A rebase onto a moved base branch counts as a change.
- Lean on the build cache: plain `test` tasks only re-run what changed. Don't add `clean`/`--rerun-tasks` unless results look stale.
- Run long suites in the background with `--continue`, then read the JUnit XML (`build/test-results/**/TEST-*.xml`, `build/outputs/androidTest-results/**`) for counts instead of trusting the exit code of a wrapper.
- iOS: `xcodebuild build-for-testing` once, then `test-without-building -resultBundlePath <scratchpad>/x.xcresult` (delete an old bundle first; it won't overwrite). Read counts with `xcrun xcresulttool get test-results summary --path x.xcresult --compact` (`totalTestCount`, `passedTests`, `failedTests`, `skippedTests`, `testFailures`), not the log.

## Built against a paired repo

When the app builds a library from another local checkout (e.g. iOS building the KMP framework from an Android/KMP checkout via a local settings file), its own tree hash doesn't describe what ran.
- Point the build at a checkout of the counterpart branch this PR pairs with, plus any of its uncommitted changes. Use the project's dedicated integration worktree if it has one (see its `AGENTS.md`), rather than moving the developer's main checkout.
- Record that checkout's commit, tree and clean/dirty state in the provenance line as well.
- Temporary evidence fakes in the library (`evidence/forcing-states.md`) go in the same checkout. Run the tests before applying them, or rebuild without them first.

## Instrumented tests and the installed app

`connected*AndroidTest` installs the variant's own APK (same application ID as the build you run by hand) plus a test APK, and by default uninstalls both when it finishes. That wipes the app's data, including any sign-in. Either:
- run instrumented tests before signing in for evidence, or after it, or
- keep the APKs with `-Pandroid.injected.androidTest.leaveApksInstalledAfterRun=true`. I haven't verified this property in every AGP version. Tests that clear app data will still sign you out.

## Reporting

Above the table, one line of provenance:
- the commit SHA and **tree hash** (`git rev-parse --short HEAD HEAD^{tree}`);
- whether the working tree was clean (`git status --porcelain` is empty). Results from a dirty tree don't count for the commit;
- the date and time with timezone.

Results still apply to a later commit only if its tree hash matches. A re-sign or reword keeps it. A rebase onto a moved base changes it, even a clean one, so rerun (the build cache keeps that cheap). Compare with `git rev-parse <old-sha>^{tree} HEAD^{tree}`.

Never claim "all tests pass". Record each Gradle task you actually ran, with its exact name including the flavour/variant (e.g. `:app:testRedDevDebugUnitTest`, `:modules:kmp:iosSimulatorArm64Test`), or each `xcodebuild` scheme with its destination (e.g. `RedEnergy - Debug` on iPhone 18 Pro, iOS 27.0), its result (✅ / ❌ / ⏭️ not run) and the test count from the JUnit XML or result bundle (and how many were skipped, if any). That goes in the PR's verification comment, not the body (see `templates/verification-comment.md` and "Verification comment" in `publish.md`). Include variants you deliberately skipped, so reviewers can see what CI has to cover.

## If something fails

- A failure caused by this branch: fix it before anything else.
- A failure that also happens on the base branch: confirm it there (or show the change didn't touch it), tell the user, and ask whether to fix it in this PR (separate commit), in its own PR, or leave it. Note it in the PR either way.

# Component: british-english-hook

Writes a git pre-commit hook to `$TARGET/.git/hooks/pre-commit` that enforces
British English spelling in staged prose files using portable perl substitutions.
The hook auto-corrects and re-stages — it does not block the commit.

**Inputs:** `$TARGET`, `$AGENTFILES_ROOT`

## DO

- Back up any existing pre-commit hook before replacing it
- Chain to the original hook at the end if one existed — do not discard prior behaviour
- Apply substitutions only to prose files (`.md`, `.txt`, `.adoc`)
- Re-stage modified files after substitution so the corrected text goes into the commit
- Use `perl -pi -e` for in-place substitution — it is portable across macOS and Linux

## DO NOT

- Apply substitutions inside fenced code blocks (lines between ` ``` ` delimiters)
- Abort the commit due to substitutions — the hook is advisory/auto-fix, not blocking
- Require any external tool beyond `git`, `perl`, and standard POSIX utilities

---

## Phase 1 — Check for Existing Hook

Check whether `$TARGET/.git/hooks/pre-commit` exists.

- If it contains the comment `# Installed by agentfiles british-english-hook`:
  Print "british-english-hook already installed" and stop.
- If it exists but does NOT contain that comment:
  Copy it to `$TARGET/.git/hooks/pre-commit.bak`
  Print: "Existing pre-commit hook backed up to `.git/hooks/pre-commit.bak` — it will be chained."
  Set `$HAD_EXISTING_HOOK=true`
- If it does not exist: proceed without backup. Set `$HAD_EXISTING_HOOK=false`.

---

## Phase 2 — Write Hook Script

Write the following script to `$TARGET/.git/hooks/pre-commit`.

At the end, replace `[CHAIN]` with:
- `exec "$(git rev-parse --git-dir)/hooks/pre-commit.bak"` if `$HAD_EXISTING_HOOK=true`
- Remove the `[CHAIN]` line entirely if `$HAD_EXISTING_HOOK=false`

```zsh
#!/usr/bin/env zsh
# Installed by agentfiles british-english-hook.
# Applies British English spelling to staged prose files and re-stages them.
# Does not block the commit — corrections are applied automatically.

set -e

# Prose file extensions to process
prose_extensions='.*\.(md|txt|adoc)$'

# Get staged prose files (added or modified, not deleted)
staged=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null \
         | grep -E "$prose_extensions" || true)

[[ -z "$staged" ]] && { [CHAIN]; exit 0; }

for file in ${(f)staged}; do
  [[ -f "$file" ]] || continue

  # -ize → -ise endings
  perl -pi -e '
    s/\borganize\b/organise/g; s/\bOrganize\b/Organise/g; s/\bORGANIZE\b/ORGANISE/g;
    s/\boptimize\b/optimise/g; s/\bOptimize\b/Optimise/g; s/\bOPTIMIZE\b/OPTIMISE/g;
    s/\bcustomize\b/customise/g; s/\bCustomize\b/Customise/g;
    s/\bnormalize\b/normalise/g; s/\bNormalize\b/Normalise/g;
    s/\brecognize\b/recognise/g; s/\bRecognize\b/Recognise/g;
    s/\banalyze\b/analyse/g; s/\bAnalyze\b/Analyse/g;
    s/\brealize\b/realise/g; s/\bRealize\b/Realise/g;
    s/\bfinalize\b/finalise/g; s/\bFinalize\b/Finalise/g;
    s/\bprioritize\b/prioritise/g; s/\bPrioritize\b/Prioritise/g;
    s/\bsummarize\b/summarise/g; s/\bSummarize\b/Summarise/g;
    s/\bsynchronize\b/synchronise/g; s/\bSynchronize\b/Synchronise/g;
    s/\bstandardize\b/standardise/g; s/\bStandardize\b/Standardise/g;
    s/\bminimize\b/minimise/g; s/\bMinimize\b/Minimise/g;
    s/\bmaximize\b/maximise/g; s/\bMaximize\b/Maximise/g;
    s/\butilize\b/utilise/g; s/\bUtilize\b/Utilise/g;
  ' "$file"

  # -our endings
  perl -pi -e '
    s/\bbehavior\b/behaviour/g; s/\bBehavior\b/Behaviour/g;
    s/\bcolor\b/colour/g; s/\bColor\b/Colour/g;
    s/\bfavor\b/favour/g; s/\bFavor\b/Favour/g;
    s/\bhonor\b/honour/g; s/\bHonor\b/Honour/g;
    s/\bfavorite\b/favourite/g; s/\bFavorite\b/Favourite/g;
    s/\bneighbor\b/neighbour/g; s/\bNeighbor\b/Neighbour/g;
    s/\blabor\b/labour/g; s/\bLabor\b/Labour/g;
    s/\bhumor\b/humour/g; s/\bHumor\b/Humour/g;
    s/\bodor\b/odour/g; s/\bOdor\b/Odour/g;
    s/\bvapor\b/vapour/g; s/\bVapor\b/Vapour/g;
  ' "$file"

  # -re endings
  perl -pi -e '
    s/\bcenter\b/centre/g; s/\bCenter\b/Centre/g;
    s/\btheatre\b/theatre/g;
    s/\bfiber\b/fibre/g; s/\bFiber\b/Fibre/g;
    s/\bmeter\b/metre/g; s/\bMeter\b/Metre/g;
  ' "$file"

  # Miscellaneous
  perl -pi -e '
    s/\btraveling\b/travelling/g; s/\bTraveling\b/Travelling/g;
    s/\bprogram\b/programme/g; s/\bProgram\b/Programme/g;
    s/\bcatalog\b/catalogue/g; s/\bCatalog\b/Catalogue/g;
    s/\bdialog\b/dialogue/g; s/\bDialog\b/Dialogue/g;
    s/\bcanceled\b/cancelled/g; s/\bCanceled\b/Cancelled/g;
    s/\bcanceling\b/cancelling/g; s/\bCanceling\b/Cancelling/g;
    s/\bmodeling\b/modelling/g; s/\bModeling\b/Modelling/g;
  ' "$file"

  git add "$file"
done

[CHAIN]
```

After writing, run `chmod 755 "$TARGET/.git/hooks/pre-commit"`.

---

## Phase 3 — Verify and Report

Confirm the file is executable:
- Run `ls -l "$TARGET/.git/hooks/pre-commit"` and check for `x` in permissions

Print:
```
✓ pre-commit hook installed: .git/hooks/pre-commit
  Substitution categories: -ize→-ise, -our, -re, miscellaneous
  Prose extensions:         .md  .txt  .adoc
  Chained to:               .git/hooks/pre-commit.bak    [if applicable]
                            (none)                        [if no prior hook]
```

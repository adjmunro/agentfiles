#!/usr/bin/env zsh
# git-sign-branch — batch-sign unsigned commits by the current user
#
# Signs all unsigned commits on the current branch authored by git user.email,
# starting from the commit immediately after the most recent commit that is both
# authored by the current user AND already carries a GPG signature.
#
# Falls back to the remote tracking branch merge-base if no prior signed commit
# is found. Falls back to the root commit if no remote tracking branch exists.
#
# Commits authored by other people are left untouched (but will be rebased over
# if they fall within the signing range — hashes change, signatures are preserved).
#
# Usage: git-sign-branch
# Install: copy to ~/.local/bin/git-sign-branch and chmod +x

set -euo pipefail

# ── Preflight ──────────────────────────────────────────────────────────────────

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print -u2 "git-sign-branch: not inside a git repository"
    exit 1
fi

USER_EMAIL=$(git config user.email 2>/dev/null || true)
if [[ -z "$USER_EMAIL" ]]; then
    print -u2 "git-sign-branch: git user.email is not configured"
    exit 1
fi

# ── Find the signing base ──────────────────────────────────────────────────────
#
# Walk backwards through history. The first commit we find that was authored by
# the current user AND is already signed becomes the BASE — we sign everything
# after it. This means re-signing is a no-op (signed commits are skipped by the
# exec script).
#
# %G? signature codes:
#   G  good and valid          U  good, unknown validity
#   X  good, expired sig       Y  good, expired key
#   R  good, revoked key       B  bad signature
#   N  no signature

BASE=""

LAST_SIGNED=$(git log HEAD --format="%H %G? %ae" | \
    awk -v email="$USER_EMAIL" '
        $3 == email && $2 != "N" && $2 != "B" { print $1; exit }
    ')

if [[ -n "$LAST_SIGNED" ]]; then
    BASE="$LAST_SIGNED"
else
    # No prior signed commit by this user — fall back to remote tracking merge-base
    TRACKED=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || true)
    if [[ -n "$TRACKED" ]]; then
        BASE=$(git merge-base HEAD "$TRACKED" 2>/dev/null || true)
    fi
    # Last resort: the initial commit (sign the whole branch)
    if [[ -z "$BASE" ]]; then
        BASE=$(git rev-list --max-parents=0 HEAD)
    fi
fi

# ── Count what needs signing ───────────────────────────────────────────────────

UNSIGNED_COUNT=$(git log --format="%G? %ae" "${BASE}..HEAD" 2>/dev/null | \
    awk -v email="$USER_EMAIL" '$1 == "N" && $2 == email' | wc -l | tr -d ' ')

if [[ "$UNSIGNED_COUNT" -eq 0 ]]; then
    exit 0
fi

print -u2 "git-sign-branch: signing ${UNSIGNED_COUNT} commit(s)"

# ── Rebase with selective signing ─────────────────────────────────────────────
#
# git rebase --exec runs a command after each replayed commit. The exec script
# checks whether the just-applied commit is authored by the current user and
# unsigned — if so, amends it with a GPG signature. Commits by other authors
# pass through unmodified.

EXEC=$(mktemp /tmp/git-sign-exec.XXXXXX)
chmod +x "$EXEC"

cat > "$EXEC" << 'EXEC_EOF'
#!/bin/zsh
_email=$(git config user.email)
_author=$(git log -1 --format='%ae')
_sig=$(git log -1 --format='%G?')
if [[ "$_author" == "$_email" && ( "$_sig" == "N" || "$_sig" == "B" ) ]]; then
    git commit --amend --no-edit -S --quiet
fi
EXEC_EOF

git rebase "$BASE" --exec "$EXEC"
STATUS=$?

rm -f "$EXEC"
exit $STATUS

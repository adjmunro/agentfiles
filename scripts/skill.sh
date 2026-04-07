#!/usr/bin/env zsh
# skill — agentfiles skill manager
# Installs and updates Claude Code skills from a remote agentfiles repository.
#
# Usage:
#   skill install <name>   Install a skill into the current project
#   skill update [name]    Update installed skills (default: all)
#   skill list             List installed skills and their versions
#   skill status           Check for available updates
#   skill remove <name>    Remove an installed skill
#
# Configuration (environment variables):
#   AGENTFILES_REPO    GitHub repo slug  (default: adjmunro/agentfiles)
#   AGENTFILES_BRANCH  Branch to use     (default: main)

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────

AGENTFILES_REPO="${AGENTFILES_REPO:-adjmunro/agentfiles}"
AGENTFILES_BRANCH="${AGENTFILES_BRANCH:-main}"
AGENTFILES_REMOTE="https://github.com/${AGENTFILES_REPO}.git"
AGENTFILES_RAW="https://raw.githubusercontent.com/${AGENTFILES_REPO}/${AGENTFILES_BRANCH}"

STATE_DIR=".agentfiles"

# ── Helpers ───────────────────────────────────────────────────────────────────

die()  { print -u2 "skill: error: $*"; exit 1 }
step() { print "  $*" }
ok()   { print "✓ $*" }

# Detect (or create) the skills directory for the current project.
skills_dir() {
  if   [[ -d ".agents/skills" ]]; then print ".agents/skills"
  elif [[ -d ".claude/skills" ]]; then print ".claude/skills"
  elif [[ -d ".agents"        ]]; then mkdir -p ".agents/skills";  print ".agents/skills"
  else                                  mkdir -p ".claude/skills";  print ".claude/skills"
  fi
}

# Extract the first semver string from VERSION.md content.
parse_version() {
  grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<< "$1" | head -1
}

# Fetch the current version of a skill from the remote repository.
remote_version() {
  local name="$1"
  local content
  content=$(curl -fsSL "${AGENTFILES_RAW}/skills/${name}/VERSION.md" 2>/dev/null) || { print ""; return 0; }
  parse_version "$content"
}

# Read the locally recorded version of an installed skill.
local_version() {
  local name="$1"
  local vfile="${STATE_DIR}/${name}/version"
  [[ -f "$vfile" ]] && cat "$vfile" || print ""
}

# ── Commands ──────────────────────────────────────────────────────────────────

cmd_install() {
  local name="${1:?usage: skill install <name>}"

  # Verify the skill exists remotely and get its version.
  local version
  version=$(remote_version "$name")
  [[ -z "$version" ]] && die "skill '${name}' not found in ${AGENTFILES_REPO}"

  local current
  current=$(local_version "$name")

  if [[ "$current" == "$version" ]]; then
    print "${name} is already at v${version}."
    return
  fi

  [[ -n "$current" ]] \
    && print "Updating ${name} v${current} → v${version}..." \
    || print "Installing ${name} v${version}..."

  # Sparse-clone only the skill's directory into a temp location.
  local tmp
  tmp=$(mktemp -d)
  trap "rm -rf '${tmp}'" EXIT INT TERM

  (
    git clone --quiet --filter=blob:none --sparse --depth=1 \
      "$AGENTFILES_REMOTE" "$tmp" 2>/dev/null
    git -C "$tmp" sparse-checkout set "skills/${name}" >/dev/null 2>&1
  ) || die "failed to fetch '${name}' from ${AGENTFILES_REPO}"

  local src="${tmp}/skills/${name}"
  [[ -d "$src" ]] || die "skill '${name}' directory not found in repository"

  # Copy into the project's skills directory.
  local dest
  dest="$(skills_dir)/${name}"
  mkdir -p "$dest"
  cp -r "${src}/." "$dest/"
  step "→ ${dest}/"

  # Record installed version so status and update can work offline.
  mkdir -p "${STATE_DIR}/${name}"
  print "$version" > "${STATE_DIR}/${name}/version"

  rm -rf "$tmp"
  trap - EXIT INT TERM

  ok "${name} v${version} installed"
}

cmd_update() {
  local name="${1:-}"

  # No argument: update every installed skill.
  if [[ -z "$name" ]]; then
    [[ -d "$STATE_DIR" ]] || { print "No skills installed."; return; }
    local found=false
    for state in "${STATE_DIR}"/*/; do
      [[ -d "$state" ]] || continue
      found=true
      local skill_name="${state%/}"
      skill_name="${skill_name##*/}"
      cmd_update "$skill_name"
    done
    $found || print "No skills installed."
    return
  fi

  local current
  current=$(local_version "$name")
  [[ -z "$current" ]] && die "skill '${name}' is not installed (run: skill install ${name})"

  local latest
  latest=$(remote_version "$name")
  [[ -z "$latest" ]] && die "could not reach remote for '${name}'"

  if [[ "$current" == "$latest" ]]; then
    print "${name}: already up to date (v${current})"
    return
  fi

  cmd_install "$name"
}

cmd_list() {
  [[ -d "$STATE_DIR" ]] || { print "No skills installed."; return; }

  local found=false
  print "Installed skills:"
  for state in "${STATE_DIR}"/*/; do
    [[ -d "$state" ]] || continue
    found=true
    local name="${state%/}"; name="${name##*/}"
    local version; version=$(local_version "$name")
    printf "  %-22s v%s\n" "$name" "$version"
  done
  $found || print "  (none)"
}

cmd_status() {
  [[ -d "$STATE_DIR" ]] || { print "No skills installed."; return; }

  print "Checking for updates..."
  local found=false
  for state in "${STATE_DIR}"/*/; do
    [[ -d "$state" ]] || continue
    found=true
    local name="${state%/}"; name="${name##*/}"
    local current; current=$(local_version "$name")
    local latest;  latest=$(remote_version "$name" 2>/dev/null) || latest=""

    if [[ -z "$latest" ]]; then
      printf "  %-22s v%s  (remote unavailable)\n" "$name" "$current"
    elif [[ "$current" == "$latest" ]]; then
      printf "  %-22s v%s  up to date\n" "$name" "$current"
    else
      printf "  %-22s v%s → v%s  UPDATE AVAILABLE\n" "$name" "$current" "$latest"
    fi
  done
  $found || print "  No skills installed."
}

cmd_remove() {
  local name="${1:?usage: skill remove <name>}"

  local current; current=$(local_version "$name")
  [[ -z "$current" ]] && die "skill '${name}' is not installed"

  local dest; dest="$(skills_dir)/${name}"
  [[ -d "$dest" ]] && rm -rf "$dest"
  rm -rf "${STATE_DIR}/${name}"

  ok "${name} removed"
}

# ── Dispatch ──────────────────────────────────────────────────────────────────

case "${1:-}" in
  install) shift; cmd_install "$@" ;;
  update)  shift; cmd_update  "${1:-}" ;;
  list)    cmd_list ;;
  status)  cmd_status ;;
  remove)  shift; cmd_remove  "$@" ;;
  *)
    print "Usage: skill <command> [args]"
    print ""
    print "Commands:"
    print "  install <name>   Fetch and install a skill from ${AGENTFILES_REPO}"
    print "  update [name]    Update installed skills (default: all)"
    print "  list             List installed skills and their versions"
    print "  status           Check for available updates"
    print "  remove <name>    Remove an installed skill"
    print ""
    print "Environment:"
    print "  AGENTFILES_REPO    Source repo  (default: adjmunro/agentfiles)"
    print "  AGENTFILES_BRANCH  Branch       (default: main)"
    print ""
    print "Notes:"
    print "  Installed skills go to .claude/skills/<name>/ or .agents/skills/<name>/."
    print "  Version state is tracked in .agentfiles/<name>/version — commit both."
    print "  For private repos, ensure git credentials are configured before installing."
    ;;
esac

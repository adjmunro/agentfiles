#!/usr/bin/env zsh
# agentfiles — component manager for agentfiles repositories
# Installs and updates skills, hooks, and commands from a remote agentfiles repository.
#
# Usage:
#   agentfiles install <type>/<name>   Install a component
#   agentfiles update [skill/<name>]   Update installed skills (default: all)
#   agentfiles list                    List installed skills and their versions
#   agentfiles status                  Check for available skill updates
#   agentfiles remove <type>/<name>    Remove an installed component
#   agentfiles force-update            Clear CLI cache and re-download agentfiles.sh
#
# Supported types:
#   skill/<name>    From skills/<name>/        → <skills_dir>/<name>/
#   hook/<name>     From hooks/<name>.sh       → .claude/hooks/<name>.sh
#   command/<name>  From commands/<name>.md    → .claude/commands/<name>.md
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

CACHE_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/agentfiles/agentfiles.sh"

# ── Helpers ───────────────────────────────────────────────────────────────────

die()  { print -u2 "agentfiles: error: $*"; exit 1 }
step() { print "  $*" }
ok()   { print "✓ $*" }

# Parse <type>/<name> into _type and _name.
parse_ref() {
  local ref="$1"
  [[ "$ref" == */* ]] || die "expected <type>/<name>, got '${ref}' — e.g. skill/implement, hook/bash-guard"
  _type="${ref%%/*}"
  _name="${ref#*/}"
}

# Map type/name to repo path, local destination, and whether it is a directory.
# Sets: _repo_path, _local_dest, _is_dir
resolve_paths() {
  local type="$1" name="$2"
  case "$type" in
    skill)
      _repo_path="skills/${name}"
      _local_dest="$(skills_dir)/${name}"
      _is_dir=true
      ;;
    hook)
      _repo_path="hooks/${name}.sh"
      _local_dest=".claude/hooks/${name}.sh"
      _is_dir=false
      ;;
    command)
      _repo_path="commands/${name}.md"
      _local_dest=".claude/commands/${name}.md"
      _is_dir=false
      ;;
    *)
      die "unknown type '${type}' — supported: skill, hook, command"
      ;;
  esac
}

# Detect the skills directory for the current project (no side effects).
skills_dir() {
  if   [[ -d ".agents/skills" ]]; then print ".agents/skills"
  elif [[ -d ".claude/skills" ]]; then print ".claude/skills"
  elif [[ -d ".agents"        ]]; then print ".agents/skills"
  else                                  print ".claude/skills"
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
  content=$(curl -fsSL "${AGENTFILES_RAW}/skills/${name}/VERSION.md" 2>/dev/null) \
    || { print ""; return 0; }
  parse_version "$content"
}

# Read the version from an installed skill's own VERSION.md.
local_version() {
  local name="$1"
  local vfile; vfile="$(skills_dir)/${name}/VERSION.md"
  [[ -f "$vfile" ]] || { print ""; return 0; }
  parse_version "$(< "$vfile")"
}

# ── Commands ──────────────────────────────────────────────────────────────────

cmd_install() {
  local ref="${1:?usage: agentfiles install <type>/<name>}"
  local _type _name _repo_path _local_dest _is_dir
  parse_ref "$ref"
  resolve_paths "$_type" "$_name"

  # Skills: check versions and skip if already current.
  local version=""
  if [[ "$_is_dir" == true ]]; then
    version=$(remote_version "$_name")
    [[ -z "$version" ]] && die "${_type}/${_name} not found in ${AGENTFILES_REPO}"

    local current; current=$(local_version "$_name")
    if [[ "$current" == "$version" ]]; then
      print "${_type}/${_name} is already at v${version}."
      return
    fi
    [[ -n "$current" ]] \
      && print "Updating ${_type}/${_name} v${current} → v${version}..." \
      || print "Installing ${_type}/${_name} v${version}..."
  else
    print "Installing ${_type}/${_name}..."
  fi

  # Sparse-clone only the target path.
  local tmp; tmp=$(mktemp -d)
  trap "rm -rf '${tmp}'" EXIT INT TERM

  (
    git clone --quiet --filter=blob:none --sparse --depth=1 \
      "$AGENTFILES_REMOTE" "$tmp" 2>/dev/null
    git -C "$tmp" sparse-checkout set "$_repo_path" >/dev/null 2>&1
  ) || die "failed to fetch '${_type}/${_name}' from ${AGENTFILES_REPO}"

  local src="${tmp}/${_repo_path}"
  [[ -e "$src" ]] || die "'${_repo_path}' not found in repository"

  if [[ "$_is_dir" == true ]]; then
    mkdir -p "$_local_dest"
    cp -r "${src}/." "$_local_dest/"
  else
    mkdir -p "${_local_dest:h}"
    cp "$src" "$_local_dest"
  fi
  step "→ ${_local_dest}"

  rm -rf "$tmp"
  trap - EXIT INT TERM

  [[ -n "$version" ]] \
    && ok "${_type}/${_name} v${version} installed" \
    || ok "${_type}/${_name} installed"
}

cmd_update() {
  local ref="${1:-}"

  if [[ -z "$ref" ]]; then
    local dir; dir=$(skills_dir)
    [[ -d "$dir" ]] || { print "No skills installed."; return; }
    local found=false
    for skill_dir in "${dir}"/*/; do
      [[ -d "$skill_dir" ]] || continue
      found=true
      local name="${skill_dir%/}"; name="${name##*/}"
      cmd_update "skill/${name}"
    done
    $found || print "No skills installed."
    return
  fi

  local _type _name; parse_ref "$ref"

  # Non-skill types have no VERSION.md — reinstall unconditionally.
  if [[ "$_type" != "skill" ]]; then
    print "note: no version tracking for ${_type}s — reinstalling"
    cmd_install "$ref"
    return
  fi

  local current; current=$(local_version "$_name")
  [[ -z "$current" ]] \
    && die "skill '${_name}' is not installed (run: agentfiles install skill/${_name})"

  local latest; latest=$(remote_version "$_name")
  [[ -z "$latest" ]] && die "could not reach remote for '${_name}'"

  if [[ "$current" == "$latest" ]]; then
    print "skill/${_name}: already up to date (v${current})"
    return
  fi

  cmd_install "$ref"
}

cmd_list() {
  local dir; dir=$(skills_dir)
  [[ -d "$dir" ]] || { print "No skills installed."; return; }

  local found=false
  print "Installed skills:"
  for skill_dir in "${dir}"/*/; do
    [[ -d "$skill_dir" ]] || continue
    found=true
    local name="${skill_dir%/}"; name="${name##*/}"
    local version; version=$(local_version "$name")
    printf "  %-22s v%s\n" "$name" "$version"
  done
  $found || print "  (none)"
}

cmd_status() {
  local dir; dir=$(skills_dir)
  [[ -d "$dir" ]] || { print "No skills installed."; return; }

  print "Checking for updates..."
  local found=false
  for skill_dir in "${dir}"/*/; do
    [[ -d "$skill_dir" ]] || continue
    found=true
    local name="${skill_dir%/}"; name="${name##*/}"
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
  local ref="${1:?usage: agentfiles remove <type>/<name>}"
  local _type _name _repo_path _local_dest _is_dir
  parse_ref "$ref"
  resolve_paths "$_type" "$_name"

  [[ -e "$_local_dest" ]] || die "${_type}/${_name} is not installed"
  rm -rf "$_local_dest"
  ok "${_type}/${_name} removed"
}

cmd_force_update() {
  print "Refreshing agentfiles CLI cache..."
  mkdir -p "${CACHE_FILE:h}"
  curl -fsSL "${AGENTFILES_RAW}/scripts/agentfiles.sh" -o "$CACHE_FILE" \
    || die "failed to download agentfiles.sh from ${AGENTFILES_RAW}"
  ok "CLI cached at ${CACHE_FILE}"
}

# ── Dispatch ──────────────────────────────────────────────────────────────────

case "${1:-}" in
  install)      shift; cmd_install "$@" ;;
  update)       shift; cmd_update  "${1:-}" ;;
  list)         cmd_list ;;
  status)       cmd_status ;;
  remove)       shift; cmd_remove  "$@" ;;
  force-update) cmd_force_update ;;
  *)
    print "Usage: agentfiles <command> [args]"
    print ""
    print "Commands:"
    print "  install <type>/<name>    Install a component from ${AGENTFILES_REPO}"
    print "  update [skill/<name>]    Update installed skills (default: all)"
    print "  list                     List installed skills and their versions"
    print "  status                   Check for available skill updates"
    print "  remove <type>/<name>     Remove an installed component"
    print "  force-update             Clear CLI cache and re-download agentfiles.sh"
    print ""
    print "Types:"
    print "  skill/<name>    skills/<name>/       →  <skills_dir>/<name>/"
    print "  hook/<name>     hooks/<name>.sh      →  .claude/hooks/<name>.sh"
    print "  command/<name>  commands/<name>.md   →  .claude/commands/<name>.md"
    print ""
    print "Environment:"
    print "  AGENTFILES_REPO    Source repo  (default: adjmunro/agentfiles)"
    print "  AGENTFILES_BRANCH  Branch       (default: main)"
    print ""
    print "Notes:"
    print "  Skills have VERSION.md — update checks before fetching, status compares versions."
    print "  Hooks and commands have no version tracking — update always reinstalls."
    print "  For private repos, ensure git credentials are configured before installing."
    ;;
esac

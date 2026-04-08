#!/usr/bin/env zsh
# agentfiles — component manager for agentfiles repositories
# Installs and updates components from a remote agentfiles repository.
#
# Usage:
#   agentfiles install <type>/<name>   Install a component
#   agentfiles update [<type>/<name>]  Update versioned components (default: all)
#   agentfiles list                    List installed versioned components
#   agentfiles status                  Check for available updates
#   agentfiles remove <type>/<name>    Remove an installed component
#   agentfiles force-update            Clear CLI cache and re-download
#
# Types:
#   skill/<name>    Directory  skills/<name>/       →  <skills_dir>/<name>/
#   hook/<name>     Directory  hooks/<name>/        →  .claude/hooks/<name>/
#   prompt/<name>   File       prompts/<name>.md    →  .claude/commands/<name>.md
#   command/<name>  File       commands/<name>.md   →  .claude/commands/<name>.md
#
# Directory types (skill, hook) support VERSION.md and can be version-tracked.
# File types (prompt, command) are always reinstalled on update.
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
      _repo_path="hooks/${name}"
      _local_dest=".claude/hooks/${name}"
      _is_dir=true
      ;;
    prompt)
      _repo_path="prompts/${name}.md"
      _local_dest=".claude/commands/${name}.md"
      _is_dir=false
      ;;
    command)
      _repo_path="commands/${name}.md"
      _local_dest=".claude/commands/${name}.md"
      _is_dir=false
      ;;
    *)
      die "unknown type '${type}' — supported: skill, hook, prompt, command"
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

# Extract the first semver string from content.
parse_version() {
  grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<< "$1" | head -1
}

# Fetch the version from a remote directory component's VERSION.md.
remote_version() {
  local repo_path="$1"
  local content
  content=$(curl -fsSL "${AGENTFILES_RAW}/${repo_path}/VERSION.md" 2>/dev/null) \
    || { print ""; return 0; }
  parse_version "$content"
}

# Read the version from an installed directory component's VERSION.md.
local_version() {
  local local_dest="$1"
  local vfile="${local_dest}/VERSION.md"
  [[ -f "$vfile" ]] || { print ""; return 0; }
  parse_version "$(< "$vfile")"
}

# ── Commands ──────────────────────────────────────────────────────────────────

cmd_install() {
  local ref="${1:?usage: agentfiles install <type>/<name>}"
  local _type _name _repo_path _local_dest _is_dir
  parse_ref "$ref"
  resolve_paths "$_type" "$_name"

  local version=""
  if [[ "$_is_dir" == true ]]; then
    version=$(remote_version "$_repo_path")
    [[ -z "$version" ]] && die "${ref} not found in ${AGENTFILES_REPO}"

    local current; current=$(local_version "$_local_dest")
    if [[ "$current" == "$version" ]]; then
      print "${ref} is already at v${version}."
      return
    fi
    [[ -n "$current" ]] \
      && print "Updating ${ref} v${current} → v${version}..." \
      || print "Installing ${ref} v${version}..."
  else
    print "Installing ${ref}..."
  fi

  # Sparse-clone only the target path.
  local tmp; tmp=$(mktemp -d)
  trap "rm -rf '${tmp}'" EXIT INT TERM

  (
    git clone --quiet --filter=blob:none --sparse --depth=1 \
      "$AGENTFILES_REMOTE" "$tmp" 2>/dev/null
    git -C "$tmp" sparse-checkout set "$_repo_path" >/dev/null 2>&1
  ) || die "failed to fetch '${ref}' from ${AGENTFILES_REPO}"

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
    && ok "${ref} v${version} installed" \
    || ok "${ref} installed"
}

cmd_update() {
  local ref="${1:-}"

  if [[ -z "$ref" ]]; then
    # Update all installed directory-type components that have a VERSION.md.
    local found=false
    local sdir; sdir=$(skills_dir)

    for dir_pair in "${sdir}:skill" ".claude/hooks:hook"; do
      local base="${dir_pair%%:*}"
      local type="${dir_pair##*:}"
      [[ -d "$base" ]] || continue
      for component_dir in "${base}"/*/; do
        [[ -d "$component_dir" ]] || continue
        [[ -f "${component_dir}VERSION.md" ]] || continue
        found=true
        local name="${component_dir%/}"; name="${name##*/}"
        cmd_update "${type}/${name}"
      done
    done

    $found || print "No versioned components installed."
    return
  fi

  local _type _name _repo_path _local_dest _is_dir
  parse_ref "$ref"
  resolve_paths "$_type" "$_name"

  # File-based types have no VERSION.md — reinstall unconditionally.
  if [[ "$_is_dir" != true ]]; then
    print "note: no version tracking for ${_type}s — reinstalling"
    cmd_install "$ref"
    return
  fi

  local current; current=$(local_version "$_local_dest")
  [[ -z "$current" ]] \
    && die "${ref} is not installed (run: agentfiles install ${ref})"

  local latest; latest=$(remote_version "$_repo_path")
  [[ -z "$latest" ]] && die "could not reach remote for '${ref}'"

  if [[ "$current" == "$latest" ]]; then
    print "${ref}: already up to date (v${current})"
    return
  fi

  cmd_install "$ref"
}

cmd_list() {
  local found=false
  local sdir; sdir=$(skills_dir)

  for dir_pair in "${sdir}:skill" ".claude/hooks:hook"; do
    local base="${dir_pair%%:*}"
    local type="${dir_pair##*:}"
    [[ -d "$base" ]] || continue
    for component_dir in "${base}"/*/; do
      [[ -d "$component_dir" ]] || continue
      [[ -f "${component_dir}VERSION.md" ]] || continue
      found=true
      local name="${component_dir%/}"; name="${name##*/}"
      local version; version=$(local_version "$component_dir")
      printf "  %-8s %-20s v%s\n" "${type}" "$name" "$version"
    done
  done

  $found && return
  print "No versioned components installed."
}

cmd_status() {
  local found=false
  local sdir; sdir=$(skills_dir)

  print "Checking for updates..."
  for dir_pair in "${sdir}:skill" ".claude/hooks:hook"; do
    local base="${dir_pair%%:*}"
    local type="${dir_pair##*:}"
    [[ -d "$base" ]] || continue
    for component_dir in "${base}"/*/; do
      [[ -d "$component_dir" ]] || continue
      [[ -f "${component_dir}VERSION.md" ]] || continue
      found=true
      local name="${component_dir%/}"; name="${name##*/}"
      local repo_path; [[ "$type" == "skill" ]] && repo_path="skills/${name}" || repo_path="hooks/${name}"
      local current; current=$(local_version "$component_dir")
      local latest;  latest=$(remote_version "$repo_path" 2>/dev/null) || latest=""

      if [[ -z "$latest" ]]; then
        printf "  %-8s %-20s v%s  (remote unavailable)\n" "${type}" "$name" "$current"
      elif [[ "$current" == "$latest" ]]; then
        printf "  %-8s %-20s v%s  up to date\n" "${type}" "$name" "$current"
      else
        printf "  %-8s %-20s v%s → v%s  UPDATE AVAILABLE\n" "${type}" "$name" "$current" "$latest"
      fi
    done
  done

  $found || print "  No versioned components installed."
}

cmd_remove() {
  local ref="${1:?usage: agentfiles remove <type>/<name>}"
  local _type _name _repo_path _local_dest _is_dir
  parse_ref "$ref"
  resolve_paths "$_type" "$_name"

  [[ -e "$_local_dest" ]] || die "${ref} is not installed"
  rm -rf "$_local_dest"
  ok "${ref} removed"
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
    print "  update [<type>/<name>]   Update versioned components (default: all)"
    print "  list                     List installed versioned components"
    print "  status                   Check for available updates"
    print "  remove <type>/<name>     Remove an installed component"
    print "  force-update             Clear CLI cache and re-download"
    print ""
    print "Types:"
    print "  skill/<name>    Directory  skills/<name>/      →  <skills_dir>/<name>/"
    print "  hook/<name>     Directory  hooks/<name>/       →  .claude/hooks/<name>/"
    print "  prompt/<name>   File       prompts/<name>.md   →  .claude/commands/<name>.md"
    print "  command/<name>  File       commands/<name>.md  →  .claude/commands/<name>.md"
    print ""
    print "Directory types (skill, hook) carry VERSION.md and support version tracking."
    print "File types (prompt, command) are always reinstalled on update."
    print ""
    print "Environment:"
    print "  AGENTFILES_REPO    Source repo  (default: adjmunro/agentfiles)"
    print "  AGENTFILES_BRANCH  Branch       (default: main)"
    print ""
    print "Notes:"
    print "  For private repos, ensure git credentials are configured before installing."
    ;;
esac

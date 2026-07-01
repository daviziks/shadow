#!/usr/bin/env bash
set -eu
mkdir -p /home/coder/workspace
cat > /home/coder/workspace/.shadow-task <<META
task=${CODER_WORKSPACE_NAME:-unknown}
service_profile=${SHADOW_SERVICE_PROFILE:-none}
repo_specs=${SHADOW_REPO_SPECS:-}
META

if [ -n "${SHADOW_REPO_SPECS:-}" ] && [ ! -f /home/coder/workspace/.repos_cloned ]; then
  cd /home/coder/workspace
  for spec in ${SHADOW_REPO_SPECS}; do
    repo="${spec%%=*}"
    work=""
    case "$spec" in *=*) work="${spec#*=}"; repo="${spec%%=*}" ;; esac
    base=""
    case "$repo" in *@*) base="${repo#*@}"; repo="${repo%@*}" ;; esac
    name="${repo##*/}"
    url="https://github.com/$repo.git"
    if [ -n "$base" ]; then
      git clone --branch "$base" "$url" "$name"
    else
      git clone "$url" "$name"
    fi
    if [ -n "$work" ] && [ -d "$name/.git" ]; then
      git -C "$name" switch -c "$work" || git -C "$name" switch "$work"
    fi
  done
  touch /home/coder/workspace/.repos_cloned
fi

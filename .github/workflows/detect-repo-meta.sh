#!/usr/bin/env bash
set -euo pipefail

# This script detects OWNER, REPO, and BRANCH for use in CI
# Outputs in "key=value" form suitable for:
#   source <(.github/workflows/detect-repo-meta.sh)
# or direct evaluation:
#   eval "$(.github/workflows/detect-repo-meta.sh)"

EVENT_NAME="${GITHUB_EVENT_NAME:-}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
GITHUB_REF="${GITHUB_REF:-}"
GITHUB_EVENT_PATH="${GITHUB_EVENT_PATH:-}"

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "OWNER="
  echo "REPO="
else
  OWNER="${GITHUB_REPOSITORY%%/*}"
  REPO="${GITHUB_REPOSITORY##*/}"
  echo "OWNER=${OWNER}"
  echo "REPO=${REPO}"
fi

DEFAULT_BRANCH=""
if [[ -n "$GITHUB_EVENT_PATH" && -f "$GITHUB_EVENT_PATH" ]]; then
  DEFAULT_BRANCH="$(jq -r '.repository.default_branch // empty' "$GITHUB_EVENT_PATH" || true)"
fi

BRANCH=""

if [[ -n "$DEFAULT_BRANCH" ]]; then
  BRANCH="$DEFAULT_BRANCH"
else
  if [[ "$EVENT_NAME" == "push" ]]; then
    if [[ -n "$GITHUB_REF" ]]; then
      BRANCH="${GITHUB_REF#refs/heads/}"
    fi
  elif [[ "$EVENT_NAME" == "pull_request" && -n "$GITHUB_EVENT_PATH" && -f "$GITHUB_EVENT_PATH" ]]; then
    BRANCH="$(jq -r '.pull_request.head.ref // empty' "$GITHUB_EVENT_PATH" || true)"
  fi
fi

if [[ -z "$BRANCH" ]]; then
  BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
fi

echo "BRANCH=${BRANCH}"
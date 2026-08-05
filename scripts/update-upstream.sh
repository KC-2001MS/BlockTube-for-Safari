#!/bin/bash
# Sync "BlockTube Extension/Resources" with the latest upstream BlockTube release.
#
# Update detection is content-based: every run downloads the latest release
# asset and compares each file byte-for-byte against the working tree.
# Release tags and version strings are never used to decide whether files
# are up to date — upstream tags and manifest versions are not guaranteed
# to agree with each other or with the packaged sources.
#
# Safari-owned files (see EXCLUDED_PATHS) are never overwritten. The upstream
# manifest.json is instead mirrored to upstream/manifest.json so changes to it
# surface as a reviewable diff.
#
# Usage:
#   scripts/update-upstream.sh          # strict: any failure is fatal (CI)
#   scripts/update-upstream.sh --build  # lenient: failures skip the sync
#                                       #   (Xcode build phase; offline builds
#                                       #    must still succeed)
#
# Environment:
#   GITHUB_TOKEN         optional, raises the GitHub API rate limit
#   SKIP_UPSTREAM_SYNC=1 skip the sync entirely
set -euo pipefail

UPSTREAM_REPO="amitbl/blocktube"
ASSET_REGEX='^blocktube_chrome_.*\.zip$'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESOURCES_DIR="$REPO_ROOT/BlockTube Extension/Resources"
MANIFEST_REF="$REPO_ROOT/upstream/manifest.json"

# Paths relative to the release zip root / Resources that Safari owns.
# These are never copied into Resources.
EXCLUDED_PATHS=("manifest.json")

BUILD_MODE=0
if [[ "${1:-}" == "--build" ]]; then
  BUILD_MODE=1
fi

if [[ "${SKIP_UPSTREAM_SYNC:-0}" == "1" ]]; then
  echo "note: SKIP_UPSTREAM_SYNC=1 — upstream sync skipped"
  exit 0
fi

# On CI build machines (Xcode Cloud sets CI) the checked-in sources must be
# built as-is; only the dedicated sync workflow may modify them.
if [[ "$BUILD_MODE" == "1" && -n "${CI:-}" ]]; then
  echo "note: CI build — upstream sync skipped"
  exit 0
fi

fail() {
  if [[ "$BUILD_MODE" == "1" ]]; then
    echo "warning: BlockTube upstream sync skipped: $1"
    exit 0
  fi
  echo "error: $1" >&2
  exit 1
}

is_excluded() {
  local rel="$1" ex
  for ex in "${EXCLUDED_PATHS[@]}"; do
    if [[ "$rel" == "$ex" || "$rel" == "$ex"/* ]]; then
      return 0
    fi
  done
  return 1
}

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

CURL_AUTH=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  CURL_AUTH=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

RELEASE_JSON="$WORK_DIR/release.json"
curl -fsSL --connect-timeout 10 --max-time 60 ${CURL_AUTH[@]+"${CURL_AUTH[@]}"} \
  "https://api.github.com/repos/$UPSTREAM_REPO/releases/latest" \
  -o "$RELEASE_JSON" || fail "could not reach the GitHub API"

TAG="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["tag_name"])' "$RELEASE_JSON")" \
  || fail "could not parse the release metadata"
ASSET_URL="$(python3 -c '
import json, re, sys
release = json.load(open(sys.argv[1]))
pattern = re.compile(sys.argv[2])
for asset in release.get("assets", []):
    if pattern.match(asset["name"]):
        print(asset["browser_download_url"])
        break
' "$RELEASE_JSON" "$ASSET_REGEX")"
if [[ -z "$ASSET_URL" ]]; then
  fail "release $TAG has no asset matching $ASSET_REGEX"
fi

echo "Latest upstream release: $TAG"
echo "Asset: $ASSET_URL"

curl -fsSL --connect-timeout 10 --max-time 300 -o "$WORK_DIR/upstream.zip" "$ASSET_URL" \
  || fail "could not download the release asset"
EXTRACT_DIR="$WORK_DIR/extracted"
unzip -q "$WORK_DIR/upstream.zip" -d "$EXTRACT_DIR" || fail "could not extract the release asset"
if [[ ! -f "$EXTRACT_DIR/manifest.json" ]]; then
  fail "unexpected release layout: manifest.json not found at the zip root"
fi

CHANGED_COUNT=0
while IFS= read -r -d '' file; do
  rel="${file#"$EXTRACT_DIR"/}"
  if is_excluded "$rel"; then
    continue
  fi
  dest="$RESOURCES_DIR/$rel"
  if [[ ! -f "$dest" ]] || ! cmp -s "$file" "$dest"; then
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
    CHANGED_COUNT=$((CHANGED_COUNT + 1))
    echo "updated: $rel"
  fi
done < <(find "$EXTRACT_DIR" -type f -print0)

# Files that exist locally but not in the release may have been removed
# upstream — or may be Safari-only additions. Never delete automatically.
while IFS= read -r -d '' file; do
  rel="${file#"$RESOURCES_DIR"/}"
  if [[ "$(basename "$rel")" == ".DS_Store" ]] || is_excluded "$rel"; then
    continue
  fi
  if [[ ! -f "$EXTRACT_DIR/$rel" ]]; then
    echo "warning: $rel exists locally but not in release $TAG — remove it manually if it was dropped upstream"
  fi
done < <(find "$RESOURCES_DIR" -type f -print0)

# Mirror the upstream manifest to a reference copy outside Resources so
# upstream manifest changes show up as a diff to merge into the Safari
# manifest by hand.
MANIFEST_CHANGED=false
if [[ ! -f "$MANIFEST_REF" ]] || ! cmp -s "$EXTRACT_DIR/manifest.json" "$MANIFEST_REF"; then
  mkdir -p "$(dirname "$MANIFEST_REF")"
  cp "$EXTRACT_DIR/manifest.json" "$MANIFEST_REF"
  MANIFEST_CHANGED=true
  echo "warning: upstream manifest.json changed — review upstream/manifest.json and apply any needed changes to 'BlockTube Extension/Resources/manifest.json' manually"
fi

if [[ "$CHANGED_COUNT" == "0" ]]; then
  echo "Resources already match release $TAG — nothing to do"
else
  echo "Synced $CHANGED_COUNT file(s) from release $TAG"
fi

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "tag=$TAG"
    if [[ "$CHANGED_COUNT" != "0" ]]; then echo "changed=true"; else echo "changed=false"; fi
    echo "manifest_changed=$MANIFEST_CHANGED"
  } >> "$GITHUB_OUTPUT"
fi

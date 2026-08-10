#!/usr/bin/env bash
#
# Deploy Twin Squares to Cloudflare Pages.
#
#   ./deploy.sh                     deploy to production (branch: main)
#   ./deploy.sh --branch preview    deploy a preview build
#
# Any extra arguments are passed straight through to `wrangler pages deploy`.
#
# The game lives in a single file: mirror-twins.html. This script copies it into
# public/index.html before every deploy, so public/ is disposable build output —
# always edit mirror-twins.html, never the copy.

set -euo pipefail

PROJECT_NAME="twin-squares"
SOURCE="mirror-twins.html"
OUT_DIR="public"
BRANCH="main"

# Run from the project root regardless of where the script was invoked.
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -f "$SOURCE" ]]; then
  echo "error: $SOURCE not found in $(pwd)" >&2
  exit 1
fi

echo "==> Syncing $SOURCE -> $OUT_DIR/index.html"
mkdir -p "$OUT_DIR"
cp "$SOURCE" "$OUT_DIR/index.html"

echo "==> Deploying to Cloudflare Pages project '$PROJECT_NAME'"
npx --yes wrangler@latest pages deploy "$OUT_DIR" \
  --project-name "$PROJECT_NAME" \
  --branch "$BRANCH" \
  --commit-dirty=true \
  "$@"

echo "==> Live at https://${PROJECT_NAME}.pages.dev"

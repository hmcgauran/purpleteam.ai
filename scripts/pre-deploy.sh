#!/usr/bin/env bash
# pre-deploy smoke test.
# Runs after a clean build and confirms:
#   - 0 errors in build output
#   - 11 essay URLs present
#   - feed.xml and sitemap.xml exist
#   - robots.txt exists
#   - 404 page exists
#   - canonical URLs are absolute (no //)
#   - og:type=article on essay pages
#
# Exit non-zero on any failure so it can gate a git push or Netlify hook.

set -e

cd "$(dirname "$0")/.."

echo "→ Cleaning previous build"
rm -rf _site

echo "→ Building"
if ! npx @11ty/eleventy 2>&1 | tee /tmp/eleventy.log; then
  echo "✘ Build failed"
  exit 1
fi

if grep -q "Fatal Error" /tmp/eleventy.log; then
  echo "✘ Eleventy reported a fatal error"
  exit 1
fi

expected_essays=(
  "essays/purple-team-threat-model-wrong/"
  "essays/detection-engineering-real-environment/"
  "essays/red-team-tests-designed-to-fail/"
  "essays/purple-teaming-that-actually-works/"
  "essays/scoping-a-red-team-engagement/"
  "essays/purple-teaming-ot/"
  "essays/seven-pointless-ot-pen-test-findings/"
  "essays/insider-threat-problem/"
  "essays/living-off-the-land/"
  "essays/purple-team-report-that-gets-read/"
  "essays/adversary-emulation-vs-penetration-testing/"
)

echo "→ Checking 11 essay URLs"
for url in "${expected_essays[@]}"; do
  if [ ! -f "_site/${url}index.html" ]; then
    echo "✘ Missing: /${url}"
    exit 1
  fi
done

echo "→ Checking required surfaces"
for path in "feed.xml" "sitemap.xml" "robots.txt" "404.html" "index.html" "about/index.html" "tags/index.html"; do
  if [ ! -f "_site/${path}" ]; then
    echo "✘ Missing: /${path}"
    exit 1
  fi
done

echo "→ Checking canonical URLs are clean (no double-slash)"
if grep -rq 'https://purpleteam.ai//' _site/ 2>/dev/null; then
  echo "✘ Found double-slash in URLs:"
  grep -r 'https://purpleteam.ai//' _site/ | head -3
  exit 1
fi

echo "→ Checking essay pages have og:type=article"
for url in "${expected_essays[@]}"; do
  if ! grep -q 'og:type" content="article"' "_site/${url}index.html"; then
    echo "✘ Missing og:type=article on /${url}"
    exit 1
  fi
done

echo "→ Checking JSON-LD Article schema on essay pages"
for url in "${expected_essays[@]}"; do
  if ! grep -q '"@type": "Article"' "_site/${url}index.html"; then
    echo "✘ Missing JSON-LD Article on /${url}"
    exit 1
  fi
done

essay_count=${#expected_essays[@]}
echo "→ All checks passed. ${essay_count} essays verified."

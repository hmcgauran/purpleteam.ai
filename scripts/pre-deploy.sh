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
  "essays/purple-teaming-at-scale/"
  "essays/building-a-detection-baseline/"
  "essays/what-a-good-detection-engineer-actually-does-all-day/"
  "essays/what-i-look-for-in-a-red-team-report/"
  "essays/the-red-team-engagement-that-changed-how-i-think-about-risk/"
  "essays/why-most-threat-intelligence-programmes-are-not-worth-the-money/"
  "essays/the-six-month-build-what-a-real-detection-engineering-programme-looks-like/"
  "essays/tabletop-exercises-that-actually-prepare-you-for-an-incident/"
  "essays/how-to-run-a-purple-team-exercise-when-nobody-has-done-one-before/"
  "essays/how-to-hire-a-detection-engineer-when-you-have-never-hired-one-before/"
  "essays/what-a-ciso-actually-does-on-a-tuesday-afternoon/"
  "essays/the-detection-rule-that-changed-how-i-think-about-fidelity/"
  "essays/how-to-build-an-insider-risk-programme-that-actually-catches-the-bad-cases/"
  "essays/how-to-threat-model-a-system-you-have-never-seen-before/"
  "essays/what-a-good-ics-detection-looks-like-in-practice/"
  "essays/ics-tabletop-exercises-lessons-dont-transfer/"
  "essays/purple-teaming-your-identity-environment/"
  "essays/containing-a-credential-driven-intrusion/"
  "essays/purple-teaming-a-pci-environment/"
  "essays/quarterly-identity-purple-team-cadence/"
  "essays/the-joins-nobody-owns/"
)

echo "→ Checking ${#expected_essays[@]} essay URLs"
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

echo "→ Checking internal links resolve to a built page"
python3 <<'PY'
import os, re, sys

ROOT = "_site"

# Every built directory with an index.html, as a site-root URL.
pages = set()
for dirpath, _dirnames, filenames in os.walk(ROOT):
    if "index.html" in filenames:
        rel = os.path.relpath(dirpath, ROOT).replace("\\", "/")
        pages.add("/" if rel == "." else "/" + rel + "/")

# Only check paths that are rendered as directories. Assets and feeds
# (/feed.xml, /robots.txt, /assets/...) are files, not directory pages.
def in_scope(url):
    return url == "/" or url.startswith(("/essays/", "/tags/", "/about/"))

href_re = re.compile(r'href="(/[^"#?]*)"')
broken = []
for dirpath, _dirnames, filenames in os.walk(ROOT):
    for fn in filenames:
        if not fn.endswith(".html"):
            continue
        path = os.path.join(dirpath, fn)
        with open(path, encoding="utf-8", errors="ignore") as fh:
            html = fh.read()
        for link in href_re.findall(html):
            if not in_scope(link):
                continue
            if link not in pages:
                broken.append((os.path.relpath(path, ROOT), link))

if broken:
    print("✘ Broken internal links:")
    for src, link in sorted(set(broken)):
        print("   %s -> %s" % (src, link))
    sys.exit(1)
print("   all internal links resolve")
PY

essay_count=${#expected_essays[@]}
echo "→ All checks passed. ${essay_count} essays verified."

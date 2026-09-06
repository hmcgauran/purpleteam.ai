#!/usr/bin/env bash
# scripts/weekly-publish.sh
#
# Weekly publish gate for purpleteam.ai.
#
# Cron schedule: 0 9 * * 4 (Thursday 09:00 local).
#
# What it does:
#   1. Read PUBLISH-SCHEDULE.json. Find the earliest approved post whose
#      publishDate is strictly after today (the "next-up" post).
#   2. Bump its publishDate to today (both PUBLISH-SCHEDULE.json and the
#      post's frontmatter `date:` field). Add `post` tag if missing.
#   3. If there's no next-up post (queue empty), mint a new stub for the
#      following Thursday and queue it. Stub gets `TBD — Essay #N` title
#      and a placeholder body.
#   4. Run pre-deploy.sh. If it fails, abort (don't commit/push).
#   5. git commit + git push origin main.
#   6. Best-effort verify the live URL responds 200; warn if Netlify hook
#      is slow.
#
# Cron env: HOME, USER, optionally TODAY (for testing) and PURPLETEAM_HOME.

set -euo pipefail

PROJ="${PURPLETEAM_HOME:-/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai}"
cd "$PROJ" || { echo "FAIL: could not cd to $PROJ"; exit 2; }

TODAY="${TODAY:-$(date +%Y-%m-%d)}"
NEXT_THU="$(python3 -c "import datetime; t=datetime.date.today(); d=t+datetime.timedelta((3-t.weekday())%7 or 7); print(d.isoformat())" 2>/dev/null || date -v+7d +%Y-%m-%d 2>/dev/null || echo "$TODAY")"

echo "Today: $TODAY"
echo "Next Thursday: $NEXT_THU"
echo "Project: $PROJ"

# -----------------------------------------------------------------
# Step 1: inspect + bump the next-up post's publishDate
# -----------------------------------------------------------------
WORK="$(mktemp -t pt-publish-XXXXXX)"
trap 'rm -f "$WORK"' EXIT

export PROJ TODAY NEXT_THU
node -e '
const fs = require("fs");
const path = require("path");
const schedPath = path.join(process.env.PROJ, "strategy", "PUBLISH-SCHEDULE.json");
const today = process.env.TODAY;
const nextThu = process.env.NEXT_THU;
const sched = JSON.parse(fs.readFileSync(schedPath, "utf8"));
const candidates = sched.posts
  .filter(p => p.approved && p.publishDate >= today)
  .sort((a, b) => a.publishDate.localeCompare(b.publishDate));
if (!candidates.length) {
  const nextNum = Math.max(...sched.posts.map(p => p.number)) + 1;
  const stub = {
    id: "post-" + nextNum,
    number: nextNum,
    title: "TBD — Essay #" + nextNum,
    file: "tbd-essay-" + nextNum + ".md",
    publishDate: nextThu,
    approved: true,
    tags: ["post"],
  };
  sched.posts.push(stub);
  fs.writeFileSync(schedPath, JSON.stringify(sched, null, 2) + "\n");
  const slug = "tbd-essay-" + nextNum;
  const body =
    "---\n" +
    "title: \"TBD — Essay #" + nextNum + "\"\n" +
    "slug: \"" + slug + "\"\n" +
    "date: " + nextThu + "\n" +
    "tags:\n" +
    "  - post\n" +
    "author: Hugh McGauran\n" +
    "excerpt: \"Stub — body to be written before " + nextThu + ".\"\n" +
    "layout: layouts/post.njk\n" +
    "permalink: /essays/" + slug + "/\n" +
    "---\n\n" +
    "*Placeholder. Body to be written before " + nextThu + ".*\n";
  fs.writeFileSync(path.join(process.env.PROJ, "content", "posts", stub.file), body);
  const pdPath = path.join(process.env.PROJ, "scripts", "pre-deploy.sh");
  let pd = fs.readFileSync(pdPath, "utf8");
  const newEntry = "  \"essays/" + slug + "/\"";
  if (!pd.includes(newEntry)) {
    pd = pd.replace(
      /\n(\s*)\)\n\necho "→ Checking \$\{#expected_essays\[@\]\} essay URLs"/,
      "\n" + newEntry + "\n$1)\n\necho \"→ Checking ${#expected_essays[@]} essay URLs\""
    );
    fs.writeFileSync(pdPath, pd);
  }
  process.stdout.write(["MINT_STUB", stub.id, stub.publishDate, stub.file].join(" ") + "\n");
  process.exit(0);
}
const p = candidates[0];
// Pre-check: if the candidate body is still placeholder, do NOT bump.
const postPath = path.join(process.env.PROJ, "content", "posts", p.file);
const src = fs.readFileSync(postPath, "utf8");
const fmStart = src.indexOf("---") + 3;
const fmEnd = src.indexOf("\n---", fmStart);
const body = fmEnd >= 0 ? src.slice(fmEnd + 4) : "";
const bodyNorm = body.replace(/\s+/g, " ").trim().toLowerCase();
if (bodyNorm.startsWith("*placeholder. body to be written before")) {
  process.stdout.write(["STUB_PENDING", p.id, p.publishDate, p.file].join(" ") + "\n");
  process.exit(0);
}
p.publishDate = today;
fs.writeFileSync(schedPath, JSON.stringify(sched, null, 2) + "\n");
process.stdout.write(["BUMPED", p.id, p.publishDate, p.file].join(" ") + "\n");
' > "$WORK"

ACTION="$(awk '{print $1}' "$WORK")"
TARGET_ID="$(awk '{print $2}' "$WORK")"
TARGET_DATE="$(awk '{print $3}' "$WORK")"
TARGET_FILE="$(awk '{print $4}' "$WORK")"

echo "Action: $ACTION | $TARGET_ID | $TARGET_DATE | $TARGET_FILE"

if [ "$ACTION" = "MINT_STUB" ]; then
  echo "Minted stub post for $NEXT_THU — body needs to be written by then."
  exit 0
fi

if [ "$ACTION" = "STUB_PENDING" ]; then
  echo "STUB_PENDING: $TARGET_ID ($TARGET_FILE) still has placeholder body."
  echo "Schedule left untouched. ACTION REQUIRED: write the body before $TARGET_DATE."
  exit 0
fi

if [ "$ACTION" != "BUMPED" ] || [ -z "$TARGET_FILE" ]; then
  echo "Nothing to publish."
  exit 0
fi

POST_PATH="$PROJ/content/posts/$TARGET_FILE"
if [ ! -f "$POST_PATH" ]; then
  echo "FAIL: post file missing: $POST_PATH"
  exit 3
fi

python3 <<PY
import re
path = '$POST_PATH'
today = '$TODAY'
src = open(path).read()
src2 = re.sub(r'^date:\s*\d{4}-\d{2}-\d{2}', 'date: ' + today, src, count=1, flags=re.MULTILINE)
if not re.search(r'^\s*-\s*post\s*$', src2, flags=re.MULTILINE):
    src2 = re.sub(r'^(tags:\s*\n((?:\s*-\s*.+\n)+))', r'\1  - post\n', src2, count=1, flags=re.MULTILINE)
open(path, 'w').write(src2)
PY

# -----------------------------------------------------------------
# Step 2: build
# -----------------------------------------------------------------
echo "Running pre-deploy.sh"
if ! bash scripts/pre-deploy.sh 2>&1 | tail -20; then
  echo "FAIL: pre-deploy failed — NOT committing."
  exit 4
fi

# -----------------------------------------------------------------
# Step 3: commit + push
# -----------------------------------------------------------------
git add strategy/PUBLISH-SCHEDULE.json scripts/pre-deploy.sh content/posts/ || true

if git diff --cached --quiet; then
  echo "No staged changes — nothing to commit."
  exit 0
fi

git commit -m "weekly publish: bump $TARGET_ID to $TODAY" >/dev/null
git push origin main 2>&1 | tail -3

# -----------------------------------------------------------------
# Step 4: best-effort live URL verification (max 90s)
# -----------------------------------------------------------------
LIVE_URL="https://purpleteam.ai/essays/$(basename "$TARGET_FILE" .md)/"
echo "Pushed. Verifying $LIVE_URL (up to 90s)..."
for i in 1 2 3 4 5 6; do
  HTTP=$(curl -sS --max-time 20 -o /dev/null -w '%{http_code}' "$LIVE_URL" 2>/dev/null || echo "000")
  if [ "$HTTP" = "200" ]; then
    echo "Live URL OK: $LIVE_URL"
    exit 0
  fi
  sleep 15
done
echo "WARN: live URL still $HTTP after 90s."
echo "Manual: Netlify dashboard -> Trigger deploy -> Clear cache and deploy"
exit 0
#!/usr/bin/env bash
# scripts/weekly-publish.sh
#
# Weekly publish gate for purpleteam.ai.
#
# Cron schedule: 0 9 * * 4 (Thursday 09:00).
#
# What it does:
#   1. Read PUBLISH-SCHEDULE.json and find the earliest approved post whose
#      publishDate is today or later (the "next-up" post).
#   2. Act on it:
#        BUMPED       - due today: bump publishDate + frontmatter date to
#                       today, build, commit, push, verify the live URL.
#        SCHEDULED    - dated in the future with a real body: commit it as a
#                       preview (body on disk, built, reviewable) but do NOT
#                       publish it early. It publishes on its own date.
#        STUB_PENDING - body is still the auto-generated placeholder.
#        MINT_STUB    - queue exhausted: mint a stub for the following
#                       Thursday so the next week is never skipped.
#   3. After a successful publish, mint the next slot. Publishing consumes the
#      queue, so without this the queue drains, the monitor reports MATCH
#      forever, and weekly slots get skipped (the deadlock that skipped
#      2026-11-19).
#
# Contract with the cron agent: exactly one "Action: ACTION | id | date | file"
# line on stdout. Helpers write to files, never to stdout.
#
# Cron env: HOME, USER, optionally TODAY (for testing) and PURPLETEAM_HOME.

set -euo pipefail

PROJ="${PURPLETEAM_HOME:-/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai}"
cd "$PROJ" || { echo "FAIL: could not cd to $PROJ"; exit 2; }

TODAY="${TODAY:-$(date +%Y-%m-%d)}"
export TODAY
# The next slot is the Thursday strictly after TODAY. Derive it from TODAY, not
# from the wall clock, so a stub minted on publish day lands on the following
# Thursday rather than colliding with the post being published.
NEXT_THU="$(python3 -c "
import datetime, os
t = datetime.date.fromisoformat(os.environ.get('TODAY') or datetime.date.today().isoformat())
d = t + datetime.timedelta((3 - t.weekday()) % 7 or 7)
print(d.isoformat())
" 2>/dev/null || date -v+7d +%Y-%m-%d 2>/dev/null || echo "$TODAY")"

echo "Today: $TODAY"
echo "Next Thursday: $NEXT_THU"
echo "Project: $PROJ"

WORK="$(mktemp -t pt-publish-XXXXXX)"
NEXTFILE="$(mktemp -t pt-nextstub-XXXXXX)"
PREVIEWFILE="$(mktemp -t pt-preview-XXXXXX)"
trap 'rm -f "$WORK" "$NEXTFILE" "$PREVIEWFILE"' EXIT

export PROJ TODAY NEXT_THU NEXTFILE PREVIEWFILE

# ---------------------------------------------------------------------------
# Step 1: decide the action. Exactly one line on stdout.
# ---------------------------------------------------------------------------
node -e '
const fs = require("fs");
const path = require("path");
const proj = process.env.PROJ;
const today = process.env.TODAY;
const nextThu = process.env.NEXT_THU;
const schedPath = path.join(proj, "strategy", "PUBLISH-SCHEDULE.json");
const sched = JSON.parse(fs.readFileSync(schedPath, "utf8"));

function save() {
  fs.writeFileSync(schedPath, JSON.stringify(sched, null, 2) + "\n");
}

const candidates = sched.posts
  .filter(function (p) { return p.approved && p.publishDate >= today; })
  .sort(function (a, b) { return a.publishDate.localeCompare(b.publishDate); });

if (!candidates.length) {
  // Queue exhausted. The stub is minted by mint_next_slot below; report what
  // it will be so the agent knows which body to write.
  const n = Math.max.apply(null, sched.posts.map(function (p) { return p.number; })) + 1;
  process.stdout.write(["MINT_STUB", "post-" + n, nextThu, "tbd-essay-" + n + ".md"].join(" ") + "\n");
  process.exit(0);
}

const p = candidates[0];
const postPath = path.join(proj, "content", "posts", p.file);
let body = "";
let missing = false;
try {
  const src = fs.readFileSync(postPath, "utf8");
  const fmStart = src.indexOf("---") + 3;
  const fmEnd = src.indexOf("\n---", fmStart);
  body = fmEnd >= 0 ? src.slice(fmEnd + 4) : "";
} catch (e) {
  body = "";
  missing = true;
}
const bodyNorm = body.replace(/\s+/g, " ").trim().toLowerCase();
if (missing || bodyNorm.startsWith("*placeholder. body to be written before")) {
  process.stdout.write(["STUB_PENDING", p.id, p.publishDate, p.file].join(" ") + "\n");
  process.exit(0);
}

// Seeded ahead of its slot. Bumping it here would publish it a week early and
// collapse the cadence, so leave the schedule alone. It publishes on its own
// date.
if (p.publishDate > today) {
  process.stdout.write(["SCHEDULED", p.id, p.publishDate, p.file].join(" ") + "\n");
  process.exit(0);
}

p.publishDate = today;
save();
process.stdout.write(["BUMPED", p.id, p.publishDate, p.file].join(" ") + "\n");
' > "$WORK"

# Slots queued for a future Thursday whose body still needs writing. The agent
# writes those during the preview week, so it needs to be told which ones.
node -e '
const fs = require("fs");
const path = require("path");
const proj = process.env.PROJ;
const today = process.env.TODAY;
const schedPath = path.join(proj, "strategy", "PUBLISH-SCHEDULE.json");
const sched = JSON.parse(fs.readFileSync(schedPath, "utf8"));
const pending = [];
for (const p of sched.posts) {
  if (!p.approved || p.publishDate <= today) continue;
  let body = "";
  try {
    const src = fs.readFileSync(path.join(proj, "content", "posts", p.file), "utf8");
    const fmStart = src.indexOf("---") + 3;
    const fmEnd = src.indexOf("\n---", fmStart);
    body = fmEnd >= 0 ? src.slice(fmEnd + 4) : "";
  } catch (e) {
    body = "";
  }
  const norm = body.replace(/\s+/g, " ").trim().toLowerCase();
  if (!norm || norm.startsWith("*placeholder. body to be written before")) {
    pending.push(["PENDING_PREVIEW", p.id, p.publishDate, p.file].join(" "));
  }
}
fs.writeFileSync(process.env.PREVIEWFILE, pending.join("\n"));
' >/dev/null

ACTION="$(awk '{print $1}' "$WORK")"
TARGET_ID="$(awk '{print $2}' "$WORK")"
TARGET_DATE="$(awk '{print $3}' "$WORK")"
TARGET_FILE="$(awk '{print $4}' "$WORK")"

echo "Action: $ACTION | $TARGET_ID | $TARGET_DATE | $TARGET_FILE"

if [ -s "$PREVIEWFILE" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] && echo "$line"
  done < "$PREVIEWFILE"
fi

# ---------------------------------------------------------------------------
# Step 2: mint the next slot.
#
# A stub is a placeholder and is deliberately NOT committed: the agent writes
# the real body during the following week and commits it then. Committing a
# placeholder would publish a live "TBD" page.
# ---------------------------------------------------------------------------
mint_next_slot() {
  node -e '
const fs = require("fs");
const path = require("path");
const proj = process.env.PROJ;
const today = process.env.TODAY;
const nextThu = process.env.NEXT_THU;
const schedPath = path.join(proj, "strategy", "PUBLISH-SCHEDULE.json");
const sched = JSON.parse(fs.readFileSync(schedPath, "utf8"));

// A future slot already exists - nothing to mint.
if (sched.posts.some(function (p) { return p.approved && p.publishDate > today; })) {
  process.exit(0);
}

const n = Math.max.apply(null, sched.posts.map(function (p) { return p.number; })) + 1;
const slug = "tbd-essay-" + n;
const stub = {
  id: "post-" + n,
  number: n,
  title: "TBD — Essay #" + n,
  file: "tbd-essay-" + n + ".md",
  publishDate: nextThu,
  approved: true,
  tags: ["post"],
};
sched.posts.push(stub);
fs.writeFileSync(schedPath, JSON.stringify(sched, null, 2) + "\n");

const body =
  "---\n" +
  "title: \"TBD — Essay #" + n + "\"\n" +
  "slug: \"" + slug + "\"\n" +
  "date: " + nextThu + "\n" +
  "tags:\n" +
  "  - post\n" +
  "author: Hugh Mc Gauran\n" +
  "excerpt: \"Stub — body to be written before " + nextThu + ".\"\n" +
  "layout: layouts/post.njk\n" +
  "permalink: /essays/" + slug + "/\n" +
  "---\n\n" +
  "*Placeholder. Body to be written before " + nextThu + ". *\n";
fs.writeFileSync(path.join(proj, "content", "posts", stub.file), body);
fs.writeFileSync(process.env.NEXTFILE, ["NEXT_STUB", stub.id, stub.publishDate, stub.file].join(" "));
'
}

# ---------------------------------------------------------------------------
# Step 3: keep pre-deploy.sh's expected-URL list in step with the post.
#
# The published slug lives in the post's frontmatter, so the list entry must
# use the real slug. Any placeholder-slug entry for the same file is dropped.
# ---------------------------------------------------------------------------
sync_expected_url() {
  POST_FILE="$1" node -e '
const fs = require("fs");
const path = require("path");
const proj = process.env.PROJ;
const file = process.env.POST_FILE;
let src = "";
try {
  src = fs.readFileSync(path.join(proj, "content", "posts", file), "utf8");
} catch (e) {
  process.exit(0);
}
const m = src.match(/^permalink:\s*\/essays\/([^\/]+)\//m);
if (!m) process.exit(0);
const slug = m[1];
const stubSlug = file.replace(/\.md$/, "");
const pdPath = path.join(proj, "scripts", "pre-deploy.sh");
let pd = fs.readFileSync(pdPath, "utf8");

// Drop the placeholder-slug entry for this file, if present.
pd = pd.split("\n").filter(function (line) {
  return line.trim() !== "\"essays/" + stubSlug + "/\"";
}).join("\n");

if (pd.indexOf("\"essays/" + slug + "/\"") === -1) {
  pd = pd.replace(
    /\n(\s*)\)\n(\necho "→ Checking)/,
    "\n  \"essays/" + slug + "/\"\n$1)\n$2"
  );
}
fs.writeFileSync(pdPath, pd);
'
}

# ---------------------------------------------------------------------------
# Step 4: build, commit, push.
# ---------------------------------------------------------------------------
build_and_gate() {
  echo "Running pre-deploy.sh"
  if ! bash scripts/pre-deploy.sh 2>&1 | tail -20; then
    echo "FAIL: pre-deploy failed — NOT committing."
    exit 4
  fi
}

# Stage the schedule, the URL list, and every post whose body is real. A
# freshly minted placeholder stub must never be staged, or it would be
# published as a live "TBD" page. A real body for a future slot IS staged:
# that is the preview commit, and it must not be lost.
# Keep the expected-URL list in step with every essay that has a real body,
# not just the one being published. A preview body committed on the same tick
# must reach the list too, or the next build gate misses it. Placeholder stubs
# are skipped: their slug is a placeholder, not a published URL.
sync_all_expected_urls() {
  for f in content/posts/*.md; do
    [ -f "$f" ] || continue
    if grep -qi '^\*placeholder\. body to be written before' "$f"; then
      continue
    fi
    sync_expected_url "$(basename "$f")"
  done
}

stage_target() {
  git add strategy/PUBLISH-SCHEDULE.json scripts/pre-deploy.sh || true
  for f in content/posts/*.md; do
    [ -f "$f" ] || continue
    if grep -qi '^\*placeholder\. body to be written before' "$f"; then
      continue
    fi
    git add "$f" || true
  done
}

case "$ACTION" in
  MINT_STUB)
    mint_next_slot
    # Commit the schedule entry for the new slot so it survives a clean
    # checkout. The placeholder body is deliberately left uncommitted: a
    # committed stub would publish a live "TBD" page.
    git add strategy/PUBLISH-SCHEDULE.json
    if ! git diff --cached --quiet; then
      git commit -m "schedule: queue post for $NEXT_THU" >/dev/null
      git push origin main 2>&1 | tail -3
    fi
    echo "Minted stub post for $NEXT_THU — body needs to be written by then."
    exit 0
    ;;

  SCHEDULED)
    # A real body for a future date. Commit it as a preview so it is on disk,
    # built and reviewable, but leave the date alone: it publishes on its own
    # date, and bumping it here would publish a week early.
    sync_all_expected_urls
    build_and_gate
    stage_target
    if git diff --cached --quiet; then
      echo "SCHEDULED: $TARGET_ID ($TARGET_FILE) is queued for $TARGET_DATE — already committed as a preview."
    else
      git commit -m "preview: $TARGET_ID body for $TARGET_DATE" >/dev/null
      git push origin main 2>&1 | tail -3
      echo "SCHEDULED: $TARGET_ID ($TARGET_FILE) is queued for $TARGET_DATE — committed as a preview, not published early."
    fi
    exit 0
    ;;

  STUB_PENDING)
    echo "STUB_PENDING: $TARGET_ID ($TARGET_FILE) still has placeholder body."
    echo "Schedule left untouched. ACTION REQUIRED: write the body before $TARGET_DATE."
    exit 0
    ;;

  BUMPED)
    ;;

  *)
    echo "Nothing to publish."
    exit 0
    ;;
esac

if [ -z "$TARGET_FILE" ]; then
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

sync_all_expected_urls
build_and_gate
stage_target

if git diff --cached --quiet; then
  # The publish-day bump is a no-op when the schedule and the post's frontmatter
  # already carry today's date — which is what happens when the body landed on
  # an earlier preview-week commit. The deploy still has to run so the build's
  # date gate promotes the post on the homepage, so push an empty commit to
  # trigger it rather than skipping the push.
  git commit --allow-empty -m "weekly publish: publish $TARGET_ID to $TODAY" >/dev/null
else
  git commit -m "weekly publish: bump $TARGET_ID to $TODAY" >/dev/null
fi
git push origin main 2>&1 | tail -3

# ---------------------------------------------------------------------------
# Step 5: keep the queue alive.
#
# Publishing consumes the queue, so mint the next slot now. The stub is a
# placeholder and stays uncommitted; the agent writes its body during the
# following week.
# ---------------------------------------------------------------------------
mint_next_slot
NEXT_LINE="$(cat "$NEXTFILE" 2>/dev/null || true)"
if [ -n "$NEXT_LINE" ]; then
  # Commit the new slot's schedule entry so the queue survives a clean
  # checkout. The placeholder body stays uncommitted.
  git add strategy/PUBLISH-SCHEDULE.json
  if ! git diff --cached --quiet; then
    git commit -m "schedule: queue the next post slot" >/dev/null
    git push origin main 2>&1 | tail -3
  fi
fi

# ---------------------------------------------------------------------------
# Step 6: best-effort live URL verification (max 90s)
# ---------------------------------------------------------------------------
# Derive the URL from the post's own permalink. The filename (tbd-essay-N.md)
# is a placeholder — the published slug lives in the frontmatter, so a
# filename-derived URL 404s even after a successful deploy.
PERMALINK="$(grep -m1 '^permalink:' "$POST_PATH" | sed 's/^permalink:[[:space:]]*//' | tr -d '"\r' || true)"
LIVE_URL="https://purpleteam.ai${PERMALINK:-/essays/$(basename "$TARGET_FILE" .md)/}"
echo "Pushed. Verifying $LIVE_URL (up to 90s)..."
for i in 1 2 3 4 5 6; do
  HTTP=$(curl -sS --max-time 20 -o /dev/null -w '%{http_code}' "$LIVE_URL" 2>/dev/null || echo "000")
  if [ "$HTTP" = "200" ]; then
    echo "Live URL OK: $LIVE_URL"
    if [ -n "$NEXT_LINE" ]; then
      echo "$NEXT_LINE"
      echo "Next slot queued for $NEXT_THU. Its body still needs writing before then."
    fi
    exit 0
  fi
  sleep 15
done
echo "WARN: live URL still $HTTP after 90s."
echo "Manual: Netlify dashboard -> Trigger deploy -> Clear cache and deploy"
if [ -n "$NEXT_LINE" ]; then
  echo "$NEXT_LINE"
fi
exit 0

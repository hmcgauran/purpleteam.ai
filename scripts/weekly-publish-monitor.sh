#!/usr/bin/env bash
# scripts/weekly-publish-monitor.sh
#
# Cron monitor gate for purpleteam.ai. Cheap, no LLM.
#
# Strategy: work out which branch weekly-publish.sh would take on this tick,
# and report that. The agent only sleeps when there is genuinely nothing to do.
#
# This is robust to:
#   - Atom vs RSS feed differences
#   - feed.xml showing future/draft posts
#   - sitemap.xml having no dates
#   - homepage being slightly stale between build and deploy
#
# Output MUST be deterministic: same input -> same output, no timestamps.
#
# ---------------------------------------------------------------------------
# WHY THIS FILE CHANGED (2026-11-25)
#
# The old version compared two dates:
#     SCHED_DATE = max(publishDate) where publishDate <= today and approved
#     LIVE_DATE  = publishDate of the newest essay on the live homepage
# and reported MATCH when they were equal.
#
# That comparison cannot see an exhausted queue. Once every approved post has
# a publishDate in the past, SCHED_DATE freezes at the last published date and
# LIVE_DATE matches it forever, so the monitor reports MATCH every week. The
# output bytes never change, so the scheduler's hash gate treats the tick as
# "no change" and never wakes the agent. weekly-publish.sh never runs, so it
# never mints the next stub, so the queue stays empty, so the monitor keeps
# reporting MATCH. That is the deadlock that skipped the 2026-11-19 slot, and
# it would have skipped 2026-11-26 the same way.
#
# The fix: mirror the publish script's own decision instead of comparing
# dates. The script has exactly three branches, and two of them need the
# agent:
#
#   BUMPED       - candidate ready, publishDate >= today, body is real
#   STUB_PENDING - candidate exists, body is still the placeholder
#   MINT_STUB    - no candidate at all, queue exhausted
#
# The monitor now computes which branch applies and reports it. Only a ready
# candidate whose date the live site already agrees with sleeps.
# ---------------------------------------------------------------------------

set -e

PROJ="${PURPLETEAM_HOME:-/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai}"
export PROJ

RESULT="$(node -e '
const fs = require("fs");
const path = require("path");
const https = require("https");

const proj = process.env.PROJ;
const schedPath = path.join(proj, "strategy", "PUBLISH-SCHEDULE.json");
const sched = JSON.parse(fs.readFileSync(schedPath, "utf8"));
// Local calendar date, matching the publish script (date +%Y-%m-%d). The
// scheduler fires this at 09:00 local, so the two must agree exactly.
function localDate(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
}
const today = localDate(new Date());

// --- What the SCHEDULE says should be live today (unchanged semantics).
const due = sched.posts
  .filter(function (p) { return p.approved && p.publishDate <= today; })
  .map(function (p) { return p.publishDate; })
  .sort();
const schedDate = due.length ? due[due.length - 1] : "NONE";

// --- Map both the schedule filename and the post real permalink slug to its
// publishDate. The homepage links real slugs while the schedule stores
// tbd-essay-NN.md filenames, so a filename-only map resolves to NONE forever
// and the monitor never settles.
const bySlug = {};
for (const p of sched.posts) {
  bySlug[p.file.replace(/\.md$/, "")] = p.publishDate;
  try {
    const src = fs.readFileSync(path.join(proj, "content", "posts", p.file), "utf8");
    const m = src.match(/^permalink:\s*\/essays\/([^\/]+)\//m);
    if (m) bySlug[m[1]] = p.publishDate;
  } catch (e) {}
}

// --- Which branch would weekly-publish.sh take? Mirrors the script filter:
//     candidates = approved posts with publishDate >= today, earliest first.
const candidates = sched.posts
  .filter(function (p) { return p.approved && p.publishDate >= today; })
  .sort(function (a, b) { return a.publishDate.localeCompare(b.publishDate); });

let action;
let target = "NONE";
let placeholder = false;
if (!candidates.length) {
  action = "MINT_STUB";            // queue exhausted - agent must mint + write
} else {
  const p = candidates[0];
  target = p.id;
  try {
    const src = fs.readFileSync(path.join(proj, "content", "posts", p.file), "utf8");
    const fmStart = src.indexOf("---") + 3;
    const fmEnd = src.indexOf("\n---", fmStart);
    const body = fmEnd >= 0 ? src.slice(fmEnd + 4) : "";
    placeholder = body.replace(/\s+/g, " ").trim().toLowerCase()
      .startsWith("*placeholder. body to be written before");
  } catch (e) {
    placeholder = true;            // missing file - treat as needs writing
  }
  if (p.publishDate > today) {
    // A preview-week stub: seeded ahead of its slot so it can be reviewed
    // before the day. It is NOT due yet, so the script must not bump it.
    action = placeholder ? "STUB_PENDING" : "SCHEDULED";
  } else {
    action = placeholder ? "STUB_PENDING" : "BUMPED";
  }
}

// --- What the LIVE SITE shows as its newest essay.
function fetchHtml(url) {
  return new Promise(function (resolve, reject) {
    const req = https.get(url, { timeout: 12000 }, function (res) {
      let body = "";
      res.on("data", function (c) { body += c; });
      res.on("end", function () { resolve(body); });
    });
    req.on("error", reject);
    req.on("timeout", function () { req.destroy(new Error("timeout")); });
  });
}

(async function () {
  let liveDate = "NONE";
  try {
    const html = await fetchHtml("https://purpleteam.ai/");
    const m = html.match(/href="\/(?:essays)\/([^\/]+)\/"/);
    if (m) liveDate = bySlug[m[1]] || "NONE";
  } catch (e) {
    liveDate = "NONE";
  }
  const drift = schedDate !== liveDate ? "DRIFT" : "IN-SYNC";
  const out = [action, target, drift, "schedule=" + schedDate, "live=" + liveDate].join(" ");
  // Sleep only when there is genuinely nothing to do:
  //   SCHEDULED  - a seeded-ahead post with a real body, not due until its date
  //   BUMPED + IN-SYNC - already published, the live site agrees
  // Everything else is agent work: mint the stub, write the body, or publish.
  const sleep = (action === "SCHEDULED") ||
                (action === "BUMPED" && drift === "IN-SYNC");
  process.stdout.write((sleep ? "MATCH " : "DIFF ") + out);
})();
')"

echo "$RESULT"

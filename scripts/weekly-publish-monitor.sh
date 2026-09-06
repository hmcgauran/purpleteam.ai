#!/usr/bin/env bash
# scripts/weekly-publish-monitor.sh
#
# Cron monitor gate for purpleteam.ai. Cheap, no LLM.
#
# Strategy: parse the homepage HTML for the first /essays/<slug>/ link,
# look up that slug's publishDate in PUBLISH-SCHEDULE.json, and compare
# with the schedule's newest live date. If they match, output MATCH
# (no agent wake). If they differ, output DIFF (agent wakes).
#
# This is robust to:
#   - Atom vs RSS feed differences
#   - feed.xml showing future/draft posts
#   - sitemap.xml having no dates
#   - homepage being slightly stale between build and deploy
#
# Output MUST be deterministic: same input -> same output, no timestamps.

set -e

PROJ="${PURPLETEAM_HOME:-/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai}"

# What the SCHEDULE says should be live today: max(publishDate) where
# publishDate <= today and approved.
SCHED_DATE="$(node -e "
const s = require('$PROJ/strategy/PUBLISH-SCHEDULE.json');
const t = new Date().toISOString().slice(0,10);
const live = s.posts.filter(p => p.approved && p.publishDate <= t).map(p => p.publishDate);
process.stdout.write(live.length ? live.sort().pop() : 'NONE');
")"

# What the LIVE SITE shows as its newest essay: scrape homepage for the
# first /essays/<slug>/ link, then look that slug up in the schedule.
LIVE_DATE="$(node -e "
const https = require('https');
const s = require('$PROJ/strategy/PUBLISH-SCHEDULE.json');
const byFile = Object.fromEntries(s.posts.map(p => [p.file.replace(/\.md$/, ''), p.publishDate]));
function fetchHtml(url) {
  return new Promise((resolve, reject) => {
    const req = https.get(url, { timeout: 12000 }, (res) => {
      let body = '';
      res.on('data', (c) => body += c);
      res.on('end', () => resolve(body));
    });
    req.on('error', reject);
    req.on('timeout', () => req.destroy(new Error('timeout')));
  });
}
(async () => {
  try {
    const html = await fetchHtml('https://purpleteam.ai/');
    const m = html.match(/href=\"\\/essays\\/([^\\/]+)\\/\"/);
    if (!m) { process.stdout.write('NONE'); return; }
    process.stdout.write(byFile[m[1]] || 'NONE');
  } catch (e) {
    process.stdout.write('NONE');
  }
})();
")"

if [ "$SCHED_DATE" = "$LIVE_DATE" ]; then
  echo "MATCH schedule=$SCHED_DATE live=$LIVE_DATE"
else
  echo "DIFF schedule=$SCHED_DATE live=$LIVE_DATE"
fi
#!/usr/bin/env bash
# scripts/weekly-publish-monitor.sh
#
# Cron monitor gate for purpleteam.ai. Cheap, no LLM.
#
# Compares the live site's newest essay against what the publish schedule
# says should be live. If the live site is behind schedule, prints a
# DIFF line so the scheduler wakes the agent. If they match, prints
# the same MATCH line as last tick, so the agent stays asleep.
#
# This makes the cron idempotent: manual pushes or out-of-band deploys
# that already brought the site up to date don't cause duplicate agent
# runs.

set -e

PROJ="${PURPLETEAM_HOME:-/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai}"

# What the SCHEDULE says should be live today: max(publishDate) for posts
# where publishDate <= today and approved.
SCHED_DATE="$(node -e "
const s = require('$PROJ/strategy/PUBLISH-SCHEDULE.json');
const t = new Date().toISOString().slice(0,10);
const live = s.posts.filter(p => p.approved && p.publishDate <= t).map(p => p.publishDate);
process.stdout.write(live.length ? live.sort().pop() : 'NONE');
")"

# What the LIVE SITE shows as its newest essay date. Parse feed.xml (which
# has RFC822 pubDate) for the highest-pubDate entry.
LIVE_DATE="$(curl -sS --max-time 15 https://purpleteam.ai/feed.xml 2>/dev/null \
  | grep -oE '<pubDate>[^<]+</pubDate>' \
  | sed -E 's|<pubDate>([A-Za-z]+, [0-9]+ [A-Za-z]+ [0-9]+) [^<]+</pubDate>|\1|' \
  | while read d; do date -j -f '%a, %d %b %Y' "$d" +%Y-%m-%d 2>/dev/null; done \
  | sort \
  | tail -1)"

if [ -z "$LIVE_DATE" ]; then
  LIVE_DATE="NONE"
fi

if [ "$SCHED_DATE" = "$LIVE_DATE" ]; then
  echo "MATCH schedule=$SCHED_DATE live=$LIVE_DATE"
else
  echo "DIFF schedule=$SCHED_DATE live=$LIVE_DATE"
fi
---
permalink: false
---
# purpleteam.ai

The static site that powers [purpleteam.ai](https://purpleteam.ai). Practitioner-led
writing on purple teaming, detection engineering, and operational security work.

## Stack

- **Eleventy 3** static site generator
- **Nunjucks** templates
- Plain CSS, no framework
- **Luxon** for date formatting
- Node 20+

## Local development

```bash
npm install        # one-time
npm run dev        # http://localhost:8080 with live-reload
npm run build      # production build into _site/
```

## Content model

### Essays

Drop a markdown file into `content/posts/` with this frontmatter:

```yaml
---
title: "Essay title"
slug: "kebab-case-slug"
date: 2026-03-20
tags:
  - "Purple Teaming"
  - "Threat Modelling"
  - post            # must be present; marks the post-collection
author: Hugh McGauran
excerpt: "Single-sentence pitch used on archive cards and meta descriptions."
layout: layouts/post.njk
permalink: /essays/your-slug/
---
```

The `permalink` field is required and stable; **don't change it after publishing** —
that's the URL people will have bookmarked.

### Publish gating

`strategy/PUBLISH-SCHEDULE.json` is the canonical "is this post live?" gate. The
build reads it and only emits HTML for posts that are:

1. `approved: true`
2. `publishDate` ≤ today

To schedule a new essay:

1. Drop the markdown into `content/posts/` with `permalink`, `tags: [..., post]`, `date: YYYY-MM-DD`.
2. Add an entry to `strategy/PUBLISH-SCHEDULE.json` with `approved: false`.
3. On the publish day (or after), flip `approved: true`.
4. Commit. CI / cron triggers a rebuild.

### Topic taxonomy

The `site.tags` array in `_data/site.js` is the canonical list of topics. Adding
a new topic:

1. Append it to `site.tags` in `_data/site.js`.
2. Use it in a post's `tags:` frontmatter list.
3. Rebuild — the topic page at `/tags/<slug>/` is auto-generated.

Do **not** freeform a topic on a single post without adding it to `site.tags` —
the topic-page index won't include it.

## File map

```
.
├── _data/             JS files exposed as template variables
│   ├── site.js        site title, tagline, description, URL, topic list
│   └── author.js      author bio + social links
├── _includes/
│   ├── layouts/       page templates (base, post)
│   └── partials/      header, footer, meta, article-schema, newsletter-cta
├── _scripts/          one-shot scripts (post migration)
├── assets/            favicon, OG image, CSS (passthrough)
├── content/
│   ├── posts/         essay markdown sources
│   └── assets/        (unused; reserved for post images)
├── strategy/
│   └── PUBLISH-SCHEDULE.json
├── .eleventy.js       config
├── about.md
├── feed.njk           RSS (Atom) feed
├── index.njk          homepage
├── tag.njk            per-topic page template
├── tags.njk           topics index
├── 404.njk
├── robots.txt
└── netlify.toml       (deployment config — see below)
```

## Deployment

Hosted on Netlify. Source repo at `purpleteam.ai`. Netlify builds on every
push to `main`:

- Build command: `npm run build`
- Publish directory: `_site`
- Node version pinned at 20 in `netlify.toml`

### Custom domain

Once DNS is pointed at Netlify:
- `purpleteam.ai` (apex) — Netlify-managed CNAME
- `www.purpleteam.ai` — 301 redirect to apex

## Editorial standards

Captured in the `_includes/layouts/base.njk` masthead copy and the `about.md` page:

- Threat-model driven analysis, not checklist security.
- Detection engineering grounded in baseline and environment.
- Practical writing for teams that run real programmes.
- No vendor fluff. No generic frameworks presented as new. No theatre dressed as strategy.

## What's intentionally NOT in scope

- Comments / community (Discord link in footer is sufficient; can be added later).
- Newsletter backend (the form is a placeholder — Buttondown or Beehiiv embed when
  ready; RSS is the fallback).
- Per-essay OG image generator (static `/assets/og/default.svg` for now).
- Internal search engine.
- Analytics integration (Plausible or Fathom is one env-var away when ready).

## License

Content (essays): © Hugh McGauran. All rights reserved.
Code (templates, scripts, CSS): MIT.

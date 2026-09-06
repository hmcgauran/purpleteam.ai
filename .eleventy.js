/**
 * eleventy config for purpleteam.ai
 *
 * Reads PUBLISH-SCHEDULE.json and only emits pages for approved posts whose
 * publishDate is on or before today. The schedule is the single source of truth
 * for "is this post live?".
 */

const fs = require('fs');
const path = require('path');
const { DateTime } = require('luxon');

module.exports = function (eleventyConfig) {
  // Passthrough static assets. assets/ at root is the canonical place.
  eleventyConfig.addPassthroughCopy({ 'assets': 'assets' });
  eleventyConfig.addPassthroughCopy({ 'robots.txt': 'robots.txt' });

  // Date filters — use ISO everywhere internally; render human-readable separately.
  eleventyConfig.addFilter('isoDate', (d) => {
    if (!d) return '';
    const dt = (d instanceof Date) ? d : new Date(d);
    if (isNaN(dt.getTime())) return '';
    return dt.toISOString().slice(0, 19) + 'Z';
  });

  eleventyConfig.addFilter('readableDate', (d) => {
    if (!d) return '';
    // Eleventy passes either an ISO string (frontmatter date: 'YYYY-MM-DD')
    // or a Date instance (resolved via the post's date field). Handle both.
    const dt = (d instanceof Date) ? DateTime.fromJSDate(d, { zone: 'utc' })
                                   : DateTime.fromISO(String(d), { zone: 'utc' });
    if (!dt.isValid) return '';
    return dt.toFormat('d LLLL yyyy');
  });

  eleventyConfig.addFilter('readingTime', (content) => {
    if (!content) return '1 min read';
    const words = String(content).split(/\s+/).filter(Boolean).length;
    const mins = Math.max(1, Math.round(words / 200));
    return `${mins} min read`;
  });

  eleventyConfig.addFilter('limit', (arr, n) => (arr || []).slice(0, n));

  // Newest ISO date from a list of dated objects.
  eleventyConfig.addFilter('newestDateISO', (arr) => {
    if (!arr || !arr.length) return '';
    const newest = arr.reduce((a, b) => (a.date > b.date ? a : b));
    return newest.date ? newest.date.toISOString().slice(0, 19) + 'Z' : '';
  });

  // Drop the last item from an array (used to remove the featured post from archive).
  eleventyConfig.addFilter('dropLast', (arr) => (arr || []).slice(0, -1));

  // Drop the first item from an array (the featured post, after sortDesc).
  eleventyConfig.addFilter('dropFirst', (arr) => (arr || []).slice(1));

  // Sort an array of dated objects by `date` in descending order (newest first).
  eleventyConfig.addFilter('sortDesc', (arr) => {
    if (!arr) return [];
    return [...arr].sort((a, b) => {
      const ad = a.date instanceof Date ? a.date.getTime() : new Date(a.date).getTime();
      const bd = b.date instanceof Date ? b.date.getTime() : new Date(b.date).getTime();
      return bd - ad;
    });
  });

  eleventyConfig.addFilter('slugify', (s) =>
    String(s).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
  );

  // Map a topic name to a chip colour class. Used by every card / chip
  // surface so the colour rule lives in one place.
  eleventyConfig.addFilter('chipClass', (tag) => {
    const t = String(tag || '').toLowerCase();
    const RED = new Set(['red team', 'pen testing', 'adversary emulation']);
    const BLUE = new Set(['blue team', 'detection engineering', 'insider threat']);
    const PURPLE = new Set(['purple teaming', 'threat modelling', 'threat modeling']);
    if (RED.has(t))    return 'chip chip--red';
    if (BLUE.has(t))   return 'chip chip--blue';
    if (PURPLE.has(t)) return 'chip chip--purple';
    return 'chip chip--neutral';
  });

  // Bug 3 fix: each post's first body paragraph duplicates the excerpt
  // (the dek). Render the dek once at the top of the article and strip the
  // matching leading <p> from the body so we don't display it twice.
  eleventyConfig.addFilter('bodyWithoutDek', (content, excerpt) => {
    if (!content) return '';
    if (!excerpt) return content;
    // Normalise both sides aggressively: collapse whitespace, decode the
    // HTML entities the markdown renderer might emit (e.g. &quot; -> "),
    // strip trailing punctuation, lower-case. The dek and the body are
    // authored identically, so they should match after this.
    const decode = (s) => String(s || '')
      .replace(/&quot;/g, '"')
      .replace(/&#34;/g, '"')
      .replace(/&amp;/g, '&')
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&mdash;/g, '\u2014')
      .replace(/&ndash;/g, '\u2013')
      .replace(/&hellip;/g, '\u2026')
      .replace(/&rsquo;|&lsquo;/g, "'")
      .replace(/&ldquo;|&rdquo;/g, '"');
    const norm = (s) => decode(s).replace(/\s+/g, ' ').trim().replace(/[.\s]+$/, '').toLowerCase();
    const want = norm(excerpt);
    if (!want) return content;
    // Find the first <p>...</p> and check whether its text matches the dek.
    const m = String(content).match(/^(\s*<p[^>]*>)([\s\S]*?)(<\/p>)/i);
    if (!m) return content;
    const have = norm(m[2].replace(/<[^>]+>/g, ''));
    if (have === want) {
      // Drop the leading <p>...</p> and any whitespace before the next block.
      return String(content).slice(m[0].length).replace(/^\s+/, '');
    }
    return content;
  });

  // Absolute URL: `${site.url}${path}`. Tolerates either side having the slash.
  eleventyConfig.addFilter('absoluteUrl', (path, base) => {
    base = base || 'https://purpleteam.ai';
    if (!base.endsWith('/')) base = base + '/';
    if (path.startsWith('/')) path = path.slice(1);
    return base + path;
  });

  // Build a sorted list of {name, count, slug} from a tag → posts map.
  eleventyConfig.addFilter('tagCounts', (postsByTag) => {
    const out = [];
    for (const [name, posts] of Object.entries(postsByTag || {})) {
      out.push({
        name,
        count: posts.length,
        slug: name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, ''),
      });
    }
    return out.sort((a, b) => a.name.localeCompare(b.name));
  });

  // Collections scoped to the publish gate.
  const schedulePath = path.join(__dirname, 'strategy', 'PUBLISH-SCHEDULE.json');
  const schedule = JSON.parse(fs.readFileSync(schedulePath, 'utf8'));
  const todayISO = new Date().toISOString().slice(0, 10);
  const liveFiles = new Set(
    schedule.posts
      .filter((p) => p.approved && p.publishDate <= todayISO)
      .map((p) => p.file)
  );

  function isLive(item) {
    if (!item || !item.filePath) return false;
    const base = path.basename(item.filePath);
    return liveFiles.has(base);
  }

  // Bug fix: the `posts` collection was previously broken in Eleventy 3
  // because `api.getFilteredByGlob` returns zero items when called from
  // inside this collection callback (the same issue we hit with the
  // postsByTag collection). The robust workaround is the same one we
  // use for `postsByTag`: compute the data in a global data file
  // (_data/postsByTag.js) and expose it as a collection via a thin
  // wrapper. The wrapper still has to look like an Eleventy template
  // object (so the {% for post in archive %} loop can read post.url,
  // post.data.title, post.date, etc.), so we build the same shape from
  // the data file.
  //
  // Templates read this collection as `collections.posts` (plural).
  // The default Eleventy 3 `post` collection (singular) is also still
  // available, but it includes future-dated posts. We use `posts` so
  // the publish-gate is honoured.
  eleventyConfig.addCollection('posts', () => {
    const { postsByTag } = require('./_data/postsByTag.js');
    const out = [];
    for (const arr of Object.values(postsByTag || {})) {
      for (const p of arr) out.push(p);
    }
    out.sort((a, b) => {
      const ad = a.date ? new Date(a.date).getTime() : 0;
      const bd = b.date ? new Date(b.date).getTime() : 0;
      return ad - bd;
    });
    return out;
  });

  // Bug fix: the previous `postsByTag` collection was broken in Eleventy 3
  // because `api.getFilteredByGlob` returns zero items when called from
  // inside this collection callback. The robust workaround is to compute
  // these from the frontmatter in a global data file (see
  // _data/postsByTag.js), which is evaluated at template-render time
  // and has the data we need.
  eleventyConfig.addCollection('postsByTag', () => {
    // Delegate to the global data file.
    const { postsByTag, tagList } = require('./_data/postsByTag.js');
    // Also rebuild the legacy `tagCounts` shape so existing templates work.
    eleventyConfig.collections._tagCountsReady = tagList;
    return postsByTag || {};
  });

  // Plain array of tag names so `pagination.data` can iterate cleanly.
  eleventyConfig.addCollection('tagsList', (api) => {
    const tagged = new Set();
    api.getFilteredByGlob('content/posts/*.md')
      .filter(isLive)
      .forEach((p) => {
        (p.data.tags || []).forEach((t) => tagged.add(t));
      });
    return Array.from(tagged).sort();
  });

  // Sitemap generated manually for full control of the output. We collect
  // URLs at sitemap-generation time so we don't depend on plugin lifecycle hooks.
  eleventyConfig.on('eleventy.after', async () => {
    const fsx = require('fs');
    const pathx = require('path');
    const out = pathx.join(__dirname, '_site', 'sitemap.xml');
    const base = 'https://purpleteam.ai';
    function walk(dir, acc = []) {
      const entries = fsx.readdirSync(dir, { withFileTypes: true });
      for (const e of entries) {
        const full = pathx.join(dir, e.name);
        if (e.isDirectory()) walk(full, acc);
        else if (e.name === 'index.html') {
          const rel = pathx.relative(pathx.join(__dirname, '_site'), pathx.dirname(full));
          const url = rel === '' ? `${base}/` : `${base}/${rel.replace(/\\/g, '/')}/`;
          acc.push(url);
        }
      }
      return acc;
    }
    const urls = walk(pathx.join(__dirname, '_site'));
    const xml = [
      '<?xml version="1.0" encoding="UTF-8"?>',
      '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
      ...urls.map((u) => `  <url><loc>${u}</loc></url>`),
      '</urlset>',
      '',
    ].join('\n');
    fsx.writeFileSync(out, xml);
  });

  return {
    dir: {
      input: '.',
      includes: '_includes',
      data: '_data',
      output: '_site',
    },
    templateFormats: ['md', 'njk', 'html'],
    markdownTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',
    pathPrefix: '/',
  };
};

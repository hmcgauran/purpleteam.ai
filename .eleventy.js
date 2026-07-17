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
const sitemap = require('@quasibit/eleventy-plugin-sitemap');

module.exports = function (eleventyConfig) {
  // Passthrough static assets
  eleventyConfig.addPassthroughCopy({ static: 'static' });
  eleventyConfig.addPassthroughCopy({ 'content/assets': 'assets' });

  // Date filters — use ISO everywhere internally; render human-readable separately.
  eleventyConfig.addFilter('isoDate', (d) => {
    if (!d) return '';
    return DateTime.fromISO(String(d), { zone: 'utc' })
      .toISO({ suppressMilliseconds: true });
  });

  eleventyConfig.addFilter('readableDate', (d) => {
    if (!d) return '';
    return DateTime.fromISO(String(d), { zone: 'utc' })
      .toFormat('d LLLL yyyy');
  });

  eleventyConfig.addFilter('readingTime', (content) => {
    if (!content) return '1 min read';
    const words = String(content).split(/\s+/).filter(Boolean).length;
    const mins = Math.max(1, Math.round(words / 200));
    return `${mins} min read`;
  });

  eleventyConfig.addFilter('limit', (arr, n) => (arr || []).slice(0, n));

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

  eleventyConfig.addCollection('posts', (api) => {
    return api
      .getFilteredByGlob('content/posts/*.md')
      .filter(isLive)
      .sort((a, b) => a.date - b.date);
  });

  eleventyConfig.addCollection('postsByTag', (api) => {
    const tagged = {};
    api.getFilteredByGlob('content/posts/*.md')
      .filter(isLive)
      .forEach((p) => {
        (p.data.tags || []).forEach((t) => {
          tagged[t] = tagged[t] || [];
          tagged[t].push(p);
        });
      });
    return tagged;
  });

  // Sitemap
  eleventyConfig.addPlugin(sitemap, {
    sitemap: {
      hostname: 'https://purpleteam.ai',
    },
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

// _data/postsByTag.js
// Bug fix: the original Eleventy 3 `postsByTag` and `tagsList` collections were
// broken because `api.getFilteredByGlob` returns zero items from inside an
// `addCollection` callback. This file computes the same data directly from the
// filesystem + PUBLISH-SCHEDULE, mirroring the live-gate the Eleventy build
// already applies to `collections.post`. The file's *exports* become the
// global data on the page: `postsByTag`, `tagList`, `tagMap`.
//
// Note: the file is named `postsByTag.js` (not `tags.js`) so it does not
// collide with Eleventy 3's reserved top-level `tags` key (Eleventy treats
// any `_data/<name>.js` as if `<name>` were a global data key, and `tags`
// must be an array of strings).

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const POSTS_DIR = path.join(ROOT, 'content', 'posts');
const SCHEDULE = path.join(ROOT, 'strategy', 'PUBLISH-SCHEDULE.json');

function readSchedule() {
  try { return JSON.parse(fs.readFileSync(SCHEDULE, 'utf8')); }
  catch (e) { return { posts: [] }; }
}

function livePostFiles() {
  const schedule = readSchedule();
  const today = new Date().toISOString().slice(0, 10);
  const set = new Set();
  for (const p of (schedule.posts || [])) {
    if (p && p.approved && p.publishDate && p.publishDate <= today && p.file) {
      set.add(p.file);
    }
  }
  return set;
}

function parseFrontmatter(raw) {
  // Tiny YAML-ish frontmatter parser. Handles the `key: value` and `key:\n  - item` shapes
  // used in this repo. We only need `tags`, `title`, `date`, `permalink`, `slug`, `excerpt`.
  const m = raw.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) return {};
  const block = m[1];
  const fm = {};
  const lines = block.split('\n');
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const km = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!km) { i++; continue; }
    const key = km[1];
    const val = km[2];
    if (val === '' && i + 1 < lines.length && lines[i + 1].trim().startsWith('- ')) {
      const arr = [];
      i++;
      while (i < lines.length && lines[i].trim().startsWith('- ')) {
        arr.push(lines[i].trim().slice(2).replace(/^["']|["']$/g, ''));
        i++;
      }
      fm[key] = arr;
    } else if (val !== '') {
      fm[key] = val.replace(/^["']|["']$/g, '');
      i++;
    } else {
      i++;
    }
  }
  return fm;
}

function build() {
  if (!fs.existsSync(POSTS_DIR)) {
    return { postsByTag: {}, tagList: [], tagMap: {}, count: 0 };
  }
  const live = livePostFiles();
  const postsByTag = {};   // 'Purple Teaming' -> [post entries]
  const tagMap = {};       // 'purple-teaming' -> 'Purple Teaming'

  const files = fs.readdirSync(POSTS_DIR).filter((f) => f.endsWith('.md')).sort();
  for (const file of files) {
    if (!live.has(file)) continue;
    const raw = fs.readFileSync(path.join(POSTS_DIR, file), 'utf8');
    const fm = parseFrontmatter(raw);
    const tagsForPost = (fm.tags || []).filter((t) => t !== 'post');
    if (!tagsForPost.length) continue;
    const slug = fm.slug || file.replace(/\.md$/, '');
    // Match the shape Eleventy's `collections.post` exposes, plus a few flat
    // fields the existing site templates read (e.g. `post.date`).
    const entry = {
      url: fm.permalink || `/essays/${slug}/`,
      fileSlug: slug,
      inputPath: path.join(POSTS_DIR, file),
      date: fm.date || '',
      templateContent: raw.replace(/^---\n[\s\S]*?\n---\n/, ''),
      data: {
        title: fm.title || slug,
        date: fm.date || '',
        slug,
        excerpt: fm.excerpt || '',
        tags: tagsForPost,
        permalink: fm.permalink || `/essays/${slug}/`,
      },
    };
    for (const t of tagsForPost) {
      (postsByTag[t] = postsByTag[t] || []).push(entry);
      tagMap[String(t).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')] = t;
    }
  }

  // tagList is the alphabetical list of {name, count, slug} entries that the
  // existing `tagCounts` filter produces from the buggy `postsByTag` map.
  const tagList = Object.keys(postsByTag)
    .sort((a, b) => a.localeCompare(b))
    .map((name) => ({
      name,
      count: postsByTag[name].length,
      slug: name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, ''),
    }));

  return { postsByTag, tagList, tagMap, count: tagList.length };
}

const built = build();
module.exports = built;
module.exports.tagCounts = built.tagList;  // legacy alias for old filter

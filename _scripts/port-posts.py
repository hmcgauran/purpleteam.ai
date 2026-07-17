#!/usr/bin/env python3
"""
One-shot migration: convert 11 legacy posts in
~/.openclaw/workspace/purpleteamai/content/purpleteam-blog-post-N.md
into Eleventy-friendly content/posts/<slug>.md with YAML frontmatter.

Reads PUBLISH-SCHEDULE.json from the new tree.

Run from anywhere; absolute paths.
"""

import json
import re
import sys
from datetime import date
from pathlib import Path

OLD_CONTENT = Path("/Users/hughmcgauran/.openclaw/workspace/purpleteamai/content")
NEW_CONTENT = Path("/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai/content/posts")
SCHEDULE = Path("/Users/hughmcgauran/.openclaw/workspace/purpleteam.ai/strategy/PUBLISH-SCHEDULE.json")

# Stable slugs (lock-in now; URL changes later cost SEO).
SLUGS = {
    "post-1": "purple-team-threat-model-wrong",
    "post-2": "detection-engineering-real-environment",
    "post-3": "red-team-tests-designed-to-fail",
    "post-4": "purple-teaming-that-actually-works",
    "post-5": "scoping-a-red-team-engagement",
    "post-6": "purple-teaming-ot",
    "post-7": "seven-pointless-ot-pen-test-findings",
    "post-8": "insider-threat-problem",
    "post-9": "living-off-the-land",
    "post-10": "purple-team-report-that-gets-read",
    "post-11": "adversary-emulation-vs-penetration-testing",
    "post-12": "purple-teaming-at-scale",
    "post-13": "building-a-detection-baseline",
}


def extract_excerpt(body: str, title: str) -> str:
    """First meaty paragraph (skip h1 / byline / read-time blocks)."""
    lines = body.split("\n")
    paragraph_lines = []
    for line in lines:
        s = line.strip()
        if not s:
            if paragraph_lines:
                break
            continue
        if s.startswith("#"):
            if paragraph_lines:
                break
            continue
        if s.startswith("**"):
            continue
        if s.startswith("---"):
            continue
        if s.startswith("[") or s.startswith("!"):
            continue
        paragraph_lines.append(s)
    excerpt = " ".join(paragraph_lines)
    excerpt = re.sub(r"\*\*(.+?)\*\*", r"\1", excerpt)
    excerpt = re.sub(r"\*(.+?)\*", r"\1", excerpt)
    excerpt = re.sub(r"`(.+?)`", r"\1", excerpt)
    excerpt = excerpt.strip().rstrip(".")
    if len(excerpt) > 220:
        excerpt = excerpt[:217].rsplit(" ", 1)[0] + "…"
    return excerpt


def yaml_escape(s: str) -> str:
    """Double-quoted YAML scalar with escapes."""
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def yaml_tags(tags: list[str]) -> str:
    return "[" + ", ".join(yaml_escape(t) for t in tags) + "]"


def convert(post: dict):
    """Returns (out_path, content) or None if the source file is missing."""
    src = OLD_CONTENT / post["file"]
    if not src.exists():
        return None
    raw = src.read_text()
    # The body starts after the metadata block (the `---` line just after "Read time:").
    parts = raw.split("\n---\n", 1)
    if len(parts) != 2:
        raise ValueError(f"{post['file']}: missing `---` separator after metadata")
    metadata, body = parts
    metadata = metadata.strip()
    body = body.lstrip("\n")

    # Strip the leading h1 — title goes in frontmatter.
    body_lines = body.split("\n")
    while body_lines and not body_lines[0].strip():
        body_lines.pop(0)
    if body_lines and body_lines[0].startswith("# "):
        body_lines.pop(0)
    body = "\n".join(body_lines).lstrip("\n")

    excerpt = extract_excerpt(body, post["title"])

    fm = [
        "---",
        f"title: {yaml_escape(post['title'])}",
        f"slug: {yaml_escape(SLUGS[post['id']])}",
        f"date: {post['publishDate']}",
        "tags:",
    ]
    for t in post["tags"]:
        fm.append(f"  - {yaml_escape(t)}")
    fm.extend(
        [
            "author: Hugh McGauran",
            f"excerpt: {yaml_escape(excerpt)}",
            "layout: layouts/post.njk",
            "---",
            "",
        ]
    )
    frontmatter = "\n".join(fm)
    full = frontmatter + body
    out = NEW_CONTENT / f"{SLUGS[post['id']]}.md"
    return out, full


def main() -> int:
    schedule = json.loads(SCHEDULE.read_text())
    today = date.today().isoformat()
    NEW_CONTENT.mkdir(parents=True, exist_ok=True)
    written = []
    for post in schedule["posts"]:
        if not post["approved"]:
            continue
        if post["publishDate"] > today:
            continue
        if post["id"] not in SLUGS:
            print(f"  SKIP {post['id']}: no slug mapping", file=sys.stderr)
            continue
        result = convert(post)
        if result is None:
            print(f"  MISS {post['id']}: source file {post['file']!r} not yet written")
            continue
        out, content = result
        out.write_text(content)
        written.append(out)
        print(f"  OK   {out.name}  ({len(content):>6} bytes)")
    print(f"\n{len(written)} posts written.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

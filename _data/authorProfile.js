// _data/authorProfile.js
// Phase 2: this file is intentionally named `authorProfile` (not `author`)
// so it doesn't shadow the `author:` frontmatter key on individual posts.
// The global data is exposed to templates as `authorProfile`.
//
// Per the redesign brief: no employer, company, or job title anywhere on
// the site. We keep only name, shortBio, longBio (both free of employment
// claims), twitter, linkedin, email.

module.exports = {
  name: "Hugh McGauran",
  shortBio:
    "Cybersecurity practitioner with 25 years across enterprise security, red and blue collaboration, and detection engineering.",
  longBio:
    "Hugh McGauran is a cybersecurity practitioner working across enterprise security operations, purple team methodology, and detection engineering. He writes here because most public security content is either vendor marketing, generic framework worship, or theatre dressed as strategy — and the practitioners running real programmes deserve sharper thinking than that.",
  twitter: "https://twitter.com/purpleteamai",
  linkedin: "https://linkedin.com/in/hughmcgauran",
  email: "hello@purpleteam.ai",
};

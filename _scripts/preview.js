// Render the live site to screenshots for human review.
// Uses Playwright. Saves PNGs to /tmp/purpleteamai-screenshots/.

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const OUT = '/tmp/purpleteamai-screenshots';

const PAGES = [
  { name: 'home-dark',     url: '/',                                  theme: 'dark' },
  { name: 'home-light',    url: '/',                                  theme: 'light' },
  { name: 'essay-dark',    url: '/essays/purple-team-threat-model-wrong/', theme: 'dark' },
  { name: 'essay-light',   url: '/essays/purple-team-threat-model-wrong/', theme: 'light' },
  { name: 'about-dark',    url: '/about/',                            theme: 'dark' },
  { name: 'tags-dark',     url: '/tags/',                             theme: 'dark' },
  { name: 'topic-dark',    url: '/tags/purple-teaming/',              theme: 'dark' },
];

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  const browser = await chromium.launch();

  for (const p of PAGES) {
    const context = await browser.newContext({
      viewport: { width: 1280, height: 900 },
      deviceScaleFactor: 2,
      colorScheme: p.theme === 'dark' ? 'dark' : 'light',
    });
    await context.addInitScript((theme) => {
      localStorage.setItem('pt-theme', theme);
    }, p.theme);
    const page = await context.newPage();
    await page.goto(`http://localhost:8123${p.url}`, { waitUntil: 'networkidle' });
    // Take full page screenshot
    await page.screenshot({
      path: path.join(OUT, `${p.name}.png`),
      fullPage: true,
    });
    console.log(`Saved ${p.name}.png`);
    await context.close();
  }

  await browser.close();
})();

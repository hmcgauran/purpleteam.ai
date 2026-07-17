// Render the brand mark at three sizes (favicon, header, masthead) so we can
// visually verify it before committing it across the site.
const { chromium } = require('playwright');
const path = require('path');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1200, height: 800 }, deviceScaleFactor: 2 });
  const html = `
    <!doctype html><html><body style="margin:0;background:#0f172a;color:#e5e7eb;font-family:Inter,system-ui,sans-serif">
      <div style="padding:48px;display:grid;grid-template-columns:repeat(3,1fr);gap:48px;align-items:end">
        <div style="text-align:center"><div style="width:32px;height:32px;color:#e5e7eb">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">favicon · 32px</div></div>
        <div style="text-align:center"><div style="width:48px;height:48px;color:#e5e7eb">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">header · 48px</div></div>
        <div style="text-align:center"><div style="width:200px;height:200px;color:#e5e7eb">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">masthead · 200px</div></div>
      </div>
      <div style="padding:48px;background:#fafaf7;color:#0f172a">
        <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:48px;align-items:end">
          <div style="text-align:center"><div style="width:32px;height:32px">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">light · 32px</div></div>
          <div style="text-align:center"><div style="width:48px;height:48px">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">light · 48px</div></div>
          <div style="text-align:center"><div style="width:200px;height:200px">__SVG__</div><div style="margin-top:8px;font-size:11px;letter-spacing:0.1em;color:#9ca3af;text-transform:uppercase">light · 200px</div></div>
        </div>
      </div>
    </body></html>`;
  const svg = require('fs').readFileSync(path.join(__dirname, '..', 'assets', 'brand-mark.svg'), 'utf8');
  // Use the inner content (strip <svg> wrapper) since we set width/height on a wrapper div
  const inner = svg.replace(/<\?xml[^>]*>/, '').replace(/<svg[^>]*>/, '').replace(/<\/svg>$/, '');
  await page.setContent(html.replace(/__SVG__/g, inner));
  await page.screenshot({ path: '/tmp/mark-preview.png', fullPage: true });
  console.log('Wrote /tmp/mark-preview.png');
  await browser.close();
})();

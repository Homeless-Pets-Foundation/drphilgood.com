import { chromium } from 'playwright';

const pages = [
  { url: 'https://drphilgood.com/', name: 'home', viewports: ['desktop', 'mobile'] },
  { url: 'https://drphilgood.com/about-me/', name: 'about', viewports: ['desktop'] },
  { url: 'https://drphilgood.com/my-practice/', name: 'practice', viewports: ['desktop'] },
  { url: 'https://drphilgood.com/rescue-mission/', name: 'rescue', viewports: ['desktop'] },
  { url: 'https://drphilgood.com/our-legacy/', name: 'legacy', viewports: ['desktop'] },
  { url: 'https://drphilgood.com/contact-me/', name: 'contact', viewports: ['desktop'] },
];

const viewportSizes = {
  desktop: { width: 1440, height: 900 },
  mobile: { width: 390, height: 844 },
};

const browser = await chromium.launch({ headless: true });

for (const page of pages) {
  for (const vp of page.viewports) {
    const context = await browser.newContext({ viewport: viewportSizes[vp] });
    const p = await context.newPage();
    await p.goto(page.url + '?nocache=' + Date.now(), { waitUntil: 'networkidle' });

    // Scroll through the entire page to trigger IntersectionObserver reveals
    const pageHeight = await p.evaluate(() => document.body.scrollHeight);
    for (let y = 0; y < pageHeight; y += 300) {
      await p.evaluate((scrollY) => window.scrollTo(0, scrollY), y);
      await p.waitForTimeout(100);
    }
    // Scroll back to top
    await p.evaluate(() => window.scrollTo(0, 0));
    await p.waitForTimeout(500);

    // Force ALL elements visible with CSS override
    await p.evaluate(() => {
      const style = document.createElement('style');
      style.textContent = `
        .reveal, .reveal-left, .reveal-stagger,
        .reveal > *, .reveal-stagger > *,
        .bricks-lazy-hidden, [class*="reveal"] {
          opacity: 1 !important;
          transform: none !important;
          visibility: visible !important;
          transition: none !important;
          animation: none !important;
        }
      `;
      document.head.appendChild(style);
    });

    await p.waitForTimeout(1000);
    const path = `audit/screenshots/${page.name}-after-${vp}.png`;
    await p.screenshot({ path, fullPage: true });
    console.log(`Captured: ${path}`);
    await context.close();
  }
}

await browser.close();

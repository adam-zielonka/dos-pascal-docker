const { test } = require('node:test');
const assert = require('node:assert/strict');
const { chromium } = require('@playwright/test');
const fs = require('node:fs/promises');
const path = require('node:path');
const root = path.resolve(__dirname, '..');

async function fixture(browser, game = 'SAPER', fail = false) {
  const page = await browser.newPage({ viewport: { width: 390, height: 844 }, hasTouch: true });
  await page.route('http://player.test/**', async route => {
    const name = new URL(route.request().url()).pathname.slice(1) || 'index.html';
    if (name === 'js-dos.js') {
      return route.fulfill({ contentType: 'application/javascript', body: `
        window.events = [];
        window.Dos = async () => {
          ${fail ? 'throw new Error("Unavailable archive");' : ''}
          return {
            fs: { extractAll: async archives => { window.archives = archives; } },
            main: async args => { window.commands = args; return {
              simulateKeyEvent: (code, down) => window.events.push([code, down])
            }; }
          };
        };` });
    }
    const mime = { html: 'text/html', css: 'text/css', js: 'application/javascript' }[name.split('.').pop()];
    let body = await fs.readFile(path.join(root, name), 'utf8');
    body = body.replaceAll('!!!TITLE!!!', game).replaceAll('!!!ZIP_FILENAME!!!', `${game}-hash.ZIP`).replaceAll('!!!EXE_FILENAME!!!', `${game}.EXE`);
    await route.fulfill({ contentType: mime, body });
  });
  await page.goto('http://player.test/');
  await page.waitForFunction(() => document.querySelector('#boot').hidden || !document.querySelector('#retry').hidden);
  return page;
}

test('mini pad: real input events, recovery and responsive game profiles', async () => {
  const browser = await chromium.launch();
  try {
    const page = await fixture(browser);
    assert.equal(await page.locator('[data-key="80"]').first().isVisible(), false);
    for (const key of [190, 191, 112]) assert.equal(await page.locator(`[data-key="${key}"]`).isVisible(), true);
    assert.deepEqual(await page.evaluate(() => archives), [
      { url: 'SAPER.ZIP', mountPoint: '/SAPER' },
      { url: 'SAPER-hash.ZIP', mountPoint: '/GRA' },
    ]);
    assert.ok((await page.evaluate(() => commands)).includes('COPY C:\\GRA\\SAPER.EXE'));
    await page.locator('[data-key="191"]').click();
    assert.deepEqual(await page.evaluate(() => events.splice(0)), [[191, true], [191, false]]);
    await page.locator('[data-key="190"]').tap();
    assert.deepEqual(await page.evaluate(() => events.splice(0)), [[190, true], [190, false]]);
    // Holding is distinct from clicking; cancellation must never leave a key down.
    const right = page.locator('[data-key="39"]');
    const box = await right.boundingBox();
    await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
    await page.mouse.down();
    assert.deepEqual(await page.evaluate(() => events.splice(0)), [[39, true]]);
    await page.evaluate(() => window.dispatchEvent(new Event('blur')));
    assert.deepEqual(await page.evaluate(() => events.splice(0)), [[39, false]]);
    await page.mouse.up();
    assert.deepEqual(await page.evaluate(() => events.splice(0)), []);
    // Assistive / keyboard activation should send one complete key press.
    await right.focus();
    await page.keyboard.press('Enter');
    await page.waitForTimeout(150);
    assert.deepEqual(await page.evaluate(() => events.splice(0)), [[39, true], [39, false]]);
    for (const width of [320, 390, 768, 1280]) {
      await page.setViewportSize({ width, height: 900 });
      const geometry = await page.evaluate(() => {
        const canvas = document.querySelector('canvas').getBoundingClientRect();
        return { width: document.documentElement.scrollWidth, ratio: canvas.width / canvas.height };
      });
      assert.ok(geometry.width <= width, `horizontal overflow at ${width}px`);
      assert.ok(Math.abs(geometry.ratio - 1.6) < 0.01);
    }
    await page.close();
    const deska = await fixture(browser, 'DESKA');
    assert.equal(await deska.locator('[data-key="80"]').first().isVisible(), true);
    assert.equal(await deska.locator('[data-key="190"]').isVisible(), false);
    await deska.locator('summary').click();
    await deska.locator('#letters [data-key="65"]').tap();
    assert.deepEqual(await deska.evaluate(() => events), [[65, true], [65, false]]);
    await deska.close();
    const failed = await fixture(browser, 'HELLO', true);
    assert.equal(await failed.locator('#retry').isVisible(), true);
    assert.equal(await failed.locator('[data-key="32"]').first().isDisabled(), true);
    assert.equal(await failed.locator('#led').getAttribute('class'), null);
    await failed.close();
  } finally {
    await browser.close();
  }
});

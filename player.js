(() => {
  'use strict';
  const arcade = document.querySelector('.arcade');
  const game = arcade.dataset.game;
  const canvas = document.getElementById('jsdos');
  const controls = document.getElementById('controls');
  const boot = document.getElementById('boot');
  const status = document.getElementById('status');
  const led = document.getElementById('led');
  const retry = document.getElementById('retry');
  let ci;
  const held = new Map();

  document.querySelectorAll('[data-for]').forEach(element => {
    element.hidden = element.dataset.for !== game.toUpperCase();
  });
  if (game.toUpperCase() === 'DESKA') {
    document.getElementById('space-label').textContent = 'Start piłki';
    document.getElementById('hint').textContent = '← → ruch deski · Spacja / Enter: start piłki · P: pauza. W menu użyj ↑ ↓ i Spacji.';
  } else if (game.toUpperCase() === 'SAPER') {
    document.getElementById('space-label').textContent = 'Odkryj / wybierz';
    document.getElementById('hint').textContent = 'Strzałki: ruch · Spacja / Enter: odkryj · .: mina · /: pytajnik. W menu wybieraj Spacją.';
  }
  // A real key pad also works with Turbo Pascal ReadLn on touch-only devices.
  const letters = document.getElementById('letters');
  for (const letter of 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') {
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = letter;
    button.dataset.key = letter.charCodeAt(0);
    letters.append(button);
  }
  for (const [label, code] of [['⌫', 8], ['Spacja', 32], ['Enter', 13]]) {
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = label;
    button.setAttribute('aria-label', code === 8 ? 'Usuń literę' : label);
    button.dataset.key = code;
    letters.append(button);
  }
  const buttons = [...document.querySelectorAll('[data-key]')];
  buttons.forEach(button => { button.disabled = true; });

  function press(button, owner) {
    if (!ci || held.has(owner)) return;
    const code = Number(button.dataset.key);
    const alreadyDown = [...held.values()].some(item => item.code === code);
    held.set(owner, { code, button });
    button.classList.add('pressed');
    if (!alreadyDown) ci.simulateKeyEvent(code, true);
  }
  function release(owner) {
    const item = held.get(owner);
    if (!item) return;
    held.delete(owner);
    if (![...held.values()].some(other => other.button === item.button)) item.button.classList.remove('pressed');
    if (![...held.values()].some(other => other.code === item.code)) ci.simulateKeyEvent(item.code, false);
  }
  function releaseAll() {
    [...held.keys()].forEach(release);
  }
  buttons.forEach(button => {
    button.addEventListener('pointerdown', event => {
      if (event.button !== 0 || !ci) return;
      event.preventDefault();
      button.setPointerCapture(event.pointerId);
      press(button, event.pointerId);
    });
    for (const type of ['pointerup', 'pointercancel', 'lostpointercapture']) {
      button.addEventListener(type, event => release(event.pointerId));
    }
    // Native click covers keyboard and assistive-technology activation.
    button.addEventListener('click', event => {
      if (event.detail !== 0 || !ci) return;
      const owner = Symbol('activation');
      press(button, owner);
      setTimeout(() => release(owner), 100);
    });
    // Do not also send the native Enter/Space activation into DOSBox.
    for (const type of ['keydown', 'keyup']) {
      button.addEventListener(type, event => {
        if (event.key === 'Enter' || event.key === ' ') event.stopPropagation();
      });
    }
  });
  window.addEventListener('blur', releaseAll);
  document.addEventListener('visibilitychange', () => { if (document.hidden) releaseAll(); });
  window.addEventListener('pagehide', releaseAll);
  document.getElementById('restart').addEventListener('click', () => { releaseAll(); location.reload(); });
  retry.addEventListener('click', () => location.reload());

  function fail(error) {
    releaseAll();
    ci = undefined;
    controls.disabled = true;
    buttons.forEach(button => { button.disabled = true; });
    led.classList.remove('on');
    boot.hidden = false;
    status.textContent = 'Nie udało się uruchomić gry. Spróbuj ponownie.';
    retry.hidden = false;
    console.error('DOS startup failed:', error);
  }
  async function start() {
    try {
      // Keep the original writable mount and versioned EXE replacement.
      // Storage may be unavailable in privacy mode; it is not required to play.
      try { indexedDB.deleteDatabase('/GRA'); } catch (_) { /* optional cache */ }
      const { fs, main } = await Dos(canvas, {
        onprogress: () => {},
        onerror: fail,
      });
      await fs.extractAll([
        { url: `${game}.ZIP`, mountPoint: `/${game}` },
        { url: arcade.dataset.archive, mountPoint: '/GRA' },
      ]);
      ci = await main([
        '-c', 'KEYB pl',
        '-c', `CD ${game}`,
        '-c', `COPY C:\\GRA\\${arcade.dataset.executable}`,
        '-c', arcade.dataset.executable,
        '-c', '@dir',
      ]);
      controls.disabled = false;
      buttons.forEach(button => { button.disabled = false; });
      boot.hidden = true;
      led.classList.add('on');
    } catch (error) {
      fail(error);
    }
  }
  start();
})();

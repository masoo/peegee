// Shared client helpers for Peegee. Exposed on window.PG.

(function () {
  const isJa = () => document.documentElement.lang === 'ja';

  // Site-specific recipes (constraints match the server-side generators)
  const SITE_EN = {
    kuroneko: { label: 'Kuroneko Members', hint: '8-15 chars · letters + numbers + symbols',  endpoint: '/kuronekoyamato.co.jp.json' },
    nenkin:   { label: 'Nenkin Net',       hint: '20 chars · letters + numbers (no symbols)', endpoint: '/nenkin.go.jp.json' },
    sbisec:   { label: 'SBI Securities',   hint: '10-20 chars · letters + numbers + 2 symbols', endpoint: '/sbisec.co.jp.json' },
    smartex:  { label: 'Smart EX',         hint: '4-8 chars · letters / numbers / symbols',   endpoint: '/smart-ex.jp.json' },
    rakuten:  { label: 'Rakuten Bank',     hint: '8-12 chars · upper + lower + number + symbol', endpoint: '/rakuten-bank.co.jp.json' },
  };
  const SITE_JA = {
    kuroneko: { label: 'クロネコメンバーズ', hint: '8〜15文字 · 英字 + 数字 + 記号',           endpoint: '/kuronekoyamato.co.jp.json' },
    nenkin:   { label: 'ねんきんネット',     hint: '20文字 · 英字 + 数字（記号なし）',          endpoint: '/nenkin.go.jp.json' },
    sbisec:   { label: 'SBI 証券',          hint: '10〜20文字 · 英字 + 数字 + 記号2文字',      endpoint: '/sbisec.co.jp.json' },
    smartex:  { label: 'スマート EX',        hint: '4〜8文字 · 英字 / 数字 / 記号',             endpoint: '/smart-ex.jp.json' },
    rakuten:  { label: '楽天銀行',           hint: '8〜12文字 · 大文字 + 小文字 + 数字 + 記号', endpoint: '/rakuten-bank.co.jp.json' },
  };
  const SITE = new Proxy({}, { get: (_, k) => (isJa() ? SITE_JA : SITE_EN)[k] });

  const STRENGTH_LABELS = {
    en: { dash: '—', weak: 'Weak', fair: 'Fair', strong: 'Strong', veryStrong: 'Very strong' },
    ja: { dash: '—', weak: '弱い',   fair: '普通',  strong: '強い',  veryStrong: '非常に強い' },
  };

  // Strength scoring — rough heuristic 0-4
  function strength(pw) {
    const L = STRENGTH_LABELS[isJa() ? 'ja' : 'en'];
    if (!pw) return { score: 0, label: L.dash };
    const len = pw.length;
    let pool = 0;
    if (/[a-z]/.test(pw)) pool += 26;
    if (/[A-Z]/.test(pw)) pool += 26;
    if (/[0-9]/.test(pw)) pool += 10;
    if (/[^a-zA-Z0-9]/.test(pw)) pool += 30;
    if (/[぀-ゟ]/.test(pw)) pool += 80; // hiragana
    const entropy = Math.log2(Math.max(pool, 1)) * len;
    let score, label;
    if (entropy < 28) { score = 1; label = L.weak; }
    else if (entropy < 50) { score = 2; label = L.fair; }
    else if (entropy < 80) { score = 3; label = L.strong; }
    else { score = 4; label = L.veryStrong; }
    return { score, label, entropy: Math.round(entropy) };
  }

  async function copy(text) {
    try { await navigator.clipboard.writeText(text); return true; }
    catch { return false; }
  }

  window.PG = { strength, copy, SITE, isJa };
})();

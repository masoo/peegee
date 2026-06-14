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
    jal:      { label: 'JAL Mileage Bank', hint: '8+ chars · 2+ of upper/lower/number/symbol', endpoint: '/jal.co.jp.json' },
  };
  const SITE_JA = {
    kuroneko: { label: 'クロネコメンバーズ', hint: '8〜15文字 · 英字 + 数字 + 記号',           endpoint: '/kuronekoyamato.co.jp.json' },
    nenkin:   { label: 'ねんきんネット',     hint: '20文字 · 英字 + 数字（記号なし）',          endpoint: '/nenkin.go.jp.json' },
    sbisec:   { label: 'SBI 証券',          hint: '10〜20文字 · 英字 + 数字 + 記号2文字',      endpoint: '/sbisec.co.jp.json' },
    smartex:  { label: 'スマート EX',        hint: '4〜8文字 · 英字 / 数字 / 記号',             endpoint: '/smart-ex.jp.json' },
    rakuten:  { label: '楽天銀行',           hint: '8〜12文字 · 大文字 + 小文字 + 数字 + 記号', endpoint: '/rakuten-bank.co.jp.json' },
    jal:      { label: 'JALマイレージバンク', hint: '8文字以上 · 大文字/小文字/数字/記号から2種類以上', endpoint: '/jal.co.jp.json' },
  };
  const SITE = new Proxy({}, { get: (_, k) => (isJa() ? SITE_JA : SITE_EN)[k] });

  // zxcvbn score (0-4) → human label, in ascending order.
  const STRENGTH_LABELS = {
    en: { dash: '—', levels: ['Very weak', 'Weak', 'Fair', 'Strong', 'Very strong'] },
    ja: { dash: '—', levels: ['非常に弱い', '弱い', '普通', '強い', '非常に強い'] },
  };

  // Map a server strength result ({ guesses_log10, score }) to display info.
  // The score comes straight from zxcvbn (0-4), so the bars and label stay in
  // sync with what the API and other clients report.
  function strength(result) {
    const L = STRENGTH_LABELS[isJa() ? 'ja' : 'en'];
    if (!result || result.score == null) return { score: 0, label: L.dash, guessesLog10: 0 };
    const score = result.score;
    return {
      score,
      label: L.levels[score] || L.dash,
      guessesLog10: Math.round(result.guesses_log10 || 0),
    };
  }

  async function copy(text) {
    try { await navigator.clipboard.writeText(text); return true; }
    catch { return false; }
  }

  window.PG = { strength, copy, SITE, isJa };
})();

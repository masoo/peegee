// Vanilla JS for the Pico edition. No React.
// Hooks up password generation, mode switching, options bar,
// site presets, and the MCP tabs.

(function () {
  const PG = window.PG;
  const JA = PG.isJa();

  const T = JA ? {
    copy: 'コピー',
    copied: 'コピー済み',
    mcpCopied: '✓ コピー済み',
    needAnother: '他のサービスも必要ですか？',
    requestIt: 'GitHub でリクエスト →',
    snippets: {
      claude: 'コマンド実行後に Claude Code を再起動してください。',
      vscode: 'ファイルを保存し、VS Code を再読み込みしてください。',
      cursor: 'サーバーを反映するには Cursor を再起動してください。',
    },
  } : {
    copy: 'Copy',
    copied: 'Copied',
    mcpCopied: '✓ Copied',
    needAnother: 'Need another service?',
    requestIt: 'Request it on GitHub →',
    snippets: {
      claude: 'Restart Claude Code after running the command.',
      vscode: 'Save the file and reload VS Code window.',
      cursor: 'Restart Cursor for the server to appear.',
    },
  };

  // ---------- Hero generator ----------
  const $out = document.getElementById('pw-output');
  const $bars = document.getElementById('pw-bars');
  const $label = document.getElementById('pw-label');
  const $guesses = document.getElementById('pw-guesses');
  const $copy = document.getElementById('btn-copy');
  const $copyLabel = document.getElementById('btn-copy-label');
  const $regen = document.getElementById('btn-regen');

  function currentMode() {
    return document.querySelector('input[name="mode"]:checked').value;
  }

  // Apply a strength result to a row of 4 bars (shared by hero + site cards).
  function applyBars($barsEl, s) {
    $barsEl.querySelectorAll('.bar').forEach((b, i) => {
      b.classList.remove('on', 'strong');
      if (i < s.score) {
        b.classList.add('on');
        if (s.score >= 3) b.classList.add('strong');
      }
    });
  }

  async function generate() {
    const url = currentMode() === 'japanese' ? '/japanese_secret_questions.json' : '/g.json';
    const res = await fetch(url, { headers: { Accept: 'application/json' } });
    return res.json();
  }

  async function render() {
    const data = await generate();
    $out.textContent = data.password;
    const s = PG.strength(data);
    $label.textContent = s.label;
    $guesses.textContent = s.guessesLog10;
    applyBars($bars, s);
  }

  $regen.addEventListener('click', render);
  document.querySelectorAll('input[name="mode"]').forEach(r =>
    r.addEventListener('change', render)
  );

  $copy.addEventListener('click', async () => {
    const ok = await PG.copy($out.textContent);
    if (!ok) return;
    $copy.classList.add('copied');
    $copyLabel.textContent = T.copied;
    setTimeout(() => {
      $copy.classList.remove('copied');
      $copyLabel.textContent = T.copy;
    }, 1400);
  });

  render();

  // ---------- Japan presets ----------
  const TOP = ['kuroneko', 'sbisec', 'rakuten'];
  const EXTRA = ['nenkin', 'smartex'];
  const $topGrid = document.getElementById('sites-top');
  const $extraGrid = document.getElementById('sites-extra');

  async function sitePassword(id) {
    const rule = PG.SITE[id];
    const res = await fetch(rule.endpoint, { headers: { Accept: 'application/json' } });
    return res.json();
  }

  function siteCardHTML(id) {
    const rule = PG.SITE[id];
    return `
      <article class="site-card" data-site="${id}">
        <header>
          <span class="tag">JP</span>
          <h3>${rule.label}</h3>
        </header>
        <p class="hint">${rule.hint}</p>
        <div class="strength" aria-label="${JA ? 'パスワード強度' : 'Password strength'}">
          <div class="bars">
            <div class="bar"></div><div class="bar"></div><div class="bar"></div><div class="bar"></div>
          </div>
          <strong class="site-strength-label">—</strong>
        </div>
        <div class="pw-row">
          <code class="site-pw">…</code>
          <button class="regen" type="button" title="Regenerate" aria-label="Regenerate">
            <svg width="12" height="12" viewBox="0 0 16 16" fill="none">
              <path d="M13.5 8a5.5 5.5 0 1 1-1.6-3.88M13.5 3v3h-3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
          <button class="primary copy" type="button" title="Copy" aria-label="Copy">⧉</button>
        </div>
      </article>
    `;
  }

  $topGrid.innerHTML = TOP.map(siteCardHTML).join('');
  $extraGrid.innerHTML = EXTRA.map(siteCardHTML).join('') + `
    <div class="request-card">
      ${T.needAnother}<br/>
      <a href="https://github.com/masoo/peegee/issues">${T.requestIt}</a>
    </div>
  `;

  // delegated handlers for all site cards
  document.querySelectorAll('.site-card').forEach(card => {
    const id = card.dataset.site;
    const $pw = card.querySelector('.site-pw');
    const $sbars = card.querySelector('.bars');
    const $slabel = card.querySelector('.site-strength-label');

    async function fill() {
      const data = await sitePassword(id);
      $pw.textContent = data.password;
      const s = PG.strength(data);
      $slabel.textContent = s.label;
      applyBars($sbars, s);
    }

    fill();
    card.querySelector('.regen').addEventListener('click', fill);
    const $copyBtn = card.querySelector('.copy');
    $copyBtn.addEventListener('click', async () => {
      await PG.copy($pw.textContent);
      const orig = $copyBtn.textContent;
      $copyBtn.textContent = '✓';
      setTimeout(() => { $copyBtn.textContent = orig; }, 1200);
    });
  });

  // ---------- Accordion summary swap ----------
  // The label/chevron toggle is handled entirely via CSS using
  // details[open] selectors. No JS needed for the visual swap.

  // ---------- MCP tabs ----------
  const $mcpCode = document.getElementById('mcp-code');
  const $mcpHint = document.getElementById('mcp-hint');
  const $mcpCopy = document.getElementById('mcp-copy');
  // Base URL is injected via data attribute on the <pre> so ERB can supply
  // request.base_url at render time. Falls back to the production URL.
  const MCP_URL =
    ($mcpCode && $mcpCode.closest('pre') && $mcpCode.closest('pre').dataset.mcpUrl) ||
    'https://peegee.masoo.dev/mcp/sse';

  const SNIPPETS = {
    claude: {
      hint: T.snippets.claude,
      html: `<span class="prompt">$</span> claude mcp add --transport sse peegee \\\n    ${MCP_URL}`,
      raw:  `$ claude mcp add --transport sse peegee \\\n    ${MCP_URL}`,
    },
    vscode: {
      hint: T.snippets.vscode,
      html: `// .vscode/mcp.json\n{\n  <span class="str">"servers"</span>: {\n    <span class="str">"Peegee"</span>: {\n      <span class="str">"type"</span>: <span class="str">"sse"</span>,\n      <span class="str">"url"</span>: <span class="str">"${MCP_URL}"</span>\n    }\n  }\n}`,
      raw:  `// .vscode/mcp.json\n{\n  "servers": {\n    "Peegee": {\n      "type": "sse",\n      "url": "${MCP_URL}"\n    }\n  }\n}`,
    },
    cursor: {
      hint: T.snippets.cursor,
      html: `// ~/.cursor/mcp.json\n{\n  <span class="str">"mcpServers"</span>: {\n    <span class="str">"peegee"</span>: {\n      <span class="str">"url"</span>: <span class="str">"${MCP_URL}"</span>\n    }\n  }\n}`,
      raw:  `// ~/.cursor/mcp.json\n{\n  "mcpServers": {\n    "peegee": {\n      "url": "${MCP_URL}"\n    }\n  }\n}`,
    },
  };

  let activeClient = 'claude';

  function setClient(c) {
    activeClient = c;
    $mcpCode.innerHTML = SNIPPETS[c].html;
    $mcpHint.textContent = SNIPPETS[c].hint;
  }
  document.querySelectorAll('input[name="client"]').forEach(r =>
    r.addEventListener('change', () => setClient(r.value))
  );
  setClient('claude');

  $mcpCopy.addEventListener('click', async () => {
    await PG.copy(SNIPPETS[activeClient].raw);
    $mcpCopy.classList.add('copied');
    $mcpCopy.textContent = T.mcpCopied;
    setTimeout(() => {
      $mcpCopy.classList.remove('copied');
      $mcpCopy.textContent = T.copy;
    }, 1400);
  });
})();

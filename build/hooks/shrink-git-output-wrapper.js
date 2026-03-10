// Wrapper so Cursor's piped stdin reaches PowerShell on Windows.
// Usage: node shrink-git-output-wrapper.js
// Reads JSON from stdin, writes to temp file, invokes PS1 with -InputFile.

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const dir = __dirname;
const ps1 = path.join(dir, 'shrink-git-output.ps1');

const STDIN_TIMEOUT_MS = 1500;

function main() {
  if (process.stdin.isTTY) {
    console.log(JSON.stringify({ permission: 'allow' }));
    process.exit(0);
  }
  const chunks = [];
  let done = false;
  function allowAndExit() {
    if (done) return;
    done = true;
    console.log(JSON.stringify({ permission: 'allow' }));
    process.exit(0);
  }
  const t = setTimeout(allowAndExit, STDIN_TIMEOUT_MS);
  process.stdin.on('data', (chunk) => chunks.push(chunk));
  process.stdin.on('end', () => {
    if (done) return;
    done = true;
    clearTimeout(t);
    const input = Buffer.concat(chunks).toString('utf8');
    run(input);
  });
  process.stdin.resume();
}

function run(input) {
  if (!input || !input.trim()) {
    console.log(JSON.stringify({ permission: 'allow' }));
    return;
  }
  const tmp = path.join(dir, '.hook-input-' + Date.now() + '.json');
  try {
    fs.writeFileSync(tmp, input, 'utf8');
    const out = execFileSync(
      'powershell',
      ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ps1, '-InputFile', tmp],
      { encoding: 'utf8', maxBuffer: 1024 * 1024 }
    );
    process.stdout.write(out);
  } catch (e) {
    if (e.stdout) process.stdout.write(e.stdout);
    console.log(JSON.stringify({ permission: 'allow' }));
  } finally {
    try { fs.unlinkSync(tmp); } catch (_) {}
  }
  process.exit(0);
}

main();

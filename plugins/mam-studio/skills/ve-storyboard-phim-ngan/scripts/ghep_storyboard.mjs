#!/usr/bin/env node
// ghep_storyboard.mjs - ghep cac panel storyboard thanh trang PNG bang ffmpeg (chay duoc macOS + Windows, khong can goi them).
// Ban thay the cho ghep_storyboard.ps1 (chi chay Windows). Cung manifest, cung bo cuc.
// Dung:
//   node ghep_storyboard.mjs --manifest <manifest.json> --out <thu_muc> [--cols 3] [--rows 2] [--panel-width 640] [--safezone916] [--font <file.ttf>]
// Manifest (UTF-8): { "title": "...", "panels": [ { "id","frames","framing","action","dialogue","image" } ] }
// "image" tuyet doi hoac tuong doi so voi file manifest. Can ffmpeg trong PATH.
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';

const argv = process.argv.slice(2);
const opt = { cols: 3, rows: 2, 'panel-width': 640, safezone916: false };
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (!a.startsWith('--')) continue;
  const k = a.slice(2);
  if (k === 'safezone916') { opt[k] = true; continue; }
  opt[k] = argv[++i];
}
if (!opt.manifest || !opt.out) {
  console.error('Thieu --manifest hoac --out'); process.exit(2);
}
const manifestPath = path.resolve(opt.manifest);
const baseDir = path.dirname(manifestPath);
const data = JSON.parse(fs.readFileSync(manifestPath, 'utf8').replace(/^\uFEFF/, ''));
const panels = data.panels || [];
if (!panels.length) { console.error('Manifest khong co panel'); process.exit(2); }
const outDir = path.resolve(opt.out); fs.mkdirSync(outDir, { recursive: true });

const cols = +opt.cols, rows = +opt.rows, imgW = +opt['panel-width'];
const imgH = Math.round(imgW * 9 / 16), capH = 150, pad = 24, headerH = 64;
const cellW = imgW, cellH = imgH + capH;
const pageW = pad + cols * (cellW + pad), pageH = headerH + pad + rows * (cellH + pad);

// Font co dau tieng Viet (Arial). Chep vao thu muc tam, goi ten tuong doi de tranh dau ':' trong chuoi filter.
const fontCandidates = [opt.font, 'C:/Windows/Fonts/arial.ttf', '/System/Library/Fonts/Supplemental/Arial.ttf',
  '/Library/Fonts/Arial.ttf', '/usr/share/fonts/truetype/msttcorefonts/Arial.ttf', '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'].filter(Boolean);
const fontSrc = fontCandidates.find(f => fs.existsSync(f));
if (!fontSrc) { console.error('Khong tim thay font Arial. Dung --font <file.ttf>.'); process.exit(2); }

function wrap(text, maxChars, maxLines) {
  const words = String(text || '').split(/\s+/).filter(Boolean); const lines = []; let cur = '';
  for (const w of words) {
    if ((cur + ' ' + w).trim().length > maxChars && cur) { lines.push(cur); cur = w; } else cur = (cur + ' ' + w).trim();
  }
  if (cur) lines.push(cur);
  if (lines.length > maxLines) { lines.length = maxLines; lines[maxLines - 1] = lines[maxLines - 1].replace(/.{0,2}$/, '…'); }
  return lines.join('\n');
}

const perPage = cols * rows, pages = Math.ceil(panels.length / perPage);
for (let p = 0; p < pages; p++) {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'sb_'));
  fs.copyFileSync(fontSrc, path.join(tmp, 'font.ttf'));
  const args = ['-hide_banner', '-loglevel', 'error', '-y', '-f', 'lavfi', '-i', `color=c=white:s=${pageW}x${pageH}:d=1`];
  const fl = []; let last = '0:v'; let inIdx = 1; const texts = [];
  const write = (name, s) => { fs.writeFileSync(path.join(tmp, name), s, 'utf8'); return name; };
  texts.push(`drawtext=fontfile=font.ttf:textfile=${write('title.txt', `${data.title || ''}   |   ${p + 1}/${pages}`)}:expansion=none:fontsize=22:fontcolor=0x141414:x=${pad}:y=24`);
  for (let i = 0; i < perPage; i++) {
    const idx = p * perPage + i; if (idx >= panels.length) break;
    const pn = panels[idx]; const c = i % cols, r = Math.floor(i / cols);
    const x = pad + c * (cellW + pad), y = headerH + pad + r * (cellH + pad);
    let img = pn.image ? String(pn.image) : '';
    if (img && !path.isAbsolute(img)) img = path.join(baseDir, img);
    if (img && fs.existsSync(img)) {
      args.push('-i', img);
      fl.push(`[${inIdx}:v]scale=${imgW}:${imgH}:force_original_aspect_ratio=increase:flags=lanczos,crop=${imgW}:${imgH},setsar=1,format=rgba[p${i}]`);
    } else {
      args.push('-f', 'lavfi', '-i', `color=c=0xE1E1E1:s=${imgW}x${imgH}:d=1`);
      fl.push(`[${inIdx}:v]setsar=1,format=rgba[p${i}]`);
      texts.push(`drawtext=fontfile=font.ttf:textfile=${write(`m${i}.txt`, 'Missing image: ' + (pn.image || ''))}:expansion=none:fontsize=13:fontcolor=0x141414:x=${x + 10}:y=${y + 10}`);
    }
    fl.push(`[${last}][p${i}]overlay=${x}:${y}[b${i}]`); last = `b${i}`; inIdx++;
    texts.push(`drawbox=x=${x}:y=${y}:w=${imgW}:h=${imgH}:color=0x282828:t=2`);
    if (opt.safezone916) { const sw = Math.round(imgH * 9 / 16); texts.push(`drawbox=x=${x + Math.round((imgW - sw) / 2)}:y=${y}:w=${sw}:h=${imgH}:color=0xE62828@0.86:t=2`); }
    const maxChars = Math.floor(imgW / 6.6);
    texts.push(`drawtext=fontfile=font.ttf:textfile=${write(`h${i}.txt`, `${pn.id || ''}    ${pn.frames || ''}    ${pn.framing || ''}`)}:expansion=none:fontsize=15:fontcolor=0x141414:x=${x}:y=${y + imgH + 8}`);
    texts.push(`drawtext=fontfile=font.ttf:textfile=${write(`a${i}.txt`, wrap(pn.action, maxChars, 4))}:expansion=none:fontsize=13:line_spacing=3:fontcolor=0x555555:x=${x}:y=${y + imgH + 32}`);
    if (pn.dialogue) texts.push(`drawtext=fontfile=font.ttf:textfile=${write(`d${i}.txt`, wrap(pn.dialogue, maxChars, 3))}:expansion=none:fontsize=13:line_spacing=3:fontcolor=0x1E468C:x=${x}:y=${y + imgH + 98}`);
  }
  const graph = fl.join(';') + `;[${last}]` + texts.join(',') + '[out]';
  const outFile = path.join(outDir, `storyboard_trang_${String(p + 1).padStart(2, '0')}.png`);
  args.push('-filter_complex', graph, '-map', '[out]', '-frames:v', '1', outFile);
  const r = spawnSync('ffmpeg', args, { cwd: tmp, encoding: 'utf8' });
  fs.rmSync(tmp, { recursive: true, force: true });
  if (r.status !== 0) { console.error(r.stderr || r.error); process.exit(1); }
  console.log('Wrote ' + outFile);
}

#!/usr/bin/env node
// bang_mau_tu_sheet.mjs - rut bang mau chu dao tu mot character sheet (bo nen kem), chay macOS + Windows.
// Dung:  node bang_mau_tu_sheet.mjs <sheet.jpg|png|webp> [--k 6] [--json]
// In ra: mau nen (hex) va k mau chu dao cua nhan vat (hex + ti le %), xep tu nhieu den it.
// Can: ffmpeg trong PATH. Chi doc anh, khong sua file nao.
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';

const argv = process.argv.slice(2);
const file = argv.find(a => !a.startsWith('--'));
const K = +(argv[argv.indexOf('--k') + 1] || 0) || 6;
const asJson = argv.includes('--json');
if (!file || !fs.existsSync(file)) { console.error('Dung: node bang_mau_tu_sheet.mjs <sheet> [--k 6] [--json]'); process.exit(2); }

const W = 344, H = 192;
const r = spawnSync('ffmpeg', ['-v', 'error', '-i', file, '-vf', `scale=${W}:${H}:flags=area,format=rgb24`, '-frames:v', '1', '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-'], { maxBuffer: 64 << 20 });
if (r.status !== 0) { console.error(String(r.stderr || r.error)); process.exit(1); }
const buf = r.stdout;
const px = (x, y) => { const i = (y * W + x) * 3; return [buf[i], buf[i + 1], buf[i + 2]]; };

// Mau nen = trung vi cac diem o mep tren va hai mep ben (nua tren).
const border = [];
for (let x = 0; x < W; x++) border.push(px(x, 1));
for (let y = 0; y < H / 2; y++) { border.push(px(1, y)); border.push(px(W - 2, y)); }
const med = c => border.map(p => p[c]).sort((a, b) => a - b)[border.length >> 1];
const bg = [med(0), med(1), med(2)];
const dist = (a, b) => Math.hypot(a[0] - b[0], a[1] - b[1], a[2] - b[2]);

// Diem cua nhan vat: khac nen ro, bo bong do (xam nhat gan nen) va goc phai duoi (dau sao Gemini).
const pts = [];
for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
  if (x > W - 24 && y > H - 24) continue;
  const p = px(x, y);
  if (dist(p, bg) < 30) continue;
  pts.push(p);
}
if (pts.length < 50) { console.error('Khong tach duoc nhan vat khoi nen.'); process.exit(1); }

// k-means, khoi tao theo phan vi do sang (xac dinh, chay lai ra cung ket qua).
const lum = p => 0.299 * p[0] + 0.587 * p[1] + 0.114 * p[2];
const sorted = [...pts].sort((a, b) => lum(a) - lum(b));
let cent = Array.from({ length: K }, (_, i) => [...sorted[Math.floor((i + 0.5) * sorted.length / K)]]);
let assign = new Array(pts.length).fill(0);
for (let it = 0; it < 25; it++) {
  const sum = cent.map(() => [0, 0, 0, 0]);
  pts.forEach((p, i) => {
    let best = 0, bd = Infinity;
    cent.forEach((c, j) => { const d = dist(p, c); if (d < bd) { bd = d; best = j; } });
    assign[i] = best; const s = sum[best]; s[0] += p[0]; s[1] += p[1]; s[2] += p[2]; s[3]++;
  });
  cent = sum.map((s, j) => s[3] ? [s[0] / s[3], s[1] / s[3], s[2] / s[3]] : cent[j]);
}
const count = cent.map(() => 0); assign.forEach(a => count[a]++);
const hex = c => '#' + c.map(v => Math.round(v).toString(16).padStart(2, '0')).join('');
const out = cent.map((c, j) => ({ hex: hex(c), ti_le: +(100 * count[j] / pts.length).toFixed(1) }))
  .filter(o => o.ti_le > 0).sort((a, b) => b.ti_le - a.ti_le);

if (asJson) console.log(JSON.stringify({ file, nen: hex(bg), mau: out }, null, 2));
else {
  console.log(`Nen: ${hex(bg)}`);
  out.forEach(o => console.log(`${o.hex}  ${String(o.ti_le).padStart(5)} %`));
}

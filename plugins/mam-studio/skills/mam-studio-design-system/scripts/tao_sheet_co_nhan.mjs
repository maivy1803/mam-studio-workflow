#!/usr/bin/env node
// tao_sheet_co_nhan.mjs - ghep ban "co nhan" cho character sheet theo quy chuan Mam_Studio (chay macOS + Windows).
// Tu anh sheet raw 1376x768 tao anh 1376x936: thanh tieu de den 64 px + anh raw + dai nhan trang 104 px
// (nhan tung o, duong ke mo, chan trang). Anh khac co thi thu nho/phong to theo ti le chieu ngang / 1376.
//
// Dung:
//   node tao_sheet_co_nhan.mjs --in <sheet_raw.jpg> --out <sheet_CHOT_co_nhan.jpg> \
//        --title "HEO 1 · ĐEN TRẮNG — character sheet (ĐÃ CHỐT 2026-11-23)" \
//        [--labels "FRONT · Chính diện|BACK · Sau lưng|CHÂN DUNG"] \
//        [--footer "Team-suc-vat · #2.6_Heo · bản người dùng gửi và chốt · 2026-11-23"] \
//        [--x 241,660,1110] [--font-bold <file.ttf>] [--font <file.ttf>] [--ghi-de]
//   --labels mac dinh 3 o; sheet 4 goc: "FRONT · Chính diện|3/4 · Ba phần tư|SIDE · Nghiêng|BACK · Sau lưng".
//   --x: tam ngang (px, theo anh raw) cua tung nhan. Bo trong thi script tu do vi tri nhan vat trong anh.
// Can: ffmpeg trong PATH; font co dau tieng Viet (tu tim Segoe UI / Arial / DejaVu theo he dieu hanh).
// Khong sua anh goc. Khong ghi de file ra da co tru khi them --ghi-de.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const argv = process.argv.slice(2);
const opt = {};
for (let i = 0; i < argv.length; i++) {
  if (!argv[i].startsWith('--')) continue;
  const k = argv[i].slice(2);
  if (k === 'ghi-de') { opt[k] = true; continue; }
  opt[k] = argv[++i];
}
if (!opt.in || !opt.out || !opt.title) {
  console.error('Thieu --in, --out hoac --title. Xem dau file de biet cach dung.'); process.exit(2);
}
const inFile = path.resolve(opt.in), outFile = path.resolve(opt.out);
if (!fs.existsSync(inFile)) { console.error('Khong thay anh vao: ' + inFile); process.exit(2); }
if (inFile === outFile) { console.error('--out phai khac --in (khong sua anh goc).'); process.exit(2); }
if (fs.existsSync(outFile) && !opt['ghi-de']) { console.error('Da co ' + outFile + '. Them --ghi-de neu muon thay.'); process.exit(3); }
const labels = String(opt.labels || 'FRONT · Chính diện|BACK · Sau lưng|CHÂN DUNG').split('|').map(s => s.trim()).filter(Boolean);
const footer = opt.footer || '';

// --- Kich thuoc anh vao
const pr = spawnSync('ffprobe', ['-v', 'error', '-select_streams', 'v:0', '-show_entries', 'stream=width,height', '-of', 'csv=p=0', inFile], { encoding: 'utf8' });
if (pr.status !== 0) { console.error('ffprobe loi: ' + (pr.stderr || pr.error)); process.exit(1); }
const [W, H] = pr.stdout.trim().split(',').map(Number);
const s = W / 1376;
const R = v => Math.max(1, Math.round(v * s));
const TOP = R(64), BAND = R(104);

// --- Font
const pick = list => list.filter(Boolean).find(f => fs.existsSync(f));
const fontBold = pick([opt['font-bold'], 'C:/Windows/Fonts/segoeuib.ttf', 'C:/Windows/Fonts/arialbd.ttf',
  '/System/Library/Fonts/Supplemental/Arial Bold.ttf', '/Library/Fonts/Arial Bold.ttf',
  '/usr/share/fonts/truetype/msttcorefonts/Arial_Bold.ttf', '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf']);
const fontReg = pick([opt.font, 'C:/Windows/Fonts/segoeui.ttf', 'C:/Windows/Fonts/arial.ttf',
  '/System/Library/Fonts/Supplemental/Arial.ttf', '/Library/Fonts/Arial.ttf',
  '/usr/share/fonts/truetype/msttcorefonts/Arial.ttf', '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf']) || fontBold;
if (!fontBold) { console.error('Khong tim thay font dam co dau tieng Viet. Dung --font-bold <file.ttf>.'); process.exit(2); }

// --- Tam ngang cua tung nhan: lay tu --x, khong co thi do tu anh (cot co nhan vat, bo nen kem).
function autoCenters(n) {
  const w = 344, h = Math.max(2, Math.round(344 * H / W));
  const r = spawnSync('ffmpeg', ['-v', 'error', '-i', inFile, '-vf', `scale=${w}:${h}:flags=area,format=rgb24`, '-frames:v', '1', '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-'], { maxBuffer: 64 << 20 });
  if (r.status !== 0) return null;
  const b = r.stdout, at = (x, y) => { const i = (y * w + x) * 3; return [b[i], b[i + 1], b[i + 2]]; };
  const edge = []; for (let x = 0; x < w; x++) edge.push(at(x, 1));
  const med = c => edge.map(p => p[c]).sort((a, z) => a - z)[edge.length >> 1];
  const bg = [med(0), med(1), med(2)];
  const rows = Math.floor(h * 0.72); // bo phan duoi (bong do tren san)
  const active = [];
  for (let x = 0; x < w; x++) {
    let c = 0;
    for (let y = 0; y < rows; y++) { const p = at(x, y); if (Math.hypot(p[0] - bg[0], p[1] - bg[1], p[2] - bg[2]) > 40) c++; }
    active.push(c > rows * 0.04);
  }
  let segs = [];
  for (let x = 0; x < w; x++) {
    if (!active[x]) continue;
    const last = segs[segs.length - 1];
    if (last && x - last[1] === 1) last[1] = x; else segs.push([x, x]); // mot cot trong la da tach o
  }
  segs = segs.filter(([a, z]) => z - a >= w * 0.04);
  while (segs.length > n) { // gop hai doan gan nhau nhat
    let bi = 0, bd = Infinity;
    for (let i = 0; i < segs.length - 1; i++) { const d = segs[i + 1][0] - segs[i][1]; if (d < bd) { bd = d; bi = i; } }
    segs.splice(bi, 2, [segs[bi][0], segs[bi + 1][1]]);
  }
  if (segs.length !== n) return null;
  return segs.map(([a, z]) => Math.round(((a + z + 1) / 2) * W / w));
}
let xs = opt.x ? String(opt.x).split(',').map(v => Math.round(+v)) : autoCenters(labels.length);
if (!xs || xs.length !== labels.length || xs.some(v => !Number.isFinite(v))) {
  if (opt.x) { console.error('--x phai co dung ' + labels.length + ' so.'); process.exit(2); }
  xs = labels.map((_, i) => Math.round((i + 0.5) * W / labels.length));
  console.log('Canh bao: khong do duoc vi tri nhan vat, chia deu ' + labels.length + ' o. Muon chinh thi dung --x.');
}

// --- Ghep bang ffmpeg (font va chu chep vao thu muc tam, goi ten tuong doi de tranh dau ':' trong filter)
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'sheet_'));
try {
  fs.copyFileSync(fontBold, path.join(tmp, 'b.ttf'));
  fs.copyFileSync(fontReg, path.join(tmp, 'r.ttf'));
  const txt = (name, t) => { fs.writeFileSync(path.join(tmp, name), t, 'utf8'); return name; };
  // y cua drawtext la mep tren hop chu; dat duong chan chu de chu hoa nam giua dong: y = tam + 0.35*co - ascent
  const dt = (font, file, size, color, x, cy) =>
    `drawtext=fontfile=${font}:textfile=${file}:expansion=none:fontsize=${size}:fontcolor=${color}:x=${x}:y=${cy}+${(0.35 * size).toFixed(1)}-ascent`;
  const f = [`pad=${W}:${H + TOP + BAND}:0:${TOP}:color=0xFFFFFF`,
    `drawbox=x=0:y=0:w=${W}:h=${TOP}:color=0x222222:t=fill`,
    dt('b.ttf', txt('t.txt', opt.title), R(23), '0xFFFFFF', R(32), R(34))];
  const labelCy = TOP + H + R(37);
  labels.forEach((l, i) => f.push(dt('b.ttf', txt(`l${i}.txt`, l), R(24), '0x222222', `${xs[i]}-text_w/2`, labelCy)));
  f.push(`drawbox=x=${R(24)}:y=${TOP + H + R(70)}:w=${W - 2 * R(24)}:h=${R(1)}:color=0xDCDCDC:t=fill`);
  if (footer) f.push(dt('r.ttf', txt('f.txt', footer), R(14), '0x6E6E6E', R(28), TOP + H + R(88)));
  const ext = path.extname(outFile).toLowerCase();
  const q = ext === '.jpg' || ext === '.jpeg' ? ['-q:v', '2'] : [];
  fs.mkdirSync(path.dirname(outFile), { recursive: true });
  const r = spawnSync('ffmpeg', ['-hide_banner', '-loglevel', 'error', '-y', '-i', inFile, '-vf', f.join(','), '-frames:v', '1', ...q, outFile], { cwd: tmp, encoding: 'utf8' });
  if (r.status !== 0) { console.error(r.stderr || r.error); process.exit(1); }
} finally { fs.rmSync(tmp, { recursive: true, force: true }); }
console.log(`Da tao ${outFile} (${W}x${H + TOP + BAND}); tam nhan: ${xs.join(', ')}`);

#!/usr/bin/env node
// dong_goi_zip.mjs - nen thu muc Mam_Studio_Kit thanh zip kieu Unix (chay macOS + Windows, chi can Node).
// Vi sao: Compress-Archive / ZipArchive cua Windows ghi zip kieu FAT, macOS giai nen ra se mat quyen chay
// cua install.sh / install.command. Bo nen nay ghi "version made by" = Unix va quyen 0755 cho .sh/.command.
// Dung: node cong_cu/dong_goi_zip.mjs [--ra <file.zip>] [--ghi-de]
//   Mac dinh ghi ra <thu muc cha cua kit>/Mam_Studio_Kit_v<VERSION>.zip, ben trong co san thu muc Mam_Studio_Kit/.
import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';
import { fileURLToPath } from 'node:url';

const kit = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const version = fs.readFileSync(path.join(kit, 'VERSION'), 'utf8').trim();
const argv = process.argv.slice(2);
const outArg = argv.includes('--ra') ? argv[argv.indexOf('--ra') + 1] : null;
const out = path.resolve(outArg || path.join(kit, '..', `Mam_Studio_Kit_v${version}.zip`));
if (fs.existsSync(out) && !argv.includes('--ghi-de')) { console.error('Da co ' + out + '. Them --ghi-de neu muon thay.'); process.exit(3); }
const root = 'Mam_Studio_Kit/';
const EXEC = /\.(sh|command)$/i;
const SKIP = /(^|\/)(\.DS_Store|Thumbs\.db|desktop\.ini|\.git|\.gitattributes|\.gitignore)$/i;

const crcTable = new Uint32Array(256).map((_, n) => { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; return c >>> 0; });
const crc32 = buf => { let c = 0xFFFFFFFF; for (const b of buf) c = crcTable[(c ^ b) & 0xFF] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; };
const dos = d => ({ time: (d.getHours() << 11) | (d.getMinutes() << 5) | (d.getSeconds() >> 1), date: ((d.getFullYear() - 1980) << 9) | ((d.getMonth() + 1) << 5) | d.getDate() });

const items = [];
(function walk(dir, rel) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    const p = path.join(dir, e.name), r = rel + e.name;
    if (SKIP.test(r)) continue;
    if (e.isDirectory()) { items.push({ name: root + r + '/', dir: true, mtime: fs.statSync(p).mtime }); walk(p, r + '/'); }
    else if (e.isFile()) items.push({ name: root + r, file: p, mtime: fs.statSync(p).mtime });
  }
})(kit, '');
items.unshift({ name: root, dir: true, mtime: fs.statSync(kit).mtime });

const parts = [], central = []; let offset = 0;
for (const it of items) {
  const name = Buffer.from(it.name, 'utf8');
  const raw = it.dir ? Buffer.alloc(0) : fs.readFileSync(it.file);
  let data = raw, method = 0;
  if (raw.length) { const z = zlib.deflateRawSync(raw, { level: 9 }); if (z.length < raw.length) { data = z; method = 8; } }
  const crc = it.dir ? 0 : crc32(raw), { time, date } = dos(it.mtime);
  const mode = it.dir ? 0o40755 : (EXEC.test(it.name) ? 0o100755 : 0o100644);
  const lh = Buffer.alloc(30);
  lh.writeUInt32LE(0x04034b50, 0); lh.writeUInt16LE(20, 4); lh.writeUInt16LE(0x0800, 6); lh.writeUInt16LE(method, 8);
  lh.writeUInt16LE(time, 10); lh.writeUInt16LE(date, 12); lh.writeUInt32LE(crc, 14);
  lh.writeUInt32LE(data.length, 18); lh.writeUInt32LE(raw.length, 22); lh.writeUInt16LE(name.length, 26); lh.writeUInt16LE(0, 28);
  parts.push(lh, name, data);
  const ch = Buffer.alloc(46);
  ch.writeUInt32LE(0x02014b50, 0); ch.writeUInt16LE((3 << 8) | 20, 4); ch.writeUInt16LE(20, 6); ch.writeUInt16LE(0x0800, 8);
  ch.writeUInt16LE(method, 10); ch.writeUInt16LE(time, 12); ch.writeUInt16LE(date, 14); ch.writeUInt32LE(crc, 16);
  ch.writeUInt32LE(data.length, 20); ch.writeUInt32LE(raw.length, 24); ch.writeUInt16LE(name.length, 28);
  ch.writeUInt16LE(0, 30); ch.writeUInt16LE(0, 32); ch.writeUInt16LE(0, 34); ch.writeUInt16LE(it.dir ? 0x10 : 0, 36);
  ch.writeUInt32LE(((mode << 16) | (it.dir ? 0x10 : 0)) >>> 0, 38); ch.writeUInt32LE(offset, 42);
  central.push(ch, name);
  offset += 30 + name.length + data.length;
}
const cdSize = central.reduce((s, b) => s + b.length, 0);
const end = Buffer.alloc(22);
end.writeUInt32LE(0x06054b50, 0); end.writeUInt16LE(items.length, 8); end.writeUInt16LE(items.length, 10);
end.writeUInt32LE(cdSize, 12); end.writeUInt32LE(offset, 16);
fs.writeFileSync(out, Buffer.concat([...parts, ...central, end]));
const nFiles = items.filter(i => !i.dir).length;
console.log(`Da nen ${nFiles} file -> ${out} (${(fs.statSync(out).size / 1048576).toFixed(2)} MB)`);

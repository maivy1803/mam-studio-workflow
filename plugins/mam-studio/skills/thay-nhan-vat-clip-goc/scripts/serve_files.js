// 127.0.0.1-only helper: GET serves files from <serveDir>; POST /save?name=<file> stores the body into <outDir>.
const http = require('http'), fs = require('fs'), path = require('path');
const root = path.resolve(process.argv[2]); const outDir = path.resolve(process.argv[3]); const port = +process.argv[4] || 8765;
const types = { '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.png': 'image/png', '.mp4': 'video/mp4', '.webp': 'image/webp' };
http.createServer((req, res) => {
  const h = { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Private-Network': 'true', 'Access-Control-Allow-Headers': '*', 'Access-Control-Allow-Methods': 'GET,POST,OPTIONS' };
  if (req.method === 'OPTIONS') { res.writeHead(204, h); return res.end(); }
  const u = new URL(req.url, 'http://127.0.0.1');
  if (req.method === 'POST' && u.pathname === '/save') {
    const name = path.basename(u.searchParams.get('name') || 'out.bin');
    const chunks = []; req.on('data', c => chunks.push(c)).on('end', () => {
      const buf = Buffer.concat(chunks); fs.writeFileSync(path.join(outDir, name), buf);
      console.log('saved', name, buf.length); res.writeHead(200, h); res.end('ok ' + buf.length);
    }); return;
  }
  const p = path.join(root, decodeURIComponent(u.pathname));
  if (!p.startsWith(root) || !fs.existsSync(p) || fs.statSync(p).isDirectory()) { res.writeHead(404, h); return res.end('404'); }
  res.writeHead(200, { ...h, 'Content-Type': types[path.extname(p).toLowerCase()] || 'application/octet-stream', 'Content-Length': fs.statSync(p).size });
  fs.createReadStream(p).pipe(res);
}).listen(port, '127.0.0.1', () => console.log('serving', root, 'saving to', outDir, 'on', port));

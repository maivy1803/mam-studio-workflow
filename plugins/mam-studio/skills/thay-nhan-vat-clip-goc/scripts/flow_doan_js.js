// Cac doan JS chay trong tab Google Flow (trinh duyet cua app, cong cu javascript_tool).
// Moi doan la MOT lan goi javascript_tool (chay rieng, co the dung await). Moi lan goi bi gioi han ~45 s:
// vong cho dai thi chia nhieu lan goi. Neu tab Flow khong o phia truoc, luon truyen tabId.
// Truoc khi dung: chay server tren may (cung thu muc scripts):
//   node serve_files.js <thu_muc_phuc_vu> <thu_muc_luu> 8765
// Trang Flow fetch duoc http://127.0.0.1 (KHONG phai localhost) khi co {targetAddressSpace:'local'}.

// ---------- 1. Tai file tu may len luoi media cua project (anh hoac mp4) ----------
const files = [['ten_anh.jpg', 'image/jpeg'] /*, ['doan.mp4','video/mp4'] */];
const dt = new DataTransfer();
for (const [n, t] of files) {
  const buf = await (await fetch('http://127.0.0.1:8765/' + n, { targetAddressSpace: 'local' })).arrayBuffer();
  dt.items.add(new File([buf], n, { type: t }));
}
const x = Math.round(innerWidth * 0.6), y = Math.round(innerHeight * 0.45); // phai roi vao luoi media
const el = document.elementFromPoint(x, y);
for (const t of ['dragenter', 'dragover', 'drop']) {
  el.dispatchEvent(new DragEvent(t, { bubbles: true, cancelable: true, composed: true, dataTransfer: dt, clientX: x, clientY: y }));
  await new Promise(r => setTimeout(r, 200));
}
// Lan dau tai video, Flow hien hop "Rights to use this video": phai hoi nguoi dung truoc khi bam.

// ---------- 2. Chinh khung tao: Image/Video, Frames, 9:16, 720p, x1, do dai ----------
{
  const tr = [...document.querySelectorAll('button')].find(e => e.getAttribute('aria-label') === 'Settings trigger');
  tr.click(); await new Promise(r => setTimeout(r, 900));
  const pick = (txt) => { const r = [...document.querySelectorAll('[role=radio]')].find(e => e.innerText.replace(/\s+/g, ' ').trim().endsWith(txt)); if (r) { r.click(); return txt + ':ok'; } return txt + ':none'; };
  const out = [pick('Video')]; await new Promise(r => setTimeout(r, 900)); // hoac 'Image' cho anh (Nano Banana, 0 credit)
  out.push(pick('Frames')); out.push(pick('9:16')); out.push(pick('720p')); out.push(pick('x1')); // luon x1
  // Thanh Length: gia tri 0..12 = 3..15 giay (vd 7 = 10 s, 9 = 12 s, 12 = 15 s)
  const inp = [...document.querySelectorAll('input[type=range]')].find(x => x.getAttribute('aria-label') === 'Length');
  if (inp) { Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(inp, '7'); inp.dispatchEvent(new Event('input', { bubbles: true })); inp.dispatchEvent(new Event('change', { bubbles: true })); }
  await new Promise(r => setTimeout(r, 600));
  const info = document.body.innerText.match(/Generating will use \d+ credits/); // gia hien ngay trong bang
  tr.click(); // dong bang; KHONG bam Escape o trang sua video (Escape thoat ra luoi)
  JSON.stringify({ out, info: info && info[0] });
}

// ---------- 3. Gan anh tham chieu (ingredients) theo ten ----------
{
  const names = ['Cow standing in room', 'bo_bia_chinh_dien.jpg']; const out = [];
  const openPanel = async () => { if (document.querySelectorAll('[role=option]').length) return; const b = [...document.querySelectorAll('button')].find(e => e.getAttribute('aria-label') === 'Add ingredients to the prompt box'); b.click(); await new Promise(r => setTimeout(r, 1200)); };
  for (const name of names) {
    await openPanel();
    const o = [...document.querySelectorAll('[role=option]')].find(o => o.innerText.includes(name));
    if (!o) { out.push(name + ':khong thay'); continue; }
    o.click(); await new Promise(r => setTimeout(r, 900));
    const add = [...document.querySelectorAll('*')].find(e => e.childElementCount === 0 && e.textContent.trim() === 'Add to prompt');
    if (add) (add.closest('button') || add).click();
    out.push(name + ':ok'); await new Promise(r => setTimeout(r, 900));
  }
  JSON.stringify({ out, gan: [...document.querySelectorAll('img')].filter(i => (i.alt || '') === 'Ingredient image').length });
}

// ---------- 4. Dat khung dau (Start) theo ten anh trong project ----------
{
  [...document.querySelectorAll('button')].find(b => b.innerText.trim() === 'Start').click();
  await new Promise(r => setTimeout(r, 1300));
  const o = [...document.querySelectorAll('[role=option]')].find(o => o.innerText.includes('Cow standing on sidewalk'));
  o.click(); await new Promise(r => setTimeout(r, 1200));
}

// ---------- 5. Dat con tro vao o lenh (sau do go bang computer action=type) ----------
{
  // O lenh chinh: aria-label 'What do you want to create?'; trang sua video: 'Describe how to edit this video…'
  const tb = [...document.querySelectorAll('[contenteditable=true]')].find(e => /create|edit this video/i.test(e.getAttribute('aria-label') || ''));
  tb.focus(); const r = document.createRange(); r.selectNodeContents(tb); r.collapse(false);
  const s = getSelection(); s.removeAllRanges(); s.addRange(r);
  document.activeElement.getAttribute('aria-label');
  // Sau khi go: kiem tb.innerText.length dung so ky tu. Bam gui bang find('Start generation') + computer left_click theo ref
  // (bam bang JS .click() co luc khong an khi tab o phia sau).
}

// ---------- 6. Xem gia o trang sua video (menu model) ----------
{
  const m = [...document.querySelectorAll('button')].find(e => e.getAttribute('aria-label') === 'Select model family');
  m.click(); await new Promise(r => setTimeout(r, 900));
  const menu = [...document.querySelectorAll('[role=menu]')].map(e => e.innerText.replace(/\s+/g, ' ')).join(' | ');
  const bd = document.querySelector('.cdk-overlay-backdrop'); if (bd) bd.click();
  menu; // vd "Omni 1.2 Flash ... Generating will use 30 credits"
}

// ---------- 7. Cho render (goi lai nhieu lan, moi lan < 45 s) ----------
{
  let st = ''; for (let i = 0; i < 9; i++) {
    await new Promise(r => setTimeout(r, 4000)); const t = document.body.innerText;
    const p = t.match(/\b\d{1,3}%/g) || []; if (/Failed/i.test(t)) { st = 'FAIL ' + t.slice(t.indexOf('Failed'), t.indexOf('Failed') + 200); break; }
    if (!p.length) { st = 'xong'; break; } st = 'dang chay ' + p.join(',');
  } st;
}

// ---------- 8. Keo video ve may: o trang /edit/<id>, bam ban (history) can lay roi bat URL trong performance ----------
{
  // Lich su ban sua nam cot phai (x ~874). Ban moi nhat o duoi cung (y lon nhat).
  const items = [...document.querySelectorAll('img')].filter(im => { const r = im.getBoundingClientRect(); return r.x > 550 && r.width > 80 && /video thumbnail/i.test(im.alt || ''); })
    .map(im => { const r = im.getBoundingClientRect(); return { x: Math.round(r.x + r.width / 2), y: Math.round(r.y + r.height / 2) }; }).sort((a, b) => b.y - a.y);
  performance.clearResourceTimings();
  const it = items[0]; const el = document.elementFromPoint(it.x, it.y);
  (el.closest('a,button,[role=button],[role=option],[role=listitem]') || el).click();
  let us = []; for (let k = 0; k < 12; k++) { await new Promise(r => setTimeout(r, 1000)); us = [...new Set(performance.getEntriesByType('resource').map(e => e.name).filter(n => /flow-content\.google\/video\//.test(n)))]; if (us.length) break; }
  const out = [];
  for (const u of us) {
    const id = u.split('/video/')[1].split('?')[0]; const b = await (await fetch(u)).blob();
    const sv = await fetch('http://127.0.0.1:8765/save?name=ten_ra_' + id.slice(0, 8) + '.mp4', { method: 'POST', body: b, targetAddressSpace: 'local' });
    out.push(id.slice(0, 8) + ' ' + b.size + ' ' + await sv.text());
  } JSON.stringify(out);
  // Neu khong bat duoc (video da nap truoc do): tai lai trang roi lam lai. Cach du phong: va fetch/XHR de bat chuoi
  // 'flow-content.google/video/<id>?Expires=..&KeyName=..&Signature=..' trong phan hoi (\\u003d -> '=', \\u0026 -> '&').
}

// ---------- 9. Keo anh full-res (trang /edit/<id> cua anh) ----------
{
  const i = [...document.querySelectorAll('img')].filter(i => i.naturalWidth >= 700).sort((a, b) => b.naturalWidth - a.naturalWidth)[0];
  const blob = await (await fetch(i.src)).blob();
  const sv = await fetch('http://127.0.0.1:8765/save?name=anh_ra.jpg', { method: 'POST', body: blob, targetAddressSpace: 'local' });
  i.naturalWidth + 'x' + i.naturalHeight + ' ' + blob.size + ' ' + await sv.text(); // 768x1376 cho 9:16
}

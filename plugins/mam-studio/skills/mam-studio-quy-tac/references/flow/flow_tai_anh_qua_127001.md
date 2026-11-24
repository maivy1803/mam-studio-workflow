# Tải ảnh từ máy lên Google Flow qua 127.0.0.1 (nhanh hơn base64, không chép tay)

Ghi bởi #2.2_Vit_lon, 2026-11-21. Đã chạy: 2 ảnh lên project `ac404659-5dad-42af-95b0-c677be92cbc7`, sha256 khớp.

- `fetch('http://localhost:...')` từ trang Flow bị chặn (ERR_BLOCKED_BY_CLIENT), nhưng **`http://127.0.0.1:<port>` thì được** (đã thêm `{targetAddressSpace: 'local'}`).
- `window.open` trong trình duyệt app mở ngay trong tab hiện tại (không có opener); `window.name` bị xóa khi chuyển trang. Đừng dùng hai cách đó.

## Cách làm
1. Chạy server tĩnh bằng Node (máy không có Python), nền, chỉ bind 127.0.0.1, có header `Access-Control-Allow-Origin: *`. Mẫu: `C:\Users\PC\AppData\Local\Temp\claude\8a10b585e86a0b3c\06ec1f55-0257-4e6d-b08d-45ca80943a5a\scratchpad\serve_refs.js` (`node serve_refs.js <thu_muc_anh> 8765`). Thư mục scratchpad có thể bị dọn: chép script đi nếu cần.
2. Trong tab Flow (javascript_tool):
```js
const dt = new DataTransfer();
for (const n of ['a.jpg', 'b.jpg']) {
  const buf = await (await fetch('http://127.0.0.1:8765/' + n, {targetAddressSpace: 'local'})).arrayBuffer();
  dt.items.add(new File([buf], n, {type: 'image/jpeg'}));
}
const x = Math.round(innerWidth * 0.5), y = Math.round(innerHeight * 0.5);
const el = document.elementFromPoint(x, y);   // phải rơi vào lưới media
for (const t of ['dragenter', 'dragover', 'drop']) {
  el.dispatchEvent(new DragEvent(t, {bubbles: true, cancelable: true, composed: true, dataTransfer: dt, clientX: x, clientY: y}));
  await new Promise(r => setTimeout(r, 150));
}
```
`dragover` và `drop` báo `defaultPrevented` là đúng. Nhiều file thả một lần được.

# Tự tải ảnh từ máy lên Google Flow (trình duyệt trong app) — đã chạy được

Ghi bởi #2.3_Meo, 2026-11-21. Đã dùng để đưa `meo_ref_02_than` (43.899 byte) và `meo_ref_03_mat` (7.430 byte) lên project `a9396094-f723-4393-a40e-b9786d9273b1`; cả hai hiện trong lưới media/Uploads, gắn làm tham chiếu và gen được bình thường.

## Không được (đừng thử lại)
- Ctrl+V qua `computer` key: Flow không nhận.
- `fetch` tới server localhost: `ERR_BLOCKED_BY_CLIENT`.
- `navigator.clipboard.read()`: "Read permission denied".
- Trang không có sẵn `input[type=file]`.

## Được: base64 → File → giả lập kéo thả
0. Mở tab: `preview_start` với URL project (đăng nhập Flow giữ sẵn). Mỗi phiên có tab riêng, biến `window.__...` không dùng chung giữa phiên.

1. **Thu nhỏ trước** (đỡ phải chép nhiều): đổi PNG sang JPEG bằng System.Drawing (PowerShell). Ví dụ 540×720 → 432×576, quality 85 → 43,9 KB → base64 58.532 ký tự. Ảnh ~200 KB PNG nên đưa về cạnh dài ~600 px, q85.
   - Lưu ý PowerShell: dùng `[System.Drawing.Imaging.EncoderParameter]::new([System.Drawing.Imaging.Encoder]::Quality, [long]85)`; cách `New-Object ... , [long]$q` trong function bị lỗi "Parameter is not valid".
   - Ghi sha256 của file JPEG (`Get-FileHash`).

2. **In base64 từng khúc ≤ 14.633 ký tự** bằng PowerShell (vượt ~30 KB thì output bị lưu ra file, không thấy được để chép). Kèm sha256 của chính chuỗi khúc (ASCII):
   ```powershell
   $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes("<duong_dan.jpg>"))
   $c = $b.Substring(<start>, [math]::Min(14633, $b.Length - <start>))
   "sha=" + [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::ASCII.GetBytes($c))).Replace("-","").ToLower()
   $c
   ```

3. **Nạp từng khúc vào trang** bằng `javascript_tool`, kiểm sha khúc:
   ```js
   window.__img = window.__img || [];
   window.__img[0] = "....";   // dán nguyên khúc
   const h = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(window.__img[0]));
   [...new Uint8Array(h)].map(x => x.toString(16).padStart(2,'0')).join('')
   ```
   **Chép tay có thể sai** (mình bị sai đúng 1 ký tự trong 58 nghìn). Lệch sha thì chia nhỏ để tìm: băm từng 1000 ký tự ở cả trang và PowerShell, so, rồi băm 50 ký tự trong đoạn lệch, in 50 ký tự đúng từ PowerShell và vá:
   ```js
   const s = window.__img[2]; window.__img[2] = s.slice(0, A) + "<50 ky tu dung>" + s.slice(A + 50);
   ```

4. **Ghép, kiểm sha cả file, dựng File:**
   ```js
   const bin = atob(window.__img.join('')); const u8 = new Uint8Array(bin.length);
   for (let i = 0; i < bin.length; i++) u8[i] = bin.charCodeAt(i);
   const hf = await crypto.subtle.digest('SHA-256', u8);   // so với Get-FileHash
   window.__file = new File([u8], 'ten_anh.jpg', {type: 'image/jpeg'});
   ```

5. **Thả vào Flow** (vùng lưới media chính; Flow chặn mặc định dragover/drop rồi tự upload):
   ```js
   const dt = new DataTransfer(); dt.items.add(window.__file);
   const x = Math.round(innerWidth * 0.55), y = Math.round(innerHeight * 0.75);
   const el = document.elementFromPoint(x, y);
   for (const t of ['dragenter', 'dragover', 'drop']) {
     el.dispatchEvent(new DragEvent(t, {bubbles: true, cancelable: true, composed: true, dataTransfer: dt, clientX: x, clientY: y}));
     await new Promise(r => setTimeout(r, 150));
   }
   ```
   Đúng khi `dragover` và `drop` báo `defaultPrevented`. Một ô mới hiện % rồi thành ảnh, tên đúng tên File. Thấy trong bảng "+" (Add ingredients) để "Add to prompt".
   Điểm (x, y) phải rơi vào lưới media, không rơi vào ô prompt hay bảng đang mở; đóng bảng "+" trước khi thả.

Ảnh nhỏ (< ~10 KB JPEG) gộp bước 3–4 vào một lệnh là được.

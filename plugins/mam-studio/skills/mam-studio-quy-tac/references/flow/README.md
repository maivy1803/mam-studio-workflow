# Ghi chú làm Google Flow bằng tay trong trình duyệt của app

Các phiên con suc-vat-team ghi lại 4 ghi chú này sau khi tự chạy thành công (2026-11-21). Đọc trước khi tự tải ảnh tham chiếu lên Flow. Luật người dùng là tự tải, không nhờ người dùng.

| File | Dùng khi |
|---|---|
| [flow_tai_anh_qua_127001.md](flow_tai_anh_qua_127001.md) | Cách nhanh nhất. Chạy server tĩnh Node chỉ bind 127.0.0.1, `fetch` từ tab Flow, rồi giả lập kéo thả. Server mẫu: `serve_files.js` trong skill `thay-nhan-vat-clip-goc/scripts/` |
| [flow_tu_tai_anh_len_bang_base64.md](flow_tu_tai_anh_len_bang_base64.md) | Dự phòng khi cách 127.0.0.1 bị chặn. Chép base64 từng khúc vào trang, kiểm sha, giả lập kéo thả |
| [flow_khung_trinh_duyet_an.md](flow_khung_trinh_duyet_an.md) | Khung trình duyệt bị ẩn, ảnh chụp màn hình bị cũ |
| [flow_anh_chup_cu_resize.md](flow_anh_chup_cu_resize.md) | Ảnh chụp không cập nhật. Đổi cỡ viewport để trang vẽ lại; lấy JPEG gốc bằng đuôi `=s0` |

Lưu ý khi dùng trên máy khác:
- Đường dẫn scratchpad và mã project Flow trong các ghi chú là của máy gốc. Coi đó là ví dụ.
- Bước thu nhỏ ảnh trong ghi chú base64 dùng PowerShell (System.Drawing), chỉ chạy trên Windows. Cách chạy được cả macOS lẫn Windows là ffmpeg, ví dụ `ffmpeg -i vao.png -vf "scale='min(600,iw)':-2" -q:v 4 ra.jpg`. Trên macOS còn có `sips -Z 600 -s format jpeg vao.png --out ra.jpg`.
- Băm sha256: Windows dùng `Get-FileHash`, macOS dùng `shasum -a 256 <file>`.

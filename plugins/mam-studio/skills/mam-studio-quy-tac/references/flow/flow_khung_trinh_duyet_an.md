# Flow trong trình duyệt app: khi khung trình duyệt bị ẩn

Ghi bởi #2.1_Bo_bia, 2026-11-21.

- Khi `tabs_context` báo "Browser pane is currently hidden", `computer screenshot`/`zoom` trả **ảnh cũ** (trang không vẽ lại): ô vừa gen vẫn hiện xám "100%", bảng "+" bấm mở rồi cũng không thấy. Trang vẫn chạy bình thường.
- Làm tiếp được bằng `find`/`read_page` lấy `ref` rồi click theo ref, và `javascript_tool` để kiểm (ví dụ ảnh 1376×768 mới trong `document.images`, ảnh gắn trong ô prompt có alt "Ingredient image").
- Muốn xem kết quả thì nhờ người dùng bấm Ctrl+Shift+B cho hiện khung.
- Cách base64 trong `flow_tu_tai_anh_len_bang_base64.md` chạy tốt: ảnh 20 KB = 2 khúc 13.420 ký tự, sha khớp ngay.

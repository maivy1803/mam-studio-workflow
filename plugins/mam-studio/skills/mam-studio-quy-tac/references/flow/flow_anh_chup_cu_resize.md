# Flow: ảnh chụp màn hình bị cũ → đổi cỡ viewport để vẽ lại

Ghi bởi #2.4_Ga, 2026-11-21.

- Kể cả khi `tabs_context` báo khung "displayed", `computer screenshot` có thể trả ảnh cũ (ô gen vẫn hiện "13%" dù đã xong, chuyển trang mà ảnh không đổi).
- Cách chữa không cần người dùng: gọi `resize_window` với cỡ tùy chỉnh (vd 1600×1000), chụp lại là thấy trang mới. Lần sau đổi 1–2 px (1600×1002 ↔ 1600×1000) để buộc vẽ lại. Xong thì `resize_window` preset "desktop".
- Ở trang sửa ảnh (`/edit/<media>`), ảnh chính đôi khi không tải sau khi bấm qua lại; `navigate` lại đúng URL đó là hiện.
- Lấy JPEG gốc của ảnh Flow: src ảnh có đuôi `=s1600-rw` (webp); thay đuôi thành `=s0` → JPEG 1376×768.

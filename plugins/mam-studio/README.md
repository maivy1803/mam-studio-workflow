# mam-studio (plugin)

Plugin Claude Code cho dự án Mam_Studio / series Halo_Cub. Gồm 4 skill:
- `mam-studio-quy-tac`: quy tắc điều phối 6 Session, các luật người dùng đã dặn, bảng nhân vật đã chốt. Kèm bản sao bộ nhớ và ghi chú tự tải ảnh lên Google Flow.
- `thay-nhan-vat-clip-goc`: đưa nhân vật Halo_Cub vào clip gốc có thoại, giữ tiếng gốc.
  - Các bước: nghiên cứu clip, dựng bằng Google Flow, phông xanh, đặt đúng tỉ lệ thật, sửa mắt, sửa khớp miệng.
  - Có script bash và Node chạy được cả macOS lẫn Windows.
- `ve-storyboard-phim-ngan`: vẽ storyboard từ shotlist.
- `mam-studio-design-system`: quy chuẩn hình ảnh của studio (style series, character sheet, bản có nhãn, bảng màu nhân vật, đặt tên file). Có script ghép nhãn sheet và script rút bảng màu.

Khi cài dạng plugin, gọi skill bằng `/mam-studio:<tên-skill>`.

**Cách cài**
- Dùng trình cài của bộ Mam_Studio_Kit: `install.sh` hoặc `install.ps1` với `--mode plugin`.
- Hoặc cài tay:
  ```
  claude plugin marketplace add <đường dẫn tới thư mục Mam_Studio_Kit>
  claude plugin install mam-studio@mam-studio-kit
  ```
- Trong phiên Claude Code: `/plugin marketplace add <đường dẫn>` rồi `/plugin install mam-studio@mam-studio-kit`.

Cần ffmpeg (bản có bộ lọc whisper để chép lời) và Node.js. Xem README ở thư mục gốc của bộ cài.

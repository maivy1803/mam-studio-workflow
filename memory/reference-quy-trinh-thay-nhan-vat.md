---
name: reference-quy-trinh-thay-nhan-vat
description: "Quy trình đã đóng gói để đưa nhân vật Halo_Cub vào clip gốc có thoại (giữ tiếng gốc, đúng tỉ lệ thật), kèm script đã chạy thử"
metadata:
  node_type: memory
  type: reference
  originSessionId: cd6ce37f-e2ca-4fd0-ac34-990fdeaa365f
  modified: 2026-11-23T06:38:58.183Z
---

Người dùng yêu cầu đóng gói quy trình ngày 2026-11-23. File chính: `Halo_Cub/Uong-oi-e/quy_trinh/quy_trinh_thay_nhan_vat_clip_goc.md`.

Script trong `quy_trinh/scripts/` (đều đã chạy thử lại trên tập Uong-oi-e):
- `nghien_cuu_clip.sh`: thông số, điểm cắt, bảng khung, whisper, độ lớn giọng.
- `serve_files.js`: server 127.0.0.1 có `/save`.
- `flow_doan_js.js`: các đoạn JS cho tab Flow.
- `ghep_v1_dung_moi.sh` và `ghep_phong_xanh_ty_le_that.sh`: ghép bản nháp.
- `tim_do_tre_mieng.sh` và `sua_khop_mieng_doan.sh`: sửa khớp miệng một cảnh.

Dùng khi làm tập mới dựa trên clip gốc. Đọc file này trước, rồi chỉnh tham số (điểm cắt, tỉ lệ, nhịp cận mặt) theo clip mới.

Liên quan: [[mam-studio-production-workflow]], [[feedback-google-flow-trinh-duyet-app]], [[reference-whisper-ffmpeg]]

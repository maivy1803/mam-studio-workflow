# Design system Mam_Studio / Halo_Cub

Có hai bản, cùng nội dung:

1. **Tài liệu trong gói**:
   - [quy_chuan_hinh_anh.md](quy_chuan_hinh_anh.md): style series, bố cục character sheet, bản có nhãn, bảng màu nhân vật, đặt tên file, khối prompt style.
   - Claude đọc bản này qua skill `mam-studio-design-system`. Skill có thêm script ghép nhãn sheet và script rút bảng màu.
2. **Trang Design System trên claude.ai**: https://claude.ai/artifact/FTKDxFtAASthBFtXpbcm7E
   - Trang có token màu, kiểu chữ, kích thước, ảnh 7 sheet chốt và component SheetCoNhan.
   - Trang riêng tư: chỉ tài khoản chủ dự án mở được. Muốn người khác xem thì chủ chia sẻ từ menu Share của trang.
   - Thư mục `ban_sao_trang_claude_ai/` giữ bản sao `README.md` và `tokens.json` của trang, phòng khi không mở được link.

Khi chốt nhân vật mới:
- Thêm một dòng vào bảng màu trong `quy_chuan_hinh_anh.md`.
- Nhờ Claude cập nhật trang claude.ai (thêm token màu và ảnh sheet).

---
name: reference-bo-cai-mam-studio-kit
description: "Bộ cài Mam_Studio_Kit (macOS + Windows): 4 skill (có design system), bộ nhớ, sheet nhân vật, trang Design System trên claude.ai; nằm ở Mam_studio/_bo_cai/, cách cập nhật và nén lại"
metadata:
  node_type: memory
  type: reference
  originSessionId: cd6ce37f-e2ca-4fd0-ac34-990fdeaa365f
  modified: 2026-11-24T05:12:32.474Z
---

Người dùng yêu cầu ngày 2026-11-24: "đóng gói đầy đủ nhất… memory, skill, tài nguyên… bộ cài cho cả mac và window", thêm mục "Design system" (người dùng chọn: cả tài liệu trong gói lẫn trang trên claude.ai).

**Vị trí:**
- Thư mục: `Mam_studio/_bo_cai/Mam_Studio_Kit/`. Bản hiện tại: 1.2.0. Bản này thêm 12 ảnh tham chiếu đã khóa, sau khi soát 961 ảnh trong dự án:
  - Vịt: concept 4 góc và 6 biểu cảm.
  - Bò: sheet 4 góc nguồn và biểu cảm B05.
  - Bản có nhãn của 6 con.
  - Ảnh style Bò + Vịt.
  - Ảnh nguồn bếp Rau_cau.
- Thằn lằn: người dùng chọn bỏ (2026-11-24), không đưa vào bộ cài; sheet cũ chỉ còn trong `02_character_sheet_SESSION_ZIP_2026-11-21.zip`. Còn treo: ảnh mẫu ô bình luận còn tên người thật (chưa làm mờ).
- File nén: `Mam_studio/_bo_cai/Mam_Studio_Kit_v<version>.zip`. Bản 1.0.0 cũ vẫn để cạnh.
- Trang Design System (riêng tư): https://claude.ai/artifact/FTKDxFtAASthBFtXpbcm7E

**Nội dung:**
- 4 skill trong `plugins/mam-studio/skills/`:
  - `mam-studio-quy-tac`: kèm bản sao bộ nhớ và 4 ghi chú tự tải ảnh lên Flow.
  - `thay-nhan-vat-clip-goc`.
  - `ve-storyboard-phim-ngan`: có `ghep_storyboard.mjs` chạy được cả hai hệ điều hành.
  - `mam-studio-design-system`: quy chuẩn hình ảnh, `tao_sheet_co_nhan.mjs`, `bang_mau_tu_sheet.mjs`.
- Plugin và marketplace nội bộ `mam-studio-kit`.
- `memory/`, `tai_nguyen/` (sheet chốt, design_system, ví dụ Uong-oi-e, mẫu `CLAUDE.md`).
- `install.*`, `uninstall.*`:
  - Hỏi trước khi thay file không phải do bộ cài đặt, có sao lưu bản cũ.
  - Ghi sổ `~/.claude/mam-studio-kit.install.txt` từng file đã đặt kèm sha256.
  - Uninstall chỉ gỡ theo sổ. File đã sửa sau khi cài thì giữ lại.

**Khi đổi skill, bộ nhớ hay sheet nhân vật:**
1. Chép bản mới vào thư mục kit.
2. Tăng `VERSION`, `version` trong `plugin.json` và thêm mục Lịch sử trong README.
3. Nhân vật mới thì cập nhật cả trang Design System.
4. Nén lại bằng `node cong_cu/dong_goi_zip.mjs`. Bộ nén kiểu Unix giữ quyền 0755 cho `.sh` và `.command`, để macOS chạy được. Đừng nén bằng `ZipArchive` hay `Compress-Archive` của Windows: chúng làm mất quyền chạy.

Liên quan: [[reference-quy-trinh-thay-nhan-vat]], [[mam-studio-production-workflow]]

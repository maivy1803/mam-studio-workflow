---
name: mam-studio-design-system
description: Quy chuẩn hình ảnh (design system) của Mam_Studio / Halo_Cub. Gồm style 3D thú bông của series (dáng ~2,7 đầu, lông xù mờ, đen than, kem ngà, đèn mềm từ phải), bố cục character sheet 1376×768 ba ô hoặc bốn góc, bản có nhãn 1376×936 (thanh tiêu đề #222222, dải nhãn, chân trang, font), bảng màu từng nhân vật đo từ sheet chốt, tỉ lệ ảnh nhóm, quy tắc đặt tên file và thư mục, khối prompt style. Có script ghép bản có nhãn và script rút bảng màu, chạy được trên macOS và Windows. Dùng khi làm hoặc sửa character sheet, ghép nhãn sheet, làm nhân vật mới cho đồng bộ style, làm lineup hoặc avatar nhóm, soát xem ảnh có đúng style series không, đặt tên file ảnh, hoặc khi người dùng nhắc "design system", "quy chuẩn hình ảnh", "style series", "ghép nhãn", "bảng màu".
---

# Design system Mam_Studio / Halo_Cub

Bản đầy đủ: [references/quy_chuan_hinh_anh.md](references/quy_chuan_hinh_anh.md). Đọc phần liên quan trước khi làm ảnh.
Bản xem trên web (riêng tư, của chủ dự án): https://claude.ai/artifact/FTKDxFtAASthBFtXpbcm7E

Luật người dùng (skill `mam-studio-quy-tac`) đứng trên tài liệu này: giữ nguyên nhân vật theo sheet chốt mới nhất, mắt Vịt hạt cườm, hỏi trước khi sửa ảnh, Flow làm tay, chỉ render x1.

## Tóm tắt nhanh
- **Style**:
  - 3D phim hoạt hình. Thú bông mập lùn khoảng 2,7 đầu, không cổ, thân quả lê.
  - Tay chân ngắn, bàn tròn không ngón. Lông dày xù nhẹ, mờ, có viền lông tơ.
  - Diễn bằng mí mắt. Mõm là trung tâm mặt.
  - Màu: đen than, không đen tuyền; kem ngà tối hơn nền một bậc.
  - Đèn mềm ấm từ phải, bóng sàn dài đổ sang trái.
- **Sheet raw**:
  - 1376×768, nền kem ngà `#E9E8DA`.
  - Ba ô: chính diện toàn thân, sau lưng toàn thân, chân dung to bên phải. Sheet bốn góc có FRONT / 3/4 / SIDE / BACK.
  - Không chữ trong ảnh raw.
- **Bản có nhãn** (1376×936), từ trên xuống:
  - Thanh tiêu đề 64 px nền `#222222`, chữ trắng đậm 23 px.
  - Ảnh raw giữ nguyên.
  - Dải nhãn trắng 104 px: nhãn đậm 24 px `#222222`, kẻ `#DCDCDC` ở y=902, chân trang 14 px `#6E6E6E`.
  - Font: Segoe UI trên Windows, Arial trên Mac.
- **Đặt tên**:
  - Gốc: `<nv>_character_sheet_v1a_CHOT.webp`, giữ nguyên byte.
  - Tham chiếu: `..._raw.jpg`.
  - Có nhãn: `..._CHOT_co_nhan.jpg`.
  - Bản dựng mới lưu `vNNN` riêng.

## Script (cần ffmpeg, chạy bằng Node trên cả hai hệ điều hành)
Ghép bản có nhãn (tự dò vị trí nhân vật, không ghi đè file có sẵn):
```
node scripts/tao_sheet_co_nhan.mjs --in <sheet_raw.jpg> --out <sheet_CHOT_co_nhan.jpg> \
  --title "HEO 1 · ĐEN TRẮNG — character sheet (ĐÃ CHỐT 2026-11-23)" \
  --labels "Chính diện|Sau lưng|Cận mặt" \
  --footer "Team-suc-vat · #2.6_Heo · bản người dùng gửi và chốt · 2026-11-23"
```
- Mặc định nhãn là `FRONT · Chính diện|BACK · Sau lưng|CHÂN DUNG`.
- Sheet bốn góc thì truyền 4 nhãn.
- Nhãn lệch thì chỉnh bằng `--x 241,660,1110` (tâm ngang từng nhãn).

Rút bảng màu nhân vật mới: `node scripts/bang_mau_tu_sheet.mjs <sheet_raw.jpg> [--k 6] [--json]`.

Ví dụ bản có nhãn đúng quy chuẩn: [assets/mau_sheet_co_nhan_heo_1.jpg](assets/mau_sheet_co_nhan_heo_1.jpg).

## Khi làm nhân vật mới
1. Lấy khối prompt style ở mục 6 tài liệu đầy đủ. Ghép thêm câu nhận diện riêng của con mới.
2. Gắn tham chiếu style. Có ba cách, đều nằm ở `<dự án>/_Mam_Studio_Kit/tai_nguyen/nhan_vat/`:
   - ảnh style chung `_style_chung/style_bo_vit_4_goc.jpg` (Bò + Vịt 4 góc, cách đã dùng cho Chó PQ). Ảnh này chỉ lấy style: Bò trong đó là biến thể cũ;
   - sheet `_raw.jpg` của Bò và Vịt, hoặc sheet concept 4 góc của Vịt `vit_lon/tham_chieu/Duck_…3af3b1fe.jpg`;
   - sheet chốt của con gần dáng nhất.
3. Gen trên Flow bằng tay, x1. Tự xem nhanh theo mục 1 (dáng, màu, mí, khẩu hình).
4. Người dùng chốt xong:
   - Lưu bản `_CHOT.webp` và `_raw.jpg`.
   - Ghép bản có nhãn bằng script.
   - Rút bảng màu, thêm một dòng vào bảng màu (mục 3).
   - Ghi PROJECT_INDEX.

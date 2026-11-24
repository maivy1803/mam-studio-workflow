---
name: thay-nhan-vat-clip-goc
description: Đưa nhân vật Halo_Cub (Bò Bía, Vịt Lộn, Mèo, Gà, Chó, Heo…) vào thay nhân vật trong một clip gốc lan truyền có lời thoại, giữ nguyên tiếng gốc, đúng tỉ lệ với bối cảnh thật, khớp miệng. Gồm nghiên cứu clip gốc (thông số, điểm cắt, chép lời bằng whisper, mốc nói), dựng bằng Google Flow (Nano Banana khung đầu, Omni 1.2 Flash dựng đoạn theo mốc, đổi phông xanh, sửa chi tiết), ghép trên máy bằng ffmpeg (tách phông, đặt tỉ lệ, bóng, nhịp cận mặt, ô bình luận, tiếng gốc) và sửa lệch tiếng–hình từng cảnh. Dùng khi người dùng nói "thay con … vào clip", "làm lại clip này bằng Bò Bía", "giữ voice gốc", "đổi background", "tỉ lệ con bò cho tự nhiên", "mắt mở to", "lỗi voice với hình từ giây … tới …", hoặc đưa một clip TikTok/Douyin và muốn làm tập Halo_Cub từ nó.
---

# Thay nhân vật Halo_Cub vào clip gốc, giữ tiếng gốc

Trả lời người dùng bằng tiếng Việt, ngắn, làm nhanh. Người dùng hay chốt từng bản rồi yêu cầu sửa đúng một chỗ: **chỉ sửa đúng chỗ được yêu cầu, giữ nguyên phần còn lại**, và không dựng lại toàn bộ nếu không cần.

Tài liệu đầy đủ (lệnh mẫu, số đo, bài học): [references/quy_trinh_day_du.md](references/quy_trinh_day_du.md).
Script: thư mục `${CLAUDE_SKILL_DIR}/scripts/`. Ảnh mẫu: `${CLAUDE_SKILL_DIR}/assets/`.
Sheet nhân vật đã chốt (nếu đã cài bộ tài nguyên): `<thư mục dự án>/_Mam_Studio_Kit/tai_nguyen/nhan_vat/`.

## Luật cứng
- **Không sửa, chuyển, xóa clip gốc.** File trung gian để trong scratchpad; file giao để trong `Halo_Cub/<tap>/06_render/ban_nhap_<nhan_vat>_vNNN/`, kèm `ghi_chu.md`. Bản cũ giữ nguyên.
- **Google Flow làm tay trong trình duyệt của app** (`mcp__Claude_Browser__*`), không dùng MCP `google-flow`/`flow-studio`, không dùng KIE. Chỉ render **x1**. Đọc giá ("Generating will use N credits") trước khi bấm.
- Flow **từ chối sửa video tải lên có tiếng nói** ("Our policies prevent editing or generating speech for people in uploaded videos"). **Không lách** (không tải bản bỏ tiếng). Luôn dựng mới nhân vật rồi ghép tiếng gốc trên máy.
- Hộp "Rights to use this video", điều khoản, nút đồng ý: **hỏi người dùng** trước khi bấm.
- Nhân vật phải đúng sheet đã chốt; ghi rõ mọi chỗ lệch. Kịch bản bám gốc, không thêm gag.
- Sau khi tạo: tự xem nhanh (bảng khung, ffprobe), không chạy agent soát dài nếu không được yêu cầu.

## Các bước (chi tiết ở tài liệu đầy đủ)
1. **Nghiên cứu clip gốc** (gọn, chỉ phần phục vụ việc thay nhân vật):
   `bash "${CLAUDE_SKILL_DIR}/scripts/nghien_cuu_clip.sh" "<clip_goc.mp4>" "<scratchpad>/nghien_cuu"`
   → thông số, điểm cắt, bảng khung 2 hình/giây, lời (whisper), độ lớn giọng mỗi 0,1 s. Mốc nói/im lấy từ độ lớn dải giọng, không từ silencedetect toàn dải. Tách tiếng gốc (`-vn -c:a pcm_s16le`), ô bình luận (nếu có), một khung phòng không overlay.
2. **Khung đầu** (Nano Banana, Image 9:16 x1, 0 credit): khung phòng gốc + ô cắt từ sheet nhân vật → nhân vật đứng đúng chỗ nhân vật gốc.
3. **Dựng đoạn video** (Omni 1.2 Flash, Video › Frames › Start = khung đầu, 9:16, 720p, x1): chia tại điểm cắt gốc, mỗi đoạn ≤ 15 s (thanh Length 0…12 = 3…15 s; khoảng 3 credit/s). Lệnh ghi mốc từng câu nói, từng khoảng ngậm miệng, từng cử chỉ.
4. **Kéo về máy**: `node "${CLAUDE_SKILL_DIR}/scripts/serve_files.js" <thư_mục_phục_vụ> <thư_mục_lưu> 8765` rồi dùng các đoạn JS trong `scripts/flow_doan_js.js` (tải lên qua `http://127.0.0.1`, bắt URL `flow-content.google/video/…`, `POST /save`).
5. **Đổi nền giữ diễn xuất + tỉ lệ thật** (cách người dùng đã chốt): Omni sửa từng đoạn do Flow tạo sang **phông xanh**; Nano Banana tạo **ảnh nền trống** có vật kích thước biết trước; ghép:
   `bash "${CLAUDE_SKILL_DIR}/scripts/ghep_phong_xanh_ty_le_that.sh" G1 G2 G3 nen.jpg "${CLAUDE_SKILL_DIR}/assets/bong_chan.png" tieng_goc.wav o_binh_luan.png out.mp4`
   Thông số đặt nhân vật và nhịp phóng to phải đo lại theo nền và nhân vật mới (mục 6.3 tài liệu).
6. **Sửa chi tiết nhân vật** (vd mắt mở to từ giây X): Omni sửa trên bản phông xanh, nối tại đúng khung, ghép lại như bước 5.
7. **Sửa lệch tiếng–hình một cảnh** (0 credit):
   `bash "${CLAUDE_SKILL_DIR}/scripts/tim_do_tre_mieng.sh" tieng_goc.wav <đoạn_flow.mp4> <offset_s> <t0> <t1>` → số khung trễ tốt nhất;
   `bash "${CLAUDE_SKILL_DIR}/scripts/sua_khop_mieng_doan.sh" ban_cu.mp4 G1 G2 G3 nen.jpg bong_chan.png <N0> <N1> <LAG> <ZOOM> ban_moi.mp4` → chỉ thay các khung của cảnh đó (hai đầu nên là điểm cắt cảnh).
8. **Kiểm và giao**: ffprobe (720×1280, 24 fps, đúng số khung, tiếng đủ dài), bảng 12 khung so với bản trước, khớp miệng đo bằng độ lớn giọng; gửi file bằng SendUserFile; ghi `ghi_chu.md` (cách làm, credit, điểm cần người dùng xem).

## Cần có trên máy
ffmpeg bản có bộ lọc `whisper` (ffmpeg 8+ full build), Node.js, model `~/.cache/whisper/ggml-large-v3-turbo-q5_0.bin` (574 MB, tải với sự đồng ý của người dùng), font Arial. Chạy được trên macOS (Terminal/bash) và Windows (Git Bash, là shell của Claude Code trên Windows).

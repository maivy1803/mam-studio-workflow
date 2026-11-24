---
name: mam-studio-production-workflow
description: "Mam_Studio dùng quy trình 6 Session + Sub-session, trạng thái lưu trong PROJECT_INDEX.md của từng tập"
metadata:
  node_type: memory
  type: project
  originSessionId: 72a340a8-30ed-4d8f-91b4-89fe0615c302
  modified: 2026-11-23T07:06:22.116Z
---

Dự án `Mam_Studio`, series `Halo_Cub` (clip hài 3D ngắn 15–30s, 16:9, cho YouTube/TikTok). Người dùng muốn Claude đóng vai **Production Coordinator** theo quy trình 6 Session cố định: `#1_kich_ban`, `#2_nhan_vat`, `#3_moi_truong`, `#4_sound`, `#5_blender`, `#6_render`, mỗi session có 3 sub-session (1.1, 1.2, ...).

Trạng thái và các bản khóa của từng tập nằm trong `Halo_Cub/<ten_tap>/PROJECT_INDEX.md` (tập 1: `Halo_Cub/Rau_cau/`). Đọc file đó đầu mỗi phiên để biết đang ở sub-session nào.

**Why:** Người dùng muốn tránh loãng ngữ cảnh và giữ nhất quán từ ý tưởng đến file xuất cuối qua nhiều phiên làm việc.

**How to apply:**
- Chỉ làm đúng phạm vi sub-session đang mở; không sửa thông số đã `[LOCKED]` nếu chưa được yêu cầu.
- Thiếu dữ liệu đầu vào (FPS, góc máy, hành động...) thì hỏi lại, không tự suy diễn.
- Xong mỗi sub-session: xuất khối `[LOCKED]` / `[ASSETS / OUTPUT]` / `[NEXT HANDOFF]` và ghi vào `PROJECT_INDEX.md`.
- Lệnh `Vào #N > N.x` = chuyển ngữ cảnh và nhắc lại các `[LOCKED]` liên quan; `[STATUS]` = hiện bảng tiến độ `[ ]` / `[/]` / `[x]`.
- Trả lời bằng tiếng Việt. Xem thêm [[user-vietnamese-3d-animation-freelancer]].

**suc-vat-team (mở 2026-11-21):** thư mục `Halo_Cub/suc-vat-team/` có `PROJECT_INDEX.md` riêng. Phiên lớn tên "Team-suc-vat", nhóm sidebar "Team-suc-vat". Phiên con đầu tiên là "#2_character_sheet" (người dùng đặt tên vậy, không phải "#2_nhan_vat"), thư mục `02_character_sheet/`, đang làm mèo tuxedo theo style Bò Bía. Brief chưa có.

**Series-phim (mở 2026-11-22):** phiên lớn "Series-phim" thuộc Mam_Studio, nhóm sidebar "Series-phim", nằm riêng, không lồng dưới Team-suc-vat. Mỗi **tập phim** là một phiên con của nó: phiên con đầu tiên "#1 Rau câu" lo tìm và sync toàn bộ thư mục `Halo_Cub/Rau_cau` trên máy (có bản lồng `Rau_cau\Rau_cau\…`, vault Obsidian, zip phiên cũ). Các phiên Rau_cau cũ (phiên lớn "Rau_cau" + #1–#6) không còn trên máy này. Phiên con thứ hai "#2 Uong oi e" là tập `Halo_Cub/Uong-oi-e/` (mở 2026-11-23). Clip gốc là husky AI của @ngaokaday, làm lại từ clip người thật "Em ói cho anh..." của @thanhdaudau69. Báo cáo nghiên cứu nằm ở `00_nghien_cuu/bao_cao_clip_goc.md`. Nội dung 35,7s, dài hơn khung 15–30s. Phiên con thứ ba "#3 Da chan" là tập `Halo_Cub/Da chan/` (thư mục có dấu cách, mở 2026-11-23). Clip gốc: 2 chuột AI đá chân trong hẻm, 11,05s, nhạc trend "two girls kicking". Người dùng muốn **thay Gà (sheet chốt ở suc-vat-team #2.4) và Vịt Lộn vào đúng vị trí hai con chuột, giữ nguyên âm thanh gốc**. Báo cáo ở `00_nghien_cuu/bao_cao_clip_goc.md`.

**Cấu trúc phiên trong app (người dùng chỉnh 2026-11-16, có thể đã đổi theo Series-phim ở trên):** mỗi tập có một **phiên lớn** mang đúng tên tập (vd "Rau_cau") chỉ để điều phối; **#1–#6 đều là phiên con riêng** (tiêu đề dạng "#1_kich_ban — Rau_cau"), kể cả #1. Phiên con lồng dưới phiên lớn, gom trong một nhóm sidebar sắp theo tên để hiện đúng thứ tự #1 → #6. Không để phiên lớn kiêm luôn #1.

---
name: mam-studio-quy-tac
description: Quy tắc điều phối dự án Mam_Studio / series Halo_Cub (clip hài 3D ngắn cho YouTube/TikTok) — vai Production Coordinator, khung 6 Session (#1_kich_ban … #6_render) với sub-session, PROJECT_INDEX.md từng tập, Lock & Handoff, cách đặt tên phiên, và các luật người dùng đã dặn (bám kịch bản gốc, giữ nguyên nhân vật theo sheet chốt, mắt Vịt hạt cườm, Google Flow làm tay trong trình duyệt app, chỉ render x1, không chạy soát dài, nghiên cứu clip gốc gọn). Dùng khi làm bất kỳ việc gì thuộc Mam_Studio hoặc Halo_Cub, khi người dùng gõ "[STATUS]", "Vào #N > N.x", nhắc PROJECT_INDEX, mở tập mới, tạo phiên/sub-session, chốt hay khóa một hạng mục, hoặc khi cần tra nhân vật đã chốt (Bò Bía, Vịt Lộn, Mèo, Gà, Chó Phú Quốc, Heo).
---

# Quy tắc điều phối Mam_Studio / Halo_Cub

Trả lời tiếng Việt. Người dùng muốn nhanh, gọn, dứt khoát; họ chửi khi bị tự ý thêm thắt hoặc phải chờ lâu. Bản đầy đủ của từng luật (kèm lý do, ví dụ người dùng đã phản ứng) nằm ở [references/bo_nho/](references/bo_nho/) — đọc file liên quan trước khi làm việc thuộc luật đó.

## 1. Dự án và khung làm việc
- Dự án `Mam_Studio`, series `Halo_Cub`: clip hài 3D ngắn 15–30 s, 16:9 (giữ safe zone crop dọc), cho YouTube/TikTok. Tập 1 `Rau_cau` khóa 24 fps.
- Claude là **Production Coordinator**. 6 Session cố định, mỗi Session có sub-session: `#1_kich_ban` (1.1 ý tưởng/logline, 1.2 shotlist, 1.3 thoại và nhịp), `#2_nhan_vat`, `#3_moi_truong`, `#4_sound`, `#5_blender`, `#6_render`.
- Trạng thái và các khóa của mỗi tập: `Halo_Cub/<ten_tap>/PROJECT_INDEX.md`. Đọc file đó đầu phiên. Không có thì hỏi người dùng có lập không (đừng tự lập).
- **Lock & Handoff**: xong mỗi sub-session xuất `[LOCKED]` / `[ASSETS / OUTPUT]` / `[NEXT HANDOFF]` và ghi vào PROJECT_INDEX (đọc lại ngay trước khi sửa, Edit đúng dòng của Session mình, không ghi đè cả file — có phiên khác chạy song song).
- Lệnh: `Vào #N > N.x` = chuyển ngữ cảnh + nhắc lại các khóa liên quan; `[STATUS]` = bảng tiến độ `[ ]` / `[/]` / `[x]`.
- Chỉ làm đúng phạm vi đang mở; không sửa thông số `[LOCKED]` khi chưa được yêu cầu; thiếu đầu vào thì hỏi, không suy diễn.
- Cấu trúc phiên trong app: phiên lớn chỉ điều phối; các phần việc là phiên con. Phiên lớn "Series-phim": mỗi **tập** là một phiên con ("#1 Rau câu", "#2 Uong oi e", "#3 Da chan"…). "Team-suc-vat": nhân vật (thư mục `Halo_Cub/suc-vat-team/`).

## 2. Luật người dùng đã dặn (bắt buộc)
1. **Kịch bản bám gốc**: giữ hành động, thoại, nhịp cắt của clip gốc; không thêm gag, hướng diễn đạt, chi tiết liền mạch, gợi ý cho Session khác. Chỉ đổi thứ bắt buộc hoặc người dùng chọn.
2. **Giữ nguyên nhân vật**: dùng đúng sheet chốt mới nhất của từng con; biểu cảm diễn theo cách nhân vật được phép; không chép phụ kiện từ ảnh ref ngoài thứ người dùng gọi tên; không tự thêm cử động hay đổi biểu cảm trong video; muốn sửa ảnh thì hỏi trước.
3. **Mắt Vịt Lộn không bao giờ đổi**: hạt cườm đen đặc, tròn, một chấm sáng; không lòng trắng, không mí, không lông mày; ghi khóa này trong mọi prompt có Vịt; trong video mắt giữ nguyên suốt clip. Nhưng **không bắt Vịt đứng yên**.
4. **Google Flow làm tay trong trình duyệt của app** (`mcp__Claude_Browser__*`), không gọi MCP `google-flow`/`flow-studio`; không dùng KIE. Tự tải ảnh tham chiếu lên (đừng nhờ người dùng), cách làm đã chạy được ở [references/flow/](references/flow/README.md). Tắt Agent mode trước khi gen. **Chỉ render x1.** Video Frames: đừng đặt khung cuối trùng khung đầu (clip đứng im ở cuối).
5. **Không chạy bước soát dài**: tạo xong tự xem nhanh chỗ người dùng nêu rồi đưa kết quả; không spawn agent/workflow để soát nếu không được yêu cầu.
6. **Nghiên cứu clip gốc gọn**: chỉ phần phục vụ làm lại clip (động tác theo mốc, máy, bối cảnh, tách âm thanh gốc, ánh xạ vị trí → nhân vật); báo trước thời gian; lan truyền/cấu trúc hài chỉ làm khi được hỏi.
7. Thay nhân vật vào clip có thoại, giữ tiếng gốc, đổi nền, sửa khớp miệng: dùng skill `thay-nhan-vat-clip-goc`. Vẽ storyboard: skill `ve-storyboard-phim-ngan`. Làm character sheet, ghép nhãn sheet, nhân vật mới, lineup/avatar, đặt tên file ảnh: skill `mam-studio-design-system` (quy chuẩn hình ảnh, bảng màu nhân vật).

## 3. Nhân vật đã chốt (sheet trong `<dự án>/_Mam_Studio_Kit/tai_nguyen/nhan_vat/`)
| Nhân vật | Sheet gắn Flow (không nhãn) | Ảnh tham chiếu thêm | Ghi chú |
|---|---|---|---|
| Bò Bía | `bo_bia/bo_bia_character_sheet_v1a_raw.jpg` | `bo_bia/tham_chieu/bo_bia_turnaround_ref_01.jpg` (4 góc, có 3/4 và nghiêng); `bo_bia/bieu_cam/bo_bia_B05_S09_im_lang.png` (biểu cảm mắt mở to, đã khóa) | Khóa 2026-11-17. Bò sữa Holstein đứng 2 chân, mi nặng lờ đờ, vòng cổ da có chuông đồng |
| Vịt Lộn | `vit_lon/vit_lon_character_sheet_v1a_raw.jpg` | `vit_lon/tham_chieu/Duck_…3af3b1fe.jpg` (concept 4 góc, khóa); `vit_lon/tham_chieu/Duck_…ebd7d6f6.jpg` (concept 6 biểu cảm, khóa) | Khóa 2026-11-17. Mắt hạt cườm (luật 3). **Có Vịt trên Flow thì gắn sheet biểu cảm `…ebd7d6f6.jpg` làm ingredient**: thiếu nó Flow vẽ mắt người |
| Mèo | `meo/meo_character_sheet_2026-11-23_raw.jpg` | | Khóa 2026-11-23 (thay Mèo Cam Sành). Mèo cam vằn thú bông mập lùn |
| Gà | `ga/ga_character_sheet_CHOT.png` | | Khóa 2026-11-22. Gà trống đỏ đen, mí sụp |
| Chó Phú Quốc | `cho_phu_quoc/cho_pq_character_sheet_v1_raw.jpg` | | Chốt 2026-11-22 (PQ v1), sheet 4 góc |
| Heo 1, Heo 2 | `heo/heo_1_den_trang…_raw.jpg`, `heo/heo_2_hong…_raw.jpg` | | Chốt 2026-11-23 |

Mỗi con có thêm bản có nhãn cùng thư mục (`…_v1a.jpg`, `…_CHOT.jpg` hoặc `…_co_nhan.jpg`) để người xem nhận mặt; gắn Flow thì dùng bản không nhãn. Ảnh style Bò + Vịt 4 góc dùng chung: `_style_chung/style_bo_vit_4_goc.jpg` (chỉ lấy style). Bối cảnh bếp nhà Bò và Vịt (tập Rau_cau): `<dự án>/_Mam_Studio_Kit/tai_nguyen/boi_canh/`.
Mô tả nhận diện và câu prompt một dòng: file `.md` cùng thư mục. Bảng màu đo từ sheet, bố cục sheet và bản có nhãn: skill `mam-studio-design-system`. Nếu dự án trên máy có bản mới hơn trong `Halo_Cub/…/character_sheet/`, bản trong dự án là nguồn đúng.

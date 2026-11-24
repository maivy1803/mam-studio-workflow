---
name: ve-storyboard-phim-ngan
description: Vẽ storyboard cho kịch bản phim ngắn hoạt hình 3D (dự án Mam_Studio / Halo_Cub và các tập sau). Biến shotlist đã khóa thành từng khung hình có nhân vật, đúng bối cảnh và đúng góc máy, rồi ghép thành bảng storyboard PNG kèm bảng markdown. Quy trình gồm đặt camera và hình nộm nhân vật trong set blockout Blender qua MCP blender, render khung blockout, render lại trên Google Flow (làm tay trong trình duyệt của app, chỉ x1) theo ảnh tham chiếu nhân vật và bối cảnh, và ghép bảng bằng script Node chạy được cả macOS lẫn Windows (hoặc bản PowerShell trên Windows). Dùng skill này mỗi khi người dùng nói "vẽ storyboard", "storyboard", "board", "phân cảnh bằng hình", "khung hình từng shot", "previs frames", "animatic", hoặc muốn xem shotlist/kịch bản thành ảnh, kể cả khi không nói chữ "storyboard". Cũng dùng khi cần vẽ lại một vài panel sau khi shotlist đổi.
---

# Vẽ storyboard cho kịch bản phim ngắn

Storyboard ở đây là **một tấm ảnh cho mỗi shot** (hai tấm nếu shot có chuyển động lớn), đúng bối cảnh, đúng chỗ đứng và đúng góc máy của shotlist, kèm chú thích frame, cỡ cảnh, hành động và thoại.

Quy trình đi qua hai lớp, mỗi lớp lo một việc:
1. **Blockout Blender lo hình học**: camera, tiêu cự, vị trí và hướng nhân vật, đạo cụ nằm đâu. Phần này tính bằng số nên chính xác và lặp lại được.
2. **Google Flow lo vẻ ngoài**: chất liệu, ánh sáng, và nhân vật trông đúng như concept. Phần này cần ảnh, Flow làm tốt hơn.

Nếu bỏ lớp 1 và chỉ gõ prompt vào Flow, mỗi panel sẽ ra một căn bếp khác nhau và góc máy không khớp shotlist. Nếu bỏ lớp 2, storyboard chỉ là khối màu, người duyệt khó hình dung.

Trả lời người dùng bằng tiếng Việt.

> **Cập nhật 2026-11-23 (bộ cài Mam_Studio_Kit):** người dùng đã chuyển sang làm Google Flow **bằng tay trong trình duyệt của app** (`mcp__Claude_Browser__*`), không gọi MCP `google-flow`/`flow-studio`, chỉ render x1. Các bước dưới đây nhắc `gen_i2i`/`flow_download` của MCP là cách cũ: làm tương đương bằng tay (khung tạo Image, gắn ảnh tham chiếu, kéo ảnh về bằng các đoạn JS trong `thay-nhan-vat-clip-goc/scripts/flow_doan_js.js`). Đường dẫn `C:\Users\PC\...` là của máy gốc. Ghép bảng dùng `ghep_storyboard.mjs` (chạy cả macOS lẫn Windows).

---

## 0. Luật của dự án (Mam_Studio)

Dự án chia 6 Session (`#1_kich_ban` … `#6_render`). Trạng thái và các thông số đã khóa nằm trong `Halo_Cub/<tap>/PROJECT_INDEX.md`. Các luật dưới đây đến từ cách người dùng vận hành dự án; làm sai sẽ phá dữ liệu của phiên khác đang chạy song song:

- **Đọc `PROJECT_INDEX.md` trước.** Chỉ dùng thông số `[LOCKED]`. Bản nháp thì nói rõ là nháp.
- **Thiếu đầu vào thì hỏi, không tự bịa**: chiều cao nhân vật, chỗ đứng, cỡ cảnh… Người dùng đã nhiều lần sửa lại khi Claude tự đoán.
- **Chỉ ghi vào thư mục của Session đang chạy skill.** Mặc định là `<tap>/03_moi_truong/storyboard/` nếu chạy từ #3. Không sửa file trong thư mục của Session khác.
- **Thấy shotlist mâu thuẫn với set** (ví dụ shotlist cần "bàn đầy rau câu" nhưng set đã bỏ): báo người dùng. Không tự sửa shotlist của #1.
- **Xong việc**: xuất khối `[LOCKED]` / `[ASSETS / OUTPUT]` / `[NEXT HANDOFF]`. Khi cập nhật `PROJECT_INDEX.md`: đọc lại ngay trước khi sửa, dùng Edit chính xác, chỉ sửa dòng của Session mình, không ghi đè cả file.

Ở dự án khác không có các file này thì bỏ qua phần đường dẫn, nhưng vẫn giữ tinh thần: dùng dữ liệu đã chốt và hỏi khi thiếu.

---

## 1. Gom đầu vào

Kiểm tra đủ các mục dưới đây **trước khi** đụng vào Blender hay Flow, rồi báo người dùng mục nào còn thiếu.

| Đầu vào | Chỗ thường thấy (Mam_Studio) | Bắt buộc? |
|---|---|---|
| Shotlist: shot, frame, cỡ cảnh, hành động, ai trong khung | `01_kich_ban/1.2_phan_canh_shotlist.md` + khối 1.2 trong PROJECT_INDEX | Có |
| Thoại và timing | `01_kich_ban/1.3_thoai_va_nhip.md` | Nên có (để ghi lên panel) |
| Set blockout `.blend` | `03_moi_truong/3.1_blockout_*.blend` + ghi chú `3.1_bo_cuc_va_dao_cu_NHAP.md` (hệ trục, chỗ đứng, bảng màu khối) | Có. Chưa có thì dừng và đề xuất dựng blockout trước |
| Ảnh vẻ ngoài bối cảnh | Ảnh Flow môi trường đã duyệt (`3.1_lineup/flow_render/`) hoặc ảnh tham chiếu bối cảnh (`tham_chieu/`) | Nên có |
| Ảnh concept nhân vật **đã khóa** | `02_nhan_vat/<sub>/tham_chieu/` | Có, nếu shot có nhân vật |
| Chiều cao / tỷ lệ nhân vật | Khối #2 trong PROJECT_INDEX | Có, cho hình nộm. Chưa khóa thì hỏi người dùng con số tạm và ghi rõ là tạm |
| Chỗ đứng, hướng nhìn theo shot | Dấu sàn `MARK_*` trong blockout, ghi chú 3.1, hoặc #5 > 5.1 | Có. Chưa có thì đề xuất rồi chờ duyệt |
| Khung hình và crop dọc | Project Brief: 16:9, giữ vùng an toàn cho crop 9:16 | Có |
| Ánh sáng, mood màu | #3 > 3.2 nếu đã khóa. Nếu chưa thì lấy theo ảnh bối cảnh và ghi "chưa khóa 3.2" | Nên có |

---

## 2. Lập bảng panel và xin duyệt

**Bám nguyên văn kịch bản đã khóa.** Người dùng đã từ chối một storyboard vì nó thêm chi tiết không có trong kịch bản: nhân vật đi ra từ cửa nào, hành động phụ, cảm xúc tự suy ra. Vì vậy:
- Các cột **khung, hành động, thoại, người nói** chép **nguyên văn** từ shotlist và bảng thoại đã khóa. Không viết lại cho hay hơn, không thêm động tác, không thêm cảm xúc.
- Mỗi panel đúng một shot, đúng số shot và frame của shotlist. Chỉ tách panel khi người dùng đồng ý.
- Kịch bản không ghi (chỗ đứng hay ngồi, hướng nhìn, qua vai nhìn về đâu): **hỏi người dùng**. Có thể kèm một đề xuất, nhưng phải ghi rõ là đề xuất. Dấu chỗ đứng trong blockout cũng chỉ là đề xuất, trừ khi PROJECT_INDEX ghi đã khóa.
- Cột camera và tiêu cự là phần duy nhất được tự suy ra, và chỉ từ cột "Khung" của shotlist.
- Prompt Flow ở bước 5 cũng chỉ tả đúng hành động và biểu cảm có trong kịch bản, cộng với các đặc điểm nhân vật đã khóa ở Session nhân vật.

Lập bảng, mỗi shot một dòng. Cột:

`panel | shot | frame (giây) | khung (nguyên văn) | hành động (nguyên văn) | thoại + mã câu (nguyên văn) | ai trong khung | camera, tiêu cự (suy từ "khung") | điều kịch bản không ghi, cần hỏi`

Gợi ý tiêu cự, cảm biến 36 mm:
- Toàn cảnh, thiết lập: 18–24 mm
- Trung cảnh, hai nhân vật: 28–35 mm
- Qua vai: 35–50 mm
- Cận mặt: 50–85 mm

Đặt camera ngang tầm mắt nhân vật chính của shot, trừ khi shotlist ghi góc khác. Ở cận một nhân vật, đặt mặt vào **dải giữa rộng ≈ 31.6% khung** (vùng crop 9:16) và chừa chỗ cạnh đầu cho phụ đề, nếu 1.3 có đặt phụ đề cạnh người nói.

Gửi bảng cho người dùng duyệt **trước khi render**: sửa trên bảng gần như không tốn gì, render lại thì tốn hạn mức ảnh.

---

## 3. Dựng camera và hình nộm trong Blender

Code mẫu có trong `references/blender_storyboard.md`. Đọc file đó trước khi viết script. Các điểm chính:

1. **Mở file an toàn.** In `bpy.data.filepath` và `bpy.data.is_dirty`. Nếu Blender đang mở file của dự án khác mà còn thay đổi chưa lưu thì dừng và hỏi người dùng. Không đóng mất việc của họ. Mở file set bằng một lệnh riêng, rồi **lưu thành bản sao** vào thư mục storyboard, để file set của 3.1 giữ sạch.
2. **Hình nộm nhân vật**: thân trụ, đầu cầu và một chóp nón chỉ hướng nhìn. Chiều cao theo số liệu đã khóa. Mỗi nhân vật một màu riêng, chưa khối nào trong set dùng. Flow nhờ màu và chóp nón để biết ai đứng đâu, nhìn hướng nào.
3. **Mỗi panel một camera** `CAM_SB_<panel>` (nhắm bằng `to_track_quat`), cộng một bảng vị trí và hướng hình nộm theo từng panel. Nhân vật không có trong panel thì ẩn khi render.
4. **Ẩn dấu sàn, chữ và đường đi** (`COL_MARK_*`, `TXT_*`) khi render. Flow sẽ vẽ chúng thành thảm hay vạch sơn.

---

## 4. Render khung blockout

- Ảnh 1920×1080, tên `SB_<panel>_blockout.png`, lưu trong `storyboard/blockout/`.
- `scene.render.engine` có thể báo thiếu engine, Workbench có thể không có trong danh sách enum. EEVEE chỉ có ánh sáng world cũng cho ảnh màu phẳng, rõ khối, đủ dùng. Ghi lại engine cũ và trả lại sau khi render.
- Xem nhanh từng ảnh (Read) để kiểm tra: đúng cỡ cảnh chưa, mặt có nằm trong dải 9:16 không, có khối nào che mặt không. Sửa camera ở bước này rẻ hơn nhiều so với sửa ở Flow.

---

## 5. Render bằng Google Flow

Mẫu prompt và bảng quy đổi màu khối sang vật liệu có trong `references/prompt_flow.md`. Đọc file đó trước khi gọi Flow.

- Nạp tool bằng ToolSearch: `mcp__google-flow__gen_i2i`, `mcp__google-flow__flow_projects`, `mcp__google-flow__project_create`.
- **Báo trước số ảnh sẽ tạo.** Model mặc định `nano2` tốn 0 credit nhưng tính vào hạn mức ảnh mỗi ngày.
- Mỗi storyboard một project, tên dạng `"<series> <tap> - storyboard"`. `project_create` hay báo lỗi khi đổi tên, nhưng project vẫn được tạo: lấy id trong thông báo lỗi mà dùng.
- `refs` là **đường dẫn file trên máy**. Truyền media id sẽ bị từ chối (`FlowHostMigratedError`). **Tối đa 2 ảnh**: đến ảnh thứ 3 Flow báo `ReferenceNotFoundError` (đã thử 3 và 4 ảnh, đều lỗi, không tốn gì). Vì vậy dùng `[khung blockout, ảnh nhân vật]`:
  - Panel có hai nhân vật: ghép hai sheet thành một tấm, nhân vật nhỏ thu theo đúng tỷ lệ chiều cao (VD `refs/REF_BO_VIT_ti_le.png`).
  - Panel một nhân vật: dùng sheet của nhân vật đó, có thể ghép thêm sheet biểu cảm vào cùng tấm.
  - Panel không có nhân vật: `[khung blockout, ảnh bối cảnh]`.
  - Vẻ ngoài bối cảnh tả bằng chữ (bảng quy đổi màu trong `references/prompt_flow.md`).
  - Muốn bối cảnh **như ảnh chụp thật** (người dùng Rau_cau chọn: nhân vật 3D trong bếp thật): ghép ảnh tham chiếu bối cảnh thật vào **bên trái** ảnh nhân vật thành một tấm (`refs/REF_BEPTHAT_*.png`). Prompt nói rõ: phần trái là ảnh thật để bám chất liệu và ánh sáng; phần phải là nhân vật 3D. Thêm câu "All plates are plain white ceramic (the lavender colour in Image 1 is only a blockout code)", vì Flow hay để lọt màu mã của blockout.
  - Đổi phong cách thì **render thử 1 panel cho người dùng duyệt trước**, rồi mới chạy cả bộ.
  - Ảnh webp không đọc được bằng System.Drawing: đổi sang PNG bằng `ffmpeg -i x.webp x.png`.
  - Ghép ảnh bằng PowerShell System.Drawing, lưu PNG trong `storyboard/refs/`.
- `aspect: "16:9"`, `count: 1`, `job_id: "sb-<tap>-<panel>-v1"`. Lần vẽ lại dùng `-v2`, `-v3`.
- **Gọi lần lượt từng panel**, không gọi song song: Flow chạy trên một cửa sổ Chrome thật.
- Ảnh ra nằm ở `path` dạng `out\<workflow_id>_1.jpg`, tương đối với `C:\Users\PC\tools\google-flow-mcp\`. Chép sang `storyboard/flow/SB_<panel>.jpg`. (`flow_download` chỉ ghi được vào thư mục `out` của nó.)
- Google báo "unusual activity" (WAF) thì **dừng hẳn**: không thử lại, không đăng nhập lại, báo người dùng.
- Xem từng ảnh: đúng góc máy và vị trí như khung blockout chưa, nhân vật có đúng concept không. Flow hay tự thêm đồ vật. Nếu chỗ thêm làm sai câu chuyện thì vẽ lại, prompt nói rõ không thêm. Nếu không ảnh hưởng thì giữ và ghi chú.

---

## 6. Ghép bảng storyboard

1. Viết manifest JSON theo mẫu `assets/manifest_mau.json`: tiêu đề, và cho mỗi panel: `id`, `frames`, `framing`, `action`, `dialogue`, `image` (đường dẫn tương đối so với file manifest).
2. Chạy (macOS và Windows, cần Node + ffmpeg):
   ```
   node "${CLAUDE_SKILL_DIR}/scripts/ghep_storyboard.mjs" --manifest "<storyboard>/manifest.json" --out "<storyboard>/bang" --safezone916
   ```
   Tùy chọn: `--cols 3 --rows 2` (mặc định 6 panel một trang), `--panel-width 640`, `--font <file.ttf>`. Cờ `--safezone916` vẽ khung đỏ cho vùng crop dọc 9:16.
   Trên Windows vẫn dùng được bản cũ (System.Drawing):
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_SKILL_DIR}/scripts/ghep_storyboard.ps1" -Manifest "<storyboard>/manifest.json" -OutDir "<storyboard>/bang" -SafeZone916
   ```
3. Viết thêm `storyboard.md`: bảng panel, ảnh, thoại, ghi chú. Bảng PNG để xem nhanh, file md để các Session sau tra cứu.
4. Gửi các trang PNG cho người dùng bằng SendUserFile.

---

## 7. Duyệt, sửa và khóa

- Người dùng chỉ ra panel cần sửa thì chỉ vẽ lại panel đó: sửa camera/hình nộm, render blockout, rồi Flow `-v2`. Không chạy lại cả bộ.
- Khi người dùng duyệt: xuất khối `[LOCKED]` (bản storyboard nào, ngày), `[ASSETS / OUTPUT]` (đường dẫn các file), `[NEXT HANDOFF]` (Session nào dùng: #3 > 3.3 camera, #5 > 5.1 previs, #4 nhịp SFX…). Rồi cập nhật PROJECT_INDEX theo luật ở mục 0.

---

## Lỗi đã gặp

| Hiện tượng | Cách xử lý |
|---|---|
| Flow vẽ dấu chỗ đứng trên sàn thành thảm tròn | Ẩn `COL_MARK_*` và `TXT_*` trước khi render blockout |
| `gen_i2i` báo `FlowHostMigratedError` | Truyền đường dẫn file, không truyền media id |
| `gen_i2i` báo `WireFormatError` (no ogiZ0b frame) hoặc `MediaUploadRejectedError` (no maseQ reply) | Lỗi tạm của Flow, không tốn gì. Xem `flow_media` để chắc chưa có ảnh nào được tạo, rồi gọi lại với job_id mới |
| `gen_i2i` báo `ReferenceNotFoundError` ở ảnh thứ 3 | Chỉ dùng 2 ảnh tham chiếu; ghép nhân vật vào một tấm |
| Chờ Flow rảnh bằng vòng lặp nền mà vòng lặp không bao giờ kết thúc | Lệnh `powershell -Command "...match 'profile_default'..."` tự đếm cả chính nó, vì dòng lệnh của nó chứa chuỗi đang tìm. Lọc theo tên tiến trình: `-Filter "Name='chrome.exe' OR Name='node.exe'"`, rồi mới so khớp `profile_default\|google-flow-mcp` |
| Muốn chạy song song bằng Flow Studio (`mcp__flow-studio__*`, hồ sơ Chrome riêng) | Đã thử 2026-11-16, chưa dùng được. Lần đầu bạn phải tự đăng nhập qua `flow_sign_in` rồi đóng hẳn Chrome đó. Ảnh tải lên chỉ nhận từ `C:\Users\PC\FlowStudio\input`. Từ ảnh thứ 2 trở đi `flow_upload` báo "Connection closed", sau đó báo "Not signed in". Không bao giờ gửi nhiều lệnh tải cùng lúc |
| `gen_i2i` báo `ProfileLockedError` | Một phiên khác đang dùng Flow (cùng một hồ sơ Chrome). **Không tắt Chrome**, vì sẽ làm hỏng việc của phiên kia. Xem `list_sessions` phiên nào đang chạy, đăng ký `notify_when_idle` với phiên đó, rồi gọi lại khi nó rảnh |
| `project_create` báo lỗi đổi tên | Project vẫn được tạo; dùng id trong thông báo |
| Không tìm thấy Workbench trong danh sách engine | Dùng EEVEE với ánh sáng world; nhớ trả lại engine cũ |
| Blender đang mở file của dự án khác | Kiểm tra `is_dirty`; không có gì chưa lưu thì mới mở file khác, và báo người dùng |
| Flow thêm đồ vật không có trong blockout | Vẽ lại với "do not add any object that is not in Image 1", hoặc ghi chú. Nguồn đúng về vị trí là file `.blend` |
| Góc nhìn ngược ra phía mở của set chỉ thấy khoảng trống | Thêm nền (sân, cây, tường) vào blockout trước khi render góc đó |

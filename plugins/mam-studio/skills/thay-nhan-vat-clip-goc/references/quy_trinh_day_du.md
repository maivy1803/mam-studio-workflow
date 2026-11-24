# Quy trình: đưa nhân vật Halo_Cub vào clip gốc, giữ nguyên tiếng gốc

> Đóng gói ngày 2026-11-23 từ tập `Uong-oi-e` (phiên `#2 Uong oi e`).
> Kết quả mẫu (trên máy gốc): `Halo_Cub/Uong-oi-e/06_render/ban_nhap_bo_bia_v005/uong_oi_e_bo_bia_nhap_v5.mp4`, Bò Bía đứng nói trước quán nhậu vỉa hè, 35,7s, nguyên tiếng gốc.
> Script đi kèm nằm trong [../scripts/](../scripts/), ảnh mẫu trong [../assets/](../assets/). Tất cả đã chạy thử lại trên dữ liệu thật của tập này.

---

## 0. Dùng khi nào

Khi có **một clip gốc lan truyền** (một nhân vật nói chuyện trước máy, có lời thoại) và cần **làm lại bằng nhân vật Halo_Cub**:
- giữ đúng lời, nhịp và cú chốt của gốc (xem quy tắc "Kịch bản bám gốc");
- giữ **nguyên tiếng gốc**;
- nhân vật đứng **đúng tỉ lệ thật** trong một bối cảnh mới.

**Không** sửa trực tiếp video gốc trên Flow: Flow từ chối sửa video tải lên có tiếng nói ("Our policies prevent editing or generating speech for people in uploaded videos"). **Không lách quy định này** (ví dụ tải lên bản đã bỏ tiếng). Quy trình dưới đây dựng mới nhân vật rồi ghép tiếng gốc trên máy.

```
Clip gốc ──► [1] Nghiên cứu: thông số, điểm cắt, lời + mốc nói, nguồn
          └─► tiếng gốc (wav), ô bình luận (png), khung phòng không overlay
[2] Khung đầu (Nano Banana, 0 credit): nhân vật đứng đúng chỗ nhân vật gốc
[3] Dựng 3 đoạn video (Omni, khung đầu, lệnh ghi mốc từng câu)
[4] Kéo video về máy (server 127.0.0.1)
[5] Đổi nền các đoạn sang phông xanh (Omni sửa video)
[6] Ảnh nền trống (Nano Banana) ─► tách phông + đặt đúng tỉ lệ + bóng + nhịp cận mặt + tiếng gốc
[7] Sửa chi tiết nhân vật nếu cần (vd mắt): Omni sửa trên đoạn phông xanh, nối tại mốc
[8] Sửa khớp miệng từng cảnh: dò độ trễ, dựng lại riêng cảnh đó, thay vào bản cũ
[9] Kiểm, lưu `06_render/ban_nhap_<...>_vNNN/` + ghi_chu.md
```

---

## 1. Chuẩn bị

| Thứ | Ở đâu / cách có |
|---|---|
| ffmpeg 9 bản full (có bộ lọc `whisper`) | WinGet Gyan.FFmpeg, đã cài |
| Model whisper `ggml-large-v3-turbo-q5_0.bin` (574 MB) | `C:\Users\PC\.cache\whisper\`, đã tải |
| Node (máy **không có Python**) | đã cài |
| Google Flow | **Làm tay trong trình duyệt của app** (công cụ `mcp__Claude_Browser__*`). Không dùng MCP `google-flow` hay `flow-studio`. Không dùng KIE: người dùng đã dặn ngày 2026-11-23. |
| Server nội bộ | `node scripts/serve_files.js <thư_mục_phục_vụ> <thư_mục_lưu> 8765`. Chỉ bind 127.0.0.1. GET để lấy file lên Flow, `POST /save?name=` để kéo file từ Flow về. |
| Đoạn JS cho tab Flow | [scripts/flow_doan_js.js](../scripts/flow_doan_js.js), mục 1–9 |

**Quy tắc chung:**
- Không sửa, chuyển hay xóa clip gốc. File trung gian để trong scratchpad; file giao để trong thư mục tập.
- Chỉ render **x1**.
- Trước khi tiêu credit, đọc giá Flow hiện ("Generating will use N credits").
- Hộp "Rights to use this video", hộp điều khoản và các nút đồng ý: phải **hỏi người dùng** trước khi bấm.
- Sau khi tạo xong thì tự xem nhanh kết quả. Không chạy agent soát dài nếu người dùng không yêu cầu.

---

## 2. Bước 1: nghiên cứu clip gốc

```bash
bash scripts/nghien_cuu_clip.sh "<clip_goc.mp4>" "<scratchpad>/nghien_cuu"   # khoảng 15 s
```
Script xuất ra:
- `thong_so.json`: thông số file.
- `diem_cat.txt`: điểm cắt cảnh bằng `scdet`.
- `bang_khung_*.jpg`: 2 khung mỗi giây, có ghi mốc thời gian.
- `thoai_ca_clip.srt`: lời chép bằng whisper.
- `khoang_lang.txt`: các khoảng lặng.
- `do_lon_giong.txt`: độ lớn dải giọng nói mỗi 0,1s.

Làm tiếp bằng tay:
1. **Xem trực tiếp các bảng khung**, cộng khung trước và sau mỗi điểm cắt. Lập bảng phân cảnh: thời gian, cỡ cảnh, hành động, lời. Ghi riêng các lần phóng to số (punch-in) và cử chỉ.
2. **Chép lời chắc hơn:** cắt âm thanh theo khoảng lặng rồi chép từng câu. Whisper hay bịa trên đoạn ngắn, vd "Hãy subscribe cho kênh Ghiền Mì Gõ". Đối chiếu với phụ đề tự động của TikTok nếu có.
3. **Mốc nói chính xác:** lấy từ `do_lon_giong.txt` (nói khi lớn hơn khoảng −33dB, im khi nhỏ hơn khoảng −45dB). Không lấy từ `silencedetect` toàn dải: tập này từng lệch 0,7s vì cách đó.
4. **Nguồn và độ lan truyền:** giao một agent tra web. Đọc trang TikTok công khai bằng trình duyệt của app rồi lấy dữ liệu trong `__UNIVERSAL_DATA_FOR_REHYDRATION__` (playCount, diggCount…). Không đưa thông tin cá nhân của người dùng vào truy vấn.
5. **Tách sẵn:**
   - tiếng gốc: `ffmpeg -i goc.mp4 -t <hết nội dung> -vn -c:a pcm_s16le tieng_goc.wav`;
   - ô bình luận: đo khung bằng ngưỡng sáng, cắt, bo góc bằng `geq` (xem `assets/o_binh_luan_mau_720.png`);
   - một **khung phòng không overlay**: chọn một shot không có ô bình luận.
6. Viết `00_nghien_cuu/bao_cao_clip_goc.md` và `thoai_clip_goc.srt`. **Chưa viết kịch bản**, việc đó thuộc `#1_kich_ban`.

---

## 3. Bước 2: khung đầu (Nano Banana, 0 credit)

- Khung tạo: **Image**, 9:16, x1, model Nano Banana 2.1.
- Ảnh tham chiếu (theo thứ tự): khung phòng gốc, rồi các ô cắt từ sheet nhân vật đã khóa (chính diện, chân dung).

```
Use the first reference image (the room with the <con vật gốc>) as the scene. Keep the room, the camera position, framing,
angle, lens and lighting exactly the same: <tả các mốc của phòng>. Remove the <con vật gốc> completely and put the
<nhân vật> from the other two reference images in its place. <tả nhân vật theo sheet: thân, lông, đầu, tai, sừng,
mắt, mõm, vòng cổ, tay…>. His design must match the reference images exactly. He stands on the floor exactly where
the <con vật gốc> sits, centered in the frame, facing the camera, arms relaxed at his sides; <vị trí đầu, mép khung>.
Deadpan, serious face, ... muzzle closed. Stylized 3D feature-animation render, lit by the room's soft daylight so
he sits naturally in the scene. No text, no logos, no stickers, no other characters.
```

- Kéo ảnh full-res về (768×1376), xem kỹ, so với sheet.
- Tập này: khung đầu thiếu bầu vú hồng so với sheet v1a. Người dùng không yêu cầu sửa.

---

## 4. Bước 3: dựng đoạn video theo mốc (Omni 1.2 Flash)

- **Chia clip** tại các điểm cắt của gốc, mỗi đoạn **≤ 15s**. Tập này: 0–9,5 | 9,5–21,1 | 21,1–35,733.
- **Khung tạo:**
  - Video, **Frames**, đặt **Start** là khung đầu, 9:16, 720p, **x1**.
  - Thanh Length: giá trị 0…12 tương ứng 3…15s.
  - Giá đo được: 10s = 30 credit, 12s = 42 credit, 15s = 60 credit.
- **Lệnh** (mỗi đoạn tính mốc từ 0):

```
Start exactly from the first frame. One continuous shot, <N> seconds, no cuts. Static locked-off camera with the same
vertical framing as the first frame: no zoom, no pan, no tilt, no camera shake. The <nhân vật> stands on the same spot
facing the camera the whole time, <thái độ>. 0 to 3.0 seconds: he listens in silence, muzzle closed, ...
3.2 to 3.9 seconds: he says one short word, flatly: "Ói." 3.9 to 4.8 seconds: pause, muzzle closed. ...
<a> to <b> seconds: he lifts both arms and waves his hooves in front of his chest ... <mỗi câu, mỗi khoảng ngậm,
mỗi cử chỉ một dòng, mốc lấy từ Bước 1>. His mouth moves only while he speaks. Vietnamese speech in a flat male voice,
no music. Nothing else in the room moves, nobody else appears, no text on screen.
```

- Cả 3 đoạn gửi liền nhau được, Flow render song song, mỗi đoạn 2–4 phút.
- Omni bám mốc khoảng ±0,3–0,5s. Phần lệch còn lại sửa ở Bước 8.

## 5. Bước 4: kéo video về máy

- Mở `/edit/<id>`, bấm vào bản cần lấy trong lịch sử, lấy URL `flow-content.google/video/...` trong `performance`, rồi fetch và `POST /save`. Đây là mục 8 trong `flow_doan_js.js`.
- Ảnh lấy theo mục 9.
- Kiểm lại bằng `ffprobe` (720×1280, 24 fps, đúng độ dài) và bằng bảng khung.
- Muốn xem nhanh một bản nháp ngay trên nền vừa dựng, chưa qua phông xanh: dùng [scripts/ghep_v1_dung_moi.sh](../scripts/ghep_v1_dung_moi.sh). Lệnh này cắt 3 đoạn, phóng to theo nhịp gốc, thêm ô bình luận và tiếng gốc. Đây là cách ra bản v001.

---

## 6. Bước 5–6: nền thật và tỉ lệ thật (cách đã chốt)

### 6.1 Đổi các đoạn sang phông xanh
- Mở trang sửa của từng đoạn do Flow tạo, đảm bảo bản đang chọn là bản cần đổi.
- Giá: 10s = 30 credit, 12s = 42 credit, 15s ≈ 60 credit.

```
Replace the entire background with a perfectly flat, evenly lit, pure chroma-key green screen (bright saturated green,
#00FF00): remove <các thứ trong nền>. Keep the cow exactly as he is in the original video: same design, same size, same
position in the frame, same body movements, gestures, head movements, expressions, mouth movements and timing, same
lighting and colors on him. Show his whole body including his feet. The green screen must be one uniform color
everywhere, with no shadows, no gradients, no floor line, no objects and no text. Do not add any green tint or green
reflections on the cow.
```
- Omni giữ cử động và tự lùi khung để thấy trọn người tới chân.
- Phải so từng giây với đoạn gốc. Tập này: đoạn 2 thêm một lần giơ tay ở khoảng 15,5s.

### 6.2 Ảnh nền trống (Nano Banana, 0 credit)
```
Photorealistic photo of <bối cảnh>, completely empty ... soft late-afternoon daylight (khớp ánh sáng trên nhân vật),
Vertical 9:16 photo taken from a static camera at standing chest height (about 1.2 m), looking straight ahead, 28 mm lens,
sharp foreground, background slightly soft. Leave a clear empty patch in the center foreground where one person could
stand, about 2 meters from the camera. Real-world scale everywhere. Nobody in the scene, no animals, no text,
no readable signs, no logos or brand names.
```

### 6.3 Ghép: tách phông, tỉ lệ, bóng, nhịp cận mặt, tiếng
Lệnh: [scripts/ghep_phong_xanh_ty_le_that.sh](../scripts/ghep_phong_xanh_ty_le_that.sh)
```bash
bash ghep_phong_xanh_ty_le_that.sh G1.mp4 G2.mp4 G3.mp4 nen.jpg bong_chan.png tieng_goc.wav o_binh_luan_720.png out.mp4
```
**Cách tính tỉ lệ** (đổi số khi đổi nền hay nhân vật):
1. Đo **px/cm ở chỗ chân nhân vật** bằng vật thật trong ảnh nền. Tập này: ghế đẩu nhựa khoảng 30cm, bàn nhựa thấp khoảng 50cm, ra khoảng 4,6 px/cm (ảnh 768×1376) ở hàng y khoảng 1265.
2. Chiều cao muốn có: Bò Bía khoảng **1,5m**, ra 690 px trên ảnh nền, tức **1294 px trên khung 1440×2560** (ảnh nền phóng ×1,875).
3. Đo khung bao nhân vật trên phông xanh: pixel không xanh, ra cao 1098, tâm x 358, chân y 1236. Hệ số `s = 1294/1098 = 1,178`, nên scale 848×1508.
4. Chỗ đặt = điểm chân trên nền (712, 2362) trừ điểm chân đã scale: ra (290, 906).
5. Màu khóa đo trên phông: `0x2EE036`. Dùng `chromakey=…:0.16:0.05,despill=type=green:mix=0.6`, rồi ám ấm nhẹ `colorbalance=rm=0.03:bm=-0.03`.
6. Bóng chân: elip mờ `bong_chan.png`, tâm (712, 2366), bán kính 230×38, đậm 0,55.
7. Nhịp phóng to bằng `zoompan` trên khung 1440×2560, ra 720×1280:
   - **z0 = 1,227**: thấy trọn người, nhân vật cao khoảng 62% khung;
   - **zCU = 3,2**: cận mặt;
   - ×1,374 cho shot hơi chặt;
   - lùi dần tuyến tính từ zCU về z0;
   - tọa độ y nội suy giữa 421 (trung) và 1045 (cận).
   Lịch dùng ở tập này: cận mặt 14,267–17,433 và 21,1–24,5, lùi đến 26,5, ×1,374 ở 19,267–21,1.
8. Ô bình luận đặt ở (141, 80) trong 0–9,5s. Tiếng gốc map thẳng vào, cắt `-t 35.733`.

---

## 7. Bước 7: sửa chi tiết nhân vật trên đoạn phông xanh

Ví dụ: mắt mở to từ giây 3. Sửa bằng Omni trên **bản phông xanh** (chọn đúng bản trong lịch sử):
```
Change only the cow's eyes: make his eyes wide open, with his upper eyelids raised high so they no longer droop or cover
the top of his eyes; the whole round iris and pupil are visible. Keep everything else exactly the same as in this video:
the flat green screen background, his design, fur, horns, ears, collar and bell, his size and position in the frame,
his body movements, arm gestures, head movements, muzzle and mouth movements, blinks and timing.
Do not change anything except the eyelids.
```
- **Nối tại mốc yêu cầu** (khung 72 = 3,0s ở 24 fps): lấy `trim=end_frame=72` từ bản cũ và `trim=start_frame=72` từ bản sửa, rồi `concat`.
- Ghép lại bằng lệnh ở 6.3 với các đoạn mới.
- So bản trước và bản sau ở 12 mốc thời gian.

---

## 8. Bước 8: sửa khớp miệng một cảnh (không dùng AI, 0 credit)

1. **Dò độ trễ** của cảnh cần sửa (tiếng Flow kèm clip được coi là dấu vết của miệng):
   ```bash
   bash scripts/tim_do_tre_mieng.sh tieng_goc.wav E2.mp4 9.5 14.267 17.433
   # -> Tot nhat: khung 11 (0,458 s), trung 0,77 ; Hien tai: trung 0,51
   ```
2. **Dựng lại riêng cảnh đó với hình trễ đúng số khung, rồi thay vào bản cũ.** Hai đầu cảnh nên là điểm cắt cảnh, để chỗ nhảy hình bị cắt che:
   ```bash
   bash scripts/sua_khop_mieng_doan.sh ban_cu.mp4 G1.mp4 G2.mp4 G3.mp4 nen.jpg bong_chan.png 343 419 11 3.2 ban_moi.mp4
   ```
   Khung 343–418 tương ứng 14,29–17,42s. Phần ngoài cảnh lấy thẳng từ bản cũ và nén lại một lần ở CRF 14 (PSNR khoảng 50dB).
3. **Kiểm:**
   - Bảng miệng 8 khung mỗi giây trong cảnh: miệng ngậm khi tiếng im, mở khi có tiếng.
   - Khung hai bên chỗ nối.
   - Số khung bằng bản cũ.

---

## 9. Kiểm và giao

**Checklist** cho mỗi bản:
- [ ] `ffprobe`: 720×1280, 24 fps, đúng số khung, tiếng dài đúng nội dung gốc.
- [ ] Bảng 12 khung ở các mốc: ô bình luận, trung cảnh, cận mặt, lùi dần, cử chỉ, cú chốt.
- [ ] Nhân vật đúng sheet đã khóa. Ghi rõ mọi chỗ lệch (vd thiếu bầu vú).
- [ ] Khớp miệng ở các câu chính: đo bằng độ lớn dải giọng nói, không đoán.
- [ ] Không chữ, không logo lạ. Dấu ✦ của Google vẫn còn (không xóa).
- [ ] Ô bình luận vẫn còn tên và ảnh của người bình luận thật: nhắc người dùng.

**Cách lưu:** `06_render/ban_nhap_<nhan_vat>_vNNN/`, gồm:
- file `.mp4`;
- `kiem_*.jpg`;
- `flow_goc/` chứa đoạn Flow gốc, khung đầu, ảnh nền;
- `ghep/` nếu lệnh ghép mới;
- `ghi_chu.md`: cách làm, credit, điểm cần người dùng xem.

Bản cũ giữ nguyên.

---

## 10. Tham số của tập Uong-oi-e (để tham chiếu)

| Mục | Giá trị |
|---|---|
| Clip gốc | 576×1024, 9:16, 30 fps, nội dung 0–35,733s, outro TikTok 35,73–39,75s |
| Điểm cắt gốc | 9,50 · 9,80 · 14,267 · 16,00 · 17,433 · 18,233 · 19,267 · 21,10 · 27,167 · 29,50 · 32,00 · 35,733 |
| Đoạn dựng | T1 0–9,5 (gen 10s) · T2 9,5–21,1 (gen 12s) · T3 21,1–35,733 (gen 15s) |
| Ô bình luận | gốc x 113–463, y 64–163 (576×1024); trên khung 720: 440×125 tại (141, 80), 0–9,5s |
| Nhân vật | Bò Bía, sheet `Rau_cau/02_nhan_vat/2.1_Bo_bia/character_sheet/bo_bia_character_sheet_v1a_raw.jpg` |
| Nền | quán nhậu vỉa hè trống, chiều dịu: `06_render/ban_nhap_bo_bia_v003/flow_goc/nen_quan_nhau_trong_v1.jpg` |
| Sửa khớp miệng | cảnh cận mặt 14,267–17,433, trễ 11 khung |

**Credit Flow đã dùng ở tập này:**

| Bước | Credit |
|---|---|
| v1 (3 đoạn) | 132 |
| v2 (nền mới, sau bỏ) | 132 |
| Phông xanh | khoảng 132 |
| Sửa mắt | khoảng 132 |
| Sửa khớp miệng | 0 |
| Lần sửa video gốc bị từ chối | 12, đã hoàn |

Nếu làm thẳng theo quy trình này, khoảng **3 × 132 credit** cho một clip 35s: dựng, phông xanh, và một lần sửa chi tiết.

## 11. Lịch sử phiên bản của tập (để hiểu vì sao quy trình như trên)

| Bản | Thay đổi | Người dùng |
|---|---|---|
| v001 | Dựng mới Bò Bía trong phòng xanh như gốc, tiếng gốc | Chốt diễn xuất |
| v002 | Dựng lại cả 3 đoạn với nền quán nhậu; Bò Bía to quá khổ so với bàn ghế | Không chọn |
| v003 | Diễn xuất v001 → phông xanh → nền quán nhậu thật, đúng tỉ lệ khoảng 1,5m | Chốt |
| v004 | v003, mắt mở to từ 3s | Chốt |
| v005 | v004, sửa khớp miệng 14,27–17,43s (trễ 11 khung) | Bản hiện hành |

## 12. Bài học

- Flow tự đặt nhân vật vào bối cảnh thì nhân vật thường **to quá khổ**. Muốn tỉ lệ thật thì tách phông và ghép trên máy, đo bằng vật có kích thước biết trước.
- Muốn đổi một thứ mà giữ diễn xuất (nền, mắt…): **sửa clip do Flow tạo** bằng Omni, không dựng lại.
- Mốc nói phải đo bằng **độ lớn dải giọng nói**. Omni lệch khoảng 0,3–0,5s ở vài câu: sửa bằng dời khung trong từng cảnh có cắt ở hai đầu.
- Trình duyệt của app:
  - Escape ở trang sửa video sẽ thoát ra lưới.
  - Mỗi lần chạy JS tối đa khoảng 45s.
  - Ảnh chụp màn hình có thể cũ: đổi cỡ khung 1–2 px để buộc vẽ lại.
  - Khi tab không ở phía trước thì luôn truyền `tabId`.
  - Bấm nút gửi bằng ref (`find` + `left_click`), không bằng JS.

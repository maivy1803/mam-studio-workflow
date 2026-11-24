# Quy chuẩn hình ảnh Mam_Studio / Halo_Cub (design system)

Tài liệu này ghi lại quy chuẩn hình ảnh mà các sheet đã chốt (2026-11-17 → 2026-11-23) đang theo. Số đo lấy thẳng từ ảnh. Luật style lấy từ ghi chú soát style và các prompt đã duyệt. Tài liệu không đặt thêm luật mới. Nếu người dùng đổi ý, lời người dùng thắng tài liệu này.

Bản xem trên web: trang Design System trên claude.ai, https://claude.ai/artifact/FTKDxFtAASthBFtXpbcm7E. Trang này riêng tư: chỉ tài khoản chủ mở được, trừ khi chủ chia sẻ từ menu Share của trang.

## 1. Style chung của series

**Chất liệu**
- Render 3D kiểu phim hoạt hình, không toon.
- Nhân vật là thú bông lông dày, xù nhẹ, mờ (không bóng).
- Có viền lông tơ quanh dáng và một chỏm lông rối trên đầu.

**Dáng**
- Mập lùn, cao khoảng 2,7 đầu, không cổ. Đầu đặt thẳng lên thân quả lê rộng hơn đầu, bụng tròn rộng nhất ở nửa dưới.
- Tay ống ngắn buông sát người, không thấy khuỷu.
- Chân ngắn, khoảng 1/6 chiều cao, đứng dạng vững.
- Bàn tay, bàn chân tròn kiểu găng, không tách ngón, không vuốt.
- Đứng hai chân như người.

**Mặt**
- Diễn bằng mí mắt: Bò mí nặng sụp nửa chừng, Gà mí sụp, Mèo mí vừa chạm mép tròng.
- Mõm hoặc mỏ là trung tâm mặt. Mũi to, khoảng 1/4 bề ngang mặt.
- Ngoại lệ đã khóa: **Vịt Lộn mắt hạt cườm** đen đặc, một chấm sáng, không lòng trắng, không mí, không lông mày. Không bao giờ đổi.

**Màu**
- Tông trầm, hơi bụi, tương phản thấp.
- Màu đen là đen than có ánh xám của sợi lông, không bao giờ đen tuyền. Nhìn từ sau lưng vẫn phải thấy khối tròn.
- Màu trắng là kem ngà ấm, tối hơn nền một bậc.

**Ánh sáng**
- Một đèn chính mềm, ấm, từ bên phải. Bóng xám ấm, không ngả lạnh.
- Bóng sàn dài đổ sang trái, có bóng tiếp xúc đậm dưới chân.

**Khẩu hình**
- Miệng mở vừa phải trong mõm, không quá cỡ của Bò.
- Lòng miệng tối, mờ. Không răng nanh, không thè lưỡi.

**Chi tiết**
- Không có nét mảnh quá thật (ria dài, ria lông mày, ngón chân tách).
- Nếu có ria thì ngắn, mềm.

**Giữ nhân vật**
- Mọi ảnh và video dùng đúng sheet chốt mới nhất.
- Ảnh nhóm chỉ đổi biểu cảm và tư thế.
- Không chép phụ kiện từ ảnh tham chiếu, trừ thứ người dùng gọi tên.
- Muốn sửa ảnh hay thêm cử động thì hỏi trước.

## 2. Character sheet

### 2.1 Bản raw (ảnh dùng làm tham chiếu)

| Thông số | Giá trị |
|---|---|
| Kích thước | 1376 × 768 (Google Flow, 16:9) |
| Nền | kem ngà liền, không đường chân trời, không vân. Đo được `#E6E7DB` → `#EBEBD7`; giá trị chuẩn `#E9E8DA` |
| Bố cục 3 ô (mặc định) | trái: chính diện toàn thân · giữa: sau lưng toàn thân, cùng cỡ, chân cùng đường đất · phải: chân dung (đầu và ngực trên), to, tràn mép dưới và mép phải |
| Bố cục 4 góc (Chó Phú Quốc, sheet concept Vịt) | chính diện · 3/4 · nghiêng · sau lưng, một hàng, chung đường đất |
| Khung | ở ô toàn thân, nhân vật chiếm khoảng 78–80 % chiều cao ảnh; đỉnh tai cách mép trên khoảng 12 % |
| Chữ | không chữ, không nhãn, không viền trong ảnh raw (nhãn ghép sau, mục 2.2) |

Ghi chú:
- Sheet Vịt Lộn v1a có nền trắng tinh `#FFFFFF`. Đây là lệch của bản đã khóa, giữ nguyên.
- Nhiều sheet chốt có dấu ✦ của Gemini ở góc phải dưới. Giữ nguyên, không tự xóa.

### 2.2 Bản có nhãn: 1376 × 936

Bản có nhãn gồm 3 dải, từ trên xuống: thanh tiêu đề, ảnh raw giữ nguyên, dải nhãn.

| Dải | y (px) | Nội dung |
|---|---|---|
| Thanh tiêu đề | 0–63 (cao 64) | nền `#222222`; tiêu đề chữ trắng đậm 23 px, lề trái 32 px, căn giữa theo chiều dọc |
| Ảnh raw | 64–831 (cao 768) | giữ nguyên, không chỉnh màu |
| Dải nhãn | 832–935 (cao 104) | nền `#FFFFFF`; nhãn đậm 24 px màu `#222222`, căn giữa dưới từng nhân vật, tâm chữ ở y ≈ 869 |
| Đường kẻ | y = 902, dày 1 px, x từ 24 đến 1352 | `#DCDCDC` |
| Chân trang | tâm chữ ở y ≈ 920, lề trái 28 px | chữ thường 14 px, màu `#6E6E6E` |

Ảnh có cỡ khác 1376 thì mọi số trên nhân theo tỉ lệ `rộng / 1376`.

**Font**
- Windows: Segoe UI Bold cho tiêu đề và nhãn, Segoe UI cho chân trang.
- macOS: Arial Bold và Arial.
- Font nào thay cũng phải đủ dấu tiếng Việt.

**Tiêu đề**: `<TÊN IN HOA>[ · <MÔ TẢ>] — character sheet[ <bản>] (ĐÃ CHỐT yyyy-mm-dd)`.
Ví dụ: `HEO 1 · ĐEN TRẮNG — character sheet (ĐÃ CHỐT 2026-11-23)`.

**Nhãn ô**: có hai kiểu đang dùng, chọn theo sheet cùng nhóm.
- Song ngữ, dùng ở Bò, Mèo 23/11, Gà: `FRONT · Chính diện` | `BACK · Sau lưng` | `CHÂN DUNG`.
- Tiếng Việt, dùng ở 2 Heo: `Chính diện` | `Sau lưng` | `Cận mặt`.
- Sheet 4 góc: `FRONT · Chính diện` | `3/4 · Ba phần tư` | `SIDE · Nghiêng` | `BACK · Sau lưng`.

**Chân trang**: `<phiên lớn hoặc tập> · #<sub-session> · <nguồn> · yyyy-mm-dd`.
- `<nguồn>` là `Google Flow gen_i2i` hoặc `bản người dùng gửi và chốt`.
- Ví dụ: `Team-suc-vat · #2.6_Heo · bản người dùng gửi và chốt · 2026-11-23`.

**Công cụ**: `scripts/tao_sheet_co_nhan.mjs` ghép đúng quy chuẩn trên. Script chạy được trên macOS và Windows, cần ffmpeg. Script tự dò vị trí nhân vật để đặt nhãn, không sửa ảnh gốc, không ghi đè file có sẵn.

## 3. Bảng màu nhân vật

Các mảng màu chính dưới đây đo bằng `scripts/bang_mau_tu_sheet.mjs` (k = 6, đã bỏ nền), xếp từ nhiều đến ít. Số đo gồm cả vùng bóng trên lông. Chi tiết nhỏ (mỏ, mũi, chuông) quá ít điểm ảnh để lọt vào bảng, nên ghi bằng chữ.

| Nhân vật (sheet) | Mảng màu đo được | Màu chính đặt tên | Chi tiết nhận diện bằng chữ |
|---|---|---|---|
| Bò Bía (v1a, khóa 2026-11-17) | `#665E57` `#AAA093` `#423F3B` `#867D73` `#C6BCAF` `#202122` | lông kem `#C6BCAF`, đốm đen `#202122` | đầu đen có vệt trắng giữa mặt; mõm hồng tím; tai trong hồng; sừng kem cong ngắn; vòng cổ da nâu có chuông đồng; mi nặng lờ đờ |
| Vịt Lộn (v1a, khóa 2026-11-17) | `#CABDA0` `#AA9D83` `#907D5E` `#181C28` `#DFD9CA` `#3F4046` | lông vàng kem `#CABDA0`, tóc xanh đen `#181C28` | tóc cắt bát bóng như mũ, mái bằng; mỏ dẹt cam vàng; chân màng cam; **mắt hạt cườm** |
| Mèo (bản 2026-11-23) | `#856344` `#A57A52` `#B9936E` `#6A492B` `#978475` `#C5B5A1` | cam vằn `#A57A52`, vằn nâu `#6A492B`, ngực kem `#C5B5A1` | mèo cam vằn mập lùn, lông xù dày; tai to lòng hồng; mắt xanh vàng; mũi hồng nhỏ; mặt lim dim điềm tĩnh; đuôi ngắn xù |
| Gà (CHOT, 2026-11-22) | `#201B17` `#0D0D0A` `#54241A` `#8B371D` `#B5A99C` `#A65542` | ngực bụng đen `#201B17`, vai maroon `#54241A`, cánh cam `#8B371D` | gà trống đỏ đen; mặt da đỏ, mí sụp chán đời; mỏ kem, miệng mếu; mào cục, không tích; bờm cổ cam; đuôi xanh chai; chân đỏ |
| Chó Phú Quốc (PQ v1, 2026-11-22) | `#A6764C` `#BB8C5F` `#C8A680` `#885F3D` `#D6C2A9` `#614028` | vàng gừng `#BB8C5F`, xoáy lưng nâu `#885F3D` | tai dựng to; mí nặng; mũi đen; xoáy lưng dải hẹp viền nâu đỏ; đuôi buông thấp |
| Heo 1 đen trắng (2026-11-23) | `#0F1112` `#292B2D` `#D0C3B6` `#ABA199` `#857F7B` `#4D4C4B` | đen `#0F1112`, khúc giữa trắng hồng `#D0C3B6` | đầu, mông và chân đen; khúc giữa trắng hồng; tai cụp; mũi hồng |
| Heo 2 hồng (2026-11-23) | `#DAAFA8` `#C79F99` `#967670` `#E9C2BA` `#AC8C87` `#7C5A52` | hồng `#DAAFA8`, hồng sáng `#E9C2BA` | toàn thân hồng; tai cụp; đuôi xoăn |

Nhân vật mới: chạy `node scripts/bang_mau_tu_sheet.mjs <sheet_raw.jpg>`, rồi thêm một dòng vào bảng này.

## 4. Ảnh nhóm, lineup, avatar

- Mọi con chung đường đất. Bò cao nhất, Vịt khoảng 1/2 Bò. Tỉ lệ chiều cao này còn tạm, chưa khóa.
- Ảnh nhóm: Bò ở giữa, các con khác dàn đều khung hình. Người dùng yêu cầu như vậy ở avatar v4.
- Chữ `halo club` trên avatar chưa có bản chốt. Đã thử: chữ 3D đồ chơi, chữ lông xù đen, chữ `HALO CLUB` lông xù pastel. Chưa có logo chốt. Khi cần chữ này thì hỏi người dùng dùng kiểu nào.

## 5. Đặt tên file và thư mục

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| Thư mục tập | `Halo_Cub/<Ten_tap>/`, có `PROJECT_INDEX.md` | `Halo_Cub/Uong-oi-e/` |
| Thư mục nhân vật | `Halo_Cub/<nhom>/02_character_sheet/2.N_<Ten>/`; bên trong có `character_sheet/`, `tham_chieu/`, `nhep_mieng/` và file `2.N_<Ten>.md` | `2.6_Heo/character_sheet/` |
| Tên nhân vật trong tên file | không dấu, gạch dưới, ngắn | `bo_bia`, `vit_lon`, `meo`, `ga`, `cho_pq`, `heo_1_den_trang`, `heo_2_hong` |
| Bản gốc sheet | `<nv>_character_sheet_v<N><a\|b>_CHOT.webp`: giữ nguyên byte tải về hoặc người dùng gửi; ghi kích thước, số byte và sha256 vào file `.md` | `cho_pq_character_sheet_v1_CHOT.webp` |
| Bản tham chiếu | `..._raw.jpg`: JPEG q95, không nhãn | `bo_bia_character_sheet_v1a_raw.jpg` |
| Bản có nhãn | `..._CHOT.jpg` hoặc `..._CHOT_co_nhan.jpg`, 1376 × 936 | `heo_2_hong_character_sheet_CHOT_co_nhan.jpg` |
| Sheet người dùng gửi, không có số bản | dùng ngày thay cho số bản | `meo_character_sheet_2026-11-23_raw.jpg` |
| a / b | hai phương án của cùng một lượt gen. Nay chỉ render x1 nên chỉ có `a` | `v1a` |
| Ảnh tham chiếu | `tham_chieu/<nv>_ref_NN_<mo_ta>.png` | `meo_ref_06_meo_cam_thon.png` |
| Bản dựng, clip | mỗi bản mới lưu thành `vNNN` riêng, không sửa bản cũ. Không sửa, chuyển hay xóa clip gốc | `v005` |

## 6. Khối prompt style (tiếng Anh, dùng lại khi gen nhân vật mới)

Đoạn dưới rút từ prompt sửa style đã duyệt. Phần nhận diện riêng của từng con lấy từ câu mô tả một dòng trong file `.md` cạnh sheet.

```
Stylized 3D cartoon character in the same series as the fluffy cartoon Holstein cow and the fluffy bowl-cut duckling: a chunky, short, bottom-heavy plush-toy build, about 2.7 heads tall, no visible neck, the head sitting directly on a soft pear-shaped body that is wider than the head, with a round belly widest in the lower half. Short, thick tube arms rest flush against the sides with no visible elbows. Short, thick, stubby legs about one sixth of total height in a planted stance. Paws are simple rounded mitten nubs with no separated toes or claws. The fur is deep, dense, slightly tousled and matte, with a small messy tuft on top of the head and a soft halo of stray hairs around the whole silhouette. Black fur is soft charcoal-black with visible grey strand highlights, never jet black; white fur is warm creamy ivory, a step darker and warmer than the background. Warm, soft studio key light from the right, warm-grey shadows with no cool tint, a long soft floor shadow falling left with dark contact shadows under the feet, muted, slightly dusty, low-contrast grade. LAYOUT: three panels side by side on one seamless warm off-white background: (1) full body, front view, standing straight, arms relaxed, neutral face, looking at the camera; (2) full body, back view, same size and pose; (3) portrait, head and chest close-up, front view. The two full-body views are the same size with their feet on the same ground line, filling about 78-80 percent of the image height. No text, no labels, no numbers, no borders, no other characters.
```

Nhắc lại khi dùng trên Google Flow:
- Làm tay trong trình duyệt của app.
- Tắt Agent mode.
- Chỉ render x1.
- Tự tải ảnh tham chiếu lên (sheet chốt mới nhất, bản `_raw.jpg`).
- Có Vịt thì ghi khóa mắt hạt cườm trong prompt, **và gắn sheet concept 6 biểu cảm** `vit_lon/tham_chieu/Duck_character_turnaround_sheet_ebd7d6f6.jpg`. Test Shot A v3 cho thấy chỉ ghi chữ thì Flow vẫn vẽ mắt có lòng trắng.

## 7. Ảnh tham chiếu trong bộ cài

Tất cả nằm ở `<dự án>/_Mam_Studio_Kit/tai_nguyen/`.

| Ảnh | Dùng khi |
|---|---|
| `nhan_vat/<nv>/…_raw.jpg` (hoặc `ga_character_sheet_CHOT.png`) | Gắn Flow mỗi khi có con đó |
| `nhan_vat/<nv>/…_v1a.jpg`, `…_CHOT.jpg`, `…_co_nhan.jpg` | Bản có nhãn, để người xem nhận mặt và đối chiếu; không gắn Flow |
| `nhan_vat/vit_lon/tham_chieu/Duck_…3af3b1fe.jpg` | Concept 4 góc của Vịt (khóa 2026-11-16): cần góc 3/4 hoặc nghiêng của Vịt |
| `nhan_vat/vit_lon/tham_chieu/Duck_…ebd7d6f6.jpg` | Concept 6 biểu cảm của Vịt (khóa 2026-11-16): giữ mắt hạt cườm, hoặc cần biểu cảm Vịt |
| `nhan_vat/bo_bia/tham_chieu/bo_bia_turnaround_ref_01.jpg` | Sheet 4 góc của Bò, nguồn của v1a: cần góc 3/4 hoặc nghiêng của Bò. Ảnh này chưa khóa (câu 11) |
| `nhan_vat/bo_bia/bieu_cam/bo_bia_B05_S09_im_lang.png` | Biểu cảm Bò mắt mở to đứng hình (khóa 2026-11-17) |
| `nhan_vat/_style_chung/style_bo_vit_4_goc.jpg` | Làm nhân vật mới cho đồng bộ style; chỉ lấy style |
| `boi_canh/rau_cau_bep_nha_bo_vit/ref_bep_san_vuon_01.webp` | Quay lại bối cảnh bếp nhà Bò và Vịt (tập Rau_cau) |

Mỗi lượt gen chỉ gắn vài ảnh. Sheet Chó PQ v1 gắn 3 ảnh, MCP cũ báo lỗi từ ảnh thứ 3. Thứ tự ưu tiên:
1. sheet không nhãn của nhân vật chính trong shot;
2. sheet biểu cảm, nếu có Vịt;
3. ảnh góc hoặc bối cảnh.

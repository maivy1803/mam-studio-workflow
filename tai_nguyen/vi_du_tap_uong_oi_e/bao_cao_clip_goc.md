# Nghiên cứu clip gốc — tập `Uong-oi-e`

> Phiên con `#2 Uong oi e` (phiên lớn Series-phim). Ngày nghiên cứu: 2026-11-23.
> Trạng thái: **tài liệu tham khảo**, chưa khóa gì. Kịch bản thuộc `#1_kich_ban` của tập.

---

## Tóm tắt nhanh

- Clip là **một con husky "trả lời bình luận"**: "Em bị ép nhậu thì xử lý sao a 😳". Nó đáp "Ói." rồi kể leo thang các chỗ sẽ ói: lên mình → từ cổ xuống quần → bồn cầu → lên bàn → vô nồi lẩu → vô dĩa món tụi nó thích → vô người thằng ép. **Cú chốt:** "Em ỉa tại bàn đó luôn."
- Nội dung thật dài **35,73s**. Sau đó là **4s outro TikTok**. File dọc 9:16, 30 fps.
- Chuỗi nguồn:
  1. Clip **người thật** "Em ói cho anh..." của @thanhdaudau69 (24/09/2026, 57s, ~991 nghìn lượt xem).
  2. Bản **AI thay người bằng husky** của @ngaokaday, tên cũ @ngaovadongbon (13/10/2026, ~290 nghìn lượt xem). TikTok gắn nhãn nội dung AI.
  3. File người dùng tải về bằng nút lưu video của TikTok.
- **Cả tập nằm trong lời thoại.** Hình chỉ có một con chó ngồi trong phòng, nói, thỉnh thoảng giơ chân. Bồn cầu, bàn nhậu, nồi lẩu chỉ được nói tới, không xuất hiện trong hình.
- Tên "Uong oi e" **không trùng với trend nào** tìm được trên web. Cách hiểu hợp lý nhất là "Uống – ói – ẻ" (bị ép uống → ói → ẻ). Đây là suy luận, chưa xác nhận.

---

## 1. Thông số file

| Mục | Giá trị |
|---|---|
| File | `Halo_Cub/Uong-oi-e/1795351416656_2277497963049064376_2592779964886567896.mp4` (2.619.456 byte, không sửa) |
| Thời lượng file | 39,75s (1192 khung) |
| Nội dung thật | **0,00–35,73s**. Từ 35,73–39,75s là outro TikTok: logo + ô tìm kiếm "@ngaovadongbon" |
| Độ phân giải / tỉ lệ | **576×1024, dọc 9:16** (dự án dùng ngang 16:9) |
| FPS | **30** (Rau_cau đã khóa 24) |
| Video | H.264 High, yuv420p, BT.709, ~417 kbps |
| Âm thanh | **Có tiếng.** AAC-LC stereo 44,1 kHz, ~100 kbps. Hết tiếng từ ~37,0s |
| Tên file | Phần đầu `1795351416656` là dấu thời gian Unix (ms) = 2026-11-22 12:43:36 UTC, khớp thời điểm tạo file. Hai số sau **không phải** ID video TikTok (ID thật là `7696041745171156244`) |
| Metadata | Thẻ ByteDance: `aigc_info {"aigc_label_type":2}`, `TEEditor`, `te_is_reencode:0`, `source:2`. Ý nghĩa giá trị `2`: xem mục 10 |

**Cách làm:**
- Dùng ffprobe và ffmpeg để đọc thông số, dò điểm cắt (`scdet`, `select=scene`) và tách khung 2 hình/giây, đoạn khó thì 4 hình/giây.
- Chép lời bằng bộ lọc whisper của ffmpeg với model `ggml-large-v3-turbo-q5_0.bin`, lưu ở `C:\Users\PC\.cache\whisper\` để các tập sau dùng lại. Chạy cả clip một lượt, rồi chạy lại từng câu sau khi cắt theo khoảng lặng.
- Đối chiếu với phụ đề tự động của TikTok trên trang video: hai bản khớp nhau.

---

## 2. Nguồn gốc

```
@thanhdaudau69 "Em ói cho anh..."          (người thật, 24/09/2026, 57s)
        │  giữ nguyên tiếng, phòng, ô bình luận; thay người bằng husky (AI), cắt còn 35,9s
        ▼
@ngaokaday (tên cũ @ngaovadongbon) — husky "Ngáo"   (13/10/2026, nhãn nội dung AI)
        │  nút "Lưu video" của TikTok (thêm outro @ngaovadongbon)
        ▼
File người dùng (lưu 22/11/2026)
```

- **Bản husky:** https://www.tiktok.com/@ngaokaday/video/7696041745171156244 _(tự kiểm ngày 23/11/2026)_
  - Đăng 13/10/2026, 13:52 giờ VN. Dài 35s.
  - Caption: "Nói sớm câu cuối luôn là được rồi😂😂😂 #clipviral #videohaihuoc #funny #vuinhon #videohai #ngao #xuhuong #husky #fyp".
  - Âm thanh: "âm thanh gốc - Ngáo Và Đồng Bọn".
  - Dữ liệu trang: `IsAigc=false`, `moderationAigcLabelType="1"`. Theo subagent, trang hiện dòng "Contains AI-generated media"; tôi chỉ tự thấy trường dữ liệu.
- **Bản gốc người thật:** https://www.tiktok.com/@thanhdaudau69/video/7689069744762146055 _(tự kiểm ngày 23/11/2026)_
  - Kênh THANH ĐAU ĐẦU, caption "Em ói cho anh...". Đăng 24/09/2026, dài 57s, 576×1024.
  - Ảnh bìa: một người đàn ông áo thun sọc xanh, khoanh tay trên bàn, nói vào máy.
  - **Cùng căn phòng** tường xanh, cửa gỗ, cùng ô bình luận "Em bị ép nhậu thì xử lý sao a".
  - Theo phụ đề tự động TikTok (subagent đọc), bản gốc **còn một đoạn kết** sau câu "ỉa tại bàn". Người nói kể về sau ngại vài tháng nhưng không ai dám rủ nhậu nữa. Bản husky **cắt bỏ đoạn này**, nên caption mới ghi "Nói sớm câu cuối luôn là được rồi". Đoạn kết đó **không có** trong clip người dùng gửi.
- **@ngaovadongbon là tên cũ của @ngaokaday:** có cơ sở mạnh nhưng chưa khẳng định. Kết luận này dựa vào ba điểm:
  - @ngaovadongbon hiện không tồn tại.
  - Tên âm thanh vẫn là "Ngáo Và Đồng Bọn", còn tác giả là "Ngáo Ka 🐺".
  - Một duet tag "@Ngáo Và Đồng Bọn" trỏ về tài khoản ngaokaday.

---

## 3. Độ lan truyền (số công khai, đọc ngày 23/11/2026)

| Video | Kênh | Ngày đăng | Xem | Thích | Bình luận | Chia sẻ | Lưu | Ai kiểm |
|---|---|---|---|---|---|---|---|---|
| Bản gốc người thật | @thanhdaudau69 | 24/09/2026 | 991.400 | 29.400 | 1.679 | 23.400 | 1.761 | tự kiểm |
| Bản husky AI (clip này) | @ngaokaday | 13/10/2026 | 289.700 | 7.361 | 474 | 6.611 | 830 | tự kiểm |

Các số dưới đây do subagent đọc trên trang TikTok công khai; tôi chưa tự kiểm lại:

- **Kênh @ngaokaday "Ngáo Ka 🐺":**
  - 27.981 follower, 700.069 lượt thích, 110 video, tạo 11/12/2025.
  - Chủ đề: husky "Ngáo" nói bằng giọng lồng tiếng hài.
  - Clip cao nhất khoảng 3,3 triệu lượt xem.
- **Kênh THANH ĐAU ĐẦU:** 527.383 follower, 21,94 triệu lượt thích. Hai ngày sau kênh đăng phần tiếp "Nghệ thuật ói trên bàn nhậu..." (26/09/2026, 171.700 lượt xem).
- **Số video dùng âm thanh:** âm thanh gốc THANH ĐAU ĐẦU có **42 video**, âm thanh bản husky có **29 video** (phần lớn là duet).
  - Đây là mức lan truyền **vừa phải**, chưa thành sound viral lớn.
- **Các kiểu làm lại đã thấy:**
  - đăng lại bản người thật;
  - bản AI husky (clip này);
  - bản AI con khỉ "Bố khỉ tấu hài 2: đi nhậu bị ép uống phải làm sao" của @kytuoikhi (13/11/2026, ~72 nghìn lượt xem, lời viết lại);
  - duet và lip-sync của người dùng thường.
  - **Chưa thấy bản hoạt hình 3D nào.**

---

## 4. Nhân vật, bối cảnh, đạo cụ

| Mục | Mô tả |
|---|---|
| Nhân vật trong hình | **1**: husky Siberian nâu đỏ–trắng, mắt xanh nhạt, ngồi thẳng nhìn vào máy. Mặt "nghiêm", hay liếc xéo, nhíu mày. Có lúc ngồi lên giơ hai chân trước, có lúc giơ một chân |
| Giọng | **2 giọng** (suy luận, chưa nghe bằng tai): **người hỏi ngoài khung** đọc câu hỏi ở 0–2,9s (con chó không mấp máy miệng trong đoạn này) và **người đáp**, tức con chó, từ 3,2s. Cả hai đều là giọng nam, cùng tầm cao độ (~150–200 Hz), giọng miền Nam. Tiếng là tiếng gốc của clip người thật |
| Bối cảnh | Trong nhà, ban ngày. Tường trái **xanh lá đậm**, tường phải **xám trắng**, khung **cửa gỗ nâu đậm** bên phải sau lưng. Sàn tối, góc dưới trái có khung gỗ thấp (nan gỗ). Ánh sáng tự nhiên mềm từ phía trước, tông ấm |
| Đạo cụ trong hình | **Không có.** Con chó không cầm gì |
| Thứ chỉ có trong lời | áo, quần, bồn cầu, bàn nhậu, nồi lẩu, dĩa đồ ăn, "mấy thằng ép uống" (không xuất hiện trong hình) |
| Lớp phủ đồ họa | Ô "trả lời bình luận" kiểu TikTok ở đầu khung, 0–9,5s; watermark TikTok @ngaovadongbon |

---

## 5. Bảng phân cảnh

- **Máy quay:** cố định, ngang tầm mắt con chó, thẳng trước mặt. Không lia, không dolly.
- **Cách dựng:** jump cut kiểu video nói chuyện trên TikTok, cộng các lần **phóng to số (punch-in)** sang cận mặt.
- **Cỡ cảnh:** "Trung" là con chó ngồi thấy gần hết thân. "Cận" là mặt và ngực.

| Shot | Thời gian (s) | Dài (s) | Cỡ cảnh / máy | Hành động | Lời (người nói) |
|---|---|---|---|---|---|
| S01 | 0,00–9,50 | 9,50 | Trung, tĩnh. **Ô bình luận** ở trên | Ngồi im khi bị hỏi; nghiêng đầu, mấp máy theo lời từ 3,2s | (Hỏi, ngoài khung) "Còn mấy trường hợp bị ép uống thì xử lý sao anh?" → "Ói." → "Em ói cho anh." → "Ép em nhậu, uống tới mức độ nào đó, em sẽ ói." |
| S02 | 9,50–9,80 | 0,30 | Trung, jump cut. **Ô bình luận biến mất** | Ngồi, nhìn máy | _(lặng)_ |
| S03 | 9,80–14,27 | 4,47 | Trung | Ngồi nói; **11,0s nhổm lên, giơ hai chân trước** khua trước ngực, từ cổ xuống; 13,7s hạ chân | "Em ói lên mình em nè." → "Em ói từ cổ, ướt áo…" |
| S04 | 14,27–16,00 | 1,73 | **Cận mặt** (punch-in) | Mặt nghiêm, liếc; chân lấp ló dưới khung | "…xuống tới quần luôn." |
| S05 | 16,00–17,43 | 1,43 | Cận mặt, jump cut | Nói, mặt tỉnh bơ | "Em ói tiếp ở cái bồn cầu," |
| S06 | 17,43–18,23 | 0,80 | Trung | **Giơ một chân trước** | "xong em chạy ra bàn," |
| S07 | 18,23–19,27 | 1,04 | Trung, jump cut | Hạ chân, ngồi | _(hết câu trên)_ |
| S08 | 19,27–21,10 | 1,83 | Trung, jump cut | Ngồi nói | "em ói lên bàn." |
| S09 | 21,10–27,17 | 6,07 | **Cận mặt**, từ ~24,5s **zoom lùi chậm** về trung cận (~26,5s) | Nhíu mày, liếc xéo, nói chậm rãi | "Sau đó em ói vô nồi lẩu." → "Em thấy nó thích ăn món nào, em ói vô cái dĩa đó." |
| S10 | 27,17–29,50 | 2,33 | **Trung rộng hơn**, jump cut | Ngồi nói | "Mấy cái thằng ép em uống, nó sẽ đỡ em," |
| S11 | 29,50–32,00 | 2,50 | Trung | **Giơ một chân** (29,5–30,0s) rồi hạ | "em ói vô người nó luôn cho anh." |
| S12 | 32,00–35,73 | 3,73 | Trung | **Há miệng như cười** (32,5–34,5s), giữ ~0,7s sau chữ cuối | "Em thấy chưa? Hả dạ." → **"Em ỉa tại bàn đó luôn."** |
| — | 35,73–39,75 | 4,02 | Outro TikTok | — | (tiếng outro TikTok) |

Trung bình 3,0s/shot. Trừ S01 dài 9,5s, phần giữa (14,27–21,10s) cắt dồn **5 shot trong 6,8s**. Các lần cận mặt rơi đúng vào những chỗ ói "quá đà" nhất: quần, bồn cầu, nồi lẩu, dĩa.

---

## 6. Lời thoại nguyên văn

Tiếng Việt giọng miền Nam, không cần dịch. Bản có mốc thời gian để nhập vào phần mềm dựng: [thoai_clip_goc.srt](thoai_clip_goc.srt).

| # | Thời gian (s) | Người nói | Lời |
|---|---|---|---|
| 1 | 0,00–2,87 | Người hỏi (ngoài khung) | Còn mấy trường hợp bị ép uống thì xử lý sao anh? |
| 2 | 3,24–3,87 | Chó | **Ói.** |
| 3 | 4,82–5,80 | Chó | Em ói cho anh. |
| 4 | 6,50–9,31 | Chó | Ép em nhậu, uống tới mức độ nào đó, em sẽ ói. |
| 5 | 9,79–10,84 | Chó | Em ói lên mình em nè. |
| 6 | 11,34–15,56 | Chó | Em ói từ cổ, ướt áo, xuống tới quần luôn. |
| 7 | 15,80–17,87 | Chó | Em ói tiếp ở cái bồn cầu, |
| 8 | 18,07–19,02 | Chó | xong em chạy ra bàn, |
| 9 | 19,52–20,62 | Chó | em ói lên bàn. |
| 10 | 21,51–22,78 | Chó | Sau đó em ói vô nồi lẩu. |
| 11 | 23,85–26,94 | Chó | Em thấy nó thích ăn món nào, em ói vô cái dĩa đó. |
| 12 | 27,20–29,60 | Chó | Mấy cái thằng ép em uống, nó sẽ đỡ em, |
| 13 | 29,70–31,37 | Chó | em ói vô người nó luôn cho anh. |
| 14 | 31,60–32,95 | Chó | Em thấy chưa? Hả dạ. |
| 15 | 33,22–35,00 | Chó | **Em ỉa tại bàn đó luôn.** |

**Chỗ cần người dùng nghe lại:**
- **#15, chữ "ỉa":** whisper và phụ đề tự động TikTok đều nghe là "ỉa". Tên tập "Uong oi e" gợi ý có thể là "ẻ" (cùng nghĩa, lóng miền Nam).
- **#5, chữ "em" thứ hai** trong "mình em nè": hai lần chạy whisper ra hai kết quả khác nhau, phụ đề TikTok có chữ "em".
- **#1 có phải người khác nói không:** chỉ suy ra từ việc con chó không mấp máy miệng.
- **Âm 4,05–4,54s:** rất nhỏ, không ra chữ.

**Nghĩa từ lóng (cho `#1` và `#4`):**
- "ói" = nôn.
- "cho anh" = nhấn giọng kiểu "nghe anh nè".
- "nó sẽ đỡ em" = tụi nó sẽ dìu em, thấy em say nên đỡ dậy.
- "hả dạ" = hả giận, đã.
- "ỉa/ẻ" = đi ngoài.
- Từ "ói" lặp **10 lần** trong 31s.

---

## 7. Chữ trên màn hình, nhạc, tiếng động

- **Chữ trên màn hình:**
  - Ô trả lời bình luận (0–9,5s): "Em bị ép nhậu thì xử lý sao a 😳 · 1 phút · Trả lời", kèm tên và ảnh đại diện một người xem. Ảnh cắt: [khung_hinh/binh_luan_overlay.png](khung_hinh/binh_luan_overlay.png).
  - Watermark TikTok @ngaovadongbon, đổi vị trí lúc ~5s.
  - Không có phụ đề cháy, không có chữ hiệu ứng.
- **Nhạc nền:** **không có.** Phổ âm cho thấy giữa các câu chỉ còn tiếng nền phòng (~-45 dB): [khung_hinh/pho_am_thanh.png](khung_hinh/pho_am_thanh.png).
- **Tiếng động:**
  - Không có SFX dựng thêm.
  - Có một vệt âm cao rất nhỏ ở ~6,0s (2,4–3,2 kHz), không rõ nguồn.
  - Tiếng outro TikTok ở 35,7–36,6s, không thuộc nội dung.

---

## 8. Hook, nhịp dựng, cú chốt

| Nhịp | Thời gian (s) | Shot | Chuyện gì xảy ra |
|---|---|---|---|
| **Hook** | 0,00–3,87 | S01 | Ô bình luận là câu hỏi đời thường ai đi nhậu cũng gặp. Người hỏi đọc lại câu hỏi, chó im lặng nghe. Sau 0,4s chó **đáp gọn một chữ: "Ói."** |
| **Setup** | 4,82–9,31 | S01 | Giải thích nghiêm túc: bị ép tới mức nào đó thì "em sẽ ói". |
| **Leo thang** | 9,79–26,94 | S03–S09 | Liệt kê chỗ ói, mỗi chỗ quá hơn chỗ trước: lên mình → cổ, áo, quần → bồn cầu → lên bàn → nồi lẩu → dĩa món tụi nó thích. Cắt dồn và cận mặt ở các chỗ quá nhất; mặt chó luôn tỉnh bơ. |
| **Đỉnh trả đũa** | 27,20–31,37 | S10–S11 | Ói vô người chính "thằng ép em uống", đúng lúc nó đỡ mình. |
| **Cú chốt** | 31,60–35,00 | S12 | "Em thấy chưa? Hả dạ." Rồi vượt thêm một bậc: từ **ói** sang **ỉa** tại bàn. Chó há miệng như cười. |
| Giữ khung | 35,00–35,73 | S12 | ~0,7s rồi cắt cứng. Không có đoạn kết của bản người thật. |

**Vì sao buồn cười** (chỉ mô tả những gì có trong clip):
1. **Đáp một chữ:** câu trả lời đi thẳng vào giải pháp "bẩn" nhất, không vòng vo.
2. **Leo thang:** mỗi chỗ ói "tệ" hơn chỗ trước. Khán giả đoán được hướng đi nhưng không đoán được điểm dừng.
3. **Mặt nghiêm, chuyện bẩn:** con chó nói như đang tư vấn thật, liếc xéo, nhíu mày.
4. **Chốt vượt bậc:** khi khán giả nghĩ ói vô người là hết cỡ thì nó chuyển sang "ỉa tại bàn". Bản husky cắt ngay đó, đúng như caption "Nói sớm câu cuối luôn là được rồi".

**Quy đổi sang 24 fps** (nếu giữ nguyên nhịp):

| Mốc | Giây | Frame @24 |
|---|---|---|
| "Ói." | 3,24 | 78 |
| Bắt đầu leo thang | 9,79 | 235 |
| Cận mặt đầu tiên | 14,27 | 342 |
| Cận "nồi lẩu" | 21,10 | 506 |
| Vô người thằng ép | 29,70 | 713 |
| Bắt đầu câu chốt | 33,22 | 797 |
| Hết chữ cuối | 35,00 | 840 |
| Hết nội dung | 35,73 | **857** |

---

## 9. Dữ liệu cho tập Halo_Cub

### 9.1 Cần giữ đúng như gốc
- **Thứ tự và câu chữ 15 câu thoại** ở mục 6. Riêng câu "Ói." phải đứng một mình ngay sau câu hỏi.
- **Thứ tự leo thang:** mình → cổ/áo/quần → bồn cầu → bàn → nồi lẩu → dĩa → người thằng ép → ỉa tại bàn.
- **Cú chốt là câu cuối**, cắt ngay sau đó (~0,7s giữ khung). Không thêm đoạn kết.
- **Kiểu diễn:** một nhân vật ngồi nói thẳng vào máy, mặt tỉnh bơ, nghiêm, liếc xéo. Cử chỉ chỉ có giơ hai chân khua từ cổ xuống (11–13,7s), giơ một chân (17,5s và 29,5s), và há miệng cười ở câu chốt.
- **Cách dựng:** máy tĩnh, jump cut, cận mặt ở 14,27s, 16,0s và 21,1–24,5s, zoom lùi chậm ở 24,5–26,5s.
- **Ô "trả lời bình luận"** ở 0–9,5s là hook bằng chữ.

### 9.2 Thông tin cho từng Session

| Session | Dữ liệu từ clip gốc |
|---|---|
| `#1_kich_ban` | 15 câu thoại, 12 shot, cấu trúc Hook → Setup → Leo thang → Trả đũa → Chốt. Độ dài nội dung **35,73s = 857 frame @24**, **vượt khung 15–30s của dự án ~5,7s**. Tổng khoảng lặng giữa các câu khoảng 7–8s. |
| `#2_nhan_vat` | **1 nhân vật trong hình** (người đáp) + **1 giọng ngoài khung** (người hỏi, 1 câu). Cần biểu cảm: tỉnh bơ, liếc xéo, nhíu mày, há miệng cười. Cần tư thế: ngồi, nhổm lên giơ hai tay, giơ một tay. |
| `#3_moi_truong` | 1 bối cảnh trong nhà: tường xanh lá đậm + tường xám trắng, cửa gỗ nâu. Không đạo cụ trong hình. Gốc là khung dọc 9:16, nhân vật ở giữa. Khi chuyển sang 16:9 thì nhân vật ở giữa sẵn, hợp safe zone để crop dọc. |
| `#4_sound` | Chỉ có giọng, không nhạc, không SFX dựng. Giọng gốc là **giọng người thật của @thanhdaudau69**; bản husky dùng lại nguyên tiếng này. File lời có mốc: `thoai_clip_goc.srt`. |
| `#5_blender` | Camera cố định trước mặt, 3 cỡ: trung, trung rộng, cận mặt. Có 1 lần zoom lùi chậm (~2s). |
| `#6_render` | Ô bình luận là lớp đồ họa 2D, không phải vật trong cảnh. Cắt cứng ở cuối, không end card trong gốc. |

### 9.3 Câu hỏi cho `#1_kich_ban` (người dùng quyết, chưa trả lời ở đây)
1. **Độ dài:** nội dung gốc 35,7s, dài hơn khung 15–30s. Giữ nguyên 35,7s hay đưa về ≤30s?
2. **Giọng:** dùng lại tiếng gốc như cách tập Rau_cau đã làm, hay làm giọng mới? Tiếng gốc là giọng của một nhà sáng tạo thật, @thanhdaudau69, có ~527 nghìn follower.
3. **Mức ngôn ngữ:** giữ "ói", "ỉa/ẻ", "mấy cái thằng" như gốc?
4. **Hình:** clip gốc chỉ có nói, không cho thấy cảnh ói. Giữ đúng kiểu ngồi nói này?
5. **Nhân vật:** ai trong Halo_Cub đóng vai người đáp, và người hỏi có hiện hình không (gốc: ngoài khung)?
6. **Ô bình luận:** giữ lớp ô "trả lời bình luận" như gốc không? Gốc có tên và ảnh của một người xem thật.

---

## 10. Chưa xác minh / không tìm được

| Mục | Kết quả |
|---|---|
| Trend hay sound tên "Uống ơi e" / "uống ơi em" | **Không tìm được.** Không có caption hay hashtag nào ghi "uống ói ẻ". Cách hiểu "Uống – ói – ẻ" là suy luận. |
| @ngaovadongbon = @ngaokaday đổi tên | Có cơ sở mạnh (mục 2), chưa khẳng định. Không vào được Wayback Machine để đối chiếu. |
| Ý nghĩa `aigc_label_type: 2` trong thẻ MP4 | **Không có tài liệu chính thức.** Một nguồn không chính thức về trường JSON trên web cho rằng 2 = "người đăng tự khai là AI". Cách hiểu đó không khớp với dữ liệu trang, vốn là TikTok tự gắn (`moderationAigcLabelType=1`). Chưa kết luận. |
| Kênh YouTube hoặc Facebook của "Ngáo Và Đồng Bọn", bài báo về kênh | Không tìm được. |
| Lời đoạn kết của bản người thật (sau 35,9s) | Chỉ có qua phụ đề tự động TikTok, subagent đọc. Tôi chưa nghe; đoạn này không thuộc clip người dùng gửi. |
| Số liệu kênh và số video dùng âm thanh (mục 3) | Subagent đọc, tôi chưa tự kiểm lại. Số của hai video chính thì tôi đã tự kiểm. |

---

## 11. File kèm theo (`00_nghien_cuu/`)

- [thoai_clip_goc.srt](thoai_clip_goc.srt): lời thoại có mốc thời gian.
- `khung_hinh/`, mỗi shot một khung đại diện ở độ phân giải gốc 576×1024:
  - [S01](khung_hinh/S01_t01.00s.jpg), [S02](khung_hinh/S02_t09.60s.jpg), [S03a](khung_hinh/S03a_t10.50s.jpg), [S03b, giơ hai chân](khung_hinh/S03b_t12.25s.jpg)
  - [S04, cận](khung_hinh/S04_t15.00s.jpg), [S05, cận](khung_hinh/S05_t16.70s.jpg), [S06, giơ một chân](khung_hinh/S06_t17.80s.jpg), [S07](khung_hinh/S07_t18.70s.jpg), [S08](khung_hinh/S08_t20.00s.jpg)
  - [S09a, cận](khung_hinh/S09a_t22.00s.jpg), [S09b, zoom lùi](khung_hinh/S09b_t26.00s.jpg), [S10](khung_hinh/S10_t28.00s.jpg), [S11, giơ chân](khung_hinh/S11_t29.70s.jpg), [S12, câu chốt](khung_hinh/S12_t33.70s.jpg), [OUTRO](khung_hinh/OUTRO_t37.00s.jpg)
- Bảng khung toàn clip 2 hình/giây: [0–10s](khung_hinh/toan_bo_2fps_00-10s.jpg), [10–20s](khung_hinh/toan_bo_2fps_10-20s.jpg), [20–30s](khung_hinh/toan_bo_2fps_20-30s.jpg), [30–40s](khung_hinh/toan_bo_2fps_30-40s.jpg).
- [diem_cat_canh.jpg](khung_hinh/diem_cat_canh.jpg): khung trước và sau mỗi điểm cắt.
- [binh_luan_overlay.png](khung_hinh/binh_luan_overlay.png): ảnh cắt ô bình luận.
- [pho_am_thanh.png](khung_hinh/pho_am_thanh.png): phổ âm cả clip.

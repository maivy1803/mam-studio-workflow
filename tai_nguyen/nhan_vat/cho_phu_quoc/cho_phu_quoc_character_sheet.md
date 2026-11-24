# Character sheet — Chó Phú Quốc (ĐÃ CHỐT PQ v1, chưa có tên)

> **Ghi chú bộ cài (Mam_Studio_Kit 1.2.0):**
> Ảnh có trong bộ cài, cùng thư mục với file này:
> - `cho_pq_character_sheet_v1_raw.jpg`: sheet chốt, không nhãn, dùng gắn Flow.
> - `cho_pq_character_sheet_v1_CHOT.jpg`: bản có nhãn 4 góc.
> Ảnh style `style_bo_vit_4_goc.jpg` ở `../_style_chung/`. Không có trong bộ cài: bản `.webp` gốc và 2 ảnh chó thật `cho_pq_ref_01/02`; chúng vẫn ở thư mục dự án.

## CHỐT (2026-11-22)

Người dùng: "Chốt luôn" (sau khi xem PQ v1, không sửa đuôi). Giữ nguyên PQ v1, kể cả đuôi buông thấp và xoáy bắt đầu giữa lưng.

- `cho_pq_character_sheet_v1_CHOT.webp`: bản gốc tải từ Flow, 1376×768, 165.070 byte, sha256 `0b8b3ac7b6c988ea00bc458d3022f8c2e61c49a88151eea6d1237024944a7520`.
- `cho_pq_character_sheet_v1_raw.jpg`: cùng ảnh, JPEG q95, 1376×768, không nhãn.
- `cho_pq_character_sheet_v1_CHOT.jpg`: bản có nhãn (tiêu đề, 4 nhãn FRONT · Chính diện / 3/4 / SIDE · Nghiêng / BACK · Sau lưng, chân trang), 1376×936.
- Trên Flow: project `a9396094-f723-4393-a40e-b9786d9273b1`, ảnh "Phu Quoc dog" tạo 2026-11-22.

> Ngày 2026-11-22. Phiên lớn **Team-suc-vat**, phiên con **#2_character_sheet**, sub-session **#2.5_Cho**.
> Yêu cầu người dùng: "Tạo nhân vật chó có diện mạo hoàn toàn mới dựa trên thông tin chó phú quốc Việt Nam, style đồng bộ với ảnh con vịt và con bò (ảnh 3)". Sau đó: "Gen 1 sheet thôi".
> Thay cho thiết kế chó cũ (v1–v9, theo ảnh chó con vàng), giữ làm lịch sử ở `cho_character_sheet.md`.

## Tham chiếu (thứ tự gắn trên Flow)

1. `../tham_chieu/cho_pq_ref_02_dung.webp` (600×675): chó Phú Quốc thật đứng, nhìn ngang. Lông đỏ gừng ngắn, tai dựng to, đuôi dựng cong lưỡi liềm, mũi nâu gan, mắt hổ phách. Có xích cổ, logo, chữ chìm: bỏ qua.
2. `../tham_chieu/cho_pq_ref_01_nam_xoay_lung.png` (495×397): chó Phú Quốc thật nằm, lông vàng cát, ngực và chân kem, mũi đen, mắt nâu sẫm. Thấy rõ **xoáy lưng**: dải hẹp từ sau vai gần tới hông, đọc bằng một mép tối nâu đỏ.
3. `../tham_chieu/style_bo_vit_4_goc.jpg` (1376×768): sheet Bò (hàng trên) và Vịt (hàng dưới), mỗi con 4 góc, có kẻ ngang mờ. Chỉ lấy **style**.

## Nghiên cứu giống chó Phú Quốc (workflow 6 agent, 2026-11-22)

Đặc điểm đã kiểm chứng, nhìn thấy được trên turnaround miệng ngậm (nguồn chính: tiêu chuẩn VKA 2023 `https://vka.vn/wp-content/uploads/2023/10/BANG-TIEU-CHUAN-CPQ-04.10.2023.pdf`, Tuổi Trẻ 2018, Wikipedia tiếng Việt, IJAT 2019):

- **Xoáy lưng**: dải lông mọc ngược dọc sống lưng, nổi rõ khi nhìn ngang, dài hơn nửa lưng, không rộng hơn lưng, đối xứng; thường từ vai tới hông, kết thúc trước gốc đuôi. Không phải mảng màu. Tên dáng xoáy (kiếm, mũi tên, bàn…) chỉ do người nuôi đặt, không có trong tiêu chuẩn.
- **Tai**: dựng, hướng ra trước, hình vỏ ốc, chân tai rộng bằng hoặc hơn chiều cao.
- **Đuôi**: thon, đặt thấp, khi dựng cong như cánh cung/lưỡi liềm, chóp không chạm lưng.
- **Lông**: ngắn, cứng (1–2 cm), xoáy và đuôi dài hơn. Bản nhân vật cho lông xù theo series (chọn style, không phải đặc điểm giống).
- **Màu** được công nhận: vàng, đỏ, đen, vện… Bản này chọn một màu vàng gừng trầm, nằm giữa 2 ảnh.
- **Mũi, mắt**: VKA ưu tiên mũi đen, mắt sẫm, nên bỏ mũi nâu và mắt hổ phách của ảnh 1.
- Lưỡi đốm, chân có màng: có trong tài liệu nhưng không thấy khi miệng ngậm, nên không vẽ.

Kết quả đầy đủ (các đặc điểm, nguồn, 3 bản prompt nháp, điểm chấm): `C:\Users\PC\AppData\Local\Temp\claude\8a10b585e86a0b3c\04384ab2-1cf5-4d31-a67e-c405c545904c\tasks\wmtlfj6a6.output` (scratchpad, có thể bị xóa).

## Phương án tự chọn (người dùng sửa sau khi xem ảnh)

| Câu hỏi | Đang dùng |
|---|---|
| Dáng | Đứng thẳng 2 chân như Bò |
| Tỷ lệ | Thú bông mập lùn như Bò, khoảng 2,7 đầu, không cổ (bài học Mèo) |
| Màu | Một màu vàng gừng trầm, ngực và hai bên mõm kem; mũi đen, mắt nâu sẫm |
| Xoáy lưng | Dải hẹp đối xứng từ giữa hai bả vai tới trên gốc đuôi, nếp lông mọc ngược mềm, cùng màu lông, chỉ mép tối nâu đỏ |
| Kẻ ngang mờ của ảnh 3 | Không vẽ |
| Bố cục | 1 hàng 4 góc: chính diện, 3/4, nghiêng phải, sau lưng |
| Tên | _chưa có_ |

## Thiết lập

Google Flow làm tay trong trình duyệt của app, project `a9396094-f723-4393-a40e-b9786d9273b1`. Nano Banana 2.1, 16:9, **x1** (người dùng: "Gen 1 sheet thôi"), Thinking High, 0 credit. 3 ảnh tự tải lên qua server 127.0.0.1 + DragEvent, sha256 khớp (`cho_pq_ref_02_dung.webp` 112.582 byte, `cho_pq_ref_01_nam_xoay_lung.jpg` 60.201 byte, `style_bo_vit_4_goc.jpg` 149.927 byte).

## Prompt PQ v1

Workflow: 2 agent nghiên cứu (giống chó, đọc ảnh) → 3 agent viết nháp (nhận diện trước / style trước / dáng trước) → 1 agent chấm và ghép. Điểm: A 34, B 33, **C 35** (dáng trước); bản chốt lấy C, ghép sửa từ A (không cơ bắp, không eo thon; bỏ mũi nâu, mắt hổ phách của ảnh 1; lông dài hơn ở xoáy và đuôi).

```
A 16:9 turnaround of a new Vietnamese Phu Quoc dog character from the same 3D animated film as the cow and duckling in the third reference image. A chunky plush-toy dog standing upright like the cow, about 2.7 heads tall, no visible neck, the head on a soft pear-shaped body wider than the head, round lower belly, straight back, short thick arms at the sides, round mitten paws without toes, short thick legs about one fifth of the height; no muscle definition, no tucked waist. A rounded head, slightly flat on top, full cheeks, a broad-based tapering muzzle with a straight bridge and rounded tip as the center of the face. Two large erect ears set high, as wide at the base as they are tall, cupped and facing forward, tips softly rounded, dusty pink inside. A slim low-set tapering tail rising behind the body in an open sickle curve, tip clear of the back. Medium almond-shaped dark-brown eyes with dark rims and soft heavy upper eyelids over the top third of the iris, a small catchlight, a calm, alert, low-key look; a large rounded soft charcoal-black nose; a tight dark lip line, mouth closed, no long whiskers. The back ridge, as in the second reference image: a narrow symmetrical strip down the spine from between the shoulder blades to just above the tail base, rounded at the top, tapering to a point, a soft natural fold of reversed fur, gently raised, same coat colour with darker reddish-brown shading only along its edge, not a painted stripe; clear in the back view, a small raised break in the side-view topline. Fur: dense, deep, fluffy, slightly tousled and matte with a soft halo of fine hairs, a little longer on the ridge and tail; one warm muted dusty golden-ginger fawn, never bright orange, with warm cream-tan on the muzzle sides, throat and chest, a step darker than the background; no white patches, nothing saturated. From the third image take only the style: proportions, render, colour grade, seamless warm off-white background, one soft key light from the right, long soft floor shadows to the left, contact shadows. Ignore the photo backgrounds, chain collar, leash, logos, watermarks, lying pose, open mouth, the first photo's brown nose and amber eyes, and the cow and duckling themselves: no horns, udder, spots, hooves, bell, beak, bowl-cut hair, webbed duck feet, grid lines. Layout: one row of four full-body views of the same dog, same size, feet on one ground line, left to right: front, three-quarter, side view facing right, back view, nothing cut off. No text, no labels, no numbers, no borders, no other characters, no collar, no clothes.
```

## Kết quả PQ v1 (1 ảnh 1376×768, ô đầu lưới media, chưa tải về)

**Khớp style Bò + Vịt:** lông xù dày mờ có viền lông tơ; thân thú bông mập lùn, không cổ, tay chân ngắn, bàn tròn như Bò; mí mắt trên nặng, mặt điềm tĩnh, miệng ngậm; màu trầm; nền trắng ngà, đèn mềm bên phải, bóng dài sang trái; 4 góc cùng cỡ, cùng đường đất.

**Nét Phú Quốc:** tai dựng to, chân tai rộng, lòng tai hồng; một màu vàng gừng, ngực, bụng và hai bên mõm kem; mũi đen to, mõm hơi sẫm; xoáy lưng là dải hẹp viền nâu đỏ mềm, rõ ở góc sau lưng, có gờ nhỏ trên lưng ở góc nghiêng.

**Lệch:**
- Đuôi buông thấp (góc sau lưng chĩa xuống, góc nghiêng và 3/4 chĩa ra sau, xuống), không dựng cong lưỡi liềm như ảnh 1 và tiêu chuẩn giống.
- Xoáy hơi ngắn: bắt đầu giữa lưng thay vì từ bả vai.
- Dấu ✦ góc dưới phải.

## Còn lại

- Tên nhân vật.
- Người dùng đã chốt không sửa đuôi. Nếu sau này muốn đuôi dựng lưỡi liềm đúng giống thì sửa ảnh trên PQ v1 (0 credit).

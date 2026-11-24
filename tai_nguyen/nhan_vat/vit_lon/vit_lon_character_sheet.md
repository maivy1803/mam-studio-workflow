# Character sheet — Vịt Lộn

> **Ghi chú bộ cài (Mam_Studio_Kit 1.2.0):**
> Ảnh có trong bộ cài, cùng thư mục với file này:
> - `vit_lon_character_sheet_v1a_raw.jpg`: sheet chốt, không nhãn. `vit_lon_character_sheet_v1a.jpg`: bản có nhãn.
> - `tham_chieu/Duck_character_turnaround_sheet_3af3b1fe.jpg`: sheet concept 4 góc, khóa 2026-11-16. Đây là file `vitlon_4goc.jpg` nhắc bên dưới.
> - `tham_chieu/Duck_character_turnaround_sheet_ebd7d6f6.jpg`: sheet concept 6 biểu cảm, khóa 2026-11-16. Tên có chữ turnaround nhưng là sheet biểu cảm. Đây là file `vitlon_bieucam.jpg` nhắc bên dưới.
> - **Muốn Flow giữ đúng mắt hạt cườm thì phải gắn sheet biểu cảm này làm ingredient** (Rau_cau PROJECT_INDEX, kết quả test Shot A v3).

> Session `#2_nhan_vat > 2.2_Vit_lon`. Ngày 2026-11-17.
> **[LOCKED] 2026-11-17: bản v1a** (`vit_lon_character_sheet_v1a.jpg`, gốc `..._v1a_raw.jpg`), người dùng duyệt. Bản v1b chỉ để đối chiếu.
> Yêu cầu người dùng: character sheet gồm chính diện (front), sau lưng (behind) và chân dung.

## Thiết lập

- Google Flow `gen_i2i` (Nano Banana), 16:9, 2 phương án, 0 credit (trừ hạn mức ảnh hằng ngày).
- Project `ce0c8123-418c-46c3-ad2f-5ecb51e601c1`, job `rau_cau_charsheet_vitlon_v1_r2`. Lần đầu (`..._v1`) lỗi WireFormatError, không tạo ảnh.
- Ảnh tham chiếu: hai sheet concept đã khóa, dùng bản chép tên ngắn `vitlon_4goc.jpg` (sheet 4 góc) và `vitlon_bieucam.jpg` (sheet biểu cảm).

## Prompt (một dòng)

```
Character model sheet of the exact same duckling as the reference images (the first is his four-view turnaround, the second is his expression sheet), stylized 3D feature-animation render, identical design in every view: small round fluffy duckling, soft pale cream-yellow down, a thick glossy navy-black bowl-cut hairdo shaped like a helmet with straight blunt bangs just above his eyes, two tiny solid black bead eyes each with one small highlight, no eye whites, no colored iris, no human eyelids, no blush, a small flat orange-yellow bill, short stubby wings, a small fluffy tail tuft, thin orange legs and webbed feet. Keep every design detail, proportion and color exactly as in the first reference. LAYOUT: three panels side by side on one seamless pure white background, evenly spaced: (1) left: full body, front view, standing straight, wings relaxed at his sides, neutral face, looking at the camera; (2) middle: full body, back view, same size and pose, showing the back of his hairdo, his back and his tail tuft; (3) right: portrait, head and shoulders close-up, front view, neutral face, looking at the camera. The two full-body views are the same size with their feet on the same ground line and soft contact shadows. Soft even studio lighting. No text, no labels, no numbers, no borders, no other characters.
```

## Kết quả

| File | Media | Ghi chú |
|---|---|---|
| `vit_lon_character_sheet_v1a.jpg` (gốc `..._v1a_raw.jpg`) | `5283a9ab-…` | **Đã khóa.** Nền trắng tinh |
| `vit_lon_character_sheet_v1b.jpg` (gốc `..._v1b_raw.jpg`) | `586dcc2f-…` | Nền trắng ngà, có 2 dấu ngôi sao Gemini (giữa hai chân ô sau lưng và góc phải dưới) |

Soát:
- Đúng khóa: mắt hạt cườm, không lòng trắng, không má hồng. Tóc cắt bát xanh đen, mái bằng, mỏ cam, chân màng cam.
- Ô sau lưng có tóc phủ kín gáy và chỏm đuôi, giống ô sau lưng trong sheet 4 góc.
- Ô chân dung ở cả hai bản có mép dưới cắt thẳng, nhìn như một khung ảnh dán vào.

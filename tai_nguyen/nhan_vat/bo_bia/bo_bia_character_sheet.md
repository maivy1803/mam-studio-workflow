# Character sheet — Bò Bía

> **Ghi chú bộ cài (Mam_Studio_Kit 1.2.0):**
> Ảnh có trong bộ cài, cùng thư mục với file này:
> - `bo_bia_character_sheet_v1a_raw.jpg`: sheet chốt, không nhãn. Bản này dùng để gắn lên Flow.
> - `bo_bia_character_sheet_v1a.jpg`: sheet chốt, có nhãn.
> - `tham_chieu/bo_bia_turnaround_ref_01.jpg`: sheet 4 góc người dùng gửi (chính diện, 3/4, nghiêng, sau lưng), là nguồn của bản v1a. Ảnh này chưa khóa (câu 11), nhưng là ảnh duy nhất có góc 3/4 và nghiêng của Bò.
> - `bieu_cam/bo_bia_B05_S09_im_lang.png`: biểu cảm "im lặng", mắt mở to đứng hình. Khóa 2026-11-17, người dùng chọn ảnh (Rau_cau PROJECT_INDEX).
> Các đường dẫn `../tham_chieu/…` bên dưới là của thư mục dự án gốc.

> Session `#2_nhan_vat > 2.1_Bo_bia`. Ngày 2026-11-17.
> **[LOCKED] 2026-11-17: bản v1a** (`bo_bia_character_sheet_v1a.jpg`, gốc `..._v1a_raw.jpg`), người dùng duyệt. Bản v1b chỉ để đối chiếu.
> Yêu cầu người dùng: character sheet gồm chính diện (front), sau lưng (behind) và chân dung.

## Thiết lập

- Google Flow `gen_i2i` (Nano Banana), 16:9, 2 phương án, 0 credit (trừ hạn mức ảnh hằng ngày).
- Project `ce0c8123-418c-46c3-ad2f-5ecb51e601c1`, job `rau_cau_charsheet_bobia_v1`.
- Ảnh tham chiếu: `../tham_chieu/bo_bia_turnaround_ref_01.jpg` (ảnh chuẩn chưa khóa, câu 11).

## Prompt (một dòng)

```
Character model sheet of the exact same cow character as the reference image, stylized 3D feature-animation render, identical design in every view: chubby, pear-shaped Holstein cow standing upright on his two hind legs like a person; dense fluffy cream-white plush fur with irregular black patches; black head with a white blaze down the face; big floppy black ears with pink insides; short curved cream horns with a small black tuft of hair between them; heavy, half-closed droopy eyelids over pale eyes; wide mauve-pink muzzle; worn brown leather collar with a small brass cowbell; short arms ending in dark gray hooves; thin tail ending in a black tuft. Keep every design detail, proportion and color exactly as in the reference. LAYOUT: three panels side by side on one seamless pure white background, evenly spaced: (1) left: full body, front view, standing straight, arms relaxed at his sides, neutral face, looking at the camera; (2) middle: full body, back view, same size and pose, showing the patches on his back, his tail and the back of the collar; (3) right: portrait, head and shoulders close-up, front view, neutral face, looking at the camera. The two full-body views are the same size with their feet on the same ground line and soft contact shadows. Soft even studio lighting. No text, no labels, no numbers, no borders, no other characters.
```

## Kết quả

| File | Media | Ghi chú |
|---|---|---|
| `bo_bia_character_sheet_v1a.jpg` (gốc `..._v1a_raw.jpg`) | `fc2dbb68-…` | **Đã khóa.** Ba ô cách đều, ô chân dung đủ lề |
| `bo_bia_character_sheet_v1b.jpg` (gốc `..._v1b_raw.jpg`) | `4de1023d-…` | Ô chân dung bị cắt sát mép trái |

Soát:
- Thiết kế giữ đúng ảnh tham chiếu: sừng, chỏm lông, mắt lờ đờ, mõm hồng tím, vòng cổ có chuông, đốm đen. Đứng thẳng hai chân.
- Nền trắng ngà giống ảnh tham chiếu, không trắng tinh.
- Bầu vú giữ như ảnh tham chiếu. Chưa quyết, chờ câu 10.
- Góc phải dưới có dấu ngôi sao nhỏ của Gemini, giống ảnh tham chiếu.

Bản có nhãn do script `board/label_sheet.ps1` trong scratchpad ghép (System.Drawing).

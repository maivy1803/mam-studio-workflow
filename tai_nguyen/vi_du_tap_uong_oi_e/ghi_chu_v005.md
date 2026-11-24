# Bản nháp v005: v004, sửa khớp miệng ở 14–17s

> Ngày 2026-11-23. Phiên `#2 Uong oi e`.
> Người dùng báo lệch tiếng với hình từ giây 14 đến 17. Yêu cầu chỉ sửa đoạn đó rồi ghép lại vào clip, không render lại toàn bộ.

## Kết quả
- [uong_oi_e_bo_bia_nhap_v5.mp4](uong_oi_e_bo_bia_nhap_v5.mp4)
  - Khung dọc 9:16, 720×1280, 24 fps, 858 khung, dài 35,73s.
  - Âm thanh là nguyên tiếng gốc, chép thẳng từ v4.
- [kiem_mieng_14-17s_v5.jpg](kiem_mieng_14-17s_v5.jpg): miệng Bò Bía, 8 khung mỗi giây, 14,29–17,29s.
- [kiem_cho_noi_v5.jpg](kiem_cho_noi_v5.jpg): khung 339–346 và 415–422, hai chỗ nối cảnh cận mặt.

## Lỗi
- Đoạn cận mặt 14,27–17,43s (khung 343–418) lấy từ đoạn video thứ 2, mà ở đó **miệng đi trước tiếng khoảng 0,4s**.
- Đo bằng độ lớn dải giọng nói, mỗi 0,01s:

  | | Nói | Im | Nói | Im | Nói |
  |---|---|---|---|---|---|
  | Tiếng gốc | — | 13,7–14,7 | 14,75–15,55 ("xuống tới quần luôn") | 15,6–16,45 | 16,5–17,9 ("Em ói tiếp ở cái bồn cầu") |
  | Miệng ở v4 | — | 13,95–14,25 | 14,3–15,2 | 15,25–16,05 | 16,1–17,55 |

## Cách sửa (không dùng AI, không tốn credit)
- **Chỉ dựng lại 76 khung cận mặt** (khung 343–418). Mỗi khung lấy hình **trễ 11 khung (0,458s)** so với v4: cùng phông xanh, nền, tỉ lệ và khung cận ×3,2.
- **Độ trễ** chọn bằng cách dò từ −6 đến +20 khung. Mức 11 khung cho miệng và tiếng trùng nhau 76% thời gian, so với 51% ở v4.
- **Hai đầu đoạn** là điểm cắt cảnh (trung → cận ở 14,27s, cận → trung ở 17,43s), nên chỗ nhảy hình bị cảnh cắt che.
- **Phần còn lại** (khung 0–342 và 419–857) lấy thẳng từ v4, chỉ nén lại một lần ở chất lượng cao (CRF 14, PSNR so với v4 khoảng 50dB).

## Ghi chú phụ
- Câu "Em ói tiếp ở cái bồn cầu" trong tiếng gốc thật ra bắt đầu ở **16,5s**, không phải 15,80s như file phụ đề ban đầu ghi. Đã sửa lại trong `00_nghien_cuu/thoai_clip_goc.srt`.

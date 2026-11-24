# Bản nháp v004: v003, mắt mở to từ giây 3

> Ngày 2026-11-23. Phiên `#2 Uong oi e`.
> Người dùng **chốt v003** và chỉ đổi một chỗ: từ giây 3 đến giây 35, mắt Bò Bía mở to, mí không sụp. Mọi thứ khác giữ nguyên.

## Kết quả
- [uong_oi_e_bo_bia_nhap_v4.mp4](uong_oi_e_bo_bia_nhap_v4.mp4)
  - Khung dọc 9:16, 720×1280, 24 fps, dài 35,73s.
  - Âm thanh là nguyên tiếng gốc.
- [kiem_khung_v3_vs_v4.jpg](kiem_khung_v3_vs_v4.jpg): v3 (hàng trên) và v4 (hàng dưới) ở cùng 12 mốc thời gian.

## Cách làm
1. **Sửa mắt bằng Flow Omni 1.2 Flash** trên 3 đoạn phông xanh của v003. Lệnh: chỉ nâng mí trên cho mắt mở to, thấy trọn tròng; giữ nguyên nền phông xanh, Bò Bía, cử động, miệng, chớp mắt và thời điểm.
   - Kết quả: `flow_goc/E1…E3_mat_mo_*.mp4`.
   - Credit Flow: 30 + 42 + khoảng 60.
2. **Nối đoạn 1 tại giây 3** (khung 72 ở 24 fps): 0–3s lấy đoạn phông xanh cũ, mắt lờ đờ như v003; từ 3s lấy bản mắt mở. File nối: `flow_goc/G1_noi_3s.mp4`.
3. **Ghép** bằng y lệnh của v003, [ghep_v3_phong_xanh.sh](../ban_nhap_bo_bia_v003/ghep/ghep_v3_phong_xanh.sh). Giữ nguyên nền, tỉ lệ khoảng 1,5m, bóng chân, nhịp cận mặt, ô bình luận và tiếng gốc.

## Đã kiểm
- 0–2,9s trùng v003.
- Từ 3,0s mắt mở to tròn. Dáng, cử động, miệng, nền và khung hình trùng v003 ở 12 mốc so sánh.
- Còn vài lần chớp mắt nhanh (khoảng 0,1–0,2s), ví dụ khoảng 32,1s; giữ lại vì lệnh có giữ chớp mắt.
- Ở giây 3, mắt đổi từ lờ đờ sang mở to ngay lập tức, không chuyển dần, đúng mốc người dùng yêu cầu.

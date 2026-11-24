# Bản nháp v003: diễn xuất v1, nền quán nhậu vỉa hè, Bò Bía đúng tỉ lệ thật

> Ngày 2026-11-23. Phiên `#2 Uong oi e`.
> Người dùng **chốt v001** (`uong_oi_e_bo_bia_nhap_v1.mp4`): giữ nguyên Bò Bía và diễn xuất, chỉ thay nền, chỉnh cỡ Bò Bía cho tự nhiên với môi trường thật. Bản v003 làm đúng yêu cầu đó.

## Kết quả
- [uong_oi_e_bo_bia_nhap_v3.mp4](uong_oi_e_bo_bia_nhap_v3.mp4)
  - Khung dọc 9:16, 720×1280, 24 fps, dài 35,73s.
  - Âm thanh là nguyên tiếng gốc.
- [kiem_khung_nhap_v3.jpg](kiem_khung_nhap_v3.jpg): 12 khung để kiểm nhanh.

## Cách làm
1. **Tách Bò Bía khỏi nền phòng xanh của v1.**
   - Dùng chức năng sửa video của Flow (Omni 1.2 Flash) trên chính 3 đoạn v1 do Flow tạo (T1, T2, T3).
   - Lệnh: thay toàn bộ nền bằng phông xanh chroma, giữ nguyên Bò Bía, cử động, miệng và thời điểm.
   - Kết quả nằm trong `flow_goc/G1…G3_phong_xanh_*.mp4`. Omni tự lùi khung nên thấy trọn người tới chân.
   - Credit Flow: 30 (10s), 42 (12s) và khoảng 60 (15s).
2. **Nền** [flow_goc/nen_quan_nhau_trong_v1.jpg](flow_goc/nen_quan_nhau_trong_v1.jpg):
   - Tạo bằng Nano Banana 2.1, 0 credit, tham chiếu là cảnh của bản v002.
   - Quán nhậu vỉa hè trống, ánh chiều dịu cho khớp ánh sáng trên người Bò Bía ở v1.
   - Máy đặt ngang ngực khoảng 1,2m, ống kính 28mm, giữa khung chừa khoảng vỉa hè trống.
3. **Ghép** bằng [ghep/ghep_v3_phong_xanh.sh](ghep/ghep_v3_phong_xanh.sh):
   - Tách phông xanh (`chromakey` + `despill`) và ám màu Bò Bía hơi ấm cho hợp cảnh.
   - **Tỉ lệ:** thước đo là ghế đẩu nhựa (khoảng 30cm) và bàn nhựa thấp (khoảng 50cm) trong cảnh. Bò Bía đặt cao **khoảng 1,5m**, đứng trước nhóm bàn ghế, nên ghế tới gối, bàn tới hông.
   - Bóng mờ dưới chân: [ghep/bong_chan.png](ghep/bong_chan.png).
   - Phóng to theo nhịp gốc, tính trên khung 1440×2560:
     - trung cảnh thấy trọn người ×1,227;
     - cận mặt ×3,2 ở 14,267–17,433s và 21,1–24,5s, rồi lùi dần về trung cảnh đến 26,5s;
     - ×1,374 ở 19,267–21,1s.
   - Ô bình luận 0–9,5s và tiếng gốc 0–35,733s như v001.

## Điểm cần người dùng xem
- **Cử chỉ thêm:** ở đoạn phông xanh 2, khoảng 15,5s trong bài, Bò Bía giơ tay thêm một lần mà v1 không có. Lúc đó đang cận mặt nên gần như không thấy. Phần còn lại khớp v1.
- **Khẩu hình:** khớp gần đúng như v1, vì miệng lấy từ đoạn phông xanh do Omni dựng lại theo v1.
- **Nền đứng yên:** nền là ảnh tĩnh, hợp với máy quay cố định, nhưng không có chuyển động như xe chạy hay người qua lại.
- **Dấu ✦ của Google:** ở góc phải dưới, nằm trên ảnh nền.
- **Ô bình luận:** vẫn còn tên và ảnh đại diện của người bình luận thật.

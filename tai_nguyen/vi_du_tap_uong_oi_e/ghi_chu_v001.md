# Bản nháp v001: Bò Bía thay husky, giữ tiếng gốc

> Ngày 2026-11-23. Phiên `#2 Uong oi e`. Đây là bản nháp, chưa khóa.

## Kết quả
- [uong_oi_e_bo_bia_nhap_v1.mp4](uong_oi_e_bo_bia_nhap_v1.mp4)
  - Khung dọc 9:16, 720×1280, 24 fps, dài 35,73s.
  - Âm thanh là **nguyên tiếng gốc**: cắt từ clip gốc 0–35,733s, AAC 192k.
- [kiem_khung_nhap_v1.jpg](kiem_khung_nhap_v1.jpg): 12 khung để kiểm nhanh.

## Cách làm
1. **Không sửa được video gốc trên Flow.** Flow (Omni 1.2 Flash) từ chối sửa video tải lên có tiếng nói ("Our policies prevent editing or generating speech for people in uploaded videos"), đã hoàn 12 credit. Vì vậy bản này được **dựng mới** chứ không thay nhân vật trên video gốc.
2. **Khung đầu** [flow_goc/khung_dau_bo_bia_v1.jpg](flow_goc/khung_dau_bo_bia_v1.jpg):
   - Tạo bằng Nano Banana 2.1, 0 credit, 9:16.
   - Tham chiếu gồm khung phòng gốc lúc 9,65s (shot S02, không có ô bình luận) và hai ô cắt từ sheet Bò Bía v1a (chính diện, chân dung).
   - Lệnh: bỏ con chó, đặt Bò Bía đứng hai chân đúng chỗ đó, giữ nguyên phòng, góc máy và ánh sáng.
3. **Ba đoạn video**, dựng bằng Omni 1.2 Flash ở chế độ khung đầu, 720p, x1, đều bắt đầu từ cùng khung đầu:

   | Đoạn | Mốc gốc | Dài gen | Credit | File |
   |---|---|---|---|---|
   | T1 | 0–9,5s | 10s | 30 | `flow_goc/T1_0-9.5_v1.mp4` |
   | T2 | 9,5–21,1s | 12s | 42 | `flow_goc/T2_9.5-21.1_v1.mp4` |
   | T3 | 21,1–35,73s | 15s | 60 | `flow_goc/T3_21.1-35.73_v1.mp4` |

   - Tổng **132 credit Flow**.
   - Lệnh ghi mốc từng câu nói, từng lần ngậm miệng và từng cử chỉ theo [bao_cao_clip_goc.md](../../00_nghien_cuu/bao_cao_clip_goc.md): hai tay khua từ cổ xuống bụng ở 11,0–13,7s, giơ một tay ở 17,5s và 29,5s, cười há miệng ở câu chốt.
   - Kiểm bằng `silencedetect` trên tiếng của chính Flow: các lần mở miệng nói lệch mốc gốc khoảng ±0,3s.
4. **Ghép** bằng [ghep/ghep_ban_nhap.sh](ghep/ghep_ban_nhap.sh):
   - Cắt T1 0–9,5s, T2 0–11,6s, T3 0–14,633s rồi nối lại.
   - Phóng to số theo nhịp gốc:
     - cận mặt ×1,8 ở 14,267–17,433s (S04–S05);
     - ×1,12 ở 19,267–21,1s (S08);
     - cận mặt ×1,8 ở 21,1–24,5s, rồi lùi dần về ×1 đến 26,5s (S09).
   - Ô "trả lời bình luận" cắt từ khung gốc lúc 5,0s, bo góc, đặt ở 0–9,5s.
   - Bỏ tiếng Flow tự tạo, thay bằng tiếng gốc.
   - Lệnh ghép: `bash ghep_ban_nhap.sh T1.mp4 T2.mp4 T3.mp4 tieng_goc.wav o_binh_luan_720.png out.mp4`. Tiếng gốc cắt bằng `ffmpeg -i <clip gốc> -t 35.733 -vn -c:a pcm_s16le tieng_goc.wav`.

Project Flow: "Nov 23 - 12:07" (`f1076bae-668b-4c4f-b302-329e29702f5b`), tài khoản trong trình duyệt của app.

## Điểm cần người dùng xem
- **Khẩu hình:** chỉ khớp gần đúng, vì hình dựng mới theo mốc chứ không bám từng nhịp miệng.
- **Bầu vú:** sheet v1a có bầu vú hồng, khung đầu và video không có.
- **Ô bình luận:** giữ như gốc, nên còn tên và ảnh đại diện của người bình luận thật.
- **Dấu ✦ của Google** ở góc phải dưới: dấu mặc định trên ảnh và video Flow tạo ra.
- **Đổi khung ở 9,5s:** giữa T1 và T2, Bò Bía to hơn một chút do đứng gần máy hơn. Chỗ này trùng điểm jump cut của gốc.
- **Định dạng:** giữ khung dọc 9:16 như clip gốc; dự án Halo_Cub dùng 16:9.

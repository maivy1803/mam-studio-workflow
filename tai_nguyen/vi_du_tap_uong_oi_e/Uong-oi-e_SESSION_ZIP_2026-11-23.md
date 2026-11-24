# SESSION ZIP: Mam_Studio / Halo_Cub / Tập 2 `Uong-oi-e`

> Bản nén toàn bộ phiên **"#2 Uong oi e"** (phiên con của phiên lớn "Series-phim") cùng các phiên con và agent con của nó. Chốt lúc 2026-11-23 khoảng 14:20.
> Dùng để nạp lại ngữ cảnh: cho phiên mới đọc file này trước, rồi đọc [quy_trinh/quy_trinh_thay_nhan_vat_clip_goc.md](quy_trinh/quy_trinh_thay_nhan_vat_clip_goc.md).
> Tập này **chưa có `PROJECT_INDEX.md`**: người dùng chưa trả lời câu hỏi lập file đó. Nguồn sự thật là các `ghi_chu.md` trong `06_render/ban_nhap_bo_bia_vNNN/`.
> Thư mục gốc: `E:\MikeVee\Freelancer\Hoat hinh AI\Mam_studio\`. Thư mục tập: `Halo_Cub\Uong-oi-e\`.
> File zip: `Halo_Cub\Uong-oi-e_SESSION_ZIP_2026-11-23.zip`.

---

## 1. Vai trò và quy tắc (đã dùng trong phiên)

- Trả lời tiếng Việt. Người dùng muốn làm nhanh, ít hỏi, ít chữ thừa.
- **Bám clip gốc:** giữ lời, nhịp và cú chốt. Không bịa gag hay chi tiết.
- **Google Flow làm tay trong trình duyệt của app.** Không dùng MCP `google-flow`/`flow-studio`, **không dùng KIE** (người dùng dặn 2026-11-23). Chỉ render **x1**.
- Giữ đúng nhân vật theo sheet đã khóa. Mọi thay đổi ngoại hình chỉ làm khi người dùng yêu cầu (vd mắt mở to).
- Không lách quy định của Google: Flow chặn sửa video tải lên có tiếng nói.
- Sau khi tạo xong thì tự xem nhanh kết quả, không chạy agent soát dài.
- Nghiên cứu clip gốc chỉ cần phần phục vụ việc thay nhân vật và giữ tiếng gốc (bộ nhớ ghi sau 14:00).

## 2. Các phiên và agent trong bản nén (`_phien_claude/`)

| Thành phần | ID / file | Nội dung |
|---|---|---|
| Phiên "#2 Uong oi e", đoạn 1 | `194de265-7af1-41ad-acc9-1a534a2fae53.jsonl` | Nghiên cứu clip, chép lời, so model KIE, thử Flow, dựng v001 |
| Agent con: nghiên cứu nguồn | `194de265…/subagents/agent-ac079309dae509236.jsonl` | Tra TikTok: @ngaokaday, @thanhdaudau69, số liệu, trend |
| Workflow con: so model KIE | `194de265…/subagents/workflows/wf_11bfa47e-627/` | 5 agent phân tích và 1 agent chấm (không tiêu credit) |
| Phiên "#2 Uong oi e", đoạn 2 | `6ee506be-187b-476c-8cab-7e123304a2b6.jsonl` | v002 nền quán nhậu, v003 phông xanh và tỉ lệ thật |
| Phiên "#2 Uong oi e", đoạn 3 | `cd6ce37f-e2ca-4fd0-ac34-990fdeaa365f.jsonl` | v004 mắt mở, v005 khớp miệng, đóng gói quy trình, file này |

- Mỗi thư mục cùng tên chứa `tool-results/` (ảnh chụp, kết quả công cụ) và `custom-title.json`.
- **Transcript chứa thông tin tài khoản** (email Google, tên tài khoản Flow): không chia sẻ công khai.
- Phiên khác cùng họ, **không** nằm trong bản nén: "Series-phim" (phiên lớn), "#1 Rau câu", "#3 Da chan".

## 3. Clip gốc và nghiên cứu (đã xong)

- **File:** `1795351416656_2277497963049064376_2592779964886567896.mp4`
  - Dọc 9:16, 576×1024, 30 fps.
  - Nội dung 0–35,733s, sau đó là outro TikTok.
  - Không bị sửa.
- **Nội dung:** husky "trả lời bình luận" "Em bị ép nhậu thì xử lý sao a 😳". Nó đáp "Ói.", kể leo thang các chỗ sẽ ói, chốt bằng "Em ỉa tại bàn đó luôn."
- **Nguồn:**
  - Bản người thật "Em ói cho anh..." của @thanhdaudau69 (24/09/2026, khoảng 991 nghìn lượt xem).
  - Bản AI husky của @ngaokaday, tên cũ @ngaovadongbon (13/10/2026, khoảng 290 nghìn lượt xem).
- **Báo cáo:** [00_nghien_cuu/bao_cao_clip_goc.md](00_nghien_cuu/bao_cao_clip_goc.md)
- **Lời có mốc:** [00_nghien_cuu/thoai_clip_goc.srt](00_nghien_cuu/thoai_clip_goc.srt). Câu 7 đã sửa mốc bắt đầu thành 16,5s.

## 4. Chuỗi phiên bản và quyết định của người dùng

| Bản | Làm gì | Người dùng |
|---|---|---|
| (thử) | Sửa trực tiếp video gốc trên Flow | Flow từ chối vì video có tiếng nói, đã hoàn 12 credit. Không lách. |
| v001 | Dựng mới Bò Bía (sheet v1a) trong phòng xanh như gốc, 3 đoạn Omni theo mốc, tiếng gốc | **Chốt diễn xuất** |
| v002 | Dựng lại với nền quán nhậu vỉa hè (Bò Bía to quá khổ) | Không chọn |
| v003 | Diễn xuất v001 → phông xanh → nền quán nhậu thật, Bò Bía cao khoảng 1,5m | **Chốt** |
| v004 | v003, mắt mở to, mí không sụp, từ 3s đến 35s | **Chốt** |
| v005 | v004, sửa khớp miệng cảnh cận mặt 14,27–17,43s (trễ 11 khung), không dùng AI | **Bản hiện hành** |
| `uong-oi-e-done/` | Bản xuất cuối người dùng tự làm (mp4 48 MB và mp3) | Của người dùng |

**Đã chốt:**
- Nhân vật: Bò Bía.
- Giữ nguyên tiếng gốc.
- Khung dọc 9:16 như gốc.
- Nền: quán nhậu vỉa hè, chiều dịu.
- Tỉ lệ: thật, đo theo ghế đẩu khoảng 30cm và bàn nhựa khoảng 50cm.
- Mắt mở to từ giây 3.
- Ô bình luận giữ như gốc ở 0–9,5s.

**Credit Flow đã dùng:** khoảng 530 (v1 132, v2 132, phông xanh khoảng 132, mắt khoảng 132), cộng 12 đã hoàn. KIE: 0.

## 5. Điểm còn để ý (chưa ai quyết)

1. Dài 35,7s, vượt khung 15–30s của series.
2. Dọc 9:16, trong khi series dùng 16:9.
3. Bò Bía thiếu bầu vú hồng so với sheet v1a, từ khung đầu v001.
4. Ô bình luận còn tên và ảnh đại diện của người bình luận thật.
5. Tiếng là giọng người thật của @thanhdaudau69, nên quyền sử dụng là quyết định của người dùng.
6. Nền là ảnh tĩnh. Có dấu ✦ của Google ở góc.
7. Khoảng 15,5s (lúc cận mặt) Bò Bía có một lần giơ tay thêm mà v1 không có.
8. Chưa lập `PROJECT_INDEX.md` theo khung 6 Session cho tập này.

## 6. Bản đồ file (thư mục `Halo_Cub/Uong-oi-e/`)

```
Uong-oi-e_SESSION_ZIP_2026-11-23.md      ← file này
1795351416656_…mp4                       ← clip gốc (không sửa)
00_nghien_cuu/
  bao_cao_clip_goc.md, thoai_clip_goc.srt
  khung_hinh/                            ← khung đại diện từng shot, bảng khung, phổ âm
06_render/
  ban_nhap_bo_bia_v001/  mp4 + flow_goc (T1–T3, khung đầu) + ghep (lệnh, ô bình luận) + ghi_chu.md
  ban_nhap_bo_bia_v002/  mp4 + flow_goc (T1–T3 v2, khung đầu quán nhậu) + ghi_chu.md
  ban_nhap_bo_bia_v003/  mp4 + flow_goc (G1–G3 phông xanh, ảnh nền trống) + ghep (lệnh, bóng chân) + ghi_chu.md
  ban_nhap_bo_bia_v004/  mp4 + flow_goc (E1–E3 mắt mở, G1 nối 3s) + ghi_chu.md
  ban_nhap_bo_bia_v005/  mp4 + ảnh kiểm miệng, chỗ nối + ghi_chu.md   ← bản hiện hành
quy_trinh/
  quy_trinh_thay_nhan_vat_clip_goc.md    ← quy trình đóng gói, dùng cho tập sau
  scripts/                               ← nghiên cứu, server, JS Flow, ghép, dò trễ, sửa khớp miệng
uong-oi-e-done/                          ← bản xuất cuối của người dùng
```

Trong zip còn có:
- `_phien_claude/`: transcript như mục 2.
- `_bo_nho/`: bản sao các file bộ nhớ dự án lúc nén.
- Tham chiếu ngoài thư mục tập, **không** chép vào zip: sheet Bò Bía `Halo_Cub/Rau_cau/02_nhan_vat/2.1_Bo_bia/character_sheet/bo_bia_character_sheet_v1a_raw.jpg`; project Flow "Nov 23 - 12:07" (`f1076bae-668b-4c4f-b302-329e29702f5b`).

## 7. Nạp lại ở phiên mới

1. Đọc file này, rồi đọc `quy_trinh/quy_trinh_thay_nhan_vat_clip_goc.md`.
2. Xem bản hiện hành `06_render/ban_nhap_bo_bia_v005/` và `ghi_chu.md` của nó.
3. Muốn sửa tiếp thì dựa trên G1/E2/E3 (phông xanh), ảnh nền và các lệnh ghép. Phải giữ nguyên các thông số đặt Bò Bía và nhịp phóng to (mục 6.3 của quy trình).
4. Việc có thể làm tiếp, chỉ khi người dùng yêu cầu: lập `PROJECT_INDEX.md`, xử lý các điểm ở mục 5.

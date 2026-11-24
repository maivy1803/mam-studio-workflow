Quy chuẩn hình ảnh của Mam_Studio cho series hoạt hình 3D ngắn Halo_Cub (nhóm nhân vật suc-vat-team). Mọi số đo ở đây lấy từ các character sheet người dùng đã chốt, ngày 2026-11-17 đến 2026-11-23. Lời người dùng luôn đứng trên trang này.

## Nội dung và chữ

- Viết tiếng Việt có dấu trên mọi nhãn và tài liệu. Tên file dùng tiếng Việt không dấu, nối bằng gạch dưới.
- Viết tên nhân vật trong tiêu đề bằng chữ in hoa: `BÒ BÍA`, `HEO 1 · ĐEN TRẮNG`.
- Tiêu đề sheet theo mẫu `<TÊN IN HOA>[ · <MÔ TẢ>] — character sheet[ <bản>] (ĐÃ CHỐT yyyy-mm-dd)`.
- Chân trang theo mẫu `<phiên lớn hoặc tập> · #<sub-session> · <nguồn> · yyyy-mm-dd`. Nguồn là `Google Flow gen_i2i` hoặc `bản người dùng gửi và chốt`.
- Có hai kiểu nhãn ô đang dùng. Chọn theo sheet cùng nhóm:
  - Song ngữ: `FRONT · Chính diện` | `BACK · Sau lưng` | `CHÂN DUNG` (Bò, Mèo, Gà).
  - Tiếng Việt: `Chính diện` | `Sau lưng` | `Cận mặt` (2 Heo).
- Sheet bốn góc dùng nhãn `FRONT · Chính diện` | `3/4 · Ba phần tư` | `SIDE · Nghiêng` | `BACK · Sau lưng`.
- Không dùng emoji trên sheet.

## Style của series

- **Chất liệu**:
  - Render 3D kiểu phim hoạt hình, không toon.
  - Nhân vật là thú bông lông dày, xù nhẹ, mờ. Có viền lông tơ quanh dáng và một chỏm lông rối trên đầu.
- **Dáng**:
  - Mập lùn, cao khoảng 2,7 đầu, không cổ.
  - Thân quả lê rộng hơn đầu, bụng tròn rộng nhất ở nửa dưới.
  - Tay ống ngắn sát người. Chân ngắn khoảng 1/6 chiều cao.
  - Bàn tròn kiểu găng, không ngón, không vuốt. Đứng hai chân.
- **Mặt**:
  - Diễn bằng mí mắt. Mõm hoặc mỏ là trung tâm mặt. Mũi to, khoảng 1/4 bề ngang mặt.
  - Vịt Lộn luôn có mắt hạt cườm: đen đặc, một chấm sáng, không lòng trắng, không mí. Không bao giờ đổi.
- **Màu**:
  - Tông trầm, hơi bụi, tương phản thấp.
  - Đen là đen than có ánh xám sợi lông, không bao giờ đen tuyền.
  - Trắng là kem ngà ấm, tối hơn `sheet-nen` một bậc.
- **Ánh sáng**: một đèn chính mềm, ấm, từ bên phải. Bóng xám ấm. Bóng sàn dài đổ sang trái, bóng tiếp xúc đậm dưới chân.
- **Khẩu hình**: miệng mở vừa phải trong mõm, lòng miệng tối. Không răng nanh, không thè lưỡi.
- **Giữ nhân vật**:
  - Dùng đúng sheet chốt mới nhất.
  - Ảnh nhóm chỉ đổi biểu cảm và tư thế.
  - Không chép phụ kiện từ ảnh tham chiếu.
  - Hỏi trước khi sửa ảnh hay thêm cử động.

## Character sheet

### Bản raw

- Kích thước `sheet-rong` × `sheet-raw-cao` (1376 × 768), nền `sheet-nen`, không chữ, không viền.
- Bố cục ba ô:
  - trái: chính diện toàn thân;
  - giữa: sau lưng toàn thân, cùng cỡ, chân cùng đường đất;
  - phải: chân dung đầu và ngực, to, tràn mép dưới và mép phải.
- Ở ô toàn thân, nhân vật chiếm khoảng 78–80 % chiều cao, đỉnh tai cách mép trên khoảng 12 %.
- Chó Phú Quốc dùng bố cục bốn góc một hàng.
- Giữ nguyên dấu ✦ của Gemini ở góc phải dưới nếu sheet chốt có.

### Bản có nhãn

Bản có nhãn cao `sheet-co-nhan-cao` (936 px). Từ trên xuống:
1. Thanh tiêu đề `thanh-tieu-de-cao` nền `sheet-thanh-tieu-de`. Tiêu đề kiểu `tieu-de`, màu `sheet-chu-tieu-de`, lề `le-tieu-de`.
2. Ảnh raw giữ nguyên.
3. Dải nhãn `dai-nhan-cao` nền `sheet-dai-nhan`:
   - Nhãn kiểu `nhan-o`, màu `sheet-chu-nhan`, căn giữa dưới từng nhân vật.
   - Đường kẻ `sheet-duong-ke` ở y = 902, lề `le-duong-ke`.
   - Chân trang kiểu `chan-trang`, màu `sheet-chu-chan-trang`, lề `le-chan-trang`.

Góc vuông (`sheet-goc`). Ảnh khác cỡ thì nhân mọi số đo theo tỉ lệ rộng / 1376. Xem component SheetCoNhan và ảnh mẫu trong nhóm **Sheet co nhan**.

### Font

- Windows: Segoe UI Bold cho tiêu đề và nhãn, Segoe UI cho chân trang.
- macOS: Arial Bold và Arial.
- Font thay thế phải đủ dấu tiếng Việt.

## Ảnh tham chiếu đã khóa

Nhóm **Tham chieu** có các ảnh dưới đây, nhóm **Nhan vat** có sheet không nhãn. Khi gen trên Google Flow chỉ gắn bản không nhãn; bản có nhãn để người xem nhận mặt.
- `Duck_character_turnaround_sheet_ebd7d6f6.jpg`: concept 6 biểu cảm của Vịt Lộn (khóa 2026-11-16). Tên có chữ turnaround nhưng là sheet biểu cảm. **Có Vịt trên Flow thì gắn ảnh này.** Test cho thấy chỉ ghi khóa mắt bằng chữ thì Flow vẫn vẽ mắt có lòng trắng.
- `Duck_character_turnaround_sheet_3af3b1fe.jpg`: concept 4 góc của Vịt (khóa 2026-11-16), có góc 3/4 và nghiêng.
- `bo_bia_turnaround_ref_01.jpg`: sheet 4 góc của Bò do người dùng gửi, nguồn của sheet v1a. Ảnh này chưa khóa, nhưng là ảnh duy nhất có góc 3/4 và nghiêng của Bò.
- `bo_bia_B05_S09_im_lang.png`: biểu cảm Bò "im lặng", mắt mở to đứng hình (khóa 2026-11-17).
- `style_bo_vit_4_goc.jpg`: Bò và Vịt 4 góc, dùng làm chuẩn style khi làm nhân vật mới. Chỉ lấy style: Bò trong ảnh là biến thể cũ.

Mỗi lượt chỉ gắn vài ảnh. Ưu tiên sheet không nhãn của nhân vật chính, rồi sheet biểu cảm nếu có Vịt.

## Màu nhân vật

Các token `bo-bia-*`, `vit-lon-*`, `meo-*`, `ga-*`, `cho-pq-*`, `heo-1-*`, `heo-2-*` là mảng màu chính đo từ sheet chốt của từng con.
- Dùng chúng để đối chiếu khi soát ảnh mới có lệch màu không.
- Không dùng làm màu chữ hay màu nền giao diện.
- Chi tiết nhỏ (mỏ cam của Vịt, mõm hồng tím và chuông đồng của Bò, mũi hồng của Heo) ít điểm ảnh nên không có token. Tra trong mô tả nhận diện của từng sheet.

## Ảnh nhóm

- Mọi con chung đường đất. Bò cao nhất, Vịt khoảng 1/2 Bò (tỉ lệ tạm, chưa khóa).
- Bò đứng giữa, các con khác dàn đều khung.
- Chữ `halo club` trên avatar chưa có bản chốt. Hỏi người dùng trước khi dùng.

## Đặt tên file

- Bản gốc: `<nv>_character_sheet_v<N>a_CHOT.webp`. Giữ nguyên byte; ghi kích thước, số byte và sha256 vào file mô tả.
- Bản tham chiếu: `..._raw.jpg`, JPEG q95, không nhãn.
- Bản có nhãn: `..._CHOT_co_nhan.jpg`.
- Sheet người dùng gửi không có số bản: dùng ngày thay số bản, ví dụ `meo_character_sheet_2026-11-23_raw.jpg`.
- Ảnh tham chiếu: `tham_chieu/<nv>_ref_NN_<mo_ta>.png`.
- Bản dựng và clip: mỗi bản mới lưu thành `vNNN` riêng. Không sửa, chuyển hay xóa clip gốc.

## Logo và biểu tượng

Series chưa có logo chốt và không dùng bộ icon nào. Tên series viết bằng chữ thường.

## Công cụ

Bộ cài Mam_Studio_Kit có skill `mam-studio-design-system`. Skill này mang tài liệu đầy đủ và hai script chạy được trên macOS và Windows, cần ffmpeg:
- `tao_sheet_co_nhan.mjs` ghép bản có nhãn đúng quy chuẩn trên.
- `bang_mau_tu_sheet.mjs` rút bảng màu cho nhân vật mới.

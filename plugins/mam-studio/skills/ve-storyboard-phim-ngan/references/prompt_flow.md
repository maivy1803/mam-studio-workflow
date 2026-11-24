# Prompt Google Flow cho panel storyboard

Viết prompt bằng **tiếng Anh**, vì model ảnh hiểu tiếng Anh ổn định hơn. Tên món ăn Việt giữ nguyên và giải thích kèm, ví dụ `"rau câu" jelly`.

## 1. Bảng quy đổi màu khối sang vật liệu

Lập bảng này **một lần cho mỗi set**, lấy từ bảng màu của blockout (Mam_Studio: `3.1_bo_cuc_va_dao_cu_NHAP.md` mục 4), rồi dán vào mọi panel. Chỉ giữ các dòng có thấy trong panel cho prompt gọn. Ví dụ từ set "Rau_cau":

```
terracotta left wall = red brick wall with vertical wooden slats and potted plants on shelves;
thin dark bars overhead = black steel frame glass roof; brown ceiling with white beams = wooden plank ceiling;
light grey floor = polished concrete; dark strip with white squares = stepping stones on black pebbles;
green spheres = lush garden plants; long tan table = rustic wooden dining table with concrete legs;
red strip = red-and-white gingham runner; orange stools = wooden bar stools;
pink counter = kitchen counter with red gingham curtains; pale blue tall box = stainless steel fridge;
teal shelves = wooden open shelves with jars; grey cones = aluminium flower-shaped jelly moulds;
small green/cream/pink blobs = small Vietnamese "rau câu" jellies; yellow hanging cones = rattan pendant lamps.
```

## 2. Hình nộm nhân vật

```
magenta stand-in (cylinder body, round head, cone nose showing where it looks) = <TÊN NHÂN VẬT A>, exactly as in Image 3;
yellow stand-in = <TÊN NHÂN VẬT B>, exactly as in Image 4.
Keep each character's position, size relative to the set, and facing direction exactly as the stand-in.
```

## 3. Mẫu A: panel có nhân vật

```
Storyboard frame <PANEL> of an animated short. Image 1 is a colour-coded 3D blockout: keep its exact camera
angle, lens, framing, layout, and the position, height and facing of every object and stand-in. Image 2 is the
reference for the set's materials, lighting and mood. Image 3 [and Image 4] show the characters' final design.

Render image 1 as a finished stylized 3D animated-film frame: soft rounded shapes, clean hand-crafted textures,
cinematic depth of field focused on <AI/CÁI GÌ>.

<BẢNG QUY ĐỔI — chỉ các dòng thấy trong panel>
<DÒNG HÌNH NỘM>

Action: <dịch SÁT NGHĨA cột "Hành động" của shotlist, không thêm động tác. VD shotlist "Vịt nhấc khuôn, rau câu ra đĩa"
        → "the duck lifts the mould and the jelly comes out onto the plate">.
Expression: <chỉ khi shotlist có ghi cảm xúc, VD "Bò nghe, nheo mắt nghi ngờ" → "the cow listens, eyes narrowed, suspicious";
            thể hiện theo các đặc điểm đã khóa ở Session nhân vật, VD mắt hạt cườm của Vịt khi cười là "^ ^">
<Ánh sáng: theo 3.2 nếu đã khóa, nếu chưa: "Daytime, warm sunlight, soft dappled leaf shadows">.
No text, no subtitles, no speech bubbles, no watermark. Do not add any object that is not in Image 1.
```

Ghi chú cho mẫu A:
- **Nói rõ ai ở gần máy và ai ở xa** nếu panel có hai nhân vật. Ví dụ: "the cow is in the foreground seen from behind its left shoulder, out of focus".
- Nhân vật **nói ngoài khung** (L08, L13 ở Rau_cau) thì không cho hình nộm vào panel đó, và không tả nhân vật đó.
- Shot **qua vai**: hình nộm sau lưng sẽ thành lưng hoặc vai mờ ở tiền cảnh. Ghi rõ "seen from behind, blurred foreground".

## 4. Mẫu B: panel chỉ có bối cảnh hoặc đạo cụ (insert)

```
Storyboard frame <PANEL>. Image 1 is a colour-coded 3D blockout: keep its exact camera, framing and layout.
Image 2 is the material and lighting reference. Render as a finished stylized 3D animated-film frame, shallow
depth of field on <ĐẠO CỤ>. Empty of characters. <BẢNG QUY ĐỔI>. <ÁNH SÁNG>.
No text, no watermark. Do not add any object that is not in Image 1.
```

## 5. Gọi tool

```
mcp__google-flow__gen_i2i(
  project = "<project id>",
  refs = ["<...>\\storyboard\\blockout\\SB_S03_blockout.png",
          "<...>\\storyboard\\refs\\REF_BO.png"],          # TỐI ĐA 2 ảnh; ảnh thứ 3 bị ReferenceNotFoundError
  prompt = "<mẫu A đã điền>",
  aspect = "16:9", count = 1, job_id = "sb-rau_cau-S03-v1")
```

Kết quả trả về `outputs[0].path` dạng `out\\<workflow_id>_1.jpg`. File thật nằm ở `C:\Users\PC\tools\google-flow-mcp\out\<workflow_id>_1.jpg`. Chép sang `storyboard\flow\SB_<panel>.jpg`. Nhớ đọc `outcome.charged` (phải là 0 với nano2).

## 6. Kiểm tra ảnh ra

- Góc máy và bố cục có khớp khung blockout không. Flow đôi khi đẩy máy lùi ra hoặc xoay nhẹ. Lệch nhiều thì vẽ lại, nhấn mạnh "exact camera".
- Nhân vật có đúng concept không (màu lông, đặc điểm nhận diện, tỷ lệ Bò/Vịt). Flow có lúc làm rơi đặc điểm nhận diện; ví dụ Rau_cau S08 vẽ Vịt mất tóc cắt bát. Khi vẽ lại, viết "IMPORTANT, keep its signature look exactly as Image 2" và tả kỹ đặc điểm đó.
- Người dùng gửi ảnh biểu cảm riêng cho một panel: ghép ảnh đó vào bên phải ảnh bối cảnh làm Image 2, và viết "copy the face in Image 2 exactly", kèm động tác miệng nếu panel có thoại.
- Có đồ vật lạ không. Có chữ không (phụ đề sẽ thêm ở hậu kỳ, không để Flow vẽ).
- Mặt nhân vật có nằm trong dải giữa cho crop 9:16 không (xem khung đỏ khi ghép bảng với `-SafeZone916`).

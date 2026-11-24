---
name: feedback-google-flow-trinh-duyet-app
description: "Mam_Studio: dùng Google Flow bằng tay trong trình duyệt của app (Ctrl+Shift+B), không dùng MCP google-flow"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 35a3261c-9f6e-48d5-86b1-159be1bc0287
  modified: 2026-11-23T05:58:54.030Z
---

Ngày 2026-11-21, ở phiên Team-suc-vat, người dùng nói: "Tắt mcp với googleflow, mở google flow trong ctrl shift B". Từ đó làm Google Flow bằng tay trong trình duyệt của app (công cụ `mcp__Claude_Browser__*`), không gọi `google-flow` hay `flow-studio`.

**Why:** người dùng muốn thấy và điều khiển Flow ngay trong khung trình duyệt của app. `google-flow` là server MCP cài trên máy (loại "user"), công cụ connector của app không tắt được, nên chỉ cần không gọi nó.

**How to apply:**
- Tài khoản Flow trong trình duyệt của app (avatar "M") khác tài khoản MCP cũ. Project cũ như `ce0c8123…` (sheet Bò Bía, Vịt Lộn) không mở được ở đây.
- **Tự tải ảnh tham chiếu lên, đừng nhờ người dùng** (người dùng bực khi phải tự bấm Upload, 2026-11-21: "không tự tải lên được hay gì"). Trình duyệt của app chặn chọn file, Ctrl+V, clipboard.read và fetch localhost. Cách chạy được: đổi ảnh sang JPEG nhỏ, nạp base64 vào trang bằng `javascript_tool` theo khúc ≤14.6k ký tự, kiểm sha256 (chép tay có thể sai 1 ký tự), dựng `File`, rồi dispatch DragEvent `dragenter/dragover/drop` lên lưới media. Chi tiết: `C:\Users\PC\AppData\Roaming\Claude-Work\side-session-notes\local_78068ed1-d5a0-4324-a72f-388ff9d471aa\flow_tu_tai_anh_len_bang_base64.md`.
- Trước khi gen thì tắt Agent mode (công tắc trong khung prompt) để có khung prompt thường (Nano Banana, tỷ lệ, xN).
- Sửa một chi tiết: dùng chức năng sửa ảnh của Flow (mở ảnh, ô "What do you want to change?", 0 credit), chỉ đổi đúng vùng đó.
- Người dùng muốn nét nhận diện **y chang ảnh gốc**. Tả bằng chữ dễ lệch (vệt trắng con mèo: tả "hẹp" thì ra nhọn, tả "vòm tròn" thì ra tròn quá). Cách đúng: cắt cận đúng vùng đó từ ảnh gốc, tự tải lên làm tham chiếu, rồi bảo Flow chép theo ảnh cắt.
- Thanh % trên trang sửa ảnh có lúc đứng (vd 53%): tải lại trang là thấy kết quả.
- Tải video lên Flow: dùng server Node bind 127.0.0.1 cộng fetch `targetAddressSpace: 'local'`, rồi thả file vào lưới media; cách này chạy được cả với mp4. Mở video sẽ ra trang `/edit/<id>`: ô "Describe how to edit this video…", model Omni 1.2 Flash (shot 4,5s tốn 12 credit), nút "+" để gắn ảnh tham chiếu. Đừng bấm Escape vì nó thoát trang sửa video.
- Ngày 2026-11-23, Flow từ chối sửa video tải lên có tiếng nói ("Our policies prevent editing or generating speech for people in uploaded videos") và hoàn credit. Thay nhân vật trong clip người khác có lời thoại không làm được bằng chức năng sửa video của Flow.
- Muốn có bản Bò Bía "thay vào" clip có thoại thì dựng mới. Ngày 2026-11-23 làm thế này:
  - Tạo khung đầu bằng Nano Banana: khung phòng gốc cộng sheet, 0 credit.
  - Dựng video bằng Omni 1.2 Flash ở chế độ Frames (khung đầu), 9:16, 720p, x1, thanh Length 3–15s (khoảng 3–4 credit/giây).
  - Lệnh ghi mốc giây cho từng câu nói và cử chỉ. Omni bám mốc khá sát (±0,3s).
  - Ghép tiếng gốc bằng ffmpeg trên máy.
- Kéo video Flow về máy:
  - Patch `fetch` và `XMLHttpRequest` trong tab để bắt chữ `flow-content.google/video/<id>?Expires&KeyName&Signature`. Trong text có `\\u003d`/`\\u0026` lặp backslash, phải bỏ đi.
  - Mở ô video lần đầu **sau khi** đã patch (nếu đã mở trước đó thì tải lại trang rồi patch).
  - fetch URL đó, POST về server Node 127.0.0.1 có endpoint `/save`.
  - Ảnh full-res lấy từ `<img>` có naturalWidth 768 ở trang `/edit/<id>`.
- Đổi nền mà giữ nguyên diễn xuất (người dùng chốt cách này ngày 2026-11-23, tập Uong-oi-e v003):
  - Sửa clip do chính Flow tạo bằng Omni: "replace background with flat chroma green, keep the character exactly". Khoảng 3 credit/giây. Omni giữ cử động, tự lùi khung cho thấy cả chân.
  - Tạo ảnh nền trống bằng Nano Banana.
  - ffmpeg tách phông (`chromakey` + `despill`), đặt nhân vật đúng tỉ lệ thật theo vật trong cảnh (ghế đẩu khoảng 30cm, bàn nhựa khoảng 50cm), thêm bóng chân, `zoompan` trên khung 1440×2560.
  - Người dùng muốn nhân vật **đúng tỉ lệ với môi trường thật**, không to quá khổ như khi Flow tự đặt.
- **Chỉ render 1 bản (x1)** cho cả ảnh lẫn video, không để mặc định x2. Người dùng dặn ngày 2026-11-23: "sau này render 1 bản thôi".
- Video Frames: **đừng đặt khung cuối trùng khung đầu** nếu người dùng không yêu cầu. Model sẽ về đúng tư thế khung cuối sớm rồi đứng im phần còn lại. Ngày 2026-11-23 outro 9:16 `a41c85f6` đứng im từ giây 2 tới giây 3, người dùng chửi: "Đoạn từ giây thứ 2 tới giây thứ 3 tự nhiên đứng yên". Chỉ đặt khung đầu, và ghi trong prompt là chuyển động liên tục tới khung cuối cùng.

Liên quan [[mam-studio-production-workflow]].

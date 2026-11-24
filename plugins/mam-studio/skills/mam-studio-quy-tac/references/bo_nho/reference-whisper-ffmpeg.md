---
name: reference-whisper-ffmpeg
description: Chép lời clip gốc bằng bộ lọc whisper có sẵn trong ffmpeg 9 trên máy; model đã tải ở C:\Users\PC\.cache\whisper
metadata:
  node_type: memory
  type: reference
  originSessionId: 194de265-7af1-41ad-acc9-1a534a2fae53
  modified: 2026-11-23T06:39:11.044Z
---

Máy có ffmpeg 9.0.2 bản full (WinGet Gyan.FFmpeg) với bộ lọc `whisper` (whisper.cpp). Máy không có Python.

Người dùng đã đồng ý tải model `ggml-large-v3-turbo-q5_0.bin` (574 MB) về `C:\Users\PC\.cache\whisper\` ngày 2026-11-23 để các tập sau dùng lại. Model nhận tiếng Việt miền Nam khá tốt.

Cách chạy:
- Trước tiên tách tiếng ra wav 16 kHz mono.
- Chạy `-af "whisper=model='C\:/Users/PC/.cache/whisper/ggml-large-v3-turbo-q5_0.bin':language=vi:queue=10:destination=out.srt:format=srt"`.
- Thêm `max_len=1` nếu cần mốc thời gian từng chữ.
- Dấu `:` trong `C:` làm hỏng chuỗi filter. Cách đã thử được: bọc đường dẫn trong nháy đơn và thoát dấu `:` thành `C\:` (trong bash dùng `cygpath -m` rồi `${p/:/\\:}`). Đường dẫn tương đối cũng được nếu cùng ổ.
- Mốc nói/im chính xác nên đo bằng độ lớn dải giọng nói (highpass 200 + lowpass 4000, `astats` mỗi 0,01–0,1 s), không dùng `silencedetect` toàn dải (từng lệch 0,7 s). Xem [[reference-quy-trinh-thay-nhan-vat]].

Lỗi dễ gặp:
- Đoạn âm thanh ngắn hoặc gần im lặng hay sinh câu bịa kiểu "Hãy subscribe cho kênh Ghiền Mì Gõ".
- Chạy cả clip một lượt có thể lặp câu.
- Nên cắt theo `silencedetect` rồi chép lại từng câu, đối chiếu với phụ đề tự động TikTok nếu có.

Liên quan: [[mam-studio-production-workflow]]

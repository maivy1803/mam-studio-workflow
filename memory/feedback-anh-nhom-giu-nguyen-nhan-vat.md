---
name: feedback-anh-nhom-giu-nguyen-nhan-vat
description: "Mam_Studio: ảnh nhóm (lineup, avatar, cảnh chung) chỉ đổi biểu cảm/tư thế/khung, không được đổi nét nhân vật so với sheet"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 78068ed1-d5a0-4324-a72f-388ff9d471aa
  modified: 2026-11-23T05:05:13.825Z
---

Ngày 2026-11-21, ở suc-vat-team, người dùng phản đối avatar nhóm v2: "sao lại tự ý thay đổi chất lượng nhân vật". Lỗi của bản đó:
- Vịt bị vẽ mắt người có lòng trắng và mí nặng để "liếc", sai khóa mắt hạt cườm.
- Mèo bị thêm mi giả lấy từ ảnh ref, người dùng chỉ bảo "khoe nail".
- Dùng bản nhân vật cũ (qua avatar v1b) thay vì bản mới nhất ở sub-session.
- Định tự sửa ảnh mà chưa hỏi.

**Why:** nhân vật là tài sản đã duyệt và khóa qua từng sub-session. Ảnh nhóm mà đổi nét thì người dùng coi là tự ý làm hỏng nhân vật.

**How to apply:**
- Trước khi làm ảnh nhóm, đọc bản mới nhất và các khóa của từng nhân vật ở sub-session của nó. Dùng đúng sheet đó làm tham chiếu, không lấy qua ảnh nhóm cũ.
- Biểu cảm phải diễn bằng cách nhân vật đó được phép. Ví dụ Vịt liếc thì lông tơ che bớt mắt, đầu và mỏ quay ngang, vẫn mắt hạt cườm.
- Ảnh ref biểu cảm chỉ lấy đúng thứ người dùng gọi tên (nail, lè lưỡi...), không chép phụ kiện hay nét khác.
- Muốn sửa ảnh thì hỏi trước.
- Khi thay nhân vật cũ trong ảnh nhóm bằng bản đã chốt, bỏ hết chi tiết của bản cũ mà sheet chốt không có, kể cả thứ người dùng từng yêu cầu cho ảnh cũ. Ngày 2026-11-22 mình giữ bộ nail hồng của mèo cũ khi thay bằng Mèo Cam Sành, người dùng chửi: "Con mèo của tao chốt có nail đéo đâu". Chỉ giữ tư thế, vị trí, biểu cảm.

- Video làm từ ảnh nhóm/avatar (outro, end card): không tự thêm chuyển động hay đổi biểu cảm nhân vật. Ngày 2026-11-22 outro A (Flow, project `a9396094…`) có prompt tự thêm Bò ngoáy lưỡi, Chó nhún tay, Mèo vẫy, Gà gật, Vịt quay đầu, Chó còn mở mắt cười. Người dùng chửi: "Sao lại tự ý chỉnh sửa animation của các nhân vật". Muốn nhân vật cử động thì hỏi trước cử động nào. Cùng ngày người dùng bảo bỏ tiếng nhân vật Flow sinh ra trong outro, chỉ dùng một đoạn nhạc.

- **Mắt Vịt không bao giờ được đổi**, kể cả để diễn biểu cảm và kể cả trong video. Mắt phải đúng sheet chốt: hạt cườm đen đặc, tròn, một chấm sáng; không lòng trắng, không mí, không lông mày. Ngày 2026-11-23, avatar 7 con và outro có Vịt mắt lòng trắng có mí (kiểu liếc). Người dùng: "mắt vịt bị sai rồi, ghi nhớ không thay đổi mắt vịt". Mỗi prompt ảnh và video có Vịt phải ghi khóa này. Trong video, ghi rõ mắt Vịt giữ nguyên suốt clip, không chớp, không liếc.
- Khóa mắt Vịt **không có nghĩa là bắt Vịt đứng yên**. Ngày 2026-11-23 mình viết prompt cho Vịt "đứng yên hoàn toàn như ảnh tĩnh" trong outro 9:16. Người dùng: "ai mượn kêu con vịt đứng yên". Vịt vẫn cử động như các con khác, chỉ giữ mắt hạt cườm. Không tự thêm ràng buộc người dùng không yêu cầu.

Liên quan [[feedback-google-flow-trinh-duyet-app]], [[feedback-kich-ban-bam-goc-khong-them-chi-tiet]].

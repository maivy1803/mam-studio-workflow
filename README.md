# Mam_Studio_Kit 1.2.0: bộ cài Claude Code cho Mam_Studio / Halo_Cub

Một bộ cài dùng chung cho **macOS** và **Windows**. Nó mang mọi thứ Claude cần để làm việc với dự án Mam_Studio như trên máy gốc:
- 4 skill;
- bộ nhớ dự án (các luật người dùng đã dặn);
- design system (quy chuẩn hình ảnh) và trang Design System trên claude.ai;
- sheet nhân vật đã chốt, bản có nhãn và ảnh tham chiếu đã khóa;
- quy trình và script đã chạy thật ở tập `Uong-oi-e`;
- mẫu `CLAUDE.md`.

Đóng gói ngày 2026-11-24 từ máy gốc (Windows).

**Định dạng:** một **plugin Claude Code** kèm marketplace nội bộ (chuẩn của Claude Code). Thêm tài nguyên, bộ nhớ và trình cài/gỡ cho từng hệ điều hành, tất cả trong một file zip. Lý do:
- Skill cài được theo hai cách: chép thẳng vào `~/.claude/skills/` (mặc định, không cần lệnh `claude`), hoặc cài thành plugin bằng `claude plugin`.
- Bộ nhớ và tài nguyên không thuộc phần plugin, nên trình cài tự chép vào đúng chỗ.

## Bên trong có gì

| Thành phần | Nơi trong bộ cài | Cài vào đâu |
|---|---|---|
| Skill **mam-studio-quy-tac**: quy tắc điều phối 6 Session, luật người dùng, bảng nhân vật đã chốt, bản đầy đủ của bộ nhớ, 4 ghi chú tự tải ảnh lên Google Flow | `plugins/mam-studio/skills/mam-studio-quy-tac/` | `~/.claude/skills/` |
| Skill **thay-nhan-vat-clip-goc**: đưa nhân vật Halo_Cub vào clip gốc, giữ tiếng gốc, đúng tỉ lệ, đổi nền, sửa mắt, sửa khớp miệng. Kèm 7 script (bash, Node, JS cho tab Flow) và 2 ảnh mẫu | `plugins/mam-studio/skills/thay-nhan-vat-clip-goc/` | `~/.claude/skills/` |
| Skill **ve-storyboard-phim-ngan**: vẽ storyboard từ shotlist. Có `ghep_storyboard.mjs` chạy cả Mac lẫn Windows | `plugins/mam-studio/skills/ve-storyboard-phim-ngan/` | `~/.claude/skills/` |
| Skill **mam-studio-design-system** (mới): quy chuẩn hình ảnh (style series, character sheet, bản có nhãn, bảng màu nhân vật, đặt tên file, khối prompt style). Kèm `tao_sheet_co_nhan.mjs` (ghép nhãn sheet), `bang_mau_tu_sheet.mjs` (rút bảng màu) và ảnh mẫu | `plugins/mam-studio/skills/mam-studio-design-system/` | `~/.claude/skills/` |
| Plugin + marketplace nội bộ (cách cài thay thế) | `.claude-plugin/marketplace.json`, `plugins/mam-studio/.claude-plugin/plugin.json` | `claude plugin install` |
| Bộ nhớ dự án (9 file + `MEMORY.md`) | `memory/` | `~/.claude/projects/<tên-dự-án>/memory/` |
| Nhân vật đã chốt: Bò Bía, Vịt Lộn, Mèo (bản 23/11), Gà, Chó Phú Quốc, 2 Heo. Mỗi con có sheet không nhãn (gắn Flow), bản có nhãn và file mô tả (nhận diện, câu prompt) | `tai_nguyen/nhan_vat/<nv>/` | `<dự án>/_Mam_Studio_Kit/` |
| Ảnh tham chiếu đã khóa:
<br>• Vịt: concept 4 góc và concept 6 biểu cảm. Sheet biểu cảm phải gắn để Flow giữ mắt hạt cườm.
<br>• Bò: sheet 4 góc nguồn và biểu cảm B05 "im lặng".
<br>• Ảnh style Bò + Vịt 4 góc dùng chung. | `tai_nguyen/nhan_vat/vit_lon/tham_chieu/`, `bo_bia/tham_chieu/`, `bo_bia/bieu_cam/`, `_style_chung/` | `<dự án>/_Mam_Studio_Kit/` |
| Bối cảnh: ảnh nguồn bố cục bếp nhà Bò và Vịt (tập Rau_cau) | `tai_nguyen/boi_canh/` | `<dự án>/_Mam_Studio_Kit/` |
| Design system: tài liệu quy chuẩn, link trang claude.ai, bản sao token của trang | `tai_nguyen/design_system/` | `<dự án>/_Mam_Studio_Kit/` |
| Ví dụ tập Uong-oi-e: báo cáo, lời có mốc, ghi chú v1–v5, ảnh nền | `tai_nguyen/vi_du_tap_uong_oi_e/` | `<dự án>/_Mam_Studio_Kit/` |
| Mẫu `CLAUDE.md` cho gốc dự án | `tai_nguyen/mau_du_an/CLAUDE.md` | `<dự án>/CLAUDE.md` (hỏi trước, không ghi đè) |
| Bộ nén lại zip kiểu Unix | `cong_cu/dong_goi_zip.mjs` | không cài; dùng khi cập nhật bộ cài |

Mỗi nhân vật chỉ có bản chốt mới nhất và các ảnh tham chiếu đã khóa. Không có file nháp hay video nặng.

**Chưa có trong bộ cài**
- **Chưa có bản chốt trên máy:** bảng khẩu hình của mọi con; sheet biểu cảm theo shot của Bò và bảng biểu cảm chung Bò + Vịt (đang chờ duyệt); lineup và tỉ lệ chiều cao (còn tạm); avatar, logo, outro.
- **Thằn lằn:** người dùng chọn bỏ (2026-11-24), nên không đưa vào bộ cài. Sheet cũ (chốt 2026-11-21) vẫn còn trong `Halo_Cub/suc-vat-team/02_character_sheet_SESSION_ZIP_2026-11-21.zip` nếu cần tra.

**Trang Design System trên claude.ai:** https://claude.ai/artifact/FTKDxFtAASthBFtXpbcm7E
- Trang có token màu, kiểu chữ, kích thước sheet, ảnh 7 sheet chốt và component sheet có nhãn.
- Trang riêng tư: chỉ tài khoản chủ dự án mở được. Muốn người khác xem thì chia sẻ từ menu Share của trang.

**Tên thư mục bộ nhớ.** `<tên-dự-án>` là đường dẫn thư mục dự án, thay mọi ký tự không phải chữ hoặc số bằng `-` (cách Claude Code đặt tên). Trình cài tự tính tên này:
- Windows: `E:\MikeVee\Freelancer\Hoat hinh AI\Mam_studio` → `E--MikeVee-Freelancer-Hoat-hinh-AI-Mam-studio`
- macOS: `/Users/ban/Mam_studio` → `-Users-ban-Mam-studio`

## Cần có

- **Claude Code** (CLI hoặc app Claude desktop, tab Code).
- **ffmpeg**:
  - macOS: `brew install ffmpeg`
  - Windows: `winget install Gyan.FFmpeg`
  - Muốn chép lời clip thì ffmpeg phải có bộ lọc `whisper` (ffmpeg 8+ bản đầy đủ). Trình cài sẽ báo nếu thiếu.
- **Node.js**:
  - macOS: `brew install node`
  - Windows: `winget install OpenJS.NodeJS.LTS`
- **Windows**: Git for Windows (Git Bash) để chạy các script `.sh`. Claude Code trên Windows vốn đã dùng Git Bash.
- **Không bắt buộc:** model whisper `ggml-large-v3-turbo-q5_0.bin` (574 MB). Trình cài hỏi trước khi tải về `~/.cache/whisper/`.

Trình cài kiểm các thứ trên và đề nghị cài bằng Homebrew hoặc winget. Chỉ cài khi bạn đồng ý.

## Cài đặt

Giải nén zip vào một chỗ cố định. Có thể để trong `<dự án>/_bo_cai/`, khi đó trình cài tự đoán thư mục dự án. Sau đó:

**macOS**
```bash
cd đường/dẫn/Mam_Studio_Kit
bash install.sh
```
Hoặc bấm đúp `install.command`. Nếu macOS chặn: chuột phải vào file → Open, hoặc chạy `xattr -dr com.apple.quarantine .` trong thư mục bộ cài.

**Windows**: bấm đúp `install.cmd`, hoặc chạy:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Trình cài hỏi thư mục dự án Mam_Studio (thư mục chứa `Halo_Cub`). Chưa có thư mục thì trình cài hỏi có tạo không. Cài xong, **khởi động lại** Claude Code hoặc app Claude.

**Tùy chọn** (bash `--…` / PowerShell `-…`):

| bash | PowerShell | Tác dụng |
|---|---|---|
| `--yes` | `-Yes` | Không hỏi, dùng mặc định (không tải model) |
| `--project <dir>` | `-Project <dir>` | Chỉ định thư mục dự án |
| `--mode plugin` | `-Mode plugin` | Cài dạng plugin qua `claude plugin`, skill gọi bằng `/mam-studio:<tên>`. Mặc định `skills`. Plugin đọc thẳng từ `~/.claude/mam-studio-kit/` (trình cài tự chép vào), đừng xóa thư mục đó |
| `--model` / `--no-model` | `-Model` / `-NoModel` | Tải hay bỏ qua model whisper |
| `--no-memory` | `-NoMemory` | Không cài bộ nhớ |
| `--no-resources` | `-NoResources` | Không chép tài nguyên |
| `--claude-md` / `--no-claude-md` | `-ClaudeMd` / `-NoClaudeMd` | Tạo hay không tạo `CLAUDE.md` mẫu |
| `--claude-home <dir>` | `-ClaudeHome <dir>` | Thư mục cấu hình Claude khác `~/.claude` (mặc định theo biến `CLAUDE_CONFIG_DIR` nếu có) |

**An toàn**
- **Không ghi đè khi chưa hỏi.** Trình cài hỏi trước khi thay skill, file bộ nhớ hay file trong `_Mam_Studio_Kit` đang có mà không phải do nó đặt. Đồng ý thì bản cũ được sao lưu:
  - skill: `~/.claude/skills/.backup-mam-studio-<thời gian>/`;
  - bộ nhớ: `memory/.backup-mam-studio-<thời gian>/`;
  - tài nguyên: `_Mam_Studio_Kit/.backup-<thời gian>/`.
- `MEMORY.md` có sẵn chỉ được thêm dòng còn thiếu.
- `CLAUDE.md` có sẵn không bao giờ bị ghi đè.
- Mọi thứ trình cài đặt vào máy được ghi vào sổ `~/.claude/mam-studio-kit.install.txt`, kèm mã sha256 của từng file.
- Cài lại hoặc cài bản mới: file do bản trước đặt mà chưa bị sửa thì được thay luôn. File đã bị sửa thì trình cài hỏi lại.

## Gỡ cài đặt

- macOS: `bash uninstall.sh`
- Windows: bấm đúp `uninstall.cmd`

Trình gỡ chỉ gỡ **những gì có trong sổ cài đặt**:
- Mặc định gỡ skill hoặc plugin, rồi hỏi có gỡ cả bộ nhớ, tài nguyên, `CLAUDE.md` và model không (mặc định: không).
- `--all` / `-All`: gỡ hết mà không hỏi.
- File đã bị sửa sau khi cài (ví dụ bộ nhớ Claude đã ghi thêm) được **giữ lại**.
- File cũ bị thay lúc cài thì được trả về chỗ cũ từ bản sao lưu.
- Dòng đã thêm vào `MEMORY.md` được bỏ ra.
- Thư mục chỉ bị xóa khi đã rỗng.

Gỡ bằng đúng loại script đã dùng để cài: cài bằng `install.sh` thì gỡ bằng `uninstall.sh`, cài bằng `install.ps1` thì gỡ bằng `uninstall.ps1`.

## Dùng thử sau khi cài

- Mở thư mục dự án trong Claude, hỏi: "Quy tắc Mam_Studio là gì?". Claude sẽ dùng skill `mam-studio-quy-tac`.
- Nói "ghép nhãn cho sheet con heo này". Claude sẽ dùng skill `mam-studio-design-system`.
- Đưa một clip gốc và nói "thay Bò Bía vào clip này, giữ voice gốc". Claude sẽ dùng skill `thay-nhan-vat-clip-goc`.

## Cập nhật bộ cài (trên máy gốc)

1. Chép skill, bộ nhớ hoặc sheet mới vào thư mục `Mam_Studio_Kit/`.
2. Tăng số trong `VERSION` và `version` trong `plugins/mam-studio/.claude-plugin/plugin.json`. Thêm một dòng vào mục Lịch sử bên dưới.
3. Nén lại: `node cong_cu/dong_goi_zip.mjs`. Bộ nén này ghi zip kiểu Unix để macOS giữ quyền chạy của `.sh` và `.command`. Đừng nén bằng "Send to → Compressed folder" hay `Compress-Archive` của Windows: chúng làm mất quyền chạy.

## Lưu ý

- Bộ nhớ và tài liệu có nhắc **đường dẫn của máy gốc** (`E:\MikeVee\…`, `C:\Users\PC\…`). Trên máy khác, coi đó là ví dụ.
- Bộ nhớ chỉ nạp khi mở **đúng thư mục dự án** đã chọn lúc cài. Nếu dự án là một git repo, Claude Code lấy thư mục gốc của repo.
- Đổi chỗ dự án thì chạy lại trình cài với `--no-resources --project <chỗ mới>`.
- Skill `mam-studio-quy-tac` mang sẵn bản đầy đủ của bộ nhớ, nên luật vẫn dùng được ở mọi thư mục.
- **Google Flow** làm tay trong trình duyệt của app. Tài khoản, project và credit Flow không nằm trong bộ cài.
- `ghep_storyboard.ps1` chỉ chạy trên Windows; trên Mac dùng `ghep_storyboard.mjs`.
- Video và các file nặng của từng tập không nằm trong bộ cài. Chúng ở các file `*_SESSION_ZIP_*.zip` của từng tập.
- Không có skill `kie-models`: người dùng đã dặn không dùng KIE.
- Ảnh mẫu `thay-nhan-vat-clip-goc/assets/o_binh_luan_mau_720.png` cắt từ clip thật, còn tên và ảnh đại diện của người bình luận. Làm mờ trước khi chia sẻ bộ cài cho người ngoài.

## Lịch sử

- **1.2.0** (2026-11-24):
  - Thằn lằn: người dùng chọn bỏ, không đưa vào bộ cài.
  - Thêm 12 ảnh tham chiếu sau khi soát 961 ảnh trong dự án:
    - 2 sheet concept của Vịt (4 góc, 6 biểu cảm);
    - sheet 4 góc nguồn của Bò và biểu cảm B05;
    - bản có nhãn của Bò, Vịt, Mèo, Gà, Chó, Heo 2;
    - ảnh style Bò + Vịt;
    - ảnh nguồn bối cảnh bếp Rau_cau.
  - Thêm bản có nhãn Heo 1 vào `nhan_vat/heo/`.
  - Thêm file mô tả cho Mèo. Thêm ghi chú bộ cài vào đầu các file mô tả nhân vật (ảnh nào có trong bộ cài, nằm ở đâu).
  - Cập nhật bảng nhân vật trong `mam-studio-quy-tac` và mục 7 (ảnh tham chiếu) trong quy chuẩn hình ảnh.
- **1.1.0** (2026-11-24):
  - Thêm skill `mam-studio-design-system` và thư mục `tai_nguyen/design_system/`. Thêm trang Design System trên claude.ai.
  - Thêm 4 ghi chú tự tải ảnh lên Flow vào `mam-studio-quy-tac`.
  - Cập nhật bộ nhớ (thêm `reference-bo-cai-mam-studio-kit`).
  - Trình cài hỏi trước khi thay file không phải của nó và ghi sổ từng file (sha256). Trình gỡ chỉ gỡ theo sổ, giữ file đã sửa, trả lại bản cũ.
  - Thêm `cong_cu/dong_goi_zip.mjs`.
- **1.0.0** (2026-11-24):
  - Bản đầu: 3 skill, bộ nhớ, 7 sheet nhân vật, ví dụ Uong-oi-e, trình cài và gỡ cho macOS/Windows.
  - Thêm `ghep_storyboard.mjs` chạy được cả hai hệ điều hành.
  - Script nghiên cứu clip tự tìm font và model theo hệ điều hành.

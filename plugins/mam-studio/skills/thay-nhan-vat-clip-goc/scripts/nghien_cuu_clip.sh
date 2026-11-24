#!/usr/bin/env bash
# Buoc 1 - Boc tach clip goc: thong so, diem cat canh, bang khung 2 hinh/giay, chep loi bang whisper (ffmpeg).
# Dung: nghien_cuu_clip.sh <clip_goc.mp4> <thu_muc_ra> [ngon_ngu=vi]
# Can: ffmpeg/ffprobe (bo loc whisper de chep loi: ffmpeg 8+ ban day du), model o
#      ~/.cache/whisper/ggml-large-v3-turbo-q5_0.bin (hoac bien WHISPER_MODEL), font Arial (tu tim theo he dieu hanh).
# Chay duoc tren macOS (bash) va Windows (Git Bash). Khong sua clip goc. Moi file ra nam trong <thu_muc_ra>.
set -euo pipefail
V="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; OUT="$2"; LANG_="${3:-vi}"
MODEL="${WHISPER_MODEL:-$HOME/.cache/whisper/ggml-large-v3-turbo-q5_0.bin}"
mkdir -p "$OUT"; cd "$OUT"

# Font cho chu tren bang khung: chep vao thu muc ra va goi ten tuong doi (tranh dau ':' cua o dia trong chuoi filter).
for f in /c/Windows/Fonts/arial.ttf "/System/Library/Fonts/Supplemental/Arial.ttf" "/Library/Fonts/Arial.ttf" \
         /usr/share/fonts/truetype/msttcorefonts/Arial.ttf /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf; do
  if [ -f "$f" ]; then cp -n "$f" ./arial.ttf 2>/dev/null || true; break; fi
done
[ -f ./arial.ttf ] || echo "CANH BAO: khong tim thay font Arial; bang khung se loi o buoc 3. Chep mot file .ttf vao $OUT/arial.ttf."

echo "== 1. Thong so"; ffprobe -v error -show_format -show_streams -of json "$V" > thong_so.json
ffprobe -v error -show_entries stream=codec_type,codec_name,width,height,r_frame_rate,duration -of compact=p=0 "$V"

echo "== 2. Diem cat canh (scdet, nguong 5)"
ffmpeg -hide_banner -i "$V" -vf "scdet=threshold=5:sc_pass=0" -f null - 2>&1 | grep -oE "lavfi.scd.score: [0-9.]+, lavfi.scd.time: [0-9.]+" | tee diem_cat.txt || true

echo "== 3. Bang khung 2 hinh/giay (20 khung moi tam)"
ffmpeg -hide_banner -loglevel error -i "$V" -vf "fps=2,scale=192:-1,drawtext=fontfile=arial.ttf:text='%{pts\:flt}':x=3:y=3:fontsize=16:fontcolor=yellow:box=1:boxcolor=black@0.7,tile=10x2" -y bang_khung_%02d.jpg
ls bang_khung_*.jpg

echo "== 4. Tieng: 16 kHz mono, chep loi ca clip bang whisper"
ffmpeg -hide_banner -loglevel error -i "$V" -vn -ac 1 -ar 16000 -y audio16k.wav
if ! ffmpeg -hide_banner -filters 2>/dev/null | grep -q " whisper "; then
  echo "BO QUA: ffmpeg nay khong co bo loc whisper (can ffmpeg 8+ ban day du). Cac buoc khac van chay."
elif [ ! -f "$MODEL" ]; then
  echo "BO QUA: chua co model whisper o $MODEL (bo cai co the tai giup: install --model)."
else
  # Dau ':' trong 'C:' lam hong chuoi filter -> tren Windows dung duong dan C:/..., boc nhay don, thoat ':' thanh '\:'.
  WM="$MODEL"
  if command -v cygpath >/dev/null 2>&1; then WM="$(cygpath -m "$MODEL")"; WM="${WM/:/\\:}"; fi
  ffmpeg -hide_banner -loglevel warning -i audio16k.wav -af "whisper=model='$WM':language=$LANG_:queue=20:destination=thoai_ca_clip.srt:format=srt" -f null - || true
fi

echo "== 5. Khoang lang (chia cau) - dung de cat tung cau roi chep lai tung cau cho chac"
ffmpeg -hide_banner -i audio16k.wav -af "silencedetect=noise=-36dB:d=0.18" -f null - 2>&1 | grep -oE "silence_(start|end): [0-9.]+" | paste - - | tee khoang_lang.txt || true

echo "== 6. Do lon dai giong noi moi 0,1s (nhin cho noi/im chinh xac hon silencedetect)"
ffmpeg -hide_banner -i "$V" -af "aresample=44100,aformat=channel_layouts=mono,highpass=f=200,lowpass=f=4000,asetnsamples=n=4410,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level" -vn -f null - 2>&1 \
 | grep -oE "RMS_level=[-0-9.inf]+" | cut -d= -f2 | sed 's/-inf/-90/' | awk '{n=int(($1+70)/3); if(n<0)n=0; s=""; for(i=0;i<n;i++)s=s"#"; printf "%6.1f %6.1f %s\n",(NR-1)*0.1,$1,s}' > do_lon_giong.txt
echo "Xong. Xem: thong_so.json, diem_cat.txt, bang_khung_*.jpg, thoai_ca_clip.srt, khoang_lang.txt, do_lon_giong.txt"

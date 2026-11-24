#!/usr/bin/env bash
# Sua khop mieng cho MOT canh can mat ma khong render lai ca clip:
# dung lai canh tu ban ghep phong xanh voi hinh tre LAG khung, roi thay dung cac khung [N0, N1) trong ban cu.
# Hai dau canh nen la diem cat canh de cho nhay hinh bi che.
# Dung: sua_khop_mieng_doan.sh <ban_cu.mp4> <G1> <G2> <G3> <nen.jpg> <bong_chan.png> <N0> <N1> <LAG> <ZOOM> <out.mp4>
#   G1..G3 : 3 doan phong xanh dung de ghep ban cu (cung thu tu, cung cach cat 9.5 / 11.6 / 14.6334 s)
#   N0 N1  : khung dau (tinh ca) va khung cuoi (khong tinh) cua canh can sua, o 24 fps (vd 343 419 = 14.29-17.42 s)
#   LAG    : so khung lam hinh tre lai (lay tu tim_do_tre_mieng.sh), vd 11
#   ZOOM   : muc phong cua canh do trong ban cu (vd 3.2 cho can mat)
# Thong so dat bo (848x1508 tai 290,906; tam x 712; dinh can mat y 1045) phai giong lenh ghep ban cu.
set -euo pipefail
IN="$1"; G1="$2"; G2="$3"; G3="$4"; NEN="$5"; BONG="$6"; N0="$7"; N1="$8"; LAG="$9"; ZM="${10}"; OUT="${11}"
S0=$((N0-LAG)); S1=$((N1-LAG))
KEY="chromakey=0x2EE036:0.16:0.05,despill=type=green:mix=0.6"
Z0=1.227; ZC=3.2; Y0=421; YC=1045; CX=712
P="max(0\,min(1\,(zoom-$Z0)/($ZC-$Z0)))"
X="max(0\,min(iw-iw/zoom\,$CX-iw/zoom/2))"
Y="max(0\,min(ih-ih/zoom\,$Y0+($P)*($YC-$Y0)))"
ffmpeg -hide_banner -loglevel error -y \
  -i "$IN" -i "$G1" -i "$G2" -i "$G3" -loop 1 -i "$NEN" -loop 1 -i "$BONG" \
  -filter_complex "\
[1:v]trim=0:9.5,setpts=PTS-STARTPTS,fps=24,scale=720:1280[a];\
[2:v]trim=0:11.6,setpts=PTS-STARTPTS,fps=24,scale=720:1280[b];\
[3:v]trim=0:14.6334,setpts=PTS-STARTPTS,fps=24,scale=720:1280[c];\
[a][b][c]concat=n=3:v=1:a=0,$KEY,scale=848:1508:flags=lanczos,colorbalance=rm=0.03:bm=-0.03[cow];\
[4:v]scale=1440:2580:flags=lanczos,crop=1440:2560:0:10,fps=24,format=rgba[bg];\
[5:v]fps=24,format=rgba[sh];\
[bg][sh]overlay=0:0:shortest=0[bs];\
[bs][cow]overlay=290:906:shortest=1:format=auto,format=yuv420p[comp];\
[comp]trim=start_frame=$S0:end_frame=$S1,setpts=PTS-STARTPTS,zoompan=z='$ZM':x='$X':y='$Y':d=1:s=720x1280:fps=24,setsar=1[cu];\
[0:v]split=2[v0][v1];\
[v0]trim=end_frame=$N0,setpts=PTS-STARTPTS,setsar=1[pa];\
[v1]trim=start_frame=$N1,setpts=PTS-STARTPTS,setsar=1[pb];\
[pa][cu][pb]concat=n=3:v=1:a=0,format=yuv420p[v]" \
  -map "[v]" -map 0:a -c:v libx264 -crf 14 -preset slow -pix_fmt yuv420p -r 24 -c:a copy -movflags +faststart "$OUT"
ffprobe -v error -count_frames -select_streams v -show_entries stream=nb_read_frames -of csv=p=0 "$OUT" | sed 's/^/so khung: /'

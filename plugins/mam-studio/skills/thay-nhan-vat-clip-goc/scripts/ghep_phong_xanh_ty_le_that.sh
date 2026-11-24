#!/usr/bin/env bash
# Ghep ban v3 Uong-oi-e: 3 doan phong xanh (G1 0-9.5, G2 9.5-21.1, G3 21.1-35.733, cung dien xuat voi v1)
# -> tach phong, dat Bo Bia (cao ~1,5 m) vao canh quan nhau trong, bong duoi chan,
# -> phong to theo nhip goc, o binh luan 0-9.5s, tieng goc.
# Dung: ghep_v3_phong_xanh.sh <G1> <G2> <G3> <nen.jpg> <bong_chan.png> <tieng_goc.wav> <o_binh_luan.png> <out.mp4>
set -euo pipefail
G1="$1"; G2="$2"; G3="$3"; NEN="$4"; BONG="$5"; A="$6"; BOX="$7"; OUT="$8"
KEY="chromakey=0x2EE036:0.16:0.05,despill=type=green:mix=0.6"
# Canvas 1440x2560. Bo: scale 1.178 (848x1508), dat tai (290,906) -> chan o y~2362, giua x~712.
# z0=1.227 (toan than ~62% khung), zCU=3.2 (can mat); S08 x1.12 = 1.374.
Z0=1.227; ZC=3.2; Y0=421; YC=1045; CX=712
Z="if(between(it\,14.267\,17.433)\,$ZC\,if(between(it\,19.267\,21.1)\,1.374\,if(between(it\,21.1\,24.5)\,$ZC\,if(between(it\,24.5\,26.5)\,$ZC-($ZC-$Z0)*(it-24.5)/2\,$Z0))))"
P="max(0\,min(1\,(zoom-$Z0)/($ZC-$Z0)))"
X="max(0\,min(iw-iw/zoom\,$CX-iw/zoom/2))"
Y="max(0\,min(ih-ih/zoom\,$Y0+($P)*($YC-$Y0)))"
ffmpeg -hide_banner -loglevel error -y \
  -i "$G1" -i "$G2" -i "$G3" -loop 1 -i "$NEN" -loop 1 -i "$BONG" -i "$A" -loop 1 -i "$BOX" \
  -filter_complex "\
[0:v]trim=0:9.5,setpts=PTS-STARTPTS,fps=24,scale=720:1280[a];\
[1:v]trim=0:11.6,setpts=PTS-STARTPTS,fps=24,scale=720:1280[b];\
[2:v]trim=0:14.6334,setpts=PTS-STARTPTS,fps=24,scale=720:1280[c];\
[a][b][c]concat=n=3:v=1:a=0,$KEY,scale=848:1508:flags=lanczos,colorbalance=rm=0.03:bm=-0.03[cow];\
[3:v]scale=1440:2580:flags=lanczos,crop=1440:2560:0:10,fps=24,format=rgba[bg];\
[4:v]fps=24,format=rgba[sh];\
[bg][sh]overlay=0:0:shortest=0[bs];\
[bs][cow]overlay=290:906:shortest=1:format=auto,format=yuv420p[comp];\
[comp]zoompan=z='$Z':x='$X':y='$Y':d=1:s=720x1280:fps=24[zoomed];\
[6:v]format=rgba[box];\
[zoomed][box]overlay=x=141:y=80:enable='lt(t\,9.5)':shortest=1[v]" \
  -map "[v]" -map 5:a -t 35.733 -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p -r 24 -c:a aac -b:a 192k -movflags +faststart "$OUT"

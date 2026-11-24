#!/usr/bin/env bash
# Ghep ban nhap Uong-oi-e: 3 doan Flow (T1 0-9.5, T2 9.5-21.1, T3 21.1-35.733) + phong to theo nhip goc + o binh luan 0-9.5s + tieng goc.
# Dung: ghep_ban_nhap.sh <T1.mp4> <T2.mp4> <T3.mp4> <tieng_goc.wav> <o_binh_luan.png> <out.mp4>
set -euo pipefail
T1="$1"; T2="$2"; T3="$3"; A="$4"; BOX="$5"; OUT="$6"
# z(it): 1.8 can mat S04-S05 (14.267-17.433); 1.12 S08 (19.267-21.1); 1.8 S09 21.1-24.5 roi lui dan ve 1.0 den 26.5
Z="if(between(it\,14.267\,17.433)\,1.8\,if(between(it\,19.267\,21.1)\,1.12\,if(between(it\,21.1\,24.5)\,1.8\,if(between(it\,24.5\,26.5)\,1.8-0.8*(it-24.5)/2\,1))))"
ffmpeg -hide_banner -loglevel error -y \
  -i "$T1" -i "$T2" -i "$T3" -i "$A" -loop 1 -i "$BOX" \
  -filter_complex "\
[0:v]trim=0:9.5,setpts=PTS-STARTPTS,fps=24,scale=720:1280,setsar=1[a];\
[1:v]trim=0:11.6,setpts=PTS-STARTPTS,fps=24,scale=720:1280,setsar=1[b];\
[2:v]trim=0:14.6334,setpts=PTS-STARTPTS,fps=24,scale=720:1280,setsar=1[c];\
[a][b][c]concat=n=3:v=1:a=0[base];\
[base]scale=1440:2560:flags=lanczos,zoompan=z='$Z':x='iw/2-iw/zoom/2':y='0.02*(ih-ih/zoom)':d=1:s=720x1280:fps=24[zoomed];\
[4:v]format=rgba[box];\
[zoomed][box]overlay=x=141:y=80:enable='lt(t\,9.5)':shortest=0[v]" \
  -map "[v]" -map 3:a -t 35.733 -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p -r 24 -c:a aac -b:a 192k -movflags +faststart "$OUT"

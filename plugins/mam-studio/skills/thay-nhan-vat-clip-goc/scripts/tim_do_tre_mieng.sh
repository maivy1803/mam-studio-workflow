#!/usr/bin/env bash
# Tim do tre (so khung) de mieng nhan vat khop tieng goc trong mot doan.
# Dung tieng Flow tu sinh kem theo clip lam "dau vet mieng" (mieng mo khi tieng Flow co giong).
# Dung: tim_do_tre_mieng.sh <tieng_goc.wav> <clip_flow.mp4> <offset_s> <t0> <t1> [fps=24]
#   offset_s : thoi diem trong bai = thoi diem trong clip_flow + offset_s (vd doan 2 bat dau o 9.5 -> 9.5)
#   t0 t1    : doan can khop, tinh theo thoi gian bai (vd 14.267 17.433)
# Ra: cac do tre tot nhat (so khung, giay, ty le trung nhau). Do tre duong = cho hinh tre lai.
set -euo pipefail
A="$1"; M="$2"; OFF="$3"; T0="$4"; T1="$5"; FPS="${6:-24}"
S=$(awk -v a="$T0" 'BEGIN{s=a-2; if(s<0)s=0; printf "%.3f", s}'); E=$(awk -v b="$T1" 'BEGIN{printf "%.3f", b+1}')
env_(){ ffmpeg -hide_banner -ss "$2" -to "$3" -i "$1" -af "aformat=channel_layouts=mono:sample_rates=44100,highpass=f=200,lowpass=f=4000,asetnsamples=n=441,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level" -vn -f null - 2>&1 | grep -oE "RMS_level=[-0-9.inf]+" | cut -d= -f2 | sed 's/-inf/-90/' | tr '\n' ' '; }
MS=$(awk -v s="$S" -v o="$OFF" 'BEGIN{v=s-o; if(v<0)v=0; printf "%.3f", v}'); ME=$(awk -v e="$E" -v o="$OFF" 'BEGIN{printf "%.3f", e-o}')
export ENV_G="$(env_ "$A" "$S" "$E")" ENV_M="$(env_ "$M" "$MS" "$ME")" P_S="$S" P_MS="$MS" P_OFF="$OFF" P_T0="$T0" P_T1="$T1" P_FPS="$FPS"
node -e '
const e=process.env; const [S,MS,OFF,T0,T1,FPS]=[e.P_S,e.P_MS,e.P_OFF,e.P_T0,e.P_T1,e.P_FPS];
const G=e.ENV_G.trim().split(/\s+/).map(Number), M=e.ENV_M.trim().split(/\s+/).map(Number);
const th=-33, gb=G.map(v=>v>th?1:0), mb=M.map(v=>v>th?1:0);
const gStart=+S, mStart=+MS + +OFF; // ca hai doi ve thoi gian bai, buoc 0.01 s
const i0=Math.round((+T0-gStart)*100), i1=Math.round((+T1-gStart)*100), dm=Math.round((mStart-gStart)*100);
const res=[]; for(let f=-6; f<=20; f++){ const lag=Math.round(f/ +FPS*100); let a=0,n=0; for(let i=i0;i<i1;i++){ const j=i-dm-lag; if(j<0||j>=mb.length) continue; n++; if(gb[i]===mb[j]) a++; } if(n) res.push({khung:f, giay:+(f/ +FPS).toFixed(3), trung:+(a/n).toFixed(3)}); }
const z=res.find(r=>r.khung===0); res.sort((a,b)=>b.trung-a.trung);
console.log("Tot nhat:", JSON.stringify(res.slice(0,5))); console.log("Hien tai (0 khung):", JSON.stringify(z));
'

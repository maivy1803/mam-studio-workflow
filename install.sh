#!/usr/bin/env bash
# Mam_Studio_Kit - trinh cai cho macOS / Linux / Windows (Git Bash).
# Cai: 4 skill (hoac plugin), bo nho du an, tai nguyen (sheet nhan vat, design system, vi du), mau CLAUDE.md, model whisper (tuy chon).
# Dung: bash install.sh [--yes] [--project <thu_muc_du_an>] [--mode skills|plugin] [--model|--no-model]
#                       [--no-memory] [--no-resources] [--claude-md|--no-claude-md] [--claude-home <thu_muc>]
# An toan: file/thu muc da co ma khong phai do bo cai dat thi HOI truoc khi thay (ban cu duoc sao luu).
# Moi thu bo cai dat duoc ghi vao so <claude-home>/mam-studio-kit.install.txt; uninstall.sh chi go nhung thu trong so.
# Chay duoc voi bash 3.2 cua macOS (khong dung mang ket hop cua bash 4).
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "$KIT_DIR/VERSION" 2>/dev/null || echo 1.1.0)"
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
MODE=skills; PROJECT=""; YES=0; DO_MEMORY=1; DO_RES=1; DO_MODEL=ask; DO_CLAUDEMD=ask
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin"
MODEL_FILE="$HOME/.cache/whisper/ggml-large-v3-turbo-q5_0.bin"
TS="$(date +%Y%m%d-%H%M%S)"
TAB="$(printf '\t')"

while [ $# -gt 0 ]; do
  case "$1" in
    --yes|-y) YES=1 ;;
    --project) PROJECT="$2"; shift ;;
    --mode) MODE="$2"; shift ;;
    --model) DO_MODEL=yes ;;
    --no-model) DO_MODEL=no ;;
    --no-memory) DO_MEMORY=0 ;;
    --no-resources) DO_RES=0 ;;
    --claude-md) DO_CLAUDEMD=yes ;;
    --no-claude-md) DO_CLAUDEMD=no ;;
    --claude-home) CLAUDE_HOME="$2"; shift ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "Tham so la: $1"; exit 2 ;;
  esac
  shift
done
case "$MODE" in skills|plugin) ;; *) echo "--mode phai la skills hoac plugin"; exit 2 ;; esac

say()  { printf '%s\n' "$*"; }
ok()   { printf '  [OK] %s\n' "$*"; }
warn() { printf '  [!]  %s\n' "$*"; }
ask()  { # ask "cau hoi" mac_dinh(y/n) -> 0 neu dong y
  local q="$1" def="$2" a
  if [ "$YES" = 1 ]; then [ "$def" = y ]; return; fi
  read -r -p "$q [$( [ "$def" = y ] && echo Y/n || echo y/N )] " a || a=""
  a="${a:-$def}"; case "$a" in y|Y|yes|co|c) return 0 ;; *) return 1 ;; esac
}
sha() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi; }

OS="$(uname -s 2>/dev/null || echo unknown)"
case "$OS" in
  Darwin) OSNAME=macOS ;;
  MINGW*|MSYS*|CYGWIN*) OSNAME=Windows ;;
  Linux) OSNAME=Linux ;;
  *) OSNAME="$OS" ;;
esac

# ---------- So cai dat ----------
# Dong muc: KIND<TAB>NHOM<TAB>DUONG_DAN<TAB>SHA256<TAB>THEM (F=file, D=thu muc, L=dong trong MEMORY.md, P=plugin, M=marketplace)
REC="$CLAUDE_HOME/mam-studio-kit.install.txt"
WORK="$(mktemp -d 2>/dev/null || mktemp -d -t mamkit)"; trap 'rm -rf "$WORK"' EXIT
PREV="$WORK/prev"; ENT="$WORK/ent"; : > "$PREV"; : > "$ENT"
if [ -f "$REC" ]; then
  awk -F'\t' 'NF>=5 && $1 ~ /^[FDLPM]$/' "$REC" > "$PREV"
  legacy="$(sed -n 's/^skills=//p' "$REC" | head -1)"
  for s in $legacy; do printf 'D\tskills\t%s\t\t\n' "$CLAUDE_HOME/skills/$s" >> "$PREV"; done
fi
# prev_get KIND PATH -> dat bien P_HASH, P_EXTRA; tra 1 neu khong co
prev_get() {
  local out
  out="$(K="$1" P="$2" awk -F'\t' '$1==ENVIRON["K"] && $3==ENVIRON["P"] { h=$4; e=$5; if(h=="")h="-"; if(e=="")e="-"; print h "\t" e; f=1; exit } END { exit !f }' "$PREV")" || return 1
  P_HASH="${out%%"$TAB"*}"; P_EXTRA="${out#*"$TAB"}"
  [ "$P_HASH" = - ] && P_HASH=""; [ "$P_EXTRA" = - ] && P_EXTRA=""
  return 0
}
add_entry() { printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" >> "$ENT"; }
keep_prev() { # giu cac muc cua so cu chua co trong so moi (loc theo nhom neu co tham so)
  K="${1:-}" awk -F'\t' 'NR==FNR { seen[$1 FS $3 FS ($1=="L" ? $5 : "")]=1; next }
    { k=$1 FS $3 FS ($1=="L" ? $5 : ""); if (!(k in seen) && (ENVIRON["K"]=="" || index(" " ENVIRON["K"] " ", " " $2 " "))) print }' "$ENT" "$PREV" > "$WORK/keep"
  cat "$WORK/keep" >> "$ENT"
}
save_record() {
  mkdir -p "$CLAUDE_HOME"
  { echo "# Mam_Studio_Kit - so cai dat. Dung uninstall.sh de go; dung sua tay."
    echo "version=$VERSION"; echo "date=$TS"; echo "mode=$MODE"; echo "project=$PROJECT"; echo "memdir=${MEMDIR:-}"
    cat "$ENT"; } > "$REC"
}

# install_file SRC DST NHOM THU_MUC_SAO_LUU NHAN -> dat bien RES = new|same|upd|backup|kept
install_file() {
  local src="$1" dst="$2" group="$3" bkroot="$4" label="$5" cur new bk i ans had=0
  P_HASH=""; P_EXTRA=""; prev_get F "$dst" && had=1
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; add_entry F "$group" "$dst" "$(sha "$dst")" "$P_EXTRA"; RES=new; return
  fi
  cur="$(sha "$dst")"; new="$(sha "$src")"
  if [ "$cur" = "$new" ]; then [ $had = 1 ] && add_entry F "$group" "$dst" "$cur" "$P_EXTRA"; RES=same; return; fi
  if [ $had = 1 ] && [ "$P_HASH" = "$cur" ]; then cp "$src" "$dst"; add_entry F "$group" "$dst" "$new" "$P_EXTRA"; RES=upd; return; fi
  eval "ans=\${GA_$group:-}"
  if [ -z "$ans" ]; then
    if ask "  Da co file khac ban cua bo cai ($label). Thay bang ban moi? Ban cu se duoc sao luu" y; then ans=yes; else ans=no; fi
    eval "GA_$group=$ans"
  fi
  if [ "$ans" = no ]; then [ $had = 1 ] && add_entry F "$group" "$dst" "$P_HASH" "$P_EXTRA"; RES=kept; return; fi
  mkdir -p "$bkroot"; bk="$bkroot/$(basename "$dst")"; i=1
  while [ -e "$bk" ]; do bk="$bkroot/$i-$(basename "$dst")"; i=$((i+1)); done
  cp "$dst" "$bk"; cp "$src" "$dst"
  add_entry F "$group" "$dst" "$new" "${P_EXTRA:-$bk}"; RES=backup
}
# install_dir SRC DST NHOM THU_MUC_SAO_LUU NHAN [contents] -> 0 neu da cai
install_dir() {
  local src="$1" dst="$2" group="$3" bkroot="$4" label="$5" bk=""
  P_HASH=""; P_EXTRA=""
  if prev_get D "$dst"; then bk="$P_EXTRA"; [ -e "$dst" ] && rm -rf "$dst"
  elif [ -e "$dst" ]; then
    if ask "  Da co $label (khong phai do bo cai dat). Thay bang ban moi? Ban cu se duoc sao luu" y; then
      mkdir -p "$bkroot"; bk="$bkroot/$(basename "$dst")"; mv "$dst" "$bk"; warn "da sao luu ban cu: $bk"
    else warn "giu nguyen $dst (khong cai)"; return 1; fi
  fi
  if [ "${6:-}" = contents ]; then mkdir -p "$dst"; cp -R "$src/." "$dst/"; else cp -R "$src" "$dst"; fi
  add_entry D "$group" "$dst" "" "$bk"; return 0
}

say "=================================================="
say " Mam_Studio_Kit $VERSION  -  cai tren $OSNAME"
say " Thu muc Claude: $CLAUDE_HOME"
[ -s "$PREV" ] && say " (da co ban cai truoc: lan nay se cap nhat)"
say "=================================================="

# ---------- 1. Kiem tra cong cu ----------
say ""; say "1) Kiem tra cong cu"
NEED=""
if command -v ffmpeg >/dev/null 2>&1; then
  ok "ffmpeg: $(ffmpeg -hide_banner -version 2>/dev/null | head -1 | cut -c1-60)"
  if ffmpeg -hide_banner -filters 2>/dev/null | grep -q " whisper "; then ok "ffmpeg co bo loc whisper"; else warn "ffmpeg chua co bo loc whisper (can ffmpeg 8+ ban day du de chep loi)"; fi
else warn "chua co ffmpeg"; NEED="$NEED ffmpeg"; fi
if command -v node >/dev/null 2>&1; then ok "node: $(node -v)"; else warn "chua co Node.js"; NEED="$NEED node"; fi
if command -v claude >/dev/null 2>&1; then ok "claude CLI: co"; HAS_CLAUDE=1; else warn "chua thay lenh 'claude' (khong bat buoc o che do skills)"; HAS_CLAUDE=0; fi
if [ -n "$NEED" ]; then
  if [ "$OSNAME" = macOS ] && command -v brew >/dev/null 2>&1; then
    if ask "Cai$NEED bang Homebrew (brew install$NEED)?" n; then brew install $NEED; fi
  elif [ "$OSNAME" = Windows ] && command -v winget >/dev/null 2>&1; then
    PK=""; case "$NEED" in *ffmpeg*) PK="$PK Gyan.FFmpeg" ;; esac; case "$NEED" in *node*) PK="$PK OpenJS.NodeJS.LTS" ;; esac
    if ask "Cai$PK bang winget?" n; then for p in $PK; do winget install -e --id "$p" --accept-source-agreements; done; fi
  else
    warn "Hay tu cai:$NEED (macOS: brew install$NEED ; Windows: winget install Gyan.FFmpeg OpenJS.NodeJS.LTS)"
  fi
fi

# ---------- 2. Thu muc du an ----------
if [ -z "$PROJECT" ]; then
  if [ -d "$PWD/Halo_Cub" ]; then PROJECT="$PWD"
  elif [ -d "$KIT_DIR/../../Halo_Cub" ]; then PROJECT="$(cd "$KIT_DIR/../.." && pwd)"
  fi
  if [ "$YES" != 1 ]; then
    read -r -p "Thu muc du an Mam_Studio (chua Halo_Cub) [${PROJECT:-bo qua}]: " a || a=""
    a="${a%\"}"; a="${a#\"}"; a="${a%\'}"; a="${a#\'}"
    [ -n "$a" ] && PROJECT="$a"
  fi
fi
case "$PROJECT" in "~"|"~/"*) PROJECT="$HOME${PROJECT#\~}" ;; esac
if [ -n "$PROJECT" ] && [ ! -d "$PROJECT" ]; then
  if ask "Chua co thu muc $PROJECT. Tao moi?" y; then mkdir -p "$PROJECT"; else PROJECT=""; fi
fi
SLUG=""; MEMDIR=""; NATIVE=""
if [ -n "$PROJECT" ]; then
  PROJECT="$(cd "$PROJECT" && pwd)"
  NATIVE="$PROJECT"; command -v cygpath >/dev/null 2>&1 && NATIVE="$(cygpath -w "$PROJECT")"
  if command -v node >/dev/null 2>&1; then SLUG="$(node -e 'process.stdout.write(process.argv[1].replace(/[^a-zA-Z0-9]/g,"-"))' "$NATIVE")"
  else SLUG="$(printf '%s' "$NATIVE" | sed 's/[^A-Za-z0-9]/-/g')"; fi
  [ ${#SLUG} -gt 200 ] && warn "Ten thu muc du an qua dai (>200 ky tu): Claude se them ma bam, bo nho co the khong khop."
  MEMDIR="$CLAUDE_HOME/projects/$SLUG/memory"
  say ""; say "   Du an: $NATIVE"; say "   Bo nho: $MEMDIR"
fi

# ---------- 3. Cai skill / plugin ----------
say ""; say "3) Cai skill (che do: $MODE)"
SKILL_SRC="$KIT_DIR/plugins/mam-studio/skills"
if [ "$MODE" = plugin ]; then
  [ "$HAS_CLAUDE" = 1 ] || { warn "Che do plugin can lenh 'claude'. Chay lai voi --mode skills."; exit 1; }
  DEST="$CLAUDE_HOME/mam-studio-kit"
  if install_dir "$KIT_DIR" "$DEST" plugin "$CLAUDE_HOME/.backup-mam-studio-$TS" "thu muc mam-studio-kit" contents; then
    claude plugin marketplace add "$DEST" </dev/null || warn "marketplace add bao loi (co the da them truoc do)"
    if claude plugin install mam-studio@mam-studio-kit </dev/null; then
      add_entry M plugin mam-studio-kit "" ""; add_entry P plugin mam-studio@mam-studio-kit "" ""
      ok "plugin mam-studio da cai (goi skill: /mam-studio:<ten>)"
    else warn "claude plugin install bao loi"; fi
  fi
else
  mkdir -p "$CLAUDE_HOME/skills"
  for d in "$SKILL_SRC"/*/; do
    n="$(basename "$d")"; t="$CLAUDE_HOME/skills/$n"
    if install_dir "${d%/}" "$t" skills "$CLAUDE_HOME/skills/.backup-mam-studio-$TS" "skill $n"; then
      find "$t" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
      ok "skill $n -> $t"
    fi
  done
fi
keep_prev "skills plugin"; save_record

# ---------- 4. Bo nho ----------
if [ "$DO_MEMORY" = 1 ] && [ -n "$MEMDIR" ]; then
  say ""; say "4) Cai bo nho du an"
  mkdir -p "$MEMDIR"; BKMEM="$MEMDIR/.backup-mam-studio-$TS"
  for f in "$KIT_DIR"/memory/*.md; do
    n="$(basename "$f")"; [ "$n" = MEMORY.md ] && continue
    install_file "$f" "$MEMDIR/$n" memory "$BKMEM" "bo nho $n"
    case "$RES" in new) ok "them $n" ;; same) ok "giu $n (giong nhau)" ;; upd) ok "cap nhat $n" ;; backup) warn "cap nhat $n (ban cu o $BKMEM)" ;; kept) warn "giu ban dang co cua $n" ;; esac
  done
  IDX="$MEMDIR/MEMORY.md"
  if [ ! -f "$IDX" ]; then cp "$KIT_DIR/memory/MEMORY.md" "$IDX"; add_entry F memory "$IDX" "$(sha "$IDX")" ""; ok "them MEMORY.md"
  elif prev_get F "$IDX" && [ "$P_HASH" = "$(sha "$IDX")" ]; then cp "$KIT_DIR/memory/MEMORY.md" "$IDX"; add_entry F memory "$IDX" "$(sha "$IDX")" "$P_EXTRA"; ok "cap nhat MEMORY.md"
  else
    prev_get F "$IDX" && add_entry F memory "$IDX" "$P_HASH" "$P_EXTRA"
    P="$IDX" awk -F'\t' '$1=="L" && $3==ENVIRON["P"] { print $5 }' "$PREV" > "$WORK/oldlines"
    while IFS= read -r line; do
      if grep -qxF -- "$line" "$IDX"; then add_entry L memory "$IDX" "" "$line"; fi
    done < "$WORK/oldlines"
    while IFS= read -r line || [ -n "$line" ]; do
      link="$(printf '%s' "$line" | sed -n 's/.*](\([^)]*\.md\)).*/\1/p')"
      [ -z "$link" ] && continue
      grep -qF "]($link)" "$IDX" && continue
      [ -s "$IDX" ] && [ "$(tail -c1 "$IDX" | od -An -c | tr -d ' ')" != '\n' ] && printf '\n' >> "$IDX"
      printf '%s\n' "$line" >> "$IDX"; add_entry L memory "$IDX" "" "$line"; ok "MEMORY.md + $link"
    done < "$KIT_DIR/memory/MEMORY.md"
  fi
  save_record
elif [ "$DO_MEMORY" = 1 ]; then warn "Bo qua bo nho (chua co thu muc du an). Chay lai voi --project <thu_muc>."; fi

# ---------- 5. Tai nguyen ----------
if [ "$DO_RES" = 1 ] && [ -n "$PROJECT" ]; then
  R="$PROJECT/_Mam_Studio_Kit"; BKRES="$R/.backup-$TS"
  say ""; say "5) Chep tai nguyen -> $R"
  N_NEW=0; N_UPD=0; N_SAME=0; N_BK=0
  { (cd "$KIT_DIR" && find tai_nguyen -type f) | while IFS= read -r rel; do printf '%s\t%s\n' "$KIT_DIR/$rel" "$rel"; done
    printf '%s\t%s\n' "$KIT_DIR/README.md" README.md "$KIT_DIR/VERSION" VERSION \
      "$SKILL_SRC/thay-nhan-vat-clip-goc/references/quy_trinh_day_du.md" quy_trinh/quy_trinh_day_du.md
  } > "$WORK/pairs"
  # doc danh sach qua fd 3 de cau hoi (neu co) van doc tu ban phim
  while IFS="$TAB" read -r src rel <&3; do
    install_file "$src" "$R/$rel" resources "$BKRES/$(dirname "$rel")" "trong $R"
    case "$RES" in new) N_NEW=$((N_NEW+1)) ;; upd) N_UPD=$((N_UPD+1)) ;; backup) N_UPD=$((N_UPD+1)); N_BK=$((N_BK+1)) ;; *) N_SAME=$((N_SAME+1)) ;; esac
  done 3< "$WORK/pairs"
  ok "$N_NEW file moi, $N_UPD cap nhat, $N_SAME giu nguyen"
  [ "$N_BK" -gt 0 ] && warn "ban cu da sao luu o $BKRES"
  save_record
fi

# ---------- 6. CLAUDE.md mau ----------
if [ -n "$PROJECT" ] && [ "$DO_CLAUDEMD" != no ]; then
  CM="$PROJECT/CLAUDE.md"
  if [ -f "$CM" ]; then
    if prev_get F "$CM"; then add_entry F claudemd "$CM" "$P_HASH" "$P_EXTRA"; ok "giu CLAUDE.md da tao lan truoc"
    else warn "Du an da co CLAUDE.md: giu nguyen (mau o _Mam_Studio_Kit/tai_nguyen/mau_du_an/CLAUDE.md)"; fi
  elif [ "$DO_CLAUDEMD" = yes ] || ask "Tao CLAUDE.md (quy tac Mam_Studio) o goc du an?" y; then
    cp "$KIT_DIR/tai_nguyen/mau_du_an/CLAUDE.md" "$CM"; add_entry F claudemd "$CM" "$(sha "$CM")" ""; ok "tao $CM"
  fi
fi

# ---------- 7. Model whisper ----------
say ""; say "7) Model whisper (chep loi clip goc)"
if [ -f "$MODEL_FILE" ]; then ok "da co $MODEL_FILE"
elif [ "$DO_MODEL" = yes ] || { [ "$DO_MODEL" = ask ] && [ "$YES" != 1 ] && ask "Tai model whisper 574 MB tu huggingface.co ve $MODEL_FILE?" n; }; then
  mkdir -p "$(dirname "$MODEL_FILE")"
  if curl -L --fail -o "$MODEL_FILE.part" "$MODEL_URL" && mv "$MODEL_FILE.part" "$MODEL_FILE"; then add_entry F model "$MODEL_FILE" "" ""; ok "da tai model"; else warn "tai model loi"; fi
else warn "Bo qua. Tai sau: bash install.sh --model --no-memory --no-resources"; fi

keep_prev; save_record
say ""; say "Xong. So cai dat: $REC"
say "Tiep theo: khoi dong lai Claude Code / app Claude, mo thu muc du an, go: dung skill mam-studio-quy-tac."

#!/usr/bin/env bash
# Go Mam_Studio_Kit (macOS / Linux / Git Bash). Chi go nhung thu ghi trong so <claude-home>/mam-studio-kit.install.txt.
# Dung: bash uninstall.sh [--all] [--yes] [--claude-home <thu_muc>]
#   Mac dinh: go skill/plugin, roi hoi co go ca bo nho, tai nguyen, CLAUDE.md, model whisper khong (mac dinh: khong).
#   --all: go ca nhung thu do. --yes: khong hoi (chi go skill/plugin, tru khi co --all).
#   File da bi sua sau khi cai thi giu lai. File cu bi thay luc cai (co sao luu) thi duoc tra ve cho cu.
set -euo pipefail
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"; ALL=0; YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --all) ALL=1 ;; --yes|-y) YES=1 ;; --claude-home) CLAUDE_HOME="$2"; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "Tham so la: $1"; exit 2 ;;
  esac; shift
done
ok()   { printf '  [OK] %s\n' "$*"; }
warn() { printf '  [!]  %s\n' "$*"; }
ask()  { local q="$1" def="$2" a
  if [ "$YES" = 1 ]; then [ "$def" = y ]; return; fi
  read -r -p "$q [$( [ "$def" = y ] && echo Y/n || echo y/N )] " a || a=""
  a="${a:-$def}"; case "$a" in y|Y|yes|co|c) return 0 ;; *) return 1 ;; esac
}
sha() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi; }
TAB="$(printf '\t')"
REC="$CLAUDE_HOME/mam-studio-kit.install.txt"
[ -f "$REC" ] || { echo "Khong thay so cai dat $REC (chua cai, hoac da go)."; exit 1; }
val() { sed -n "s/^$1=//p" "$REC" | head -1; }
VERSION="$(val version)"; DATE="$(val date)"; MODE="$(val mode)"; PROJECT="$(val project)"; MEMDIR="$(val memdir)"
WORK="$(mktemp -d 2>/dev/null || mktemp -d -t mamkit)"; trap 'rm -rf "$WORK"' EXIT
# Doc cac muc; o trong thay bang "-" de "read" tach dung cot.
awk -F'\t' -v OFS='\t' 'NF>=5 && $1 ~ /^[FDLPM]$/ { for (i=1;i<=5;i++) if ($i=="") $i="-"; print }' "$REC" > "$WORK/ent"
if [ ! -s "$WORK/ent" ]; then # so cua ban 1.0.0
  for s in $(val skills); do printf 'D\tskills\t%s\t-\t-\n' "$CLAUDE_HOME/skills/$s" >> "$WORK/ent"; done
  if [ "$MODE" = plugin ]; then printf 'D\tplugin\t%s\t-\t-\nM\tplugin\tmam-studio-kit\t-\t-\nP\tplugin\tmam-studio@mam-studio-kit\t-\t-\n' "$CLAUDE_HOME/mam-studio-kit" >> "$WORK/ent"; fi
fi

echo "=================================================="
echo " Go Mam_Studio_Kit $VERSION  (cai ngay $DATE)"
echo "=================================================="
GROUPS_="skills plugin"
if [ "$ALL" = 1 ]; then GROUPS_="$GROUPS_ memory resources claudemd model"
elif awk -F'\t' '$2!="skills" && $2!="plugin" {f=1} END {exit !f}' "$WORK/ent" \
     && ask "Go ca bo nho, tai nguyen, CLAUDE.md va model do bo cai dat? (file da sua sau khi cai van duoc giu)" n; then
  GROUPS_="$GROUPS_ memory resources claudemd model"; ALL=1
fi

restore() { # restore DUONG_DAN SAO_LUU
  if [ "$2" != - ] && [ -e "$2" ] && [ ! -e "$1" ]; then mv "$2" "$1"; ok "tra lai ban cu: $1"; fi
}
: > "$WORK/left"
# Go theo thu tu nguoc lai luc cai
awk '{ a[NR]=$0 } END { for (i=NR; i>0; i--) print a[i] }' "$WORK/ent" > "$WORK/rev"
while IFS="$TAB" read -r kind group path hash extra <&3; do
  case " $GROUPS_ " in *" $group "*) ;; *) printf '%s\t%s\t%s\t%s\t%s\n' "$kind" "$group" "$path" "$hash" "$extra" >> "$WORK/left"; continue ;; esac
  case "$kind" in
    P) if command -v claude >/dev/null 2>&1; then claude plugin uninstall "$path" </dev/null || true; fi; ok "go plugin $path" ;;
    M) if command -v claude >/dev/null 2>&1; then claude plugin marketplace remove "$path" </dev/null || true; fi; ok "go marketplace $path" ;;
    D) if [ -e "$path" ]; then rm -rf "$path"; ok "go $path"; fi; restore "$path" "$extra" ;;
    F) if [ -e "$path" ]; then
         if [ "$hash" = - ] || [ "$(sha "$path")" = "$hash" ]; then rm -f "$path"; ok "go $path"; restore "$path" "$extra"
         else warn "giu $path (da sua sau khi cai)"; if [ "$extra" != - ] && [ -e "$extra" ]; then warn "  ban truoc khi cai van o $extra"; fi; fi
       else restore "$path" "$extra"; fi ;;
    L) if [ -f "$path" ]; then
         L="$extra" awk 'BEGIN { t=ENVIRON["L"] } !done && $0==t { done=1; next } { print }' "$path" > "$WORK/idx" && cat "$WORK/idx" > "$path"
         ok "bo dong khoi $path"
       fi ;;
  esac
done 3< "$WORK/rev"

remove_empty_dirs() { [ -n "$1" ] && [ -d "$1" ] && find "$1" -depth -type d -empty -exec rmdir {} \; 2>/dev/null; return 0; }
if [ "$ALL" = 1 ] && [ -n "$PROJECT" ]; then remove_empty_dirs "$PROJECT/_Mam_Studio_Kit"; fi
for d in "$CLAUDE_HOME/skills" "$MEMDIR" "$CLAUDE_HOME"; do
  [ -n "$d" ] && [ -d "$d" ] || continue
  for b in "$d"/.backup-mam-studio-*; do if [ -d "$b" ]; then remove_empty_dirs "$b"; fi; done
done

if [ -s "$WORK/left" ]; then
  { echo "# Mam_Studio_Kit - so cai dat (phan con lai sau khi go). Dung uninstall.sh --all de go not."
    echo "version=$VERSION"; echo "date=$DATE"; echo "mode=$MODE"; echo "project=$PROJECT"; echo "memdir=$MEMDIR"
    awk -F'\t' -v OFS='\t' '{ for (i=1;i<=5;i++) if ($i=="-") $i=""; print }' "$WORK/left"; } > "$REC"
  echo "Xong. Con giu bo nho/tai nguyen; so van o $REC (go not: bash uninstall.sh --all)."
else
  rm -f "$REC"; echo "Xong. Da go het nhung gi bo cai dat."
fi

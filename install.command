#!/bin/bash
# macOS: bam dup file nay de cai. Neu bi chan: chuot phai > Open, hoac chay "bash install.sh" trong Terminal.
cd "$(dirname "$0")" || exit 1
bash ./install.sh "$@"
echo ""; read -r -p "Nhan Enter de dong cua so..." _

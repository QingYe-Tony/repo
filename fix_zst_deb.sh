#!/bin/zsh
DEBDIR="./debs"
TMP="./tmp_work"
mkdir -p "$TMP"
for f in "$DEBDIR"/*.deb; do
  if ar t "$f" 2>/dev/null | grep -q "control.tar.zst"; then
    echo "转换 zstd 包: $f"
    bn=$(basename "$f")
    cd "$TMP"
    rm -rf *
    ar x "../$f"
    zstd -d control.tar.zst
    gzip -c control.tar > control.tar.gz
    zstd -d data.tar.zst
    gzip -c data.tar > data.tar.gz
    ar -q "../$DEBDIR/fixed_$bn" debian-binary control.tar.gz data.tar.gz
    cd ..
    rm "$f"
  fi
done
rm -rf "$TMP"
echo "✅全部zstd‑deb转换完成"

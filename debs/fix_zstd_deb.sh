#!/bin/zsh
set -euo pipefail

OUT_DIR="./fixed"
mkdir -p "$OUT_DIR"

for deb in *.deb; do
  [[ -f "$deb" ]] || continue

  echo "Processing: $deb"
  mkdir -p _tmp
  cd _tmp
  ar x "../$deb"

  if [[ -f control.tar.zst ]]; then
    echo "  → Detect zstd control.tar.zst, converting to gzip..."
    zstd -d control.tar.zst
    rm -f control.tar.zst
    gzip control.tar
    # 重新打包，顺序必须：debian‑binary 放第一位
    ar rc "../$OUT_DIR/$deb" debian-binary control.tar.gz data.tar.*
  else
    echo "  → skip, no zstd"
    cp "../$deb" "../$OUT_DIR/$deb"
  fi

  cd ..
  rm -rf _tmp
done

echo ""
echo "✅全部处理完成，修复后的deb输出目录：$OUT_DIR"
echo "👉把 fixed/* 的deb复制回 debs，再执行 ./upload.sh"

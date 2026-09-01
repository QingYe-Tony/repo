#!/bin/bash
cd /Users/apple/repo/debs
TMP=/tmp/repack_batch
fixed=0
for f in *.deb; do
  if ar t "$f" 2>/dev/null | grep -q "\.zst"; then
    echo "处理: $f"
    rm -rf "$TMP" && mkdir -p "$TMP" && cd "$TMP"
    ar x "/Users/apple/repo/debs/$f" 2>/dev/null
    zstd -d -q *.zst 2>/dev/null
    if [ -f control.tar ] && [ -f data.tar ]; then
      xz -z control.tar data.tar
      rm -f "/Users/apple/repo/debs/$f"
      ar r "/Users/apple/repo/debs/$f" debian-binary control.tar.xz data.tar.xz
      echo "  OK"; fixed=$((fixed+1))
    else
      echo "  FAIL"
    fi
    cd /Users/apple/repo/debs
  fi
done
rm -rf "$TMP"
echo "=== 完成：成功 $fixed ==="
cd /Users/apple/repo && ./repo_update.sh

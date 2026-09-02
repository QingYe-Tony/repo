#!/bin/bash
mkdir -p fixed_debs
# 只遍历磁盘真实存在的*.deb
for deb in debs/*.deb; do
    [ -f "$deb" ] || continue
    echo "==== 处理 $deb ===="
    TMP=$(mktemp -d)
    dpkg-deb -x "$deb" "$TMP"
    dpkg-deb -e "$deb" "$TMP/DEBIAN"
    OUT="fixed_debs/$(basename "$deb")"
    dpkg-deb -b "$TMP" "$OUT"
    rm -rf "$TMP"
done
echo "完成，输出 fixed_debs"

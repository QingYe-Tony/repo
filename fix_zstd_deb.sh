#!/bin/bash
set -e

INPUT="debs/com.iosdump.appdata_2.7.1_iphoneos-arm64e.deb"
OUTPUT="debs/com.iosdump.appdata_2.7.1_iphoneos-arm64e_fixed.deb"

TMPDIR=$(mktemp -d)
echo "临时目录: $TMPDIR"

# macOS bsd‑ar 不支持 --output，cd进去解压
pushd "$TMPDIR" >/dev/null
ar x "../$INPUT"
popd >/dev/null

zstd -d "$TMPDIR/control.tar.zst" -o "$TMPDIR/control.tar"
rm -f "$TMPDIR/control.tar.zst"
gzip "$TMPDIR/control.tar"

DATA_FILES=("$TMPDIR"/data.tar.*)

ar rcs "$OUTPUT" \
    "$TMPDIR/debian-binary" \
    "$TMPDIR/control.tar.gz" \
    "${DATA_FILES[@]}"

rm -rf "$TMPDIR"
echo "✅已生成兼容deb：$OUTPUT"
echo "⚠️记得删除原来的zstd版本deb"

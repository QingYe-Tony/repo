#!/bin/zsh
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
DEBS_DIR="./debs"

for deb in "$DEBS_DIR"/*.deb; do
    [[ -f "$deb" ]] || continue
    echo "Processing: $deb"

    # 检测deb内部是否含有zst压缩包
    if ! 7z l "$deb" | grep -qE 'control\.tar\.zst|data\.tar\.zst'; then
        echo "  → no zstd inside, skip"
        continue
    fi

    TMP=$(mktemp -d)
    cp "$deb" "$TMP/orig.deb"
    cd "$TMP"

    # 解压deb ar归档
    ar x orig.deb

    # 解压zst，生成tar裸文件
    if [[ -f control.tar.zst ]]; then
        zstd -d control.tar.zst
        gzip -n -f control.tar
        rm -f control.tar.zst
    fi
    if [[ -f data.tar.zst ]]; then
        zstd -d data.tar.zst
        gzip -n -f data.tar
        rm -f data.tar.zst
    fi

    # 重建deb
    ar cr new.deb debian-binary control.tar.gz data.tar.gz
    cd - >/dev/null

    cp "$TMP/new.deb" "$deb"
    rm -rf "$TMP"
done

echo "✅ Done: zstd‑inside debs repacked, normal debs skipped"

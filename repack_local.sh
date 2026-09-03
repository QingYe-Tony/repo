#!/bin/zsh
# 删掉set‑e，遇到坏包跳过继续处理其它包
DEB_IN_DIR="./debs"
OUT_DIR="./fixed_debs"

mkdir -p "$OUT_DIR"

for debfile in "$DEB_IN_DIR"/*.deb; do
    [[ -f "$debfile" ]] || continue
    echo "==== 处理: $debfile ===="
    BN=$(basename "$debfile")
    TMPDIR=$(mktemp -d)

    # Mac ar不支持--output，切换目录解压
    cd "$TMPDIR"
    if ! ar x "$debfile"; then
        echo "!!! $debfile ar解压失败，跳过该包"
        rm -rf "$TMPDIR"
        cd - >/dev/null
        continue
    fi
    cd - >/dev/null

    mkdir -p "$TMPDIR/data"
    if [[ -f "$TMPDIR/data.tar.zst" ]]; then
        tar --zstd -xf "$TMPDIR/data.tar.zst" -C "$TMPDIR/data"
    elif [[ -f "$TMPDIR/data.tar.xz" ]]; then
        tar -Jxf "$TMPDIR/data.tar.xz" -C "$TMPDIR/data"
    elif [[ -f "$TMPDIR/data.tar.gz" ]]; then
        tar -zxf "$TMPDIR/data.tar.gz" -C "$TMPDIR/data"
    fi

    mkdir -p "$TMPDIR/control"
    if [[ -f "$TMPDIR/control.tar.zst" ]]; then
        tar --zstd -xf "$TMPDIR/control.tar.zst" -C "$TMPDIR/control"
    elif [[ -f "$TMPDIR/control.tar.xz" ]]; then
        tar -Jxf "$TMPDIR/control.tar.xz" -C "$TMPDIR/control"
    elif [[ -f "$TMPDIR/control.tar.gz" ]]; then
        tar -zxf "$TMPDIR/control.tar.gz" -C "$TMPDIR/control"
    fi

    BUILD="$TMPDIR/build"
    mkdir -p "$BUILD"
    cp -r "$TMPDIR/data"/* "$BUILD/"
    mkdir -p "$BUILD/DEBIAN"
    cp "$TMPDIR/control"/* "$BUILD/DEBIAN/"

    dpkg-deb -Zxz -b "$BUILD" "$OUT_DIR/$BN"

    rm -rf "$TMPDIR"
done

cp "$OUT_DIR"/*.deb "$DEB_IN_DIR"/

dpkg-scanpackages -m "$DEB_IN_DIR" /dev/null > Packages
gzip -k -f Packages

rm -rf fixed_debs

git add debs/ Packages Packages.gz
git commit -m "local repack fix zstd deb"
git push origin master

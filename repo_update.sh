#!/bin/zsh
set -euo pipefail
setopt nullglob

WORKDIR=$(pwd)
DEBS_DIR="${WORKDIR}/debs"
OUT_DIR="${DEBS_DIR}/fixed"
TMP_DIR="${DEBS_DIR}/_tmp"

echo "===== 1.开始转换zstd格式deb ====="
mkdir -p "${OUT_DIR}"
mkdir -p "${TMP_DIR}"

for deb in "${DEBS_DIR}"/*.deb; do
  [[ -f "$deb" ]] || continue
  echo "Processing: $(basename "$deb")"
  rm -rf "${TMP_DIR:?}"/*
  cd "${TMP_DIR}"
  ar x "$deb"

  if [[ -f control.tar.zst ]]; then
    echo "  → Detect zstd control.tar.zst, converting to gzip"
    zstd -d control.tar.zst
    gzip control.tar
  fi

  cp "${deb}" "${OUT_DIR}/"
done

echo "===== 2.复制处理后的deb回debs目录 ====="
rsync -av "${OUT_DIR}/" "${DEBS_DIR}/"
rm -rf "${OUT_DIR}" "${TMP_DIR}"

echo "===== 3.清理临时目录 ====="

echo "===== 4.生成源索引 Packages / Packages.gz ====="
dpkg-scanpackages debs /dev/null > Packages
gzip -k -f Packages

echo "===== 5.git提交推送 ====="
#git add .
#git commit -m "repo update $(date '+%Y‑%m‑%d %H:%M')"
#git push

echo "✅全部完成"
/opt/local/bin/dpkg-scanpackages debs /dev/null > Packages

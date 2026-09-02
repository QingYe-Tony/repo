#!/bin/zsh
rm -f Packages Packages.gz Packages.bz2 Release

dpkg‑scanpackages -m ./debs /dev/null > Packages
gzip -c9 Packages > Packages.gz
bzip2 -c9 Packages > Packages.bz2

cat > Release <<'EOF'
Origin: 清野
Label: 清野
Suite: stable
Codename: ios
Architectures: iphoneos‑arm64
Components: main
Description: 清野越狱源 | 支持有根、无根、隐根插件
EOF

echo "MD5Sum:" >> Release
for f in Packages Packages.gz Packages.bz2; do
  hash=$(md5 -r "$f" | awk '{print $1}')
  size=$(stat -f%z "$f")
  echo " $hash $size $f" >> Release
done

echo "SHA256Sum:" >> Release
for f in Packages Packages.gz Packages.bz2; do
  hash=$(shasum -a 256 "$f" | awk '{print $1}')
  size=$(stat -f%z "$f")
  echo " $hash $size $f" >> Release
done

git add .
git commit -m "repo更新"
git push
echo "✅推送完成，请等待2‑3分钟CDN缓存后手机再操作"

#!/bin/zsh
echo "=== 清野源 更新索引开始 ==="

# 扫描debs文件夹生成Packages
dpkg-scanpackages -m debs /dev/null > Packages

# 生成压缩包
gzip -k -f Packages

# 生成Release文件
cat > Release <<ENDREL
Origin: 清野
Label: 清野
Suite: stable
Codename: ios
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: main
Description: 清野软件源
ENDREL

# git提交推送
git add debs Packages Packages.gz Release
git commit -m "自动脚本：更新软件源索引"
git push

echo "=== 推送完成！等待GitHub Pages 2‑5分钟生效 ==="
echo "源地址：https://qingye-tony.github.io/repo/"

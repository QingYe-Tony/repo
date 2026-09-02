#!/bin/zsh
if [ ! -d "./debs" ];then
    echo "❌ 必须在repo根目录运行"
    exit 1
fi

echo "🔨 生成Packages索引（保留多版本）"
dpkg‑scanpackages -m debs /dev/null > Packages

echo "📦 压缩索引文件"
gzip -k -f Packages
bzip2 -k -f Packages

echo "📤 git提交推送"
git add .
git commit -m "add new tweaks && update index"
git push

echo "✅ 全部完成，等待GitHub Pages部署"

#!/bin/zsh
# 清理旧索引
rm -f Packages Packages.bz2 Packages.gz
# 扫描deb生成包列表
dpkg-scanpackages debs /dev/null > Packages
# 生成压缩索引（Cydia/Sileo必需）
bzip2 -k Packages
gzip -k Packages

# ========== Release 文件内容，自行修改下面信息 ==========
cat > Release << EOF
Origin: 清野
Label: 清野
Suite: stable
Codename: ios
Architectures: iphoneos-arm64 iphoneos-arm
Components: main
Description: 在这里填写仓库简介
EOF

echo "✅ 源索引更新完成！可以上传GitHub"

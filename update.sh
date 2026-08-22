#!/bin/zsh
# 清理旧索引
rm -f Packages Packages.bz2 Packages.gz

# 多目录扫描，拼接所有deb包（debs/v1、debs/v2）
rm -f Packages
dpkg-scanpackages debs/v1 /dev/null >> Packages
dpkg-scanpackages debs/v2 /dev/null >> Packages

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
Description: 个人测试插件源，仅供学习使用
EOF

echo "✅ 源索引更新完成！可以上传GitHub"
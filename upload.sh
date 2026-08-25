#!/bin/zsh
source ~/.zshrc
cd ~/repo
# 扫描deb生成原始Packages索引
dpkg‑scanpackages -m debs /dev/null > Packages
# 追加命令：强制覆盖生成压缩包，保留原Packages
gzip -k -f Packages
# git提交全部改动
git add .
git commit -m "更新源"
git push origin master
#!/bin/zsh
cd ~/repo
# 使用MacPorts完整绝对路径，彻底避开PATH问题
/opt/local/bin/dpkg-scanpackages -m debs /dev/null > Packages
gzip -k -f Packages
git add .
git commit -m "更新源"
git push origin master
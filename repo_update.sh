#!/bin/bash
echo "=== 清野源 更新索引开始 ==="
dpkg-scanpackages -m debs /dev/null > Packages_raw
awk 'BEGIN{RS="";FS="\n"}{pkg="";ver="";arch="";for(i=1;i<=NF;i++){if($i~/^Package: /)pkg=substr($i,10);if($i~/^Version: /)ver=substr($i,10);if($i~/^Architecture: /)arch=substr($i,15)}key=pkg"|"ver;score=0;if(arch=="iphoneos-arm64")score=3;else if(arch=="iphoneos-arm64e")score=2;else if(arch=="iphoneos-arm")score=1;if(!(key in best)||score>best[key]){best[key]=score;data[key]=$0}}END{for(k in data)print data[k]"\n"}' Packages_raw > Packages
rm -f Packages_raw
gzip -k -f Packages
cat > Release <<ENDREL
Origin: 清野
Label: 清野
Suite: stable
Codename: ios
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: main
Description: 清野软件源
ENDREL
git add debs Packages Packages.gz Release
git commit -m "自动脚本：更新软件源索引"
git push
echo "=== 推送完成！等待 GitHub Pages 2-5分钟生效 ==="
echo "源地址：https://qingye-tony.github.io/repo/"

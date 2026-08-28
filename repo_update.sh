#!/bin/bash
echo "=== 清野源 更新索引开始 ==="
dpkg-scanpackages -m debs /dev/null > Packages_raw
perl -00 -ne '
/^Package: (.+)$/m; $pkg=$1;
/^Version: (.+)$/m; $ver=$1;
/^Architecture: (.+)$/m; $arch=$1;
$key="$pkg\t$ver";
$score=($arch eq "iphoneos-arm64")?3:($arch eq "iphoneos-arm64e")?2:($arch eq "iphoneos-arm")?1:0;
if(!exists($best{$key}) || $score>$best{$key}){$best{$key}=$score;$data{$key}=$_}
END{foreach(sort keys %data){print "$data{$_}\n"}}
' Packages_raw > Packages
rm -f Packages_raw
gzip -k -f Packages
rm -f Packages.zst
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

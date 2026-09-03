#!/bin/zsh
cd "$(dirname "$0")"

echo "=== 提交新增deb到debs文件夹 ==="
git add debs/*.deb
git status

read "msg?提交备注(回车默认add tweak): "
[[ -z $msg ]] && msg="add new tweak"

git commit -m "$msg"
git push

echo ""
echo "✅deb已经推送到GitHub！"
echo "👉打开浏览器进入仓库 Actions"
echo "👉找到最新 Build Cydia Repo，下载 repo‑index‑files.zip"
echo "👉解压，网页上传3个索引文件到仓库根目录覆盖旧文件"
echo "👉等待Pages部署，手机删除源重新添加"

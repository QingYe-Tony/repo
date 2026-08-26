#!/bin/zsh
rm -f Packages Packages.gz Release
/opt/local/bin/dpkg-scanpackages debs /dev/null > Packages
gzip -k -f Packages

cat > Release <<'REL'
Origin: MyRepo
Label: MyRepo
Suite: stable
Codename: main
Architectures: iphoneos-arm iphoneos-arm64 iphoneos-arm64e
Components: main
Description: My Cydia Repo
REL

git add Packages Packages.gz Release
git commit -m "repo update $(date '+%Y-%m-%d %H:%M')"
git push
ls -lh Packages Packages.gz Release

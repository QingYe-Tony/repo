#!/bin/zsh
source ~/.zshrc
cd ~/repo
dpkg-scanpackages -m debs /dev/null > Packages
git add .
git commit -m "更新源"
git push origin master
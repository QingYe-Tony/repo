#!/usr/bin/env python3
import os, hashlib

def calc_hash(fpath):
    with open(fpath,'rb') as f:
        d = f.read()
    return {
        'MD5Sum': hashlib.md5(d).hexdigest(),
        'SHA1': hashlib.sha1(d).hexdigest(),
        'SHA256': hashlib.sha256(d).hexdigest(),
        'size': str(len(d))
    }

file_list = ["Packages","Packages.gz","Packages.bz2","news.xml"]

lines = []
lines.append("Origin: 清野")
lines.append("Label: 清野")
lines.append("Suite: stable")
lines.append("Codename: ios")
lines.append("Components: main")
lines.append("Description: 清野越狱源 | 支持有根、无根、隐根插件")
lines.append("")

lines.append("MD5Sum:")
for fn in file_list:
    if os.path.exists(fn):
        h = calc_hash(fn)
        lines.append(f" {h['MD5Sum']} {h['size']} {fn}")

lines.append("SHA1:")
for fn in file_list:
    if os.path.exists(fn):
        h = calc_hash(fn)
        lines.append(f" {h['SHA1']} {h['size']} {fn}")

lines.append("SHA256:")
for fn in file_list:
    if os.path.exists(fn):
        h = calc_hash(fn)
        lines.append(f" {h['SHA256']} {h['size']} {fn}")

with open("Release","w",encoding="utf-8") as f:
    f.write("\n".join(lines))

print("✅ Release 生成完成")

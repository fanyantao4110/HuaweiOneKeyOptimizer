#!/usr/bin/env python3
"""扫某个 smali 文件引用到的类型里，哪些是本机框架和 launcher 自身都没有的。"""
import re
import sys

OWN = "/storage/emulated/0/Download/own43.txt"
FW = "/storage/emulated/0/Download/fw_types.txt"


def main(path):
    with open(OWN, encoding="utf-8") as f:
        own = set(f.read().split())
    with open(FW, encoding="utf-8") as f:
        fw = set(f.read().split())
    with open(path, encoding="utf-8", errors="ignore") as f:
        src = f.read()
    refs = set(re.findall(r"L[A-Za-z0-9/$\_]+;", src))
    miss = sorted(r for r in refs if r.startswith("Lcom/huawei/") and r not in fw and r not in own)
    print(path)
    print("缺失依赖:", miss if miss else "无")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        main(p)

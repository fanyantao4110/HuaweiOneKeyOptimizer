#!/usr/bin/env python3
# aar_resolve.py —— 不依赖 gradle/maven：直接按 POM 递归下载 AAR/JAR
# 输出：
#   build/m2/...            下载缓存
#   build/libs/*.jar        所有 classes.jar / jar（javac + d8 用）
#   build/aarres/<x>/res    各库的 res 目录（aapt2 compile 用）
import os
import re
import shutil
import sys
import urllib.request
import xml.etree.ElementTree as ET
import zipfile
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "build")
CACHE = os.path.join(ROOT, "m2")
LIBS = os.path.join(ROOT, "libs")
RESROOT = os.path.join(ROOT, "aarres")
REPOS = [
    # 国内镜像优先（阿里云 google 镜像含 androidx / material，速度最快）
    "https://maven.aliyun.com/repository/google",
    "https://maven.aliyun.com/repository/central",
    "https://maven.aliyun.com/repository/public",
    # 兜底
    "https://dl.google.com/dl/android/maven2",
    "https://repo1.maven.org/maven2",
]
SEED = [("com.google.android.material", "material", "1.11.0")]

SKIP_SCOPE = {"test", "provided", "system"}
UA = {"User-Agent": "onekey-build"}


def fetch(url, timeout=90):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def download(url, path):
    if os.path.exists(path) and os.path.getsize(path) > 0:
        return True
    try:
        data = fetch(url)
    except Exception:
        return False
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        f.write(data)
    return True


def art_path(g, a, v, ext):
    return "%s/%s/%s/%s-%s.%s" % (g.replace(".", "/"), a, v, a, v, ext)


def get_pom(g, a, v):
    rel = art_path(g, a, v, "pom")
    dst = os.path.join(CACHE, rel)
    for repo in REPOS:
        if download(repo + "/" + rel, dst):
            try:
                return ET.parse(dst).getroot(), dst
            except Exception:
                continue
    return None, None


def strip_ns(root):
    for el in root.iter():
        if "}" in el.tag:
            el.tag = el.tag.split("}", 1)[1]
    return root


def text(el, tag, default=None):
    e = el.find(tag)
    return e.text.strip() if e is not None and e.text else default


def ver_key(v):
    parts = re.split(r"[.\-_]", v)
    out = []
    for p in parts:
        if p.isdigit():
            out.append((1, int(p), ""))
        else:
            m = re.match(r"^(\d+)(.*)$", p)
            if m:
                out.append((1, int(m.group(1)), m.group(2)))
            else:
                out.append((0, 0, p))
    return out


def walk(seed, best=None, collect_best=None):
    """BFS 解析依赖。best 给定时用统一版本替换（冲突消解）。"""
    seen = set()
    queue = list(seed)
    arts = []
    while queue:
        g, a, v = queue.pop(0)
        if best is not None and (g, a) in best and best[(g, a)] != v:
            v = best[(g, a)]
        key = (g, a, v)
        if key in seen:
            continue
        seen.add(key)
        if collect_best is not None:
            cur = collect_best.get((g, a))
            if cur is None or ver_key(v) > ver_key(cur):
                collect_best[(g, a)] = v
        root, pomfile = get_pom(g, a, v)
        if root is None:
            print("  ! POM 缺失: %s:%s:%s" % key)
            arts.append(key)
            continue
        root = strip_ns(root)
        props = {}
        pe = root.find("properties")
        if pe is not None:
            for c in pe:
                if c.tag and c.text:
                    props[c.tag] = c.text.strip()
        props.setdefault("project.version", v)
        props.setdefault("project.groupId", g)
        props.setdefault("version", v)

        def sub(s):
            if s is None:
                return s
            for k, val in props.items():
                s = s.replace("${%s}" % k, val)
            return s

        deps = []
        de = root.find("dependencies")
        if de is not None:
            for d in de.findall("dependency"):
                dg = sub(text(d, "groupId"))
                da = sub(text(d, "artifactId"))
                dv = sub(text(d, "version"))
                scope = text(d, "scope", "compile")
                opt = text(d, "optional", "false")
                if not dg or not da or not dv:
                    continue
                if scope in SKIP_SCOPE or opt == "true":
                    continue
                if "${" in dv:
                    continue
                deps.append((dg, da, dv))
        arts.append(key)
        print("%s:%s:%s  (+%d deps)" % (g, a, v, len(deps)))
        for d in deps:
            queue.append(d)
    return arts


def resolve():
    print("-- pass1: 收集版本 --")
    best = {}
    walk(SEED, best=None, collect_best=best)
    print("-- pass2: 按统一版本展开 (%d 个坐标) --" % len(best))
    arts = walk(SEED, best=best)
    # 去重并按 group:artifact 唯一
    final = {}
    for g, a, v in arts:
        final[(g, a)] = best.get((g, a), v)
    # kotlin-stdlib-jdk7/jdk8 从 1.8 起已并入 kotlin-stdlib，同时保留会重复类（d8 会报 defined multiple times）
    for key in list(final):
        if key[1] in ("kotlin-stdlib-jdk7", "kotlin-stdlib-jdk8"):
            del final[key]
    return [(g, a, v) for (g, a), v in sorted(final.items())]


def unpack_one(gav):
    g, a, v = gav
    name = "%s-%s" % (a, v)
    jar = None
    resdir = None
    pkg = None
    for ext in ("aar", "jar"):
        rel = art_path(g, a, v, ext)
        dst = os.path.join(CACHE, rel)
        got = False
        for repo in REPOS:
            if download(repo + "/" + rel, dst):
                got = True
                break
        if not got:
            continue
        if ext == "aar":
            try:
                with zipfile.ZipFile(dst) as z:
                    names = z.namelist()
                    if "classes.jar" in names:
                        out = os.path.join(LIBS, name + ".jar")
                        with z.open("classes.jar") as src, open(out, "wb") as f:
                            shutil.copyfileobj(src, f)
                        jar = out
                    if "AndroidManifest.xml" in names:
                        raw = z.read("AndroidManifest.xml").decode("utf-8", "ignore")
                        m = re.search(r'package="([^"]+)"', raw)
                        if m:
                            pkg = m.group(1)
                    target = os.path.join(RESROOT, name, "res")
                    if any(n.startswith("res/") for n in names):
                        if os.path.isdir(target):
                            shutil.rmtree(target)
                        for n in names:
                            if n.startswith("res/") and not n.endswith("/"):
                                zp = os.path.join(os.path.dirname(target), n)
                                os.makedirs(os.path.dirname(zp), exist_ok=True)
                                with z.open(n) as src, open(zp, "wb") as f:
                                    shutil.copyfileobj(src, f)
                        resdir = target
            except Exception as e:
                print("  ! 解包失败 %s: %s" % (dst, e))
        else:
            out = os.path.join(LIBS, "%s-%s.jar" % (a, v))
            if not os.path.exists(out):
                shutil.copyfile(dst, out)
            jar = out
        break
    if jar is None:
        print("  ! 产物缺失: %s:%s:%s" % (g, a, v))
    return jar, resdir, pkg


def unpack(artifacts):
    os.makedirs(LIBS, exist_ok=True)
    os.makedirs(RESROOT, exist_ok=True)
    jars, ress, pkgs = [], [], []
    with ThreadPoolExecutor(max_workers=8) as ex:
        for jar, resdir, pkg in ex.map(unpack_one, artifacts):
            if jar:
                jars.append(jar)
            if resdir:
                ress.append(resdir)
                if pkg:
                    pkgs.append(pkg)
    return jars, ress, sorted(set(pkgs))


if __name__ == "__main__":
    print("== 解析依赖 ==")
    arts = resolve()
    print("== 下载产物 (%d 个坐标) ==" % len(arts))
    jars, ress, pkgs = unpack(arts)
    print("== 结果 ==")
    print("jars: %d" % len(jars))
    print("res dirs: %d" % len(ress))
    print("r packages: %d" % len(pkgs))
    total = sum(os.path.getsize(j) for j in jars)
    print("classes 总大小: %.1f MB" % (total / 1048576.0))
    with open(os.path.join(ROOT, "libs.txt"), "w") as f:
        f.write("\n".join(jars) + "\n")
    with open(os.path.join(ROOT, "aarres.txt"), "w") as f:
        f.write("\n".join(ress) + "\n")
    with open(os.path.join(ROOT, "rpackages.txt"), "w") as f:
        f.write("\n".join(pkgs) + "\n")
#!/usr/bin/env python3
"""从 aliyun 镜像递归拉 maven 依赖（.aar/.jar）+ 解析 POM 传递依赖。
androidx/com.google → google 仓；其余 → central 仓。"""
import os, re, sys, subprocess, urllib.parse

MIRRORS = ["https://maven.aliyun.com/repository/google",
           "https://maven.aliyun.com/repository/central"]
OUT = "/workspace/fdm-app/libs"
CACHE = "/workspace/fdm-app/work/m2"

def get(url, dest):
    if os.path.exists(dest) and os.path.getsize(dest) > 0:
        return True
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    r = subprocess.run(["curl", "-fsSL", "--max-time", "90", "-o", dest, url],
                       capture_output=True)
    if r.returncode != 0:
        if os.path.exists(dest):
            os.remove(dest)
        return False
    return True

def fetch_any(group, artifact, version, ext):
    path = "%s/%s/%s/%s-%s.%s" % (group.replace(".", "/"), artifact, version, artifact, version, ext)
    for m in MIRRORS:
        dest = os.path.join(CACHE, path)
        if get(m + "/" + path, dest):
            return dest
    return None

def latest_stable(group, artifact):
    path = "%s/%s/maven-metadata.xml" % (group.replace(".", "/"), artifact)
    for m in MIRRORS:
        dest = os.path.join(CACHE, path)
        if get(m + "/" + path, dest):
            s = open(dest, encoding="utf-8").read()
            vs = re.findall(r"<version>([^<]+)</version>", s)
            good = [v for v in vs if not re.search(r"alpha|beta|rc|dev|snapshot", v, re.I)]
            return good[-1] if good else (vs[-1] if vs else None)
    return None

DEP_RE = re.compile(r"<dependency>(.*?)</dependency>", re.S)
def parse_pom(pom_path):
    if not pom_path or not os.path.exists(pom_path):
        return []
    s = open(pom_path, encoding="utf-8", errors="ignore").read()
    deps = []
    for blk in DEP_RE.findall(s):
        def g(t):
            m = re.search(r"<%s>([^<]+)</%s>" % (t, t), blk)
            return m.group(1).strip() if m else None
        scope, opt = g("scope"), g("optional")
        if scope in ("test", "provided") or opt == "true":
            continue
        gg, aa, vv = g("groupId"), g("artifactId"), g("version")
        if not (gg and aa and vv):
            continue
        if "${" in (vv or ""):
            continue
        deps.append((gg, aa, vv))
    return deps

SKIP = re.compile(r"(-lint$|-test$|-test-|-test-manifest|junit|espresso)")
def resolve(roots, pins=None):
    pins = pins or {}
    seen, queue, got = set(), list(roots), []
    while queue:
        g, a, v = queue.pop(0)
        if (g, a) in seen:
            continue
        seen.add((g, a))
        if SKIP.search(a):
            continue
        if a in pins:
            v = pins[a]
        pom = fetch_any(g, a, v, "pom")
        art = fetch_any(g, a, v, "aar") or fetch_any(g, a, v, "jar")
        if art:
            got.append((g, a, v, art))
            dest = os.path.join(OUT, os.path.basename(art))
            if not os.path.exists(dest):
                subprocess.run(["cp", art, dest])
        for d in parse_pom(pom):
            if (d[0], d[1]) not in seen:
                queue.append(d)
    return got

def compose_pins(pom_path):
    """material3 的 POM 里声明的 compose 版本 = 官方测过的组合，照它钉住"""
    pins = {}
    if not pom_path or not os.path.exists(pom_path):
        return pins
    s = open(pom_path, encoding="utf-8", errors="ignore").read()
    for blk in DEP_RE.findall(s):
        g = re.search(r"<groupId>([^<]+)</groupId>", blk)
        a = re.search(r"<artifactId>([^<]+)</artifactId>", blk)
        v = re.search(r"<version>([^<]+)</version>", blk)
        if g and a and v and g.group(1).startswith("androidx.compose"):
            pins[a.group(1)] = v.group(1)
    return pins


if __name__ == "__main__":
    roots = []
    for spec in sys.argv[1:]:
        g, a = spec.split(":")
        v = latest_stable(g, a)
        if not v:
            print("  ✗ 找不到版本:", spec); continue
        print("  %-42s %s" % (spec, v))
        roots.append((g, a, v))
    m3 = fetch_any("androidx.compose.material3", "material3", roots[0][2], "pom") if roots else None
    pins = compose_pins(m3)
    if pins:
        print("\n  按 material3 钉住版本：" + ", ".join("%s=%s" % kv for kv in sorted(pins.items())[:8]) + " …")
    got = resolve(roots, pins)
    print("\n共拉到 %d 个产物 → %s" % (len(got), OUT))
    for g, a, v, p in sorted(got, key=lambda x: x[1]):
        print("   %-40s %s" % (a, v))

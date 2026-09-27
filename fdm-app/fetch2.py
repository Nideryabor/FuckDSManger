#!/usr/bin/env python3
"""按 compose-bom 对齐版本，拉一份【干净】的依赖清单（只要 android 变体）"""
import os, re, subprocess
M = ["https://maven.aliyun.com/repository/google", "https://maven.aliyun.com/repository/central"]
CACHE = "/workspace/fdm-app/work/m2"; OUT = "/workspace/fdm-app/libs"
BOM = "2026.09.00"

def curl(path, dest):
    if os.path.exists(dest) and os.path.getsize(dest) > 0: return True
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    for m in M:
        r = subprocess.run(["curl","-fsSL","--max-time","30","-o",dest, m+"/"+path], capture_output=True)
        if r.returncode == 0 and os.path.getsize(dest) > 0: return True
        if os.path.exists(dest): os.remove(dest)
    return False

def bom_versions():
    p = "androidx/compose/compose-bom/%s/compose-bom-%s.pom" % (BOM, BOM)
    d = os.path.join(CACHE, p)
    if not curl(p, d): print("  ⚠️ BOM 拿不到"); return {}
    s = open(d, encoding="utf-8", errors="ignore").read()
    out = {}
    for blk in re.findall(r"<dependency>(.*?)</dependency>", s, re.S):
        g = re.search(r"<groupId>([^<]+)", blk); a = re.search(r"<artifactId>([^<]+)", blk); v = re.search(r"<version>([^<]+)", blk)
        if g and a and v: out[g.group(1)+":"+a.group(1)] = v.group(1)
    return out

B = bom_versions()
print("  BOM %s 提供 %d 个 compose 构件" % (BOM, len(B)))
for k in ["androidx.compose.material3:material3","androidx.compose.ui:ui","androidx.compose.foundation:foundation","androidx.compose.runtime:runtime"]:
    print("    %-42s %s" % (k, B.get(k, "?")))

# 需要的东西（compose 的走 BOM 版本；其余外面单独定）
WANT = [
 ("androidx.compose.material3","material3-android"),
 ("androidx.compose.ui","ui-android"),
 ("androidx.compose.ui","ui-text-android"),
 ("androidx.compose.ui","ui-graphics-android"),
 ("androidx.compose.ui","ui-unit-android"),
 ("androidx.compose.ui","ui-geometry-android"),
 ("androidx.compose.foundation","foundation-android"),
 ("androidx.compose.foundation","foundation-layout-android"),
 ("androidx.compose.runtime","runtime-android"),
 ("androidx.compose.runtime","runtime-saveable-android"),
 ("androidx.compose.animation","animation-android"),
 ("androidx.compose.animation","animation-core-android"),
 ("androidx.compose.material","material-ripple-android"),
 ("androidx.compose.material","material-icons-core-android"),
 ("androidx.compose.material","material-icons-extended-android"),
 ("androidx.graphics","graphics-shapes-android"),
]
EXTRA = [
 ("androidx.activity","activity-compose","1.13.0"),
 ("androidx.activity","activity","1.13.0"),
 ("androidx.activity","activity-ktx","1.13.0"),
 ("androidx.lifecycle","lifecycle-runtime-android","2.9.4"),
 ("androidx.lifecycle","lifecycle-runtime-ktx-android","2.9.4"),
 ("androidx.lifecycle","lifecycle-viewmodel-android","2.9.4"),
 ("androidx.lifecycle","lifecycle-viewmodel-compose-android","2.9.4"),
 ("androidx.lifecycle","lifecycle-common","2.9.4"),
 ("androidx.savedstate","savedstate-android","1.3.1"),
 ("androidx.savedstate","savedstate-compose-android","1.3.1"),
 ("androidx.core","core","1.17.0"),
 ("androidx.core","core-ktx","1.17.0"),
 ("androidx.collection","collection-jvm","1.5.0"),
 ("androidx.annotation","annotation-jvm","1.9.1"),
 ("androidx.profileinstaller","profileinstaller","1.4.1"),
 ("org.jetbrains.kotlinx","kotlinx-coroutines-core-jvm","1.10.2"),
 ("org.jetbrains.kotlinx","kotlinx-coroutines-android","1.10.2"),
]

ok, fail = [], []
def grab(g, a, v):
    base = a.replace("-android","")
    v = B.get("%s:%s" % (g, base), B.get("%s:%s" % (g, a), v))
    if not v: v = "0"
    for ext in ("aar","jar"):
        path = "%s/%s/%s/%s-%s.%s" % (g.replace(".","/"), a, v, a, v, ext)
        d = os.path.join(CACHE, path)
        if curl(path, d):
            subprocess.run(["cp", d, os.path.join(OUT, os.path.basename(d))])
            ok.append("%-46s %s" % (a, v)); return
    fail.append("%s:%s:?" % (g, a))

for g, a in WANT: grab(g, a, None)
for g, a, v in EXTRA: grab(g, a, v)
print("\n  ✅ 拉到 %d 个：" % len(ok))
for x in sorted(ok): print("     " + x)
if fail:
    print("\n  ⚠️ 没拿到 %d 个：" % len(fail))
    for x in fail: print("     " + x)

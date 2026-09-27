#!/usr/bin/env python3
"""按 compose-bom 2026.09.00 对齐后的【明确清单】拉依赖，并逐个校验"""
import os, subprocess, zipfile, shutil
MIR = ["https://maven.aliyun.com/repository/google", "https://maven.aliyun.com/repository/central"]
OUT = "/workspace/fdm-app/libs"
WANT = [
 ("androidx.compose.material3","material3-android","1.4.0"),
 ("androidx.compose.ui","ui-android","1.12.1"),
 ("androidx.compose.ui","ui-text-android","1.12.1"),
 ("androidx.compose.ui","ui-graphics-android","1.12.1"),
 ("androidx.compose.ui","ui-unit-android","1.12.1"),
 ("androidx.compose.ui","ui-geometry-android","1.12.1"),
 ("androidx.compose.foundation","foundation-android","1.12.1"),
 ("androidx.compose.foundation","foundation-layout-android","1.12.1"),
 ("androidx.compose.runtime","runtime-android","1.12.1"),
 ("androidx.compose.runtime","runtime-saveable-android","1.12.1"),
 ("androidx.compose.animation","animation-android","1.12.1"),
 ("androidx.compose.animation","animation-core-android","1.12.1"),
 ("androidx.compose.material","material-ripple-android","1.12.1"),
 ("androidx.compose.material","material-icons-core-android","1.7.8"),
 ("androidx.compose.material","material-icons-extended-android","1.7.8"),
 ("androidx.graphics","graphics-shapes-android","1.1.0"),
 ("androidx.graphics","graphics-path","1.0.1"),
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
 ("androidx.navigationevent","navigationevent-android","1.0.0"),
 ("org.jetbrains.kotlinx","kotlinx-coroutines-core-jvm","1.10.2"),
 ("org.jetbrains.kotlinx","kotlinx-coroutines-android","1.10.2"),
]
shutil.rmtree(OUT, ignore_errors=True); os.makedirs(OUT)
ok, bad = [], []
for g,a,v in WANT:
    got = False
    for ext in ("aar","jar"):
        rel = "%s/%s/%s/%s-%s.%s" % (g.replace(".","/"), a, v, a, v, ext)
        dst = os.path.join(OUT, os.path.basename(rel))
        for m in MIR:
            r = subprocess.run(["curl","-fsSL","--max-time","40","-o",dst, m+"/"+rel], capture_output=True)
            if r.returncode == 0 and os.path.getsize(dst) > 1000:
                got = True; break
        if got: break
        if os.path.exists(dst): os.remove(dst)
    if not got:
        bad.append("%s:%s:%s" % (g,a,v)); continue
    # 校验是不是真 zip
    try:
        zipfile.ZipFile(dst).namelist()
        ok.append((a,v,os.path.getsize(dst)))
    except Exception as e:
        bad.append("%s:%s:%s (坏文件: %s)" % (g,a,v,e)); os.remove(dst)
print("  ✅ 拿到 %d 个" % len(ok))
for a,v,s in sorted(ok): print("     %-42s %-8s %7.2f MB" % (a,v,s/1e6))
if bad:
    print("\n  ⚠️ %d 个没拿到/坏了：" % len(bad))
    for b in bad: print("     "+b)

#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""FDM 方案A 全流程：POM 解析闭包 → 资源合并(0x7e) → R类 → Compose编译 → R8 → 组包 → 签名 → 备份"""
import os, re, sys, zipfile, subprocess, urllib.request, shutil
FD="/workspace/fdm-app"; AAPT="/workspace/tools/aapt2/aapt2_64"
AJAR="/workspace/tools/jvm/lib/android.jar"; STD="/workspace/tools/jvm/kotlinc/lib/kotlin-stdlib.jar"
BASES=["https://maven.aliyun.com/repository/google/","https://maven.aliyun.com/repository/public/"]
ROOTS=["androidx.compose.ui:ui-android:1.12.1","androidx.compose.foundation:foundation-android:1.12.1",
 "androidx.compose.material3:material3-android:1.4.0","androidx.compose.material3:material3-adaptive-android:1.1.0",
 "androidx.compose.runtime:runtime-android:1.12.1","androidx.activity:activity-compose:1.13.0",
 "androidx.lifecycle:lifecycle-runtime-android:2.9.4","androidx.core:core:1.19.1",
 "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2","androidx.graphics:graphics-shapes-android:1.0.1"]
os.makedirs(FD+"/libs_all",exist_ok=True)
def dl(c,ext):
    g,a,v=c.split(":"); dst="%s/libs_all/%s-%s.%s"%(FD,a,v,ext)
    if os.path.exists(dst) and os.path.getsize(dst)>0: return dst
    for b in BASES:
        try:
            urllib.request.urlretrieve(b+"%s/%s/%s/%s-%s.%s"%(g.replace('.','/'),a,v,a,v,ext),dst)
            if os.path.getsize(dst)>0: return dst
        except Exception: pass
    if os.path.exists(dst): os.remove(dst)
    return None
def deps(c):
    p=dl(c,"pom")
    if not p: return []
    t=open(p,encoding="utf-8",errors="ignore").read(); out=[]
    for m in re.finditer(r'<dependency>(.*?)</dependency>',t,re.S):
        b=m.group(1)
        def g(tag):
            mm=re.search(r'<%s>([^<]+)</%s>'%(tag,tag),b); return mm.group(1).strip() if mm else None
        gid,aid,ver,sc,opt=g('groupId'),g('artifactId'),g('version'),g('scope'),g('optional')
        if not(gid and aid and ver) or ver.startswith("$") or "SNAPSHOT" in ver: continue
        if sc in("test","provided","system") or opt=="true": continue
        out.append("%s:%s:%s"%(gid,aid,ver))
    return out
print("① 解析依赖闭包 ...")
seen=set(); q=list(ROOTS)
while q:
    c=q.pop(0)
    if c in seen: continue
    seen.add(c)
    for d in deps(c):
        if d not in seen: q.append(d)
print("   闭包 %d 个构件" % len(seen)); sys.stdout.flush()
arts=[]
for c in sorted(seen):
    an=c.split(":")[1]
    if an=="kotlin-stdlib": continue
    if re.search(r"tooling|test|debug|samples|lint|benchmark|ui-util-linux|notify", an): continue
    if os.path.exists("%s/libs/%s-%s.aar"%(FD,an,c.split(":")[2])): continue   # 已有就别下
    a=dl(c,"aar") or dl(c,"jar")
    if a: arts.append((c,a))
print("   下载到 %d 个" % len(arts))
print("② 处理 AAR（编 res + 抽 classes.jar）...")
RES=FD+"/work/res_all"; CLS=FD+"/work/cls_all"
shutil.rmtree(RES,ignore_errors=True); shutil.rmtree(CLS,ignore_errors=True)
os.makedirs(RES,exist_ok=True); os.makedirs(CLS,exist_ok=True)
nres=0; njar=0
for c,a in arts:
    name=os.path.basename(a).rsplit(".",1)[0]
    if a.endswith(".aar"):
        z=zipfile.ZipFile(a)
        if any(n.startswith("res/") for n in z.namelist()):
            d=RES+"/"+name; os.makedirs(d,exist_ok=True)
            for n in z.namelist():
                if n.startswith("res/"):
                    p=os.path.join(d,n); os.makedirs(os.path.dirname(p),exist_ok=True); open(p,"wb").write(z.read(n))
            if subprocess.run([AAPT,"compile","--dir",d+"/res","-o",RES+"/"+name+".zip","--legacy"],
                              capture_output=True).returncode==0: nres+=1
            shutil.rmtree(d,ignore_errors=True)
        if "classes.jar" in z.namelist():
            d=CLS+"/"+name; os.makedirs(d,exist_ok=True)
            open(d+"/classes.jar","wb").write(z.read("classes.jar")); njar+=1
    else: print("   跳过非 aar: %s" % name)
print("   编译资源 %d 个 / classes.jar %d 个" % (nres,njar))
print("③ link 资源（包 ID 0x7e）...")
mf=FD+"/work/AndroidManifest.xml"
open(mf,"w").write('<?xml version="1.0" encoding="utf-8"?>\n<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.nidyaber.fuckdsmanger" android:versionCode="452" android:versionName="2.22.121">\n<uses-sdk android:minSdkVersion="26" android:targetSdkVersion="34"/>\n<application android:label="FuckDSManger">\n<meta-data android:name="xposedmodule" android:value="true"/>\n<meta-data android:name="xposeddescription" android:value="FuckDSManger NL"/>\n<meta-data android:name="xposedminversion" android:value="82"/>\n</application>\n</manifest>\n')
shutil.rmtree(FD+"/work/rjava2",ignore_errors=True)
r=subprocess.run([AAPT,"link","-o",FD+"/pipeline/res3.apk","-I",AJAR,"--manifest",mf,"--java",FD+"/work/rjava2",
  "--output-text-symbols",FD+"/work/symbols3.txt","--min-sdk-version","26","--target-sdk-version","34",
  "--allow-reserved-package-id","--package-id","0x7e",FD+"/work/mine.zip"]+[RES+"/"+n for n in os.listdir(RES) if n.endswith(".zip")],
  capture_output=True,text=True)
print("   link rc=%d res3.apk=%s" % (r.returncode, os.path.exists(FD+"/pipeline/res3.apk")))
if r.returncode!=0:
    print("   " + "\n   ".join([l for l in r.stderr.splitlines() if "error" in l][:4])); sys.exit(1)
print("   ✅ 资源链完成")

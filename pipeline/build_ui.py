#!/usr/bin/env python3
"""
build_ui.py —— 从源码构建 Compose UI 的 APK（**可重放**）🐲

为什么要有它：FDM-UI-3.0 是昨天**手敲命令**堆出来的，脚本没落下来。
⇒ 想改一行 Kotlin 就得重来一遍手工流程 —— 那不可能"把 UI 真正做好"。

流水线：
  ① 收集 AAR（fdm-app/libs*，去重）
  ② 每个 AAR：aapt2 compile res → work/res/*.zip ；抽 classes.jar → work/cls/*.jar
  ③ aapt2 link（manifest + res）→ work/ui_base.apk + work/rjava（app R 源码）+ symbols.txt
  ④ R 类：
       · app R       → javac --release 8（★ 高版本 javac 会给内部类加 NestHost，单独 dex 会失败）
       · 各库 R      → tools/respipe/gen_r.py 按 **link 分配的真 ID** 生成
       · poolingcontainer R$id → **手工补 + 单独 D8 注入**（R8 会把它吃掉，-keep 也没用）
  ⑤ kotlinc（-Xplugin=compose-compiler-plugin.jar）
  ⑥ R8（--dontobfuscate，保住真名，方便日志）
  ⑦ 组包（dex + 资源 + **META-INF/services** ← 协程主调度器，丢过它一次，UI 第一帧就崩）
  ⑧ 签名

用法：
    python3 pipeline/build_ui.py --out out/FDM-UI.apk --version-code 473 --version-name 3.7.0
"""
import argparse
import re
import glob
import os
import shutil
import subprocess
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "mod-src", "pack"))
import dexinfo                                       # noqa: E402
FD = os.path.join(ROOT, "fdm-app")
WORK = os.path.join(FD, "work")
OUT = os.path.join(ROOT, "out")

AAPT2 = os.path.join(ROOT, "tools", "aapt2", "aapt2_64")
ANDROID_JAR = os.path.join(ROOT, "tools", "jvm", "lib", "android.jar")
R8_JAR = os.path.join(ROOT, "tools", "jvm", "lib", "r8.jar")
KOTLINC = os.path.join(ROOT, "tools", "jvm", "kotlinc")
KOTLIN_COMPILER = os.path.join(KOTLINC, "lib", "kotlin-compiler.jar")
COMPOSE_PLUGIN = os.path.join(KOTLINC, "lib", "compose-compiler-plugin.jar")
GEN_R = os.path.join(ROOT, "tools", "respipe", "gen_r.py")
PKG = "com.nidyaber.fuckdsmanger"

# ★ Kotlin 运行时：**必须进 dex**（不是只进 classpath）
#   它是 jar 不是 aar ⇒ 依赖闭包扫不到它；而 R8 的 `-dontwarn **` 让"缺 kotlin 类"
#   一路静默通过 ⇒ 打出一个父类缺失的包（实测：1102 个类缺父类，MainActivity 起不来）
KOTLIN_RUNTIME = [
    os.path.join(KOTLINC, "lib", "kotlin-stdlib.jar"),
    os.path.join(KOTLINC, "lib", "kotlinx-coroutines-core-jvm.jar"),
]

# ★ 闭包里没有、但确实被用到的 aar（缺了会父类缺失 / 引用缺失）
FORCE_AARS = ["navigationevent-android", "navigationevent-compose-android",
              "lifecycle-livedata-core", "window",
              "material-icons-core-android", "material-icons-extended-android",
              "graphics-path", "core-runtime", "tracing"]

# ★ 同样"闭包扫不到"的 jar（它们只发 jar）—— 必须进 dex，不只是 classpath
#   ⚠️ 只放**我们真的会用到**的：塞进可选的集成（如 kotlinx-coroutines-rx2/rx3）
#      反而会造出"父类 io.reactivex.Scheduler 缺失"，把干净包弄脏（实测栽过）
FORCE_JARS = ["lifecycle-common-jvm", "kotlinx-serialization-core-jvm",
              "collection-jvm",           # ← 51 个类型都指望它（SimpleArrayMap 就是这里崩的）
              "core-common",              # arch core 的 SafeIterableMap
              "window-core-jvm",
              "kotlinx-coroutines-android",
              "annotation-jvm", "concurrent-futures", "listenablefuture"]

MANIFEST = """<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="{pkg}" android:versionCode="{vc}" android:versionName="{vn}">
  <uses-sdk android:minSdkVersion="26" android:targetSdkVersion="34"/>
  <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
  <!-- android:debuggable：为了让国产 ROM 别吞应用的日志。
       实测 ColorOS 会把应用进程的 android.util.Log 全部丢掉（logcat 里一条 FDM-UI 都没有 ✗），
       只有系统认它是"可调试应用"（开发者选项里勾上）才会放行。
       这是**诊断必需**：没日志我等于瞎着修。 -->
  <application android:label="@string/app_name" android:theme="@style/AppTheme"
               android:icon="@drawable/ic_launcher" android:allowBackup="false"
               android:debuggable="true"
               android:forceQueryable="true">
    <activity android:name="com.nidyaber.fuckdsmanger.MainActivity" android:exported="true"
              android:configChanges="orientation|screenSize|keyboardHidden|uiMode">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
      <!-- ★ 「检查更新」换乘用的 scheme 通道（宿主进程 startActivity(fdm://open)）。
           宿主里点「检查更新」走的是 FdmUiHook：先试显式 ComponentName，
           这条 scheme 是兜底 —— 免得哪天包名/可见性出岔子时整条路哑掉。
           也能手测： adb shell am start -a android.intent.action.VIEW -d fdm://open -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="fdm"/>
      </intent-filter>
    </activity>
  </application>
</manifest>
"""


def say(s):
    print("\033[36m· %s\033[0m" % s, flush=True)


def ok(s):
    print("\033[32m✓ %s\033[0m" % s, flush=True)


def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    if r.returncode != 0:
        print("\033[31m✗ 命令失败：%s\033[0m" % " ".join(str(c) for c in cmd[:6]))
        print((r.stderr or r.stdout or "")[:3000])
        sys.exit(1)
    return r


def _norm_art(a):
    """'foundation-android' / 'annotation-jvm' → 'foundation' / 'annotation'
    （按构件族归并：同一库的 -android / -jvm 变体会定义同样的类，一起收会重复）"""
    for suf in ("-android", "-jvm"):
        if a.endswith(suf):
            return a[:-len(suf)]
    return a


def _ver_key(v):
    """版本号按数字段比（字符串比较会得出 "1.9.0" > "1.10.2" 这种错）"""
    import re as _re
    parts = _re.findall(r"\d+", v or "")
    return tuple(int(x) for x in parts) or (0,)


def _variant_rank(art):
    """真实类在 `-android` / `-jvm` 变体里；纯构件名往往只是 KMP 的元数据桩。

    实测：`kotlinx-coroutines-core-1.9.0.jar` 只有 135 KB（桩），
    真类在 `kotlinx-coroutines-core-jvm-*.jar` 里。
    """
    return 2 if (art.endswith("-android") or art.endswith("-jvm")) else 1


def dedupe_jars(paths):
    """同一构件族只留一个：**先看变体（-android/-jvm 优先），再按版本数字段比大小**。"""
    best = {}
    for p in paths:
        art, ver = _split_av(os.path.basename(p)[:-4])
        key = _norm_art(art)
        score = (_variant_rank(art), _ver_key(ver))
        if key not in best or score > best[key][0]:
            best[key] = (score, p)
    return sorted(v for _s, v in best.values())


def _split_av(name):
    """'animation-core-android-1.12.1' → ('animation-core-android', '1.12.1')"""
    import re as _re
    m = _re.match(r"^(.*?)-(\d[^-]*)$", name)
    return (m.group(1), m.group(2)) if m else (name, "")


# 不需要的构件（lint/tooling/test/samples 那些）
_SKIP = ("-lint", "tooling", "samples", "benchmark", "-test", "debug", "ui-util-linux",
         "notify")


def closure_wanted():
    """依赖闭包（以 `libs_all/*.pom` 为准）→ {构件名: [版本…]}"""
    wanted = {}
    for p in glob.glob(os.path.join(FD, "libs_all", "*.pom")):
        art, ver = _split_av(os.path.basename(p)[:-4])
        if any(s in art for s in _SKIP):
            continue
        wanted.setdefault(_norm_art(art), []).append(ver)
    return wanted


def collect_closure_jars():
    """闭包里「只发 jar」的构件（`androidx.collection` / `annotation-jvm` / `lifecycle-common`…）。

    ★ 这些**必须进 dex**，不能只挂 classpath —— 真机炸过：
      `NoClassDefFoundError: androidx.collection.SimpleArrayMap`
      （它是 `ComponentActivity.<init>` 方法体里用到的类型，跟"父类闭包"无关，最容易漏）。
    """
    wanted = closure_wanted()
    pool = {}
    for pat in (os.path.join(FD, "libs_extra", "*.jar"),
                os.path.join(WORK, "m2", "**", "*.jar")):
        for p in glob.glob(pat, recursive=True):
            b = os.path.basename(p)
            if any(s in b.lower() for s in ("-lint", "sources", "javadoc", "test",
                                            "samples", "benchmark", "debug")):
                continue
            art, ver = _split_av(b[:-4])
            pool.setdefault(_norm_art(art), {}).setdefault(ver, p)
    out = []
    for art, vers in sorted(wanted.items()):
        cand = pool.get(art)
        if not cand:
            continue
        pick = None
        for v in vers:
            if v in cand:
                pick = v
                break
        if pick is None:
            pick = sorted(cand.keys())[-1]
        out.append(cand[pick])
    return sorted(set(out))


def collect_aars():
    """按**依赖闭包**取 AAR，并按「构件族」匹配。

    两个坑：
      ① 直接遍历 libs*/ 全塞进去 ⇒ 混着老的 `support-*`，跟 androidx 抢同名资源（实测炸过）
      ② pom 叫 `animation-core-1.12.1`，AAR 却叫 `animation-core-android-1.12.1`（多个 -android）
         ⇒ 按名字精确匹配只能对上 26/259（实测炸过）
    """
    wanted = closure_wanted()
    avail = {}
    for d in ("libs", "libs_new", "libs_extra", "libs_legacy"):
        for p in sorted(glob.glob(os.path.join(FD, d, "*.aar"))):
            art, ver = _split_av(os.path.basename(p)[:-4])
            # ★ 按「去掉 -android 后的构件名」归并：否则 foundation 和 foundation-android
            #   会各匹配一次 ⇒ 同名资源冲突（实测炸过：androidx_compose_foundation_autofill）
            avail.setdefault(_norm_art(art), {}).setdefault(ver, {})[art] = p

    out, missing = [], []
    for art, vers in sorted(wanted.items()):
        cand = avail.get(art)
        if not cand:
            missing.append(art)
            continue
        pick = None
        for v in vers:                      # 优先闭包里点名的版本
            if v in cand:
                pick = v
                break
        if pick is None:
            pick = sorted(cand.keys())[-1]   # 否则取最高的
        variants = cand[pick]
        chosen = None
        for v, p in sorted(variants.items()):    # 优先 -android 变体
            if v.endswith("-android"):
                chosen = p
                break
        out.append(chosen or list(variants.values())[0])

    print("   闭包 %d 个构件 → 匹配到 AAR %d 个；缺 %d 个" % (len(wanted), len(out), len(missing)))
    if missing:
        print("   缺（跳过）：" + " ".join(missing[:10]))
    # 强制补上闭包里漏掉、但确实需要的
    have = set(out)
    allav = {}
    for d in ("libs", "libs_new", "libs_extra"):
        for p in sorted(glob.glob(os.path.join(FD, d, "*.aar"))):
            art, _v = _split_av(os.path.basename(p)[:-4])      # ★ 用「构件名」而不是带版本的文件名
            allav.setdefault(art, p)
    for name in FORCE_AARS:
        p = allav.get(name)
        if p and p not in have:
            out.append(p)
            print("   强制加入 %s" % os.path.basename(p))
    return out


def force_jars():
    """FORCE_JARS 那些「只发 jar」的依赖：从 libs_extra / work/m2 里挑最高版本。"""
    pool = {}
    for pat in (os.path.join(FD, "libs_extra", "*.jar"),
                os.path.join(WORK, "m2", "**", "*.jar")):
        for p in glob.glob(pat, recursive=True):
            art, ver = _split_av(os.path.basename(p)[:-4])
            if art in FORCE_JARS:
                pool.setdefault(art, {})[ver] = p
    out = []
    for art in FORCE_JARS:
        cand = pool.get(art)
        if not cand:
            print("   ⚠ 没找到强制 jar：%s" % art)
            continue
        pick = sorted(cand.keys())[-1]
        out.append(cand[pick])
        print("   强制 jar %s" % os.path.basename(cand[pick]))
    return out


def collect_jars():
    """只发 .jar 的依赖（annotation-jvm / collection-jvm / runtime-annotation…）。

    ★ 这些**只进编译期 classpath**，不进 dex：
      它们要么是注解、要么已经在别的 dex 里，塞进去只会多一份重复类。
    """
    out = []
    for pat in ("cp/*.jar", "m2/**/*.jar"):
        for p in glob.glob(os.path.join(WORK, pat), recursive=True):
            b = os.path.basename(p).lower()
            if any(s in b for s in ("-lint", "test", "samples", "debug", "benchmark")):
                continue
            out.append(p)
    return sorted(set(out))


def index_providers(paths):
    """{类描述符: 提供它的文件} —— 扫 jar 与 aar(里面的 classes.jar)。"""
    idx = {}
    for p in paths:
        try:
            if p.endswith(".aar"):
                z = zipfile.ZipFile(p)
                if "classes.jar" not in z.namelist():
                    continue
                import io as _io
                inner = zipfile.ZipFile(_io.BytesIO(z.read("classes.jar")))
                names = inner.namelist()
            else:
                names = zipfile.ZipFile(p).namelist()
        except Exception:
            continue
        for n in names:
            if n.endswith(".class"):
                idx.setdefault("L" + n[:-6] + ";", p)
    return idx


def is_r_class(desc):
    """R / R$id / R$string … 这类资源索引类（它们要绕开 R8，用 D8 注入）。"""
    import re as _re
    return bool(_re.search(r"/R(\$[A-Za-z0-9_]+)?;$", desc))


def heal_inputs(need, cls_dir, already):
    """为缺失的类找提供者：返回新增的、可直接喂给 R8 的 jar 列表。

    ★ 这是"不再打地鼠"的关键：R8 出完包先查「有没有引用了但不在包里的类」，
      再把提供它们的 jar/aar 补进输入，重跑一轮。最多几轮就收敛。
    """
    cands = []
    for d in ("libs", "libs_new", "libs_extra", "libs_legacy"):
        cands += glob.glob(os.path.join(FD, d, "*.aar"))
    cands += [p for p in glob.glob(os.path.join(WORK, "m2", "**", "*.jar"), recursive=True)
              if not any(s in os.path.basename(p).lower()
                         for s in ("lint", "test", "samples", "debug", "benchmark"))]
    cands += glob.glob(os.path.join(FD, "libs_extra", "*.jar"))
    idx = index_providers(cands)

    hit = {}
    for c in need:
        p = idx.get(c)
        if p:
            hit.setdefault(p, []).append(c)
    added = []
    for p, cls in sorted(hit.items(), key=lambda kv: -len(kv[1])):
        if p in already or p in added:
            continue
        if p.endswith(".aar"):                      # aar ⇒ 抽 classes.jar 进 inputs
            import io as _io
            z = zipfile.ZipFile(p)
            out = os.path.join(cls_dir, os.path.basename(p)[:-4] + ".jar")
            open(out, "wb").write(z.read("classes.jar"))
            added.append(out)
        else:
            added.append(p)
        print("   + 补依赖 %s（提供 %d 个缺失类）" % (os.path.basename(p), len(cls)))
    return added


def strip_icons(cls_dir):
    """把 `material-icons-extended` 裁成「只有用到的图标」。

    为什么必须这么做：它有 7000+ 图标类，整包喂给 R8 ⇒ 输入暴涨 ⇒
    在只有 2.5 GB 可用内存的机器上直接被杀（实测：R8 进程消失、输出为空、
    表现为"构建崩了"）。而 UI 其实只用 9 个图标。
    """
    ext = [p for p in glob.glob(os.path.join(cls_dir, "material-icons*.jar"))
           if "extended" in os.path.basename(p)]
    if not ext:
        return None
    src = ext[0]
    # ① 从编译出的 UI class 里找出真正用到的图标描述符
    need = set()
    for c in glob.glob(os.path.join(WORK, "b_appcls", "**", "*.class"), recursive=True):
        data = open(c, "rb").read()
        for m in re.finditer(rb"androidx/compose/material/icons/[A-Za-z0-9_/$]+", data):
            need.add(m.group().decode("ascii"))
    # ② 图标容器类（Icons / Icons$Rounded / Icons$AutoMirrored…）也要留
    need |= {"androidx/compose/material/icons/Icons",
             "androidx/compose/material/icons/Icons$Rounded",
             "androidx/compose/material/icons/Icons$Filled",
             "androidx/compose/material/icons/Icons$Outlined",
             "androidx/compose/material/icons/Icons$AutoMirrored",
             "androidx/compose/material/icons/Icons$AutoMirrored$Rounded",
             "androidx/compose/material/icons/IconsKt"}
    if not need:
        return None
    out = os.path.join(WORK, "b_icons_trim.jar")
    z = zipfile.ZipFile(src)
    kept = 0
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as o:
        for n in z.namelist():
            desc = n[:-6] if n.endswith(".class") else None
            if desc and (desc in need or desc.rsplit("$", 1)[0] in need):
                o.writestr(n, z.read(n))
                kept += 1
    print("   图标裁剪：%d 个类 → %d 个（extended 整包 %d 个）"
          % (len(need), kept, sum(1 for n in z.namelist() if n.endswith(".class"))))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--version-code", type=int, default=473)
    ap.add_argument("--version-name", default="3.7.0")
    a = ap.parse_args()

    os.makedirs(WORK, exist_ok=True)
    os.makedirs(OUT, exist_ok=True)

    # ---------------- ① AAR 清单 ----------------
    say("① 收集 AAR")
    aars = collect_aars()

    # ---------------- ② 编资源 + 抽 classes.jar ----------------
    say("② 处理 AAR（aapt2 compile res / 抽 classes.jar）")
    res_dir = os.path.join(WORK, "b_res")
    cls_dir = os.path.join(WORK, "b_cls")
    for d in (res_dir, cls_dir):
        shutil.rmtree(d, ignore_errors=True)
        os.makedirs(d)
    res_zips = []
    for p in aars:
        name = os.path.basename(p)[:-4]
        try:
            z = zipfile.ZipFile(p)
        except Exception as e:
            print("   跳过 %s (%s)" % (name, e))
            continue
        names = z.namelist()
        if any(n.startswith("res/") for n in names):
            d = os.path.join(res_dir, name)
            os.makedirs(d, exist_ok=True)
            for n in names:
                if n.startswith("res/") and not n.endswith("/"):
                    dst = os.path.join(d, n)
                    os.makedirs(os.path.dirname(dst), exist_ok=True)
                    open(dst, "wb").write(z.read(n))
            outz = os.path.join(res_dir, name + ".zip")
            r = subprocess.run([AAPT2, "compile", "--dir", os.path.join(d, "res"),
                                "-o", outz, "--legacy"], capture_output=True, text=True)
            if r.returncode == 0:
                res_zips.append(outz)
            else:
                print("   res 编译失败 %s：%s" % (name, (r.stderr or "")[:200]))
            shutil.rmtree(d, ignore_errors=True)
        if "classes.jar" in names:
            open(os.path.join(cls_dir, name + ".jar"), "wb").write(z.read("classes.jar"))
        # ★ AAR 里还能嵌 jar（`libs/*.jar`）—— 有的库把类放这儿而不是 classes.jar
        #   实测：tracing-1.3.0.aar 完全没有 classes.jar；emoji2 的 flatbuffer 类在 libs/repackaged.jar
        for n in names:
            if n.startswith("libs/") and n.endswith(".jar"):
                inner = name + "-" + os.path.basename(n)
                open(os.path.join(cls_dir, inner), "wb").write(z.read(n))
    ok("资源 zip %d 个 / classes.jar %d 个" % (len(res_zips), len(os.listdir(cls_dir))))

    # 我们自己的资源
    mine = os.path.join(WORK, "b_mine.zip")
    run([AAPT2, "compile", "--dir", os.path.join(FD, "res"), "-o", mine, "--legacy"])
    res_zips.append(mine)
    ok("自己的 res 编好（%d B）" % os.path.getsize(mine))

    # ---------------- ③ link ----------------
    say("③ aapt2 link（分配资源 ID + 出 base.apk + app R 源码）")
    mf = os.path.join(WORK, "b_manifest.xml")
    open(mf, "w", encoding="utf-8").write(
        MANIFEST.format(pkg=PKG, vc=a.version_code, vn=a.version_name))
    rjava = os.path.join(WORK, "b_rjava")
    shutil.rmtree(rjava, ignore_errors=True)
    symbols = os.path.join(WORK, "b_symbols.txt")
    base_apk = os.path.join(WORK, "b_base.apk")
    cmd = [AAPT2, "link", "-o", base_apk, "-I", ANDROID_JAR, "--manifest", mf,
           "--java", rjava, "--output-text-symbols", symbols,
           "--min-sdk-version", "26", "--target-sdk-version", "34"] + res_zips
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print("   " + "\n   ".join([l for l in (r.stderr or "").splitlines() if "error" in l][:6]))
        sys.exit("✗ aapt2 link 失败")
    ok("base.apk %d B · symbols %d 行" % (os.path.getsize(base_apk),
                                          sum(1 for _ in open(symbols))))

    # ---------------- ④ R 类 ----------------
    say("④ R 类（app R + 库 R + 手工 poolingcontainer R$id）")
    rcls = os.path.join(WORK, "b_rcls")
    shutil.rmtree(rcls, ignore_errors=True)
    os.makedirs(rcls)
    javas = []
    for root, _d, files in os.walk(rjava):
        javas += [os.path.join(root, f) for f in files if f.endswith(".java")]
    if javas:
        run(["javac", "--release", "8", "-nowarn", "-encoding", "UTF-8",
             "-classpath", ANDROID_JAR, "-d", rcls] + javas)
    ok("app R → %d 个 .class" % sum(len(f) for _r, _d, f in os.walk(rcls)))

    lib_r = os.path.join(WORK, "b_librcls")
    shutil.rmtree(lib_r, ignore_errors=True)
    os.makedirs(lib_r)
    # ★ gen_r 必须覆盖**我们真正用到的全部 AAR**（不只是 libs/*.aar）——
    #   否则库的 R 类（R$id / R$string…）缺一半，运行时会 NoSuchFieldError。
    used_dir = os.path.join(WORK, "b_used_aars")
    shutil.rmtree(used_dir, ignore_errors=True)
    os.makedirs(used_dir)
    for p in aars:
        link = os.path.join(used_dir, os.path.basename(p))
        if not os.path.exists(link):
            os.symlink(os.path.abspath(p), link)
    r = subprocess.run([sys.executable, GEN_R, symbols,
                        os.path.join(used_dir, "*.aar"), lib_r, PKG],
                       capture_output=True, text=True)
    print("   gen_r: " + ((r.stdout or r.stderr or "").strip().splitlines() or ["?"])[-1][:160])
    # ★ gen_r 产出的是 **R.java 源码**，得自己 javac 成 class。
    #   之前漏了这一步 ⇒ 库的 R 类（R$id / R$string…）从来没进过包 ⇒ 25 个类型缺失。
    lib_r_cls = os.path.join(WORK, "b_librcls_cls")
    shutil.rmtree(lib_r_cls, ignore_errors=True)
    os.makedirs(lib_r_cls)
    libros = [os.path.join(dp, f) for dp, _d, fs in os.walk(lib_r)
              for f in fs if f.endswith(".java")]
    if libros:
        run(["javac", "--release", "8", "-nowarn", "-encoding", "UTF-8",
             "-classpath", ANDROID_JAR, "-d", lib_r_cls] + libros)
    n_rcls = sum(len(f) for _r, _d, f in os.walk(lib_r_cls))
    print("   库 R 类 → %d 个 .class（javac 编译 %d 个 R.java，覆盖 %d 个 AAR）"
          % (n_rcls, len(libros), len(aars)))
    rcls_jar = os.path.join(WORK, "b_rcls.jar")
    run(["jar", "cf", rcls_jar, "-C", rcls, ".", "-C", lib_r_cls, "."])
    ok("R 类全部打进 %s (%d B)" % (os.path.basename(rcls_jar), os.path.getsize(rcls_jar)))

    # ---------------- ⑤ kotlinc ----------------
    say("⑤ kotlinc（Compose 编译器插件）")
    # ★ 桥的签名（编译期）：UI 里要调 `FdmPush.push/set/sp` 那几个方法，
    #   但那些类住在 classes2.dex（我们的桥 dex）里，**不能再进 UI 的 dex**（否则重复类）。
    #   ⇒ 只把 jar 挂到 classpath 上，不进 R8 的输入。
    bridge_jar = os.path.join(WORK, "b_bridge.jar")
    bridge_cls = os.path.join(ROOT, "mod-src", "build", "classes")
    if not os.path.isdir(bridge_cls):
        sys.exit("✗ 缺 %s —— 先跑 `cd mod-src && sh build.sh`" % bridge_cls)
    run(["jar", "cf", bridge_jar, "-C", bridge_cls, "."])
    print("   桥签名 %s (%d B)" % (os.path.basename(bridge_jar), os.path.getsize(bridge_jar)))

    jars = collect_jars()
    print("   编译期额外 jar %d 个（只进 classpath，不进 dex）" % len(jars))
    cp = ":".join(sorted(glob.glob(os.path.join(cls_dir, "*.jar"))) + jars
                  + KOTLIN_RUNTIME + [bridge_jar, rcls_jar, ANDROID_JAR])
    appcls = os.path.join(WORK, "b_appcls")
    shutil.rmtree(appcls, ignore_errors=True)
    os.makedirs(appcls)
    srcs = sorted(glob.glob(os.path.join(FD, "src", "*.kt")))
    r = subprocess.run(["java", "-Xmx3g", "-cp", KOTLIN_COMPILER,
                        "org.jetbrains.kotlin.cli.jvm.K2JVMCompiler",
                        "-jvm-target", "17", "-nowarn",
                        "-Xplugin=" + COMPOSE_PLUGIN,
                        "-classpath", cp, "-d", appcls] + srcs,
                       capture_output=True, text=True)
    if r.returncode != 0:
        errs = [l for l in (r.stderr or r.stdout or "").splitlines() if "error:" in l]
        print("\n".join(errs[:12]) or (r.stderr or r.stdout or "")[:2000])
        sys.exit("✗ kotlinc 失败")
    ok("kotlinc → %d 个 .class" % sum(len(f) for _r, _d, f in os.walk(appcls)))
    appcls_jar = os.path.join(WORK, "b_appcls.jar")
    run(["jar", "cf", appcls_jar, "-C", appcls, "."])
    ok("打包 %s (%d B)" % (os.path.basename(appcls_jar), os.path.getsize(appcls_jar)))

    # ---------------- ⑥ R8 ----------------
    say("⑥ R8（--dontobfuscate，保住真名）")
    r8out = os.path.join(WORK, "b_r8out")
    shutil.rmtree(r8out, ignore_errors=True)
    os.makedirs(r8out)
    ins = (sorted(glob.glob(os.path.join(cls_dir, "*.jar"))) + [rcls_jar, appcls_jar]
           + dedupe_jars(KOTLIN_RUNTIME + force_jars() + collect_closure_jars()))
    # ★ 把 material-icons-extended 换成裁过的版本，否则 R8 会被 7000+ 图标类撑爆
    trim = strip_icons(cls_dir)
    if trim:
        ins = [p for p in ins if "material-icons" not in os.path.basename(p) or "extended" not in os.path.basename(p)]
        ins.append(trim)
    print("   dex 输入的 jar：%d 个" % (len(ins) - 2))
    for k in KOTLIN_RUNTIME:
        if not os.path.isfile(k):
            sys.exit("✗ 缺 %s" % k)
    print("   Kotlin 运行时进 dex：%s" % "、".join(os.path.basename(k) for k in KOTLIN_RUNTIME))
    cmd = ["java", "-Xmx3g", "-XX:MaxMetaspaceSize=512m", "-cp", R8_JAR, "com.android.tools.r8.R8",
           "--release", "--min-api", "26",     # ★ 不给 min-api，R8 会按单 dex 处理 ⇒ 方法数超限直接失败
           "--lib", ANDROID_JAR,
           "--pg-conf", os.path.join(ROOT, "pipeline", "r8-app.pro"),
           # ★ 不要再给 --main-dex-rules：min-api ≥ 21 时 R8 明确不支持
           #   （报 "does not support main-dex inputs and outputs when compiling to API level 21 and above"）
           "--output", r8out] + ins
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print((r.stderr or r.stdout or "")[:3000])
        sys.exit("✗ R8 失败")
    dexes = sorted(glob.glob(os.path.join(r8out, "*.dex")))
    ok("R8 → %d 个 dex（%s）" % (len(dexes), [os.path.getsize(d) for d in dexes]))

    # poolingcontainer R$id：R8 会吃掉它 ⇒ 手工补一份，单独 D8 成一个 dex 注入
    # ★ 必须用 `javac --release 8` 重编：现成的那份是 major=61（Java 17）且**带 NestHost**，
    #   单独 D8 会失败（`Class R$id requires its nest host R to be on program or class path`）
    say("⑥b 手工补 poolingcontainer R$id（--release 8 重编 + 单独 D8 注入）")
    pc_java = os.path.join(WORK, "pc_R", "androidx", "customview", "poolingcontainer", "R.java")
    if not os.path.isfile(pc_java):
        sys.exit("✗ 缺 %s（手工 R 源码）" % pc_java)
    pc8 = os.path.join(WORK, "b_pc8")
    shutil.rmtree(pc8, ignore_errors=True)
    os.makedirs(pc8)
    run(["javac", "--release", "8", "-nowarn", "-d", pc8, pc_java])
    only = os.path.join(WORK, "b_pc_only")
    shutil.rmtree(only, ignore_errors=True)
    d = os.path.join(only, "androidx", "customview", "poolingcontainer")
    os.makedirs(d)
    rid = os.path.join(pc8, "androidx", "customview", "poolingcontainer", "R$id.class")
    rcls_file = os.path.join(pc8, "androidx", "customview", "poolingcontainer", "R.class")
    if not os.path.isfile(rid):
        sys.exit("✗ 没编出 R$id.class")
    shutil.copy(rid, os.path.join(d, "R$id.class"))
    if os.path.isfile(rcls_file):
        shutil.copy(rcls_file, os.path.join(d, "R.class"))   # ★ R 本身也要（有人引用它）
    cl = open(rid, "rb").read()
    print("   R$id major=%d 含NestHost=%s" % (int.from_bytes(cl[6:8], "big"), b"NestHost" in cl))
    pc_jar = os.path.join(WORK, "b_pc_only.jar")
    run(["jar", "cf", pc_jar, "-C", only, "."])
    pc_dex_dir = os.path.join(WORK, "b_pc_dex")
    shutil.rmtree(pc_dex_dir, ignore_errors=True)
    os.makedirs(pc_dex_dir)
    run(["java", "-cp", R8_JAR, "com.android.tools.r8.D8", "--release", "--min-api", "26",
         "--lib", ANDROID_JAR, "--output", pc_dex_dir, pc_jar])
    pc_dex = os.path.join(pc_dex_dir, "classes.dex")
    ok("pc.dex %d B" % os.path.getsize(pc_dex))

    # ---------------- ⑥c R 类占位补全 ----------------
    say("⑥c 补齐被引用但缺失的 R 类（占位 + 单独 D8）")
    pr_out = os.path.join(WORK, "b_patchr")
    shutil.rmtree(pr_out, ignore_errors=True)
    r = subprocess.run([sys.executable, os.path.join(HERE, "patch_r.py")]
                       + dexes + [pr_out], capture_output=True, text=True)
    print("   " + (r.stdout or r.stderr or "").strip().replace("\n", "\n   "))
    patch_dex = None
    patch_jar = os.path.join(WORK, "patch_r.jar")
    if os.path.isfile(patch_jar):
        pd = os.path.join(WORK, "b_patchr_dex")
        shutil.rmtree(pd, ignore_errors=True)
        os.makedirs(pd)
        run(["java", "-cp", R8_JAR, "com.android.tools.r8.D8", "--release", "--min-api", "26",
             "--lib", ANDROID_JAR, "--output", pd, patch_jar])
        patch_dex = os.path.join(pd, "classes.dex")
        ok("patch_r.dex %d B" % os.path.getsize(patch_dex))

    # ---------------- ⑥c R 类：绕开 R8 单独注入 ----------------
    # 为什么：R8 会把「只被库自己字节码引用」的 `R` / `R$id` / `R$string` 削掉，
    # 连 `-keep class androidx.** { *; }` 都拦不住（实测 `rcls.jar` 里有、R8 输出里没有）。
    # 而 AGP 8 的 R 字段不是编译期常量 ⇒ 运行时会真的去加载这些类 ⇒ `NoClassDefFoundError`。
    # 做法：把 R8 **没保留**的那些 R 类挑出来，D8 单独出一个 dex 注入（不重复类）。
    say("⑥c R 类（D8 单独注入 —— R8 拦不住会削掉它们）")
    r8_defined = set()
    for dx in dexes:
        with open(dx, "rb") as f:
            r8_defined |= dexinfo.defined_classes(f.read())
    rcls_only = os.path.join(WORK, "b_rcls_only")
    shutil.rmtree(rcls_only, ignore_errors=True)
    os.makedirs(rcls_only)
    n_r = 0
    with zipfile.ZipFile(rcls_jar) as z:
        for n in z.namelist():
            if not n.endswith(".class"):
                continue
            desc = "L" + n[:-6] + ";"
            if not is_r_class(desc) or desc in r8_defined:
                continue
            dst = os.path.join(rcls_only, n)
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            with open(dst, "wb") as f:
                f.write(z.read(n))
            n_r += 1
    rcls_dex = None
    if n_r:
        jar2 = os.path.join(WORK, "b_rcls_only.jar")
        run(["jar", "cf", jar2, "-C", rcls_only, "."])
        rd = os.path.join(WORK, "b_rcls_dex")
        shutil.rmtree(rd, ignore_errors=True)
        os.makedirs(rd)
        run(["java", "-cp", R8_JAR, "com.android.tools.r8.D8", "--release", "--min-api", "26",
             "--lib", ANDROID_JAR, "--output", rd, jar2])
        rcls_dex = os.path.join(rd, "classes.dex")
        ok("R 类 dex：%d 个类 / %d B" % (n_r, os.path.getsize(rcls_dex)))
    else:
        ok("R 类 dex：不需要（R8 都保留了）")

    # ---------------- ⑦ 组包 ----------------
    say("⑦ 组包（dex + 资源 + META-INF/services）")
    src = zipfile.ZipFile(base_apk)
    entries = []
    for i, dx in enumerate(dexes, 1):
        entries.append(("classes.dex" if i == 1 else "classes%d.dex" % i, open(dx, "rb").read()))
    entries.append(("classes%d.dex" % (len(dexes) + 1), open(pc_dex, "rb").read()))
    if patch_dex:
        entries.append(("classes%d.dex" % (len(dexes) + 3), open(patch_dex, "rb").read()))
    if rcls_dex:
        entries.append(("classes%d.dex" % (len(dexes) + 2), open(rcls_dex, "rb").read()))
    for n in src.namelist():
        if n == "AndroidManifest.xml" or n.endswith(".dex"):
            continue
        info = src.getinfo(n)
        entries.append((n, src.read(n), info.compress_type))
    entries.append(("AndroidManifest.xml", src.read("AndroidManifest.xml")))  # ★ 别忘加回来
    src.close()

    # ★ META-INF/services：协程主调度器只被这个文本文件引用，丢了 UI 第一帧就崩
    #   （来源自动找：任何含这两个文件的旧 UI 包 / 我们历次产物都行）
    import glob as _glob
    cands = sorted(_glob.glob(os.path.join(OUT, "FDM-UI-*-signed.apk"))
                   + _glob.glob(os.path.join(ROOT, "FDM-UI-*.apk"))
                   + _glob.glob(os.path.join(ROOT, "FDM-*-single-signed.apk")),
                   key=os.path.getmtime, reverse=True)
    n_svc = 0
    for c in cands:
        try:
            z = zipfile.ZipFile(c)
        except Exception:
            continue
        got = [n for n in z.namelist() if n.startswith("META-INF/services/")]
        if len(got) >= 2:
            for n in got[:2]:
                entries.append((n, z.read(n)))
            n_svc = len(got[:2])
            print("   services 来源：%s" % os.path.basename(c))
            break
        z.close()
    if n_svc != 2:
        sys.exit("✗ META-INF/services 只找到 %d 个（应当 2 个）—— 缺了 UI 会崩" % n_svc)
    ok("services 文件 %d 个 ✓" % n_svc)

    sys.path.insert(0, os.path.join(ROOT, "mod-src", "pack"))
    from build_apk import write_zip                      # noqa: E402
    ent = []
    for it in entries:
        d = {"name": it[0], "data": it[1]}
        if len(it) > 2:
            d["store"] = it[2] == zipfile.ZIP_STORED
        if it[0] == "resources.arsc":
            d.update(store=True, align=4)
        ent.append(d)
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    write_zip(a.out, ent)
    ok("→ %s (%d B)" % (a.out, os.path.getsize(a.out)))

    # ---------------- ⑧ 签名 ----------------
    say("⑧ 签名")
    signed = a.out.replace(".apk", "-signed.apk")
    run(["apksigner", "sign",
         "--key", os.path.join(ROOT, "mod-src", "pack", "keys", "fuckdsmanger.pk8"),
         "--cert", os.path.join(ROOT, "mod-src", "pack", "keys", "fuckdsmanger.x509.pem"),
         "--v1-signing-enabled", "true", "--v2-signing-enabled", "true",
         "--v3-signing-enabled", "true", "--v4-signing-enabled", "false", "--out", signed, a.out])
    run(["apksigner", "verify", "-v", signed])
    ok("→ %s (%d B)" % (signed, os.path.getsize(signed)))


if __name__ == "__main__":
    main()

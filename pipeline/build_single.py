#!/usr/bin/env python3
"""
build_single.py —— 单包组装（方案 C）🐲

    ┌─ UI 包（Compose，34.6 MB）─────────────┐
    │  它的 dex / res / resources.arsc 全保留 │
    │  只把【清单】改一改                     │
    ├─ 底座 2.22.110 的 classes.dex（188 KB）│  ← 128 类 = hook 层主体，一个字节不动
    ├─ 我们真编译的桥 dex（GmEntry+桥）       │  ← classes2.dex
    └────────────────────────────────────────┘
                 ↓ 拼 zip + 签名
        一个 APK：既是 LSPosed 模块，又是桌面 App

用法：
    python3 pipeline/build_single.py \
        --ui   FDM-UI-3.0-signed.apk \
        --base mod-src/base/FuckDSManger_NL_2.22.110_for_ds2.5.2.apk \
        --our-dex mod-src/build/dex/classes.dex \
        --version-code 452 --version-name 3.1.0 \
        --out out/FDM-3.1.0-single.apk
"""
import argparse
import os
import re
import subprocess
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "mod-src", "pack"))
import axml                                        # noqa: E402
import dexinfo                                     # noqa: E402
from build_apk import write_zip, DEFAULT_KEY, DEFAULT_CERT   # noqa: E402

PKG = "com.little_femaleboy.cannot_show.the_big_won_whale"
ENTRY = "com.nidyaber.fuckdsmanger.bridge.FdmEntry"
BASE_ENTRY = "com.nidyaber.fuckdsmanger.GmEntry"
SETTINGS_ACT = "com.nidyaber.fuckdsmanger.bridge.FdmSettingsActivity"
SETTINGS_LABEL = "FDM 桥设置"
MAIN_LABEL = "FuckDSManger UI (单包)"
# UI 包里自带的 Material Symbols 矢量图，拿来给两个图标**做区分**
# （原包和新包连图标都一样，桌面上根本分不出来 —— 这个 bug 让主人白卸了一次包）
ICON_MAIN = 0x7F040004       # drawable/ic_build
ICON_SETTINGS = 0x7F040001   # drawable/ic_admin_panel_settings
SETTINGS_AFFINITY = PKG + ".bridge"   # 设置页自己一个任务，不跟 UI 抢
PROVIDER = "com.nidyaber.fuckdsmanger.bridge.ConfigProvider"
PROVIDER_AUTH = PKG + ".config"


# ------------------------------------------------------------------ 清单打补丁

def patch_manifest(src, version_code, version_name, app_class=None):
    """解码 → 改（包名 / 版本 / 加 provider / 加 xposed meta-data）→ 重编码。

    ⚠️ 只加「ANDROID_ATTR_ID 表里有 id」的属性；表里没有的直接报错，
       绝不让一个写坏的清单悄悄出包。
    """
    pool, ev = axml.decode(src)
    attr_ids = axml.collect_attr_ids(pool, ev)
    pool = list(pool)

    def S(s):
        pool.append(s)
        return len(pool) - 1

    A = axml.ANDROID_NS

    def s_attr(name, value):
        """android:name="value" 这种字符串属性。

        ★ raw 与 typed **都要写**：aapt2 自己产出的清单里，字符串属性两个值都在。
          少了 raw（=只留 data），aapt2 能读、`getAttributeValue()` 那条路读不到，
          属于"看着对、平台读不到"的隐形坏件。
        """
        return (A, name, value, axml.TYPE_STRING, S(value))

    def ref_attr(name, rid, raw=None):
        """引用型属性（@xxx / 0x 资源 id）。"""
        return (A, name, raw, axml.TYPE_REFERENCE, rid)

    def new_elem(name, attrs, line=99):
        return [("start", line, "", name, attrs),
                ("end", line, "", name)]

    out = []
    inserted = False
    for e in ev:
        if e[0] == "start" and e[3] == "manifest":
            attrs = []
            for (ans, aname, araw, atype, adata) in e[4]:
                if aname == "package":
                    attrs.append((ans, aname, PKG, axml.TYPE_STRING, S(PKG)))
                elif aname == "versionCode":
                    attrs.append((ans, aname, None, axml.TYPE_INT_DEC, version_code))
                elif aname == "versionName":
                    attrs.append((ans, aname, version_name, axml.TYPE_STRING, S(version_name)))
                else:
                    attrs.append((ans, aname, araw, atype, adata))
            out.append(("start", e[1], e[2], e[3], attrs))

        elif e[0] == "start" and e[3] == "activity":
            # 单包的 MainActivity：标签加「(单包)」后缀 —— 否则跟旧的独立 UI 包
            # （com.nidyaber.fdmui，标签也是 "FuckDSManger UI"）在桌面上一模一样，根本分不出来。
            attrs = []
            is_main = False
            for (ans, aname, araw, atype, adata) in e[4]:
                if aname == "name" and araw == "com.nidyaber.fuckdsmanger.MainActivity":
                    is_main = True
                if aname == "label":
                    continue                      # 丢掉原来的，下面统一给
                attrs.append((ans, aname, araw, atype, adata))
            if is_main:
                attrs.append(s_attr("label", MAIN_LABEL))
                # （这里本来想给两个图标各挂一张矢量图，用来跟旧的独立 UI 包区分；
                #   但旧包已经卸掉了 ⇒ 需求消失。而且新 UI 的资源表是我们自己 link 的，
                #   硬编码的资源 id 不再适用 —— 要挂图标得先把矢量图放进 fdm-app/res/drawable。
                #   留给"正式 UI"那一轮，跟 UI 的图标体系一起做。）
            out.append(("start", e[1], e[2], e[3], attrs))

        elif e[0] == "start" and e[3] == "application":
            attrs = list(e[4])
            if app_class:
                attrs.append(s_attr("name", app_class))
            out.append(("start", e[1], e[2], e[3], attrs))

        elif e[0] == "end" and e[3] == "application" and not inserted:
            # 插到 </application> 之前
            for nm, val in (("xposedmodule", "true"),
                            ("xposeddescription", "FuckDSManger — DeepSeek 灰度管理器（单包·双层）"),
                            ("xposedminversion", "82")):
                out += new_elem("meta-data", [s_attr("name", nm), s_attr("value", val)])
            out += new_elem("provider", [
                s_attr("name", PROVIDER),
                s_attr("authorities", PROVIDER_AUTH),
                (A, "exported", None, axml.TYPE_INT_BOOLEAN, 0xFFFFFFFF),
                (A, "grantUriPermissions", None, axml.TYPE_INT_BOOLEAN, 0),
            ])

            # 桥设置页：纯框架控件（Switch），**不需要 Compose / 不需要任何资源**
            # 给它自己的 LAUNCHER 图标 ⇒ 桌面多一个「FDM 桥设置」，点开就能拨开关
            out += [("start", 99, "", "activity", [
                s_attr("name", SETTINGS_ACT),
                s_attr("label", SETTINGS_LABEL),
                # ★ 独立的 taskAffinity：否则两个图标共用同一个任务，
                #   点了另一个只会把已有任务拉到前台，**不会起这个 Activity**
                (A, "taskAffinity", SETTINGS_AFFINITY, axml.TYPE_STRING, S(SETTINGS_AFFINITY)),
                (A, "exported", None, axml.TYPE_INT_BOOLEAN, 0xFFFFFFFF),
            ])]
            out += [("start", 99, "", "intent-filter", [])]
            out += [("start", 99, "", "action",
                     [s_attr("name", "android.intent.action.MAIN")]),
                    ("end", 99, "", "action")]
            out += [("start", 99, "", "category",
                     [s_attr("name", "android.intent.category.LAUNCHER")]),
                    ("end", 99, "", "category")]
            out += [("end", 99, "", "intent-filter")]
            out += [("end", 99, "", "activity")]
            inserted = True
            out.append(e)

        else:
            out.append(e)

    if not inserted:
        raise SystemExit("✗ 清单里找不到 <application> 的结束标签，补丁没打上")
    return axml.rebuild(pool, out, attr_ids)


# ------------------------------------------------------------------ 主流程

DEX_RE = re.compile(r"^classes(\d*)\.dex$")

# 只丢这些 —— META-INF/services/** 里住着协程的主调度器，丢了 UI 会崩
# （"Module with the Main dispatcher is missing"，方案B 时代踩过一次，这次又踩了）
SIG_RE = re.compile(r"^META-INF/(MANIFEST\.MF|.*\.(SF|RSA|DSA|EC))$", re.IGNORECASE)


def is_signature(name):
    return bool(SIG_RE.match(name))


def check_carryover(src_names, kept_names, added_names):
    """出包前检查：UI 包里**【除签名/清单/dex】以外的东西，一件都不许丢**。

    这条检查的由来：我为了丢旧签名写了 `if n.startswith("META-INF/"): continue`，
    把 `META-INF/services/kotlinx.coroutines.*` 两个服务文件一起丢了
    ⇒ UI 起来就崩在 `Main dispatcher is missing`。
    """
    kept = set(kept_names) | set(added_names)
    must_keep = [n for n in src_names if not is_signature(n) and n != "AndroidManifest.xml"
                 and not DEX_RE.match(n)]
    lost = [n for n in must_keep if n not in kept]
    svc = [n for n in src_names if n.startswith("META-INF/services/")]
    print("⑤ 条目搬运      : 源 %d 项 → 保留 %d 项；services 文件 %d 个%s"
          % (len(must_keep), len(must_keep) - len(lost), len(svc),
             " ✓" if not lost else ""))
    if svc:
        for s in svc:
            print("     · %s" % s)
    if lost:
        print("\n✗ 出包前自检没过：这些东西被丢了（不止签名！）")
        for n in lost:
            print("   " + n)
        raise SystemExit(1)


def preflight(base_dex, our_dex, ui_dexes):
    """出包前的硬检查 —— 每一颗雷都真炸过一次，所以写成脚本卡住。"""
    bad = []

    def desc(cls):
        return "L" + cls.replace(".", "/") + ";"

    base_cls = dexinfo.defined_classes(base_dex)
    our_cls = dexinfo.defined_classes(our_dex)
    print("类定义          : 底座 %d 个 / 我们 %d 个" % (len(base_cls), len(our_cls)))

    # ① 两个 dex 不许有同名类（否则谁被加载取决于 dex 顺序 ⇒ 随机行为）
    dup = base_cls & our_cls
    if dup:
        bad.append("① 底座与我们**同名类** %d 个：%s" % (len(dup), sorted(dup)[:8]))
    else:
        print("① 同名类        : 0 个 ✓")

    # ② 底座 dex 必须真的【定义】了入口要转发的那个类
    if desc(BASE_ENTRY) not in base_cls:
        bad.append("② 底座 dex 里没有定义 %s（只被引用不算）" % BASE_ENTRY)
    else:
        print("② 底座入口      : %s 在 ✓" % BASE_ENTRY)

    # ③ 我们自己的入口必须真的在
    if desc(ENTRY) not in our_cls:
        bad.append("③ 我们的 dex 里没有定义入口 %s" % ENTRY)
    else:
        print("③ 我们的入口    : %s 在 ✓" % ENTRY)

    # ④ 底座 dex 不能引用 0x7f/0x7e 资源常量 —— 我们复用的是 UI 那套 resources.arsc
    rids = dexinfo.find_res_ids(base_dex)
    if rids:
        bad.append("④ 底座 dex 里有 %d 个资源常量引用：%s ⇒ 复用 UI 资源会错位"
                   % (len(rids), ["0x%08x" % i for i in sorted(rids)][:8]))
    else:
        print("④ 底座资源引用  : 0 个 ✓（可以安全复用 UI 的 resources.arsc）")

    for i, (_, d) in enumerate(ui_dexes, 3):
        uic = dexinfo.defined_classes(d)
        print("   classes%d.dex  : %d 个类定义 · 资源常量 %d 个（UI 引自己的资源，正常）"
              % (i, len(uic), len(dexinfo.find_res_ids(d))))
        dup2 = uic & our_cls
        if dup2:
            bad.append("⑤ UI dex 与我们的 dex 同名类 %d 个：%s" % (len(dup2), sorted(dup2)[:6]))

    if bad:
        print("\n✗ 出包前自检没过：")
        for b in bad:
            print("   " + b)
        raise SystemExit(1)
    print("自检全部通过 ✓\n")


def check_dex_fresh(our_dex_path):
    """★ 出包前确认「我们刚编出来的 dex」比源码新。

    由来：我编译失败了，但流水线用的是 `;` 连命令 ⇒ **旧 dex 照样进了包**，
    出来一个"看起来成功、其实还是上一版"的 APK。这种包最坑人。
    """
    import time
    newest_src = 0.0
    for root, _dirs, files in os.walk(os.path.join(ROOT, "mod-src", "src")):
        for f in files:
            if f.endswith(".java"):
                newest_src = max(newest_src, os.path.getmtime(os.path.join(root, f)))
    dex_m = os.path.getmtime(our_dex_path)
    if newest_src > dex_m:
        raise SystemExit("✗ 我们的 dex (%s) 比源码旧 —— 编译没成功就跑打包了！"
                         % our_dex_path)
    print("⑥ dex 新鲜度    : dex 比 src/ 新 ✓")


def check_icons(ui_apk):
    """确认①硬编码的矢量图 id 在 UI 包里**真的存在**（不然图标会变空白，还很难查）。

    硬编码 id 是有风险的，所以每次出包都对着 UI 包的资源表核一遍。
    """
    aapt = os.path.join(ROOT, "tools", "aapt2", "aapt2_64")
    if not os.path.isfile(aapt):
        print("⑦ 图标 id      : 跳过（没找到 aapt2）")
        return
    try:
        out = subprocess.run([aapt, "dump", "resources", ui_apk],
                             capture_output=True, text=True, timeout=180).stdout
    except Exception as e:
        print("⑦ 图标 id      : 跳过（aapt2 跑不动：%s）" % e)
        return
    pairs = [("drawable/ic_build", ICON_MAIN),
             ("drawable/ic_admin_panel_settings", ICON_SETTINGS)]
    for name, rid in pairs:
        want = "resource 0x%08x %s" % (rid, name)
        if want not in out:
            raise SystemExit("✗ 图标资源 id 对不上：%s（UI 包里没这个）" % want)
    print("⑦ 图标 id      : %s 都在 ✓" % "、".join(n for n, _ in pairs))


def check_attr_order(apk_path):
    """⑧ 出包后验一遍：**每个元素的属性必须按资源 id 升序、无 id 的排最后**。

    这个坑踩了三次（resmap 乱序 / provider 属性乱序 / 设置页属性乱序），
    症状都是"平台读不到某个属性"（provider exported=false、安装报 exported 未定义）。
    所以出完包必须自己核一遍 —— 别指望 aapt2 dump（它是按名字反查，顺序无关，看不出来）。
    """
    import struct
    try:
        with zipfile.ZipFile(apk_path) as z:
            d = z.read("AndroidManifest.xml")
        pool, _ev = axml.decode(d)
        pos = 8
        rm = []
        while pos < len(d):
            c, _h, s = struct.unpack_from("<HHI", d, pos)
            if c == 0x0180:
                rm = list(struct.unpack_from("<%dI" % ((s - 8) // 4), d, pos + 8))
                break
            pos += s
        pos = 8
        bad = []
        while pos < len(d):
            c, _h, s = struct.unpack_from("<HHI", d, pos)
            if c == 0x0102:
                _ns, name, astart, asize, acount = struct.unpack_from("<IIHHH", d, pos + 16)
                tag = pool[name]
                ids = []
                ap = pos + 16 + astart
                for _ in range(acount):
                    _ans, aname, _araw = struct.unpack_from("<III", d, ap)
                    ids.append(rm[aname] if aname < len(rm) else 0xFFFFFFFF)
                    ap += asize
                if ids != sorted(ids):
                    bad.append("%s: %s" % (tag, [hex(i) for i in ids]))
            pos += s
        if bad:
            raise SystemExit("✗ 属性顺序不是升序（平台会漏读属性）：\n   " + "\n   ".join(bad))
        print("⑧ 属性顺序      : 每个元素都按资源 id 升序 ✓")
    except SystemExit:
        raise
    except Exception as e:
        print("⑧ 属性顺序      : 跳过（%s）" % e)


def check_components(manifest_bytes, class_sets):
    """⑨ 清单里声明的组件类**必须真的存在于 dex 里**。

    由来：`build_ui.py` 的清单用了**相对名** `.MainActivity`，而 `build_single.py` 会改 package
    ⇒ 相对名跟着变，指向一个不存在的类 ⇒ 一点图标就 `ClassNotFoundException`。
    这种错**不该靠装一次才发现**。
    """
    pool, ev = axml.decode(manifest_bytes)
    pkg = None
    comps = []
    for e in ev:
        if e[0] != "start":
            continue
        tag = e[3]
        attrs = {a[1]: a[2] for a in e[4]}
        if tag == "manifest":
            pkg = attrs.get("package")
        if tag in ("activity", "activity-alias", "provider", "service", "receiver") \
                and "name" in attrs:
            comps.append((tag, attrs["name"]))
    bad = []
    for tag, name in comps:
        full = (pkg + name) if name.startswith(".") else name
        if "/" in full:                      # activity-alias 的 targetActivity 之类不校验
            continue
        desc = "L" + full.replace(".", "/") + ";"
        if not any(desc in s for s in class_sets):
            bad.append("<%s android:name=%s> → %s 不在任何 dex 里" % (tag, name, full))
    print("⑨ 组件类        : 声明 %d 个，%d 个找不到%s"
          % (len(comps), len(bad), "" if not bad else " ✗"))
    for t, n in comps:
        print("     · <%s> %s" % (t, n))
    if bad:
        raise SystemExit("✗ 清单声明的组件类不在 dex 里：\n   " + "\n   ".join(bad))


def check_super_closure(dexes):
    """⑩ 「引用闭包」：dex 里**引用过**的所有类型，必须是"我们定义的"或"框架白名单里的"。

    由来（两个都真机炸过）：
      · 只看父类不够 —— kotlin-stdlib 没进 dex 时 1102 个类缺父类（已修）
      · 只看父类还不够 —— `SimpleArrayMap` 不是父类，只是 `ComponentActivity.<init>`
        方法体里用到的类型 ⇒ 运行时 `NoClassDefFoundError`，而父类检查看不见
    ⇒ 所以这里用 **type_ids 全表**（dex 引用过的所有类型）来算缺口。
    """
    miss = dexinfo.missing_refs(dexes)
    print("⑩ 引用闭包      : 缺被引用的类型 %d 个%s" % (len(miss), "" if not miss else " ✗"))
    if miss:
        raise SystemExit("✗ dex 里引用了不存在的类型（装上去必然 NoClassDefFoundError）：\n   "
                         + "\n   ".join("%-58s 被 %d 个 dex 引用" % (t, n) for t, n in miss[:12])) 


def check_ref_closure(dexes):
    """⑪ 「引用闭包」：被引用、但既没定义、也不是框架/白名单的**类型**，一个都不许有。

    这条比 ⑩ 强：`androidx.collection.SimpleArrayMap`（构造器里用到）父类检查看不到，
    但它缺了就在 `<init>` 里炸 `NoClassDefFoundError`。dex 的 `type_ids` 里有一切引用。

    白名单里每一条都有理由（见下），新增的缺件一律让构建失败。
    """
    import re as _re
    WL_PREFIX = (
        "Landroidx/window/extensions/",   # 系统可选库，反射加载（required=false）
        "Landroidx/window/sidecar/",      # 同上
        "Lorg/xmlpull/",                  # 设备上的框架类
        "Lio/reactivex/",                 # 可选集成（我们不引 RxJava）
        "Lkotlinx/coroutines/rx2/",       # 同上：coroutines 的 RxJava 转换，用不到
        "Lkotlinx/coroutines/rx3/",
        # ↓ 下面几条是"注解处理器的编译期残留"：R8 的宽松 keep 把它们留下了，
        #   但运行时没有任何代码路径会加载它们（javapoet / AutoValue / Guava 都是编译期用的）
        "Lcom/squareup/javapoet/",
        "Lcom/google/auto/",
        "Lcom/google/common/",
        "Lcom/google/errorprone/",
        # ↓ Compose 的追踪集成：androidx.tracing 的 aar 里**只有资源、没有类**
        #   （它是可选集成，启用 tracing 时才用到）
        "Landroidx/tracing/",
    )
    miss = dexinfo.missing_types(dexes)
    left, wl = [], []
    for t in miss:
        if t.startswith(WL_PREFIX):
            wl.append(t)
        elif _re.search(r"/R\$[A-Za-z_]+;$", t):
            wl.append(t)                  # 库内部 R 类（AGP non-transitive R）：只在库的未执行路径里被引用
        else:
            left.append(t)
    print("⑪ 引用闭包      : 缺 %d 个引用类型（白名单 %d，**待处理 %d**）%s"
          % (len(miss), len(wl), len(left), "" if not left else " ✗"))
    print("     白名单（都有理由）：window 可选库 / xmlpull / rxjava / 库内部 R 类")
    if left:
        import collections
        pk = collections.Counter(".".join(t[1:-1].split("/")[:3]) for t in left)
        raise SystemExit("✗ 有引用类型缺失（装上去会 NoClassDefFoundError）：\n   "
                         + "\n   ".join("%-46s %d 个" % (k, v) for k, v in pk.most_common(8))
                         + "\n   ⇒ 找到提供它的 aar/jar，加进 build_ui.py 的 FORCE_AARS / FORCE_JARS")
    return left


def check_refs_closure(dexes):
    """⑪ 引用闭包：**被 method/field 引用到的类，必须都在 dex 并集里**。

    这是最硬的一道 —— 它抓的是"装上去必然崩、但构建全程不报错"的包：
      · `NoClassDefFoundError: androidx.collection.SimpleArrayMap`（ComponentActivity.<init> 里用到）
      · `NoClassDefFoundError: androidx.compose.ui.R$id`（R8 把 R 类削了）
    ⑩ 只查父类链抓不到这两个（它们不在 superclass 上）。
    """
    miss = dexinfo.missing_refs(dexes)
    print("⑪ 引用闭包      : 被引用但缺失的类 %d 个%s" % (len(miss), "" if not miss else " ✗"))
    if miss:
        raise SystemExit("✗ 有类被引用但不在包里（装上去必然崩）：\n   "
                         + "\n   ".join(miss[:12])
                         + ("\n   …还有 %d 个" % (len(miss) - 12) if len(miss) > 12 else ""))


# ------------------------------------------------------------------ ⑫ 铁律

HOST_PKG_MARKERS = (b"com.deepseek.chat", b"com/deepseek/chat")


def check_no_host_pkg(dexes):
    """⑫ 铁律：模块功能**不许依赖宿主包名**（主人 2026-09-26 拍）。

    为什么扫 **dex** 而不是扫源码：源码里注释还留着"旧写法是
    `packageName.startsWith("com.deepseek.chat")`"这种**历史说明**，那是该留的；
    dex 里出现这个串，才是**真的写进了字节码**。

    由来（真机级隐患，不是洁癖）：
      宿主清单包名已经从 `com.deepseek.chat` 变成过 `com.deepseek.chat.a`，
      我们现在能跑，靠的是 `"com.deepseek.chat.a".startsWith("com.deepseek.chat")` **恰巧为真**。
      一旦真改名 —— 底座总闸 `packageName.startsWith(...)` 不通过 ⇒ `return-void`
      ⇒ **51 条钩子一条都不挂**；而总闸在日志之前 ⇒ **连日志都进不去，静默全灭**。

    细则见 `专题/铁律-不依赖宿主包名.md`。
    """
    bad = []
    for label, data in dexes:
        for m in HOST_PKG_MARKERS:
            if m in data:
                bad.append("%s 里出现 %s" % (label, m.decode()))
    print("⑫ 宿主包名依赖  : %d 处%s" % (len(bad), "" if not bad else " ✗"))
    if bad:
        raise SystemExit(
            "✗ 铁律被破：dex 里出现了宿主包名 —— 模块功能不许依赖它！\n   "
            + "\n   ".join(bad)
            + "\n   改法：① 判「是不是宿主」改判**锚点类在不在**（不要看它叫什么）"
              "\n         ② hook 落点尽量换**框架类**（android.app.Application / android.app.Activity）"
              "\n         ③ 白名单/鉴权改 **token + uid** 握手"
              "\n   详见 专题/铁律-不依赖宿主包名.md")


def check_module_pkg():
    """⑫.1 我们**自己**的包名必须跟本脚本的 PKG 一致。

    `MODULE_PKG` 指我们自己的包（不违反铁律），但它写歪了 ⇒
    拉起 UI 的显式 Intent（`FdmUiHook`）和 provider 寻址（`FdmBridge`）会指错地方。
    """
    src = os.path.join(ROOT, "mod-src", "src", "com", "nidyaber", "fuckdsmanger",
                       "bridge", "FdmBridge.java")
    txt = open(src, encoding="utf-8").read()
    m = re.search(r'MODULE_PKG\s*=\s*"([^"]+)"', txt)
    got = m.group(1) if m else None
    ok = (got == PKG)
    print("⑫.1 自身包名     : MODULE_PKG=%s / PKG=%s %s" % (got, PKG, "✓" if ok else "✗"))
    if not ok:
        raise SystemExit("✗ MODULE_PKG(%s) 与本脚本 PKG(%s) 不一致" % (got, PKG))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ui", required=True, help="UI 包（提供 Compose dex / 资源 / 清单底子）")
    ap.add_argument("--base", required=True, help="底座模块包（提供 128 类的 classes.dex）")
    ap.add_argument("--our-dex", required=True, help="我们真编译出来的 dex（桥 + 入口）")
    ap.add_argument("--app-class", default=None, help="要写进 <application android:name> 的类（可选）")
    ap.add_argument("--version-code", type=int, required=True)
    ap.add_argument("--version-name", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--sign", dest="sign", action="store_true", default=True)
    ap.add_argument("--no-sign", dest="sign", action="store_false")
    a = ap.parse_args()

    # ---------- ① 底座：只要它的 classes.dex ----------
    with zipfile.ZipFile(a.base) as z:
        base_dex = z.read("classes.dex")
    print("底座 classes.dex : %d 字节（128 类，原样搬）" % len(base_dex))

    with open(a.our_dex, "rb") as f:
        our_dex = f.read()
    print("我们的   dex     : %d 字节（桥 + 入口）" % len(our_dex))

    # ---------- ② UI 包：dex 全部改名往后排，其余条目照抄 ----------
    ui_dexes = []
    keep = []
    ui_all_names = []
    manifest_src = None
    with zipfile.ZipFile(a.ui) as z:
        for info in z.infolist():
            n = info.filename
            ui_all_names.append(n)
            if is_signature(n):
                continue                      # 只丢【签名文件】，其它 META-INF 一定要留！
            if n == "AndroidManifest.xml":
                manifest_src = z.read(n)
                continue
            if DEX_RE.match(n):
                ui_dexes.append((int(DEX_RE.match(n).group(1) or "1"), z.read(n)))
                continue
            keep.append((n, z.read(n), info.compress_type))
    ui_dexes.sort()
    print("UI dex           : %s" % [len(d) for _, d in ui_dexes])
    print("其它条目（资源等）: %d 个" % len(keep))

    # ---------- ②.5 出包前自检 ----------
    preflight(base_dex, our_dex, ui_dexes)
    check_dex_fresh(a.our_dex)
    check_carryover(ui_all_names, [n for n, _, _ in keep],
                    ["classes.dex", "classes2.dex", "AndroidManifest.xml", "assets/xposed_init"]
                    + ["classes%d.dex" % i for i in range(3, 3 + len(ui_dexes))])

    # ---------- ③ 清单补丁 ----------
    new_manifest = patch_manifest(manifest_src, a.version_code, a.version_name, a.app_class)
    print("清单             : %d → %d 字节（包名→%s）" % (len(manifest_src), len(new_manifest), PKG))

    # ---------- ③.5 组件类必须真在 dex 里 ----------
    class_sets = [dexinfo.defined_classes(base_dex), dexinfo.defined_classes(our_dex)] \
        + [dexinfo.defined_classes(d) for _, d in ui_dexes]
    check_components(new_manifest, class_sets)
    check_super_closure([base_dex, our_dex] + [d for _, d in ui_dexes])
    check_refs_closure([base_dex, our_dex] + [d for _, d in ui_dexes])
    check_ref_closure([base_dex, our_dex] + [d for _, d in ui_dexes])

    # ---------- ③.6 ⑫ 铁律：功能不许依赖宿主包名 ----------
    #   只扫「底座 + 我们的桥」—— hook 层与桥在这儿，
    #   UI（Compose）是独立进程的皮，扫它意义不大（也可能有正当的展示文案）。
    check_module_pkg()
    check_no_host_pkg([("底座 classes.dex", base_dex), ("我们的 classes2.dex", our_dex)])

    # ---------- ④ 拼 zip ----------
    entries = []
    entries.append({"name": "classes.dex", "data": base_dex})
    entries.append({"name": "classes2.dex", "data": our_dex})
    for i, (_, d) in enumerate(ui_dexes, start=3):
        entries.append({"name": "classes%d.dex" % i, "data": d})
    entries.append({"name": "AndroidManifest.xml", "data": new_manifest})
    entries.append({"name": "assets/xposed_init", "data": (ENTRY + "\n").encode("utf-8")})
    for n, d, ct in keep:
        if n == "resources.arsc":
            entries.append({"name": n, "data": d, "store": True, "align": 4})
        else:
            entries.append({"name": n, "data": d, "store": ct == zipfile.ZIP_STORED})

    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    write_zip(a.out, entries)
    print("→ 未签名 APK     : %s (%d 字节)" % (a.out, os.path.getsize(a.out)))
    check_attr_order(a.out)

    # ---------- ⑤ 签名 ----------
    if a.sign:
        signed = a.out.replace(".apk", "-signed.apk")
        subprocess.run(["apksigner", "sign",
                        "--key", DEFAULT_KEY, "--cert", DEFAULT_CERT,
                        "--v1-signing-enabled", "true",
                        "--v2-signing-enabled", "true",
                        "--v3-signing-enabled", "true", "--v4-signing-enabled", "false",
                        "--out", signed, a.out], check=True)
        print("→ 已签名         : %s (%d 字节)" % (signed, os.path.getsize(signed)))
        subprocess.run(["apksigner", "verify", "--print-certs", "-v", signed], check=True)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
patch_r.py —— 给「被引用、但 dex 里没有」的 R 类生成**占位类** 🐲

为什么需要：
  · R8 会把库的 R 类削掉（`-keep` 也拦不住，跟 poolingcontainer 一个家族）
  · 有些 R 字段引用的资源**根本不在我们 link 出来的 arsc 里**（R8 留了悬空引用）
  ⇒ 拿不到真值，那就补占位：字段值 0（读不到就退默认），总比 `NoClassDefFoundError` 强

关键：**只生成被真正引用到的字段**（名字/类型从 dex 的 field_ids 里读），不瞎编。

用法：python3 pipeline/patch_r.py <要打的 dex…> <输出目录>
      生成 <输出目录>/patch_r.jar（交给 D8 出 dex）
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "..", "mod-src", "pack"))
import dexinfo                                        # noqa: E402

R_RE = re.compile(r"^L(.+)/R(\$[A-Za-z0-9_]+)?;$")


def main():
    dex_paths = sys.argv[1:-1]
    outdir = sys.argv[-1]
    dexes = [open(p, "rb").read() for p in dex_paths]

    miss = [t for t, _n in dexinfo.missing_refs(dexes)]
    r_classes = [t for t in miss if R_RE.match(t)]
    # 非 R 的缺失也要报出来（那些是"真的少依赖"，不能靠占位糊过去）
    other = [t for t in miss if not R_RE.match(t)]
    if other:
        print("⚠ 还有 %d 个非 R 类缺失（这些是依赖没补全，别指望占位）：" % len(other))
        for t in other[:12]:
            print("   ", t)

    if not r_classes:
        print("✓ 没有缺的 R 类，不用补")
        return 0

    want = set(r_classes)
    fields = {}                                        # 类描述符 → [(名字, 类型描述符)]
    for d in dexes:
        for cls, name, typ in dexinfo.referenced_fields(d):
            if cls in want:
                fields.setdefault(cls, [])
                if (name, typ) not in fields[cls]:
                    fields[cls].append((name, typ))

    os.makedirs(outdir, exist_ok=True)
    n = 0
    for cls in sorted(r_classes):
        m = R_RE.match(cls)
        pkg = m.group(1).replace("/", ".")
        inner = m.group(2)                             # '$id' / '$styleable' / None
        simple = "R" + (inner if inner else "")
        d = os.path.join(outdir, *pkg.split("."))
        os.makedirs(d, exist_ok=True)
        body = ["package %s;" % pkg, "", "/* 占位：补 dex 里被引用但缺失的 R 类（由 patch_r.py 生成） */"]
        if inner:
            body.append("public final class R {")
            body.append("    public static final class %s {" % inner[1:])
            ind = "        "
        else:
            body.append("public final class R {")
            ind = "    "
        for name, typ in sorted(fields.get(cls, [])):
            if typ == "[I":
                body.append(ind + "public static final int[] %s = {};" % name)
            elif typ == "I":
                body.append(ind + "public static final int %s = 0;" % name)
            else:
                print("   跳过非常规字段 %s.%s : %s" % (cls, name, typ))
        if inner:
            body.append("    }")
        body.append("}")
        open(os.path.join(d, simple + ".java"), "w", encoding="utf-8").write("\n".join(body) + "\n")
        n += 1

    javas = []
    for root, _dirs, files in os.walk(outdir):
        javas += [os.path.join(root, f) for f in files if f.endswith(".java")]
    subprocess.run(["javac", "--release", "8", "-nowarn", "-d", outdir] + javas, check=True)
    jar = os.path.join(os.path.dirname(outdir), "patch_r.jar")
    subprocess.run(["jar", "cf", jar, "-C", outdir, "."], check=True)
    print("✓ 生成了 %d 个 R 占位类 → %s" % (n, jar))
    return 0


if __name__ == "__main__":
    sys.exit(main())

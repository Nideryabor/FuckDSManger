#!/usr/bin/env python3
"""
extract_hooks.py —— 从真编译产物 GmEntry.smali 里抽出「hook 注册序列」。

原理：模拟 d8 的寄存器分配——跟踪每个寄存器最后一次被
const-string 写入了什么 / 被 findClass 或 new-instance 装进了哪个类，
再把 invoke 的实参寄存器映射回字符串；最后按【调用点顺序】输出
（hookPickAll 的方法体在文件里靠前，所以它里面那次要挪到调用点）。

用法:  python3 extract_hooks.py <GmEntry.smali>
"""
import re
import sys

GM_PREFIXES = ["com.nidyaber.fuckdsmanger.gm.",
               "com.varuns2002.disable_flag_secure.gm."]   # 改名前后都认


def unescape(s):
    return re.sub(r"\\u([0-9a-fA-F]{4})", lambda m: chr(int(m.group(1), 16)), s)


def short(desc):
    """Lcom/xx/Foo;  ->  Foo     （并去掉 gm 包前缀）"""
    d = desc.strip()
    if d.startswith("L") and d.endswith(";"):
        d = d[1:-1].replace("/", ".")
    for p in GM_PREFIXES:
        if d.startswith(p):
            return d[len(p):]
    return d


def short_str(v):
    """hook 类的字符串形式是 FQCN，压成短名再比。"""
    for p in GM_PREFIXES:
        if v.startswith(p):
            return v[len(p):]
    return v


def main(path):
    lines = open(path, encoding="utf-8").read().split("\n")
    regs = {}          # reg -> 字符串值
    cls_regs = {}      # reg -> 类名（findClass / new-instance 的结果）
    pending_new = None
    pending_find = None

    out = []
    cur_method = None
    pick_events = []   # hookPickAll 方法体里攒的事件，等调用点再吐

    def emit(s):
        if cur_method == "hookPickAll":
            pick_events.append(s)
        else:
            out.append(s)

    for raw in lines:
        line = raw.strip()

        if line.startswith(".method"):
            if "hookPickAll" in line:
                cur_method = "hookPickAll"
            elif "handleLoadPackage" in line:
                cur_method = "handleLoadPackage"
            else:
                cur_method = None
            continue
        if line.startswith(".end method"):
            cur_method = None
            continue
        if cur_method is None or not line or line.startswith("#") or line.startswith("."):
            continue

        m = re.match(r'const-string (/[a-z]+ )?(v\d+|p\d+), "(.*)"$', line)
        if m:
            regs[m.group(2)] = unescape(m.group(3))
            continue

        m = re.match(r"new-instance (v\d+|p\d+), (L[^;]+;)", line)
        if m:
            pending_new = short(m.group(2))
            cls_regs[m.group(1)] = pending_new
            continue

        m = re.match(r"invoke-static \{([^}]*)\}, L([^;]+);->(\w+)\((.*)\)", line)
        if m:
            argv = [a.strip() for a in m.group(1).split(",")]
            owner = m.group(2).replace("/", ".")
            name = m.group(3)
            sig = m.group(4)

            # findClass(String, ClassLoader)：结果寄存器等 move-result-object
            if name == "findClass" and sig.startswith("Ljava/lang/String;"):
                pending_find = regs.get(argv[0], "?")
                continue

            if name == "hookM" and owner.endswith("GmEntry"):
                emit("hookM|%s|%s|%s" % (
                    regs.get(argv[1], "?"), regs.get(argv[2], "?"), short_str(regs.get(argv[3], "?"))))
            elif name == "hookC2" and owner.endswith("GmEntry"):
                emit("hookC2|%s|%s" % (regs.get(argv[1], "?"), short_str(regs.get(argv[2], "?"))))
            elif name == "hookPickAll" and owner.endswith("GmEntry"):
                out.extend(pick_events)          # ← 按调用点顺序吐出来
            elif name == "findAndHookMethod":
                emit("findAndHookMethod|%s|%s|%s" % (
                    regs.get(argv[0], "?"), regs.get(argv[2], "?"), pending_new or "?"))
                pending_new = None
            elif name == "findAndHookConstructor":
                emit("findAndHookConstructor|%s|-|%s" % (regs.get(argv[0], "?"), pending_new or "?"))
                pending_new = None
            elif name == "hookAllConstructors":
                c = cls_regs.get(argv[0]) or regs.get(argv[0], "?")
                emit("hookAllConstructors|%s|-|%s" % (short_str(c), pending_new or "?"))
                pending_new = None
            elif name == "hookAllMethods":
                c = cls_regs.get(argv[0]) or regs.get(argv[0], "?")
                emit("hookAllMethods|%s|%s|%s" % (short_str(c), regs.get(argv[1], "?"), pending_new or "?"))
                pending_new = None
            continue

        m = re.match(r"move-result-object (v\d+|p\d+)", line)
        if m and pending_find is not None:
            cls_regs[m.group(1)] = pending_find
            pending_find = None

    print("\n".join(out))


if __name__ == "__main__":
    main(sys.argv[1])

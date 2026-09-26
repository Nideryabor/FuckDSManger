#!/usr/bin/env python3
"""
dexinfo.py —— 只读 dex 的「类定义表」🐲

为什么需要它：**字符串搜索分不清「定义」和「引用」**。
`b"com/nidyaber/fuckdsmanger/gm/GmCrashHook" in dex` 为 True 只说明 dex 里提到过这个名字
（可能只是别的类引用它），不代表这个类就在这个 dex 里。

这个工具按 dex 头部 → class_defs → type_ids → string_ids 走一遍，
给出**真正被定义**的类描述符集合。用于出包前的自检：

  · 底座 dex 是否真的定义了入口要用的那些类
  · 我们新编的 dex 与底座 dex 有没有**同名类**（同名 = 谁被加载取决于 dex 顺序 = 随机行为）
"""
import collections
import struct


def _mutf8(data, off):
    n = 0
    shift = 0
    p = off
    while True:
        b = data[p]
        p += 1
        n |= (b & 0x7F) << shift
        shift += 7
        if not (b & 0x80):
            break
    end = data.index(b"\x00", p)
    return data[p:end].decode("utf-8", "replace")


def defined_classes(data):
    """→ set[str]，形如 {'Lcom/foo/Bar;', 'Lcom/foo/Bar$1;', ...}"""
    if len(data) < 0x70 or data[:4] not in (b"dex\n",):
        raise ValueError("不是 dex（magic=%r）" % data[:8])
    string_ids_size, string_ids_off = struct.unpack_from("<II", data, 0x38)
    type_ids_size, type_ids_off = struct.unpack_from("<II", data, 0x40)
    class_defs_size, class_defs_off = struct.unpack_from("<II", data, 0x60)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    def type_at(i):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        return string_at(idx)

    out = set()
    for i in range(class_defs_size):
        # class_def_item: class_idx | access | superclass | interfaces | source_file |
        #                 annotations | class_data | static_values   （8 × u4 = 32 B）
        (class_idx,) = struct.unpack_from("<I", data, class_defs_off + 32 * i)
        out.add(type_at(class_idx))
    return out


def hierarchy(data):
    """→ {class_desc: super_desc}（只取类定义表里的 superclass）。

    用途：查「父类闭包」——某个类被找到、但它的父类不在任何 dex 里时，
    运行时的表现是 `ClassNotFoundException 这个类` + `Suppressed: NoClassDefFoundError 父类`，
    非常容易误判成"这个类本身没打进去"。
    """
    if len(data) < 0x70 or data[:4] != b"dex\n":
        raise ValueError("不是 dex")
    string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
    type_ids_off = struct.unpack_from("<I", data, 0x44)[0]
    class_defs_size, class_defs_off = struct.unpack_from("<II", data, 0x60)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    def type_at(i):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        return string_at(idx)

    out = {}
    for i in range(class_defs_size):
        class_idx, _acc, super_idx = struct.unpack_from("<III", data, class_defs_off + 32 * i)
        cls = type_at(class_idx)
        sup = type_at(super_idx) if super_idx != 0xFFFFFFFF else None
        out[cls] = sup
    return out


def referenced_types(data):
    """dex 的 type_ids 全集 = 这个 dex **引用到**的所有类型描述符。

    ★ 这比"父类闭包"强得多：`SimpleArrayMap` 那种只在构造函数体里用到的类型，
    不在任何类的 superclass 链上 —— 只查父类会漏掉它（实测栽过一次：
    `NoClassDefFoundError: androidx.collection.SimpleArrayMap`）。
    """
    if len(data) < 0x70 or data[:4] != b"dex\n":
        raise ValueError("不是 dex")
    string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
    type_ids_size, type_ids_off = struct.unpack_from("<II", data, 0x40)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    out = set()
    for i in range(type_ids_size):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        out.add(string_at(idx))
    return out


def missing_types(dex_list):
    """→ [(缺的类型, 引用它的 dex 序号)]：跨全部 dex 求并集后仍找不到的类型。"""
    defined = set()
    refs = []
    for i, d in enumerate(dex_list):
        defined |= set(defined_classes(d).keys()) if isinstance(defined_classes(d), dict) \
            else defined_classes(d)
        refs.append(referenced_types(d))
    out = []
    for i, rs in enumerate(refs):
        for t in sorted(rs):
            if t in defined or t.startswith(_FW):
                continue
            out.append((t, i + 1))
    return out


# 框架/系统类不需要出现在我们的 dex 里
#   · `de/robv/android/xposed/` —— 模块 API，由 LSPosed 在宿主进程提供
#   · `androidx/window/extensions|sidecar|core` —— **由 OEM/系统提供**（AndroidX 的窗口扩展接口）
#   · `org/xmlpull/` —— boot classpath 里就有
_FW = ("Landroid/", "Ljava/", "Ljavax/", "Ldalvik/", "Lorg/xml/", "Lorg/json/",
       "Lorg/w3c/", "Lorg/xmlpull/", "Lsun/", "Ljdk/", "Lorg/apache/",
       "Lde/robv/android/xposed/",
       "Landroidx/window/extensions/", "Landroidx/window/sidecar/", "Landroidx/window/core/",
       "Ljava")

# 「可以缺」的：可选集成，跑不到那条路就不用
_BENIGN = ("Lio/reactivex/",)

_PRIM = ("B", "C", "D", "F", "I", "J", "S", "V", "Z")


def missing_supers(dex_list):
    """→ [(类, 缺失的父类)]：跨全部 dex 求并集后仍然找不到父类的那些类。"""
    defined, supers = set(), {}
    for d in dex_list:
        h = hierarchy(d)
        defined |= set(h.keys())
        supers.update(h)
    out = []
    for c, s in supers.items():
        if s is None or s in defined:
            continue
        if s.startswith(_FW):
            continue
        out.append((c, s))
    return out


def referenced_types(data):
    """→ set[str]：dex 里**被引用过的所有类型描述符**（字段类型 / 方法签名 / 代码里的一切）。

    这比"只查父类"强：`androidx.collection.SimpleArrayMap` 这种**构造器里用到**的类型，
    父类检查看不到，但它缺了照样在 `<init>` 里炸。
    """
    if len(data) < 0x70 or data[:4] != b"dex\n":
        raise ValueError("不是 dex")
    string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
    type_ids_size, type_ids_off = struct.unpack_from("<II", data, 0x40)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    out = set()
    for i in range(type_ids_size):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        out.add(string_at(idx))
    return out


def missing_types(dex_list):
    """→ [类型]：被引用、但既没定义、也不是框架/白名单类型的那些（⑪ 用）。

    「引用闭包」的检查 —— 装上必然 NoClassDefFoundError 的包，只有它能提前发现。
    比父类闭包强：方法体里引用到的类型（如 `androidx.collection.SimpleArrayMap`）也在 `type_ids` 里。
    """
    defined, refs = set(), set()
    for d in dex_list:
        defined |= set(hierarchy(d).keys())
        refs |= referenced_types(d)
    out = []
    for t in sorted(refs):
        if t in defined or t.startswith(_FW) or t.startswith(_BENIGN) or t.startswith("["):
            continue
        if len(t) == 1 or t in _PRIM:          # B/C/D/F/I/J/S/V/Z = 基本类型，不是类
            continue
        out.append(t)
    return out


# 兼容旧名字（我先前写的脚本用过 missing_refs）
missing_refs = missing_types


def referenced_types(data):
    """→ set：这个 dex **引用过**的全部类型（type_ids 整张表）。

    比只看父类强得多：`SimpleArrayMap` 不是谁的父类，它只是
    `ComponentActivity.<init>` 方法体里用到的一个类型 —— 父类闭包检查看不见它，
    但运行时会 `NoClassDefFoundError`。
    """
    string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
    type_ids_size, type_ids_off = struct.unpack_from("<II", data, 0x40)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    out = set()
    for i in range(type_ids_size):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        out.add(string_at(idx))
    return out


# 基本类型/void 的描述符（不是类，不该拿去查）
_PRIM = {"V", "Z", "B", "C", "S", "I", "J", "F", "D"}

# 明确「可以不打包」的类型（可选/仅编译期/ JVM 专用）
_OPTIONAL = ("Lcom/squareup/javapoet/", "Lkotlin/io/path/", "Lkotlin/reflect/",
             "Lorg/intellij/", "Lorg/jetbrains/", "Landroidx/compose/ui/tooling/",
             "Landroidx/compose/runtime/tooling/", "Lkotlinx/coroutines/debug/",
             "Landroidx/profileinstaller/", "Landroidx/tracing/",
             # 可选集成（我们没打的适配器）：RxJava / Guava / Auto / coroutines-rx
             "Lio/reactivex/", "Lcom/google/common/", "Lcom/google/auto/",
             "Lkotlinx/coroutines/rx2/", "Lkotlinx/coroutines/rx3/",
             "Lkotlinx/coroutines/guava/", "Lkotlinx/coroutines/reactive/")


def _norm_type(t):
    """数组 → 元素类型；基本类型 → None（这些不需要"定义"）"""
    while t.startswith("["):
        t = t[1:]
    return None if t in _PRIM else t


def referenced_fields(data):
    """→ [(类描述符, 字段名, 字段类型)]：method/field 引用里出现的**字段**。

    用途：给"被引用但确实拿不到真值"的 R 类**生成占位类**时，
    要按**被引用到的字段名**生成（不能瞎编字段名）。
    """
    if len(data) < 0x70 or data[:4] != b"dex\n":
        raise ValueError("不是 dex")
    string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
    type_ids_off = struct.unpack_from("<I", data, 0x44)[0]
    field_ids_size, field_ids_off = struct.unpack_from("<II", data, 0x50)

    def string_at(i):
        (off,) = struct.unpack_from("<I", data, string_ids_off + 4 * i)
        return _mutf8(data, off)

    def type_at(i):
        (idx,) = struct.unpack_from("<I", data, type_ids_off + 4 * i)
        return string_at(idx)

    out = []
    for i in range(field_ids_size):
        cls, typ, name = struct.unpack_from("<HHI", data, field_ids_off + 8 * i)
        out.append((type_at(cls), string_at(name), type_at(typ)))
    return out


def missing_refs(dex_list):
    """→ [(类型, 引用它的 dex 数)]：被引用、但既不定义在我们 dex 里、
    也不属于框架白名单的类型。**这就是"装上去才会炸"的完整清单。**"""
    defined = set()
    refs = collections.Counter()
    for d in dex_list:
        defined |= set(hierarchy(d).keys())
        for raw in referenced_types(d):
            t = _norm_type(raw)
            if t:
                refs[t] += 1
    out = []
    for t, n in refs.items():
        if t in defined or t.startswith(_FW) or t.startswith(_OPTIONAL):
            continue
        out.append((t, n))
    out.sort(key=lambda x: -x[1])
    return out


def find_res_ids(data):
    """扫 dex 里疑似「硬编码的资源 id」常量（0x7f****** / 0x7e******）。"""
    out = set()
    for op, size in ((b"\x13\x00", 2), (b"\x14\x00", 4)):
        pos = 0
        while True:
            i = data.find(op, pos)
            if i < 0:
                break
            v = int.from_bytes(data[i + 2:i + 2 + size], "little")
            if 0x7E000000 <= v <= 0x7FFFFFFF:
                out.add(v)
            pos = i + 1
    return out


if __name__ == "__main__":
    import sys
    import zipfile

    for path in sys.argv[1:]:
        with open(path, "rb") as f:
            head = f.read(8)
        if head[:4] == b"dex\n":
            data = open(path, "rb").read()
            cs = defined_classes(data)
            print("%s : %d 个类定义, 资源常量 %d 个" % (path, len(cs), len(find_res_ids(data))))
        else:
            z = zipfile.ZipFile(path)
            for n in z.namelist():
                if n.startswith("classes") and n.endswith(".dex"):
                    d = z.read(n)
                    try:
                        cs = defined_classes(d)
                    except Exception as e:
                        print("  %s %s → 解析失败 %s" % (path, n, e))
                        continue
                    print("  %-16s %9d B  %4d 个类定义  资源常量 %d 个"
                          % (n, len(d), len(cs), len(find_res_ids(d))))

#!/usr/bin/env python3
"""
axml.py —— 自己造的 Android 二进制 XML（AXML）编解码器 🐲

为什么要有它：这个沙箱里没有 aapt2（`apt` 里也没有 android-sdk-build-tools），
要「从头自己造 APK」就必须自己会写 AndroidManifest.xml。

格式（从 2.22.110 的真实 manifest 逐字节读出来的）：
  ResXMLTree_header          03 00 | 08 00 | size
  ResStringPool (UTF-8)      01 00 | 1C 00 | size | count | styleCount | flags=0x100 |
                             stringsStart | stylesStart | offsets[] | data
      ★ data 里每个串是： [UTF-16 长度][UTF-8 长度][UTF-8 字节][00]
        （ASCII 时两个长度相同，所以看着像"长度写了两遍"——这是 aapt2 的写法）
  ResXMLTree_resourceMap     80 01 | 08 00 | size | ids[]      ← 只覆盖池子开头的属性名
  ResXMLTree_node 系列       00 01 namespace / 02 01 element / 03 01 end / 01 01 endns
      element 的 body: ns | name | attrStart(0x14) | attrSize(0x14) | attrCount |
                       idIndex | classIndex | styleIndex | 属性[]
      attribute: ns | name | rawValue | {u16 size=8, u8 res0=0, u8 dataType, u32 data}
"""
import struct

RES_XML_TYPE = 0x0003
RES_STRING_POOL_TYPE = 0x0001
RES_XML_RESOURCE_MAP_TYPE = 0x0180
RES_XML_START_NAMESPACE_TYPE = 0x0100
RES_XML_END_NAMESPACE_TYPE = 0x0101
RES_XML_START_ELEMENT_TYPE = 0x0102
RES_XML_END_ELEMENT_TYPE = 0x0103

TYPE_REFERENCE = 0x01
TYPE_STRING = 0x03
TYPE_INT_DEC = 0x10
TYPE_INT_HEX = 0x11
TYPE_INT_BOOLEAN = 0x12

NO_INDEX = 0xFFFFFFFF


# ----------------------------------------------------------------- 编码

def enc_len(n):
    """UTF-8 池里的变长长度：>0x7F 时首位带上 0x80。"""
    out = b""
    if n > 0x7F:
        out += bytes([(n >> 8) | 0x80])
    out += bytes([n & 0xFF])
    return out


class Pool:
    def __init__(self):
        self.strings = []
        self.index = {}

    def add(self, s):
        if s in self.index:
            return self.index[s]
        self.index[s] = len(self.strings)
        self.strings.append(s)
        return self.index[s]

    def chunk(self):
        data = b""
        offsets = []
        for s in self.strings:
            offsets.append(len(data))
            raw = s.encode("utf-8")
            u16len = len(s.encode("utf-16-le")) // 2
            data += enc_len(u16len) + enc_len(len(raw)) + raw + b"\x00"
        while len(data) % 4:
            data += b"\x00"
        n = len(self.strings)
        strings_start = 28 + 4 * n                     # header(28) + offsets[]
        size = strings_start + len(data)
        out = struct.pack("<HHI", RES_STRING_POOL_TYPE, 28, size)
        out += struct.pack("<IIIII", n, 0, 0x100, strings_start, 0)
        out += b"".join(struct.pack("<I", o) for o in offsets)
        return out + data


def resmap_chunk(ids):
    out = struct.pack("<HHI", RES_XML_RESOURCE_MAP_TYPE, 8, 8 + 4 * len(ids))
    return out + b"".join(struct.pack("<I", i) for i in ids)


def _node(ctype, line, body):
    return struct.pack("<HHIII", ctype, 0x10, 0x10 + len(body), line, NO_INDEX) + body


def start_ns(line, prefix, uri):
    return _node(RES_XML_START_NAMESPACE_TYPE, line, struct.pack("<II", prefix, uri))


def end_ns(line, prefix, uri):
    return _node(RES_XML_END_NAMESPACE_TYPE, line, struct.pack("<II", prefix, uri))


def start_element(line, ns, name, attrs):
    body = struct.pack("<II", ns, name)
    body += struct.pack("<HHH", 20, 20, len(attrs))     # attrStart / attrSize / attrCount
    body += struct.pack("<HHH", 0, 0, 0)                # idIndex / classIndex / styleIndex
    for (ans, aname, araw, atype, adata) in attrs:
        body += struct.pack("<III", ans, aname, araw)
        body += struct.pack("<HBBI", 8, 0, atype, adata)
    return _node(RES_XML_START_ELEMENT_TYPE, line, body)


def end_element(line, ns, name):
    return _node(RES_XML_END_ELEMENT_TYPE, line, struct.pack("<II", ns, name))


def build(pool, rm_ids, nodes):
    body = pool.chunk() + resmap_chunk(rm_ids) + b"".join(nodes)
    return struct.pack("<HHI", RES_XML_TYPE, 8, 8 + len(body)) + body


# --------------------------------------------------------- 通用重建（改任意 APK 的清单）

ANDROID_NS = "http://schemas.android.com/apk/res/android"

# android 属性的资源 id。**重建 resourceMap 时只认这张表里的名字**（不认识的会直接报错，
# 绝不静默写坏一个清单）。不够用就往这里加。
ANDROID_ATTR_ID = {
    "theme": 0x01010000, "label": 0x01010001, "icon": 0x01010002, "name": 0x01010003,
    "permission": 0x01010006, "enabled": 0x0101000E, "debuggable": 0x0101000F,
    "exported": 0x01010010, "process": 0x01010011, "taskAffinity": 0x01010012,
    "excludeFromRecents": 0x01010017, "authorities": 0x01010018,
    "grantUriPermissions": 0x0101001B, "launchMode": 0x0101001D,
    "targetPackage": 0x01010021, "targetActivity": 0x01010022,
    "value": 0x01010024, "resource": 0x01010025,
    "minSdkVersion": 0x0101020C, "versionCode": 0x0101021B, "versionName": 0x0101021C,
    "targetSdkVersion": 0x01010270, "allowBackup": 0x01010280, "supportsRtl": 0x010103AF,
    "extractNativeLibs": 0x010104EA, "compileSdkVersion": 0x01010572,
    "compileSdkVersionCodename": 0x01010573, "appComponentFactory": 0x0101057A,
}


def collect_attr_ids(pool, ev):
    """从「已解码的清单」里回收 `属性名 → android 资源 id`（resourceMap 只覆盖池子开头）。

    注意：拿回来的 id 里，**不在 ANDROID_ATTR_ID 表内的名字也会被收进来**（来源文件自己带），
    所以「原样重建」不会被表不全卡住；只有「新加一个表里没有的属性」才会报错。
    """
    out = dict(ANDROID_ATTR_ID)
    for e in ev:
        if e[0] == "resmap":
            for i, rid in enumerate(e[1]):
                if i < len(pool):
                    out[pool[i]] = rid
    return out


def rebuild(pool, ev, attr_ids):
    """把 decode() 出来的事件列表重新编码成 AXML（结构可以任意改：加节点、加属性都行）。

    ★ resourceMap 只能覆盖池子**开头连续一段**字符串 ⇒ 这里先把所有 android 属性名
      排在池子最前面，再按同样顺序写 resourceMap。

    ★ 字符串型属性（TYPE_STRING）的 data 是**池子下标**，换了池子必须重新映射
      —— 漏了这一步，清单会「看着对、装上去全错」。
    """
    attr_order = []
    for e in ev:
        if e[0] == "start":
            for (ans, aname, araw, atype, adata) in e[4]:
                if ans == ANDROID_NS and aname not in attr_order:
                    attr_order.append(aname)
    missing = [n for n in attr_order if n not in attr_ids]
    if missing:
        raise KeyError("缺这些 android 属性的资源 id，无法重建 resourceMap：%s" % missing)

    # ★★★ resourceMap **必须按资源 id 升序**（aapt2 一直这么写）。
    # 按"属性出现顺序"写会得到一个乱序的 resmap ⇒ 平台查属性时**有的查得到、有的查不到**，
    # 查不到的那个就静默掉回默认值 —— 实测症状：provider 的 android:exported="true" 变成 exported=false。
    # （aapt2 dump 看不出来：它是拿名字反查 resmap，顺序无关。）
    attr_order.sort(key=lambda n: attr_ids[n])

    p = Pool()
    for n in attr_order:
        p.add(n)
    rm_ids = [attr_ids[n] for n in attr_order]
    assert rm_ids == sorted(rm_ids), "resmap 不是升序，重建逻辑错了"

    remap = {i: p.add(s) for i, s in enumerate(pool)}

    nodes = []
    for e in ev:
        k = e[0]
        if k == "resmap":
            continue
        if k in ("ns+", "ns-"):
            _, line, prefix, uri = e
            fn = start_ns if k == "ns+" else end_ns
            nodes.append(fn(line, p.add(prefix), p.add(uri)))
        elif k == "start":
            _, line, ns, name, attrs = e
            # ★★★ 元素内的属性**按资源 id 升序**（aapt2 一直这么写）。
            # 平台是按 id 顺序扫属性表的 —— 顺序一乱就整段错位、**漏掉属性**，
            # 漏掉的那个就变成"没定义"（实测：provider 的 android:exported 被读成 false、
            # 设置页的 android:exported 直接让安装失败）。
            #   aapt2：name(…03) exported(…10) authorities(…18) grantUriPermissions(…1b)  ← 升序
            #   我们：name(…03) authorities(…18) exported(…10) grantUriPermissions(…1b)  ← 乱序 ⇒ 炸
            # 没有资源 id 的属性（如 manifest 上的 package）排在最后，保持原相对顺序。
            ordered = sorted(attrs, key=lambda t: attr_ids[t[1]] if t[0] == ANDROID_NS
                             and t[1] in attr_ids else 0xFFFFFFFF)
            out = []
            for (ans, aname, araw, atype, adata) in ordered:
                if atype == TYPE_STRING and adata != NO_INDEX:
                    adata = remap[adata]
                out.append((p.add(ans) if ans else NO_INDEX,
                            p.add(aname) if aname else NO_INDEX,
                            p.add(araw) if araw is not None else NO_INDEX,
                            atype, adata))
            nodes.append(start_element(line, p.add(ns) if ns else NO_INDEX, p.add(name), out))
        elif k == "end":
            _, line, ns, name = e
            nodes.append(end_element(line, p.add(ns) if ns else NO_INDEX, p.add(name)))
        else:
            raise AssertionError("不认识的 AXML 事件：%r" % (k,))
    return build(p, rm_ids, nodes)


# ----------------------------------------------------------------- 解码（校验用）

def _read_len(buf, pos):
    b0 = buf[pos]
    if b0 & 0x80:
        return ((b0 & 0x7F) << 8) | buf[pos + 1], pos + 2
    return b0, pos + 1


def decode_string_pool(buf, pos):
    ctype, hsize, size = struct.unpack_from("<HHI", buf, pos)
    assert ctype == RES_STRING_POOL_TYPE, hex(ctype)
    count, style_count, flags, sstart, ststart = struct.unpack_from("<IIIII", buf, pos + 8)
    utf8 = bool(flags & 0x100)
    offsets = struct.unpack_from("<%dI" % count, buf, pos + 28)
    base = pos + sstart
    out = []
    for off in offsets:
        p = base + off
        if utf8:
            u16len, p = _read_len(buf, p)
            u8len, p = _read_len(buf, p)
            out.append(buf[p:p + u8len].decode("utf-8"))
        else:
            # UTF-16 池：长度单位是「UTF-16 码元」，长度字段**固定 2 字节**
            # （不是 UTF-8 那种 1/2 字节变长；写错就会整体错位一个字节 ⇒ 全变成乱码）
            n = struct.unpack_from("<H", buf, p)[0]
            p += 2
            if n & 0x8000:
                n2 = struct.unpack_from("<H", buf, p)[0]
                p += 2
                n = ((n & 0x7FFF) << 16) | n2
            out.append(buf[p:p + n * 2].decode("utf-16-le"))
    return out, pos + size


def decode(data):
    """→ (strings, 事件列表)，事件用元组表示，方便跟预期比对。"""
    assert struct.unpack_from("<H", data, 0)[0] == RES_XML_TYPE
    pool, pos = decode_string_pool(data, 8)
    ev = []
    while pos < len(data):
        ctype, hsize, size = struct.unpack_from("<HHI", data, pos)
        if ctype == RES_XML_RESOURCE_MAP_TYPE:
            n = (size - 8) // 4
            ev.append(("resmap", struct.unpack_from("<%dI" % n, data, pos + 8)))
        elif ctype in (RES_XML_START_NAMESPACE_TYPE, RES_XML_END_NAMESPACE_TYPE):
            line, = struct.unpack_from("<I", data, pos + 8)
            a, b = struct.unpack_from("<II", data, pos + 16)
            ev.append(("ns+" if ctype == RES_XML_START_NAMESPACE_TYPE else "ns-",
                       line, pool[a], pool[b]))
        elif ctype == RES_XML_START_ELEMENT_TYPE:
            line, = struct.unpack_from("<I", data, pos + 8)
            ns, name, astart, asize, acount = struct.unpack_from("<IIHHH", data, pos + 16)
            attrs = []
            ap = pos + 16 + astart
            for _ in range(acount):
                ans, aname, araw = struct.unpack_from("<III", data, ap)
                tsize, res0, dtype, ddata = struct.unpack_from("<HBBI", data, ap + 12)
                attrs.append((
                    pool[ans] if ans != NO_INDEX else "",
                    pool[aname] if aname != NO_INDEX else "",
                    pool[araw] if araw != NO_INDEX else None,
                    dtype, ddata))
                ap += asize
            ev.append(("start", line, pool[ns] if ns != NO_INDEX else "", pool[name], attrs))
        elif ctype == RES_XML_END_ELEMENT_TYPE:
            line, = struct.unpack_from("<I", data, pos + 8)
            ns, name = struct.unpack_from("<II", data, pos + 16)
            ev.append(("end", line, pool[ns] if ns != NO_INDEX else "", pool[name]))
        else:
            raise AssertionError("未知 chunk: %#x" % ctype)
        pos += size
    return pool, ev


# ----------------------------------------------------------------- 我们的 manifest

# 属性名必须排在池子最前面（resourceMap 只覆盖开头这几个），顺序照抄 aapt2 的产物
ATTR_NAMES = [
    ("label", 0x01010001),
    ("icon", 0x01010002),
    ("name", 0x01010003),
    ("value", 0x01010024),
    ("resource", 0x01010025),
    ("minSdkVersion", 0x0101020C),
    ("versionCode", 0x0101021B),
    ("versionName", 0x0101021C),
    ("targetSdkVersion", 0x01010270),
    ("extractNativeLibs", 0x010104EA),
    ("compileSdkVersion", 0x01010572),
    ("compileSdkVersionCodename", 0x01010573),
]

ANDROID_NS = "http://schemas.android.com/apk/res/android"


def build_manifest(version_code, version_name, package,
                   label_ref, icon_ref, desc_ref, scope_ref,
                   min_sdk=26, target_sdk=30, compile_sdk=30, sdk_codename="11",
                   lines=None):
    """
    lines 的默认值 = 2.22.110 那份真 manifest 里的行号（aapt2 的规矩：end 标签复用 start 的行号），
    对齐它才能做到「重编码后逐字节相同」。
    """
    L = {"manifest": 2, "uses_sdk": 3, "application": 5,
         "md1": 6, "md2": 8, "md3": 10, "md4": 12, "ns": 2, "ns_end": 2}
    if lines:
        L.update(lines)

    p = Pool()
    ids = []
    for name, rid in ATTR_NAMES:
        p.add(name)
        ids.append(rid)

    i_11 = p.add(sdk_codename)
    i_vn = p.add(version_name)
    i_ns = p.add("android")
    i_app = p.add("application")
    i_pkg = p.add(package)
    i_url = p.add(ANDROID_NS)
    i_manifest = p.add("manifest")
    i_metadata = p.add("meta-data")
    i_package = p.add("package")
    i_pbc = p.add("platformBuildVersionCode")
    i_pbn = p.add("platformBuildVersionName")
    i_usessdk = p.add("uses-sdk")
    i_xdesc = p.add("xposeddescription")
    i_xmin = p.add("xposedminversion")
    i_xmod = p.add("xposedmodule")
    i_xscope = p.add("xposedscope")

    A = lambda k: p.index[k]           # 属性名下标
    NS = i_url                          # android 命名空间下标

    nodes = [
        start_ns(L["ns"], i_ns, i_url),
        start_element(L["manifest"], NO_INDEX, i_manifest, [
            (NS, A("versionCode"), NO_INDEX, TYPE_INT_DEC, version_code),
            (NS, A("versionName"), i_vn, TYPE_STRING, i_vn),
            (NS, A("compileSdkVersion"), NO_INDEX, TYPE_INT_DEC, compile_sdk),
            (NS, A("compileSdkVersionCodename"), i_11, TYPE_STRING, i_11),
            (NO_INDEX, i_package, i_pkg, TYPE_STRING, i_pkg),
            (NO_INDEX, i_pbc, NO_INDEX, TYPE_INT_DEC, compile_sdk),
            (NO_INDEX, i_pbn, NO_INDEX, TYPE_INT_DEC, int(sdk_codename)),
        ]),
        start_element(L["uses_sdk"], NO_INDEX, i_usessdk, [
            (NS, A("minSdkVersion"), NO_INDEX, TYPE_INT_DEC, min_sdk),
            (NS, A("targetSdkVersion"), NO_INDEX, TYPE_INT_DEC, target_sdk),
        ]),
        end_element(L["uses_sdk"], NO_INDEX, i_usessdk),
        start_element(L["application"], NO_INDEX, i_app, [
            (NS, A("label"), NO_INDEX, TYPE_REFERENCE, label_ref),
            (NS, A("icon"), NO_INDEX, TYPE_REFERENCE, icon_ref),
            (NS, A("extractNativeLibs"), NO_INDEX, TYPE_INT_BOOLEAN, 0),
        ]),
        start_element(L["md1"], NO_INDEX, i_metadata, [
            (NS, A("name"), i_xmod, TYPE_STRING, i_xmod),
            (NS, A("value"), NO_INDEX, TYPE_INT_BOOLEAN, 0xFFFFFFFF),
        ]),
        end_element(L["md1"], NO_INDEX, i_metadata),
        start_element(L["md2"], NO_INDEX, i_metadata, [
            (NS, A("name"), i_xdesc, TYPE_STRING, i_xdesc),
            (NS, A("value"), NO_INDEX, TYPE_REFERENCE, desc_ref),
        ]),
        end_element(L["md2"], NO_INDEX, i_metadata),
        start_element(L["md3"], NO_INDEX, i_metadata, [
            (NS, A("name"), i_xmin, TYPE_STRING, i_xmin),
            (NS, A("value"), NO_INDEX, TYPE_INT_DEC, 53),
        ]),
        end_element(L["md3"], NO_INDEX, i_metadata),
        start_element(L["md4"], NO_INDEX, i_metadata, [
            (NS, A("name"), i_xscope, TYPE_STRING, i_xscope),
            (NS, A("resource"), NO_INDEX, TYPE_REFERENCE, scope_ref),
        ]),
        end_element(L["md4"], NO_INDEX, i_metadata),
        end_element(L["application"], NO_INDEX, i_app),
        end_element(L["manifest"], NO_INDEX, i_manifest),
        end_ns(L["ns_end"], i_ns, i_url),
    ]
    return build(p, ids, nodes)


if __name__ == "__main__":
    import sys
    d = build_manifest(442, "2.22.111", "com.little_femaleboy.cannot_show.the_big_won_whale",
                       0x7F040000, 0x7F030000, 0x7F040001, 0x7F010000)
    print("生成 %d 字节" % len(d))
    pool, ev = decode(d)
    for e in ev:
        print(" ", e)

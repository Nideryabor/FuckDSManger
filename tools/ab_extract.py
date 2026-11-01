#!/usr/bin/env python3
# 从 MMKV 里抽宿主「全量灰测配置」🐲 2026-11-01
#
# 发现（重要）：
#   火山 AppLog 拉到的 AB 配置**最终是明文落在 MMKV 的 `kv_remote_settings_*`** ——
#   `tab.volces.com/service/2/abtest_config/` 那个密文只是**传输形态**，
#   到本地已经被 SDK 解好并存下来了。
#   ⇒ 不需要逆 .so、不需要 hook 解密函数，读 MMKV 就够。
#
# 键的两个形态：
#   kv_remote_settings_id_<key>  = A/B 分组号（varint 编码的 vid）
#   kv_remote_settings_<key>     = 实际值（MMKV 自带类型标记）
#
# MMKV 的 value 前面有一个类型字节（protobuf wire type）：
#   0x00 = bool false / 数字 0
#   0x01 = 数字 1
#   其他 = 长度前缀（varint）后面跟内容
#
# ⚠️ MMKV 是 **append-only**：同一个 key 会出现多次，**最后一条才是当前值**。
import sys, json, struct

def read_varint(d, i, n):
    r = 0; s = 0
    while i < n:
        b = d[i]; i += 1
        r |= (b & 0x7F) << s
        if not (b & 0x80):
            break
        s += 7
    return r, i

def parse_raw(path):
    """返回 [(key, value_bytes)]，保持文件顺序。"""
    d = open(path, 'rb').read()
    n = len(d); i = 0; out = []
    while i < n:
        start = i
        try:
            klen, i = read_varint(d, i, n)
            if klen == 0 or klen > 512 or i + klen > n:
                i = start + 1; continue
            key = d[i:i + klen]; i += klen
            try:
                ks = key.decode('utf-8')
            except UnicodeDecodeError:
                i = start + 1; continue
            if any(ord(c) < 0x20 for c in ks):
                i = start + 1; continue
            vlen, i = read_varint(d, i, n)
            if i + vlen > n:
                i = start + 1; continue
            out.append((ks, d[i:i + vlen]))
            i += vlen
        except Exception:
            i = start + 1
    return out

def decode_val(v):
    """把 MMKV 的 value bytes 解成 Python 值。

    MMKV（MiniPBCoder）的编码规则：value 就是「一个 varint 长度 + 内容」。
      · 长度 0  ⇒ 空串
      · 长度 1 且内容 0x00/0x01 ⇒ bool
      · 其余      ⇒ 内容按 utf-8 当字符串
    例外：单个字节的 value（如 0x01）是「整数 1」的紧凑写法。
    """
    if len(v) == 0:
        return ""
    if len(v) == 1:
        return v[0] != 0
    try:
        ln, j = read_varint(v, 0, len(v))
        body = v[j:]
        if ln == len(body):
            try:
                s = body.decode('utf-8')
                if s and all(ord(c) >= 32 or c in '\n\r\t' for c in s):
                    return s
            except UnicodeDecodeError:
                pass
            # 不是合法 utf-8 ⇒ 可能是 float/复数，往下走
    except Exception:
        pass
    # ★ 顺序很重要（踩过）：必须先试 varint，再试 float。
    #   反例：max_upload_file_size = 104857600 的 varint 正好 4 字节
    #   （80 80 80 32），先当 float 解就变成 0.0。
    try:
        num, j = read_varint(v, 0, len(v))
        if j == len(v):
            return num
    except Exception:
        pass
    if len(v) == 4:
        try:
            return round(struct.unpack('<f', v)[0], 6)
        except Exception:
            pass
    # 兜底：整坨当字符串
    try:
        s = v.decode('utf-8')
        if s and all(ord(c) >= 32 or c in '\n\r\t' for c in s):
            return s
    except UnicodeDecodeError:
        pass
    return '<%d bytes: %s>' % (len(v), v[:32].hex())

def main(path, out_tsv):
    rows = parse_raw(path)
    latest = {}     # key -> value bytes（后面的覆盖前面的）
    order = []
    for k, v in rows:
        if not k.startswith('kv_remote_settings'):
            continue
        if k not in latest:
            order.append(k)
        latest[k] = v

    ab = {}     # 真正的键名 -> {'vid':..., 'val':...}
    for k in order:
        v = latest[k]
        if k.startswith('kv_remote_settings_id_'):
            name = k[len('kv_remote_settings_id_'):]
            if name == '':
                continue
            try:
                vid, _ = read_varint(v, 0, len(v))
            except Exception:
                vid = None
            ab.setdefault(name, {})['vid'] = vid
        elif k.startswith('kv_remote_settings_'):
            name = k[len('kv_remote_settings_'):]
            if name.startswith('id_') or name == '':
                continue
            ab.setdefault(name, {})['val'] = decode_val(v)

    lines = []
    for name in sorted(ab):
        e = ab[name]
        val = e.get('val', None)
        vid = e.get('vid', None)
        if isinstance(val, str):
            shown = val.replace('\n', ' ').replace('\t', ' ')
            if len(shown) > 400:
                shown = shown[:400] + '...(%d chars)' % len(val)
        else:
            shown = repr(val) if val is not None else '<无值>'
        lines.append((name, vid, shown))

    with open(out_tsv, 'w', encoding='utf-8') as f:
        f.write('key\tvid\tvalue\n')
        for name, vid, shown in lines:
            f.write('%s\t%s\t%s\n' % (name, vid, shown))

    print('# 共 %d 个灰测键（MMKV 记录 %d 条）' % (len(lines), len(order)))
    for name, vid, shown in lines:
        print('%-56s vid=%-12s %s' % (name, vid, shown[:120]))

if __name__ == '__main__':
    p = sys.argv[1] if len(sys.argv) > 1 else 'tmp/mmkv272/default.bin'
    o = sys.argv[2] if len(sys.argv) > 2 else 'tmp/ab-all.tsv'
    main(p, o)

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
脱敏.py —— 把抓包 HAR 洗成「可入库版」🐲 尼得亚伯 2026-10-01

为什么要它：
    原始 HAR 里有**活 Token / Cookie / 设备指纹 / 会话正文**。
    本仓远端是 github.com/dxyabab/FuckDSManger.git —— 泄一次就等于公开。
    ⇒ 原始包只放 `抓包/`（已 gitignore）、分析完就删；
      **要写进档案的只能是本脚本产出的脱敏版。**

用法：
    python3 tools/脱敏.py <原始.har> <脱敏.har> [--map 对照表.txt]

特性：
    · 同一原值 → 同一占位符（`<TOKEN-A>` / `<TOKEN-B>`），
      所以脱敏后**仍然能看出"这两条是不是同一个 token"** —— 分析价值不丢。
    · 值按类型分桶：TOKEN / SID / DEV / DUID / TITLE / TEXT / UUID / ID
    · 结尾自检：扫一遍产物，确认原始敏感值**一个都没漏**（有漏就非零退出）
"""
import argparse
import collections
import json
import re
import sys

# ── ① header 名 → 占位符前缀（大小写不敏感）
HDR_MASK = {
    'authorization': 'TOKEN',
    'cookie': 'COOKIE',
    'set-cookie': 'COOKIE',
    'x-auth-token': 'TOKEN',
    'x-settings-token': 'SETTOKEN',
    'x-ds-pow-response': 'POW',
    'user-identity': 'IDENT',
    'x-rangers-id': 'RANGER',
    'appkey': 'APPKEY',
    'key': 'APPKEY',
    'sign': 'SIGN',
    # ── 追踪类：本身不是凭据，但有**指纹价值**（能顺着追到某个人的请求）
    #    我们的目标是"字段名"，值全掩掉最省心 —— 2026-10-01 晚补
    'x-ds-trace-id': 'TRACE',
    'x-dsa-trace-id': 'TRACE',
    'x-tt-logid': 'TRACE',
    'x-tt-trace-tag': 'TRACE',
    'eagleid': 'TRACE',
    'eo-log-uuid': 'TRACE',
    'x-request-id': 'TRACE',
    'ran': 'TRACE',
    'via': 'TRACE',
    'x-ds-served-by': 'TRACE',
    'upstream-caught': 'TRACE',
    # ── IP 类：必须掩
    'x-request-ip': 'IP',
    'x-real-ip': 'IP',
    'x-forwarded-for': 'IP',
    'client-ip': 'IP',
    'x-client-ip': 'IP',
    # ── APM / 埋点自带的身份字段
    'x-tt-logid-tag': 'TRACE',
}

# ── ② URL query 名 → 前缀
Q_MASK = {
    'did': 'DID', 'device_id': 'DEVID', 'iid': 'IID', 'duid': 'DUID',
    'psid': 'PSID', 'uid': 'UID', 'sso_id': 'SSO', 'chat_session_id': 'SESS',
    'device_platform': None, 'aid': None,     # None = 不脱敏（无隐私）
}

# ── ③ JSON 字段名 → 前缀（叶子层精确匹配，或前缀匹配用 _P 结尾的规则）
J_MASK_EXACT = {
    'did': 'DID', 'device_id': 'DEVID', 'iid': 'IID', 'duid': 'DUID',
    'psid': 'PSID', 'uid': 'UID', 'sso_id': 'SSO', 'chat_session_id': 'SESS',
    'parent_message_id': None, 'message_id': 'MSGID', 'id': 'ID',
    'title': 'TITLE', 'prompt': 'TEXT', 'content': 'TEXT',
    'mobile': 'PHONE', 'email': 'EMAIL', 'phone': 'PHONE',
}
J_MASK_REGEX = [
    (re.compile(r'token', re.I), 'TOKEN'),
    (re.compile(r'secret', re.I), 'SECRET'),
    (re.compile(r'password|passwd', re.I), 'PASS'),
]

# ── ④ 通用兜底：长得就像凭据/指纹的裸值
RAW_PATTERNS = [
    (re.compile(r'^[A-Za-z0-9_\-]{20,}\.[A-Za-z0-9_\-]{20,}\.[A-Za-z0-9_\-]{10,}$'), 'JWT'),
    (re.compile(r'^eyJ[A-Za-z0-9_\-]{10,}'), 'JWT'),
    (re.compile(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', re.I), 'UUID'),
    (re.compile(r'^[A-Za-z0-9+/=_\-]{16,}$'), 'BLOB'),
    # PoW 的 challenge / answer（base64，一次性，但一把掩掉更省心）
    (re.compile(r'^[A-Za-z0-9+/]{24,}={0,2}$'), 'BLOB'),
    # hif-*.deepseek.com/query 下发的加密值（形如 "<b64>.<b64>"，设备侧信道）
    (re.compile(r'^[A-Za-z0-9+/]{20,}={0,2}\.[A-Za-z0-9+/]{8,}={0,2}$'), 'BLOB'),
]


class Masker:
    """同一原值 → 同一假名，且按类型分桶编号"""

    def __init__(self):
        self.maps = collections.defaultdict(dict)
        self.audit = collections.Counter()

    def mask(self, kind, value):
        if value is None or value == '':
            return value
        if kind is None:
            return value
        d = self.maps[kind]
        if value not in d:
            d[value] = '<%s-%s>' % (kind, chr(ord('A') + len(d)) if len(d) < 26 else len(d))
            self.audit[kind] += 1
        return d[value]

    def mask_text(self, kind, text):
        """大段文本：只留长度量级，内容全替（会话正文/标题）"""
        if not isinstance(text, str) or not text:
            return text
        key = (kind, text)
        d = self.maps[kind]
        if key not in d:
            d[key] = '<%s-%d字>' % (kind, len(text))
            self.audit[kind] += 1
        return d[key]


def guess(kind_hint, name, value):
    """按字段名猜类型；返回 None 表示不脱敏"""
    if name is not None:
        if name in J_MASK_EXACT:
            return J_MASK_EXACT[name]
        for rx, k in J_MASK_REGEX:
            if rx.search(name):
                return k
    if isinstance(value, str):
        for rx, k in RAW_PATTERNS:
            if rx.match(value):
                return k
    return kind_hint


def mask_json(o, m, key=None):
    if isinstance(o, dict):
        return {k: mask_json(v, m, k) for k, v in o.items()}
    if isinstance(o, list):
        return [mask_json(v, m, key) for v in o]
    if isinstance(o, str):
        k = guess(None, key, o)
        if k:
            if o.strip().startswith(('{', '[')):
                try:
                    return mask_json(json.loads(o), m, key)
                except Exception:
                    pass
            return m.mask(k, o)
    return o


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('src')
    ap.add_argument('dst')
    ap.add_argument('--map', default=None, help='把「占位符 → 原值」对照表写到这个文件（⚠️ 本身也是敏感文件！）')
    a = ap.parse_args()

    h = json.load(open(a.src, encoding='utf-8'))
    m = Masker()
    entries = h['log']['entries']

    for e in entries:
        req, resp = e['request'], e['response']
        for hd in req.get('headers', []):
            k = hd['name'].lower()
            if k in HDR_MASK:
                hd['value'] = m.mask(HDR_MASK[k], hd['value'])
        for hd in resp.get('headers', []):
            k = hd['name'].lower()
            if k in HDR_MASK:
                hd['value'] = m.mask(HDR_MASK[k], hd['value'])
        # query
        u = req['url']
        # ★ path 里长度 ≥16 的十六进制段（zztfly 那种 initSecCdn/1/<appid>/<pkg>/<hash>）
        if '?' in u:
            base, q = u.split('?', 1)
        else:
            base, q = u, ''
        parts = []
        for seg in base.split('/'):
            if re.fullmatch(r'[0-9a-fA-F]{16,}', seg):
                parts.append(m.mask('BLOB', seg))
            else:
                parts.append(seg)
        u = '/'.join(parts)
        if '?' in req['url']:
            _, q = req['url'].split('?', 1)
            segs = []
            for kv in q.split('&'):
                if '=' in kv:
                    n, v = kv.split('=', 1)
                    segs.append('%s=%s' % (n, m.mask(Q_MASK.get(n), v)))
                else:
                    segs.append(kv)
            req['url'] = u + '?' + '&'.join(segs)
        else:
            req['url'] = u
        # bodies
        pd = req.get('postData')
        if pd and isinstance(pd.get('text'), str):
            t = pd['text']
            if t.strip().startswith(('{', '[')):
                try:
                    pd['text'] = json.dumps(mask_json(json.loads(t), m), ensure_ascii=False)
                except Exception:
                    pd['text'] = m.mask_text('BODY', t)
            elif t.strip():
                # ★ 表单 / octet-stream / 二进制：看不出结构 ⇒ 整体替掉
                #   （#39 的 9.3KB 上报体、#22 的 ABTest 体都属于这类，
                #     里面混着 sign / device 指纹，绝不能原样留）
                pd['text'] = m.mask_text('RAWBODY', t)
        rc = resp.get('content', {})
        if isinstance(rc.get('text'), str) and rc['text'].strip().startswith(('{', '[')):
            try:
                rc['text'] = json.dumps(mask_json(json.loads(rc['text']), m), ensure_ascii=False)
            except Exception:
                rc['text'] = m.mask_text('BODY', rc['text'])

    # ── ⑤ 全局兜底：凡"已记录的原值"，无论出现在 URL path / header / 任何角落，
    #      一律替换掉（结构化那几步漏掉的位置全靠这一道）
    raw = json.dumps(h, ensure_ascii=False, indent=1)
    swung = 0
    for kind, d in m.maps.items():
        for orig, fake in d.items():
            s = orig[1] if isinstance(orig, tuple) else orig
            if not isinstance(s, str) or len(s) < 12:
                continue
            if not re.fullmatch(r'[A-Za-z0-9_\-./+=%:]+', s):
                continue          # 含引号/中文/journal 结构字符的，跳过（怕破坏 JSON）
            if s in raw:
                cnt = raw.count(s)
                raw = raw.replace(s, fake)
                swung += cnt
    if swung:
        print('  ⑤ 全局兜底又替换了 %d 处（path / 边角位置）' % swung)
    open(a.dst, 'w', encoding='utf-8').write(raw)

    print('✓ 脱敏完成 →', a.dst)
    print('  替换统计：', dict(m.audit))
    if a.map:
        with open(a.map, 'w', encoding='utf-8') as f:
            f.write('# ⚠️ 本文件含原文，也是敏感文件！只放 抓包/，别入库\n')
            for kind, d in m.maps.items():
                for orig, fake in d.items():
                    if isinstance(orig, tuple):
                        orig = orig[1]
                    f.write('%s\t%s\t%s\n' % (kind, fake, str(orig)[:400]))
        print('  ⚠️ 对照表（含原文）已写 →', a.map, '—— 记得一起删')

    # ── 自检：产物里不许出现任何原值
    out = open(a.dst, encoding='utf-8').read()
    leaked = []
    for kind, d in m.maps.items():
        for orig in d:
            if isinstance(orig, tuple):
                orig = orig[1]
            s = str(orig)
            if len(s) >= 12 and s in out:
                leaked.append((kind, s[:6] + '…'))
    if leaked:
        print('✗✗ 自检失败：还有 %d 个原值残留！' % len(leaked))
        for k, s in leaked[:10]:
            print('   ', k, s)
        sys.exit(1)
    print('✓ 自检通过：原始值 0 残留')


if __name__ == '__main__':
    main()

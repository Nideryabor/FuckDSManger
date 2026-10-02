#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_patch_list.py —— 把两张表交叉，生成"要改哪一行、从什么改成什么"

输入:
  参考/数据/host_2.6.1-重定位映射.tsv   （旧类→新类、旧方法→新方法）
  参考/数据/反射调用清单.tsv             （底座里那些反射字面量）

输出:
  参考/数据/适配-待改清单.tsv
    文件 | 行号 | 类 | 形态 | 字面量 | 类别(类/方法/未知) | 新值 | 依据

只对 **类名字面量**（findClass）能给出确定的新值；
方法/字段名要看"那个对象是哪个宿主类"，得靠 frida 活体审计补 —— 那份留空标注。
"""
import os, sys, csv

ROOT = "参考/数据"
MAP_TSV = os.path.join(ROOT, "host_2.6.1-重定位映射.tsv")
REFL_TSV = os.path.join(ROOT, "反射调用清单.tsv")
OUT_TSV = os.path.join(ROOT, "适配-待改清单.tsv")


def read_map():
    """返回 (类映射, 方法映射)。键都是不带 L; 的裸名。"""
    cls, mth = {}, {}
    with open(MAP_TSV, encoding="utf-8") as f:
        r = csv.reader(f, delimiter="\t")
        header = next(r, None)
        for row in r:
            if len(row) < 6:
                continue
            _, role, old, new, om, nm = row[0], row[1], row[2], row[3], row[4], row[5]
            if not old or old.startswith("resource:"):
                continue
            if new and new not in ("同左", "(未定位)", "—"):
                cls.setdefault(old.strip(), new.strip())
            if om and nm and om not in ("—",) and nm not in ("—", "?", ""):
                mth.setdefault(om.strip(), nm.strip())
    return cls, mth


def main():
    cls_map, mth_map = read_map()
    sys.stderr.write("重定位表: 类 %d 条, 方法 %d 条\n" % (len(cls_map), len(mth_map)))

    rows = []
    with open(REFL_TSV, encoding="utf-8") as f:
        r = csv.reader(f, delimiter="\t")
        next(r, None)
        for row in r:
            if len(row) < 5:
                continue
            path, line, klass, api, lit = row[0], row[1], row[2], row[3], row[4]
            if lit == "(非字面量/未找到)":
                rows.append((path, line, klass, api, lit, "需人工", "", "非字面量"))
                continue

            if api == "findClass":
                new = cls_map.get(lit)
                if new:
                    rows.append((path, line, klass, api, lit, "类名", new, "重定位表-类映射"))
                else:
                    rows.append((path, line, klass, api, lit, "类名", "", "⚠ 未重定位（本轮不注册）"))
            else:
                # 方法/字段：只有在"全表唯一"时才敢给
                new = mth_map.get(lit)
                if new:
                    rows.append((path, line, klass, api, lit, "方法?", new, "重定位表-方法映射(需核对对象类)"))
                else:
                    rows.append((path, line, klass, api, lit, "方法/字段", "", "⚠ 待 frida 活体审计"))

    with open(OUT_TSV, "w", encoding="utf-8") as f:
        f.write("文件\t行号\t类\t形态\t字面量\t类别\t新值\t依据\n")
        for row in rows:
            f.write("\t".join(row) + "\n")

    # 汇总
    from collections import Counter
    c = Counter(r[5] for r in rows)
    ok = sum(1 for r in rows if r[6])
    sys.stderr.write("\n===== 交叉结果 =====\n")
    for k, v in c.most_common():
        sys.stderr.write("  %-12s %d\n" % (k, v))
    sys.stderr.write("  ⇒ 能直接给出新值的: %d / %d\n" % (ok, len(rows)))
    sys.stderr.write("  写到 %s\n" % OUT_TSV)


if __name__ == "__main__":
    main()

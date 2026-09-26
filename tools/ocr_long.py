#!/usr/bin/env python3
"""ocr_long.py —— 超长截图分块 OCR 🐲（tesseract 对超高图会整体失败 ✗）

用法：python3 tools/ocr_long.py <图片> [输出txt]
依赖：PIL + tesseract（含 chi_sim）
"""
import os
import subprocess
import sys

from PIL import Image

STEP = 2500


def main():
    src = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else "/workspace/tmp/ocr_out.txt"
    im = Image.open(src)
    W, H = im.size
    print("尺寸 %dx%d" % (W, H))
    os.makedirs("/tmp/ocr_chunks", exist_ok=True)
    parts = []
    for i in range(0, H, STEP):
        p = "/tmp/ocr_chunks/c%05d.png" % i
        im.crop((0, i, W, min(i + STEP, H))).save(p)
        subprocess.run(["tesseract", p, p[:-4], "-l", "chi_sim+eng", "--psm", "6"],
                       capture_output=True)
        try:
            parts.append(open(p[:-4] + ".txt", encoding="utf-8", errors="ignore").read())
        except Exception:
            pass
    open(out, "w", encoding="utf-8").write("\n".join(parts))
    print("→ %s（%d 块 / %d 字）" % (out, len(parts), sum(len(x) for x in parts)))


if __name__ == "__main__":
    main()

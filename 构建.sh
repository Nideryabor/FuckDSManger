#!/bin/sh
# ============================================================
#  一键出包 🐲
#
#    sh 构建.sh [版本名]       例： sh 构建.sh 3.9.0
#
#  做三件事：
#    ① 真编译桥（mod-src）→ mod-src/build/dex/classes.dex
#    ② 从源码编 Compose UI（pipeline/build_ui.py）
#    ③ 组单包（pipeline/build_single.py）→ 一个 APK
#
#  ★ 每一步过不了就立刻退出，**绝不产出半成品**。
#    出包前会连过这些关（任一不过 = 不出包）：
#      ① 同名类=0   ② 底座入口在   ③ 我们的入口在   ④ 底座零资源引用
#      ⑤ 条目一件不丢（含 META-INF/services）  ⑥ dex 比源码新
#      ⑧ 属性按资源 id 升序   ⑨ 清单组件类在 dex 里
#      ⑩ 父类闭包完整        ⑪ 引用闭包完整（缺类 = 装上去必然崩）
# ============================================================
set -e
cd "$(dirname "$0")"

VN="${1:-3.9.0}"
VC="${2:-480}"
OUT="out/FDM-${VN}-single.apk"

say() { printf '\033[36m══ %s\033[0m\n' "$*"; }

say "① 真编译桥（mod-src）"
( cd mod-src && sh build.sh ) | tail -3

say "② 编 Compose UI（从源码）"
python3 pipeline/build_ui.py --out "out/FDM-UI-${VN}.apk" \
        --version-code "$VC" --version-name "$VN"

say "③ 组单包"
python3 pipeline/build_single.py \
    --ui "out/FDM-UI-${VN}-signed.apk" \
    --base FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk \
    --our-dex mod-src/build/dex/classes.dex \
    --app-class com.nidyaber.fuckdsmanger.bridge.FdmApp \
    --version-code "$VC" --version-name "$VN" \
    --out "$OUT"

say "完成 🐲"
SIGNED="${OUT%.apk}-signed.apk"
cp -f "$SIGNED" "./FDM-${VN}-single-signed.apk"
echo "  装了它 →  ./FDM-${VN}-single-signed.apk"
echo "  sha256  →  $(sha256sum "FDM-${VN}-single-signed.apk" | cut -d' ' -f1)"
echo "  大小    →  $(stat -c%s "FDM-${VN}-single-signed.apk") B"

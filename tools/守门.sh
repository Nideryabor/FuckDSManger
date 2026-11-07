#!/bin/sh
# 守门.sh —— 出包前的机械检查（不靠记性）🐲
# 用法： sh tools/守门.sh
# 任一条不过 ⇒ 直接 exit 1，不许出包。

ROOT=/workspace
SM=$ROOT/tmp/base130_261/sm
FAIL=0

say() { printf '%-46s %s\n' "$1" "$2"; }

# ① 热路径上的**单参 log()**（每次调用都打 = 刷屏/卡顿源）
#    logOnce 是安全的（HashSet 去重），单参 log 才是危险的那个。
HOT=0
for f in GmBubblePaintHook GmBubble; do
  P="$SM/com/nidyaber/fuckdsmanger/gm/$f.smali"
  [ -f "$P" ] || continue
  N=$(grep -c 'GmUtil;->log(Ljava/lang/String;)V' "$P" 2>/dev/null || echo 0)
  HOT=$((HOT + N))
done
if [ "$HOT" -gt 16 ]; then say "① 热路径单参 log()" "✗ $HOT 处（基线 16，多了会刷屏→卡顿）"; FAIL=1
else say "① 热路径单参 log()" "✓ $HOT"; fi

# ② 类体积膨胀（相对基线超过 15% 就报警）
check_size() {
  f=$1; base=$2
  P="$SM/com/nidyaber/fuckdsmanger/gm/$f.smali"
  [ -f "$P" ] || return
  SZ=$(stat -c%s "$P")
  if [ "$SZ" -gt $((base * 115 / 100)) ]; then
    say "② $f 体积" "✗ ${SZ}B（基线 ${base}B，超 15%）"; FAIL=1
  else say "② $f 体积" "✓ ${SZ}B"; fi
}
check_size GmBubblePaintHook 38775
check_size GmBubble 73611

# ③ 并行构建锁（今天踩了 9 次）
LOCK=/tmp/fdm-build.lock
if [ -f "$LOCK" ]; then say "③ 构建锁" "✗ 有别的构建在跑"; FAIL=1
else say "③ 构建锁" "✓ 空闲"; fi

# ④ 汇编（smali 语法）
rm -rf /tmp/_gate /tmp/_gateout; mkdir -p /tmp/_gate /tmp/_gateout
cp -a "$SM/." /tmp/_gate/ 2>/dev/null
if java -jar /usr/share/java/smali.jar a /tmp/_gate -o /tmp/_gateout/classes.dex >/tmp/_gate.log 2>&1; then
  say "④ smali 汇编" "✓ 通过"
else say "④ smali 汇编" "✗ 见 /tmp/_gate.log"; FAIL=1; fi

echo
if [ "$FAIL" -ne 0 ]; then echo "✗ 守门未通过 —— 不许出包。"; exit 1; fi
echo "✓ 守门通过。"

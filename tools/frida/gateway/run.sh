#!/system/bin/sh
# ============================================================================
#  run.sh v13 —— frida 白名单网关 🐲
#  2026-10-01 · 尼得亚伯
#
#  版本史（每条都是"谁踩的坑"）：
#   v1  初版
#   v2  补 review#1 的 6 洞（路径穿越 / 符号链接 / TOCTOU / 参数校验…）
#   v3  补 review#2：OUT_DIR 属主检查（真提权）；删掉可写脚本目录，改内联
#   v4  补 review#3：--watch 的 set -u bug；awk 吞 ---；ALLOW 权限位…
#   v5  补【真机】踩出来的坑：目标冻结⇒注入卡死；timeout 不升级；零输出
#   v6  ★ 主人："刷抖音刷一半被切走真的很烦"
#        ⇒ 网关自己就地解冻（am unfreeze + 直接写 cgroup.freeze）
#   v7  ★ 补 review#4：
#        [1] am unfreeze 没有超时兜底 —— Binder 卡住就再也走不到 cgroup 那条路
#        [2] resolve_pid 的全 /proc 遍历实测 **6.97 秒**（341 进程）
#            ⇒ 改用 pgrep -f 锚定 cmdline，秒回；删掉慢循环
#        [3] 临时文件孤儿泄漏（被 SIGKILL 时 .job/.stage/.out 会堆着）
#        [4] emit 的 note 没净化（含 \n 会破坏 key=value）
#        [5] 权限判断改 stat -c %a 数字比对（不解析 ls 字符串，也不怕 ACL 的 +）
#        [6] unfreeze 写 cgroup 失败无日志
#        [7] say 改 printf（防消息以 -n/-e 开头被当选项）
#        [8] run_once 里也跑一次 preflight（watch 期间环境可能变）
#   v8  ★ 补 review#5：
#        ★ [真错] emit 的 status 恒为 ok —— rc=1（frida 自己失败）和 rc=137
#          （我们掐的）在尼尼眼里长得一样。改成 rc 0/124/137 → ok（输出空则
#          empty），其他 → error。
#        · owner_of 改 stat -c %U（跟 v7 的 mode_of 同一个动机：不解析 ls 字符串）
#        · resolve_pid 的 pidof 回退要【逐个】复核，不能只看第一个
#        · mv .n / rotate_audit 失败要 log（跟 v7 的 WARN 风格对齐）
#        · preflight 拆 static / dynamic：每轮只跑"会变的那几项"
#        · FROZEN_BASE 可用环境变量覆盖（换 ROM/旧安卓不用改逻辑）
#   v9  ★ 真机上又踩一个：
#        frida-inject 会去操作"终端"（tcgetattr）—— 继承到一个状态不对的 tty 时
#        直接 `tcgetattr failed: I/O error` + rc=4 失败，而且【报错完全没有指向性】。
#        修：给它的 stdin 接 /dev/null（非交互工具本来就不该碰终端）。
#   v10 ★ 真机又又踩一个：挂复杂钩子（切 ClassLoader + 6 个 overload）超过 12 秒，
#        脚本被掐，报 "Operation was cancelled" —— 完全看不出是被掐了。
#        修：job 可以自带 `timeout=N`（默认 MAX_RUN，封顶 180）。
#        例：  id=x\ntarget=...\ntimeout=60\n---\n<script>
#   v10.1/2 ★ 改完自查一遍，又逮到三处：
#        · 自检里还写着 (v8) —— 版本字符串没跟上（review#4 提过【同一类】）
#        · timeout= 没限量数 ⇒ 超长数字串可能绕过 -gt 钳制在 v10 里已经踩过一次
#          （现在：去前导零 → ≤6 位 → 封顶）
#        · id=/target=/timeout= 原来扫【整个文件】，正文里同名前缀的行能顶替头部
#          ⇒ 改成只从 `---` 之前取
#   v10.2 ★ 全文回读又逮到一个真的：
#        preflight_dyn 失败那条路【没有消费 job】⇒ 每 2 秒重新捡到同一个
#        ⇒ 日志刷屏 + job 永远卡住。这就是 review#2 说的"循环没有错误退避"的真身。
#   v10.3 ★ 又逮到一个【尼尼自己挖的重坑】：
#        为了方便做的一键脚本 frida.sh 放在 /data/local/tmp（尼尼可写），
#        而且会自动把 run.sh 从那儿 cp 进 /data/adb —— 两条路都能让 root
#        执行尼尼能改的东西。⇒ frida.sh 不再装任何东西 + 自检位置；
#        run.sh 也加了"不在 /data/adb/frida 就大声警告"。
#   v13 ★ 补 review#8：
#        ★ [严重] preflight_static 的目录检查【只 warn 没 return 1】——
#          等于没检查：脚本会继续跑，而 INJ="$HERE/frida-inject" 就成了
#          "尼尼能随时替换、却被 root exec"的二进制。
#          frida.sh 那边是硬 exit 1，run.sh 这边只警告 —— 同一个结论只落地了一处。
#          更该骂的是理由："改了硬失败，我的测试副本就不工作了" ——
#          ★拿安全换自己方便★。测试版请自行 patch 掉那一段，别动主线。
#        ★ [真 bug] sweep_orphans 两支用的 pattern 不一致：
#          v12 写成"第一支只匹配 .job.*，失败才回退全 pattern" —— 而 -delete
#          在 toybox 上是有的（第一次就成功）⇒ 回退永不执行
#          ⇒ .stage.* / .out.* / .rejected.* 永远不清，把 v7 的修复吃掉了。
#        · trap 补 .job.$$.n（tr 归一化的中间产物）
#        · run_once 那条"一定 return 0"的注释过时了（跟 v10.1 批的同一类毛病）
#        · 错别字：网关注动 → 网关自身
#        · resolve_pid 的 head -1 补上"依赖 ^…$ 唯一性"的提醒
#   v12 ★ 补 review#7：
#        · PAT 里的 . 没转义（resolve_pid 都记得转，这里忘了）
#        · 没有 --- 分隔行时 HDR 会吞掉整个文件 ⇒ 审计里的 target 是错的
#        · preflight_dyn 失败时别把主人的 job 悄悄删了 ⇒ 改名留物证 (.rejected.$$)
#        · usage 加 timeout= 的例子（默认 12s 太短，踩过 Operation was cancelled）
#        · selftest 失败时补一句"见上"（免得将来变成"静默通过"）
#        · sweep_orphans 的 find 加 -exec 回退（老 toybox 没 -delete）
#        · pid_matches 补上"为什么不扫全 argv"的证据与误判风险（见函数注释）
#   v11 ★ 补 review#6：
#        · emit 改【临时文件 + 原子 mv】—— 之前 rm 再写，尼尼会读到
#          "不存在"或"半截"；现在读到的一定是完整的一份
#        · run_once 装 EXIT/INT/TERM trap 清临时文件（被 KILL 时不再等 60 分钟）
#        · （frida.sh 那边同步改了：-k 连子孙一起带走 / mkdir 输出目录 /
#           -s 不解析 ls / pkill 匹配串带路径）
#
#    —— 有意【不改】的三条（附理由）——
#        · readlink -e 的字符串比较改成 inode 比较？⇒ 不行。readlink -e 解析出来的
#          就是同一个文件、inode 必然相同，改成比 inode 这个检查就【永远通过】、
#          等于删掉。它现在的价值是"发现路径上有符号链接成分"，误杀只发生在
#          定制 ROM 把 /data/local/tmp 做成链接的情形 —— 本机没有。
#        · note 里出现 '='？⇒ 尼尼那边用 cut -d= -f2- 取值，从第一个 = 之后全要，
#          所以 '=' 和空值都不会破坏解析。
#        · 加 cgroup v1 回退？⇒ 没真机验证过的代码，不如明确写"已知限制" +
#          留 FROZEN_BASE 覆盖口。
#
#  安装：/data/adb/frida/run.sh   root:root 0700
#  用法：su -c 'sh /data/adb/frida/run.sh'
#        su -c 'sh /data/adb/frida/run.sh --watch 1800'
#        su -c 'sh /data/adb/frida/run.sh --selftest'
#        su -c 'sh /data/adb/frida/run.sh --help'
#
#  job 文件（/data/local/tmp/frida_job.txt，只收 LF）：
#        id=job1
#        target=com.deepseek.chat.a
#        ---
#        <JS 正文>
#
#  ⚠️ 信任模型：
#    · job 是尼尼可写的唯一输入，被当数据解析，绝不 source/eval
#    · 尼尼控制不了任何"root 要打开的路径"：正文由 root 写进 $HERE/.stage.$$
#    · 白名单限制【目标】；JS 跑在目标进程（非 root）身份下
#    · /data/adb/frida 是 root:root 0700
#
#  ⚠️ 已知限制：frozen_state 依赖 cgroup v2 布局（Android 14+）。
#     Android 13 及以前读不到 ⇒ 一律返回 "?" ⇒ 拒绝。
#     要跑旧机就把 FROZEN_DIR 换成对应布局，或把 "?" 分支放宽。
# ============================================================================
set -u
umask 022

HERE=$(cd "$(dirname "$0")" && pwd)
INJ="$HERE/frida-inject"
ALLOW="$HERE/allow.txt"
AUDIT="$HERE/audit.log"

JOB=/data/local/tmp/frida_job.txt
OUT_DIR=/data/local/tmp/frida_out
RES="$OUT_DIR/result.txt"

MAX_RUN=12            # 单次注入【默认】最长秒数
MAX_RUN_CAP=180       # 任务自己指定 timeout= 时的上限
KILL_GRACE=5          # TERM 之后几秒还不死就 KILL
MAX_OUT=262144
MAX_SCRIPT=1048576
AUDIT_MAX=1048576
ORPHAN_MIN=60         # 超过这么多分钟的临时文件当孤儿扫掉

PATH=/system/bin:/system/xbin
export PATH

# ---- 小工具 ----------------------------------------------------------------
mode_of()  { stat -c %a "$1" 2>/dev/null; }
owner_of() { stat -c %U "$1" 2>/dev/null; }
fail()     { printf '%s\n' "$*" >&2; }
say()      { printf '%s\n' "$*"; }

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$AUDIT" 2>/dev/null || \
    printf '[网关] 审计写失败: %s\n' "$*" >&2
}

rotate_audit() {
  [ -f "$AUDIT" ] || return 0
  _sz=$(wc -c "$AUDIT" 2>/dev/null | awk '{print $1}')
  if [ "${_sz:-0}" -gt "$AUDIT_MAX" ] 2>/dev/null; then
    mv -f "$AUDIT" "$AUDIT.1" 2>/dev/null || \
      printf 'WARN audit-rotate-failed\n' >&2
  fi
  return 0
}

# 清扫孤儿临时文件（被 SIGKILL 时留下的）
#   ★v13：两支【必须用同一套 pattern】★
#      v12 写成"第一支只匹配 .job.*，失败才回退到全 pattern" ——
#      而 -delete 在 toybox 上是有的（第一次就成功、返回 0）⇒ 回退永不执行
#      ⇒ .stage.* / .out.* / .rejected.* 在支持 -delete 的机器上【永远不清】，
#         正好把 v7 那条"孤儿泄漏"的修复吃掉了。
sweep_orphans() {
  find "$HERE" -maxdepth 1 \( -name '.job.*' -o -name '.stage.*' \
       -o -name '.out.*' -o -name '.rejected.*' \) -mmin +"$ORPHAN_MIN" \
       -delete 2>/dev/null || \
  find "$HERE" -maxdepth 1 \( -name '.job.*' -o -name '.stage.*' \
       -o -name '.out.*' -o -name '.rejected.*' \) -mmin +"$ORPHAN_MIN" \
       -exec rm -f {} + 2>/dev/null
  return 0
}

# ---- 写结果给尼尼 ----------------------------------------------------------
#  ★v11：改成【临时文件 + 原子 mv】★
#   之前是 rm -f 再 > 重定向 —— 尼尼正好在那两步之间读，会读到"文件不存在"；
#   写到一半读，会读到半截。现在它读到的一定是完整的一份。
#   （mv -f 不会跟随目标符号链接，会直接替换它 —— 所以原来那个 rm 也不再需要了，
#     而且那个 rm 本身正是"短暂不存在"的窗口来源。）
emit() {
  _st="$1"; _id="$2"; _tg="$3"; _pd="$4"; _nt="$5"; _src="${6:-}"
  # note 净化：换行会破坏 key=value 结构
  _ntc=$(printf '%s' "$_nt" | tr '\n\r' '  ')
  _rtmp="$RES.new.$$"
  rm -f "$_rtmp" 2>/dev/null
  {
    printf 'job=%s\n'    "$_id"
    printf 'status=%s\n' "$_st"
    printf 'target=%s\n' "$_tg"
    printf 'pid=%s\n'    "$_pd"
    printf 'note=%s\n'   "$_ntc"
    printf 'time=%s\n'   "$(date '+%Y-%m-%d %H:%M:%S')"
    printf -- '--- output ---\n'
    if [ -n "$_src" ] && [ -f "$_src" ] && [ ! -h "$_src" ]; then
      head -c "$MAX_OUT" "$_src" 2>/dev/null
    fi
  } > "$_rtmp" 2>/dev/null
  chmod 644 "$_rtmp" 2>/dev/null || log "WARN chmod-result-failed job=$_id"
  if ! mv -f "$_rtmp" "$RES" 2>/dev/null; then
    log "WARN result-mv-failed job=$_id"
    rm -f "$_rtmp" 2>/dev/null
  fi
  say "  → 结果: $RES"
}

# 把被拒的 job 留个物证（比只留一行审计友好）
reject_job() {
  [ -f "$WORK" ] || return 0
  mv -f "$WORK" "$HERE/.rejected.$$" 2>/dev/null || rm -f "$WORK" 2>/dev/null
  return 0
}

# ---- 启动前硬性检查（fail closed）------------------------------------------
#  ★v8：拆成 static（启动查一次）+ dynamic（每轮查）。
#     动态那部分才是"watch 期间可能变"的东西，不用每 2 秒把 command -v 也跑一遍。
preflight_static() {
  command -v timeout >/dev/null 2>&1 || { fail "系统缺 timeout"; return 1; }
  command -v readlink >/dev/null 2>&1 || { fail "系统缺 readlink"; return 1; }
  command -v pgrep   >/dev/null 2>&1 || { fail "系统缺 pgrep"; return 1; }
  [ -f "$INJ" ] || { fail "缺 $INJ"; return 1; }
  [ -x "$INJ" ] || { fail "$INJ 不可执行"; return 1; }
  # ★信任边界硬检查★ 不通过就【拒绝启动】，不是警告
  #   ⚠️ v12 本来到这里只 warn 了一下、函数末尾 return 0 ——
  #      那等于没检查：脚本会继续跑，而 INJ="$HERE/frida-inject" 就成了
  #      "尼尼能随时替换、却被 root exec"的二进制。
  #   ⚠️ 当时把它写成警告的理由是"我的测试副本要跑在 /data/local/tmp"——
  #      拿安全换自己方便。测试版请自行 patch 掉这一段，别动主线。
  if [ "$HERE" != "/data/adb/frida" ]; then
    fail "⚠️⚠️ 网关不在 /data/adb/frida（当前 $HERE）"
    fail "    这个位置很可能是尼尼能写的 ⇒ root 会去 exec 尼尼能换的 frida-inject"
    fail "    正确位置: /data/adb/frida/run.sh  (root:root 0700)"
    return 1
  fi
  return 0
}

preflight_dyn() {
  # ALLOW：存在 + 可读 + 属主 root + 权限不含 group/other 写
  [ -f "$ALLOW" ] || { fail "缺 $ALLOW"; return 1; }
  [ -r "$ALLOW" ] || { fail "$ALLOW 不可读"; return 1; }
  if [ "$(owner_of "$ALLOW")" != "root" ]; then
    fail "$ALLOW 属主不是 root（是 $(owner_of "$ALLOW")）⇒ 尼尼能改白名单"; return 1
  fi
  _m=$(mode_of "$ALLOW")
  case "$_m" in
    600|400) : ;;
    *) fail "$ALLOW 权限不安全: $_m （要 600）"; return 1 ;;
  esac

  # OUT_DIR：存在 + 非符号链接 + 可达路径自反 + 属主 root + 权限不松
  [ -d "$OUT_DIR" ] || { fail "输出目录不存在: $OUT_DIR"; return 1; }
  [ -L "$OUT_DIR" ] && { fail "输出目录是符号链接: $OUT_DIR"; return 1; }
  _or=$(readlink -e "$OUT_DIR" 2>/dev/null)
  if [ "$_or" != "$OUT_DIR" ]; then
    fail "$OUT_DIR 可达路径不是自身: ${_or:-解析失败}"; return 1
  fi
  if [ "$(owner_of "$OUT_DIR")" != "root" ]; then
    fail "$OUT_DIR 属主不是 root（是 $(owner_of "$OUT_DIR")）"
    fail "  ⇒ 尼尼能往里写 ⇒ 能预埋 result.txt 符号链接 ⇒ 覆盖 allow.txt"
    fail "  修: su -c 'chown root:root $OUT_DIR && chmod 0755 $OUT_DIR'"
    return 1
  fi
  _m=$(mode_of "$OUT_DIR")
  case "$_m" in
    755|700|750) : ;;
    *) fail "$OUT_DIR 权限不安全: $_m （要 755）"; return 1 ;;
  esac
  return 0
}

preflight() { preflight_static && preflight_dyn; }

# ---- 包名 → pid -----------------------------------------------------------
#  ⚠️ 反面教材（v6 之前）：遍历 /proc/*/cmdline —— 实测 **6.97 秒**（341 进程）。
#     v7 改用 pgrep -f 锚定 cmdline（NUL 被 pgrep 换空格，所以 ^pkg$ 正好命中）。
#  ⚠️ 故意不堵 argv[0] 伪造：伪造者只能注入自己权限内的进程，不构成提权。
resolve_pid() {
  _pkg="$1"
  # ① pgrep -f：锚定整条 cmdline（转义 . 防正则误配）—— 秒回
  #    ⚠️ head -1 的安全性【依赖 ^…$ 的锚定】：锚定之后正常情况下只会有一个 PID。
  #       哪天要支持 :remote 之类的子进程名，这里就会漏掉后面的 PID —— 记得一起改。
  _pat=$(printf '%s' "$_pkg" | sed 's/\./\\./g')
  _p=$(pgrep -f "^${_pat}\$" 2>/dev/null | head -1)
  if [ -n "$_p" ] && pid_matches "$_p" "$_pkg"; then echo "$_p"; return 0; fi

  # ② pidof 预筛 + cmdline 复核（pidof 按 comm，15 字符截断，不可信）
  #    ★v8：pidof 可能返回多个（comm 截断撞名），要【逐个】复核，不能只看第一个
  for _p in $(pidof "$_pkg" 2>/dev/null); do
    pid_matches "$_p" "$_pkg" && { echo "$_p"; return 0; }
  done

  return 1
}

# pid 现在还是不是这个目标
#  ⚠️ 这里比的是 /proc/<pid>/cmdline 的【第 0 段】= argv[0]。
#     有人会问"Android 上 app 的 argv[0] 不是 /system/bin/app_process64 吗"——
#     不是。Android 在 RuntimeInit 里会 setArgV0 把进程名写进 argv[0]，
#     app_process64 是【zygote 自己】的 argv[0】。本机实测：
#         $ cat /proc/<宿主pid>/cmdline
#         com.deepseek.chat.a
#     ⚠️ 为什么【不】扫整条 cmdline（有 review 建议过）：
#         `am start -n com.deepseek.chat.a/...` 和 `monkey -p com.deepseek.chat.a 1`
#         这两条命令的 argv 里【就带着包名】—— 扫全 argv 会把它们也认成目标，
#         等于注入到错误的地方。比 argv[0] 更严，不是更松。
pid_matches() {
  _p="$1"; _pkg="$2"
  [ -r "/proc/$_p/cmdline" ] || return 1
  _c=$(tr '\0' '\n' < "/proc/$_p/cmdline" 2>/dev/null | head -1)
  [ "$_c" = "$_pkg" ]
}

# ---- 精确判断目标冻没冻 + 就地解冻 ----------------------------------------
#  ★v8：cgroup 基路径可用环境变量覆盖，换 ROM/旧安卓不用改逻辑
FROZEN_BASE="${FROZEN_BASE:-/sys/fs/cgroup}"
frozen_state() {
  _p="$1"
  _uid=$(stat -c %u "/proc/$_p" 2>/dev/null)
  [ -z "${_uid:-}" ] && { echo "?"; return; }
  _f="${FROZEN_BASE}/uid_${_uid}/pid_${_p}/cgroup.freeze"
  [ -r "$_f" ] || { echo "?"; return; }
  if [ "$(cat "$_f" 2>/dev/null)" = "1" ]; then echo "1"; else echo "0"; fi
}

# 就地解冻：双保险（am 有可能卡在 Binder 上，所以必须带 timeout）
unfreeze_target() {
  _p="$1"; _pkg="$2"
  timeout -k 1 2 am unfreeze "$_pkg" >/dev/null 2>&1
  _uid=$(stat -c %u "/proc/$_p" 2>/dev/null)
  if [ -n "${_uid:-}" ]; then
    echo 0 > "${FROZEN_BASE}/uid_${_uid}/pid_${_p}/cgroup.freeze" 2>/dev/null || \
      log "WARN cgroup-unfreeze-failed pid=$_p"
  fi
}

# ---- 处理一次 --------------------------------------------------------------
run_once() {
  [ -f "$JOB" ] || return 0
  # ★v11：被 KILL 时别把临时文件留到 60 分钟后（frida.sh -k 没杀干净 / 手滑 kill -9）
  #   ★v13：补上 .job.$$.n（tr 归一化那步的中间产物，之前漏了）
  trap 'rm -f "$HERE"/.job.$$ "$HERE"/.job.$$.n "$HERE"/.stage.$$ "$HERE"/.out.$$ 2>/dev/null' EXIT INT TERM
  rotate_audit
  sweep_orphans
  # watch 期间环境可能变了（目录被重挂/改权），每轮再查一次【动态项】
  #   ★v10.2：这条路【必须消费掉 job】，否则下一轮又捡到同一个 ⇒ 每 2 秒刷日志 + 卡死
  preflight_dyn || {
    log "PREFLIGHT-DYN-FAIL in run_once"
    say "  ✗ 环境检查失败（白名单 / 输出目录被人动过）—— 这一轮不做"
    emit error "-" "-" "-" "网关自身环境检查失败（ALLOW 或 OUT_DIR 的属主/权限不对）"
    # ★v12：别把主人的输入悄悄删了，改名留物证
    mv -f "$JOB" "$HERE/.rejected.$$" 2>/dev/null || rm -f "$JOB" 2>/dev/null
    return 1
  }
  say "[网关] 发现任务"

  if [ -h "$JOB" ]; then
    log "DENY job-is-symlink"; say "  ✗ job 是符号链接"
    emit deny "-" "-" "-" "job 文件是符号链接，拒绝"
    rm -f "$JOB"; return 0
  fi

  WORK="$HERE/.job.$$"
  if ! mv -f "$JOB" "$WORK" 2>/dev/null; then rm -f "$JOB"; return 0; fi
  if [ -h "$WORK" ]; then
    log "DENY job-symlink-race"; say "  ✗ job 搬运途中被换链"
    emit deny "-" "-" "-" "job 在搬运途中被换成符号链接，拒绝"
    rm -f "$WORK"; return 0
  fi

  if ! tr -d '\r' < "$WORK" > "$WORK.n" 2>/dev/null; then
    log "DENY job-normalize-failed"
    emit deny "-" "-" "-" "job 无法读取"
    rm -f "$WORK" "$WORK.n"; return 0
  fi
  mv -f "$WORK.n" "$WORK" 2>/dev/null || log "WARN mv-normalize-failed"

  # ★v12：没有 --- 分隔行就别往后走了★
  #   之前 HDR=$(sed -n '1,/^---$/p') 在没有 --- 时会【吞掉整个文件】，
  #   于是正文里一行 `target=xxx` 会被当成头部解析出来 ⇒ 审计里的 target 是错的。
  #   最终虽然还是会拒（正文为空），但日志会误导排查 —— 不如在这里就挑明。
  if ! grep -qx '^---$' "$WORK" 2>/dev/null; then
    log "DENY missing-separator"
    say "  ✗ job 里没有 --- 分隔行"
    emit deny "-" "-" "-" "job 里缺 --- 分隔行（头部与 JS 正文之间必须有它）"
    reject_job; return 0
  fi

  # ★v10.1：头部只从【`---` 之前】取，别扫正文★
  #   之前是直接 sed 整个文件取第一个匹配 —— 正文里一行 `target=...` 理论上能顶替头部。
  #   虽然后面还有白名单兜底，但"解析范围"本来就该是分明的。
  HDR=$(sed -n '1,/^---$/p' "$WORK" 2>/dev/null)
  jobid=$(printf '%s\n' "$HDR" | sed -n 's/^id=//p'      | head -1)
  target=$(printf '%s\n' "$HDR" | sed -n 's/^target=//p' | head -1)

  # ★v10：任务可以自己指定超时（挂复杂钩子的探针需要更长的窗口）
  #   夹取顺序：去前导零 → 只收 ≤6 位数字 → 封顶 MAX_RUN_CAP
  #   （限量数是为了防"超长数字串"绕过 -gt 钳制；去前导零是为了防 timeout 收到 008 这种）
  wantto=$(printf '%s\n' "$HDR" | sed -n 's/^timeout=//p' | head -1)
  runfor="$MAX_RUN"
  if [ -n "${wantto:-}" ]; then
    w2=$(printf '%s' "$wantto" | sed 's/^0*//')
    case "${w2:-}" in
      "") : ;;
      *[!0-9]*) : ;;
      *) if [ "${#w2}" -le 6 ] && [ "$w2" -ge 1 ] 2>/dev/null; then
           if [ "$w2" -gt "$MAX_RUN_CAP" ] 2>/dev/null; then
             runfor="$MAX_RUN_CAP"
           else
             runfor="$w2"
           fi
         fi ;;
    esac
  fi

  case "$jobid" in
    ""|*[!A-Za-z0-9._-]*)
      log "DENY bad-jobid"; say "  ✗ id 不合法"
      emit deny "-" "-" "-" "缺少合法 id=（字符集 [A-Za-z0-9._-]）"
      rm -f "$WORK"; return 0 ;;
  esac
  case "$target" in
    ""|*[!A-Za-z0-9._]*)
      log "DENY bad-target-charset id=$jobid"; say "  ✗ target 字符集不合法"
      emit deny "$jobid" "-" "-" "target 字符集不合法"
      rm -f "$WORK"; return 0 ;;
  esac
  if ! grep -qxF "$target" "$ALLOW" 2>/dev/null; then
    log "DENY not-allowlisted id=$jobid target=$target"; say "  ✗ 不在白名单: $target"
    emit deny "$jobid" "$target" "-" "不在白名单里"
    rm -f "$WORK"; return 0
  fi
  say "  · id=$jobid  target=$target  ✓ 白名单通过"

  STAGE="$HERE/.stage.$$"
  awk 'BEGIN{f=0} !f && /^---$/{f=1;next} f{print}' "$WORK" > "$STAGE" 2>/dev/null
  chmod 600 "$STAGE" 2>/dev/null
  _ssz=$(wc -c "$STAGE" 2>/dev/null | awk '{print $1}')
  if [ "${_ssz:-0}" -eq 0 ]; then
    log "DENY empty-script id=$jobid"; say "  ✗ 脚本正文为空"
    emit deny "$jobid" "$target" "-" "脚本正文为空（--- 之后要有内容）"
    rm -f "$WORK" "$STAGE"; return 0
  fi
  if [ "${_ssz:-0}" -gt "$MAX_SCRIPT" ] 2>/dev/null; then
    log "DENY script-toobig id=$jobid size=$_ssz"; say "  ✗ 脚本过大"
    emit deny "$jobid" "$target" "-" "脚本超过 $MAX_SCRIPT 字节"
    rm -f "$WORK" "$STAGE"; return 0
  fi

  # ① 找 pid
  pid=$(resolve_pid "$target")
  if [ -z "$pid" ]; then
    log "MISS no-process id=$jobid target=$target"; say "  ✗ 目标没在跑"
    emit error "$jobid" "$target" "-" "目标进程没在跑（或进程名跟包名对不上）"
    rm -f "$WORK" "$STAGE"; return 0
  fi

  # ② 冻着就自己解冻（不再要求主人抢前台）
  adj=$(cat "/proc/$pid/oom_score_adj" 2>/dev/null)
  fz=$(frozen_state "$pid")
  case "$fz" in
    "?")
      log "DENY freeze-unknown id=$jobid target=$target pid=$pid"
      say "  ✗ 读不到 cgroup.freeze，无法判定冻结状态 —— 宁可拒绝"
      emit deny "$jobid" "$target" "$pid" \
        "无法判定冻结状态（读不到 /sys/fs/cgroup/uid_<uid>/pid_<pid>/cgroup.freeze）"
      rm -f "$WORK" "$STAGE"; return 0 ;;
    "1")
      say "  · pid=$pid  oom_adj=$adj  ← 被冻结，就地解冻中…"
      unfreeze_target "$pid" "$target"
      sleep 1
      fz2=$(frozen_state "$pid")
      if [ "$fz2" != "0" ]; then
        log "DENY still-frozen id=$jobid target=$target pid=$pid adj=$adj state=$fz2"
        say "  ✗ 就地解冻失败（状态=$fz2）—— 拒绝注入，免得留个半死进程"
        emit deny "$jobid" "$target" "$pid" \
          "目标被冻结且就地解冻失败（oom_adj=$adj）。请手动打开一次再投。"
        rm -f "$WORK" "$STAGE"; return 0
      fi
      say "  · 已就地解冻 ✅（没有打扰前台）" ;;
    *)
      say "  · pid=$pid  oom_adj=$adj  ✓ 未冻结" ;;
  esac

  # ③ pid 现在还是不是这个目标
  if ! pid_matches "$pid" "$target"; then
    log "DENY pid-changed id=$jobid pid=$pid"
    say "  ✗ 目标在解析后重启了（pid 变了），请重投"
    emit error "$jobid" "$target" "$pid" "解析完 pid 之后目标重启了，请重投一次"
    rm -f "$WORK" "$STAGE"; return 0
  fi

  # ④ 注入前最后一道：再查一次冻结
  fz3=$(frozen_state "$pid")
  if [ "$fz3" != "0" ]; then
    log "DENY refrozen id=$jobid pid=$pid state=$fz3"
    say "  ✗ 刚要注入时目标又被冻上了（状态=$fz3）—— 放弃，免得留下半死进程"
    emit deny "$jobid" "$target" "$pid" \
      "解冻后又被系统冻上（状态=$fz3）。请再投一次，或在用这个 App 的时候投。"
    rm -f "$WORK" "$STAGE"; return 0
  fi

  # ⑤ 注入（只用 -p；timeout 带 KILL 兜底）
  #   ★v9：stdin 必须接 /dev/null★
  #   frida-inject 会去操作"终端"（tcgetattr），继承到的是一个状态不对的 tty 时
  #   会以 `tcgetattr failed: I/O error` + rc=4 直接失败 —— 而且【报错完全没有指向性】。
  #   它本来就是非交互工具，接黑洞就对了。
  tmp="$HERE/.out.$$"
  say "  · 注入中（最多 ${runfor}s，含 ${KILL_GRACE}s 强杀宽限）…"
  timeout -k "$KILL_GRACE" "$runfor" "$INJ" -p "$pid" -s "$STAGE" \
      < /dev/null > "$tmp" 2>&1
  rc=$?

  # ★v8：status 不再恒为 ok★
  #   frida-inject 注入完不会自己退（它一直挂着），所以 124/137 是【我们的正常收尾】。
  #   真正要报警的是别的非 0（frida 自己失败：找不到进程、脚本语法错…）。
  _osz=$(wc -c "$tmp" 2>/dev/null | awk '{print $1}')
  case "$rc" in
    0|124|137)
      if [ "${_osz:-0}" -eq 0 ]; then _st=empty; else _st=ok; fi ;;
    *)
      _st=error ;;
  esac

  log "RUN id=$jobid target=$target pid=$pid rc=$rc status=$_st to=${runfor}s bytes=$_ssz out=$_osz"
  say "  · 注入结束 rc=$rc  status=$_st"
  emit "$_st" "$jobid" "$target" "$pid" "rc=$rc" "$tmp"

  rm -f "$tmp" "$STAGE" "$WORK"
  return 0
}

# ---- 自检 ----------------------------------------------------------------
selftest() {
  echo "== frida 网关自检 (v13) =="
  echo "  网关: $0"
  echo
  echo "[1] 硬性前置检查（任一 ✗ ⇒ 网关拒绝启动）"
  if preflight; then echo "  ✓ 全部通过"; else echo "  ✗ 见上（那几条就是拒绝启动的原因）"; fi
  echo
  echo "[2] 其他"
  if [ -f "$AUDIT" ]; then
    echo "  · 审计日志 $(wc -c "$AUDIT" | awk '{print $1}') 字节"
  else
    echo "  · 审计日志还没建（首次运行会建）"
  fi
  echo
  echo "[3] 白名单"
  grep -v '^#' "$ALLOW" 2>/dev/null | grep -v '^$' | sed 's/^/    /'
  echo
  echo "[4] 目标进程"
  grep -v '^#' "$ALLOW" 2>/dev/null | grep -v '^$' | while read -r p; do
    [ -z "$p" ] && continue
    _x=$(resolve_pid "$p")
    if [ -n "$_x" ]; then
      _a=$(cat "/proc/$_x/oom_score_adj" 2>/dev/null)
      _fz=$(frozen_state "$_x")
      case "$_fz" in
        "1") echo "    ⚠ $p (pid $_x, oom_adj=$_a) —— 现在被冻结（投任务时网关会自己解冻）" ;;
        "0") echo "    ✓ $p (pid $_x, oom_adj=$_a) —— 可直接注入" ;;
        *)   echo "    ? $p (pid $_x, oom_adj=$_a) —— 读不到 cgroup.freeze" ;;
      esac
    else
      echo "    · $p （没在跑）"
    fi
  done
}

usage() {
  cat <<'EOF'
frida 白名单网关 🐲 v13

  sh run.sh                处理一次（有 job 就干）
  sh run.sh --watch [秒]   轮询（不给秒数默认 1800）
  sh run.sh --selftest     自检
  sh run.sh --help         这份帮助

job 文件（/data/local/tmp/frida_job.txt，只收 LF）：
  id=<任务号，[A-Za-z0-9._-]>
  target=<白名单里的进程名>
  timeout=<可选，秒，默认 12，封顶 180>     ← 挂复杂钩子时记得加
  ---
  <JS 正文；正文里可以出现独立的 --- 行>

  例：
    id=hooks1
    target=com.deepseek.chat.a
    timeout=60
    ---
    console.log("hi");

⚠️ 默认只有 12 秒。切 ClassLoader / 挂多个 overload 的探针会超时，
   报 "Operation was cancelled" —— 看到它就加 timeout=。

目标被系统冻结时，网关会【自己就地解冻】，不需要你切前台。
解冻失败才拒绝（免得注出一个半死的进程）。

结果 /data/local/tmp/frida_out/result.txt   审计 /data/adb/frida/audit.log
EOF
}

# ---- 入口 ------------------------------------------------------------------
MODE="${1:-once}"

case "$MODE" in
  --selftest) selftest; exit 0 ;;
  --help|-h)  usage;    exit 0 ;;
esac

preflight || exit 1

case "$MODE" in
  --watch)
    SECS="${2:-1800}"
    case "$SECS" in
      ""|*[!0-9]*) printf '用法: --watch [秒数]（只收正整数，默认 1800）\n' >&2; exit 2 ;;
    esac
    say "[网关] watch ${SECS}s，轮询中…（Ctrl-C 可停）"
    log "WATCH start ${SECS}s"
    # ★v13：开局先扫一次孤儿（run_once 只在【有 job】时才扫，
    #   所以上次会话残留的 .stage/.out 要等到下一单才会被清）
    sweep_orphans
    trap 'say ""; say "[网关] 收到中断，退出"; log "WATCH interrupted"; exit 0' INT TERM
    END=$(( $(date +%s) + SECS ))
    while [ "$(date +%s)" -lt "$END" ]; do
      # 子 shell 隔离：run_once 里 set -u 之类意外只炸这一轮，不炸整个 watch。
      # ★v13：注释更正——run_once 不是"一定 return 0"：
      #   正常路径 return 0；preflight_dyn 失败那条 return 1（它会自己消费掉 job）。
      #   所以这里响了有两种可能：环境坏了，或者真出了意外，都值得记一笔。
      ( run_once ) || log "WARN run_once-abnormal-exit"
      sleep 2
    done
    say "[网关] watch 结束"
    log "WATCH end"
    ;;
  *)
    run_once
    ;;
esac

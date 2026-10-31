#!/system/bin/sh
# ============================================================================
#  run.sh v5 —— lspctl 白名单网关 🐲
#  2026-10-24 · 尼得亚伯
#
#  v5 修掉 review#4 的 2 个**新引入漏洞** + 3 个遗留：
#    🔴1  **file_ok 的 setuid 检查被全局变量副作用废掉**（v4 新引入，完全静默）
#         is_world_writable 里 `_m="$1"; _m=${_m#?}` 改的是全局 `_m`
#         ⇒ file_ok 里 `has_special_bits "$_m"` 看到的是**削过的 3 位**
#         ⇒ 永远 return 1（"没有特殊位"）⇒ **4755 的 allow.txt 能通过**
#         ⇒ 修：两个函数内部变量全改 _wm/_wg/_wo/_sb；file_ok 用独立 _perm
#    🔴2  **-k / -s 跑在 MUST_DIR 检查之前**（v4 新引入）
#         ⇒ 从 /data/local/tmp 跑 `-k` ⇒ PID_FILE 可控 ⇒ root 级杀进程面
#         ⇒ 修：MUST_DIR 校验提到最前；stop_gw/show_status 读 PID 前过 _safe_pid_file
#    🟡3  _mono 用 $(...) 读 $SECONDS（子 shell 可能重置为 0 ⇒ 空闲计时永不触发）
#         ⇒ 修：改 _mono_set 设全局 _MONO_NOW，主 shell 直接读
#    🟡4  CRLF 规范化的 mv 失败未检查 ⇒ 修：显式 || { rm; return 1 }
#    🟡5  无 timeout 降级分支的 sleep 成孤儿 ⇒ 修：_kill_tree 再 kill
#    🟢   pkill 可能不存在 ⇒ _kill_tree 退化到 /proc/<pid>/task/*/children
#
#  v4 → 见 git log；v3 修 review#2 的 14 条；v2 修 review#1 的 9 条
#
#  用法（主人，真 su）：
#    sh /data/local/tmp/deploy.sh                # 部署（保留源，可重跑）
#    sh /data/local/tmp/deploy.sh -R             # 只更新 run.sh
#    su -c 'sh /data/adb/lspctl-gw/run.sh'       # 后台
#    su -c 'sh /data/adb/lspctl-gw/run.sh -f'    # 前台
#    su -c 'sh /data/adb/lspctl-gw/run.sh -k'    # 停
#    su -c 'sh /data/adb/lspctl-gw/run.sh -s'    # 状态
# ============================================================================

set -u

# 🔴3：强制从 MUST_DIR 运行（v2 里这个变量定义了却没用 ⇒ 攻击面还在）
MUST_DIR=/data/adb/lspctl-gw
HERE=$(cd "$(dirname "$0")" 2>/dev/null && pwd)

JOB=/data/local/tmp/lspctl_job.txt

# 🔴2：权威结果在 root-only 目录
OUT_DIR=$HERE/out
RESULT=$OUT_DIR/result.txt
AUDIT=$OUT_DIR/audit.log
PID_FILE=$OUT_DIR/gw.pid
CHILD_PID_FILE=$OUT_DIR/child.pid
LOCK=$OUT_DIR/.gw.lock

# 对外只读副本（由 deploy.sh 预创建 + 定死权限；run.sh 只校验，绝不重建）
PUB_DIR=/data/local/tmp/lspctl_out
PUB_RESULT=$PUB_DIR/result.txt
PUB_AUDIT=$PUB_DIR/audit.log

ALLOW=$HERE/allow.txt
MAX_RUN=60           # 单条命令超时（秒）
IDLE_SEC=1800        # 空闲多久自动退（30 分钟）
MAX_LIFE=7200        # ★ 总运行时长上限（2 小时）—— 到点必退，不管有没有 job
AUDIT_MAX=1048576
MAX_ARGS=6          # 🔴1 补充：带参行最多几个参数
MAX_ARG_LEN=120     # 单个参数最长

say() { printf '%s\n' "$*"; }

# ============================================================================
#  🟡v5-3 单调时钟：**不 fork**（v4 用 $(...) 读 $SECONDS，子 shell 可能重置为 0
#    ⇒ _now - LAST_ACT 恒为 0 ⇒ 空闲计时永不触发、进程永不退出）
#    ⇒ 改成「设置全局 MONO_NOW」的形式，主 shell 直接读
# ============================================================================
_MONO_NOW=0

_mono_set() {
    if [ -n "${SECONDS:-}" ]; then
        # ★ 主 shell 直接读 $SECONDS（可靠；不用 $(...) 包起来）
        _MONO_NOW=$SECONDS
    elif [ -r /proc/uptime ]; then
        read -r _u _rest < /proc/uptime 2>/dev/null
        _MONO_NOW=${_u%%.*}
    else
        _MONO_NOW=$(date +%s)
    fi
    case "${_MONO_NOW:-}" in
        ''|*[!0-9]*) _MONO_NOW=0 ;;
    esac
}

MONO_SRC="\$SECONDS"
if [ -z "${SECONDS:-}" ]; then
    if [ -r /proc/uptime ]; then
        MONO_SRC="/proc/uptime"
    else
        MONO_SRC="date +%s（会受系统时间跳变影响）"
    fi
fi

# ============================================================================
#  🔴v5-1 权限判据：**绝不污染调用方变量**
#    v4 的坑：is_world_writable 里 `_m="$1"; _m=${_m#?}` 改的是**全局 `_m`**
#    ⇒ file_ok 里 `is_world_writable "$_m"` 之后 `_m` 已被削成 3 位
#    ⇒ `has_special_bits "$_m"` 永远看到 3 位 ⇒ 永远 return 1
#    ⇒ **4755 的 allow.txt 能顺利通过，setuid 检查形同虚设（静默失效）**
#    ⇒ 现在两个函数内部变量全部改成 _wm/_wg/_wo/_sb 前缀，与调用方隔离
# ============================================================================
is_world_writable() {
    _wm="$1"
    case "$_wm" in
        [0-7][0-7][0-7]) ;;                        # 3 位
        [0-7][0-7][0-7][0-7]) _wm="${_wm#?}" ;;    # 4 位（setuid/gid/sticky）削首位
        *) return 0 ;;                             # ★ 拿不到 ⇒ 当危险（fail-close）
    esac
    _wg=$(printf '%s' "$_wm" | cut -c2)
    _wo=$(printf '%s' "$_wm" | cut -c3)
    for _wb in "$_wg" "$_wo"; do
        case "$_wb" in
            2|3|6|7) return 0 ;;                   # group/other 有写位
        esac
    done
    return 1
}

# 🟢 setuid/setgid/sticky 位（内部变量 _sb，不动 $1）
has_special_bits() {
    _sb="$1"
    case "$_sb" in
        [0-7][0-7][0-7][0-7]) ;;
        *) return 1 ;;                             # 不是 4 位 ⇒ 没有特殊位
    esac
    case "${_sb%"${_sb#?}"}" in
        1|2|3|4|5|6|7) return 0 ;;
    esac
    return 1
}

# ============================================================================
#  目录/文件校验（只读判断，绝不修改）
# ============================================================================
dir_ok() {
    _d="$1"
    [ -L "$_d" ] && return 1
    [ -d "$_d" ] || return 1
    _o=$(stat -c %U "$_d" 2>/dev/null)
    [ "$_o" = "root" ] || return 1
    _perm=$(stat -c %a "$_d" 2>/dev/null)
    is_world_writable "$_perm" && return 1
    return 0
}

file_ok() {
    _f="$1"
    [ -L "$_f" ] && return 1
    [ -f "$_f" ] || return 1
    _o=$(stat -c %U "$_f" 2>/dev/null)
    [ "$_o" = "root" ] || return 1
    # 🔴v5-1 用独立变量 _perm，且两个检查都在**原始权限串**上跑
    _perm=$(stat -c %a "$_f" 2>/dev/null)
    [ -n "$_perm" ] || return 1
    is_world_writable "$_perm" && return 1
    has_special_bits "$_perm" && return 1
    return 0
}

# ============================================================================
#  🔴2 PUB_DIR：只校验，绝不重建
#  （v2 的 rm -rf + mkdir + chown + chmod 是提权面：shell 可在 rm 与 mkdir 之间
#    放一个 symlink，root 的 chown/chmod 就跟随到攻击者指定路径）
# ============================================================================
check_pub_dir() {
    if [ -L "$PUB_DIR" ]; then
        say "✗ $PUB_DIR 是符号链接 —— 拒绝继续（应由 deploy.sh 创建）"
        return 1
    fi
    if [ ! -d "$PUB_DIR" ]; then
        say "✗ $PUB_DIR 不存在 —— 先跑一次 deploy.sh"
        return 1
    fi
    _o=$(stat -c %U "$PUB_DIR" 2>/dev/null)
    if [ "$_o" != "root" ]; then
        say "✗ $PUB_DIR 属主是 '$_o' 不是 root —— 拒绝继续"
        return 1
    fi
    _perm=$(stat -c %a "$PUB_DIR" 2>/dev/null)
    if is_world_writable "$_perm"; then
        say "✗ $PUB_DIR 权限 $_perm 里 group/other 有写位 —— 拒绝继续"
        return 1
    fi
    # 🟡v4-4 可读性提示：**先削 setuid/setgid 位再取 group 位**
    _norm=$(printf '%s' "$_perm" | sed 's/^[0-7]\([0-7][0-7][0-7]\)$/\1/')
    _g=$(printf '%s' "$_norm" | cut -c2)
    case "$_g" in
        4|5|6|7) ;;   # group 有读权限
        *)
            say "（提示：$PUB_DIR 权限 $_perm 里 group 没有读位 —— 尼尼可能读不到结果）"
            ;;
    esac
    return 0
}

# ============================================================================
#  预检
# ============================================================================
preflight() {
    if ! command -v lspctl >/dev/null 2>&1; then
        say "✗ 找不到 lspctl（LSPosed 2.2.0+ 才有；且要在 PATH 里）"
        return 1
    fi

    if [ ! -f "$ALLOW" ]; then
        say "✗ 缺 $ALLOW"
        return 1
    fi

    # 🟡6 先校验 → 再规范化 → chmod 0600 → 再校验
    if ! file_ok "$ALLOW"; then
        say "✗ allow.txt 必须是 root 拥有、非符号链接、group/other 不可写"
        say "   实际：属主=$(stat -c %U "$ALLOW" 2>/dev/null) 权限=$(stat -c %a "$ALLOW" 2>/dev/null)"
        return 1
    fi
    if grep -q "$(printf '\r')" "$ALLOW" 2>/dev/null; then
        say "（allow.txt 含 CRLF ⇒ 规范化）"
        tr -d '\r' < "$ALLOW" > "$ALLOW.n" 2>/dev/null
        if [ ! -s "$ALLOW.n" ]; then
            rm -f "$ALLOW.n"
            say "✗ 规范化失败（产物为空），拒绝运行"
            return 1
        fi
        # 🟡v5-4 mv 失败必须显式处理（v4 静默继续，CRLF 没去掉却以为去掉了）
        if ! mv -f "$ALLOW.n" "$ALLOW" 2>/dev/null; then
            rm -f "$ALLOW.n" 2>/dev/null
            say "✗ 规范化后替换失败，拒绝运行"
            return 1
        fi
        chmod 0600 "$ALLOW" 2>/dev/null   # ★ 不依赖 umask
        chown root:root "$ALLOW" 2>/dev/null
        if ! file_ok "$ALLOW"; then
            say "✗ 规范化后 allow.txt 权限异常，拒绝运行"
            return 1
        fi
    fi

    # 权威输出目录（root-only）
    if ! dir_ok "$OUT_DIR"; then
        say "✗ $OUT_DIR 必须是 root 拥有、非符号链接、group/other 不可写"
        say "   实际：属主=$(stat -c %U "$OUT_DIR" 2>/dev/null) 权限=$(stat -c %a "$OUT_DIR" 2>/dev/null)"
        return 1
    fi

    # 🔴2 对外副本目录：只校验
    check_pub_dir || return 1

    # 🔴5 超时工具
    if ! command -v timeout >/dev/null 2>&1; then
        if ! command -v sleep >/dev/null 2>&1 || ! command -v kill >/dev/null 2>&1; then
            say "✗ 既没有 timeout 也没有 sleep/kill ⇒ 无法保证不挂死，拒绝运行"
            return 1
        fi
        say "（无 timeout 命令 ⇒ 用「后台 + 定时 kill -9」降级）"
    else
        # 探测是否支持 -s KILL
        if timeout -s KILL 1 sh -c ':' >/dev/null 2>&1; then
            TIMEOUT_SIG_OK=1
        else
            TIMEOUT_SIG_OK=0
            say "（timeout 不支持 -s KILL ⇒ 用 -k 兜底或 TERM）"
        fi
    fi
    return 0
}

# ============================================================================
#  🔴1 白名单校验（**严格语义**，v2 在这里 fail-open）
#
#  allow.txt 行语义：
#    `lspctl module list`   ← **无尾随空白** ⇒ 只允许这一条，不许带参数
#    `lspctl scope add␠`    ← **有尾随空白** ⇒ 允许 base 和 base <args>
# ============================================================================
check_cmd() {
    _c="$1"

    # 长度粗筛
    [ ${#_c} -le 400 ] || return 1

    # 允许字符集：A-Z a-z 0-9 . _ : / = @ 空格 -
    _bad=$(printf '%s' "$_c" | tr -d 'A-Za-z0-9._:/= @-')
    [ -z "$_bad" ] || return 1

    # 必须以 lspctl 开头
    case "$_c" in
        lspctl|lspctl\ *) ;;
        *) return 1 ;;
    esac

    while IFS= read -r _line || [ -n "$_line" ]; do
        _line=$(printf '%s' "$_line" | tr -d '\r')
        case "$_line" in
            ''|'#'*) continue ;;
        esac

        # ★ 先记住「行尾有没有空白」—— 这是"允许带参"的唯一开关
        _has_args=0
        case "$_line" in
            *[[:space:]]) _has_args=1 ;;
        esac

        # 🟡7 用 BRE（不用 -E，兼容旧 toybox sed）
        _base=$(printf '%s' "$_line" | sed 's/[[:space:]]*$//')
        [ -n "$_base" ] || continue

        # ① 精确等于 base ⇒ 允许（无参版本，**任何行都允许**）
        if [ "$_c" = "$_base" ]; then
            return 0
        fi

        # ② 以 "base " 开头 ⇒ **只有行尾带空白时**才允许（带参版本）
        if [ "$_has_args" = 1 ]; then
            case "$_c" in
                "$_base "*)
                    # ★ 补充：参数个数 / 单参数长度上限
                    _args=${_c#"$_base "}
                    _n=$(printf '%s' "$_args" | wc -w)
                    [ "$_n" -le "$MAX_ARGS" ] || return 1
                    for _a in $_args; do
                        [ ${#_a} -le "$MAX_ARG_LEN" ] || return 1
                    done
                    return 0
                    ;;
            esac
        fi
    done < "$ALLOW"
    return 1
}

# ============================================================================
#  🟡11 合并 _emit / _emit_file
# ============================================================================
_write_result() {
    _jid="$1"; _st="$2"; _rc="$3"; _src="$4"
    {
        printf 'job=%s\n' "$_jid"
        printf 'status=%s\n' "$_st"
        [ -n "$_rc" ] && printf 'rc=%s\n' "$_rc"
        printf 'time=%s\n' "$(date '+%Y-%m-%d %H:%M:%S')"
        printf -- '--- output ---\n'
        if [ -n "$_src" ] && [ -f "$_src" ]; then
            cat "$_src" 2>/dev/null
        else
            printf '%s\n' "$_src"
        fi
    } > "$RESULT.tmp" 2>/dev/null

    if ! mv -f "$RESULT.tmp" "$RESULT" 2>/dev/null; then
        say "[gw] ⚠ 写权威结果失败（$_jid）"
        return 1
    fi
    chmod 0644 "$RESULT" 2>/dev/null

    # 🔴2 拷副本（先 rm -f 防跟随 symlink；PUB_DIR 已被 check_pub_dir 保证非链接）
    rm -f "$PUB_RESULT" 2>/dev/null
    if cp -f "$RESULT" "$PUB_RESULT" 2>/dev/null; then
        chown root:root "$PUB_RESULT" 2>/dev/null
        chmod 0644 "$PUB_RESULT" 2>/dev/null
    else
        say "[gw] ⚠ 拷贝结果到 $PUB_RESULT 失败"
    fi
    return 0
}

_audit() {
    [ -f "$AUDIT" ] || : > "$AUDIT"
    chmod 0644 "$AUDIT" 2>/dev/null

    # 🟡v4-3 净化：denied 的命令**没经过 check_cmd 的字符集过滤**
    #   ⇒ 可能含 \r / \n / ANSI 转义 / 其它控制字符，直接拼进 audit.log 会污染日志
    #   （**最危险的是 \n —— 能凭空伪造出第二条 ALLOW 记录**）。
    #   做法：删掉**除 TAB 外**的所有 C0 控制符 + DEL，再限长 300。
    #   ⚠️ 注意范围必须写到 \012（LF），不能像上一版那样从 \013 开始 —— 那会漏掉换行。
    _clean=$(printf '%s' "${2:-}" \
        | tr -d '\000-\010\012-\037\177' \
        | cut -c1-300)

    # 🟡12 保留 .1~.3
    _sz=$(stat -c %s "$AUDIT" 2>/dev/null || echo 0)
    if [ "$_sz" -gt "$AUDIT_MAX" ]; then
        rm -f "$AUDIT.3" 2>/dev/null
        [ -f "$AUDIT.2" ] && mv -f "$AUDIT.2" "$AUDIT.3" 2>/dev/null
        [ -f "$AUDIT.1" ] && mv -f "$AUDIT.1" "$AUDIT.2" 2>/dev/null
        mv -f "$AUDIT" "$AUDIT.1" 2>/dev/null
        : > "$AUDIT"
        chmod 0644 "$AUDIT" 2>/dev/null
    fi

    printf '%s %s %s\n' "$(date '+%m-%d %H:%M:%S')" "$1" "$_clean" >> "$AUDIT" 2>/dev/null

    rm -f "$PUB_AUDIT" 2>/dev/null
    cp -f "$AUDIT" "$PUB_AUDIT" 2>/dev/null
    chown root:root "$PUB_AUDIT" 2>/dev/null
    chmod 0644 "$PUB_AUDIT" 2>/dev/null
}

# 🟢v4 jid 净化：只允许 [A-Za-z0-9._-]，最长 64
_sanitize_jid() {
    printf '%s' "${1:-unnamed}" | tr -d -c 'A-Za-z0-9._-' | cut -c1-64 | sed 's/^$/unnamed/'
}

# ============================================================================
#  执行一次
# ============================================================================
FAIL_STREAK=0
LAST_FAIL_REASON=""

_fail_backoff() {
    # 🟡9 连续失败退避 + 只在原因变化时 say
    _reason="$1"
    FAIL_STREAK=$(( FAIL_STREAK + 1 ))
    if [ "$_reason" != "$LAST_FAIL_REASON" ]; then
        say "[gw] ⚠ $_reason（连续第 $FAIL_STREAK 次）"
        LAST_FAIL_REASON="$_reason"
    fi
    [ "$FAIL_STREAK" -ge 3 ] && sleep 2
    return 1
}

run_once() {
    [ -f "$JOB" ] || return 1

    # 🟡10 job 是符号链接 ⇒ 拒绝
    if [ -L "$JOB" ]; then
        say "[gw] ✗ job 是符号链接，删除"
        rm -f "$JOB" 2>/dev/null
        _audit DENY "job-symlink"
        return 0
    fi

    _stage=$OUT_DIR/.job.$$
    # 🟡v4-2 跨文件系统安全：**不再直接 mv**
    #   原因：/data/local/tmp 与 /data/adb 未必同一个 fs（/data/adb 由 KSU 挂载）。
    #   跨 fs 的 mv 是「复制 + 删除」，中途失败/断电会导致 job 部分丢失。
    #   做法：cp → 校验非空且末尾换行 → 才 rm 源；任一步失败 ⇒ 把源放回/保留。
    if ! cp -f "$JOB" "$_stage" 2>/dev/null; then
        _fail_backoff "无法复制 job（权限/竞态）"
        return 1
    fi
    # 校验副本完整（非空 + 末尾换行）
    if [ ! -s "$_stage" ] || [ -n "$(tail -c 1 "$_stage" 2>/dev/null)" ]; then
        say "[gw] ⚠ job 不完整（空或末尾非换行）⇒ 保留下轮再试"
        rm -f "$_stage" 2>/dev/null
        return 1
    fi
    # 副本确认完好 ⇒ 才删源
    rm -f "$JOB" 2>/dev/null
    FAIL_STREAK=0
    LAST_FAIL_REASON=""

    _jid=$(sed -n '1s/^id=//p' "$_stage" 2>/dev/null)
    _cmd=$(sed -n '2s/^cmd=//p' "$_stage" 2>/dev/null)
    _tmo=$(sed -n '3s/^timeout=//p' "$_stage" 2>/dev/null)
    # 🟢v4 jid 净化：只允许 [A-Za-z0-9._-]，最长 64（防控制字符污染 result.txt）
    _jid=$(_sanitize_jid "$_jid")

    _tmo=$(printf '%s' "${_tmo:-$MAX_RUN}" | sed 's/^0*//')
    [ -n "$_tmo" ] || _tmo=$MAX_RUN
    [ ${#_tmo} -le 3 ] || _tmo=$MAX_RUN
    case "$_tmo" in ''|*[!0-9]*) _tmo=$MAX_RUN ;; esac
    [ "$_tmo" -ge 1 ] 2>/dev/null || _tmo=$MAX_RUN
    [ "$_tmo" -le "$MAX_RUN" ] || _tmo=$MAX_RUN

    if [ -z "$_cmd" ]; then
        _write_result "$_jid" "error" "" "缺少 cmd= 行"
        rm -f "$_stage"; return 0
    fi

    if ! check_cmd "$_cmd"; then
        say "[gw] ✗ 拒绝：$_cmd"
        _audit DENY "$_cmd"
        _write_result "$_jid" "denied" "" "命令不在白名单 / 含非法字符 / 参数超限"
        rm -f "$_stage"; return 0
    fi

    _audit ALLOW "$_cmd"
    say "[gw] → $_cmd"

    _out=$OUT_DIR/.out.$$
    _kill_note=""

    # 🔴v4-1 超时：**统一后台化并记 PID**，否则 -k 停不掉正在跑的命令
    #   原因：主 shell 阻塞在 `wait` 里时，mksh **不会处理 trap**
    #   ⇒ 只给主 shell 发 TERM 要等命令自己结束（最长 60s）才生效。
    if command -v timeout >/dev/null 2>&1; then
        if [ "${TIMEOUT_SIG_OK:-0}" = "1" ]; then
            timeout -s KILL "$_tmo" sh -c "$_cmd" </dev/null >"$_out" 2>&1 &
        elif timeout -k 2 "$_tmo" true >/dev/null 2>&1; then
            timeout -k 2 "$_tmo" sh -c "$_cmd" </dev/null >"$_out" 2>&1 &
        else
            timeout "$_tmo" sh -c "$_cmd" </dev/null >"$_out" 2>&1 &
        fi
        _cpid=$!
        echo "$_cpid" > "$CHILD_PID_FILE" 2>/dev/null
        wait "$_cpid"; _rc=$?
        rm -f "$CHILD_PID_FILE" 2>/dev/null
        [ "$_rc" -eq 124 ] && _kill_note="timeout"
    else
        sh -c "$_cmd" </dev/null >"$_out" 2>&1 &
        _cpid=$!
        echo "$_cpid" > "$CHILD_PID_FILE" 2>/dev/null
        # 🟡v5-5 sleeper 要能被完整回收（v4 只 kill 子 shell，里面的 sleep 变孤儿）
        ( sleep "$_tmo"; kill -9 "$_cpid" 2>/dev/null ) &
        _kpid=$!
        wait "$_cpid"; _rc=$?
        _kill_tree "$_kpid"        # 先杀它的子进程（真实 sleep）
        kill -9 "$_kpid" 2>/dev/null
        rm -f "$CHILD_PID_FILE" 2>/dev/null
        if [ "$_rc" -eq 137 ]; then
            _rc=124
            _kill_note="timeout-fallback"
        fi
    fi

    case "$_rc" in
        0)   _st=ok ;;
        124) _st=timeout ;;
        137)
            # 🟢 137 来源区分：我们掐的 vs OOM
            case "$_kill_note" in
                timeout*) _st=timeout ;;
                *)        _st=killed ;;
            esac
            ;;
        *)   _st=error ;;
    esac

    if [ -f "$_out" ]; then
        _sz=$(stat -c %s "$_out" 2>/dev/null || echo 0)
        if [ "$_sz" -gt 65536 ]; then
            head -c 65536 "$_out" > "$_out.t" 2>/dev/null
            mv -f "$_out.t" "$_out"
            printf '\n...[截断，原文 %s 字节]...\n' "$_sz" >> "$_out"
        fi
    fi

    _write_result "$_jid" "$_st" "$_rc" "$_out"
    rm -f "$_out" "$_stage"
    return 0
}

# ============================================================================
#  起停
# ============================================================================
stop_gw() {
    _stopped=0

    # 🔴v4-1 + 🔴v5-2 先杀子进程（读 PID 前已过 _safe_pid_file）
    if [ -f "$CHILD_PID_FILE" ]; then
        _c=$(_read_pid "$CHILD_PID_FILE" 2>/dev/null)
        if [ -n "${_c:-}" ] && kill -0 "$_c" 2>/dev/null; then
            _kill_tree "$_c"
            kill -9 "$_c" 2>/dev/null && say "✓ 已杀子进程 $_c（含其子孙）"
            _stopped=1
        fi
        rm -f "$CHILD_PID_FILE"
    fi

    if [ -f "$PID_FILE" ]; then
        _p=$(_read_pid "$PID_FILE" 2>/dev/null)
        if [ -n "${_p:-}" ] && kill "$_p" 2>/dev/null; then
            say "✓ 已停主进程（pid $_p）"
            _stopped=1
        fi
        rm -f "$PID_FILE"
    fi

    # 🔴v5-2 清锁前也确认不是符号链接
    if [ -d "$LOCK" ] && [ ! -L "$LOCK" ]; then
        rm -rf "$LOCK" 2>/dev/null
        say "✓ 已清锁"
        _stopped=1
    fi

    [ "$_stopped" = "0" ] && say "（没在跑）"
    return 0
}

show_status() {
    if [ -d "$LOCK" ] && [ ! -L "$LOCK" ]; then
        say "✓ 锁存在（有实例）"
    else
        say "✗ 无锁（没在跑？）"
    fi
    _p=$(_read_pid "$PID_FILE" 2>/dev/null)
    if [ -n "${_p:-}" ] && kill -0 "$_p" 2>/dev/null; then
        say "  pid=$_p 存活"
    fi
    _c=$(_read_pid "$CHILD_PID_FILE" 2>/dev/null)
    [ -n "${_c:-}" ] && say "  子进程=$_c"
    command -v lspctl >/dev/null 2>&1 && say "  lspctl=$(command -v lspctl)" || say "  lspctl：找不到"
    say "  JOB=$JOB"
    say "  结果=$PUB_RESULT"
    say "  权威=$RESULT"
    [ -f "$AUDIT" ] && { say "  最近 5 条审计："; tail -5 "$AUDIT" 2>/dev/null | sed 's/^/    /'; }
}

# ============================================================================
#  🔴v5-2 **MUST_DIR 校验必须在最前面**（含 -k / -s）
#    v4 的坑：case -k/-s 在 MUST_DIR 检查**之前**
#    ⇒ 从攻击者可控目录跑 `sh /data/local/tmp/run.sh -k`
#    ⇒ HERE=/data/local/tmp ⇒ PID_FILE=/data/local/tmp/out/gw.pid（可被写任意 pid）
#    ⇒ root 执行 -k 就 TERM 攻击者指定的进程（**root 级杀进程面**）
#    ⇒ 而且 rm -rf "$LOCK" 也没有 dir_ok 兜底
# ============================================================================
if [ "$HERE" != "$MUST_DIR" ]; then
    say "✗ 拒绝运行：必须在 $MUST_DIR 下"
    say "  当前在：$HERE"
    say "  （否则 OUT_DIR 的父目录可能就是可写的，root-only 隔离当场作废；"
    say "    而且 -k/-s 会读被篡改的 PID_FILE）"
    exit 1
fi

# 🔴v5-2 stop_gw / show_status 读 PID_FILE 前的校验
_safe_pid_file() {
    _pf="$1"
    [ -f "$_pf" ] || return 1
    [ -L "$_pf" ] && return 1
    _po=$(stat -c %U "$_pf" 2>/dev/null)
    [ "$_po" = "root" ] || return 1
    _ppm=$(stat -c %a "$_pf" 2>/dev/null)
    is_world_writable "$_ppm" && return 1
    # 内容必须是纯数字 1~8 位
    _pv=$(cat "$_pf" 2>/dev/null | tr -d '\r\n ')
    case "$_pv" in
        ''|*[!0-9]*) return 1 ;;
    esac
    [ ${#_pv} -ge 1 ] && [ ${#_pv} -le 8 ] || return 1
    return 0
}

_read_pid() {
    _rpf="$1"
    _safe_pid_file "$_rpf" || return 1
    cat "$_rpf" 2>/dev/null | tr -d '\r\n '
    return 0
}

# 🟢 pkill 可能不存在（toybox 有，精简 ROM 可能没有）
_kill_tree() {
    _root="$1"
    if command -v pkill >/dev/null 2>&1; then
        pkill -9 -P "$_root" 2>/dev/null
    else
        # 退化：遍历 /proc/<pid>/task/<tid>/children
        for _t in /proc/"$_root"/task/*/children; do
            [ -r "$_t" ] || continue
            for _ch in $(cat "$_t" 2>/dev/null); do
                _kill_tree "$_ch"
                kill -9 "$_ch" 2>/dev/null
            done
        done
    fi
}

case "${1:-}" in
    -k) stop_gw; exit 0 ;;
    -s) show_status; exit 0 ;;
esac

# ============================================================================
#  主流程
# ============================================================================
say "════════════════════════════════════════"
say " lspctl 网关 v5 · $(date '+%m-%d %H:%M:%S')"
say "════════════════════════════════════════"

# （MUST_DIR 校验已在文件最前面做过 —— 含 -k/-s 之前，见 🔴v5-2）
# （这里不再重复检查）

preflight || { say "✗ 预检失败，退出"; exit 1; }

# 🔴4 原子锁（mkdir 在同一文件系统上原子）
if ! mkdir "$LOCK" 2>/dev/null; then
    _old=$(_read_pid "$PID_FILE" 2>/dev/null)
    say "✗ 已有实例（锁目录 $LOCK 存在，pid=${_old:-?}）"
    say "  真卡死就手动：rm -rf $LOCK"
    exit 1
fi
echo $$ > "$PID_FILE"
chmod 0600 "$PID_FILE" 2>/dev/null

trap 'rm -rf "$LOCK"; rm -f "$PID_FILE" "$CHILD_PID_FILE"; say "（收到终止信号，退出）"; exit 0' TERM INT

say "✓ 预检通过 · 等待 job（$JOB）"
say "  空闲 ${IDLE_SEC}s 自动退 · Ctrl-C 或 -k 停"
say "  时钟源：$MONO_SRC"
say ""

# 🟡v5-3 单调时钟（不 fork，见文件头 _mono_set）
_mono_set; START_AT=$_MONO_NOW; LAST_ACT=$START_AT
say "  寿命上限：${MAX_LIFE}s（到点必退，不管有没有 job）"
say ""

while :; do
    if run_once; then
        _mono_set; LAST_ACT=$_MONO_NOW
    fi
    sleep 1
    _mono_set; _now=$_MONO_NOW

    # ★ 总时长上限（防「job 一直被投 ⇒ 空闲计时永不触发 ⇒ 无限期常驻 root」）
    #   放在 run_once 之后才检查 ⇒ 不会打断正在执行的命令
    if [ $(( _now - START_AT )) -ge "$MAX_LIFE" ]; then
        say "（已达寿命上限 ${MAX_LIFE}s，自动退出）"
        rm -rf "$LOCK" 2>/dev/null
        rm -f "$PID_FILE" 2>/dev/null
        exit 0
    fi

    # 空闲超时
    if [ $(( _now - LAST_ACT )) -ge "$IDLE_SEC" ]; then
        say "（空闲 ${IDLE_SEC}s，自动退出）"
        rm -rf "$LOCK" 2>/dev/null
        rm -f "$PID_FILE" 2>/dev/null
        exit 0
    fi
done

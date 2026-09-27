#!/bin/sh
# ============================================================================
#  ro.sh —— 只读模式下拉一条 root 命令 🐲
#
#  用法：
#      sh /workspace/tools/出笼隧道/ro.sh '命令串'
#
#      例： sh ro.sh 'ls -la /data/data/com.deepseek.chat.a/files/mmkv/'
#           sh ro.sh 'head -c 200 /data/data/<包>/shared_prefs/fdm_ui.xml'
#
#  背景：
#    普通 `adb shell` 是 uid=2000(shell) —— 读不了 /data/data，但能装包/停进程。
#    要读 app 数据必须走 `su -c`，此时 KSU profile 会给：
#        uid=0(root) · CapEff=0000000000000004 · u:r:ksu:s0
#    也就是【只有 CAP_DAC_READ_SEARCH】⇒ 能读任何文件，写不了任何文件。
#
#  ⚠️ 命令串里别用单引号（会被外层吃掉）。
#     ro.sh 内部是 `su -c '...'` —— 你再套单引号就会把参数劈开，症状是
#     「tail: grep: No such file」「cat: Unknown option 'aoE'」「syntax error: unexpected '('」
#     这类诡异报错。要引号用双引号，或者干脆不用引号（grep 模式里只有字母数字和点就行）。
#     血的教训：2026-09-27 为这个反复栽了三次。
# ============================================================================
exec sh /workspace/tools/出笼隧道/adb.sh shell su -c "'$*'"

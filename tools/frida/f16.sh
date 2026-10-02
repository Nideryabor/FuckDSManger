#!/bin/sh
# f16.sh —— 强制用 16.7.19 那一套跑任意命令 🐲
#   例:  sh tools/frida/f16.sh frida-ps -H 127.0.0.1:27042
#        sh tools/frida/f16.sh python3 frida_eval.py com.deepseek.chat.a 'Java.performNow(function(){...})'
#
# 为什么：17.19.0 的 agent 在这台机器上 dlopen 就崩；16.7.19 是本机唯一实测可用的。
# 详见 专题/2026-10-01-frida-agent-崩溃-完整尸检.md
HERE=$(cd "$(dirname "$0")" && pwd)
export PYTHONPATH="$HERE/py16${PYTHONPATH:+:$PYTHONPATH}"
export PATH="$HERE/py16/bin:$PATH"
exec "$@"

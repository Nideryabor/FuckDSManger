#!/bin/sh
# ============================================================================
#  ubcheck.sh —— 投「用户气泡重写为什么没生效」探测任务 🐲 2026-10-02
#
#  前置（要 root）：
#      su -c 'sh /data/adb/frida/run.sh --watch 900'
#
#  然后尼尼跑：  sh /workspace/tools/frida/ubcheck.sh
#
#  产出：/data/local/tmp/frida_out/result.txt 里本次 job 的结果
# ============================================================================
ADB="sh /workspace/tools/出笼隧道/adb.sh"
JOB=/data/local/tmp/frida_job.txt
OUT=/data/local/tmp/frida_out/result.txt
ID="ub1-$(date +%s)"

{
  echo "id=$ID"
  echo "target=com.deepseek.chat.a"
  echo "timeout=60"
  echo "---"
  cat /workspace/tools/frida/probes/ub1.js
} > /tmp/frida_job_ub1.txt

echo "投递 job=$ID"
$ADB push /tmp/frida_job_ub1.txt "$JOB" 2>&1 | tail -1

echo "轮询结果（最多 120 秒）..."
i=0
while [ $i -lt 60 ]; do
  if $ADB shell "grep -q '^job=$ID\$' $OUT" 2>/dev/null; then
    echo "✓ 结果到了"
    break
  fi
  i=$((i + 1))
  sleep 2
done

echo "===================== 结果 ====================="
$ADB shell "cat $OUT" 2>&1 | tail -60

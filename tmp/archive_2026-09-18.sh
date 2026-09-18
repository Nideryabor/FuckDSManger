#!/bin/bash
set -e
cd /workspace

# ---------- 1. README / 大纲 待办行：改成"归档态" ----------
ROW='| 🔴 | **新功能「回复建议」**：**发送机制已锁定**（`new cn1(text,mask)` + `ao1.J(cmd)`，详见 `专题/回复建议.md` 第十六/二十二节）；探针 `2.10.13-probe` 待真机验证 ⏸ **2026-09-18 归档暂停** —— 回来先读该文末「📌 归档快照」 |'
for f in README.md 大纲.md; do
  sed -i "s#^| 🔴 | \*\*新功能「回复建议」\*\*（聊天页 AI 最新回复下方追加按钮，点击即发送）：\*\*探针第 14 轮 2.10.13-probe（自造发送命令）待真机验证\*\* —— 判读表见 \`专题/回复建议.md\` |#$ROW#" "$f"
done

# ---------- 2. 大纲顶部"当前在推进"改成归档提示 ----------
sed -i 's#^> 🆕 当前在推进：\*\*「回复建议」功能\*\*（探针第 14 轮 `2.10.13-probe`（自造发送命令）待真机验证，见 `专题/回复建议.md`）。#&#' 大纲.md
sed -i 's#探针第 14 轮 `2.10.13-probe`（自造发送命令）待真机验证#⏸ 2026-09-18 归档：发送机制已锁定，探针 `2.10.13-probe` 待真机验证#' 大纲.md

# ---------- 3. 刷新兜底备份 ----------
git bundle create _release_backup/FuckDSManger_FULL_backup.bundle --all >/dev/null
tar czf _release_backup/FuckDSManger_docs_snapshot_main.tar.gz \
    --exclude=./.git --exclude=./_release_backup -C /workspace . 2>/dev/null
ls -la _release_backup/*.bundle _release_backup/*.tar.gz

# ---------- 4. 大纲 §8.1 记录本次刷新 ----------
cat >> 大纲.md <<'EOF'

### 8.2 🔄 2026-09-18 刷新（「回复建议」探针进行到 2.10.13，归档暂停）

| 文件 | 状态 |
|---|---|
| `_release_backup/FuckDSManger_FULL_backup.bundle` | ✅ 已重刷（含 2.9.30 收官 + 全部 2.10.x 探针提交） |
| `_release_backup/FuckDSManger_docs_snapshot_main.tar.gz` | ✅ 已重刷（`main` 工作树快照） |
| `_release_backup/*.apk` | ⏳ 仍缺：`2.9.30` / `2.10.x-probe` 系列都在手机 `Download/apks/`，沙箱看不到手机存储 ⇒ 需要主人手动拷入（2.9.30 sha256 partial `689fa0a1…`；最新探针 `2.10.13-probe` sha256 partial `67cc773c…`） |
| `restore_to_github.sh` | ⚠️ 里面 `TAG/APK/TAG_COMMIT` 仍写死 2.9.7，解封后需要更新 |

> 📌 下次继续「回复建议」时：先读 `专题/回复建议.md` 文末「📌 归档快照」（现状 / 已确定事实 / 待验证 / 正式版计划 / 已知小坑）。
EOF

git add -A
git -c user.name="尼得亚伯" -c user.email="noreply@example.com" commit -q -m "docs: 「回复建议」暂停归档（2.10.13-probe 待验证）+ 刷新兜底备份

- 专题/回复建议.md：文末新增「📌 归档快照」（现状/已确定事实/待验证/正式版计划/已知小坑），头部状态行改为归档态
- README/大纲：待办行改为归档态描述
- 大纲 §8.2：记录本次备份刷新与仍缺的 APK
- _release_backup：重刷 FULL_backup.bundle + docs_snapshot tar.gz"
git log --oneline -3
echo "===== 归档提示自检 ====="
grep -n "归档" 专题/回复建议.md | head -4
grep -n "归档暂停" README.md 大纲.md | head -4

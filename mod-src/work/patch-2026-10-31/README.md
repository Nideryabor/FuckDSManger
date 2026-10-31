# 底座 smali 补丁快照 · 2026-10-31（3.72.7 / 3.72.8）

> 为什么单独存一份：**底座源码树 `tmp/base130_261/sm` 是不进 git 的**（`.gitignore:223 /tmp/`），
> 而 3.72.7 / 3.72.8 两版的改动全在底座。只写文档不留文件，换台机器就得从 dex 反编译回来重做。

## 怎么用

```sh
# 把这两个文件覆盖进底座源树，然后按正常流程重建底座 + 出包
cp mod-src/work/patch-2026-10-31/com/nidyaber/fuckdsmanger/gm/*.smali \
   tmp/base130_261/sm/com/nidyaber/fuckdsmanger/gm/

python3 tools/重建底座.py --smali tmp/base130_261/sm \
    --base mod-src/out/FuckDSManger_NL_2.22.133_for_ds2.6.1.apk \
    --out  mod-src/out/FuckDSManger_NL_2.22.133_for_ds2.6.1.apk --api 26

sh 做包.sh <版本> <vc>
```

（`做包.sh` ⓪ 那道自检会先帮你判「底座和树不同步」，漏了这一步它会拦住你）

## 改了什么

| 文件 | 版本 | 改动 |
|---|---|---|
| `GmNameHook.smali` | 3.72.7 | 账号名分支下标 `0x8` → **`0x9`**（2.7.1 起宿主往 `when` 里插了新分支，`8` 已成 `session_list` 埋点）+ 命中时打一行日志 |
| `GmDialog.smali` | 3.72.8 | `KEYS/NAMES/TYPES` 三数组 **86 → 90**，末尾补 4 个 AB 键：`max_input_files`(i) · `query_title_time_interval`(i) · `report_http_biz_error`(b) · `stop_stream_wait_times`(i) |

真因与验收见 **`版本/3.72.7~3.72.8.md`**。

## 原版备份

- `backups/GmNameHook-2026-10-31.smali.bak`
- `backups/GmDialog-2026-10-31.smali.bak`

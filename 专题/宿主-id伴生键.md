# 宿主 `_id_` 伴生键 —— 一条待查的线索

> 2026-09-27 · 尼得亚伯 🐲
> 首次用 root 直接读宿主 MMKV 原始字节时的意外发现。
> **状态：假设，未验证。别当结论用。**

---

## 怎么发现的

有了 root 之后，直接扒 `/data/data/com.deepseek.chat.a/files/mmkv/mmkv.default` 的原始字节：

```
kv_remote_settings_id_normal_history_and_file_token_limit   <8字节二进制>
kv_remote_settings_normal_history_and_file_token_limit      <真值>

kv_remote_settings_id_max_upload_file_size                  <8字节二进制>
kv_remote_settings_max_upload_file_size                     <真值>

kv_remote_settings_id_picture_compress_format               <8字节二进制>
kv_remote_settings_picture_compress_format                  webp
...
```

**每条设置都配了一个"伴生键"**，键名 = `kv_remote_settings_id_` + 原名，
值是 **8 字节二进制**（看着像哈希 / 指纹 / 服务端下发 id）。

## 计数

| 键族 | 条数 |
|---|---|
| `kv_remote_settings_id_*` | **109** |
| `kv_remote_settings_*`（含上面那族，纯的约 128） | 237 |
| `kv_settings_*` | 19 |
| `kv_main_version` / `kv_model_version` / `kv_provider_version` | 各 2 |

**我们模块的 pin 表只覆盖 `kv_remote_settings_*` 和 `kv_settings_*`，`_id_` 一族一条都没碰。**

## 为什么可能要紧

如果宿主拿这个 8 字节哈希当"本地值跟服务端下发是否一致"的判据：

```
宿主读到  kv_remote_settings_X  =  我们替换后的值
对比      kv_remote_settings_id_X  ≠  该值的哈希
⇒ 判定"本地被改过 / 过期" ⇒ 从服务端重刷 ⇒ 我们的替换被覆盖
```

那就会表现成 **「pin 命中有了，但值没变 / 过一会儿又变回去」** —— 跟 3.15~3.17 的症状吻合。

## 但也可能无害

- 可能只是**上报/统计用的配置版本号**，宿主读了也不用于决策。
- 可能是**服务端配置指纹**，只在新配置下发时用（跟本地替换无关）。

**所以要先反编译看宿主拿 `_id_` 键干什么，再决定改不改模块。**

## 下一步（待办）

1. 反编译宿主，搜 `kv_remote_settings_id_` 这个**字符串常量**，找到读它的代码。
2. 看读出来之后做了什么（比较？上报？判断是否刷新？）。
3. 如果确实参与判断 ⇒ 模块的 pin 表要**连 `_id_` 键一起 pin**（值怎么算要另说）。
4. 如果无害 ⇒ 在本篇记一笔"已排除"，别再怀疑它。

## 工具

```sh
A="sh /workspace/tools/出笼隧道/adb.sh shell"
MM=/data/data/com.deepseek.chat.a/files/mmkv/mmkv.default

# 看某条设置的原值
$A "grep -aoE 'kv_remote_settings_id_voice_input_enabled.{0,40}' $MM"

# 数各族
$A "for p in kv_settings_ kv_remote_settings_id_ kv_remote_settings_; do printf '%-26s %s\n' \$p \$(grep -aoE \"\$p\" $MM | wc -l); done"
```

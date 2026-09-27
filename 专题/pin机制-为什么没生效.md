# pin 机制为什么没生效 —— 完整链路

> 2026-09-27 · 尼得亚伯 🐲
> 由主人一句「**那为什么旧 UI 就能……**」逼出来的答案。

---

## 一、结论一句话

> **旧 UI 写的是「宿主的真实键」；新 UI 只写「影子键」。
> 影子键要靠一个「读侧替换钩子」才能生效 —— 而那个钩子从来没被挂到读方法上。**

**不是钩子坏了，是钩子没挂。**

---

## 二、两条路对比

### ✅ 旧 UI：直接写真实键

底座 `GmStore.write(ctx, key, type, val)`：

```java
Editor ed = GmStore.get(ctx).edit();
switch (type) {
  "b" → ed.putBoolean(key, parseBoolean(val));
  "i" → ed.putInt(key, parseInt(val));
  "f" → ed.putFloat(key, parseFloat(val));
  "l" → ed.putLong(key, parseLong(val));
  else → ed.putString(key, val);
}
ed.apply();                                    // ★ 直接落进宿主的 MMKV 真实键
if (key.startsWith("kv_remote_settings_")) { … }  // 顺带镜像影子键
```

⇒ **宿主读自己的键 ⇒ 读到 ⇒ 立刻生效。**

### ❌ 新桥：只写影子键

桥的 `grayWrite()`：

```java
sp.edit().putString("fuckds_pin_" + full, val)
  .putString("fuckds_pin_" + loc,  val)
  .putString("fuckds_pin_" + bare, val)
  .apply();                                    // ← 真实键一个字没动
// 然后等读侧替换来顶值
```

---

## 三、那个「读侧替换」到底存不存在？

**存在，逻辑还是对的。** 完整底座的 `GmMmkvHook.afterHookedMethod`：

```java
key = args[0];                        // 必须是 String
r   = param.getResult();
if (r instanceof String) {            // ← 读字符串
    p = pin(key); if (p != null) { setResult(p); log("pin 命中（读时替换）"); return; }
    h = handle(key, r); if (h != null) setResult(h);
}
else if (r instanceof Boolean) {      // ← contains / 读布尔
    if (!r) { if (pin(key) != null) { setResult(true); log("contains 提为 true"); } }
}
```

**逻辑没毛病 —— 但它挂错地方了。**

`GmSync` 里只有一行：

```
findClass("com.tencent.mmkv.MMKV") → hookAllMethods("q", GmMmkvHook)
```

反编译宿主看 `q`：

```smali
.method public final q(Ljava/lang/String;Ljava/lang/String;)Z
    invoke-direct {p0, v0, v1, p1, p2}, MMKV;->encodeString(JLjava/lang/String;Ljava/lang/String;)Z
```

**⇒ `q` = `encodeString` = 「写」。读的一个都没挂。**

而宿主的读取走这几个（反编译看到，全部**直连 native `decodeXxx`**，绕过 `SharedPreferences` 接口）：

| 混淆名 | 真身 | 结果类型 |
|---|---|---|
| `c(String)` | `decodeBool(key,false)` | boolean |
| `d(String,Z)` | `decodeBool(key,def)` | boolean |
| `e(String,F)` | `decodeFloat` | float |
| `g(String)` | `decodeInt(key,0)` | int |
| `i(String)` | `decodeLong` | long |
| `j(String)` | `decodeString(key,null)` | String |
| `k(String,String)` | `decodeString(key,def)` | String |

**这些方法上——零个钩子。**

---

## 四、顺带：那句「contains 提为 true」是**误报**

`q` 返回 `Boolean`（写成功没）。写侧 `handle` 改完值之后 `encodeString` 有时返回 `false`（值其实没变），
`afterHookedMethod` 就走进 Boolean 分支 → 看到 `pin(key) != null` → 把结果强改成 `true` 并打上「contains 命中」。

**那不是 contains，是一次写操作的返回值被误判了。**

---

## 五、修法

### A · 快（不碰底座）—— 让 `grayWrite` 也写真实键

```java
// ① 先探「哪个键形本来就在」（contains 是接口方法，不会被 R8 改名）
String realKey = null;
for (String k : new String[]{full, loc, bare}) if (sp.contains(k)) { realKey = k; break; }
if (realKey == null) realKey = full;        // 都不存在 ⇒ 默认 kv_remote_settings_

// ② 备份原值（可一键还原）
// ③ GmStore.write(ctx, realKey, type, val)   ← 这一步才真正生效
// ④ 影子键三种形式照写（拦远程下发用）
// ⑤ 内存 pin 表照旧
```

> **就地覆盖**，不是到处乱写 —— 存在哪个键形就写哪个。

### B · 净（要碰底座）—— 补挂读侧钩子

1. `GmSync.smali`：`q` 之外补挂 `c/d/e/g/i/j/k`
2. `GmMmkvHook.afterHookedMethod`：补 `Integer` / `Long` / `Float` / `Set` 分支（现在只认 String 和 Boolean）
3. **建议按签名挂**，别写死混淆名（`c/d/e/g/i/j/k` 换宿主版本就变）
4. `patch_base.py` 的白名单要从「只允许 `GmEntry.smali` 不同」放开到三个文件

---

## 六、教训

> 旧代码"能用"不代表它走的机制还在。
> **旧 UI 是笨办法（直接写），新 UI 是聪明办法（影子键），
> 但聪明办法依赖的另一半（读侧钩子）从来没交付过 —— 于是聪明办法看起来"更优雅地"什么都没做。**

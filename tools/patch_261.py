#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
patch_261.py v2 —— 底座 smali：宿主 2.5.2 → 2.6.1  🐲 尼得亚伯 2026-10-01

策略（v2 修订）：
  · **GmEntry.smali 不动字符串** —— 它的寄存器被复用（同一个 "v" 服务 m5/uia/s5），
    纯文本替换会串味。改成在 `hookM` 入口**插入一次运行时查表调用**：
        cls    = GmRemap.cls(cls)              // 未定位 ⇒ 返回假名 ⇒ findClass 失败 ⇒ 安全跳过
        method = GmRemap.method(旧cls, method)
  · **其余文件**：只做**宿主类名字符串**的 1:1 替换（这些文件里一个名字只服务一个用途，无冲突）。
  · 未定位的名字 → 替换成 `__gmGone_xxx`（必然找不到）。
  · 输出到 tmp/base130_261，原树不动。
"""
import os, re, shutil, sys

SRC = sys.argv[1] if len(sys.argv) > 1 else 'tmp/base130/sm'
DST = sys.argv[2] if len(sys.argv) > 2 else 'tmp/base130_261/sm'

CLASS_MAP = {
    'kf5': 'kh7', 'fh6': 'w2b', 'me4': 'pe5', 'h91': 'd12', 'p5': 'x5',
    'pn9': 'i93', 'ls9': 'ua0', 'uia': 'qk7', 'tn0': 'jq0', 'jd8': 'dn9',
    'se0': 'eh0', 'zc': 'pr6',  's5': 'a6',   'p66': 'm97', 'h02': 'yt2',
    'ao1': 'gh2', 'bx4': 'py5', 'yb5': 'hs7', 'pd5': 'i93', 'hp8': 'dz9',
    'wr': 'ns',   'sr9': 'zx8', 'lp9': 's4b', 'le': 'af',   'ok0': 'an0',
    'ku6': 'mz7', 'vq': 'mr',   'c76': 'x97', 'ey3': 'yx4', 'sn0': 'iq0',
    'dd8': 'im9', 'md8': 'gn9', 'we5': 'pz7', 'vk0': 'jn0', 'gz3': 'bz4',
    'it9': 'd9b',
    # 未定位 ⇒ 改成必然不存在的名字
    'c73': 'f44',   # LinearGradient（字段 c/d 都是 List + (J)Shader）
    'tt7': 'u19',   # Shape 伴生（a()/b(F)/c(FFFF) 全齐）
    'g56': 'g87',   # 建议文案的数据类（由 pd5.H 形参位次推出）
    'yp1': '__gmGone_yp1', 'um1': '__gmGone_um1', 'cn1': '__gmGone_cn1',
    'pr8': '__gmGone_pr8',
    'm5': '__gmGone_m5',   # m5 只在 GmEntry 里，由运行时表处理；别的地方若出现也算异常
}
# GmEntry.smali 交给运行时表 ⇒ 这里不改它
SKIP_FILES = {'GmEntry.smali'}

# ── ③ 宿主资源 ID 平移（2026-10-01 实测：用户反馈"设置页又变回检查更新"）
RES_MAP = {
    '0x7f0f0217': '0x7f0f0263',   # 【历史遗留】2.5.0 时代的"检查更新行" id ⇒ 它就是这一行
    '0x7f0f021f': '0x7f0f0263',   # 检查更新行 profile_check_for_updates（2.6.1 新 id）
    '0x7f0f0220': '0x7f0f0264',   # profile_check_for_updates_newest（备用）
    # ⚠️ 下面两个是当年"宿主资源表里没有这个 id ⇒ 返回空串防 NotFoundException 崩溃"的防护。
    #    2.6.1 里 0x7f0f0221/0x7f0f0222 **已经变成真的资源**
    #    （mobile_verification_account_exist_toast / ..._invalid_phone_number_toast）
    #    ⇒ 这条分支会把登录验证的 toast 清空！必须废掉 ⇒ 指向 0（不可能是任何有效资源 id）
    '0x7f0f0221': '0x0',
    '0x7f0f0222': '0x0',
    '0x7f070059': '0x7f07005a',   # assistant_message_avatar（同一份矢量图 res/Fi.xml）
}


# ── ④ 锚点「判据常量」平移（2026-10-01 实测：设置行 case 号被 R8 重排）
# 老 m5.v() : case 0x14 → sget Lad8;->a   （检查更新行）
# 新 t5.w() : case 0x5  → sget Lz32;->a   ★ 用运行时调用栈抓到的真桶：
#    AndroidComposeView.dispatchTouchEvent → … → m01.w → t5.w → … → xu2.a
#    （t5 带串 batch_management_click，与老 m5 同；分支体 sget Lz32;->a 完全同构）
# 证据链：① 运行时调用栈锁定 t5  ② t5 带老 m5 的招牌串 batch_management_click
TARGET_EDITS = [
    # (文件, 旧片段, 新片段)
    # PAINTMOD_ORDER: 新宿主 jn0 的构造器参数顺序被 R8 换了 (I,J) -> (J,I)
    #                    ⇒ ColorFilter 的 newInstance 参数要换序：Integer/Long 对调
    ('gm/GmPaintModHook.smali',
     "    const/4 v4, 0x0\n\n    aput-object v3, v2, v4\n\n    const-wide/16 v4, 0x0",
     "    const/4 v4, 0x1\n\n    aput-object v3, v2, v4\n\n    const-wide/16 v4, 0x0"),
    ('gm/GmPaintModHook.smali',
     "    const/4 v4, 0x1\n\n    aput-object v3, v2, v4\n\n    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->newInstance",
     "    const/4 v4, 0x0\n\n    aput-object v3, v2, v4\n\n    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->newInstance"),
    # 纯观感：GmPainterHook 里写死的旧日志串
    ('gm/GmPainterHook.smali', '"PHook: kf5.K id=0x"', '"PHook: kh7.x id=0x"'),
    ('gm/GmEntryHook.smali',
     "    const/16 v2, 0x14\n\n    if-eq v1, v2, :cond_10",
     "    new-instance v4, Ljava/lang/StringBuilder;\n\n"
     "    const-string v5, \"[FDS] row case=\"\n\n"
     "    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V\n\n"
     "    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;\n\n"
     "    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;\n\n"
     "    move-result-object v4\n\n"
     "    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V\n\n"
     "    const/16 v2, 0x1d\n\n    if-eq v1, v2, :cond_10"),
    # ── UAVA_TAG（2026-10-01 晚）★★★ 崩因修复 ★★★
    # ⛔⛔ 2026-10-01 22:2x **暂时关掉** —— 因为它是"未验证的增量"，
    #     而同一版里我还误伤了两处（见下），一次动太多无法归因（教训 #328 又犯）。
    #     ⇒ 本版先出【纯回滚版】把 3.42.21 的状态救回来，这条单独留到下一版验。
    #
    #   （证据保留在此）
    #   p5.v() / x5.w() 是一个「按 this.a(tag) 分派的 packed-switch 桶」（29 个 case），
    #   每个 case 自己从 State 取值、cast 成各自期望的类型再返回 Object。
    #   R8 把 case 顺序重排了 ⇒ 同一个 tag 号在新宿主指向完全不同的业务。
    #     旧 tag 0xf  → :pswitch_92   check-cast Lit9;  iget-object v1, Lit9;->e:Ljava/lang/String;  return v1
    #     新 tag 0x12 → :pswitch_95   check-cast Ld9b;  iget-object v1, Ld9b;->e:Ljava/lang/String;  return v1
    #     ⇒ 逐指令同构（it9→d9b 是同一条映射，字段 e 也没改名）
    #     而新宿主 0xf → :pswitch_c3  check-cast Lfs; / Les; 是另一条业务。
    #   交叉验证：账号名桶 s5/a6 的 tag 0x8 **没位移**（所以账号名一直能用）——
    #     "能/不能"正好互为对照。
    #
    # ★★ 2026-10-01 23:1x **必须写进树里（不能只改字节）** ★★
    #   3.42.24 是用 tools/dex_const_patch.py 直接改 dex 字节上线的，树里没有。
    #   而 tools/重建底座.py 是「用 smali 树 assemble 出来的 dex **整个替换**」
    #   ⇒ 一重建就把它覆盖回 0xf（3.42.25 差点带着这个雷出包，已拦下）。
    #   教训 #347：**字节级改动与"重建"互斥** —— 要么全走树，要么全走字节，混用必丢。
    # ── ROLE_NAME（2026-10-01 23:2x）★★★ 修「雷霆大横条」★★★
    #   真机日志：`[ROLE] fy role=mb9@0` —— 取回来的不是 "USER"，是个 mb9 对象。
    #   原因（铁证·名字复用）：
    #       旧 vq:   D()Ljava/lang/String;   ← 取角色      · C()Ljava/lang/String;
    #       新 mr:   C()Ljava/lang/String;   ← 取角色      · D()Lmb9;  ← 变成返回对象了！
    #   ⇒ 代码写 "D"，反射在新宿主上**"成功"却打到另一个方法** ⇒ instance-of String 失败
    #     ⇒ 用户项也走助手支线 ⇒ 整条涂色 = 大横条
    #     （与 3.28.0 修过的 if-nez 写反**症状相同、根因不同**；教训 #334：名字复用比哑火更坏）
    #   ⚠️ 只改 GmBubbleCellHook 这 3 处（取角色 → 打日志 → 判据）。
    #      GmBubble:1989/2174 的 "D" 是 qk7.D（气泡 background，**本来就对**）——别碰！
    ('gm/GmBubbleCellHook.smali',
     '    const-string v3, "D"\n\n    const/4 v4, 0x0\n\n    new-array v4, v4, [Ljava/lang/Object;\n\n    invoke-static {v2, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod',
     '    const-string v3, "C"\n\n    const/4 v4, 0x0\n\n    new-array v4, v4, [Ljava/lang/Object;\n\n    invoke-static {v2, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod'),
    ('gm/GmBubbleCellHook.smali',
     '    const-string v4, "D"\n\n    const/4 v6, 0x0\n\n    new-array v6, v6, [Ljava/lang/Object;\n\n    invoke-static {v5, v4, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod',
     '    const-string v4, "C"\n\n    const/4 v6, 0x0\n\n    new-array v6, v6, [Ljava/lang/Object;\n\n    invoke-static {v5, v4, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod'),
    ('gm/GmBubbleCellHook.smali',
     '    const-string v3, "D"\n\n    const/4 v4, 0x0\n\n    new-array v4, v4, [Ljava/lang/Object;\n\n    invoke-static {v5, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod',
     '    const-string v3, "C"\n\n    const/4 v4, 0x0\n\n    new-array v4, v4, [Ljava/lang/Object;\n\n    invoke-static {v5, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod'),
    # ── CALLER_NAME（2026-10-01 23:1x）★★★ 修「用户气泡不变色」★★★
    #   GmBubblePaintHook 的**定点重写**认的是调用栈：
    #       GmUtil.caller() → "类名.方法名:行号"（混淆类在默认包 ⇒ 类名就是 ua0 这种短名）
    #       判据：caller().startsWith("ls9.f")
    #   新宿主里「用户气泡 lambda」已经从 ls9.f 变成 **ua0.e**（GmRemap: ls9→ua0 / f→e）
    #   ⇒ 前缀对不上 ⇒ 定点重写从来不生效 ⇒ **用户气泡不变色**。
    #   ⚠️ 真机日志里那句「ls9.f 用户气泡 lambda 已调用（仅诊断，不参与判定）」只是**文案**，
    #      真正参与判定的是这里的 caller 前缀 —— 别再被它带偏。
    ('gm/GmBubblePaintHook.smali',
     '    const-string v3, "ls9.f"\n\n    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z',
     '    const-string v3, "ua0.e"\n\n    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z'),
    # ── UAVA_TAG：账号头像锚点的 tag 在 2.6.1 位移了（0xf → 0x12）★ 真机已验证 ★
    #   p5.v() / x5.w() 是按 this.a(tag) 分派的 packed-switch 桶（29 个 case），
    #   每个 case 从 State 取值、cast 成自己那一族类型再返回 Object。R8 重排了 case 顺序：
    #     旧 tag 0xf  → :pswitch_92  check-cast Lit9;  iget v1, Lit9;->e:Ljava/lang/String;  return v1
    #     新 tag 0x12 → :pswitch_95  check-cast Ld9b;  iget v1, Ld9b;->e:Ljava/lang/String;  return v1  ← 逐指令同构
    #     新 tag 0xf  → :pswitch_c3  check-cast Lfs;/Les;  ← 另一条业务（咬它 = 投毒 ⇒ 崩/卡死）
    #   对照：账号名桶 s5/a6 的 tag 0x8 **没位移** ⇒ 所以账号名一直能用。
    #   ⚠️ 必须写进树里 —— 3.42.24 只改了 dex 字节没进树，一重建就被覆盖回 0xf（教训 #347）。
    # ── IMG_BRUSH_261（2026-10-01 23:5x）★★★ 修「图片底」★★★
    #   宿主 2.6.1 把 jq0（ShaderBrush 实现）的 <init>(Shader) 删了，只剩 <init>(RuntimeShader)。
    #   而我们的 GmBmpShader extends BitmapShader ⇒ 塞不进去（argument type mismatch）。
    #   ⇒ 改成**自造一个 RuntimeShader**（AGSL 直通采样），把解码好的 bitmap 喂进去，
    #     再拿它构造 jq0。RuntimeShader / setInputBuffer 都是 API 33+，设备是 Android 15 ✓
    #   ⚠️ 失败了不会更糟：整段在 try 里，异常 ⇒ imgBrush 返回 null ⇒ 跟现在一样（不上图）。
    ('gm/GmBubble.smali',
     '    :cond_62\n'
     '    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;\n\n'
     '    sget-object v2, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;\n\n'
     '    invoke-direct {v1, v0, v2, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V\n\n'
     '    iput-object v0, v1, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;\n\n'
     '    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;\n\n'
     '    const-string v0, "jq0"\n\n'
     '    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;\n\n'
     '    move-result-object v0\n\n'
     '    const/4 v2, 0x1\n\n'
     '    new-array v2, v2, [Ljava/lang/Class;\n\n'
     '    const/4 v3, 0x0\n\n'
     '    const-class v4, Landroid/graphics/Shader;\n\n'
     '    aput-object v4, v2, v3\n\n',
     '    :cond_62\n'
     '    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;\n\n'
     '    # ★ 2.6.1：jq0 的 (Shader) 构造器被删 ⇒ 自造 RuntimeShader（AGSL 直通采样）\n'
     '    #   ⚠️ 2026-10-02 00:3x 修正：真机 framework 里 setInputBuffer 的第二参是 **BitmapShader**\n'
     '    #      （不是 Bitmap！）—— 上一版写成 Bitmap ⇒ NoSuchMethodError。\n'
     '    #      事实来源：pull 真机 /system/framework/framework.jar，反编译 RuntimeShader.smali：\n'
     '    #         setInputBuffer(Ljava/lang/String;Landroid/graphics/BitmapShader;)V\n'
     '    #         setInputShader(Ljava/lang/String;Landroid/graphics/Shader;)V\n'
     '    new-instance v1, Landroid/graphics/RuntimeShader;\n\n'
     '    const-string v2, "uniform shader img; half4 main(float2 p) { return img.eval(p); }"\n\n'
     '    invoke-direct {v1, v2}, Landroid/graphics/RuntimeShader;-><init>(Ljava/lang/String;)V\n\n'
     '    new-instance v2, Landroid/graphics/BitmapShader;\n\n'
     '    sget-object v3, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;\n\n'
     '    invoke-direct {v2, v0, v3, v3}, Landroid/graphics/BitmapShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V\n\n'
     '    const-string v3, "img"\n\n'
     '    invoke-virtual {v1, v3, v2}, Landroid/graphics/RuntimeShader;->setInputBuffer(Ljava/lang/String;Landroid/graphics/BitmapShader;)V\n\n'
     '    const-string v0, "jq0"\n\n'
     '    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;\n\n'
     '    move-result-object v0\n\n'
     '    const/4 v2, 0x1\n\n'
     '    new-array v2, v2, [Ljava/lang/Class;\n\n'
     '    const/4 v3, 0x0\n\n'
     '    const-class v4, Landroid/graphics/RuntimeShader;\n\n'
     '    aput-object v4, v2, v3\n\n'),
    # ── FIT_HOOK_261（2026-10-02 00:5x）★ 配合图片底改成 RuntimeShader ★
    #   「限制放大」（fuckds_bubble_maxz）钩的是 jq0.b(J)（createShader）。
    #   它原来的入口判据是 `thisObject.d instanceof GmBmpShader` ——
    #   而图片底改成 RuntimeShader 之后 d 里装的是 RuntimeShader ⇒ 判据恒假 ⇒ 整个钩子失效。
    #   ⇒ 放宽成「d 是任意 Shader」（说明这是 ShaderBrush 的图片底），
    #     位图改从 GmBubble.sBmp 拿（imgBrush 每次都会 sput 它，同一渲染周期内是准的）。
    ('gm/GmBubbleFitHook.smali',
     '    const-string v2, "d"\n\n'
     '    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;\n\n'
     '    move-result-object v0\n\n'
     '    instance-of v2, v0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;\n\n'
     '    if-eqz v2, :cond_7a\n\n'
     '    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;\n\n'
     '    if-eqz v1, :cond_7a\n',
     '    const-string v2, "d"\n\n'
     '    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;\n\n'
     '    move-result-object v0\n\n'
     '    # ★ 2026-10-02：图片底改用 RuntimeShader ⇒ d 不再是 GmBmpShader。\n'
     '    #   放宽成「任意 Shader」= 这是 ShaderBrush 的图片底；位图从 GmBubble.sBmp 取。\n'
     '    instance-of v2, v0, Landroid/graphics/Shader;\n\n'
     '    if-eqz v2, :cond_7a\n\n'
     '    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;\n\n'
     '    if-eqz v1, :cond_7a\n'),
    # ── PG_UB_SKIP（2026-10-02 00:5x）★★★ 修「用户气泡透明」★★★
    #   pg()（背景实化）= 把宿主自己的底刷成透明，好让我们的底露出来。
    #   但**用户气泡的"补底"走 ub()，而 ub() 被形状门挡着（eq=false）** ⇒ 一刷透就什么都不剩
    #   ⇒ 主人看到的就是"用户气泡透明"。（第二道 10 项 equals 白名单因为行号变了全废，拦不住。）
    #   ⚠️ 这里**不能**用 sUDepth / sDepth 判 —— Compose 的组合阶段与绘制阶段分离，
    #      到绘制时 sUDepth 已归零、sDepth 可能残留，两个都不可靠。
    #      只能用调用栈里的 caller：用户气泡那条 lambda 在新宿主里是 ua0.e（旧名 ls9.f）。
    ('gm/GmBubblePaintHook.smali',
     '    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->caller()Ljava/lang/String;\n\n'
     '    move-result-object v1\n\n'
     '    sget-object v7, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sSkipList:Ljava/lang/String;\n',
     '    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->caller()Ljava/lang/String;\n\n'
     '    move-result-object v1\n\n'
     '    # ★ 用户气泡不参与背景实化（否则宿主底被刷透、而我们的底补不上 ⇒ 透明）\n'
     '    const-string v7, "ua0.e"\n\n'
     '    invoke-virtual {v1, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z\n\n'
     '    move-result v7\n\n'
     '    if-eqz v7, :cond_pgub\n\n'
     '    return-void\n\n'
     '    :cond_pgub\n'
     '    sget-object v7, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sSkipList:Ljava/lang/String;\n'),
    # ── UB_SHAPE_GATE（2026-10-02 01:0x）★★★ 修「用户气泡颜色/图片不生效」★★★
    #   ub() 里原来有这么一道门：
    #       v3 = hostShape()            (= 取 zc.o)
    #       if-ne v2, v3, :cond_a3      ← 要求"我们手上的 shape"和"宿主 zc.o 的"是**同一个对象**
    #   但 2.6.1 里 zc.o（旧: Lc84;，一个 implements md8 的 Shape 单例）**被名字复用**成
    #   了 Lqt6; ⇒ hostShape() 拿回来的根本不是 Shape ⇒ eq 恒假（真机日志：
    #       [DIAG] ub形状门 caller=ua0.e:1076 shapeId=... hsId=... eq=false）
    #   ⇒ 用户气泡的定点重写（ubMod）从来没被调用过。
    #   而 caller 判据（ua0.e = 用户气泡那条 lambda）本来就足够精确，
    #   shape 是否同一对象不是必要条件 ⇒ 去掉这道门。
    ('gm/GmBubblePaintHook.smali',
     '    if-ne v2, v3, :cond_a3\n\n'
     '    const/4 v2, 0x0\n\n'
     '    aget-object v2, v0, v2\n\n'
     '    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->useUImgName()V\n',
     '    # ★ 2026-10-02：原来的 if-ne v2, v3（shape 同一性）在 2.6.1 上恒假 —— 去掉。\n'
     '    #   caller=ua0.e 已经足够确定这是用户气泡的 background 调用。\n'
     '    const/4 v2, 0x0\n\n'
     '    aget-object v2, v0, v2\n\n'
     '    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->useUImgName()V\n'),
    # ── BMP_PAIR（2026-10-02 01:0x）★★★ 修「AI 图底 / 用户图底错乱·截断」★★★
    #   缘起：主人观察到的三种现象（AI 底被截断 / AI 底跑到用户气泡下 / 下半截透明）
    #   根因是**我上一版埋的**：把 GmBubbleFitHook（算裁剪缩放）的位图来源从"实例自带"
    #   改成了全局 GmBubble.sBmp —— 而 sBmp 每次 imgBrush() 都被覆盖
    #   ⇒ 两个气泡交替时，裁剪用的是"另一张图"的宽高 ⇒ 截断/错位/跑到别人底下。
    #   修法：给每个 jq0 实例配一张"实例 → 位图"的 IdentityHashMap，
    #        imgBrush() 里配对，FitHook 里按 thisObject 取回自己那张。
    #   ① 字段
    ('gm/GmBubble.smali',
     '.field public static sBmp:Landroid/graphics/Bitmap;\n',
     '.field public static sBmp:Landroid/graphics/Bitmap;\n\n'
     '# ★ jq0 实例 → 它用的位图（IdentityHashMap：按对象身份，不看 equals/hashCode）\n'
     '.field public static sBmpMap:Ljava/util/IdentityHashMap;\n'),
    #   ② imgBrush() 构造出 jq0 之后立刻配对
    ('gm/GmBubble.smali',
     '    invoke-virtual {v0, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;\n\n'
     '    move-result-object v0\n'
     '    :try_end_89\n',
     '    invoke-virtual {v0, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;\n\n'
     '    move-result-object v0\n\n'
     '    # ★ 把这个 jq0 实例和它用的位图配对（FitHook 靠它拿回"自己那张"，不再看全局 sBmp）\n'
     '    move-object v1, v0\n\n'
     '    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmpMap:Ljava/util/IdentityHashMap;\n\n'
     '    if-nez v2, :map_new\n\n'
     '    new-instance v2, Ljava/util/IdentityHashMap;\n\n'
     '    invoke-direct {v2}, Ljava/util/IdentityHashMap;-><init>()V\n\n'
     '    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmpMap:Ljava/util/IdentityHashMap;\n\n'
     '    :map_new\n'
     '    sget-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;\n\n'
     '    invoke-virtual {v2, v1, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;\n'
     '    :try_end_89\n'),
    #   ③ FitHook 改成从映射表按实例取
    ('gm/GmBubbleFitHook.smali',
     '    instance-of v2, v0, Landroid/graphics/Shader;\n\n'
     '    if-eqz v2, :cond_7a\n\n'
     '    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;\n\n'
     '    if-eqz v1, :cond_7a\n',
     '    instance-of v2, v0, Landroid/graphics/Shader;\n\n'
     '    if-eqz v2, :cond_7a\n\n'
     '    # ★ 从「实例 → 位图」表里取**自己这张**（原来读全局 sBmp ⇒ 两个气泡互相串图 ⇒ 截断/错位）\n'
     '    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;\n\n'
     '    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmpMap:Ljava/util/IdentityHashMap;\n\n'
     '    if-eqz v2, :cond_7a\n\n'
     '    invoke-virtual {v2, v0}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;\n\n'
     '    move-result-object v1\n\n'
     '    check-cast v1, Landroid/graphics/Bitmap;\n\n'
     '    if-eqz v1, :cond_7a\n'),
    # ── FIT_DIAG（2026-10-02 02:3x）—— 临时诊断：裁剪到底用了什么值
    #   目的：不依赖 frida，主人导出模块日志就能看到每个气泡的
    #        「用的哪张图 / 尺寸多少 / 目标尺寸 / 最终 scale」。
    #   只加日志，不改任何返回值 ⇒ 安全。定位完就删。
    ('gm/GmBubbleFitHook.smali',
     '    invoke-static {v10, p0}, Ljava/lang/Math;->min(FF)F\n\n'
     '    move-result v10\n\n'
     '    const/high16 v11, 0x3f000000    # 0.5f\n',
     '    invoke-static {v10, p0}, Ljava/lang/Math;->min(FF)F\n\n'
     '    move-result v10\n\n'
     '    # ★ 诊断（临时）\n'
     '    new-instance v11, Ljava/lang/StringBuilder;\n\n'
     '    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V\n\n'
     '    const-string v12, "[FIT] \\u56fe="\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
     '    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I\n\n'
     '    move-result v12\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;\n\n'
     '    const-string v12, "x"\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
     '    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I\n\n'
     '    move-result v12\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;\n\n'
     '    const-string v12, " \\u76ee\\u6807=("\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
     '    float-to-int v12, v6\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;\n\n'
     '    const-string v12, ","\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
     '    float-to-int v12, v7\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;\n\n'
     '    const-string v12, ") scale="\n\n'
     '    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
     '    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;\n\n'
     '    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;\n\n'
     '    move-result-object v11\n\n'
     '    invoke-static {v11}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V\n\n'
     '    const/high16 v11, 0x3f000000    # 0.5f\n'),
    # ── NO_BG_FALLBACK（2026-10-02 02:5x）★★★ 修「图底截断/跑到别人底下」★★★
    #   真机日志（3.42.35 的诊断）：
    #       [FIT] 图=1439x1143  目标=(635,161)     ← 用户图，正常
    #       [FIT] 图=1440x3168  目标=(1440,3612)   ← ★ 屏幕尺寸 = 背景图被当成气泡图！
    #       [FIT] 图=1440x3168  目标=(1440,25349)  ← ★★ 目标高度 = 整个列表高度
    #   ⇒ imgBrush() 有一条"气泡图不可用 ⇒ 回退用 fuckds_bg.png（背景图）"的路，
    #     于是同一屏里有的气泡用 1439x1143 的气泡图、有的用 1440x3168 的背景图，
    #     FitHook 再按各自尺寸算裁剪 ⇒ **截断 / 错位 / 跑到别人底下**。
    #   ⇒ 砍掉这条回退：气泡图不可用就返回 null（那一路本来就是"退回纯色"）✓
    #   ⚠️ 只改那一个文件名常量（最小改动），不动其它分支。
    ('gm/GmBubble.smali',
     '    const-string v3, "fuckds_bg.png"\n',
     '    # ★ 2026-10-02：不再拿背景图当气泡底的替身（尺寸完全不同 ⇒ 裁剪全乱）\n'
     '    const-string v3, "__gm_no_bg_fallback__.png"\n'),
    # ── FIT_SIZE_GATE（2026-10-02 03:0x）★★★ 修「图底跑到别人底下」★★★
    #   真机日志里出现了非气泡尺寸的调用：
    #       [FIT] 目标=(1440,3612)   /   [FIT] 目标=(1440,25349)   ← 25349 = 整个列表高度
    #   说明宿主的**列表级 ShaderBrush** 也被这个钩子接管了（判据放宽成任意 Shader 的代价），
    #   于是把气泡图 shader 画到了列表区域 ⇒ "图底跑到用户气泡下 / 下半截透明"。
    #   ⇒ 加一道尺寸闸门：目标尺寸明显不是气泡（> 2500）就**放行不裁剪**。
    #     气泡的真实尺寸实测只有 161 / 798 这种量级，2500 能干净分开。
    ('gm/GmBubbleFitHook.smali',
     '    invoke-static {v7}, Ljava/lang/Float;->intBitsToFloat(I)F\n\n'
     '    move-result v7\n\n'
     '    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I\n',
     '    invoke-static {v7}, Ljava/lang/Float;->intBitsToFloat(I)F\n\n'
     '    move-result v7\n\n'
     '    # ★ 尺寸闸门：目标尺寸不像气泡 ⇒ 放行（别接管列表级的 ShaderBrush）\n'
     '    const/high16 v11, 0x451c4000    # 2500.0f\n\n'
     '    cmpl-float v12, v6, v11\n\n'
     '    if-lez v12, :cond_fit_ok1\n\n'
     '    return-void\n\n'
     '    :cond_fit_ok1\n'
     '    cmpl-float v12, v7, v11\n\n'
     '    if-lez v12, :cond_fit_ok2\n\n'
     '    return-void\n\n'
     '    :cond_fit_ok2\n'
     '    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I\n'),
    # ── UAVA_TAG：账号头像锚点 tag 在 2.6.1 位移了（0xf → 0x12）★ 真机已验证 ★
    #   p5.v()/x5.w() 是按 this.a(tag) 分派的 packed-switch 桶（29 个 case），R8 重排了 case 顺序：
    #     旧 0xf  → check-cast it9; iget it9->e:String          ← 账号数据类
    #     新 0x12 → check-cast d9b; iget d9b->e:String          ← 逐指令同构
    #     新 0xf  → check-cast fs;/es;                          ← 另一条业务（咬它 = 投毒 ⇒ 崩/卡死）
    #   对照：账号名桶 s5/a6 的 tag 0x8 **没位移** ⇒ 账号名一直能用。
    ('gm/GmUAvatarHook.smali',
     "    const/16 v2, 0xf\n\n    if-ne v1, v2, :cond_33",
     "    const/16 v2, 0x12\n\n    if-ne v1, v2, :cond_33"),
]
JSON_HOOK = None

CS = re.compile(r'^(\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*")(.*)("\s*)$')


# ── ⑦ 宿主「成员名」重映射（R8 也改字段名/方法名）
#    这一类是"功能全哑"的真凶：模块要用反射深挖宿主对象，
#    而对象上的方法名/字段名被 R8 换了 ⇒ 静默失效（异常被 try 吞掉）。
#    每处都用「const-string + 紧跟的反射调用」做唯一上下文，避免误伤。
MEMBER_EDITS = [
    # --- GmSuggestHook 里 c1/i1 是方法名（不是类名），任务已还原，这里不动
    # --- GmBubble：Modifier.background 的两个扩展（老 uia.u/v → 新 qk7.C/D）
    ('gm/GmBubble.smali',
     '    const-string v4, "u"\n\n    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod',
     '    const-string v4, "C"\n\n    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod'),
    ('gm/GmBubble.smali',
     '    const-string v4, "v"\n\n    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod',
     '    const-string v4, "D"\n\n    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod'),
    ('gm/GmBubble.smali',
     '    const-string v1, "v"\n\n    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod',
     '    const-string v1, "D"\n\n    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod'),
    ('gm/GmBubble.smali',
     '    const-string v6, "u"\n\n    invoke-static {v5, v6, v4}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod',
     '    const-string v6, "C"\n\n    invoke-static {v5, v6, v4}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod'),
]

def apply_member_edits(dst):
    n = 0
    for rel, o, nw in MEMBER_EDITS:
        fp = os.path.join(dst, 'com/nidyaber/fuckdsmanger', rel)
        if not os.path.exists(fp):
            print('  ⚠️ 缺', rel); continue
        t = open(fp, encoding='utf-8').read()
        c = t.count(o)
        if c == 1:
            open(fp, 'w', encoding='utf-8').write(t.replace(o, nw, 1)); n += 1
        else:
            print(f'  ⚠️ {rel} 上下文出现 {c} 次（跳过）: {o[:40]}')
    return n

def fix_probe_fields(dst):
    """GmProbe 的字段是 private，但 4 个类在读它 ⇒ IllegalAccessError ⇒ 改 public"""
    fp = os.path.join(dst, 'com/nidyaber/fuckdsmanger/gm/GmProbe.smali')
    if not os.path.exists(fp):
        print('  ⚠️ 缺 GmProbe'); return 0
    t = open(fp, encoding='utf-8').read()
    n = t.count('\n.field private static ')
    if n:
        t = t.replace('\n.field private static ', '\n.field public static ')
        open(fp, 'w', encoding='utf-8').write(t)
    return n


def fix_method_name_judges(dst):
    """★★ 2026-10-01 23:3x —— 「按被钩方法名判分支」整类修复 ★★

    底座里有这种写法（专题文档 §四C 早就点过名）：
        method.getName().equals("v")
    R8 把 qk7 的 u/v 改名成 C/D 之后，这些门**恒假** ⇒ 后面的逻辑整段不执行。
    最典型的就是 GmBubblePaintHook.ub()：第一道门 equals("v") 一假，
    「用户气泡定点重写」永远进不去 ⇒ **用户气泡不变色**。

    做法：只在 `Member;->getName()` 之后 15 行内的 `const-string vX, "v"/"u"` 才改，
          而且这两个字符串在该文件里本来就只有这 6 处 ⇒ 精确且安全。
              "v" → "D"      ("uia.v" → "qk7.D"，color 版 background)
              "u" → "C"      ("uia.u" → "qk7.C"，brush 版 background)
    """
    fp = os.path.join(dst, 'com/nidyaber/fuckdsmanger/gm/GmBubblePaintHook.smali')
    if not os.path.exists(fp):
        print('  ⚠️ 缺 GmBubblePaintHook'); return 0
    lines = open(fp, encoding='utf-8').read().split('\n')
    last_getname = -999
    n = 0
    for i, ln in enumerate(lines):
        if 'Member;->getName()' in ln:
            last_getname = i
        m = re.match(r'^(\s*const-string v\d+, ")([vu])("\s*)$', ln)
        if m and 0 < i - last_getname <= 100:
            lines[i] = m.group(1) + ('D' if m.group(2) == 'v' else 'C') + m.group(3)
            n += 1
    if n:
        open(fp, 'w', encoding='utf-8').write('\n'.join(lines))
    # ★ 自检：该文件里独立成串的 "v"/"u" 必须一个不剩（2026-10-01 23:3x 漏过一次）
    left = [i + 1 for i, ln in enumerate(lines)
            if re.match(r'^\s*const-string v\d+, "[vu]"\s*$', ln)]
    if left:
        print(f'  ✗✗ 仍有 {len(left)} 处未改：行 {left} —— 别出包！')
    return n


def main():
    if os.path.exists(DST):
        shutil.rmtree(DST)
    shutil.copytree(SRC, DST)
    n_cls = 0; n_files = 0; n_res = 0
    for dp, _, fs in os.walk(DST):
        for fn in fs:
            if not fn.endswith('.smali') or fn in SKIP_FILES:
                continue
            p = os.path.join(dp, fn)
            txt = open(p, encoding='utf-8').read()
            if txt.startswith('\ufeff'):
                txt = txt[1:]
            lines = txt.split('\n')
            changed = False
            for i, line in enumerate(lines):
                # 先做资源 id 替换（纯文本，够特异）
                for oid, nid in RES_MAP.items():
                    if oid in line:
                        line = line.replace(oid, nid)
                        n_res += 1
                        changed = True
                lines[i] = line
                m = CS.match(line)
                if not m:
                    continue
                v = m.group(2)
                if v in CLASS_MAP:
                    lines[i] = m.group(1) + CLASS_MAP[v] + m.group(3)
                    n_cls += 1
                    changed = True
            if changed:
                open(p, 'w', encoding='utf-8').write('\n'.join(lines))
                n_files += 1
    print(f'✓ 类名替换：{n_files} 个文件 / {n_cls} 处')
    print(f'✓ 资源 ID 平移：{n_res} 处')
    n_t = 0
    for rel, oldseg, newseg in TARGET_EDITS:
        fp = os.path.join(DST, 'com/nidyaber/fuckdsmanger', rel)
        if not os.path.exists(fp):
            print('  ⚠️ 缺文件', fp); continue
        t = open(fp, encoding='utf-8').read()
        if oldseg in t:
            open(fp, 'w', encoding='utf-8').write(t.replace(oldseg, newseg, 1)); n_t += 1
        else:
            print('  ⚠️ 判据片段没找到:', rel)
    print(f'✓ 判据常量平移：{n_t} 处')
    gd = os.path.join(DST, 'com/nidyaber/fuckdsmanger/gm/GmDialog.smali')
    if os.path.exists(gd):
        print(f'✓ 新键纳管：追加 {add_new_keys(gd)} 个宿主新键（83 -> 85）')
    # ⚠️ 2026-10-01 回滚：GmProbe 字段改 public 会复活 4 条从未跑过的钩子，
    #    它们的成员名还是旧的 ⇒ 一跑就咬崩宿主。等逐个修好逻辑再开。
    # print(f'✓ GmProbe 字段改 public：{fix_probe_fields(DST)} 个')
    print('· GmProbe 字段改动【已回滚】(4 条钩子保持哑火，宿主优先)')
    # ⚠️ 2026-10-01 回滚：成员名重映射先只留 qk7(u/v→C/D) 这 4 处（GmBubble 用的，
    #    该钩子本来就能跑）；GmBubbleCellHook 那 3 处随 GmProbe 一起先关掉。
    # ★2026-10-01 晚重开★ 当初"疑似致崩"是【一次改了 7 处 + 复活 4 条钩子】后的结论，
    #   无法定位是哪一处（教训 #328）。现在 frida 活体审计已证明 qk7#v 确实不存在：
    #       [0.3s][callStaticMethod] java.lang.Class .v
    #         ✗ NoSuchMethodError: qk7#v[class mv9, class java.lang.Long, ...]
    #   ⇒ 这次只开这 4 处（GmBubble 的 qk7 u/v→C/D），别的先不动，逐个验。
    # ★ 2026-10-01 23:0x **重新打开** —— 3.42.24 的真机日志把它钉死了：
    #     E java.lang.NoSuchMethodError: qk7#v[class mv9, class java.lang.Long, class t19]
    #     与 frida 活体审计抓到的签名**完全一致**；而 3.42.18 那次崩是
    #     【一次改了 7 处 + 复活 4 条钩子】的混合结果，无法归因（教训 #328）。
    #     形状核对（已做）：
    #         旧 uia.u(Lc76;Lsn0;Lmd8;I)Lc76;   4参  ↔  新 qk7.C(Lx97;Liq0;Lgn9;I)Lx97;  4参 ✓
    #         旧 uia.v(Lc76;JLmd8;)Lc76;        3参  ↔  新 qk7.D(Lx97;JLgn9;)Lx97;       3参 ✓
    #         （c76→x97 Modifier / sn0→iq0 Brush / md8→gn9 Shape，逐项对得上）
    #     ⇒ 本版**只开这 4 处**，别的（GmBubbleCellHook 等）一律不动。
    _me = apply_member_edits(DST)
    print(f'✓ 成员名重映射：{_me} 处（只开 GmBubble 的 4 处）')
    print(f'✓ 方法名判分支整类修复：{fix_method_name_judges(DST)} 处（"v"→"D" / "u"→"C"）')

    # ================================================================
    # ★★ 2026-10-01 22:3x —— 血的教训，必须自动恢复 ★★
    #   GmEntry.smali 在 SKIP_FILES 里（类名替换不碰它），而它里面那两处
    #   `GmRemap.cls()` / `GmRemap.method()` 是**手工加进 smali 树里**的，
    #   不在本脚本里 ⇒ **我一重跑，它们就被冲回原样** ⇒
    #   所有锚点拿着 2.5.2 的旧名字去 findClass ⇒ **功能全灭**（主人：\"能用的全没了\"）。
    #
    #   修法：把它固化成**模板文件**，每次生成完自动覆盖回去。
    #   模板：mod-src/work/GmEntry.261.smali（含 GmRemap 调用 + 寄存器重编号，别手改）
    # ================================================================
    gtpl = os.path.normpath(os.path.join(
        os.path.dirname(os.path.abspath(__file__)), '..', 'mod-src', 'work', 'GmEntry.261.smali'))
    gdst = os.path.join(DST, 'com/nidyaber/fuckdsmanger/GmEntry.smali')
    if os.path.exists(gtpl):
        shutil.copyfile(gtpl, gdst)
        _n = open(gdst, encoding='utf-8').read().count('GmRemap')
        print(f'✓ GmEntry.smali 已从模板恢复：GmRemap 调用 {_n} 处（应为 3）')
    else:
        print('✗✗ 找不到模板 mod-src/work/GmEntry.261.smali —— 锚点会全灭，别继续！')
    print(f'  （GmEntry.smali 跳过 —— 由 GmRemap 在运行时查表）')


# ── ⑤ 新键纳管：往 GmDialog 的 KEYS/NAMES/TYPES 表里追加宿主新键
NEW_KEYS = [
    ("edit_canvas_brush_enabled", "圈选画笔", "b",
     "开关：多模态相机是否提供圈选画笔（下发 false 隐藏画布与圈选引导）"),
    ("enable_wechat_upload", "微信上传入口", "b",
     "开关：是否显示微信上传文件入口"),
    ("key_tts_voice_list", "朗读音色列表", "s",
     "TTS 可选音色列表（JSON 数组，宿主 2.6.1 新增）"),
]

def add_new_keys(path):
    t = open(path, encoding='utf-8').read()
    if 'edit_canvas_brush_enabled' in t:
        return 0
    import re as _re
    n_old = 0x53  # 原表长度（83）
    n_new = n_old + len(NEW_KEYS)
    t = t.replace('const/16 v0, 0x53', 'const/16 v0, 0x%x' % n_new, 1)
    anchor = t.index('sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmDialog;->KEYS:')
    head, tail = t[:anchor], t[anchor:]
    m = list(_re.finditer(r'aput-object v5, v3, v4\s*\n', head))[-1]
    ins = ''
    for k, (key, name, typ, desc) in enumerate(NEW_KEYS):
        ins += ('    const/16 v4, 0x%x\n\n'
                '    const-string v5, "%s"\n\n'
                '    aput-object v5, v1, v4\n\n'
                '    const-string v5, "%s"\n\n'
                '    aput-object v5, v2, v4\n\n'
                '    const-string v5, "%s"\n\n'
                '    aput-object v5, v3, v4\n\n') % (n_old + k, key, name, typ)
    t = head[:m.end()] + ins + head[m.end():] + tail
    # DESCS 串尾部补两行（用正则找那一整行的结尾引号）
    mm = _re.search(r'(\\u6717\\u8bfb\\u97f3\\u8272 ID\\uff08zh-CN[^"]*)"', t)
    if mm:
        extra = ''.join('\\n' + d for _k, _n, _t, d in NEW_KEYS)
        t = t[:mm.end()-1] + extra + t[mm.end()-1:]
    else:
        print('  ⚠️ DESCS 尾串没匹配上（描述未补，不影响功能）')
    open(path, 'w', encoding='utf-8').write(t)
    return len(NEW_KEYS)


if __name__ == '__main__':
    main()

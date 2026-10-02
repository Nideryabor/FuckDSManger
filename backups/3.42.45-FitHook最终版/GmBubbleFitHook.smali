.class public final Lcom/nidyaber/fuckdsmanger/gm/GmBubbleFitHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmBubbleFitHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 16

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v0, :cond_7a

    const-string v2, "d"

    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    # jq0（= Compose ShaderBrush）上：tag=1 ⇒ d 是 RuntimeShader（**我们 imgBrush 造的就是这条**）；tag=0 ⇒ d 是 Shader。
    # 只要是个 Shader 就继续；"是不是我们的"由下面两把钥匙判定。
    instance-of v2, v0, Landroid/graphics/Shader;

    if-eqz v2, :cond_7a

    # ── 取图 · 钥匙①：按 RuntimeShader 实例配对 ─────────────────────────
    #   最稳的一把：这个 RuntimeShader 是 imgBrush() 里亲手 new 的，
    #   而 jq0.<init>(RuntimeShader) 把它原封不动存进 thisObject->d
    #   ⇒ 两边是同一个对象（IdentityHashMap 语义）。宿主中间复制/包装过 brush 也不影响这条。
    const/4 v1, 0x0

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmpShaderMap:Ljava/util/IdentityHashMap;

    if-eqz v2, :fit_key2

    invoke-virtual {v2, v0}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Bitmap;

    if-eqz v2, :fit_key2

    move-object v1, v2

    :fit_key2
    if-nez v1, :fit_has_bmp

    # ── 取图 · 钥匙②：按 brush 实例配对（3.42.34 的老路，保留兜底）──────
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sBmpMap:Ljava/util/IdentityHashMap;

    if-eqz v2, :fit_no_bmp

    invoke-virtual {v2, v0}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Bitmap;

    if-eqz v2, :fit_no_bmp

    move-object v1, v2

    :fit_has_bmp
    # ── 解尺寸 ─────────────────────────────────────────────────────────
    #   参数 J = Compose 的 packed Size（高 32 = width / 低 32 = height）。
    #   事实来源：宿主 Lim9.a(F,J,Lsf;) 用 hv9.b(缓存size,J) 判"尺寸变没变"，
    #   再把这个 J 原样传给本方法；Lim9->b:J 的初值是 NaN,NaN。
    #   （jq0.b(J) 自己不用 J，但传进来的确实是 size —— 见 Lim9.a 的反编译。）
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object v0, v0, v2

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    move-wide v4, v2

    const/16 v0, 0x20

    shr-long/2addr v4, v0

    long-to-int v6, v4

    if-lez v6, :cond_7a

    long-to-int v7, v2

    if-lez v7, :cond_7a

    invoke-static {v6}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result v6

    invoke-static {v7}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result v7

    # ── 算缩放 ─────────────────────────────────────────────────────────
    #   ★ 2026-10-02：**删掉 3.42.37 那道「目标 > 2500 就放行」的尺寸闸门**。
    #     它是基于误判加的 —— 当时把 [FIT] 目标=(1440,25349) 读成"宿主的列表级
    #     ShaderBrush 被我们接管了"，其实那是**我们自己的 brush 被用在一个大节点上**
    #     （宽 1440 = 屏幕宽 ⇒ 那是整页/整列表）。闸门挡的是正常调用，只会让大区域
    #     退回"不缩放"（图贴左上角 + 边缘拉伸）⇒ 反而制造新的错位。
    #     现在改用身份判据，这个启发式不需要了。
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v0

    int-to-float v8, v0

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v0

    int-to-float v9, v0

    div-float v10, v6, v8

    div-float v11, v7, v9

    invoke-static {v10, v11}, Ljava/lang/Math;->max(FF)F

    move-result v10

    # ★★★ 2026-10-02（主人第二轮回执：「下面还是空白」+「不喜欢镜像」）★★★
    #   结论：**封顶必须去掉。**
    #   封顶（min(sCover, zoomF)）会让图盖不满目标区域，而"盖不满"这件事
    #   **任何 TileMode 都补不回来**：
    #     · MIRROR 补出来的是镜像 —— 主人明确说不喜欢；
    #     · CLAMP 补出来的是"最后一行像素"拉成的纯色带 —— 主人原话「连像素延伸都没有」。
    #   ⇒ 「永远铺满」是硬要求、糊是软代价 ⇒ 直接用 sCover，不再 min。
    #   zoomF() 仍然读出来（放 p0）**只用于日志对照**，方便主人一句话切回封顶。
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->zoomF()F

    move-result p0

    # ★ 诊断（临时）：图尺寸 / 目标尺寸 / 最终 scale
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "[FIT] \u56fe="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, "x"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " \u76ee\u6807=("

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v12, v6

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, ","

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v12, v7

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, ") scale="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    # ★ 配置上限对照：这次实际用了 scale，而配置里的上限是 zoom。
    #   scale > zoom 时**不再封顶**（铺满优先），把两个值都打出来，
    #   方便主人判"图要被放大到什么程度 / 会不会糊"，再决定要不要切回封顶。
    const-string v12, " zoom="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/high16 v11, 0x3f000000    # 0.5f

    new-instance v0, Landroid/graphics/Matrix;

    invoke-direct {v0}, Landroid/graphics/Matrix;-><init>()V

    invoke-virtual {v0, v10, v10}, Landroid/graphics/Matrix;->setScale(FF)V

    mul-float v12, v8, v10

    sub-float v12, v12, v6

    neg-float v12, v12

    mul-float v12, v12, v11

    mul-float v13, v9, v10

    sub-float v13, v13, v7

    neg-float v13, v13

    mul-float v13, v13, v11

    invoke-virtual {v0, v12, v13}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    new-instance v12, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;

    # ★ 不封顶 ⇒ 图**正好**盖满目标区域（一点不差）⇒ CLAMP 只是浮点误差的兜底，
    #   不会出现色带，更不会出现镜像。（主人：「我不喜欢镜像」）
    sget-object v13, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v12, v1, v13, v13}, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    iput-object v1, v12, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;

    invoke-virtual {v12, v0}, Landroid/graphics/Shader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    invoke-virtual {p1, v12}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v0, "[\u6c14\u6ce1] \u94fa\u6ee1"

    const-string v1, "\u56fe\u7247\u5e95\u5c45\u4e2d\u88c1\u526a\u94fa\u6ee1\uff0c\u653e\u5927\u4e0d\u8d85\u8fc7\u914d\u7f6e\u4e0a\u9650\uff0c\u8d85\u989d\u90e8\u5206\u7528\u56fe\u7247\u8fb9\u7f18\u8272\u586b\u5145\uff08NL 2.22.29 \u8d77\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :cond_7a

    :fit_no_bmp
    # ★ 两把钥匙都配不上 ⇒ 这不是我们造的 brush（宿主自己的渐变 / 列表级 ShaderBrush）
    #   ⇒ **一律放行**，绝不 setResult。
    #   这里用 logOnce：正常情况一条都不出现；一旦出现，说明宿主的某个 brush 确实
    #   走进了这个钩子 —— 那就是"串图 / 跑到别人底下"的候选来源。
    #   （放在 try 范围内，万一打日志自己出问题也只会被 catchall 吞掉，不会崩宿主。）
    const-string v0, "[FIT] \u4e24\u628a\u94a5\u5319\u90fd\u6ca1\u914d\u4e0a"

    const-string v2, "\u8fd9\u4e2a ShaderBrush \u4e0d\u662f\u6211\u4eec\u9020\u7684 \u21d2 \u653e\u884c\u3002\u82e5\u771f\u7684\u51fa\u73b0\u4e86\uff0c\u8bf4\u660e\u5b83\u8d70\u8fdb\u4e86\u8fd9\u4e2a\u94a9\u5b50\u3002"

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
    :try_end_7a
    .catchall {:try_start_0 .. :try_end_7a} :catchall_7b

    :cond_7a
    return-void

    :catchall_7b
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u56fe\u7247\u5e95\u7f29\u653e\u5931\u8d25\uff08\u5df2\u541e\uff09"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

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

    instance-of v2, v0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;

    if-eqz v2, :cond_7a

    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;

    if-eqz v1, :cond_7a

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

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->zoomF()F

    move-result p0

    invoke-static {v10, p0}, Ljava/lang/Math;->min(FF)F

    move-result v10

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

    sget-object v13, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v12, v1, v13, v13}, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    iput-object v1, v12, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;

    invoke-virtual {v12, v0}, Landroid/graphics/Shader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    invoke-virtual {p1, v12}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v0, "[\u6c14\u6ce1] \u94fa\u6ee1"

    const-string v1, "\u56fe\u7247\u5e95\u5c45\u4e2d\u88c1\u526a\u94fa\u6ee1\uff0c\u653e\u5927\u4e0d\u8d85\u8fc7\u914d\u7f6e\u4e0a\u9650\uff0c\u8d85\u989d\u90e8\u5206\u7528\u56fe\u7247\u8fb9\u7f18\u8272\u586b\u5145\uff08NL 2.22.29 \u8d77\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
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

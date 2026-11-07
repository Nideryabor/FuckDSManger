.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassPanel;
.super Ljava/lang/Object;
.source "GmGlassPanel.java"


# static fields
.field public static final ENGINE_CLOUDY:I = 0x1

.field public static final ENGINE_HAZE:I = 0x0

.field public static final ENGINE_RIPPLE:I = 0x2


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static available()Z
    .registers 1

    .line 46
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->available()Z

    move-result v0

    return v0
.end method

.method public static backdropScale()I
    .registers 1

    const/4 v0, 0x4

    return v0
.end method

.method public static blurCpu(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :cond_1c

    .line 122
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_1c

    .line 124
    :cond_a
    :try_start_a
    sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/4 v2, 0x1

    invoke-virtual {p0, v1, v2}, Landroid/graphics/Bitmap;->copy(Landroid/graphics/Bitmap$Config;Z)Landroid/graphics/Bitmap;

    move-result-object p0

    if-nez p0, :cond_14

    return-object v0

    .line 126
    :cond_14
    invoke-static {v2, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBlur;->blur(Landroid/graphics/Bitmap;I)V
    :try_end_1b
    .catchall {:try_start_a .. :try_end_1b} :catchall_1c

    return-object p0

    :catchall_1c
    :cond_1c
    :goto_1c
    return-object v0
.end method

.method public static draw(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;FFFFIFIFF)Z
    .registers 24

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v0, p0

    move-object v1, p1

    move v4, p2

    move/from16 v5, p3

    move/from16 v6, p4

    move/from16 v7, p5

    move/from16 v8, p6

    move/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v12, p10

    .line 72
    invoke-static/range {v0 .. v12}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassPanel;->drawAt(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIFFFFIFIFF)Z

    move-result p0

    return p0
.end method

.method public static drawAt(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIFFFFIFIFF)Z
    .registers 34

    const/4 v1, 0x0

    if-eqz p0, :cond_6a

    if-eqz p1, :cond_6a

    .line 92
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v0

    if-eqz v0, :cond_c

    goto :goto_6a

    :cond_c
    const/high16 v0, 0x40000000    # 2.0f

    cmpg-float v2, p4, v0

    if-ltz v2, :cond_6a

    cmpg-float v2, p5, v0

    if-gez v2, :cond_17

    goto :goto_6a

    .line 96
    :cond_17
    :try_start_17
    invoke-static/range {p4 .. p5}, Ljava/lang/Math;->min(FF)F

    move-result v2

    const v3, 0x3e3851ec    # 0.18f

    mul-float/2addr v2, v3

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-static {v3, v2}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-static {v0, v2}, Ljava/lang/Math;->max(FF)F

    move-result v10

    const/high16 v0, 0x3f000000    # 0.5f

    move/from16 v2, p7

    .line 98
    invoke-static {v0, v2}, Ljava/lang/Math;->max(FF)F

    move-result v11

    const/16 v17, 0x0

    const/16 v18, 0x0

    const/16 v12, 0xff

    const/16 v16, 0x0

    move-object/from16 v3, p0

    move-object/from16 v4, p1

    move/from16 v5, p2

    move/from16 v6, p3

    move/from16 v7, p4

    move/from16 v8, p5

    move/from16 v9, p6

    move/from16 v14, p8

    move/from16 v13, p9

    move/from16 v15, p10

    move/from16 v19, p11

    move/from16 v20, p12

    .line 97
    invoke-static/range {v3 .. v20}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->draw(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIFFFFFIFIIZFZFF)Z

    move-result v0
    :try_end_55
    .catchall {:try_start_17 .. :try_end_55} :catchall_56

    return v0

    :catchall_56
    move-exception v0

    .line 104
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010GmMiniBar\u3011\u6db2\u6001\u73bb\u7483\u7ed8\u5236\u5931\u8d25\uff08\u9000\u56de\u5e95\u8272\uff09\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "minibar.glass.err"

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_6a
    :goto_6a
    return v1
.end method

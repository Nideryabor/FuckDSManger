.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;
.super Ljava/lang/Object;
.source "GmGlassGpu.java"


# static fields
.field private static final SH_CACHE:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Landroid/graphics/RuntimeShader;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sErrLogged:Z

.field private static volatile sOkLogged:Z

.field private static final sRecPaint:Landroid/graphics/Paint;


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 70
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->SH_CACHE:Ljava/util/HashMap;

    const/4 v0, 0x0

    .line 72
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sErrLogged:Z

    .line 217
    new-instance v1, Landroid/graphics/Paint;

    const/4 v2, 0x1

    invoke-direct {v1, v2}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sRecPaint:Landroid/graphics/Paint;

    .line 218
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sOkLogged:Z

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 52
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static available()Z
    .registers 2

    .line 75
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_8

    const/4 v0, 0x1

    return v0

    :cond_8
    const/4 v0, 0x0

    return v0
.end method

.method static draw(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIFFFFFIFIIZFZFF)Z
    .registers 42

    move-object/from16 v0, p1

    move/from16 v6, p4

    move/from16 v7, p5

    move/from16 v4, p7

    const-string v1, "\u3010GmGlass\u3011GPU \u7ba1\u7ebf\u751f\u6548\uff08"

    const/4 v2, 0x0

    if-eqz v0, :cond_222

    .line 96
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-eqz v3, :cond_15

    goto/16 :goto_222

    :cond_15
    const/high16 v3, 0x40000000    # 2.0f

    cmpg-float v5, v6, v3

    if-ltz v5, :cond_21f

    cmpg-float v5, v7, v3

    if-gez v5, :cond_21

    goto/16 :goto_21f

    .line 101
    :cond_21
    invoke-virtual/range {p0 .. p0}, Landroid/graphics/Canvas;->isHardwareAccelerated()Z

    move-result v5

    if-nez v5, :cond_28

    return v2

    :cond_28
    const/4 v5, 0x1

    if-eqz p13, :cond_37

    .line 104
    :try_start_2b
    invoke-static/range {p1 .. p5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->estimateBg(Landroid/graphics/Bitmap;IIFF)I

    move-result v8

    goto :goto_38

    :catchall_30
    move-exception v0

    move/from16 v23, v2

    move/from16 v17, v5

    goto/16 :goto_207

    :cond_37
    const/4 v8, -0x1

    :goto_38
    move v14, v8

    mul-float/2addr v3, v4

    add-float v8, v6, v3

    .line 105
    invoke-static {v8}, Ljava/lang/Math;->round(F)I

    move-result v8

    add-float/2addr v3, v7

    .line 106
    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 109
    new-instance v9, Landroid/graphics/RenderNode;

    const-string v10, "fdm-glass"

    invoke-direct {v9, v10}, Landroid/graphics/RenderNode;-><init>(Ljava/lang/String;)V

    neg-float v10, v4

    .line 113
    invoke-static {v10}, Ljava/lang/Math;->round(F)I

    move-result v10

    add-int v11, v10, v8

    add-int v12, v10, v3

    .line 114
    invoke-virtual {v9, v10, v10, v11, v12}, Landroid/graphics/RenderNode;->setPosition(IIII)Z

    move/from16 v10, p9

    int-to-float v10, v10

    const/high16 v11, 0x437f0000    # 255.0f

    div-float/2addr v10, v11

    .line 116
    invoke-virtual {v9, v10}, Landroid/graphics/RenderNode;->setAlpha(F)Z

    if-eqz p15, :cond_71

    .line 123
    new-instance v10, Landroid/graphics/Rect;

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v11

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v12

    invoke-direct {v10, v2, v2, v11, v12}, Landroid/graphics/Rect;-><init>(IIII)V

    goto :goto_a7

    .line 127
    :cond_71
    new-instance v10, Landroid/graphics/Rect;

    float-to-int v11, v4

    sub-int v12, p2, v11

    div-int/lit8 v12, v12, 0x4

    .line 128
    invoke-static {v2, v12}, Ljava/lang/Math;->max(II)I

    move-result v12

    sub-int v13, p3, v11

    div-int/lit8 v13, v13, 0x4

    .line 129
    invoke-static {v2, v13}, Ljava/lang/Math;->max(II)I

    move-result v13

    invoke-direct {v10, v12, v13, v2, v2}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 131
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    float-to-int v13, v6

    add-int v13, p2, v13

    add-int/2addr v13, v11

    div-int/lit8 v13, v13, 0x4

    invoke-static {v12, v13}, Ljava/lang/Math;->min(II)I

    move-result v12

    iput v12, v10, Landroid/graphics/Rect;->right:I

    .line 132
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v12

    float-to-int v13, v7

    add-int v13, p3, v13

    add-int/2addr v13, v11

    div-int/lit8 v13, v13, 0x4

    invoke-static {v12, v13}, Ljava/lang/Math;->min(II)I

    move-result v11

    iput v11, v10, Landroid/graphics/Rect;->bottom:I

    .line 134
    :goto_a7
    invoke-virtual {v10}, Landroid/graphics/Rect;->width()I

    move-result v11

    const/4 v12, 0x2

    if-lt v11, v12, :cond_204

    invoke-virtual {v10}, Landroid/graphics/Rect;->height()I

    move-result v11

    if-ge v11, v12, :cond_b6

    goto/16 :goto_204

    .line 136
    :cond_b6
    invoke-virtual {v9, v8, v3}, Landroid/graphics/RenderNode;->beginRecording(II)Landroid/graphics/RecordingCanvas;

    move-result-object v11

    .line 137
    sget-object v12, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sRecPaint:Landroid/graphics/Paint;

    .line 138
    invoke-virtual {v12, v5}, Landroid/graphics/Paint;->setFilterBitmap(Z)V

    .line 139
    new-instance v13, Landroid/graphics/Rect;

    invoke-direct {v13, v2, v2, v8, v3}, Landroid/graphics/Rect;-><init>(IIII)V

    invoke-virtual {v11, v0, v10, v13, v12}, Landroid/graphics/RecordingCanvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Rect;Landroid/graphics/Paint;)V

    .line 140
    invoke-virtual {v9}, Landroid/graphics/RenderNode;->endRecording()V

    .line 145
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    move/from16 v10, p12

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v6}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v7}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static/range {p6 .. p6}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 146
    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/high16 v11, 0x42c80000    # 100.0f

    mul-float v12, p10, v11

    invoke-static {v12}, Ljava/lang/Math;->round(F)I

    move-result v12

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, ":"

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 147
    invoke-static/range {p11 .. p11}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, ":"

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    mul-float v11, v11, p16

    .line 148
    invoke-static {v11}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ":"

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static/range {p17 .. p17}, Ljava/lang/Math;->round(F)I

    move-result v11

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 150
    sget-object v11, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->SH_CACHE:Ljava/util/HashMap;

    monitor-enter v11
    :try_end_141
    .catchall {:try_start_2b .. :try_end_141} :catchall_30

    .line 151
    :try_start_141
    invoke-virtual {v11, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/graphics/RuntimeShader;

    if-nez v12, :cond_199

    move-object v13, v0

    .line 153
    new-instance v0, Landroid/graphics/RuntimeShader;

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->sourceOf(I)Ljava/lang/String;

    move-result-object v12

    invoke-direct {v0, v12}, Landroid/graphics/RuntimeShader;-><init>(Ljava/lang/String;)V
    :try_end_153
    .catchall {:try_start_141 .. :try_end_153} :catchall_1f8

    move v12, v2

    int-to-float v2, v8

    move v15, v3

    int-to-float v3, v15

    move/from16 v16, v5

    move/from16 v5, p7

    move-object/from16 v17, v9

    move/from16 v9, p7

    move-object/from16 v22, v1

    move/from16 v18, v8

    move v1, v10

    move-object/from16 p1, v11

    move/from16 v23, v12

    move-object/from16 v21, v13

    move/from16 v19, v15

    move-object/from16 v20, v17

    move/from16 v8, p6

    move/from16 v10, p10

    move/from16 v11, p11

    move/from16 v12, p13

    move/from16 v13, p14

    move/from16 v15, p16

    move/from16 v17, v16

    move/from16 v16, p17

    .line 155
    :try_start_17e
    invoke-static/range {v0 .. v16}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->setUniforms(Landroid/graphics/RuntimeShader;IFFFFFFFFFIZFIFF)V

    .line 157
    invoke-virtual/range {p1 .. p1}, Ljava/util/HashMap;->size()I

    move-result v1
    :try_end_185
    .catchall {:try_start_17e .. :try_end_185} :catchall_195

    const/16 v2, 0x60

    if-ge v1, v2, :cond_191

    move-object/from16 v1, p1

    move-object/from16 v13, v21

    :try_start_18d
    invoke-virtual {v1, v13, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_193

    :cond_191
    move-object/from16 v1, p1

    :goto_193
    move-object v12, v0

    goto :goto_1a6

    :catchall_195
    move-exception v0

    move-object/from16 v1, p1

    goto :goto_1fe

    :cond_199
    move-object/from16 v22, v1

    move/from16 v23, v2

    move/from16 v19, v3

    move/from16 v17, v5

    move/from16 v18, v8

    move-object/from16 v20, v9

    move-object v1, v11

    .line 159
    :goto_1a6
    monitor-exit v1
    :try_end_1a7
    .catchall {:try_start_18d .. :try_end_1a7} :catchall_202

    .line 161
    :try_start_1a7
    sget-object v0, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    move/from16 v1, p8

    invoke-static {v1, v1, v0}, Landroid/graphics/RenderEffect;->createBlurEffect(FFLandroid/graphics/Shader$TileMode;)Landroid/graphics/RenderEffect;

    move-result-object v0

    .line 163
    const-string v2, "content"

    invoke-static {v12, v2}, Landroid/graphics/RenderEffect;->createRuntimeShaderEffect(Landroid/graphics/RuntimeShader;Ljava/lang/String;)Landroid/graphics/RenderEffect;

    move-result-object v2

    .line 164
    invoke-static {v0, v2}, Landroid/graphics/RenderEffect;->createChainEffect(Landroid/graphics/RenderEffect;Landroid/graphics/RenderEffect;)Landroid/graphics/RenderEffect;

    move-result-object v0

    move-object/from16 v2, v20

    invoke-virtual {v2, v0}, Landroid/graphics/RenderNode;->setRenderEffect(Landroid/graphics/RenderEffect;)Z

    move-object/from16 v0, p0

    .line 167
    invoke-virtual {v0, v2}, Landroid/graphics/Canvas;->drawRenderNode(Landroid/graphics/RenderNode;)V

    .line 169
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sOkLogged:Z

    if-nez v0, :cond_1f7

    .line 170
    sput-boolean v17, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sOkLogged:Z

    .line 171
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v22

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move/from16 v2, v18

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "x"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v15, v19

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u6a21\u7cca="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 172
    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "px\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 171
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_1f7
    .catchall {:try_start_1a7 .. :try_end_1f7} :catchall_200

    :cond_1f7
    return v17

    :catchall_1f8
    move-exception v0

    move/from16 v23, v2

    move/from16 v17, v5

    move-object v1, v11

    .line 159
    :goto_1fe
    :try_start_1fe
    monitor-exit v1
    :try_end_1ff
    .catchall {:try_start_1fe .. :try_end_1ff} :catchall_202

    :try_start_1ff
    throw v0
    :try_end_200
    .catchall {:try_start_1ff .. :try_end_200} :catchall_200

    :catchall_200
    move-exception v0

    goto :goto_207

    :catchall_202
    move-exception v0

    goto :goto_1fe

    :cond_204
    :goto_204
    move/from16 v23, v2

    return v23

    .line 176
    :goto_207
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sErrLogged:Z

    if-nez v1, :cond_21e

    .line 177
    sput-boolean v17, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->sErrLogged:Z

    .line 178
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010GmGlass\u3011GPU \u7ba1\u7ebf\u5931\u8d25\uff08\u9000\u56de CPU \u7248\uff09\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_21e
    return v23

    :cond_21f
    :goto_21f
    move/from16 v23, v2

    return v23

    :cond_222
    :goto_222
    move/from16 v23, v2

    return v23
.end method

.method private static estimateBg(Landroid/graphics/Bitmap;IIFF)I
    .registers 24

    .line 194
    :try_start_0
    invoke-virtual/range {p0 .. p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v1

    invoke-virtual/range {p0 .. p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    const/16 v3, 0x8

    .line 196
    new-array v4, v3, [F

    fill-array-data v4, :array_82

    .line 197
    new-array v5, v3, [F

    fill-array-data v5, :array_96

    const/4 v6, 0x0

    const-wide/16 v7, 0x0

    move-wide v10, v7

    move-wide v12, v10

    move v7, v6

    move-wide v8, v12

    :goto_1b
    if-ge v6, v3, :cond_66

    .line 201
    aget v14, v4, v6

    mul-float v14, v14, p3

    float-to-int v14, v14

    add-int v14, p1, v14

    div-int/lit8 v14, v14, 0x4

    .line 202
    aget v15, v5, v6

    mul-float v15, v15, p4

    float-to-int v15, v15

    add-int v15, p2, v15

    div-int/lit8 v15, v15, 0x4
    :try_end_2f
    .catchall {:try_start_0 .. :try_end_2f} :catchall_7e

    if-ltz v14, :cond_57

    if-ltz v15, :cond_57

    if-ge v14, v1, :cond_57

    if-lt v15, v2, :cond_38

    goto :goto_57

    :cond_38
    move-object/from16 v0, p0

    const/16 v16, -0x1

    .line 204
    :try_start_3c
    invoke-virtual {v0, v14, v15}, Landroid/graphics/Bitmap;->getPixel(II)I

    move-result v14

    shr-int/lit8 v15, v14, 0x10

    and-int/lit16 v15, v15, 0xff

    move/from16 v17, v3

    move-object/from16 v18, v4

    int-to-long v3, v15

    add-long/2addr v8, v3

    shr-int/lit8 v3, v14, 0x8

    and-int/lit16 v3, v3, 0xff

    int-to-long v3, v3

    add-long/2addr v10, v3

    and-int/lit16 v3, v14, 0xff

    int-to-long v3, v3

    add-long/2addr v12, v3

    add-int/lit8 v7, v7, 0x1

    goto :goto_5f

    :cond_57
    :goto_57
    move-object/from16 v0, p0

    move/from16 v17, v3

    move-object/from16 v18, v4

    const/16 v16, -0x1

    :goto_5f
    add-int/lit8 v6, v6, 0x1

    move/from16 v3, v17

    move-object/from16 v4, v18

    goto :goto_1b

    :cond_66
    move/from16 v17, v3

    const/16 v16, -0x1

    if-nez v7, :cond_6d

    return v16

    :cond_6d
    int-to-long v0, v7

    .line 211
    div-long/2addr v8, v0

    long-to-int v2, v8

    shl-int/lit8 v2, v2, 0x10

    const/high16 v3, -0x1000000

    or-int/2addr v2, v3

    div-long/2addr v10, v0

    long-to-int v3, v10

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v2, v3

    div-long/2addr v12, v0
    :try_end_7b
    .catchall {:try_start_3c .. :try_end_7b} :catchall_80

    long-to-int v0, v12

    or-int/2addr v0, v2

    return v0

    :catchall_7e
    const/16 v16, -0x1

    :catchall_80
    return v16

    nop

    :array_82
    .array-data 4
        0x3d75c28f    # 0.06f
        0x3f000000    # 0.5f
        0x3f70a3d7    # 0.94f
        0x3d75c28f    # 0.06f
        0x3f70a3d7    # 0.94f
        0x3d75c28f    # 0.06f
        0x3f000000    # 0.5f
        0x3f70a3d7    # 0.94f
    .end array-data

    :array_96
    .array-data 4
        0x3d75c28f    # 0.06f
        0x3d75c28f    # 0.06f
        0x3d75c28f    # 0.06f
        0x3f000000    # 0.5f
        0x3f000000    # 0.5f
        0x3f70a3d7    # 0.94f
        0x3f70a3d7    # 0.94f
        0x3f70a3d7    # 0.94f
    .end array-data
.end method

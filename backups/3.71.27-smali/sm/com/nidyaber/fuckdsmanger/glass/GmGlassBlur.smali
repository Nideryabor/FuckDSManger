.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassBlur;
.super Ljava/lang/Object;
.source "GmGlassBlur.java"


# static fields
.field private static final PASSES:I = 0x3


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static blur(Landroid/graphics/Bitmap;I)V
    .registers 13

    if-nez p0, :cond_4

    goto/16 :goto_50

    .line 42
    :cond_4
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    .line 43
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    if-lez v2, :cond_50

    if-lez v3, :cond_50

    const/4 v8, 0x1

    if-ge p1, v8, :cond_14

    goto :goto_50

    :cond_14
    mul-int v0, v2, v3

    .line 46
    new-array v1, v0, [I

    .line 47
    new-array v9, v0, [I

    const/4 v4, 0x0

    const/4 v5, 0x0

    move v7, v3

    move v3, v2

    const/4 v2, 0x0

    move v6, v3

    move-object v0, p0

    .line 49
    :try_start_21
    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V
    :try_end_24
    .catchall {:try_start_21 .. :try_end_24} :catchall_50

    add-int v0, p1, p1

    add-int/lit8 v6, v0, 0x1

    add-int/lit8 v5, v3, -0x1

    add-int/lit8 v8, v7, -0x1

    const/4 v0, 0x0

    move v10, v0

    :goto_2e
    const/4 v0, 0x3

    if-ge v10, v0, :cond_48

    move v4, p1

    move-object v0, v1

    move v2, v3

    move v3, v7

    move-object v1, v9

    .line 59
    invoke-static/range {v0 .. v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBlur;->boxBlurH([I[IIIIII)V

    move-object p1, v1

    move-object v1, v0

    move-object v0, p1

    move p1, v5

    move v5, v8

    .line 60
    invoke-static/range {v0 .. v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBlur;->boxBlurV([I[IIIIII)V

    move v3, v2

    add-int/lit8 v10, v10, 0x1

    move-object v9, v0

    move v5, p1

    move p1, v4

    goto :goto_2e

    :cond_48
    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v2, 0x0

    move v6, v3

    move-object v0, p0

    .line 64
    :try_start_4d
    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->setPixels([IIIIIII)V
    :try_end_50
    .catchall {:try_start_4d .. :try_end_50} :catchall_50

    :catchall_50
    :cond_50
    :goto_50
    return-void
.end method

.method private static boxBlurH([I[IIIIII)V
    .registers 24

    move/from16 v0, p2

    move/from16 v1, p4

    move/from16 v2, p5

    move/from16 v4, p3

    const/4 v5, 0x0

    :goto_9
    if-ge v5, v4, :cond_115

    mul-int v6, v5, v0

    add-int v7, v6, v1

    .line 76
    aget v8, p0, v6

    add-int v9, v6, v2

    .line 77
    aget v9, p0, v9

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    :goto_1a
    if-ge v10, v1, :cond_38

    .line 81
    invoke-static {v10, v2}, Ljava/lang/Math;->min(II)I

    move-result v15

    add-int/2addr v15, v6

    aget v15, p0, v15

    ushr-int/lit8 v3, v15, 0x18

    and-int/lit16 v3, v3, 0xff

    add-int/2addr v11, v3

    shr-int/lit8 v3, v15, 0x10

    and-int/lit16 v3, v3, 0xff

    add-int/2addr v12, v3

    shr-int/lit8 v3, v15, 0x8

    and-int/lit16 v3, v3, 0xff

    add-int/2addr v13, v3

    and-int/lit16 v3, v15, 0xff

    add-int/2addr v14, v3

    add-int/lit8 v10, v10, 0x1

    goto :goto_1a

    :cond_38
    const/4 v3, 0x0

    :goto_39
    if-gt v3, v1, :cond_80

    .line 88
    invoke-static {v3, v2}, Ljava/lang/Math;->min(II)I

    move-result v10

    add-int/2addr v10, v6

    aget v10, p0, v10

    ushr-int/lit8 v15, v10, 0x18

    and-int/lit16 v15, v15, 0xff

    ushr-int/lit8 v1, v8, 0x18

    and-int/lit16 v1, v1, 0xff

    sub-int/2addr v15, v1

    add-int/2addr v11, v15

    shr-int/lit8 v1, v10, 0x10

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v15, v8, 0x10

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v1, v15

    add-int/2addr v12, v1

    shr-int/lit8 v1, v10, 0x8

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v15, v8, 0x8

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v1, v15

    add-int/2addr v13, v1

    and-int/lit16 v1, v10, 0xff

    and-int/lit16 v10, v8, 0xff

    sub-int/2addr v1, v10

    add-int/2addr v14, v1

    add-int v1, v6, v3

    .line 94
    div-int v10, v11, p6

    shl-int/lit8 v10, v10, 0x18

    div-int v15, v12, p6

    shl-int/lit8 v15, v15, 0x10

    or-int/2addr v10, v15

    div-int v15, v13, p6

    shl-int/lit8 v15, v15, 0x8

    or-int/2addr v10, v15

    div-int v15, v14, p6

    or-int/2addr v10, v15

    aput v10, p1, v1

    add-int/lit8 v3, v3, 0x1

    move/from16 v1, p4

    goto :goto_39

    :cond_80
    add-int/lit8 v1, p4, 0x1

    move v3, v6

    :goto_83
    sub-int v8, v0, p4

    if-ge v1, v8, :cond_cd

    .line 98
    aget v8, p0, v7

    .line 99
    aget v10, p0, v3

    ushr-int/lit8 v15, v8, 0x18

    and-int/lit16 v15, v15, 0xff

    move/from16 v16, v1

    ushr-int/lit8 v1, v10, 0x18

    and-int/lit16 v1, v1, 0xff

    sub-int/2addr v15, v1

    add-int/2addr v11, v15

    shr-int/lit8 v1, v8, 0x10

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v15, v10, 0x10

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v1, v15

    add-int/2addr v12, v1

    shr-int/lit8 v1, v8, 0x8

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v15, v10, 0x8

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v1, v15

    add-int/2addr v13, v1

    and-int/lit16 v1, v8, 0xff

    and-int/lit16 v8, v10, 0xff

    sub-int/2addr v1, v8

    add-int/2addr v14, v1

    add-int v1, v6, v16

    .line 105
    div-int v8, v11, p6

    shl-int/lit8 v8, v8, 0x18

    div-int v10, v12, p6

    shl-int/lit8 v10, v10, 0x10

    or-int/2addr v8, v10

    div-int v10, v13, p6

    shl-int/lit8 v10, v10, 0x8

    or-int/2addr v8, v10

    div-int v10, v14, p6

    or-int/2addr v8, v10

    aput v8, p1, v1

    add-int/lit8 v7, v7, 0x1

    add-int/lit8 v3, v3, 0x1

    add-int/lit8 v1, v16, 0x1

    goto :goto_83

    :cond_cd
    :goto_cd
    if-ge v8, v0, :cond_10f

    ushr-int/lit8 v1, v9, 0x18

    and-int/lit16 v1, v1, 0xff

    .line 111
    aget v7, p0, v3

    ushr-int/lit8 v10, v7, 0x18

    and-int/lit16 v10, v10, 0xff

    sub-int/2addr v1, v10

    add-int/2addr v11, v1

    shr-int/lit8 v1, v9, 0x10

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v10, v7, 0x10

    and-int/lit16 v10, v10, 0xff

    sub-int/2addr v1, v10

    add-int/2addr v12, v1

    shr-int/lit8 v1, v9, 0x8

    and-int/lit16 v1, v1, 0xff

    shr-int/lit8 v10, v7, 0x8

    and-int/lit16 v10, v10, 0xff

    sub-int/2addr v1, v10

    add-int/2addr v13, v1

    and-int/lit16 v1, v9, 0xff

    and-int/lit16 v7, v7, 0xff

    sub-int/2addr v1, v7

    add-int/2addr v14, v1

    add-int v1, v6, v8

    .line 116
    div-int v7, v11, p6

    shl-int/lit8 v7, v7, 0x18

    div-int v10, v12, p6

    shl-int/lit8 v10, v10, 0x10

    or-int/2addr v7, v10

    div-int v10, v13, p6

    shl-int/lit8 v10, v10, 0x8

    or-int/2addr v7, v10

    div-int v10, v14, p6

    or-int/2addr v7, v10

    aput v7, p1, v1

    add-int/lit8 v3, v3, 0x1

    add-int/lit8 v8, v8, 0x1

    goto :goto_cd

    :cond_10f
    add-int/lit8 v5, v5, 0x1

    move/from16 v1, p4

    goto/16 :goto_9

    :cond_115
    return-void
.end method

.method private static boxBlurV([I[IIIIII)V
    .registers 23

    move/from16 v0, p2

    move/from16 v1, p3

    move/from16 v2, p4

    move/from16 v3, p5

    const/4 v5, 0x0

    :goto_9
    if-ge v5, v0, :cond_118

    mul-int v6, v2, v0

    add-int/2addr v6, v5

    .line 130
    aget v7, p0, v5

    mul-int v8, v3, v0

    add-int/2addr v8, v5

    .line 131
    aget v8, p0, v8

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    :goto_1a
    if-ge v9, v2, :cond_39

    .line 135
    invoke-static {v9, v3}, Ljava/lang/Math;->min(II)I

    move-result v14

    mul-int/2addr v14, v0

    add-int/2addr v14, v5

    aget v14, p0, v14

    ushr-int/lit8 v15, v14, 0x18

    and-int/lit16 v15, v15, 0xff

    add-int/2addr v10, v15

    shr-int/lit8 v15, v14, 0x10

    and-int/lit16 v15, v15, 0xff

    add-int/2addr v11, v15

    shr-int/lit8 v15, v14, 0x8

    and-int/lit16 v15, v15, 0xff

    add-int/2addr v12, v15

    and-int/lit16 v14, v14, 0xff

    add-int/2addr v13, v14

    add-int/lit8 v9, v9, 0x1

    goto :goto_1a

    :cond_39
    const/4 v9, 0x0

    :goto_3a
    if-gt v9, v2, :cond_81

    .line 142
    invoke-static {v9, v3}, Ljava/lang/Math;->min(II)I

    move-result v14

    mul-int/2addr v14, v0

    add-int/2addr v14, v5

    aget v14, p0, v14

    ushr-int/lit8 v15, v14, 0x18

    and-int/lit16 v15, v15, 0xff

    ushr-int/lit8 v4, v7, 0x18

    and-int/lit16 v4, v4, 0xff

    sub-int/2addr v15, v4

    add-int/2addr v10, v15

    shr-int/lit8 v4, v14, 0x10

    and-int/lit16 v4, v4, 0xff

    shr-int/lit8 v15, v7, 0x10

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v4, v15

    add-int/2addr v11, v4

    shr-int/lit8 v4, v14, 0x8

    and-int/lit16 v4, v4, 0xff

    shr-int/lit8 v15, v7, 0x8

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v4, v15

    add-int/2addr v12, v4

    and-int/lit16 v4, v14, 0xff

    and-int/lit16 v14, v7, 0xff

    sub-int/2addr v4, v14

    add-int/2addr v13, v4

    mul-int v4, v9, v0

    add-int/2addr v4, v5

    .line 148
    div-int v14, v10, p6

    shl-int/lit8 v14, v14, 0x18

    div-int v15, v11, p6

    shl-int/lit8 v15, v15, 0x10

    or-int/2addr v14, v15

    div-int v15, v12, p6

    shl-int/lit8 v15, v15, 0x8

    or-int/2addr v14, v15

    div-int v15, v13, p6

    or-int/2addr v14, v15

    aput v14, p1, v4

    add-int/lit8 v9, v9, 0x1

    goto :goto_3a

    :cond_81
    add-int/lit8 v4, v2, 0x1

    move v7, v5

    :goto_84
    sub-int v9, v1, v2

    if-ge v4, v9, :cond_cf

    .line 152
    aget v9, p0, v6

    .line 153
    aget v14, p0, v7

    ushr-int/lit8 v15, v9, 0x18

    and-int/lit16 v15, v15, 0xff

    ushr-int/lit8 v0, v14, 0x18

    and-int/lit16 v0, v0, 0xff

    sub-int/2addr v15, v0

    add-int/2addr v10, v15

    shr-int/lit8 v0, v9, 0x10

    and-int/lit16 v0, v0, 0xff

    shr-int/lit8 v15, v14, 0x10

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v0, v15

    add-int/2addr v11, v0

    shr-int/lit8 v0, v9, 0x8

    and-int/lit16 v0, v0, 0xff

    shr-int/lit8 v15, v14, 0x8

    and-int/lit16 v15, v15, 0xff

    sub-int/2addr v0, v15

    add-int/2addr v12, v0

    and-int/lit16 v0, v9, 0xff

    and-int/lit16 v9, v14, 0xff

    sub-int/2addr v0, v9

    add-int/2addr v13, v0

    mul-int v0, v4, p2

    add-int/2addr v0, v5

    .line 159
    div-int v9, v10, p6

    shl-int/lit8 v9, v9, 0x18

    div-int v14, v11, p6

    shl-int/lit8 v14, v14, 0x10

    or-int/2addr v9, v14

    div-int v14, v12, p6

    shl-int/lit8 v14, v14, 0x8

    or-int/2addr v9, v14

    div-int v14, v13, p6

    or-int/2addr v9, v14

    aput v9, p1, v0

    add-int v6, v6, p2

    add-int v7, v7, p2

    add-int/lit8 v4, v4, 0x1

    move/from16 v0, p2

    goto :goto_84

    :cond_cf
    :goto_cf
    if-ge v9, v1, :cond_112

    ushr-int/lit8 v0, v8, 0x18

    and-int/lit16 v0, v0, 0xff

    .line 165
    aget v4, p0, v7

    ushr-int/lit8 v6, v4, 0x18

    and-int/lit16 v6, v6, 0xff

    sub-int/2addr v0, v6

    add-int/2addr v10, v0

    shr-int/lit8 v0, v8, 0x10

    and-int/lit16 v0, v0, 0xff

    shr-int/lit8 v6, v4, 0x10

    and-int/lit16 v6, v6, 0xff

    sub-int/2addr v0, v6

    add-int/2addr v11, v0

    shr-int/lit8 v0, v8, 0x8

    and-int/lit16 v0, v0, 0xff

    shr-int/lit8 v6, v4, 0x8

    and-int/lit16 v6, v6, 0xff

    sub-int/2addr v0, v6

    add-int/2addr v12, v0

    and-int/lit16 v0, v8, 0xff

    and-int/lit16 v4, v4, 0xff

    sub-int/2addr v0, v4

    add-int/2addr v13, v0

    mul-int v0, v9, p2

    add-int/2addr v0, v5

    .line 170
    div-int v4, v10, p6

    shl-int/lit8 v4, v4, 0x18

    div-int v6, v11, p6

    shl-int/lit8 v6, v6, 0x10

    or-int/2addr v4, v6

    div-int v6, v12, p6

    shl-int/lit8 v6, v6, 0x8

    or-int/2addr v4, v6

    div-int v6, v13, p6

    or-int/2addr v4, v6

    aput v4, p1, v0

    add-int v7, v7, p2

    add-int/lit8 v9, v9, 0x1

    goto :goto_cf

    :cond_112
    add-int/lit8 v5, v5, 0x1

    move/from16 v0, p2

    goto/16 :goto_9

    :cond_118
    return-void
.end method

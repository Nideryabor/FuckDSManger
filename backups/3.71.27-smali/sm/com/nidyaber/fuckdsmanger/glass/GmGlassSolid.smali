.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;
.super Ljava/lang/Object;
.source "GmGlassSolid.java"


# static fields
.field private static final CACHE:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private static final SIZE:I = 0x40


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 42
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->CACHE:Ljava/util/HashMap;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static argb(IIII)I
    .registers 4

    shl-int/lit8 p0, p0, 0x18

    shl-int/lit8 p1, p1, 0x10

    or-int/2addr p0, p1

    shl-int/lit8 p1, p2, 0x8

    or-int/2addr p0, p1

    or-int/2addr p0, p3

    return p0
.end method

.method private static build(I)Landroid/graphics/Bitmap;
    .registers 15

    ushr-int/lit8 v0, p0, 0x18

    const/16 v1, 0xff

    and-int/2addr v0, v1

    shr-int/lit8 v2, p0, 0x10

    and-int/2addr v2, v1

    shr-int/lit8 v3, p0, 0x8

    and-int/2addr v3, v1

    and-int/2addr p0, v1

    if-nez v0, :cond_13

    const/16 v2, 0x28

    move p0, v2

    move v3, p0

    goto :goto_14

    :cond_13
    move v1, v0

    :goto_14
    const v0, 0x3f970a3d    # 1.18f

    .line 70
    :try_start_17
    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result v4

    invoke-static {v3, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result v5

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result v0

    invoke-static {v1, v4, v5, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->argb(IIII)I

    move-result v11

    const v0, 0x3f5c28f6    # 0.86f

    .line 71
    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result v2

    invoke-static {v3, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result v3

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->lift(IF)I

    move-result p0

    invoke-static {v1, v2, v3, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->argb(IIII)I

    move-result v12

    .line 73
    sget-object p0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/16 v0, 0x40

    invoke-static {v0, v0, p0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object p0

    .line 74
    new-instance v0, Landroid/graphics/Canvas;

    invoke-direct {v0, p0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 75
    new-instance v5, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v5, v1}, Landroid/graphics/Paint;-><init>(I)V

    .line 76
    new-instance v6, Landroid/graphics/LinearGradient;

    sget-object v13, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/high16 v10, 0x42800000    # 64.0f

    invoke-direct/range {v6 .. v13}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    invoke-virtual {v5, v6}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    const/high16 v3, 0x42800000    # 64.0f

    const/high16 v4, 0x42800000    # 64.0f

    const/4 v1, 0x0

    const/4 v2, 0x0

    .line 77
    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V
    :try_end_65
    .catchall {:try_start_17 .. :try_end_65} :catchall_66

    return-object p0

    :catchall_66
    const/4 p0, 0x0

    return-object p0
.end method

.method private static lift(IF)I
    .registers 2

    int-to-float p0, p0

    mul-float/2addr p0, p1

    .line 85
    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    if-gez p0, :cond_a

    const/4 p0, 0x0

    return p0

    :cond_a
    const/16 p1, 0xff

    if-le p0, p1, :cond_f

    return p1

    :cond_f
    return p0
.end method

.method static make(I)Landroid/graphics/Bitmap;
    .registers 5

    .line 51
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->CACHE:Ljava/util/HashMap;

    monitor-enter v0

    .line 52
    :try_start_3
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/Bitmap;

    if-eqz v1, :cond_17

    .line 53
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v2

    if-nez v2, :cond_17

    monitor-exit v0

    return-object v1

    .line 54
    :cond_17
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->build(I)Landroid/graphics/Bitmap;

    move-result-object v1

    if-eqz v1, :cond_2c

    .line 55
    invoke-virtual {v0}, Ljava/util/HashMap;->size()I

    move-result v2

    const/16 v3, 0x40

    if-ge v2, v3, :cond_2c

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {v0, p0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 56
    :cond_2c
    monitor-exit v0

    return-object v1

    :catchall_2e
    move-exception p0

    .line 57
    monitor-exit v0
    :try_end_30
    .catchall {:try_start_3 .. :try_end_30} :catchall_2e

    throw p0
.end method

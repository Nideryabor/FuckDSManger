.class public final Lcom/nidyaber/fuckdsmanger/gm/GmBgView;
.super Landroid/view/View;
.source "GmBgView.java"


# static fields
.field static final P:[[I


# instance fields
.field a:Landroid/graphics/Paint;

.field b:Landroid/graphics/LinearGradient;

.field c:Landroid/graphics/Bitmap;

.field d:Landroid/graphics/Matrix;

.field e:I

.field f:I

.field g:I

.field h:I


# direct methods
.method static constructor <clinit>()V
    .registers 4

    const/4 v0, 0x4

    new-array v0, v0, [[I

    const/4 v1, 0x0

    const/4 v2, 0x4

    new-array v2, v2, [I

    fill-array-data v2, :array_2a

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const/4 v2, 0x4

    new-array v2, v2, [I

    fill-array-data v2, :array_36

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const/4 v2, 0x4

    new-array v2, v2, [I

    fill-array-data v2, :array_42

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const/4 v2, 0x4

    new-array v2, v2, [I

    fill-array-data v2, :array_4e

    aput-object v2, v0, v1

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->P:[[I

    return-void

    :array_2a
    .array-data 4
        -0xf4efda
        -0xe4d595
        -0xd19458
        -0xb7393a
    .end array-data

    :array_36
    .array-data 4
        -0xd4efab
        -0x8a6822
        -0x73be
        -0x2e9a
    .end array-data

    :array_42
    .array-data 4
        -0xf0dfd9
        -0xdfc5bd
        -0xd3ac9c
        -0xb11e60
    .end array-data

    :array_4e
    .array-data 4
        -0xe0e3e8
        -0xb5c4d6
        -0x4f83b1
        -0xd3787
    .end array-data
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .registers 3

    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setWillNotDraw(Z)V

    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0}, Landroid/graphics/Paint;-><init>()V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->a:Landroid/graphics/Paint;

    new-instance v0, Landroid/graphics/Matrix;

    invoke-direct {v0}, Landroid/graphics/Matrix;-><init>()V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->d:Landroid/graphics/Matrix;

    return-void
.end method

.method private build()V
    .registers 14

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_3c

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->P:[[I

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->f:I

    array-length v3, v1

    rem-int/2addr v2, v3

    aget-object v1, v1, v2

    const/4 v2, 0x5

    new-array v3, v2, [I

    const/4 v2, 0x0

    aget v4, v1, v2

    aput v4, v3, v2

    const/4 v2, 0x1

    aget v4, v1, v2

    aput v4, v3, v2

    const/4 v2, 0x2

    aget v4, v1, v2

    aput v4, v3, v2

    const/4 v2, 0x3

    aget v4, v1, v2

    aput v4, v3, v2

    const/4 v2, 0x4

    const/4 v4, 0x0

    aget v4, v1, v4

    aput v4, v3, v2

    new-instance v4, Landroid/graphics/LinearGradient;

    const/4 v5, 0x0

    const/4 v6, 0x0

    mul-int/lit8 v2, v0, 0x2

    int-to-float v7, v2

    const/4 v8, 0x0

    move-object v9, v3

    const/4 v10, 0x0

    sget-object v11, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct/range {v4 .. v11}, Landroid/graphics/LinearGradient;-><init>(FFFF[I[FLandroid/graphics/Shader$TileMode;)V

    iput-object v4, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->b:Landroid/graphics/LinearGradient;

    :cond_3c
    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .registers 16

    invoke-super {p0, p1}, Landroid/view/View;->onDraw(Landroid/graphics/Canvas;)V

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    if-lez v0, :cond_d2

    if-lez v1, :cond_d2

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "w="

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " h="

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " e="

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->e:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " g="

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->g:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " bmp="

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v13, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->c:Landroid/graphics/Bitmap;

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    const-string v13, "[\u80cc\u666f] onDraw"

    invoke-static {v13, v12}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->a:Landroid/graphics/Paint;

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->g:I

    const/16 v4, 0xff

    mul-int/2addr v3, v4

    const/16 v4, 0x64

    div-int/2addr v3, v4

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setAlpha(I)V

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->h:I

    if-eqz v3, :cond_6c

    const/4 v4, 0x1

    if-ne v3, v4, :cond_62

    sget-object v3, Landroid/graphics/PorterDuff$Mode;->MULTIPLY:Landroid/graphics/PorterDuff$Mode;

    goto :goto_64

    :cond_62
    sget-object v3, Landroid/graphics/PorterDuff$Mode;->SCREEN:Landroid/graphics/PorterDuff$Mode;

    :goto_64
    new-instance v4, Landroid/graphics/PorterDuffXfermode;

    invoke-direct {v4, v3}, Landroid/graphics/PorterDuffXfermode;-><init>(Landroid/graphics/PorterDuff$Mode;)V

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setXfermode(Landroid/graphics/Xfermode;)Landroid/graphics/Xfermode;

    :cond_6c
    iget v3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->e:I

    if-nez v3, :cond_a5

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->c:Landroid/graphics/Bitmap;

    if-eqz v3, :cond_a5

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    if-lez v4, :cond_a5

    if-lez v5, :cond_a5

    int-to-float v6, v0

    int-to-float v7, v4

    div-float/2addr v6, v7

    int-to-float v7, v1

    int-to-float v8, v5

    div-float/2addr v7, v8

    invoke-static {v6, v7}, Ljava/lang/Math;->max(FF)F

    move-result v6

    int-to-float v7, v4

    mul-float/2addr v7, v6

    int-to-float v8, v0

    sub-float/2addr v8, v7

    const/high16 v7, 0x3f000000    # 0.5f

    mul-float/2addr v8, v7

    int-to-float v9, v5

    mul-float/2addr v9, v6

    int-to-float v10, v1

    sub-float/2addr v10, v9

    mul-float/2addr v10, v7

    iget-object v9, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->d:Landroid/graphics/Matrix;

    invoke-virtual {v9}, Landroid/graphics/Matrix;->reset()V

    invoke-virtual {v9, v6, v6}, Landroid/graphics/Matrix;->setScale(FF)V

    invoke-virtual {v9, v8, v10}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    invoke-virtual {p1, v3, v9, v2}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Matrix;Landroid/graphics/Paint;)V

    return-void

    :cond_a5
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->b:Landroid/graphics/LinearGradient;

    if-eqz v3, :cond_d2

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    const-wide/16 v6, 0x2328

    rem-long/2addr v4, v6

    long-to-float v4, v4

    const v5, 0x461c4000    # 10000.0f

    div-float/2addr v4, v5

    int-to-float v5, v0

    mul-float/2addr v4, v5

    neg-float v4, v4

    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->d:Landroid/graphics/Matrix;

    invoke-virtual {v5}, Landroid/graphics/Matrix;->reset()V

    const/4 v6, 0x0

    invoke-virtual {v5, v4, v6}, Landroid/graphics/Matrix;->setTranslate(FF)V

    invoke-virtual {v3, v5}, Landroid/graphics/LinearGradient;->setLocalMatrix(Landroid/graphics/Matrix;)V

    move-object v4, p1

    const/4 v5, 0x0

    int-to-float v5, v5

    const/4 v6, 0x0

    int-to-float v6, v6

    int-to-float v7, v0

    int-to-float v8, v1

    move-object v9, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    :cond_d2
    invoke-virtual {p0}, Landroid/view/View;->postInvalidateOnAnimation()V

    return-void
.end method

.method protected onSizeChanged(IIII)V
    .registers 5

    invoke-super {p0, p1, p2, p3, p4}, Landroid/view/View;->onSizeChanged(IIII)V

    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->build()V

    return-void
.end method

.method public setBlend(I)V
    .registers 2

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->h:I

    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setup(IIILandroid/graphics/Bitmap;)V
    .registers 6

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->e:I

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->f:I

    iput p3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->g:I

    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBgView;->c:Landroid/graphics/Bitmap;

    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

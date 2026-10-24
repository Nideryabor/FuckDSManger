.class public final Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;
.super Landroid/graphics/BitmapShader;
.source "GmBmpShader.java"


# instance fields
.field public bmp:Landroid/graphics/Bitmap;

# ★ 2026-10-02：我们算好的"铺满"基础矩阵（scale + 居中）。
#   为什么需要它：宿主 ob7.i 会**逐片**把 shader 的局部矩阵整个替换成"纯平移"
#   （Matrix.setTranslate 是替换不是叠加）⇒ 我们设的铺满矩阵**活不过一次绘制循环**。
#   ⇒ 这里改成：宿主来设矩阵时，我们**不照单全收**，而是合成 M0 ∘ T
#      （采样 = M0(p + T)）——保住缩放，同时跟随宿主的逐片平移。
.field public m0:Landroid/graphics/Matrix;


# direct methods
.method public constructor <init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V
    .registers 4

    invoke-direct {p0, p1, p2, p3}, Landroid/graphics/BitmapShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    return-void
.end method


# virtual methods
# ★ 设置"基础矩阵"：同时记住它，供后面的合成用（构造时由 FitHook 调）
.method public final baseMatrix(Landroid/graphics/Matrix;)V
    .registers 2

    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->m0:Landroid/graphics/Matrix;

    invoke-super {p0, p1}, Landroid/graphics/Shader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    return-void
.end method

# ★ override：宿主调 setLocalMatrix(纯平移 T) 时，合成 M0 ∘ T，而不是把它整个顶掉
.method public setLocalMatrix(Landroid/graphics/Matrix;)V
    .registers 12

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmBmpShader;->m0:Landroid/graphics/Matrix;

    if-eqz v0, :pass

    if-eqz p1, :pass

    # v1 = new Matrix(m0)
    new-instance v1, Landroid/graphics/Matrix;

    invoke-direct {v1, v0}, Landroid/graphics/Matrix;-><init>(Landroid/graphics/Matrix;)V

    # v2 = float[9] ; m0.getValues(v2)
    const/16 v3, 0x9

    new-array v2, v3, [F

    invoke-virtual {v0, v2}, Landroid/graphics/Matrix;->getValues([F)V

    # v4 = float[9] ; T.getValues(v4)
    new-array v4, v3, [F

    invoke-virtual {p1, v4}, Landroid/graphics/Matrix;->getValues([F)V

    # v5 = T.tx ; v6 = T.ty
    const/4 v5, 0x2

    aget v5, v4, v5

    const/4 v6, 0x5

    aget v6, v4, v6

    # v7 = w0*tx + w1*ty   （输出空间的位移 = 线性部分 × 平移）
    const/4 v7, 0x0

    aget v7, v2, v7

    mul-float/2addr v7, v5

    const/4 v8, 0x1

    aget v8, v2, v8

    mul-float/2addr v8, v6

    add-float/2addr v7, v8

    # v8 = w3*tx + w4*ty
    const/4 v8, 0x3

    aget v8, v2, v8

    mul-float/2addr v8, v5

    const/4 v9, 0x4

    aget v9, v2, v9

    mul-float/2addr v9, v6

    add-float/2addr v8, v9

    invoke-virtual {v1, v7, v8}, Landroid/graphics/Matrix;->postTranslate(FF)V

    invoke-super {p0, v1}, Landroid/graphics/Shader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    return-void

    # m0 还没设 / 传入 null ⇒ 原样直通（保持老行为，绝不更差）
    :pass
    invoke-super {p0, p1}, Landroid/graphics/Shader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    return-void
.end method

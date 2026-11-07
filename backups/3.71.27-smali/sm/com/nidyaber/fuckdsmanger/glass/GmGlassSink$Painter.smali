.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;
.super Ljava/lang/Object;
.source "GmGlassSink.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NativePainter;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Painter"
.end annotation


# instance fields
.field private final back:Landroid/graphics/Bitmap;

.field private final cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

.field private final fadeAmt:F

.field private final fadePx:F

.field private final fit:Landroid/graphics/Path;

.field private final h:F

.field private final ox:I

.field private final oy:I

.field private final r:F

.field private final stretch:Z

.field private final w:F


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;FFFIILandroid/graphics/Bitmap;ZLandroid/graphics/Path;FF)V
    .registers 12

    .line 948
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 949
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    .line 950
    iput p2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->w:F

    .line 951
    iput p3, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->h:F

    .line 952
    iput p4, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->r:F

    .line 953
    iput p5, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    .line 954
    iput p6, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    .line 955
    iput-object p7, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    .line 956
    iput-boolean p8, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->stretch:Z

    .line 957
    iput-object p9, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fit:Landroid/graphics/Path;

    .line 958
    iput p10, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadeAmt:F

    .line 959
    iput p11, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadePx:F

    return-void
.end method


# virtual methods
.method public paint(Landroid/graphics/Canvas;)V
    .registers 30

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const-string v2, "\u3010GmGlass\u3011\u6298\u5c04\u5df2\u751f\u6548\uff08"

    .line 965
    iget v5, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->w:F

    iget v6, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->h:F

    .line 967
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRect:Landroid/graphics/RectF;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2700()Landroid/graphics/RectF;

    move-result-object v3

    const/4 v4, 0x0

    invoke-virtual {v3, v4, v4, v5, v6}, Landroid/graphics/RectF;->set(FFFF)V

    .line 968
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPath:Landroid/graphics/Path;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2800()Landroid/graphics/Path;

    move-result-object v3

    invoke-virtual {v3}, Landroid/graphics/Path;->reset()V

    .line 969
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPath:Landroid/graphics/Path;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2800()Landroid/graphics/Path;

    move-result-object v3

    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRect:Landroid/graphics/RectF;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2700()Landroid/graphics/RectF;

    move-result-object v7

    iget v8, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->r:F

    sget-object v9, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual {v3, v7, v8, v8, v9}, Landroid/graphics/Path;->addRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Path$Direction;)V

    .line 971
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fit:Landroid/graphics/Path;

    if-eqz v3, :cond_2d

    goto :goto_31

    :cond_2d
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPath:Landroid/graphics/Path;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2800()Landroid/graphics/Path;

    move-result-object v3

    .line 973
    :goto_31
    invoke-virtual {v1}, Landroid/graphics/Canvas;->save()I

    move-result v7

    .line 976
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->tick()D

    move-result-wide v8

    const-wide/high16 v10, 0x3ff0000000000000L    # 1.0

    sub-double v10, v8, v10

    .line 977
    invoke-static {v10, v11}, Ljava/lang/Math;->abs(D)D

    move-result-wide v10

    const-wide v12, 0x3f50624dd2f1a9fcL    # 0.001

    cmpl-double v10, v10, v12

    const/high16 v11, 0x40000000    # 2.0f

    if-lez v10, :cond_54

    double-to-float v8, v8

    div-float v9, v5, v11

    div-float v10, v6, v11

    .line 979
    invoke-virtual {v1, v8, v8, v9, v10}, Landroid/graphics/Canvas;->scale(FFFF)V

    .line 985
    :cond_54
    invoke-virtual {v1, v4, v4, v5, v6}, Landroid/graphics/Canvas;->clipRect(FFFF)Z

    .line 986
    invoke-virtual {v1, v3}, Landroid/graphics/Canvas;->clipPath(Landroid/graphics/Path;)Z

    .line 996
    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v4, v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->color:I

    ushr-int/lit8 v4, v4, 0x18

    const/16 v8, 0xff

    and-int/2addr v4, v8

    .line 997
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v9, v9, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->tint:I

    int-to-float v9, v9

    const v10, 0x40233333    # 2.55f

    mul-float/2addr v9, v10

    int-to-float v4, v4

    const/high16 v10, 0x437f0000    # 255.0f

    div-float/2addr v4, v10

    mul-float/2addr v9, v4

    invoke-static {v9}, Ljava/lang/Math;->round(F)I

    move-result v4

    if-gez v4, :cond_78

    const/4 v4, 0x0

    :cond_78
    if-le v4, v8, :cond_7b

    move v4, v8

    :cond_7b
    shl-int/lit8 v4, v4, 0x18

    .line 1014
    iget-object v10, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v10, v10, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->color:I

    const v12, 0xffffff

    and-int/2addr v10, v12

    or-int v12, v4, v10

    .line 1015
    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v4, v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->disp:I

    int-to-float v4, v4

    const/high16 v10, 0x41200000    # 10.0f

    div-float v10, v4, v10

    const/high16 v4, 0x41c00000    # 24.0f

    .line 1016
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->density()F

    move-result v13

    mul-float/2addr v13, v4

    .line 1017
    invoke-static {v5, v6}, Ljava/lang/Math;->min(FF)F

    move-result v4

    const/high16 v14, 0x3f000000    # 0.5f

    mul-float/2addr v4, v14

    .line 1016
    invoke-static {v13, v4}, Ljava/lang/Math;->min(FF)F

    move-result v4

    invoke-static {v11, v4}, Ljava/lang/Math;->max(FF)F

    move-result v4

    .line 1020
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->wantGpu()Z

    move-result v11

    const/high16 v19, 0x42c80000    # 100.0f

    if-eqz v11, :cond_11a

    iget-object v11, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    if-eqz v11, :cond_11a

    invoke-virtual {v11}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v11

    if-nez v11, :cond_11a

    iget v11, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    if-ltz v11, :cond_11a

    iget v11, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    if-ltz v11, :cond_11a

    .line 1022
    iget-object v11, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v11, v11, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->blur:I

    int-to-float v11, v11

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->density()F

    move-result v13

    mul-float/2addr v11, v13

    mul-float/2addr v11, v14

    const/high16 v13, 0x3f800000    # 1.0f

    invoke-static {v13, v11}, Ljava/lang/Math;->max(FF)F

    move-result v11

    move-object v13, v2

    .line 1023
    iget-object v2, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    move-object v14, v3

    iget v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    move v15, v8

    move v8, v4

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    move/from16 v16, v7

    iget v7, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->r:F

    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v9, v9, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->engine:I

    iget-object v15, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget-boolean v15, v15, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->clean:Z

    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v1, v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->cleanTol:I

    int-to-float v1, v1

    div-float v1, v1, v19

    move/from16 v20, v1

    iget-boolean v1, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->stretch:Z

    move/from16 v21, v1

    iget v1, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadeAmt:F

    move/from16 v22, v1

    iget v1, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadePx:F

    move-object/from16 v23, v13

    move v13, v9

    move v9, v11

    move v11, v10

    const/16 v10, 0xff

    move/from16 v18, v1

    move-object/from16 v24, v14

    move v14, v15

    move/from16 v25, v16

    move/from16 v15, v20

    move/from16 v16, v21

    move/from16 v17, v22

    move-object/from16 v26, v23

    move-object/from16 v1, p1

    invoke-static/range {v1 .. v18}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->draw(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIFFFFFIFIIZFZFF)Z

    move-result v9

    move v10, v11

    move v11, v12

    move v2, v9

    goto :goto_123

    :cond_11a
    move-object/from16 v26, v2

    move-object/from16 v24, v3

    move v8, v4

    move/from16 v25, v7

    move v11, v12

    const/4 v2, 0x0

    :goto_123
    const/4 v3, 0x1

    if-nez v2, :cond_1d7

    .line 1028
    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    if-eqz v4, :cond_1d7

    invoke-virtual {v4}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v4

    if-nez v4, :cond_1d7

    iget-boolean v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->stretch:Z

    if-nez v4, :cond_13c

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    if-ltz v4, :cond_1d7

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    if-ltz v4, :cond_1d7

    :cond_13c
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v7, 0x21

    if-lt v4, v7, :cond_1d7

    move v4, v3

    .line 1031
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    move v7, v4

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    move v9, v7

    move v7, v6

    move v6, v5

    iget v5, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    move v12, v9

    move v9, v8

    iget v8, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->r:F

    iget-object v13, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v13, v13, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->engine:I

    iget-object v14, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget-boolean v14, v14, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->clean:Z

    iget-object v15, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->cfg:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v15, v15, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->cleanTol:I

    int-to-float v15, v15

    div-float v15, v15, v19

    iget-boolean v12, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->stretch:Z

    move/from16 v19, v2

    iget v2, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadeAmt:F

    move/from16 v17, v2

    iget v2, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->fadePx:F

    move/from16 v16, v12

    move v12, v13

    move v13, v14

    move v14, v15

    const/16 v18, 0x1

    const/4 v15, -0x1

    move/from16 v27, v18

    move/from16 v18, v2

    move/from16 v2, v27

    invoke-static/range {v3 .. v18}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->make(Landroid/graphics/Bitmap;IIFFFFFIIZFIZFF)Landroid/graphics/Shader;

    move-result-object v3

    move v5, v6

    move v6, v7

    if-eqz v3, :cond_1da

    const/4 v4, 0x0

    .line 1036
    :try_start_181
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2900()Landroid/graphics/Paint;

    move-result-object v7

    invoke-virtual {v7, v3}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 1037
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2900()Landroid/graphics/Paint;

    move-result-object v3

    const/16 v15, 0xff

    invoke-virtual {v3, v15}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 1038
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2900()Landroid/graphics/Paint;

    move-result-object v3

    move-object/from16 v14, v24

    invoke-virtual {v1, v14, v3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V
    :try_end_19a
    .catchall {:try_start_181 .. :try_end_19a} :catchall_1cf

    .line 1040
    :try_start_19a
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3000()Z

    move-result v3

    if-nez v3, :cond_1c3

    .line 1041
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensLogged:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3002(Z)Z

    .line 1042
    new-instance v3, Ljava/lang/StringBuilder;

    move-object/from16 v13, v26

    invoke-direct {v3, v13}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    float-to-int v7, v5

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "x"

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v7, v6

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "\uff09"

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_1c3
    .catchall {:try_start_19a .. :try_end_1c3} :catchall_1cd

    .line 1046
    :cond_1c3
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2900()Landroid/graphics/Paint;

    move-result-object v3

    invoke-virtual {v3, v4}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    move/from16 v19, v2

    goto :goto_1da

    :catchall_1cd
    move/from16 v19, v2

    :catchall_1cf
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2900()Landroid/graphics/Paint;

    move-result-object v3

    invoke-virtual {v3, v4}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    goto :goto_1da

    :cond_1d7
    move/from16 v19, v2

    move v2, v3

    :cond_1da
    :goto_1da
    if-nez v19, :cond_21b

    .line 1052
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u6298\u5c04\u6ca1\u7528\u4e0a \u00b7 sdk="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " \u00b7 \u5e95\u56fe="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1053
    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    if-nez v4, :cond_1f4

    const-string v4, "null"

    goto :goto_1f6

    :cond_1f4
    const-string v4, "\u6709"

    :goto_1f6
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \u00b7 \u539f\u70b9=("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ","

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ")"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 1052
    const-string v4, "nolens"

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {v4, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V

    :cond_21b
    if-nez v19, :cond_293

    .line 1058
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    if-eqz v3, :cond_293

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-nez v3, :cond_293

    iget-boolean v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->stretch:Z

    if-nez v3, :cond_233

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    if-ltz v4, :cond_293

    iget v4, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    if-ltz v4, :cond_293

    :cond_233
    if-eqz v3, :cond_237

    move v4, v2

    goto :goto_238

    :cond_237
    const/4 v4, 0x4

    :goto_238
    if-eqz v3, :cond_23c

    const/4 v9, 0x0

    goto :goto_23e

    .line 1060
    :cond_23c
    iget v9, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->ox:I

    :goto_23e
    if-eqz v3, :cond_242

    const/4 v3, 0x0

    goto :goto_244

    .line 1061
    :cond_242
    iget v3, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->oy:I

    .line 1062
    :goto_244
    new-instance v7, Landroid/graphics/Rect;

    div-int/2addr v9, v4

    div-int/2addr v3, v4

    iget-object v8, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    .line 1064
    invoke-virtual {v8}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v8

    float-to-int v5, v5

    div-int v10, v5, v4

    invoke-static {v2, v10}, Ljava/lang/Math;->max(II)I

    move-result v10

    add-int/2addr v10, v9

    invoke-static {v8, v10}, Ljava/lang/Math;->min(II)I

    move-result v8

    iget-object v10, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    .line 1065
    invoke-virtual {v10}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v10

    float-to-int v6, v6

    div-int v4, v6, v4

    invoke-static {v2, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    add-int/2addr v4, v3

    invoke-static {v10, v4}, Ljava/lang/Math;->min(II)I

    move-result v4

    invoke-direct {v7, v9, v3, v8, v4}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 1066
    new-instance v3, Landroid/graphics/Rect;

    const/4 v4, 0x0

    invoke-direct {v3, v4, v4, v5, v6}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 1067
    invoke-virtual {v7}, Landroid/graphics/Rect;->width()I

    move-result v4

    if-le v4, v2, :cond_293

    invoke-virtual {v7}, Landroid/graphics/Rect;->height()I

    move-result v4

    if-le v4, v2, :cond_293

    .line 1069
    :try_start_281
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBitmapPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3100()Landroid/graphics/Paint;

    move-result-object v2

    const/16 v4, 0xeb

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 1070
    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->back:Landroid/graphics/Bitmap;

    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBitmapPaint:Landroid/graphics/Paint;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3100()Landroid/graphics/Paint;

    move-result-object v2

    invoke-virtual {v1, v0, v7, v3, v2}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Rect;Landroid/graphics/Paint;)V
    :try_end_293
    .catchall {:try_start_281 .. :try_end_293} :catchall_293

    :catchall_293
    :cond_293
    move/from16 v0, v25

    .line 1081
    invoke-virtual {v1, v0}, Landroid/graphics/Canvas;->restoreToCount(I)V

    return-void
.end method

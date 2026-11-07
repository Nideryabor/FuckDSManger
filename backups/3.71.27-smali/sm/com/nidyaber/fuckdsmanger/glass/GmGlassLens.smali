.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;
.super Ljava/lang/Object;
.source "GmGlassLens.java"


# static fields
.field private static final DEPTH_EFFECT:F = 0.6f

.field static final ENGINE_CLOUDY:I = 0x1

.field static final ENGINE_HAZE:I = 0x0

.field static final ENGINE_RIPPLE:I = 0x2

.field private static final REFRACTION_DP:F = 24.0f

.field private static final SOURCE:Ljava/lang/String; = "uniform shader content;\nuniform float2 sampleSize;\nuniform float2 materialOrigin;\nuniform float2 materialSize;\nuniform float4 cornerRadii;\nuniform float refractionHeight;\nuniform float refractionAmount;\nuniform float depthEffect;\nuniform float dispersion;\nuniform float4 tintColor;\nfloat radiusAt(float2 coord, float4 radii) {\n    if (coord.x >= 0.0) {\n        if (coord.y <= 0.0) return radii.y; else return radii.z;\n    } else {\n        if (coord.y <= 0.0) return radii.x; else return radii.w;\n    }\n}\nfloat sdRoundedRect(float2 coord, float2 halfSize, float radius) {\n    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n    float outside = length(max(cornerCoord, 0.0)) - radius;\n    float inside = min(max(cornerCoord.x, cornerCoord.y), 0.0);\n    return outside + inside;\n}\nfloat2 gradSdRoundedRect(float2 coord, float2 halfSize, float radius) {\n    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n    if (cornerCoord.x >= 0.0 || cornerCoord.y >= 0.0) {\n        return sign(coord) * normalize(max(cornerCoord, 0.0) + float2(0.0001));\n    } else {\n        float gradX = step(cornerCoord.y, cornerCoord.x);\n        return sign(coord) * float2(gradX, 1.0 - gradX);\n    }\n}\nfloat circleMap(float x) { return 1.0 - sqrt(max(1.0 - x * x, 0.0)); }\nfloat2 clampSample(float2 c) {\n    return clamp(c, float2(0.5), sampleSize - float2(0.5));\n}\nhalf4 main(float2 coord) {\n    float2 matCoord = coord - materialOrigin;\n    float2 halfSize = materialSize * 0.5;\n    float2 centeredCoord = matCoord - halfSize;\n    float radius = radiusAt(matCoord, cornerRadii);\n    float sd = sdRoundedRect(centeredCoord, halfSize, radius);\n    float gradRadius = min(radius * 1.5, min(halfSize.x, halfSize.y));\n    float2 grad = normalize(\n            gradSdRoundedRect(centeredCoord, halfSize, gradRadius)\n            + depthEffect * normalize(centeredCoord + float2(0.0001)));\n    float d = 0.0;\n    if (sd < 0.0) {\n        float t = clamp(1.0 + sd / max(refractionHeight, 0.001), 0.0, 1.0);\n        d = circleMap(t) * refractionAmount;\n    }\n    float2 base = coord + d * grad;\n    half4 cr = content.eval(clampSample(base + dispersion * grad));\n    half4 cg = content.eval(clampSample(base));\n    half4 cb = content.eval(clampSample(base - dispersion * grad));\n    float3 rgb = float3(float(cr.r), float(cg.g), float(cb.b));\n    float3 outRgb = tintColor.rgb * tintColor.a + rgb * (1.0 - tintColor.a);\n    return half4(half(outRgb.r), half(outRgb.g), half(outRgb.b), half(1.0));\n}\n"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static available()Z
    .registers 2

    .line 215
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :cond_8

    const/4 v0, 0x1

    return v0

    :cond_8
    const/4 v0, 0x0

    return v0
.end method

.method static make(Landroid/graphics/Bitmap;IIFFFFFIIZFIZFF)Landroid/graphics/Shader;
    .registers 34

    move-object/from16 v0, p0

    move/from16 v4, p6

    const/16 v17, 0x0

    if-eqz v0, :cond_a3

    .line 246
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-eqz v1, :cond_10

    goto/16 :goto_a3

    :cond_10
    const/high16 v1, 0x40000000    # 2.0f

    cmpg-float v2, p3, v1

    if-ltz v2, :cond_a3

    cmpg-float v2, p4, v1

    if-gez v2, :cond_1c

    goto/16 :goto_a3

    .line 249
    :cond_1c
    :try_start_1c
    new-instance v2, Landroid/graphics/BitmapShader;

    sget-object v3, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    sget-object v5, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v2, v0, v3, v5}, Landroid/graphics/BitmapShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    const/4 v3, 0x2

    .line 250
    invoke-virtual {v2, v3}, Landroid/graphics/BitmapShader;->setFilterMode(I)V

    .line 252
    new-instance v3, Landroid/graphics/Matrix;

    invoke-direct {v3}, Landroid/graphics/Matrix;-><init>()V

    if-eqz p13, :cond_4a

    mul-float v5, v4, v1

    add-float v6, p3, v5

    add-float v5, p4, v5

    .line 256
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v7

    int-to-float v7, v7

    div-float/2addr v6, v7

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v0

    int-to-float v0, v0

    div-float/2addr v5, v0

    invoke-virtual {v3, v6, v5}, Landroid/graphics/Matrix;->setScale(FF)V

    neg-float v0, v4

    .line 257
    invoke-virtual {v3, v0, v0}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    goto :goto_5b

    :cond_4a
    const/high16 v0, 0x40800000    # 4.0f

    .line 260
    invoke-virtual {v3, v0, v0}, Landroid/graphics/Matrix;->setScale(FF)V

    float-to-int v0, v4

    sub-int v5, p1, v0

    neg-int v5, v5

    int-to-float v5, v5

    sub-int v0, p2, v0

    neg-int v0, v0

    int-to-float v0, v0

    .line 261
    invoke-virtual {v3, v5, v0}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    .line 263
    :goto_5b
    invoke-virtual {v2, v3}, Landroid/graphics/BitmapShader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    .line 265
    new-instance v0, Landroid/graphics/RuntimeShader;

    invoke-static/range {p9 .. p9}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->sourceOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v0, v3}, Landroid/graphics/RuntimeShader;-><init>(Ljava/lang/String;)V

    .line 266
    const-string v3, "content"

    invoke-virtual {v0, v3, v2}, Landroid/graphics/RuntimeShader;->setInputBuffer(Ljava/lang/String;Landroid/graphics/BitmapShader;)V

    mul-float/2addr v1, v4

    add-float v2, p3, v1

    add-float v3, p4, v1

    move/from16 v5, p6

    move/from16 v9, p6

    move/from16 v6, p3

    move/from16 v7, p4

    move/from16 v8, p5

    move/from16 v10, p7

    move/from16 v11, p8

    move/from16 v1, p9

    move/from16 v12, p10

    move/from16 v13, p11

    move/from16 v14, p12

    move/from16 v15, p14

    move/from16 v16, p15

    .line 267
    invoke-static/range {v0 .. v16}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->setUniforms(Landroid/graphics/RuntimeShader;IFFFFFFFFFIZFIFF)V
    :try_end_8e
    .catchall {:try_start_1c .. :try_end_8e} :catchall_8f

    return-object v0

    :catchall_8f
    move-exception v0

    .line 271
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010GmGlass\u3011\u6298\u5c04 shader \u9020\u5931\u8d25\uff08\u9000\u5316\u4e3a\u78e8\u7802\uff09\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "glass.lens.err"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_a3
    :goto_a3
    return-object v17
.end method

.method static setUniforms(Landroid/graphics/RuntimeShader;FFFFFFFFFI)V
    .registers 15

    ushr-int/lit8 v0, p10, 0x18

    and-int/lit16 v0, v0, 0xff

    int-to-float v0, v0

    const/high16 v1, 0x437f0000    # 255.0f

    div-float/2addr v0, v1

    shr-int/lit8 v2, p10, 0x10

    and-int/lit16 v2, v2, 0xff

    int-to-float v2, v2

    div-float/2addr v2, v1

    shr-int/lit8 v3, p10, 0x8

    and-int/lit16 v3, v3, 0xff

    int-to-float v3, v3

    div-float/2addr v3, v1

    and-int/lit16 p10, p10, 0xff

    int-to-float p10, p10

    div-float/2addr p10, v1

    .line 226
    const-string v1, "sampleSize"

    invoke-virtual {p0, v1, p1, p2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 227
    const-string p1, "materialOrigin"

    invoke-virtual {p0, p1, p3, p4}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 228
    const-string p1, "materialSize"

    invoke-virtual {p0, p1, p5, p6}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 229
    const-string p3, "cornerRadii"

    move p5, p7

    move p6, p7

    move p4, p7

    move-object p2, p0

    invoke-virtual/range {p2 .. p7}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    .line 230
    const-string p1, "refractionHeight"

    invoke-virtual {p0, p1, p8}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    const p1, 0x3f0ccccd    # 0.55f

    mul-float/2addr p8, p1

    .line 231
    const-string p1, "refractionAmount"

    invoke-virtual {p0, p1, p8}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 232
    const-string p1, "depthEffect"

    const p2, 0x3f19999a    # 0.6f

    invoke-virtual {p0, p1, p2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 233
    const-string p1, "dispersion"

    invoke-virtual {p0, p1, p9}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 234
    const-string p1, "tintColor"

    move p4, p10

    move p5, v0

    move p2, v2

    move p3, v3

    invoke-virtual/range {p0 .. p5}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    return-void
.end method

.method static setUniforms(Landroid/graphics/RuntimeShader;IFFFFFFFFFI)V
    .registers 29

    move-object/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    move/from16 v3, p3

    move/from16 v4, p4

    move/from16 v5, p5

    move/from16 v6, p6

    move/from16 v7, p7

    move/from16 v8, p9

    move/from16 v9, p10

    move/from16 v10, p11

    ushr-int/lit8 v11, v10, 0x18

    and-int/lit16 v11, v11, 0xff

    int-to-float v11, v11

    const/high16 v12, 0x437f0000    # 255.0f

    div-float/2addr v11, v12

    shr-int/lit8 v13, v10, 0x10

    and-int/lit16 v13, v13, 0xff

    int-to-float v13, v13

    div-float/2addr v13, v12

    shr-int/lit8 v14, v10, 0x8

    and-int/lit16 v14, v14, 0xff

    int-to-float v14, v14

    div-float/2addr v14, v12

    and-int/lit16 v10, v10, 0xff

    int-to-float v10, v10

    div-float/2addr v10, v12

    const/4 v12, 0x1

    .line 103
    const-string v15, "dispersion"

    move/from16 p11, v10

    const/high16 v10, 0x3f800000    # 1.0f

    if-ne v1, v12, :cond_d7

    .line 104
    const-string v1, "resolution"

    invoke-virtual {v0, v1, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    const/high16 v1, 0x3f000000    # 0.5f

    mul-float v2, v6, v1

    add-float/2addr v2, v4

    mul-float v3, v7, v1

    add-float/2addr v3, v5

    .line 105
    const-string v4, "lensCenter"

    invoke-virtual {v0, v4, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 106
    const-string v2, "lensSize"

    invoke-virtual {v0, v2, v6, v7}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 107
    const-string v2, "cornerRadius"

    move/from16 v12, p8

    invoke-virtual {v0, v2, v12}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 108
    const-string v2, "refraction"

    mul-float v3, v8, v1

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 109
    const-string v2, "curve"

    invoke-virtual {v0, v2, v10}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 110
    invoke-virtual {v0, v15, v9}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 111
    const-string v2, "saturation"

    invoke-virtual {v0, v2, v10}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 112
    const-string v2, "contrast"

    invoke-virtual {v0, v2, v10}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 113
    const-string v2, "tint"

    move/from16 p5, p11

    move-object/from16 p1, v0

    move-object/from16 p2, v2

    move/from16 p6, v11

    move/from16 p3, v13

    move/from16 p4, v14

    invoke-virtual/range {p1 .. p6}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    .line 114
    const-string v2, "edge"

    invoke-virtual {v0, v2, v10}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    const/4 v2, 0x0

    const/high16 v3, -0x40800000    # -1.0f

    .line 115
    const-string v4, "lightDir"

    invoke-virtual {v0, v4, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 116
    const-string v2, "specStrength"

    const/high16 v3, 0x3f400000    # 0.75f

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 117
    const-string v2, "specPower"

    const/high16 v3, 0x41c00000    # 24.0f

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 118
    const-string v2, "specRimMix"

    invoke-virtual {v0, v2, v1}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 119
    const-string v2, "specWidthPx"

    const/high16 v3, 0x40c00000    # 6.0f

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 120
    const-string v2, "specLightZ"

    const v3, 0x3f19999a    # 0.6f

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 121
    const-string v2, "specDomeFrac"

    const v4, 0x3eb33333    # 0.35f

    invoke-virtual {v0, v2, v4}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 122
    const-string v2, "specBodyPower"

    const/high16 v4, 0x40000000    # 2.0f

    invoke-virtual {v0, v2, v4}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 123
    const-string v2, "specBodyGain"

    const/high16 v4, 0x3e800000    # 0.25f

    invoke-virtual {v0, v2, v4}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 124
    const-string v2, "specFocalK"

    invoke-virtual {v0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 125
    const-string v2, "specPoolFrac"

    invoke-virtual {v0, v2, v1}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 126
    const-string v1, "specPoolGain"

    const v2, 0x3f99999a    # 1.2f

    invoke-virtual {v0, v1, v2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    return-void

    :cond_d7
    move/from16 v12, p8

    move/from16 v16, p11

    const/4 v10, 0x2

    if-ne v1, v10, :cond_f3

    .line 130
    const-string v1, "size"

    invoke-virtual {v0, v1, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    const/high16 v1, 0x41a00000    # 20.0f

    div-float v1, v9, v1

    const/high16 v2, 0x3f800000    # 1.0f

    .line 131
    invoke-static {v2, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const-string v2, "strength"

    invoke-virtual {v0, v2, v1}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    return-void

    .line 135
    :cond_f3
    const-string v1, "sampleSize"

    invoke-virtual {v0, v1, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 136
    const-string v1, "materialOrigin"

    invoke-virtual {v0, v1, v4, v5}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 137
    const-string v1, "materialSize"

    invoke-virtual {v0, v1, v6, v7}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 138
    const-string v1, "cornerRadii"

    move/from16 v2, p8

    move/from16 v3, p8

    move/from16 v4, p8

    move-object/from16 p1, v0

    move-object/from16 p2, v1

    move/from16 p4, v2

    move/from16 p5, v3

    move/from16 p6, v4

    move/from16 p3, v12

    invoke-virtual/range {p1 .. p6}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    .line 139
    const-string v1, "refractionHeight"

    invoke-virtual {v0, v1, v8}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    const v1, 0x3f0ccccd    # 0.55f

    mul-float/2addr v1, v8

    .line 140
    const-string v2, "refractionAmount"

    invoke-virtual {v0, v2, v1}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 141
    const-string v1, "depthEffect"

    const v3, 0x3f19999a    # 0.6f

    invoke-virtual {v0, v1, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 142
    invoke-virtual {v0, v15, v9}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 143
    const-string v1, "tintColor"

    move-object/from16 p2, v1

    move/from16 p6, v11

    move/from16 p3, v13

    move/from16 p4, v14

    move/from16 p5, v16

    invoke-virtual/range {p1 .. p6}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    return-void
.end method

.method static setUniforms(Landroid/graphics/RuntimeShader;IFFFFFFFFFIZFIFF)V
    .registers 23

    move/from16 v1, p14

    if-eqz p12, :cond_7

    const/high16 v2, 0x3f800000    # 1.0f

    goto :goto_8

    :cond_7
    const/4 v2, 0x0

    .line 76
    :goto_8
    const-string v3, "fdmCleanOn"

    invoke-virtual {p0, v3, v2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 77
    const-string v2, "fdmCleanTol"

    move/from16 v3, p13

    invoke-virtual {p0, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    shr-int/lit8 v2, v1, 0x10

    and-int/lit16 v2, v2, 0xff

    int-to-float v2, v2

    const/high16 v3, 0x437f0000    # 255.0f

    div-float/2addr v2, v3

    shr-int/lit8 v4, v1, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-float v4, v4

    div-float/2addr v4, v3

    and-int/lit16 v1, v1, 0xff

    int-to-float v1, v1

    div-float/2addr v1, v3

    const/high16 v5, 0x3f800000    # 1.0f

    move v3, v4

    move v4, v1

    .line 78
    const-string v1, "fdmCleanColor"

    move-object v0, p0

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FFFF)V

    .line 87
    :try_start_30
    const-string v1, "fdmFade"

    move/from16 v2, p15

    invoke-virtual {p0, v1, v2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V

    .line 88
    const-string v1, "fdmFadePx"

    move/from16 v2, p16

    invoke-virtual {p0, v1, v2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V
    :try_end_3e
    .catchall {:try_start_30 .. :try_end_3e} :catchall_3e

    .line 91
    :catchall_3e
    invoke-static/range {p0 .. p11}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassLens;->setUniforms(Landroid/graphics/RuntimeShader;IFFFFFFFFFI)V

    return-void
.end method

.method static sourceOf(I)Ljava/lang/String;
    .registers 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_c

    const/4 v0, 0x2

    if-eq p0, v0, :cond_9

    .line 55
    const-string p0, "uniform shader content;\n// \u2500\u2500 fdm \u516c\u5171\u524d\u594f\uff08\u7531 tools/gen_glass_shaders.py \u6ce8\u5165\uff09\u2500\u2500\nuniform float fdmCleanOn;\nuniform float fdmCleanTol;\nuniform float4 fdmCleanColor;\n\nhalf4 fdmSample(float2 p) {\n    half4 c = content.eval(p);\n    if (fdmCleanOn < 0.5) { return c; }\n    float d = distance(float3(c.rgb), float3(fdmCleanColor.rgb));\n    // \u79bb\u80cc\u666f\u8272\u592a\u8fdc \u21d2 \u8ba4\u4e3a\u662f\u6587\u5b57/\u56fe\u6807 \u21d2 \u6362\u6210\u80cc\u666f\u8272\n    return (d > fdmCleanTol) ? half4(half3(fdmCleanColor.rgb), c.a) : c;\n}\n\n// \u2500\u2500 \u300c\u8fb9\u7f18\u8fc7\u6e21\u300d\u516c\u5171\u4ef6\uff082026-10-02 \u4e3b\u4eba\uff1a\u300c\u989c\u8272\u6ca1\u6709\u8fc7\u6e21\u4e5f\u5f88\u751f\u786c\u300d\uff09\u2500\u2500\n//   sd = \u6709\u7b26\u53f7\u8ddd\u79bb\uff08\u8d1f\u503c = \u5185\u90e8\u30010 = \u8fb9\u7f18\uff09\u21d2 \u989c\u8272\u4ece\u8fb9\u7f18\u5f80\u91cc\u67d4\u548c\u8870\u51cf\u3002\n//   fdmFade   = \u5f3a\u5ea6 0..1\uff08\u6ed1\u6746\uff09\n//   fdmFadePx = \u8fc7\u6e21\u8ddd\u79bb\uff08px\uff09\uff1b\u300c\u4ec5\u8fb9\u7f18\u300d= \u8fb9\u7f18\u5e26\u5bbd\uff1b\u300c\u6b63\u5e38\u300d= \u6309\u5143\u7d20\u5c3a\u5bf8\u53d6\u3002\nuniform float fdmFade;\nuniform float fdmFadePx;\n\nfloat fdmFadeFac(float sd) {\n    float inner = clamp(-sd / max(fdmFadePx, 1.0), 0.0, 1.0);\n    return 1.0 - fdmFade * inner;\n}\n// \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\nuniform float2 sampleSize;\nuniform float2 materialOrigin;\nuniform float2 materialSize;\nuniform float4 cornerRadii;\nuniform float refractionHeight;\nuniform float refractionAmount;\nuniform float depthEffect;\nuniform float dispersion;\nuniform float4 tintColor;\nfloat radiusAt(float2 coord, float4 radii) {\n    if (coord.x >= 0.0) {\n        if (coord.y <= 0.0) return radii.y; else return radii.z;\n    } else {\n        if (coord.y <= 0.0) return radii.x; else return radii.w;\n    }\n}\nfloat sdRoundedRect(float2 coord, float2 halfSize, float radius) {\n    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n    float outside = length(max(cornerCoord, 0.0)) - radius;\n    float inside = min(max(cornerCoord.x, cornerCoord.y), 0.0);\n    return outside + inside;\n}\nfloat2 gradSdRoundedRect(float2 coord, float2 halfSize, float radius) {\n    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n    if (cornerCoord.x >= 0.0 || cornerCoord.y >= 0.0) {\n        return sign(coord) * normalize(max(cornerCoord, 0.0) + float2(0.0001));\n    } else {\n        float gradX = step(cornerCoord.y, cornerCoord.x);\n        return sign(coord) * float2(gradX, 1.0 - gradX);\n    }\n}\nfloat circleMap(float x) { return 1.0 - sqrt(max(1.0 - x * x, 0.0)); }\nfloat2 clampSample(float2 c) {\n    return clamp(c, float2(0.5), sampleSize - float2(0.5));\n}\nhalf4 main(float2 coord) {\n    float2 matCoord = coord - materialOrigin;\n    float2 halfSize = materialSize * 0.5;\n    float2 centeredCoord = matCoord - halfSize;\n    float radius = radiusAt(matCoord, cornerRadii);\n    float sd = sdRoundedRect(centeredCoord, halfSize, radius);\n    float gradRadius = min(radius * 1.5, min(halfSize.x, halfSize.y));\n    float2 grad = normalize(\n            gradSdRoundedRect(centeredCoord, halfSize, gradRadius)\n            + depthEffect * normalize(centeredCoord + float2(0.0001)));\n    float d = 0.0;\n    if (sd < 0.0) {\n        float t = clamp(1.0 + sd / max(refractionHeight, 0.001), 0.0, 1.0);\n        d = circleMap(t) * refractionAmount;\n    }\n    float2 base = coord + d * grad;\n    half4 cr = fdmSample(clampSample(base + dispersion * grad));\n    half4 cg = fdmSample(clampSample(base));\n    half4 cb = fdmSample(clampSample(base - dispersion * grad));\n    float3 rgb = float3(float(cr.r), float(cg.g), float(cb.b));\n    float aFac = fdmFadeFac(sd);\n    float aEff = tintColor.a * aFac;\n    float3 outRgb = tintColor.rgb * aEff + rgb * (1.0 - aEff);\n    // \u2605 \u8f93\u51fa alpha \u4e5f\u5e26\u4e0a\u201c\u5411\u5185\u51cf\u8272\u201d\uff082026-10-02 \u591c\uff0c\u4e3b\u4eba\uff1a\u201c\u6240\u6709\u5143\u7d20\u90fd\u662f\u80cc\u666f\u534a\u900f\u660e\u7684\u5899\u201d\uff09\u2014\u2014\n    //   \u53ea\u51cf tint \u7684\u8bdd\uff0c\u4e2d\u5fc3\u4f1a\u9732\u51fa\u201c\u539f\u5185\u5bb9 = \u4e00\u5835\u5b9e\u8272\u5899\u201d\uff1balpha \u4e00\u8d77\u51cf\uff0c\u624d\u662f\u771f\u7684\u201c\u5411\u91cc\u5316\u6389\u201d\u3002\n    //   \u9884\u4e58\u8f93\u51fa\uff1argb \u540c\u4e58 aFac\uff08\u8fb9\u7f18 aFac\u22481 \u5904\u89c2\u611f\u4e0e\u65e7\u7248\u4e00\u81f4\uff09\u3002\n    return half4(half(outRgb.r * aFac), half(outRgb.g * aFac), half(outRgb.b * aFac), half(aFac));\n}"

    return-object p0

    .line 54
    :cond_9
    const-string p0, "\nuniform shader content;\n// \u2500\u2500 fdm \u516c\u5171\u524d\u594f\uff08\u7531 tools/gen_glass_shaders.py \u6ce8\u5165\uff09\u2500\u2500\nuniform float fdmCleanOn;\nuniform float fdmCleanTol;\nuniform float4 fdmCleanColor;\n\nhalf4 fdmSample(float2 p) {\n    half4 c = content.eval(p);\n    if (fdmCleanOn < 0.5) { return c; }\n    float d = distance(float3(c.rgb), float3(fdmCleanColor.rgb));\n    // \u79bb\u80cc\u666f\u8272\u592a\u8fdc \u21d2 \u8ba4\u4e3a\u662f\u6587\u5b57/\u56fe\u6807 \u21d2 \u6362\u6210\u80cc\u666f\u8272\n    return (d > fdmCleanTol) ? half4(half3(fdmCleanColor.rgb), c.a) : c;\n}\n\n// \u2500\u2500 \u300c\u8fb9\u7f18\u8fc7\u6e21\u300d\u516c\u5171\u4ef6\uff082026-10-02 \u4e3b\u4eba\uff1a\u300c\u989c\u8272\u6ca1\u6709\u8fc7\u6e21\u4e5f\u5f88\u751f\u786c\u300d\uff09\u2500\u2500\n//   sd = \u6709\u7b26\u53f7\u8ddd\u79bb\uff08\u8d1f\u503c = \u5185\u90e8\u30010 = \u8fb9\u7f18\uff09\u21d2 \u989c\u8272\u4ece\u8fb9\u7f18\u5f80\u91cc\u67d4\u548c\u8870\u51cf\u3002\n//   fdmFade   = \u5f3a\u5ea6 0..1\uff08\u6ed1\u6746\uff09\n//   fdmFadePx = \u8fc7\u6e21\u8ddd\u79bb\uff08px\uff09\uff1b\u300c\u4ec5\u8fb9\u7f18\u300d= \u8fb9\u7f18\u5e26\u5bbd\uff1b\u300c\u6b63\u5e38\u300d= \u6309\u5143\u7d20\u5c3a\u5bf8\u53d6\u3002\nuniform float fdmFade;\nuniform float fdmFadePx;\n\nfloat fdmFadeFac(float sd) {\n    float inner = clamp(-sd / max(fdmFadePx, 1.0), 0.0, 1.0);\n    return 1.0 - fdmFade * inner;\n}\n// \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\nuniform float2 size;\nuniform float strength;\n\nhalf4 main(float2 fragCoord) {\n    float2 uv = fragCoord / size;\n    float dx = sin(uv.y * 18.0) * strength * 6.0;\n    float dy = cos(uv.x * 14.0) * strength * 4.0;\n    return fdmSample(fragCoord + float2(dx, dy));\n}"

    return-object p0

    .line 53
    :cond_c
    const-string p0, "\nuniform float2 resolution;\nuniform float2 lensCenter;\nuniform float2 lensSize;\nuniform float cornerRadius;\nuniform float refraction;\nuniform float curve;\nuniform float dispersion;\nuniform float saturation;\nuniform float contrast;\nuniform float4 tint;\nuniform float edge;\nuniform float2 lightDir;\nuniform float specStrength;\nuniform float specPower;\nuniform float specRimMix;     // body<->rim crossfade\nuniform float specWidthPx;\nuniform float specLightZ;\nuniform float specDomeFrac;\nuniform float specBodyPower;\nuniform float specBodyGain;\nuniform float specFocalK;      // focal-pool offset toward light (fraction of minHalf)\nuniform float specPoolFrac;    // focal-pool radius (fraction of minHalf)\nuniform float specPoolGain;    // focal-pool peak scale\nuniform shader content;\n// \u2500\u2500 fdm \u516c\u5171\u524d\u594f\uff08\u7531 tools/gen_glass_shaders.py \u6ce8\u5165\uff09\u2500\u2500\nuniform float fdmCleanOn;\nuniform float fdmCleanTol;\nuniform float4 fdmCleanColor;\n\nhalf4 fdmSample(float2 p) {\n    half4 c = content.eval(p);\n    if (fdmCleanOn < 0.5) { return c; }\n    float d = distance(float3(c.rgb), float3(fdmCleanColor.rgb));\n    // \u79bb\u80cc\u666f\u8272\u592a\u8fdc \u21d2 \u8ba4\u4e3a\u662f\u6587\u5b57/\u56fe\u6807 \u21d2 \u6362\u6210\u80cc\u666f\u8272\n    return (d > fdmCleanTol) ? half4(half3(fdmCleanColor.rgb), c.a) : c;\n}\n\n// \u2500\u2500 \u300c\u8fb9\u7f18\u8fc7\u6e21\u300d\u516c\u5171\u4ef6\uff082026-10-02 \u4e3b\u4eba\uff1a\u300c\u989c\u8272\u6ca1\u6709\u8fc7\u6e21\u4e5f\u5f88\u751f\u786c\u300d\uff09\u2500\u2500\n//   sd = \u6709\u7b26\u53f7\u8ddd\u79bb\uff08\u8d1f\u503c = \u5185\u90e8\u30010 = \u8fb9\u7f18\uff09\u21d2 \u989c\u8272\u4ece\u8fb9\u7f18\u5f80\u91cc\u67d4\u548c\u8870\u51cf\u3002\n//   fdmFade   = \u5f3a\u5ea6 0..1\uff08\u6ed1\u6746\uff09\n//   fdmFadePx = \u8fc7\u6e21\u8ddd\u79bb\uff08px\uff09\uff1b\u300c\u4ec5\u8fb9\u7f18\u300d= \u8fb9\u7f18\u5e26\u5bbd\uff1b\u300c\u6b63\u5e38\u300d= \u6309\u5143\u7d20\u5c3a\u5bf8\u53d6\u3002\nuniform float fdmFade;\nuniform float fdmFadePx;\n\nfloat fdmFadeFac(float sd) {\n    float inner = clamp(-sd / max(fdmFadePx, 1.0), 0.0, 1.0);\n    return 1.0 - fdmFade * inner;\n}\n// \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\n\nconst float SMOOTH_EDGE_PX = 1.5;\nconst float SEAM_BLEND_PX = 8.0;   // diagonal blend half-width (px); larger = softer interior crease\n\n// Signed distance to a box with rounded corners\n// Negative = inside, Positive = outside, Zero = on boundary\nfloat boxRoundedSDF(float2 p, float2 halfDim, float r) {\n    float2 d = abs(p) - halfDim + float2(r);\n    float exterior = length(max(d, 0.0));\n    float interior = min(max(d.x, d.y), 0.0);\n    return exterior + interior - r;\n}\n\n// Outward-facing direction vector from the lens surface\nfloat2 lensNormalDirection(float2 p, float2 halfDim, float r) {\n    float2 d = abs(p) - halfDim + float2(r);\n    float2 s = float2(p.x >= 0.0 ? 1.0 : -1.0, p.y >= 0.0 ? 1.0 : -1.0);\n\n    if (max(d.x, d.y) > 0.0) {\n        return s * normalize(max(d, 0.0));\n    }\n    return d.x > d.y ? float2(s.x, 0.0) : float2(0.0, s.y);\n}\n\n// Perceptual brightness (ITU-R BT.709 standard)\nfloat toBrightness(half3 c) {\n    return dot(c, half3(0.2126, 0.7152, 0.0722));\n}\n\n// Color processing: vibrancy, intensity adjustment, and color overlay\nhalf3 processColor(half3 src, float vibrancy, float intensity, float4 overlay) {\n    float mono = toBrightness(src);\n    half3 vibrant = half3(clamp(mix(half3(mono), src, vibrancy), 0.0, 1.0));\n    half3 adjusted = half3(clamp((vibrant - 0.5) * intensity + 0.5, 0.0, 1.0));\n    return mix(adjusted, half3(overlay.rgb), overlay.a);\n}\n\nhalf4 main(float2 xy) {\n    float2 halfDim = lensSize * 0.5;\n    float r = min(cornerRadius, min(halfDim.x, halfDim.y));\n\n    float2 p = xy - lensCenter;\n    float sdf = boxRoundedSDF(p, halfDim, r);\n\n    // Skip pixels outside the lens boundary\n    if (sdf > SMOOTH_EDGE_PX) {\n        return fdmSample(xy);\n    }\n\n    float2 normal = lensNormalDirection(p, halfDim, r);\n\n    // Compute refracted sample position\n    float2 sampleXY = xy;\n    if (refraction > 0.0 && curve > 0.0) {\n        float minDim = min(halfDim.x, halfDim.y);\n        float depth = clamp(-sdf / (minDim * refraction), 0.0, 1.0);\n        float curvature = 1.0 - depth;\n        float bend = 1.0 - sqrt(1.0 - curvature * curvature);\n        sampleXY = xy - bend * curve * minDim * normal;\n    }\n\n    // RGB channel separation for prismatic effect\n    half4 pixel;\n    if (dispersion > 0.0) {\n        float2 normP = p / halfDim;\n        float2 shift = dispersion * normP * normP * normP * min(halfDim.x, halfDim.y) * 0.1;\n\n        float2 xyR = sampleXY - shift;\n        float2 xyG = sampleXY;\n        float2 xyB = sampleXY + shift;\n\n        float sdfR = boxRoundedSDF(xyR - lensCenter, halfDim, r);\n        float sdfB = boxRoundedSDF(xyB - lensCenter, halfDim, r);\n\n        half4 gVal = fdmSample(xyG);\n        half4 rVal = (sdfR <= 0.0) ? fdmSample(xyR) : gVal;\n        half4 bVal = (sdfB <= 0.0) ? fdmSample(xyB) : gVal;\n\n        pixel = half4(rVal.r, gVal.g, bVal.b, gVal.a);\n    } else {\n        pixel = fdmSample(sampleXY);\n    }\n\n    // Handle fully transparent samples\n    if (pixel.a <= 0.0) {\n        pixel = fdmSample(xy);\n    }\n\n    pixel.rgb = processColor(pixel.rgb, saturation, contrast, float4(tint.rgb, tint.a * fdmFadeFac(sdf)));\n\n    // Specular highlight: 4 terms \u2014 focal pool (dual-axis moving hotspot) + body sheen + Blinn rim\n    // glint + back-rim fill. The gate also tests specStrength, so NoGlow is bit-exact off.\n    if (edge > 0.0 && specStrength > 0.0) {\n        float2 lightVec = normalize(lightDir);\n\n        // Seam-free in-plane direction (specular only; refraction\'s \'normal\' is untouched). The\n        // rounded-rect interior is an L-inf field, so the true gradient is discontinuous along the\n        // diagonal; blend it over SEAM_BLEND_PX.\n        float2 d2 = abs(p) - halfDim + float2(r);\n        float2 s2 = float2(p.x >= 0.0 ? 1.0 : -1.0, p.y >= 0.0 ? 1.0 : -1.0);\n        float2 specDir2;\n        if (max(d2.x, d2.y) > 0.0) {\n            specDir2 = s2 * normalize(max(d2, 0.0));\n        } else {\n            // +1e-4 guards the dead-center normalize singularity.\n            float w  = clamp(0.5 + 0.5 * (d2.x - d2.y) / SEAM_BLEND_PX, 0.0, 1.0);\n            float2 v = float2(s2.x * w, s2.y * (1.0 - w)) + float2(0.0, 1.0e-4);\n            specDir2 = normalize(v);\n        }\n\n        // Fake-3D surface normal from the rounded-rect bevel.\n        float minHalf = min(halfDim.x, halfDim.y);\n        float bevelPx = max(minHalf * specDomeFrac, 1.0);\n        float depthIn = max(-sdf, 0.0);\n        float t       = clamp(depthIn / bevelPx, 0.0, 1.0);\n        float n_cos   = 1.0 - t;\n        float n_sin   = sqrt(max(1.0 - n_cos * n_cos, 0.0));      // float, not half: cancellation near n_cos~1\n        float3 N      = normalize(float3(specDir2 * n_cos, n_sin + 1.0e-3));\n\n        float3 L = normalize(float3(lightVec, specLightZ));\n        float3 V = float3(0.0, 0.0, 1.0);\n\n        // Moving focal hotspot: offset toward lightVec so the bright pool tracks tilt on both axes\n        // (pitch=vertical, roll=horizontal). inside masks it off past the rim.\n        float2 focal     = lightVec * (minHalf * specFocalK);\n        float  poolR     = max(minHalf * specPoolFrac, 1.0);      // guard against zero-width smoothstep\n        float  poolD     = length(p - focal);\n        float  pool      = 1.0 - smoothstep(0.0, poolR, poolD);   // 1 at focal, 0 at rim\n        float  inside    = 1.0 - smoothstep(-6.0, 0.0, sdf);\n        float  focalPool = pool * pool * specStrength * specPoolGain * inside; // pool^2 = tighter core\n\n        // Broad body sheen (gentle modeling fill). float, not half: pow bands in fp16 (applies below too).\n        float ndl       = max(dot(N, L), 0.0);\n        float bodySheen = pow(ndl, specBodyPower) * specStrength * specBodyGain;\n\n        // Tight Blinn rim glint, confined to the rim band. max(specWidthPx, 1.0) guards the\n        // zero-width (implementation-defined hard-step) smoothstep.\n        float3 H       = normalize(L + V);\n        float  rimBand = smoothstep(-max(specWidthPx, 1.0), 0.0, sdf);\n        float  glint   = pow(max(dot(N, H), 0.0), specPower) * specStrength;\n        float  rim     = glint * rimBand;\n\n        // Back-rim fill (opposite light, rim-locked, 1/4 weight).\n        float3 Lb   = normalize(float3(-lightVec, specLightZ));\n        float  back  = pow(max(dot(N, Lb), 0.0), specPower) * specStrength * rimBand * 0.25;\n\n        // Ordered dither to break 8-bit Mach banding on the body ramp. fract-bound the coord before\n        // sin so the sin argument can\'t blow up on large lenses.\n        float2 hp = fract((p / minHalf) * 0.5 + 0.5);             // bounded ~[0,1)\n        float  dn = fract(sin(dot(hp, float2(12.9898, 78.233))) * 43758.5453) - 0.5;\n\n        // Linear body<->rim crossfade: rimMix=0 pure focal pool, rimMix=1 pure rim glint (legacy look).\n        float body      = focalPool + bodySheen + dn * (1.0 / 255.0) * specStrength;\n        float rimMix    = clamp(specRimMix, 0.0, 1.0);\n        float highlight = body * (1.0 - rimMix) + (rim + back) * rimMix;\n\n        // Screen blend, clamped to [0,1] so it survives bright backgrounds and never exceeds 1.0.\n        pixel.rgb += half3((1.0 - pixel.rgb) * clamp(highlight, 0.0, 1.0));\n    }\n\n    // Anti-aliased edge transition\n    float alpha = 1.0 - smoothstep(-SMOOTH_EDGE_PX * 0.5, SMOOTH_EDGE_PX * 0.5, sdf);\n    half4 bg = fdmSample(xy);\n    half4 outPix = mix(bg, pixel, alpha);\n    // \u2605 \u8f93\u51fa alpha \u5e26\u4e0a\u201c\u5411\u5185\u51cf\u8272\u201d\uff08\u7406\u7531\u540c haze \u2014\u2014 \u53ea\u51cf tint \u4f1a\u7559\u4e00\u5835\u5899\uff09\n    float aF = fdmFadeFac(sdf);\n    return half4(half(outPix.r * aF), half(outPix.g * aF), half(outPix.b * aF), half(aF));\n}"

    return-object p0
.end method

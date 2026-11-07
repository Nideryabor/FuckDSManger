.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmFitApplyHook.java"


# static fields
.field private static sAnchorAt:J = 0x0L

.field private static sAnchorVal:I = 0x1


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 38
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static anchor()I
    .registers 7

    .line 176
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 177
    sget-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x3e8

    cmp-long v2, v2, v4

    if-gez v2, :cond_11

    .line 178
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorVal:I

    return v0

    .line 180
    :cond_11
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorAt:J

    .line 182
    :try_start_13
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_1c

    .line 184
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorVal:I

    return v0

    .line 186
    :cond_1c
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmStore"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 187
    const-string v2, "get"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v1, v2, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 188
    instance-of v1, v0, Landroid/content/SharedPreferences;

    if-eqz v1, :cond_4f

    .line 189
    check-cast v0, Landroid/content/SharedPreferences;

    const-string v1, "fuckds_bubble_anchor"

    .line 190
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    if-ltz v0, :cond_4d

    const/16 v1, 0x8

    if-le v0, v1, :cond_4c

    goto :goto_4d

    :cond_4c
    move v3, v0

    .line 194
    :cond_4d
    :goto_4d
    sput v3, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorVal:I
    :try_end_4f
    .catchall {:try_start_13 .. :try_end_4f} :catchall_4f

    .line 198
    :catchall_4f
    :cond_4f
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->sAnchorVal:I

    return v0
.end method

.method private static app()Landroid/content/Context;
    .registers 5

    const/4 v0, 0x0

    const/4 v1, 0x0

    .line 204
    :try_start_2
    const-string v2, "android.app.ActivityThread"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    .line 205
    const-string v3, "currentApplication"

    new-array v4, v0, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    invoke-virtual {v2, v1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 206
    instance-of v3, v2, Landroid/content/Context;

    if-eqz v3, :cond_1b

    .line 207
    check-cast v2, Landroid/content/Context;
    :try_end_1a
    .catchall {:try_start_2 .. :try_end_1a} :catchall_1b

    return-object v2

    .line 212
    :catchall_1b
    :cond_1b
    :try_start_1b
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmUtil"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    .line 213
    const-string v3, "app"

    new-array v0, v0, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {v0, v1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 214
    instance-of v2, v0, Landroid/content/Context;

    if-eqz v2, :cond_34

    .line 215
    check-cast v0, Landroid/content/Context;
    :try_end_33
    .catchall {:try_start_1b .. :try_end_33} :catchall_34

    return-object v0

    :catchall_34
    :cond_34
    return-object v1
.end method

.method private static field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .registers 4

    const/4 v0, 0x0

    .line 122
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-static {v1, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p1

    if-nez p1, :cond_c

    return-object v0

    :cond_c
    const/4 v1, 0x1

    .line 126
    invoke-virtual {p1, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 127
    invoke-virtual {p1, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_14
    .catchall {:try_start_1 .. :try_end_14} :catchall_15

    return-object p0

    :catchall_15
    return-object v0
.end method

.method private static findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/reflect/Field;"
        }
    .end annotation

    :goto_0
    if-eqz p0, :cond_23

    .line 110
    const-class v0, Ljava/lang/Object;

    if-eq p0, v0, :cond_23

    .line 111
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_c
    if-ge v2, v1, :cond_1e

    aget-object v3, v0, v2

    .line 112
    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1b

    return-object v3

    :cond_1b
    add-int/lit8 v2, v2, 0x1

    goto :goto_c

    .line 110
    :cond_1e
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object p0

    goto :goto_0

    :cond_23
    const/4 p0, 0x0

    return-object p0
.end method

.method private static mapGet(Ljava/util/Map;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "**>;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p0, :cond_b

    if-nez p1, :cond_6

    goto :goto_b

    .line 147
    :cond_6
    :try_start_6
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_a
    .catchall {:try_start_6 .. :try_end_a} :catchall_b

    return-object p0

    :catchall_b
    :cond_b
    :goto_b
    return-object v0
.end method

.method private static staticMap(Ljava/lang/String;)Ljava/util/Map;
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "**>;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 135
    :try_start_1
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 136
    invoke-virtual {v1, p0}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    const/4 v1, 0x1

    .line 137
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 138
    invoke-virtual {p0, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 139
    instance-of v1, p0, Ljava/util/Map;

    if-eqz v1, :cond_1a

    check-cast p0, Ljava/util/Map;
    :try_end_19
    .catchall {:try_start_1 .. :try_end_19} :catchall_1a

    return-object p0

    :catchall_1a
    :cond_1a
    return-object v0
.end method

.method private static zf(F)F
    .registers 2

    const v0, 0x3d4ccccd    # 0.05f

    cmpg-float v0, p0, v0

    if-gtz v0, :cond_9

    const/high16 p0, 0x3f800000    # 1.0f

    :cond_9
    return p0
.end method

.method private static zoomF()F
    .registers 4

    const/high16 v0, 0x3f800000    # 1.0f

    .line 155
    :try_start_2
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 156
    const-string v2, "zoomF"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Class;

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 157
    invoke-virtual {v1, v3, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 158
    instance-of v2, v1, Ljava/lang/Float;

    if-eqz v2, :cond_20

    check-cast v1, Ljava/lang/Float;

    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v0
    :try_end_20
    .catchall {:try_start_2 .. :try_end_20} :catchall_20

    :catchall_20
    :cond_20
    return v0
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 11

    .line 43
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz p0, :cond_cf

    .line 44
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_cf

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, v0

    const/4 v1, 0x1

    if-ge v0, v1, :cond_10

    goto/16 :goto_cf

    .line 47
    :cond_10
    const-string v0, "d"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 48
    instance-of v1, v0, Landroid/graphics/Shader;

    if-nez v1, :cond_1c

    goto/16 :goto_cf

    :cond_1c
    const/4 v1, 0x0

    .line 55
    :goto_1d
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v2, v2

    if-ge v1, v2, :cond_35

    const/4 v2, 0x3

    if-ge v1, v2, :cond_35

    .line 56
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object v2, v2, v1

    instance-of v2, v2, Ljava/lang/Long;

    if-eqz v2, :cond_32

    .line 57
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object p1, p1, v1

    goto :goto_36

    :cond_32
    add-int/lit8 v1, v1, 0x1

    goto :goto_1d

    :cond_35
    const/4 p1, 0x0

    :goto_36
    if-nez p1, :cond_3a

    goto/16 :goto_cf

    .line 64
    :cond_3a
    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    const/16 p1, 0x20

    ushr-long v3, v1, p1

    long-to-int p1, v3

    .line 67
    invoke-static {p1}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result p1

    long-to-int v1, v1

    .line 68
    invoke-static {v1}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result v1

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v3, p1, v2

    if-lez v3, :cond_cf

    cmpl-float v3, v1, v2

    if-gtz v3, :cond_59

    goto :goto_cf

    .line 74
    :cond_59
    const-string v3, "sBmpShaderMap"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->staticMap(Ljava/lang/String;)Ljava/util/Map;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->mapGet(Ljava/util/Map;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/graphics/Bitmap;

    if-nez v3, :cond_74

    .line 76
    const-string v3, "sBmpMap"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->staticMap(Ljava/lang/String;)Ljava/util/Map;

    move-result-object v3

    invoke-static {v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->mapGet(Ljava/util/Map;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    move-object v3, p0

    check-cast v3, Landroid/graphics/Bitmap;

    :cond_74
    if-nez v3, :cond_7a

    .line 79
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitProbe;->notOurs(Ljava/lang/Object;)V

    return-void

    .line 84
    :cond_7a
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result p0

    int-to-float p0, p0

    div-float p0, p1, p0

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->zoomF()F

    move-result v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->zf(F)F

    move-result v4

    mul-float/2addr p0, v4

    .line 88
    instance-of v4, v0, Landroid/graphics/RuntimeShader;

    if-nez v4, :cond_92

    .line 89
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitProbe;->appliedNoInput(F)V

    return-void

    :cond_92
    const v4, 0x38d1b717    # 1.0E-4f

    cmpl-float v4, p0, v4

    if-lez v4, :cond_9a

    div-float/2addr v2, p0

    .line 94
    :cond_9a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitApplyHook;->anchor()I

    move-result v4

    .line 95
    rem-int/lit8 v5, v4, 0x3

    .line 96
    div-int/lit8 v6, v4, 0x3

    .line 97
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v7

    int-to-float v7, v7

    mul-float/2addr v7, p0

    sub-float/2addr v7, p1

    neg-float v7, v7

    int-to-float v5, v5

    const/high16 v8, 0x3f000000    # 0.5f

    mul-float/2addr v5, v8

    mul-float/2addr v7, v5

    .line 98
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v5, p0

    sub-float/2addr v5, v1

    neg-float v5, v5

    int-to-float v6, v6

    mul-float/2addr v6, v8

    mul-float/2addr v5, v6

    .line 99
    check-cast v0, Landroid/graphics/RuntimeShader;

    .line 100
    const-string v6, "fdmMul"

    invoke-virtual {v0, v6, v2, v2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    .line 101
    const-string v6, "fdmAdd"

    neg-float v7, v7

    mul-float/2addr v7, v2

    neg-float v5, v5

    mul-float/2addr v5, v2

    invoke-virtual {v0, v6, v7, v5}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V

    float-to-int p1, p1

    float-to-int v0, v1

    .line 102
    invoke-static {p0, p1, v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmFitProbe;->appliedCtx(FIILandroid/graphics/Bitmap;I)V
    :try_end_cf
    .catchall {:try_start_0 .. :try_end_cf} :catchall_cf

    :catchall_cf
    :cond_cf
    :goto_cf
    return-void
.end method

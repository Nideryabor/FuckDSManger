.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;
.super Ljava/lang/Object;
.source "GmGlassAtoms.java"


# static fields
.field private static volatile sLogged:Z = false

.field private static volatile sLogged2:Z = false

.field private static volatile sMatLogged:Z = false

.field private static volatile sRootX:I

.field private static volatile sRootY:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static floats(Ljava/lang/Object;)[F
    .registers 8

    const/4 v0, 0x0

    .line 193
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_b
    if-ge v3, v2, :cond_27

    aget-object v4, v1, v3

    .line 194
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v5

    if-nez v5, :cond_24

    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    const-class v6, [F

    if-ne v5, v6, :cond_24

    .line 195
    invoke-virtual {v4, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [F
    :try_end_23
    .catchall {:try_start_1 .. :try_end_23} :catchall_27

    return-object p0

    :cond_24
    add-int/lit8 v3, v3, 0x1

    goto :goto_b

    :catchall_27
    :cond_27
    return-object v0
.end method

.method public static matrixFromFields(Ljava/lang/Object;)[I
    .registers 13

    .line 92
    :try_start_0
    new-instance v0, Ljava/util/ArrayDeque;

    invoke-direct {v0}, Ljava/util/ArrayDeque;-><init>()V

    .line 93
    new-instance v1, Ljava/util/IdentityHashMap;

    invoke-direct {v1}, Ljava/util/IdentityHashMap;-><init>()V

    .line 95
    invoke-virtual {v0, p0}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z

    const/4 v2, 0x0

    .line 96
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, p0, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move p0, v2

    .line 98
    :cond_16
    :goto_16
    invoke-virtual {v0}, Ljava/util/ArrayDeque;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_c5

    const/16 v3, 0x12c

    if-ge p0, v3, :cond_c5

    .line 99
    invoke-virtual {v0}, Ljava/util/ArrayDeque;->poll()Ljava/lang/Object;

    move-result-object v3

    .line 100
    invoke-virtual {v1, v3}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    add-int/lit8 p0, p0, 0x1

    .line 102
    instance-of v5, v3, [F

    const/4 v6, 0x1

    if-eqz v5, :cond_81

    move-object v5, v3

    check-cast v5, [F

    array-length v5, v5

    const/16 v7, 0x10

    if-lt v5, v7, :cond_81

    .line 103
    check-cast v3, [F

    const/16 p0, 0xc

    .line 104
    aget p0, v3, p0

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    const/16 v0, 0xd

    aget v0, v3, v0

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 105
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sMatLogged:Z

    if-nez v1, :cond_76

    .line 106
    sput-boolean v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sMatLogged:Z

    .line 107
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010GmGlass\u3011\u5b57\u6bb5\u627e\u5230\u53d8\u6362\u77e9\u9635\uff1a\u5e73\u79fb("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ","

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 109
    :cond_76
    sget v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootX:I

    add-int/2addr p0, v1

    sget v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootY:I

    add-int/2addr v0, v1

    filled-new-array {p0, v0}, [I

    move-result-object p0

    return-object p0

    :cond_81
    const/4 v5, 0x4

    if-lt v4, v5, :cond_85

    goto :goto_16

    .line 112
    :cond_85
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v5

    array-length v7, v5

    move v8, v2

    :goto_8f
    if-ge v8, v7, :cond_16

    aget-object v9, v5, v8

    .line 113
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v10

    .line 114
    invoke-virtual {v10}, Ljava/lang/Class;->isPrimitive()Z

    move-result v11

    if-nez v11, :cond_c2

    const-class v11, Ljava/lang/String;

    if-eq v10, v11, :cond_c2

    const-class v11, Ljava/lang/Class;
    :try_end_a3
    .catchall {:try_start_0 .. :try_end_a3} :catchall_c5

    if-ne v10, v11, :cond_a6

    goto :goto_c2

    .line 116
    :cond_a6
    :try_start_a6
    invoke-virtual {v9, v6}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 117
    invoke-virtual {v9, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    if-eqz v9, :cond_c2

    .line 118
    invoke-virtual {v1, v9}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_b6

    goto :goto_c2

    :cond_b6
    add-int/lit8 v10, v4, 0x1

    .line 119
    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    invoke-virtual {v1, v9, v10}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 120
    invoke-virtual {v0, v9}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z
    :try_end_c2
    .catchall {:try_start_a6 .. :try_end_c2} :catchall_c2

    :catchall_c2
    :cond_c2
    :goto_c2
    add-int/lit8 v8, v8, 0x1

    goto :goto_8f

    :catchall_c5
    :cond_c5
    const/4 p0, 0x0

    return-object p0
.end method

.method public static originFromCanvas(Ljava/lang/Object;)[I
    .registers 14

    .line 140
    const-string v0, ","

    .line 0
    const-string v1, "\u3010GmGlass\u3011\u753b\u5e03\u77e9\u9635\uff1a"

    const/4 v2, 0x0

    if-nez p0, :cond_8

    return-object v2

    :cond_8
    const/4 v3, 0x1

    .line 142
    :try_start_9
    const-class v4, Landroid/graphics/Canvas;

    const-string v5, "getMatrix"

    const/4 v6, 0x0

    new-array v7, v6, [Ljava/lang/Class;

    invoke-virtual {v4, v5, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    .line 143
    invoke-virtual {v4, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_1b

    return-object v2

    .line 145
    :cond_1b
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v5, "getValues"

    new-array v7, v3, [Ljava/lang/Class;

    const-class v8, [F

    aput-object v8, v7, v6

    invoke-virtual {v4, v5, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    const/16 v5, 0x9

    .line 146
    new-array v5, v5, [F

    .line 147
    filled-new-array {v5}, [Ljava/lang/Object;

    move-result-object v7

    invoke-virtual {v4, p0, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 151
    aget p0, v5, v6

    const/high16 v4, 0x3f800000    # 1.0f

    sub-float/2addr p0, v4

    invoke-static {p0}, Ljava/lang/Math;->abs(F)F

    move-result p0

    float-to-double v7, p0

    const-wide v9, 0x3f50624dd2f1a9fcL    # 0.001

    cmpg-double p0, v7, v9

    const/4 v7, 0x3

    const/4 v8, 0x4

    if-gez p0, :cond_6f

    aget p0, v5, v8

    sub-float/2addr p0, v4

    invoke-static {p0}, Ljava/lang/Math;->abs(F)F

    move-result p0

    float-to-double v11, p0

    cmpg-double p0, v11, v9

    if-gez p0, :cond_6f

    aget p0, v5, v3

    .line 152
    invoke-static {p0}, Ljava/lang/Math;->abs(F)F

    move-result p0

    float-to-double v11, p0

    cmpg-double p0, v11, v9

    if-gez p0, :cond_6f

    aget p0, v5, v7

    invoke-static {p0}, Ljava/lang/Math;->abs(F)F

    move-result p0

    float-to-double v11, p0

    cmpg-double p0, v11, v9

    if-gez p0, :cond_6f

    move p0, v3

    goto :goto_70

    :cond_6f
    move p0, v6

    .line 153
    :goto_70
    sget-boolean v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged2:Z

    const/4 v9, 0x5

    const/4 v10, 0x2

    if-nez v4, :cond_bb

    .line 154
    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged2:Z

    .line 155
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget v1, v5, v6

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, v5, v3

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, v5, v10

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, " | "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, v5, v7

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, v5, v8

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v0, v5, v9

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, " | \u7eaf\u5e73\u79fb="

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_bb
    if-nez p0, :cond_be

    return-object v2

    .line 160
    :cond_be
    aget p0, v5, v10

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootX:I

    add-int/2addr p0, v0

    .line 161
    aget v0, v5, v9

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    sget v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootY:I

    add-int/2addr v0, v1

    .line 162
    filled-new-array {p0, v0}, [I

    move-result-object p0
    :try_end_d4
    .catchall {:try_start_9 .. :try_end_d4} :catchall_d5

    return-object p0

    :catchall_d5
    move-exception p0

    .line 164
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged2:Z

    if-nez v0, :cond_ed

    .line 165
    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged2:Z

    .line 166
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u753b\u5e03\u77e9\u9635\u53d6\u4e0d\u5230\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_ed
    return-object v2
.end method

.method public static setRootOffset(II)V
    .registers 2

    .line 38
    sput p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootX:I

    .line 39
    sput p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootY:I

    return-void
.end method

.method public static windowOrigin(Ljava/lang/Object;)[I
    .registers 5

    .line 52
    const-string v0, "\u65e0"

    const/4 v1, 0x0

    .line 55
    :try_start_3
    const-string v2, "DrawContext"

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->zeroArg(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_3e

    .line 57
    const-string v2, "DrawTransform"

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->zeroArg(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_3e

    .line 59
    const-string v2, "Matrix"

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->zeroArg(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_1d

    const/4 p0, 0x0

    goto :goto_21

    .line 60
    :cond_1d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->floats(Ljava/lang/Object;)[F

    move-result-object p0

    :goto_21
    if-eqz p0, :cond_3e

    .line 61
    array-length v2, p0

    const/16 v3, 0xe

    if-lt v2, v3, :cond_3e

    const/16 v2, 0xc

    .line 62
    aget v2, p0, v2

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2
    :try_end_30
    .catchall {:try_start_3 .. :try_end_30} :catchall_3e

    const/16 v3, 0xd

    .line 63
    :try_start_32
    aget p0, p0, v3

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result v1

    .line 64
    const-string p0, "DrawContext.transform"
    :try_end_3a
    .catchall {:try_start_32 .. :try_end_3a} :catchall_3b

    move-object v0, p0

    :catchall_3b
    move p0, v1

    move v1, v2

    goto :goto_3f

    :catchall_3e
    :cond_3e
    move p0, v1

    .line 70
    :goto_3f
    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged:Z

    if-nez v2, :cond_7e

    const/4 v2, 0x1

    .line 71
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sLogged:Z

    .line 72
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010GmGlass\u3011\u5750\u6807\u53cd\u63a8["

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "]\uff1a\u8282\u70b9("

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ","

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ") + \u6839("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootX:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootY:I

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 75
    :cond_7e
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootX:I

    add-int/2addr v1, v0

    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->sRootY:I

    add-int/2addr p0, v0

    filled-new-array {v1, p0}, [I

    move-result-object p0

    return-object p0
.end method

.method private static zeroArg(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    .line 177
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_b
    if-ge v3, v2, :cond_45

    aget-object v4, v1, v3

    .line 178
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v5

    if-eqz v5, :cond_16

    goto :goto_42

    .line 179
    :cond_16
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    .line 180
    invoke-virtual {v5}, Ljava/lang/Class;->isPrimitive()Z

    move-result v6

    if-nez v6, :cond_42

    sget-object v6, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-ne v5, v6, :cond_25

    goto :goto_42

    .line 181
    :cond_25
    const-class v6, Ljava/lang/String;

    if-ne v5, v6, :cond_2a

    goto :goto_42

    .line 182
    :cond_2a
    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_3d

    goto :goto_42

    .line 183
    :cond_3d
    invoke-virtual {v4, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_41
    .catchall {:try_start_1 .. :try_end_41} :catchall_45

    return-object p0

    :cond_42
    :goto_42
    add-int/lit8 v3, v3, 0x1

    goto :goto_b

    :catchall_45
    :cond_45
    return-object v0
.end method

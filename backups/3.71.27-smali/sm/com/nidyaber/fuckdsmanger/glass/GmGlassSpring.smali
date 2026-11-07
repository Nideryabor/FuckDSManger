.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;
.super Ljava/lang/Object;
.source "GmGlassSpring.java"


# static fields
.field private static final C:D = 26.0

.field private static final K:D = 900.0

.field public static final PRESS_SCALE:D = 0.94

.field private static volatile sDown:Z = false

.field private static volatile sLastNs:J = 0x0L

.field private static volatile sV:D = 0.0

.field private static volatile sX:D = 1.0


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isDown()Z
    .registers 1

    .line 50
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sDown:Z

    return v0
.end method

.method public static moving()Z
    .registers 4

    .line 84
    sget-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sX:D

    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sDown:Z

    if-eqz v2, :cond_c

    const-wide v2, 0x3fee147ae147ae14L    # 0.94

    goto :goto_e

    :cond_c
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    :goto_e
    sub-double/2addr v0, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide v0

    const-wide v2, 0x3f60624dd2f1a9fcL    # 0.002

    cmpl-double v0, v0, v2

    if-gtz v0, :cond_2e

    sget-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sV:D

    .line 85
    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide v0

    const-wide v2, 0x3f947ae147ae147bL    # 0.02

    cmpl-double v0, v0, v2

    if-lez v0, :cond_2c

    goto :goto_2e

    :cond_2c
    const/4 v0, 0x0

    return v0

    :cond_2e
    :goto_2e
    const/4 v0, 0x1

    return v0
.end method

.method public static onDown()V
    .registers 1

    const/4 v0, 0x1

    .line 42
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sDown:Z

    return-void
.end method

.method public static onUp()V
    .registers 1

    const/4 v0, 0x0

    .line 46
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sDown:Z

    return-void
.end method

.method public static tick()D
    .registers 13

    .line 59
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v0

    .line 60
    sget-wide v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sLastNs:J

    .line 61
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sLastNs:J

    const-wide/16 v4, 0x0

    cmp-long v4, v2, v4

    if-nez v4, :cond_11

    .line 62
    sget-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sX:D

    return-wide v0

    :cond_11
    sub-long/2addr v0, v2

    long-to-double v0, v0

    const-wide v2, 0x41cdcd6500000000L    # 1.0E9

    div-double/2addr v0, v2

    const-wide/16 v2, 0x0

    cmpg-double v2, v0, v2

    if-gtz v2, :cond_22

    .line 65
    sget-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sX:D

    return-wide v0

    :cond_22
    const-wide v2, 0x3fa999999999999aL    # 0.05

    cmpl-double v4, v0, v2

    if-lez v4, :cond_2c

    move-wide v0, v2

    .line 68
    :cond_2c
    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sDown:Z

    if-eqz v2, :cond_36

    const-wide v2, 0x3fee147ae147ae14L    # 0.94

    goto :goto_38

    :cond_36
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    .line 69
    :goto_38
    sget-wide v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sX:D

    sget-wide v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sV:D

    const-wide/high16 v8, 0x4010000000000000L    # 4.0

    div-double/2addr v0, v8

    const/4 v8, 0x0

    :goto_40
    const/4 v9, 0x4

    if-ge v8, v9, :cond_57

    const-wide v9, 0x408c200000000000L    # 900.0

    sub-double v11, v2, v4

    mul-double/2addr v11, v9

    const-wide/high16 v9, 0x403a000000000000L    # 26.0

    mul-double/2addr v9, v6

    sub-double/2addr v11, v9

    mul-double/2addr v11, v0

    add-double/2addr v6, v11

    mul-double v9, v6, v0

    add-double/2addr v4, v9

    add-int/lit8 v8, v8, 0x1

    goto :goto_40

    .line 77
    :cond_57
    sput-wide v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sX:D

    .line 78
    sput-wide v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->sV:D

    return-wide v4
.end method

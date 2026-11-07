.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmRichTextHook.java"


# static fields
.field private static final CAND_DECO:[Ljava/lang/String;

.field private static final CAND_IN:[Ljava/lang/String;

.field private static final CAND_KN:[Ljava/lang/String;

.field private static final CAND_MT:[Ljava/lang/String;

.field private static final CAND_SPAN:[Ljava/lang/String;

.field private static final CAND_STYLE:[Ljava/lang/String;

.field private static final CAND_WEIGHT:[Ljava/lang/String;

.field private static final LOCK:Ljava/lang/Object;

.field private static cDeco:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cIn:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cKn:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cSpan:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cStyle:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cWeight:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctDeco:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctInNew:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctSpan:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctStyle:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctWeight:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static fText:Ljava/lang/reflect/Field;

.field private static mAppendKn:Ljava/lang/reflect/Method;

.field private static mAppendStr:Ljava/lang/reflect/Method;

.field private static mPop:Ljava/lang/reflect/Method;

.field private static mPush:Ljava/lang/reflect/Method;

.field private static mToKn:Ljava/lang/reflect/Method;

.field private static volatile sBare:Z

.field private static volatile sBareAt:J

.field private static final sBgCache:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Long;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static sBold:Ljava/lang/Object;

.field private static final sColorCache:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Long;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sHits:I

.field private static sItalic:Ljava/lang/Object;

.field private static volatile sReady:Z

.field private static volatile sRenders:I

.field private static sStrike:Ljava/lang/Object;

.field private static volatile sTried:Z

.field private static sUline:Ljava/lang/Object;

.field private static volatile sWhy:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 64
    const-string v0, "mn"

    const-string v1, "ln"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_KN:[Ljava/lang/String;

    .line 66
    const-string v0, "kn"

    const-string v1, "jn"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_IN:[Ljava/lang/String;

    .line 68
    const-string v0, "m6a"

    const-string v1, "y2a"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_SPAN:[Ljava/lang/String;

    .line 70
    const-string v0, "wq4"

    const-string v1, "oo4"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_WEIGHT:[Ljava/lang/String;

    .line 72
    const-string v0, "uq4"

    const-string v1, "mo4"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_STYLE:[Ljava/lang/String;

    .line 74
    const-string v0, "yoa"

    const-string v1, "xka"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_DECO:[Ljava/lang/String;

    .line 81
    const-string v0, "q13"

    const-string v1, "bz0"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_MT:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 108
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    .line 109
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    .line 110
    const-string v1, "\u672a\u521d\u59cb\u5316"

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    .line 111
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sHits:I

    .line 112
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sRenders:I

    .line 115
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    .line 117
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sColorCache:Ljava/util/HashMap;

    .line 118
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBgCache:Ljava/util/HashMap;

    const/4 v0, 0x1

    .line 180
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBare:Z

    const-wide/16 v0, 0x0

    .line 181
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBareAt:J

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 59
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static appendText(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)V
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-gt p4, p3, :cond_3

    return-void

    :cond_3
    if-eqz p5, :cond_13

    .line 402
    sget-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    invoke-virtual {p2, p3, p4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p2

    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p1, p0, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    return-void

    .line 404
    :cond_13
    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendKn:Ljava/lang/reflect/Method;

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p3

    invoke-static {p4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p4

    filled-new-array {p1, p3, p4}, [Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p2, p0, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private static bail(Ljava/lang/String;)Z
    .registers 1

    .line 872
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    const/4 p0, 0x0

    return p0
.end method

.method private static bareCached()Z
    .registers 6

    .line 209
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 210
    sget-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBareAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x1f4

    cmp-long v2, v2, v4

    if-gtz v2, :cond_16

    sget-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBareAt:J

    const-wide/16 v4, 0x0

    cmp-long v2, v2, v4

    if-nez v2, :cond_1e

    .line 211
    :cond_16
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->bareOn()Z

    move-result v2

    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBare:Z

    .line 212
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBareAt:J

    .line 214
    :cond_1e
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBare:Z

    return v0
.end method

.method private static bgStyle(Ljava/lang/Long;)Ljava/lang/Object;
    .registers 5

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 618
    :cond_4
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v1

    .line 619
    :try_start_7
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBgCache:Ljava/util/HashMap;

    invoke-virtual {v2, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_11

    .line 620
    monitor-exit v1

    return-object v3

    .line 621
    :cond_11
    invoke-static {v0, p0, v0, v0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_1a

    .line 622
    invoke-virtual {v2, p0, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 623
    :cond_1a
    monitor-exit v1

    return-object v0

    :catchall_1c
    move-exception p0

    .line 624
    monitor-exit v1
    :try_end_1e
    .catchall {:try_start_7 .. :try_end_1e} :catchall_1c

    throw p0
.end method

.method private static bold()Ljava/lang/Object;
    .registers 3

    .line 628
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 629
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBold:Ljava/lang/Object;

    if-nez v1, :cond_14

    const/16 v1, 0x2bc

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->newWeight(I)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    invoke-static {v2, v2, v1, v2, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sBold:Ljava/lang/Object;

    .line 630
    :cond_14
    monitor-exit v0

    return-object v1

    :catchall_16
    move-exception v1

    .line 631
    monitor-exit v0
    :try_end_18
    .catchall {:try_start_3 .. :try_end_18} :catchall_16

    throw v1
.end method

.method private static colorOf(Ljava/lang/String;)Ljava/lang/Long;
    .registers 9

    const/4 v0, 0x0

    if-eqz p0, :cond_a8

    .line 532
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_b

    goto/16 :goto_a8

    :cond_b
    const/4 v1, 0x0

    .line 533
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x31

    const/16 v4, 0x20

    const-wide v5, 0xffffffffL

    const/4 v7, 0x1

    if-lt v2, v3, :cond_34

    const/16 v3, 0x39

    if-gt v2, v3, :cond_34

    .line 534
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ne v3, v7, :cond_34

    add-int/lit8 v2, v2, -0x30

    .line 536
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->palette(I)I

    move-result p0

    int-to-long v0, p0

    and-long/2addr v0, v5

    shl-long/2addr v0, v4

    .line 537
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    return-object p0

    :cond_34
    const/16 v3, 0x23

    if-ne v2, v3, :cond_a8

    .line 541
    invoke-virtual {p0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 545
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    const/4 v3, 0x3

    if-ne v2, v3, :cond_7d

    .line 547
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, ""

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 548
    invoke-virtual {p0, v7}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/4 v1, 0x2

    .line 549
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 551
    :cond_7d
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x6

    if-ne v1, v2, :cond_92

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "FF"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 552
    :cond_92
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x8

    if-eq v1, v2, :cond_9b

    return-object v0

    :cond_9b
    const/16 v1, 0x10

    .line 554
    :try_start_9d
    invoke-static {p0, v1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v1

    and-long/2addr v1, v5

    shl-long/2addr v1, v4

    .line 555
    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0
    :try_end_a7
    .catchall {:try_start_9d .. :try_end_a7} :catchall_a8

    return-object p0

    :catchall_a8
    :cond_a8
    :goto_a8
    return-object v0
.end method

.method private static colorStyle(Ljava/lang/Long;)Ljava/lang/Object;
    .registers 6

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 563
    :cond_4
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v1

    .line 564
    :try_start_7
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sColorCache:Ljava/util/HashMap;

    invoke-virtual {v2, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_11

    .line 565
    monitor-exit v1

    return-object v3

    .line 566
    :cond_11
    invoke-static {p0, v0, v0, v0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_21

    .line 571
    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    invoke-static {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->selfCheckColor(Ljava/lang/Object;J)V

    .line 572
    invoke-virtual {v2, p0, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 574
    :cond_21
    monitor-exit v1

    return-object v0

    :catchall_23
    move-exception p0

    .line 575
    monitor-exit v1
    :try_end_25
    .catchall {:try_start_7 .. :try_end_25} :catchall_23

    throw p0
.end method

.method private static emit(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;Ljava/util/LinkedHashMap;)V
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x0

    if-nez p2, :cond_5

    move-object p2, v0

    goto :goto_d

    .line 475
    :cond_5
    iget-object v1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    :goto_d
    if-nez p2, :cond_11

    .line 476
    const-string p2, ""

    .line 477
    :cond_11
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_5e

    .line 479
    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3014"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\u3015"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p2, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 480
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p2, "richHook.noTpl."

    invoke-direct {p0, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u6a21\u677f\u300c"

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\u300d\u6ca1\u914d\u8fc7 \u2014\u2014 \u663e\u793a\u5360\u4f4d\u7b26"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 484
    :cond_5e
    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    invoke-static {p2, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->fill(Ljava/lang/String;[Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 485
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->parseHtml(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    .line 488
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 p2, 0x0

    :cond_6d
    :goto_6d
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_b8

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    .line 489
    iget v2, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->kind:I

    if-nez v2, :cond_95

    .line 490
    iget-object v2, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    if-eqz v2, :cond_6d

    iget-object v2, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_6d

    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    iget-object v1, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v2, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_6d

    .line 491
    :cond_95
    iget v2, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->kind:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_ae

    .line 492
    iget-object v1, v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->tag:Ljava/lang/String;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->styleFor(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_6d

    .line 494
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v2, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 p2, p2, 0x1

    goto :goto_6d

    :cond_ae
    if-lez p2, :cond_6d

    .line 500
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {v1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 p2, p2, -0x1

    goto :goto_6d

    :cond_b8
    :goto_b8
    add-int/lit8 p1, p2, -0x1

    if-lez p2, :cond_c3

    .line 505
    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {p2, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move p2, p1

    goto :goto_b8

    :cond_c3
    return-void
.end method

.method private static emitAnon(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;Ljava/lang/String;)V
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 426
    iget v0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    add-int/lit8 v0, v0, 0x5

    .line 427
    iget p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    add-int/lit8 p1, p1, -0x6

    if-gt p1, v0, :cond_b

    goto :goto_6f

    .line 429
    :cond_b
    invoke-virtual {p2, v0, p1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 430
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->parseHtml(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    .line 432
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 p2, 0x0

    :cond_18
    :goto_18
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_64

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    .line 433
    iget v2, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->kind:I

    if-nez v2, :cond_41

    .line 434
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    if-eqz v1, :cond_18

    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_18

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_18

    .line 435
    :cond_41
    iget v2, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->kind:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_5a

    .line 436
    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->tag:Ljava/lang/String;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->styleFor(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_18

    .line 438
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v1, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 p2, p2, 0x1

    goto :goto_18

    :cond_5a
    if-lez p2, :cond_18

    .line 443
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 p2, p2, -0x1

    goto :goto_18

    :cond_64
    :goto_64
    add-int/lit8 p1, p2, -0x1

    if-lez p2, :cond_6f

    .line 448
    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {p2, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move p2, p1

    goto :goto_64

    :cond_6f
    :goto_6f
    return-void
.end method

.method private static emitPlain(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)Z
    .registers 24
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v2, p2

    move/from16 v6, p4

    const/4 v7, 0x0

    move/from16 v1, p3

    if-lt v1, v6, :cond_c

    return v7

    :cond_c
    if-nez p5, :cond_22

    .line 308
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendKn:Ljava/lang/reflect/Method;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    move-object/from16 v4, p1

    filled-new-array {v4, v1, v3}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v2, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    return v7

    :cond_22
    move-object/from16 v4, p1

    .line 313
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    move v3, v1

    move v9, v7

    :goto_2b
    const/4 v10, 0x0

    const/4 v11, 0x1

    if-ge v1, v6, :cond_f5

    .line 317
    invoke-virtual {v2, v1}, Ljava/lang/String;->charAt(I)C

    move-result v5

    const/16 v12, 0x3c

    if-eq v5, v12, :cond_3a

    add-int/lit8 v1, v1, 0x1

    goto :goto_2b

    :cond_3a
    const/16 v5, 0x3e

    .line 321
    invoke-virtual {v2, v5, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v12

    if-ltz v12, :cond_eb

    if-ge v12, v6, :cond_eb

    sub-int v5, v12, v1

    const/16 v13, 0x10

    if-le v5, v13, :cond_4c

    goto/16 :goto_eb

    :cond_4c
    add-int/lit8 v5, v1, 0x1

    .line 327
    invoke-virtual {v2, v5, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    .line 328
    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v14

    if-eqz v14, :cond_5e

    move v1, v5

    goto :goto_2b

    .line 332
    :cond_5e
    invoke-virtual {v13, v7}, Ljava/lang/String;->charAt(I)C

    move-result v14

    const/16 v15, 0x2f

    if-ne v14, v15, :cond_68

    move v14, v11

    goto :goto_69

    :cond_68
    move v14, v7

    :goto_69
    if-eqz v14, :cond_73

    .line 333
    invoke-virtual {v13, v11}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    .line 334
    :cond_73
    invoke-static {v13}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->normTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v15

    if-nez v15, :cond_8e

    if-eqz v14, :cond_8e

    .line 337
    const-string v7, "c"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v16

    if-eqz v16, :cond_85

    :goto_83
    move-object v15, v7

    goto :goto_8e

    .line 338
    :cond_85
    const-string v7, "bg"

    invoke-virtual {v7, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_8e

    goto :goto_83

    :cond_8e
    :goto_8e
    if-nez v15, :cond_92

    move v1, v5

    goto :goto_f2

    .line 345
    :cond_92
    invoke-interface {v8}, Ljava/util/List;->isEmpty()Z

    move-result v5

    xor-int/2addr v5, v11

    move-object/from16 v17, v4

    move v4, v1

    move-object/from16 v1, v17

    invoke-static/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->appendText(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)V

    if-eqz v14, :cond_bb

    .line 348
    invoke-static {v8, v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->matchTop(Ljava/util/List;Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_e3

    .line 350
    :goto_a7
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v2

    if-le v2, v1, :cond_ce

    .line 351
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v2

    sub-int/2addr v2, v11

    invoke-interface {v8, v2}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 352
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {v2, v0, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_a7

    .line 356
    :cond_bb
    const-string v1, "br"

    invoke-virtual {v1, v15}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_d0

    .line 357
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    const-string v2, "\n"

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    :cond_ce
    :goto_ce
    move v9, v11

    goto :goto_e3

    .line 360
    :cond_d0
    invoke-static {v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->styleFor(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_e3

    .line 362
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v2, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 363
    invoke-interface {v8, v15}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_ce

    :cond_e3
    :goto_e3
    add-int/lit8 v3, v12, 0x1

    move-object/from16 v4, p1

    move-object/from16 v2, p2

    move v1, v3

    goto :goto_f2

    :cond_eb
    :goto_eb
    move v4, v1

    add-int/lit8 v1, v4, 0x1

    move-object/from16 v4, p1

    move-object/from16 v2, p2

    :goto_f2
    const/4 v7, 0x0

    goto/16 :goto_2b

    .line 370
    :cond_f5
    invoke-interface {v8}, Ljava/util/List;->isEmpty()Z

    move-result v1

    xor-int/lit8 v5, v1, 0x1

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move v4, v6

    invoke-static/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->appendText(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)V

    .line 371
    :goto_103
    invoke-interface {v8}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_117

    .line 372
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v1

    sub-int/2addr v1, v11

    invoke-interface {v8, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 373
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    invoke-virtual {v1, v0, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_103

    :cond_117
    return v9
.end method

.method private static emitSuggest(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 461
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ready()Z

    move-result v0

    if-eqz v0, :cond_46

    .line 462
    iget-object v0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    iget-object v1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    const-string v2, "fdm_sug"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->emitLink(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 463
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "richHook.sug."

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u5efa\u8bae\u5df2\u6e32\u67d3\u6210\u53ef\u70b9\u51fb\uff1a\u300c"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\u300d\u2192 \u56de\u590d\u300c"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\u300d"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 466
    :cond_46
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {v0, p0, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 467
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "\u5efa\u8bae\u94fe\u63a5\u80fd\u529b\u672a\u5c31\u7eea\uff08"

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 468
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->why()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\uff09\u21d2 \u53ea\u5265\u6807\u7b7e"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 467
    const-string p1, "richHook.sug.nolink"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static hits()I
    .registers 1

    .line 121
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sHits:I

    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)I
    .registers 14

    .line 734
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->prepare(Ljava/lang/ClassLoader;)Z

    move-result v0

    const-string v1, "hookM FAIL richText \u2192 "

    const/4 v2, 0x0

    if-nez v0, :cond_1b

    .line 735
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2

    .line 738
    :cond_1b
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_MT:[Ljava/lang/String;

    array-length v3, v0

    move v4, v2

    :goto_1f
    if-ge v4, v3, :cond_ce

    aget-object v5, v0, v4

    .line 740
    :try_start_23
    invoke-static {v5, v2, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v6

    .line 742
    invoke-virtual {v6}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v6

    array-length v7, v6

    move v8, v2

    :goto_2d
    if-ge v8, v7, :cond_70

    aget-object v9, v6, v8

    .line 744
    const-string v10, "k"

    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-nez v10, :cond_4a

    const-string v10, "y"

    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-nez v10, :cond_4a

    goto :goto_6d

    .line 745
    :cond_4a
    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v10

    invoke-static {v10}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v10

    if-nez v10, :cond_55

    goto :goto_6d

    .line 746
    :cond_55
    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v10

    sget-object v11, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-eq v10, v11, :cond_5e

    goto :goto_6d

    .line 747
    :cond_5e
    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v10

    .line 748
    array-length v11, v10

    const/4 v12, 0x7

    if-eq v11, v12, :cond_67

    goto :goto_6d

    .line 749
    :cond_67
    aget-object v10, v10, v2

    sget-object v11, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    if-eq v10, v11, :cond_71

    :goto_6d
    add-int/lit8 v8, v8, 0x1

    goto :goto_2d

    :cond_70
    const/4 v9, 0x0

    :cond_71
    if-nez v9, :cond_8b

    .line 754
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " \u7c7b\u5728\uff0c\u4f46\u6ca1\u6709 p(AnnotatedString,\u2026) \u8fd9\u4e2a\u65b9\u6cd5\uff08\u540d\u5b57\u88ab\u590d\u7528\uff1f\u8be5\u91cd\u65b0\u53cd\u67e5\u4e86\uff09"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_ca

    :cond_8b
    const/4 v6, 0x1

    .line 758
    invoke-virtual {v9, v6}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 759
    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;

    invoke-direct {v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;-><init>()V

    invoke-static {v9, v7}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 760
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "hookM richText count=1 cls="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, ".p \u7b7e\u540d="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b7
    .catchall {:try_start_23 .. :try_end_b7} :catchall_b8

    return v6

    :catchall_b8
    move-exception v6

    .line 763
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "richTextHook.install/"

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_ca
    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_1f

    .line 766
    :cond_ce
    const-string p0, "hookM FAIL richText \u2192 \u5168\u90e8\u5019\u9009\u672a\u547d\u4e2d\uff0c\u5bbf\u4e3b\u53ef\u80fd\u5df2\u6539\u7248"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2
.end method

.method private static italic()Ljava/lang/Object;
    .registers 3

    .line 635
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 636
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sItalic:Ljava/lang/Object;

    if-nez v1, :cond_13

    const/4 v1, 0x1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->newStyle(I)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    invoke-static {v2, v2, v2, v1, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sItalic:Ljava/lang/Object;

    .line 637
    :cond_13
    monitor-exit v0

    return-object v1

    :catchall_15
    move-exception v1

    .line 638
    monitor-exit v0
    :try_end_17
    .catchall {:try_start_3 .. :try_end_17} :catchall_15

    throw v1
.end method

.method private static load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/ClassLoader;",
            "[",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation

    .line 877
    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    :goto_3
    if-ge v2, v0, :cond_11

    aget-object v3, p1, v2

    .line 879
    :try_start_7
    invoke-static {v3, v1, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3
    :try_end_b
    .catchall {:try_start_7 .. :try_end_b} :catchall_e

    if-eqz v3, :cond_e

    return-object v3

    :catchall_e
    :cond_e
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    :cond_11
    const/4 p0, 0x0

    return-object p0
.end method

.method private static matchTop(Ljava/util/List;Ljava/lang/String;)I
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")I"
        }
    .end annotation

    .line 410
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    :goto_6
    if-ltz v0, :cond_39

    .line 411
    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 412
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_15

    goto :goto_35

    .line 413
    :cond_15
    const-string v2, "c"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_27

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x63

    if-ne v2, v3, :cond_27

    goto :goto_35

    .line 414
    :cond_27
    const-string v2, "bg"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_36

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_36

    :goto_35
    return v0

    :cond_36
    add-int/lit8 v0, v0, -0x1

    goto :goto_6

    :cond_39
    const/4 p0, -0x1

    return p0
.end method

.method private static mayRender(Ljava/lang/String;)Z
    .registers 4

    const/4 v0, 0x0

    if-eqz p0, :cond_38

    .line 190
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_38

    .line 191
    :cond_a
    const-string v1, "\u27e6FDM:"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    const/4 v2, 0x1

    if-ltz v1, :cond_14

    return v2

    .line 192
    :cond_14
    const-string v1, "\u27e6FDM\u27e7"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_1d

    return v2

    .line 193
    :cond_1d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->hasSuggest(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_24

    return v2

    .line 197
    :cond_24
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->hasDj(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2b

    return v2

    .line 198
    :cond_2b
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bareCached()Z

    move-result v1

    if-eqz v1, :cond_38

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->hasBareTag(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_38

    return v2

    :cond_38
    :goto_38
    return v0
.end method

.method private static newDeco(I)Ljava/lang/Object;
    .registers 2

    .line 673
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctDeco:Ljava/lang/reflect/Constructor;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return-object p0

    :catchall_f
    const/4 p0, 0x0

    return-object p0
.end method

.method private static newStyle(I)Ljava/lang/Object;
    .registers 2

    .line 665
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctStyle:Ljava/lang/reflect/Constructor;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return-object p0

    :catchall_f
    const/4 p0, 0x0

    return-object p0
.end method

.method private static newWeight(I)Ljava/lang/Object;
    .registers 2

    .line 657
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctWeight:Ljava/lang/reflect/Constructor;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return-object p0

    :catchall_f
    const/4 p0, 0x0

    return-object p0
.end method

.method private static varargs pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Method;"
        }
    .end annotation

    .line 891
    :try_start_0
    invoke-virtual {p0, p1, p2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    const/4 p1, 0x1

    .line 892
    invoke-virtual {p0, p1}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_9

    return-object p0

    :catchall_9
    const/4 p0, 0x0

    return-object p0
.end method

.method private static pickCtor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;
    .registers 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation

    .line 901
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_7
    if-ge v2, v0, :cond_20

    aget-object v3, p0, v2

    .line 902
    invoke-virtual {v3}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v4

    .line 903
    array-length v5, v4

    const/4 v6, 0x1

    if-ne v5, v6, :cond_1d

    aget-object v4, v4, v1

    sget-object v5, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v4, v5, :cond_1d

    .line 904
    invoke-virtual {v3, v6}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    return-object v3

    :cond_1d
    add-int/lit8 v2, v2, 0x1

    goto :goto_7

    :cond_20
    const/4 p0, 0x0

    return-object p0
.end method

.method private static prepare(Ljava/lang/ClassLoader;)Z
    .registers 12

    .line 778
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    if-eqz v0, :cond_7

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    return p0

    .line 779
    :cond_7
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;

    monitor-enter v0

    .line 780
    :try_start_a
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    if-eqz v1, :cond_12

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    monitor-exit v0
    :try_end_11
    .catchall {:try_start_a .. :try_end_11} :catchall_277

    return p0

    :cond_12
    const/4 v1, 0x0

    const/4 v2, 0x1

    .line 783
    :try_start_14
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_SPAN:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cSpan:Ljava/lang/Class;

    if-nez v3, :cond_28

    .line 784
    const-string p0, "SpanStyle \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_24
    .catchall {:try_start_14 .. :try_end_24} :catchall_252

    .line 866
    :goto_24
    :try_start_24
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    monitor-exit v0
    :try_end_27
    .catchall {:try_start_24 .. :try_end_27} :catchall_277

    return p0

    .line 785
    :cond_28
    :try_start_28
    invoke-virtual {v3}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v3

    array-length v3, v3

    const/16 v4, 0xe

    if-ge v3, v4, :cond_38

    const-string p0, "f0a \u5b57\u6bb5\u6570\u4e0d\u8db3\uff0c\u4e0d\u50cf SpanStyle"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto :goto_24

    .line 786
    :cond_38
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cSpan:Ljava/lang/Class;

    invoke-virtual {v3}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v3

    array-length v5, v3

    move v6, v1

    :goto_40
    if-ge v6, v5, :cond_65

    aget-object v7, v3, v6

    .line 787
    invoke-virtual {v7}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 788
    array-length v9, v8

    const/16 v10, 0xf

    if-ne v9, v10, :cond_62

    aget-object v9, v8, v1

    sget-object v10, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v9, v10, :cond_62

    aget-object v9, v8, v2

    sget-object v10, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v9, v10, :cond_62

    aget-object v8, v8, v4

    sget-object v9, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v8, v9, :cond_62

    .line 790
    sput-object v7, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctSpan:Ljava/lang/reflect/Constructor;

    goto :goto_65

    :cond_62
    add-int/lit8 v6, v6, 0x1

    goto :goto_40

    .line 794
    :cond_65
    :goto_65
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctSpan:Ljava/lang/reflect/Constructor;

    if-nez v3, :cond_70

    const-string p0, "SpanStyle 15 \u53c2\u6784\u9020\u5668\u6ca1\u627e\u5230\uff08mask \u7248\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto :goto_24

    .line 795
    :cond_70
    invoke-virtual {v3, v2}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 798
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_KN:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    if-nez v3, :cond_84

    .line 799
    const-string p0, "AnnotatedString \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto :goto_24

    .line 800
    :cond_84
    const-class v4, Ljava/lang/CharSequence;

    invoke-virtual {v4, v3}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v3

    if-nez v3, :cond_93

    const-string p0, "kn \u4e0d\u662f CharSequence"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto :goto_24

    .line 801
    :cond_93
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    const-string v4, "b"

    invoke-virtual {v3, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->fText:Ljava/lang/reflect/Field;

    .line 802
    invoke-virtual {v3, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 803
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->fText:Ljava/lang/reflect/Field;

    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v3

    const-class v4, Ljava/lang/String;

    if-eq v3, v4, :cond_b2

    const-string p0, "kn.b \u4e0d\u662f String"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 804
    :cond_b2
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    const/4 v5, 0x2

    new-array v6, v5, [Ljava/lang/Class;

    aput-object v4, v6, v1

    const-class v7, Ljava/util/List;

    aput-object v7, v6, v2

    invoke-virtual {v3, v6}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    .line 807
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_IN:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    if-nez v3, :cond_d2

    .line 808
    const-string p0, "AnnotatedString.Builder \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 809
    :cond_d2
    new-array v6, v1, [Ljava/lang/Class;

    const/4 v6, 0x0

    invoke-virtual {v3, v6}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctInNew:Ljava/lang/reflect/Constructor;

    .line 810
    invoke-virtual {v3, v2}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 811
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    const-string v6, "c"

    const/4 v7, 0x3

    new-array v7, v7, [Ljava/lang/Class;

    sget-object v8, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    aput-object v8, v7, v1

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v8, v7, v2

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v8, v7, v5

    invoke-static {v3, v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendKn:Ljava/lang/reflect/Method;

    .line 812
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    const-string v5, "e"

    new-array v6, v2, [Ljava/lang/Class;

    aput-object v4, v6, v1

    invoke-static {v3, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    .line 813
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    const-string v4, "j"

    new-array v5, v2, [Ljava/lang/Class;

    sget-object v6, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cSpan:Ljava/lang/Class;

    aput-object v6, v5, v1

    invoke-static {v3, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    .line 814
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    const-string v4, "f"

    new-array v5, v1, [Ljava/lang/Class;

    invoke-static {v3, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    .line 815
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cIn:Ljava/lang/Class;

    const-string v4, "k"

    new-array v5, v1, [Ljava/lang/Class;

    invoke-static {v3, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mToKn:Ljava/lang/reflect/Method;

    .line 816
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendKn:Ljava/lang/reflect/Method;

    if-eqz v4, :cond_24a

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    if-eqz v4, :cond_24a

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    if-eqz v4, :cond_24a

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPop:Ljava/lang/reflect/Method;

    if-eqz v4, :cond_24a

    if-nez v3, :cond_141

    goto/16 :goto_24a

    .line 820
    :cond_141
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v3

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    if-eq v3, v4, :cond_151

    const-string p0, "in.k() \u8fd4\u56de\u7684\u4e0d\u662f AnnotatedString"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 821
    :cond_151
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mPush:Ljava/lang/reflect/Method;

    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v3

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v3, v4, :cond_163

    const-string p0, "in.j(\u2026) \u8fd4\u56de\u7684\u4e0d\u662f int\uff08\u4e0d\u50cf\u662f pushStyle\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 824
    :cond_163
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_WEIGHT:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cWeight:Ljava/lang/Class;

    if-nez v3, :cond_175

    .line 825
    const-string p0, "FontWeight \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 826
    :cond_175
    const-string v4, "a"

    invoke-virtual {v3, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v3

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v3, v4, :cond_18b

    const-string p0, "ko4.a \u4e0d\u662f int"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 827
    :cond_18b
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cWeight:Ljava/lang/Class;

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pickCtor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctWeight:Ljava/lang/reflect/Constructor;

    .line 829
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_STYLE:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cStyle:Ljava/lang/Class;

    if-nez v3, :cond_1a5

    .line 830
    const-string p0, "FontStyle \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 831
    :cond_1a5
    const-string v4, "a"

    invoke-virtual {v3, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v3

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v3, v4, :cond_1bb

    const-string p0, "io4.a \u4e0d\u662f int"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 832
    :cond_1bb
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cStyle:Ljava/lang/Class;

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pickCtor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctStyle:Ljava/lang/reflect/Constructor;

    .line 834
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->CAND_DECO:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cDeco:Ljava/lang/Class;

    if-nez v3, :cond_1d5

    .line 835
    const-string p0, "TextDecoration \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 836
    :cond_1d5
    const-string v4, "a"

    invoke-virtual {v3, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v3

    sget-object v4, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v3, v4, :cond_1eb

    const-string p0, "dia.a \u4e0d\u662f int"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 837
    :cond_1eb
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cDeco:Ljava/lang/Class;

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->pickCtor(Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctDeco:Ljava/lang/reflect/Constructor;

    .line 839
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctWeight:Ljava/lang/reflect/Constructor;

    if-eqz v4, :cond_242

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctStyle:Ljava/lang/reflect/Constructor;

    if-eqz v4, :cond_242

    if-nez v3, :cond_1fe

    goto :goto_242

    .line 843
    :cond_1fe
    const-string v3, "\u81ea\u68c0\u5168\u8fc7\uff08kn/in/f0a/ko4/io4/dia\uff09"

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    .line 844
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    .line 846
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->prepare(Ljava/lang/ClassLoader;)Z

    .line 848
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->prepare(Ljava/lang/ClassLoader;)Z

    move-result v3

    if-eqz v3, :cond_210

    .line 849
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->install(Ljava/lang/ClassLoader;)V

    .line 851
    :cond_210
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "richText \u81ea\u68c0 OK\uff1a"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \u00b7 \u94fe\u63a5\uff1a"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 852
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->status()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \u00b7 \u53d1\u9001\uff1a"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 853
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->status()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 851
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_23e
    .catchall {:try_start_28 .. :try_end_23e} :catchall_252

    .line 866
    :try_start_23e
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    monitor-exit v0
    :try_end_241
    .catchall {:try_start_23e .. :try_end_241} :catchall_277

    return v2

    .line 840
    :cond_242
    :goto_242
    :try_start_242
    const-string p0, "FontWeight/FontStyle/TextDecoration \u6709\u7f3a (int) \u6784\u9020\u5668"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0

    goto/16 :goto_24

    .line 818
    :cond_24a
    :goto_24a
    const-string p0, "Builder \u7684 append/pushStyle/pop/toAnnotatedString \u6709\u7f3a"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_250
    .catchall {:try_start_242 .. :try_end_250} :catchall_252

    goto/16 :goto_24

    :catchall_252
    move-exception p0

    .line 856
    :try_start_253
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u81ea\u68c0\u629b\u5f02\u5e38\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;
    :try_end_266
    .catchall {:try_start_253 .. :try_end_266} :catchall_273

    .line 858
    :try_start_266
    const-string v3, "richText.prepare"

    invoke-static {v3, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_26b
    .catchall {:try_start_266 .. :try_end_26b} :catchall_26b

    .line 862
    :catchall_26b
    :try_start_26b
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    .line 863
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z
    :try_end_26f
    .catchall {:try_start_26b .. :try_end_26f} :catchall_273

    .line 866
    :try_start_26f
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    monitor-exit v0

    return v1

    :catchall_273
    move-exception p0

    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sTried:Z

    .line 867
    throw p0

    :catchall_277
    move-exception p0

    .line 868
    monitor-exit v0
    :try_end_279
    .catchall {:try_start_26f .. :try_end_279} :catchall_277

    throw p0
.end method

.method private static rebuild(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .registers 14
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 220
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bareCached()Z

    move-result v6

    .line 221
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->scan(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    const/4 v7, 0x1

    const/4 v1, 0x0

    if-eqz v6, :cond_14

    .line 222
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->hasBareTag(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_14

    move v2, v7

    goto :goto_15

    :cond_14
    move v2, v1

    .line 223
    :goto_15
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v3

    const/4 v8, 0x0

    if-eqz v3, :cond_1f

    if-nez v2, :cond_1f

    return-object v8

    .line 225
    :cond_1f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->on()Z

    move-result v2

    if-nez v2, :cond_2d

    .line 226
    const-string p0, "richHook.off"

    const-string p1, "\u5bcc\u6587\u672c\u5f00\u5173\u662f\u5173\u7684\uff08fuckds_rich_on\uff09\u2014\u2014 \u53ea\u62a5\u4e00\u6b21"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object v8

    .line 232
    :cond_2d
    const-string v2, "DJ:"

    invoke-virtual {p1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-ltz v3, :cond_84

    .line 234
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_39
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_51

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    .line 235
    iget-boolean v4, v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->dj:Z

    if-eqz v4, :cond_39

    .line 247
    const-string v2, "richHook.djhit"

    const-string v3, "\u70b9\u6b4c\u6807\u8bb0\u5df2\u8ba4\u51fa \u2713"

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_84

    .line 241
    :cond_51
    invoke-virtual {p1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v2

    .line 242
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u770b\u5230 DJ: \u4f46\u6ca1\u5339\u914d\u4e0a\uff08\u62ec\u53f7\u5f62\u6001\uff1f\uff09\u9644\u8fd1\uff1a"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    add-int/lit8 v4, v2, -0x8

    .line 244
    invoke-static {v1, v4}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 245
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v5

    add-int/lit8 v2, v2, 0x28

    invoke-static {v5, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 244
    invoke-virtual {p1, v4, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    const-string v4, "\n"

    const-string v5, "\\n"

    .line 245
    invoke-virtual {v2, v4, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 242
    const-string v3, "richHook.djmiss"

    invoke-static {v3, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 252
    :cond_84
    :goto_84
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tplMap()Ljava/util/LinkedHashMap;

    move-result-object v9

    .line 254
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctInNew:Ljava/lang/reflect/Constructor;

    invoke-virtual {v2, v8}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 257
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v10

    move v0, v1

    move v4, v0

    :goto_94
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_e9

    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    move-object v11, v0

    check-cast v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    .line 258
    iget v0, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    if-le v0, v4, :cond_ae

    .line 259
    iget v5, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    move-object v3, p1

    move-object v1, v2

    move-object v2, p0

    invoke-static/range {v1 .. v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->emitPlain(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)Z

    goto :goto_b1

    :cond_ae
    move-object v3, p1

    move-object v1, v2

    move-object v2, p0

    .line 261
    :goto_b1
    iget-boolean p0, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->dj:Z

    if-eqz p0, :cond_cf

    .line 265
    :try_start_b5
    iget-object p0, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->djBody:Ljava/lang/String;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->handle(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_e2

    .line 266
    sget-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mAppendStr:Ljava/lang/reflect/Method;

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1, v1, p0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_c6
    .catchall {:try_start_b5 .. :try_end_c6} :catchall_c7

    goto :goto_e2

    :catchall_c7
    move-exception v0

    move-object p0, v0

    .line 268
    const-string p1, "richHook.dj"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_e2

    .line 271
    :cond_cf
    iget-boolean p0, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->suggest:Z

    if-eqz p0, :cond_d7

    .line 273
    invoke-static {v1, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->emitSuggest(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;)V

    goto :goto_e2

    .line 275
    :cond_d7
    iget-boolean p0, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->anonymous:Z

    if-eqz p0, :cond_df

    .line 276
    invoke-static {v1, v11, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->emitAnon(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;Ljava/lang/String;)V

    goto :goto_e2

    .line 279
    :cond_df
    invoke-static {v1, v11, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->emit(Ljava/lang/Object;Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;Ljava/util/LinkedHashMap;)V

    .line 282
    :cond_e2
    :goto_e2
    iget v4, v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    move-object p0, v2

    move-object p1, v3

    move v0, v7

    move-object v2, v1

    goto :goto_94

    :cond_e9
    move-object v3, p1

    move-object v1, v2

    move-object v2, p0

    .line 284
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result p0

    if-ge v4, p0, :cond_fd

    .line 285
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    invoke-static/range {v1 .. v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->emitPlain(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;IIZ)Z

    move-result p0

    if-eqz p0, :cond_fd

    goto :goto_fe

    :cond_fd
    move v7, v0

    :goto_fe
    if-nez v7, :cond_101

    return-object v8

    .line 291
    :cond_101
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mToKn:Ljava/lang/reflect/Method;

    invoke-virtual {p0, v1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private static selfCheckColor(Ljava/lang/Object;J)V
    .registers 7

    const-string v0, "\u81ea\u68c0 color want=0x"

    const-string v1, "richHook.chk."

    .line 586
    :try_start_4
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cSpan:Ljava/lang/Class;

    if-nez v2, :cond_9

    return-void

    .line 587
    :cond_9
    const-string v3, "a"

    invoke-virtual {v2, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    const/4 v3, 0x1

    .line 588
    invoke-virtual {v2, v3}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 589
    invoke-virtual {v2, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->unboxColor(Ljava/lang/Object;)J

    move-result-wide v2

    .line 590
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 591
    invoke-static {p1, p2}, Ljava/lang/Long;->toHexString(J)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " got=0x"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2, v3}, Ljava/lang/Long;->toHexString(J)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    cmp-long p1, p1, v2

    if-nez p1, :cond_46

    .line 592
    const-string p1, " \u2713 \u4e00\u81f4 \u21d2 \u95ee\u9898\u5728\u6e32\u67d3\u5c42"

    goto :goto_48

    :cond_46
    const-string p1, " \u2717 \u4e0d\u4e00\u81f4 \u21d2 \u6784\u9020\u6ca1\u8fdb\u53bb"

    :goto_48
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 590
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_52
    .catchall {:try_start_4 .. :try_end_52} :catchall_53

    return-void

    :catchall_53
    move-exception p0

    .line 594
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "\u81ea\u68c0\u5931\u8d25\uff1a"

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "richHook.chkfail"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static sig(Ljava/lang/reflect/Method;)Ljava/lang/String;
    .registers 5

    .line 771
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 772
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    :goto_d
    if-ge v2, v1, :cond_20

    aget-object v3, p0, v2

    invoke-virtual {v3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v3, 0x2c

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_d

    :cond_20
    const/16 p0, 0x29

    .line 773
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 22

    const-wide/16 v0, 0x0

    .line 698
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    if-nez p0, :cond_a

    move-wide v4, v0

    goto :goto_e

    .line 697
    :cond_a
    :try_start_a
    invoke-virtual/range {p0 .. p0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    :goto_e
    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    if-nez p1, :cond_15

    goto :goto_19

    .line 708
    :cond_15
    invoke-virtual/range {p1 .. p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    :goto_19
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v13

    if-eqz p0, :cond_22

    const/16 v0, 0x3ffe

    goto :goto_24

    :cond_22
    const/16 v0, 0x3fff

    :goto_24
    if-eqz p2, :cond_28

    and-int/lit8 v0, v0, -0x5

    :cond_28
    if-eqz p3, :cond_2c

    and-int/lit8 v0, v0, -0x9

    :cond_2c
    if-eqz p1, :cond_30

    and-int/lit16 v0, v0, -0x801

    :cond_30
    if-eqz p4, :cond_34

    and-int/lit16 v0, v0, -0x1001

    .line 717
    :cond_34
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v16

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v15, 0x0

    move-object v9, v3

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v14, p4

    filled-new-array/range {v2 .. v16}, [Ljava/lang/Object;

    move-result-object v0

    .line 719
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->ctSpan:Ljava/lang/reflect/Constructor;

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_50
    .catchall {:try_start_a .. :try_end_50} :catchall_51

    return-object v0

    :catchall_51
    move-exception v0

    .line 721
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "SpanStyle \u6784\u9020\u5931\u8d25\uff1as="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "richHook.spanFail"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static status()Ljava/lang/String;
    .registers 2

    .line 126
    new-instance v0, Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    if-eqz v1, :cond_9

    const-string v1, "\u5df2\u5c31\u7eea"

    goto :goto_b

    :cond_9
    const-string v1, "\u672a\u5c31\u7eea"

    :goto_b
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, " \u00b7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08\u6e32\u67d3 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sRenders:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6b21 / \u66ff\u6362 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sHits:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6b21\uff09 \u00b7 \u94fe\u63a5\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 128
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->status()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u00b7 \u53d1\u9001\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 129
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->status()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static strike()Ljava/lang/Object;
    .registers 3

    .line 649
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 650
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sStrike:Ljava/lang/Object;

    if-nez v1, :cond_13

    const/4 v1, 0x2

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->newDeco(I)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    invoke-static {v2, v2, v2, v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sStrike:Ljava/lang/Object;

    .line 651
    :cond_13
    monitor-exit v0

    return-object v1

    :catchall_15
    move-exception v1

    .line 652
    monitor-exit v0
    :try_end_17
    .catchall {:try_start_3 .. :try_end_17} :catchall_15

    throw v1
.end method

.method private static styleFor(Ljava/lang/String;)Ljava/lang/Object;
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_94

    .line 512
    :try_start_3
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_b

    goto/16 :goto_94

    .line 513
    :cond_b
    const-string v1, "b"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_18

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bold()Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 514
    :cond_18
    const-string v1, "i"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_25

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->italic()Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 515
    :cond_25
    const-string v1, "u"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_32

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->underline()Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 516
    :cond_32
    const-string v1, "s"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3f

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->strike()Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 517
    :cond_3f
    const-string v1, "bg"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_55

    const/4 v1, 0x2

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->colorOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->bgStyle(Ljava/lang/Long;)Ljava/lang/Object;

    move-result-object p0

    return-object p0

    :cond_55
    const/4 v1, 0x0

    .line 518
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x63

    if-ne v1, v2, :cond_94

    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->colorOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->colorStyle(Ljava/lang/Long;)Ljava/lang/Object;

    move-result-object p0
    :try_end_6b
    .catchall {:try_start_3 .. :try_end_6b} :catchall_6c

    return-object p0

    :catchall_6c
    move-exception v1

    .line 520
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "richHook.style."

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u6837\u5f0f\u6784\u9020\u5931\u8d25 tag="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u2192 "

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_94
    :goto_94
    return-object v0
.end method

.method private static unboxColor(Ljava/lang/Object;)J
    .registers 8

    const-wide/16 v0, -0x1

    if-nez p0, :cond_5

    return-wide v0

    .line 602
    :cond_5
    :try_start_5
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    const/4 v3, 0x0

    .line 603
    :goto_e
    array-length v4, v2

    if-ge v3, v4, :cond_34

    .line 604
    aget-object v4, v2, v3

    .line 605
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v5

    if-nez v5, :cond_31

    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    sget-object v6, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v5, v6, :cond_31

    const/4 v5, 0x0

    .line 606
    invoke-virtual {v4, p0, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 607
    instance-of v5, v4, Ljava/lang/Long;

    if-eqz v5, :cond_31

    check-cast v4, Ljava/lang/Long;

    invoke-virtual {v4}, Ljava/lang/Long;->longValue()J

    move-result-wide v0
    :try_end_30
    .catchall {:try_start_5 .. :try_end_30} :catchall_34

    return-wide v0

    :cond_31
    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    :catchall_34
    :cond_34
    return-wide v0
.end method

.method private static underline()Ljava/lang/Object;
    .registers 3

    .line 642
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 643
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sUline:Ljava/lang/Object;

    if-nez v1, :cond_13

    const/4 v1, 0x1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->newDeco(I)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    invoke-static {v2, v2, v2, v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->spanOf(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sUline:Ljava/lang/Object;

    .line 644
    :cond_13
    monitor-exit v0

    return-object v1

    :catchall_15
    move-exception v1

    .line 645
    monitor-exit v0
    :try_end_17
    .catchall {:try_start_3 .. :try_end_17} :catchall_15

    throw v1
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 9

    .line 137
    const-string p0, "DJ:"

    .line 0
    const-string v0, "\u5bcc\u6587\u672c\u5df2\u6e32\u67d3\uff1a\u539f\u6587 "

    const-string v1, "\u5feb\u901f\u95f8\u62e6\u4e0b\u4e86\u542b DJ \u7684\u6587\u672c\uff08hasDj \u6ca1\u8986\u76d6\u8fd9\u79cd\u5f62\u6001\uff1f\uff09\uff1a"

    .line 137
    :try_start_6
    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sReady:Z

    if-nez v2, :cond_c

    goto/16 :goto_c2

    .line 138
    :cond_c
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :cond_c2

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v2, v2

    const/4 v3, 0x1

    if-ge v2, v3, :cond_18

    goto/16 :goto_c2

    .line 140
    :cond_18
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v4, 0x0

    aget-object v2, v2, v4

    if-eqz v2, :cond_c2

    .line 141
    sget-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->cKn:Ljava/lang/Class;

    invoke-virtual {v5, v2}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_29

    goto/16 :goto_c2

    .line 143
    :cond_29
    sget-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->fText:Ljava/lang/reflect/Field;

    invoke-virtual {v5, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    if-eqz v5, :cond_c2

    .line 144
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_3b

    goto/16 :goto_c2

    .line 147
    :cond_3b
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->mayRender(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_79

    .line 149
    invoke-virtual {v5, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p1

    if-ltz p1, :cond_c2

    .line 150
    invoke-virtual {v5, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    .line 151
    const-string p1, "richHook.djgate"

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    add-int/lit8 v1, p0, -0xa

    .line 153
    invoke-static {v4, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 154
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v2

    add-int/lit8 p0, p0, 0x28

    invoke-static {v2, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    .line 153
    invoke-virtual {v5, v1, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    const-string v1, "\n"

    const-string v2, "\\n"

    .line 154
    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 151
    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 158
    :cond_79
    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sRenders:I

    add-int/2addr p0, v3

    sput p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sRenders:I

    .line 160
    invoke-static {v2, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->rebuild(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_c2

    .line 162
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aput-object p0, p1, v4

    .line 163
    sget p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sHits:I

    add-int/2addr p1, v3

    sput p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->sHits:I

    .line 164
    const-string p1, "richHook.hit"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 165
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\u7b26 \u2192 \u66ff\u6362\u540e "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->fText:Ljava/lang/reflect/Field;

    .line 166
    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5b57\u7b26"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 164
    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_bb
    .catchall {:try_start_6 .. :try_end_bb} :catchall_bc

    return-void

    :catchall_bc
    move-exception p0

    .line 171
    :try_start_bd
    const-string p1, "richHook"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_c2
    .catchall {:try_start_bd .. :try_end_c2} :catchall_c2

    :catchall_c2
    :cond_c2
    :goto_c2
    return-void
.end method

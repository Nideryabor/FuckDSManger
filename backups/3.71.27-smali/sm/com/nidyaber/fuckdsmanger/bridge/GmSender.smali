.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmSender;
.super Ljava/lang/Object;
.source "GmSender.java"


# static fields
.field private static final CAND_GH2:[Ljava/lang/String;

.field private static final CAND_M1A:[Ljava/lang/String;

.field private static final CAND_NS:[Ljava/lang/String;

.field private static final M_NS:Ljava/lang/String; = "Y"

.field private static final M_SEND:Ljava/lang/String; = "j0"

.field private static final RECENT_TTL:J = 0x3a98L

.field private static cGh2:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cM1a:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cNs:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctM1a:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static fMsgs:Ljava/lang/reflect/Field;

.field private static fSid:Ljava/lang/reflect/Field;

.field private static mNs:Ljava/lang/reflect/Method;

.field private static mSend:Ljava/lang/reflect/Method;

.field private static final sInst:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/ref/WeakReference<",
            "Ljava/lang/Object;",
            ">;>;"
        }
    .end annotation
.end field

.field private static volatile sReady:Z

.field private static volatile sRecent:Ljava/lang/Object;

.field private static volatile sRecentAt:J

.field private static volatile sSent:I

.field private static volatile sTried:Z

.field private static volatile sWhy:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 60
    const-string v0, "ao1"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_GH2:[Ljava/lang/String;

    .line 62
    const-string v0, "ns"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_NS:[Ljava/lang/String;

    .line 64
    const-string v0, "u7a"

    const-string v1, "f4a"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_M1A:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 87
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sTried:Z

    .line 88
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    .line 89
    const-string v1, "\u672a\u521d\u59cb\u5316"

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    .line 90
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    .line 93
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;

    const/4 v0, 0x0

    .line 105
    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecent:Ljava/lang/Object;

    const-wide/16 v0, 0x0

    .line 107
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecentAt:J

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 111
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Ljava/util/ArrayList;
    .registers 1

    .line 55
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;

    return-object v0
.end method

.method static synthetic access$102(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 1

    .line 55
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecent:Ljava/lang/Object;

    return-object p0
.end method

.method static synthetic access$202(J)J
    .registers 2

    .line 55
    sput-wide p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecentAt:J

    return-wide p0
.end method

.method private static bail(Ljava/lang/String;)Z
    .registers 1

    .line 189
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    const/4 p0, 0x0

    return p0
.end method

.method private static hasSession(Ljava/lang/Object;)Z
    .registers 4

    const/4 v0, 0x0

    .line 334
    :try_start_1
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    const/4 v2, 0x0

    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_b

    return v0

    .line 336
    :cond_b
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fSid:Ljava/lang/reflect/Field;

    invoke-virtual {v1, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-eqz p0, :cond_1d

    .line 337
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0
    :try_end_19
    .catchall {:try_start_1 .. :try_end_19} :catchall_1d

    if-lez p0, :cond_1d

    const/4 p0, 0x1

    return p0

    :catchall_1d
    :cond_1d
    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 6

    .line 214
    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    if-nez p0, :cond_5

    goto :goto_59

    .line 217
    :cond_5
    :try_start_5
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cGh2:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_e
    if-ge v1, v0, :cond_23

    aget-object v3, p0, v1
    :try_end_12
    .catchall {:try_start_5 .. :try_end_12} :catchall_3d

    const/4 v4, 0x1

    .line 219
    :try_start_13
    invoke-virtual {v3, v4}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 220
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmSender$1;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender$1;-><init>()V

    invoke-static {v3, v4}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_1e
    .catchall {:try_start_13 .. :try_end_1e} :catchall_20

    add-int/lit8 v2, v2, 0x1

    :catchall_20
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    .line 251
    :cond_23
    :try_start_23
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "gmSender \u5df2\u6302 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a gh2 \u6784\u9020\u5668\uff08\u6536\u96c6\u5b9e\u4f8b\u7528\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_3c
    .catchall {:try_start_23 .. :try_end_3c} :catchall_3d

    goto :goto_43

    :catchall_3d
    move-exception p0

    .line 253
    const-string v0, "gmSender.install"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 259
    :goto_43
    :try_start_43
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender$2;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender$2;-><init>()V

    invoke-static {p0, v0}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 273
    const-string p0, "gmSender \u5df2\u6302 gh2.W()\uff08\u6700\u8fd1\u6d3b\u8dc3\u6807\u8bb0 \u21d2 \u53d1\u9001\u6c38\u4e0d\u9009\u9519\u4f1a\u8bdd\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_52
    .catchall {:try_start_43 .. :try_end_52} :catchall_53

    goto :goto_59

    :catchall_53
    move-exception p0

    .line 275
    const-string v0, "gmSender.install/W"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_59
    return-void
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

    .line 194
    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    :goto_3
    if-ge v2, v0, :cond_15

    aget-object v3, p1, v2

    .line 196
    :try_start_7
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v1, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3
    :try_end_f
    .catchall {:try_start_7 .. :try_end_f} :catchall_12

    if-eqz v3, :cond_12

    return-object v3

    :catchall_12
    :cond_12
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    :cond_15
    const/4 p0, 0x0

    return-object p0
.end method

.method private static pickCurrent()Ljava/lang/Object;
    .registers 8

    .line 292
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 295
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecent:Ljava/lang/Object;

    if-eqz v2, :cond_18

    .line 296
    sget-wide v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecentAt:J

    sub-long/2addr v0, v3

    const-wide/16 v3, 0x3a98

    cmp-long v0, v0, v3

    if-gez v0, :cond_18

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->hasSession(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_18

    return-object v2

    .line 303
    :cond_18
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;

    monitor-enter v0

    .line 304
    :try_start_1b
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, 0x0

    const/4 v3, -0x1

    move-object v4, v2

    .line 305
    :catchall_22
    :cond_22
    :goto_22
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_67

    .line 306
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/ref/WeakReference;

    invoke-virtual {v5}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v5

    if-nez v5, :cond_38

    .line 307
    invoke-interface {v1}, Ljava/util/Iterator;->remove()V
    :try_end_37
    .catchall {:try_start_1b .. :try_end_37} :catchall_72

    goto :goto_22

    .line 309
    :cond_38
    :try_start_38
    sget-object v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    invoke-virtual {v6, v5, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    if-nez v6, :cond_41

    goto :goto_22

    .line 311
    :cond_41
    sget-object v7, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fSid:Ljava/lang/reflect/Field;

    invoke-virtual {v7, v6}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    if-eqz v7, :cond_22

    .line 312
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    if-nez v7, :cond_52

    goto :goto_22

    .line 313
    :cond_52
    sget-object v7, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fMsgs:Ljava/lang/reflect/Field;

    invoke-virtual {v7, v6}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/util/Map;

    if-nez v6, :cond_5e

    const/4 v6, 0x0

    goto :goto_62

    .line 314
    :cond_5e
    invoke-interface {v6}, Ljava/util/Map;->size()I

    move-result v6
    :try_end_62
    .catchall {:try_start_38 .. :try_end_62} :catchall_22

    :goto_62
    if-le v6, v3, :cond_22

    move-object v4, v5

    move v3, v6

    goto :goto_22

    .line 323
    :cond_67
    :try_start_67
    monitor-exit v0
    :try_end_68
    .catchall {:try_start_67 .. :try_end_68} :catchall_72

    if-eqz v4, :cond_71

    .line 325
    const-string v0, "gmSender.pick.fallback"

    const-string v1, "[\u53d1\u9001] \u26a0 \u6700\u8fd1\u6d3b\u8dc3\u4e0d\u53ef\u7528\uff0c\u56de\u9000\u5230\u300c\u6d88\u606f\u6570\u6700\u591a\u300d\u7684\u4f1a\u8bdd \u2014\u2014 \u53ef\u80fd\u4e0d\u51c6\uff0c\u8bf7\u7559\u610f"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_71
    return-object v4

    :catchall_72
    move-exception v1

    .line 323
    :try_start_73
    monitor-exit v0
    :try_end_74
    .catchall {:try_start_73 .. :try_end_74} :catchall_72

    throw v1
.end method

.method public static prepare(Ljava/lang/ClassLoader;)Z
    .registers 11

    .line 125
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sTried:Z

    if-eqz v0, :cond_7

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    return p0

    .line 126
    :cond_7
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;

    monitor-enter v0

    .line 127
    :try_start_a
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sTried:Z

    if-eqz v1, :cond_12

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    monitor-exit v0

    return p0

    :cond_12
    const/4 v1, 0x1

    .line 128
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sTried:Z
    :try_end_15
    .catchall {:try_start_a .. :try_end_15} :catchall_178

    const/4 v2, 0x0

    .line 130
    :try_start_16
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_GH2:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cGh2:Ljava/lang/Class;

    .line 131
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_NS:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cNs:Ljava/lang/Class;

    .line 132
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->CAND_M1A:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cM1a:Ljava/lang/Class;

    .line 133
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cGh2:Ljava/lang/Class;

    if-nez v3, :cond_3a

    const-string p0, "\u4f1a\u8bdd\u7ec4\u4ef6(gh2) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_38
    .catchall {:try_start_16 .. :try_end_38} :catchall_15b

    :try_start_38
    monitor-exit v0
    :try_end_39
    .catchall {:try_start_38 .. :try_end_39} :catchall_178

    return p0

    .line 134
    :cond_3a
    :try_start_3a
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cNs:Ljava/lang/Class;

    if-nez v4, :cond_46

    const-string p0, "\u6d88\u606f\u5b58\u50a8(ns) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_44
    .catchall {:try_start_3a .. :try_end_44} :catchall_15b

    :try_start_44
    monitor-exit v0
    :try_end_45
    .catchall {:try_start_44 .. :try_end_45} :catchall_178

    return p0

    :cond_46
    if-nez p0, :cond_50

    .line 135
    :try_start_48
    const-string p0, "m1a \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_4e
    .catchall {:try_start_48 .. :try_end_4e} :catchall_15b

    :try_start_4e
    monitor-exit v0
    :try_end_4f
    .catchall {:try_start_4e .. :try_end_4f} :catchall_178

    return p0

    .line 138
    :cond_50
    :try_start_50
    const-string p0, "Y"

    new-array v4, v2, [Ljava/lang/Class;

    const/4 v4, 0x0

    invoke-virtual {v3, p0, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    .line 139
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 140
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object p0

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cNs:Ljava/lang/Class;

    if-eq p0, v3, :cond_70

    const-string p0, "gh2.W() \u8fd4\u56de\u7684\u4e0d\u662f ns"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_6e
    .catchall {:try_start_50 .. :try_end_6e} :catchall_15b

    :try_start_6e
    monitor-exit v0
    :try_end_6f
    .catchall {:try_start_6e .. :try_end_6f} :catchall_178

    return p0

    .line 143
    :cond_70
    :try_start_70
    const-string p0, "a"

    invoke-virtual {v3, p0}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fSid:Ljava/lang/reflect/Field;

    .line 144
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 145
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fSid:Ljava/lang/reflect/Field;

    invoke-virtual {p0}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object p0

    const-class v3, Ljava/lang/String;

    if-eq p0, v3, :cond_8d

    const-string p0, "ns.a \u4e0d\u662f String"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_8b
    .catchall {:try_start_70 .. :try_end_8b} :catchall_15b

    :try_start_8b
    monitor-exit v0
    :try_end_8c
    .catchall {:try_start_8b .. :try_end_8c} :catchall_178

    return p0

    .line 146
    :cond_8d
    :try_start_8d
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cNs:Ljava/lang/Class;

    const-string v3, "f"

    invoke-virtual {p0, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fMsgs:Ljava/lang/reflect/Field;

    .line 147
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 148
    const-class p0, Ljava/util/Map;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fMsgs:Ljava/lang/reflect/Field;

    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {p0, v3}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result p0

    if-nez p0, :cond_b0

    const-string p0, "ns.f \u4e0d\u662f Map"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_ae
    .catchall {:try_start_8d .. :try_end_ae} :catchall_15b

    :try_start_ae
    monitor-exit v0
    :try_end_af
    .catchall {:try_start_ae .. :try_end_af} :catchall_178

    return p0

    .line 151
    :cond_b0
    :try_start_b0
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cM1a:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v3, p0

    move v4, v2

    :goto_b8
    const/4 v5, 0x2

    if-ge v4, v3, :cond_d6

    aget-object v6, p0, v4

    .line 152
    invoke-virtual {v6}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    .line 153
    array-length v8, v7

    if-ne v8, v5, :cond_d3

    aget-object v8, v7, v2

    sget-object v9, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v8, v9, :cond_d3

    aget-object v7, v7, v1

    const-class v8, Ljava/lang/String;

    if-ne v7, v8, :cond_d3

    .line 154
    sput-object v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->ctM1a:Ljava/lang/reflect/Constructor;

    goto :goto_d6

    :cond_d3
    add-int/lit8 v4, v4, 0x1

    goto :goto_b8

    .line 158
    :cond_d6
    :goto_d6
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->ctM1a:Ljava/lang/reflect/Constructor;

    if-nez p0, :cond_e2

    const-string p0, "m1a(long,String) \u6784\u9020\u5668\u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_e0
    .catchall {:try_start_b0 .. :try_end_e0} :catchall_15b

    :try_start_e0
    monitor-exit v0
    :try_end_e1
    .catchall {:try_start_e0 .. :try_end_e1} :catchall_178

    return p0

    .line 159
    :cond_e2
    :try_start_e2
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    const/16 p0, 0xb

    .line 162
    new-array p0, p0, [Ljava/lang/Class;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cGh2:Ljava/lang/Class;

    aput-object v3, p0, v2

    const-class v3, Ljava/lang/String;

    aput-object v3, p0, v1

    const-class v4, Ljava/util/List;

    aput-object v4, p0, v5

    const/4 v5, 0x3

    aput-object v4, p0, v5

    const/4 v4, 0x4

    aput-object v3, p0, v4

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cM1a:Ljava/lang/Class;

    const/4 v4, 0x5

    aput-object v3, p0, v4

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cNs:Ljava/lang/Class;

    const/4 v4, 0x6

    aput-object v3, p0, v4

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/4 v4, 0x7

    aput-object v3, p0, v4

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v4, 0x8

    aput-object v3, p0, v4

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v4, 0x9

    aput-object v3, p0, v4

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v4, 0xa

    aput-object v3, p0, v4

    .line 167
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->cGh2:Ljava/lang/Class;

    const-string v4, "j0"

    invoke-virtual {v3, v4, p0}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mSend:Ljava/lang/reflect/Method;

    .line 168
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 169
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mSend:Ljava/lang/reflect/Method;

    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result p0

    invoke-static {p0}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result p0

    if-nez p0, :cond_13d

    const-string p0, "h0 \u4e0d\u662f\u9759\u6001\u65b9\u6cd5\uff08\u7b7e\u540d\u53d8\u4e86\uff1f\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_13b
    .catchall {:try_start_e2 .. :try_end_13b} :catchall_15b

    :try_start_13b
    monitor-exit v0
    :try_end_13c
    .catchall {:try_start_13b .. :try_end_13c} :catchall_178

    return p0

    .line 171
    :cond_13d
    :try_start_13d
    const-string p0, "\u81ea\u68c0\u5168\u8fc7\uff08gh2.W()/ns.a/ns.f/m1a/h0\uff09"

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    .line 172
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    .line 173
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "gmSender \u81ea\u68c0 OK\uff1a"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_159
    .catchall {:try_start_13d .. :try_end_159} :catchall_15b

    .line 174
    :try_start_159
    monitor-exit v0
    :try_end_15a
    .catchall {:try_start_159 .. :try_end_15a} :catchall_178

    return v1

    :catchall_15b
    move-exception p0

    .line 177
    :try_start_15c
    const-string v1, "gmSender.prepare"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_161
    .catchall {:try_start_15c .. :try_end_161} :catchall_161

    .line 181
    :catchall_161
    :try_start_161
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u81ea\u68c0\u629b\u5f02\u5e38\uff1a"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    .line 182
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    .line 183
    monitor-exit v0

    return v2

    :catchall_178
    move-exception p0

    .line 185
    monitor-exit v0
    :try_end_17a
    .catchall {:try_start_161 .. :try_end_17a} :catchall_178

    throw p0
.end method

.method public static ready()Z
    .registers 1

    .line 113
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    return v0
.end method

.method public static send(Ljava/lang/String;)Z
    .registers 17

    const-string v11, "[\u53d1\u9001] \u2605 \u5df2\u53d1\u5230\u4f1a\u8bdd "

    const-string v0, "\u6ca1\u627e\u5230\u300c\u5e26\u4f1a\u8bdd\u300d\u7684 gh2 \u5b9e\u4f8b\uff08\u5b9e\u4f8b\u8868 "

    .line 350
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    const/4 v12, 0x0

    if-nez v1, :cond_24

    .line 351
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u53d1\u9001\u4e0d\u53ef\u7528\uff08"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "gmSender.notReady"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return v12

    :cond_24
    if-eqz p0, :cond_ce

    .line 354
    invoke-virtual/range {p0 .. p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2e

    goto/16 :goto_ce

    .line 357
    :cond_2e
    :try_start_2e
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->pickCurrent()Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_51

    .line 359
    const-string v1, "gmSender.noSession"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;

    .line 360
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a\uff09\u2014\u2014 \u8bf7\u5148\u8fdb\u4e00\u4e2a\u4f1a\u8bdd"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 359
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return v12

    .line 363
    :cond_51
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mNs:Ljava/lang/reflect/Method;

    const/4 v13, 0x0

    invoke-virtual {v0, v1, v13}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    .line 364
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->fSid:Ljava/lang/reflect/Field;

    invoke-virtual {v0, v6}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    move-object v14, v0

    check-cast v14, Ljava/lang/String;

    .line 367
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->ctM1a:Ljava/lang/reflect/Constructor;

    .line 368
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    .line 369
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v3

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object v2

    .line 367
    invoke-virtual {v0, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 371
    sget-object v15, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->mSend:Ljava/lang/reflect/Method;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    const-string v4, ""

    sget-object v7, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    sget-object v8, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    sget-object v9, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    sget-object v10, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    move-object v0, v1

    move-object/from16 v1, p0

    filled-new-array/range {v0 .. v10}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {v15, v13, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 376
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    const/4 v2, 0x1

    add-int/2addr v0, v2

    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    .line 377
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\uff1a\u300c"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\u300d\uff08\u7b2c "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6761\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_c7
    .catchall {:try_start_2e .. :try_end_c7} :catchall_c8

    return v2

    :catchall_c8
    move-exception v0

    .line 380
    const-string v1, "[\u53d1\u9001] \u5931\u8d25"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_ce
    :goto_ce
    return v12
.end method

.method public static sent()I
    .registers 1

    .line 115
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    return v0
.end method

.method public static status()Ljava/lang/String;
    .registers 2

    .line 118
    new-instance v0, Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sReady:Z

    if-eqz v1, :cond_9

    const-string v1, "\u5df2\u5c31\u7eea"

    goto :goto_b

    :cond_9
    const-string v1, "\u672a\u5c31\u7eea"

    :goto_b
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, " \u00b7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08\u5b9e\u4f8b "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;

    .line 119
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a / \u5df2\u53d1 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sSent:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6761\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static why()Ljava/lang/String;
    .registers 1

    .line 114
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sWhy:Ljava/lang/String;

    return-object v0
.end method

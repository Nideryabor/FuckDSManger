.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;
.super Ljava/lang/Object;
.source "GmRichLink.java"


# static fields
.field private static final CAND_CLA:[Ljava/lang/String;

.field private static final CAND_IN:[Ljava/lang/String;

.field private static final CAND_RI6:[Ljava/lang/String;

.field private static final CAND_SI6:[Ljava/lang/String;

.field private static final CAND_TI6:[Ljava/lang/String;

.field private static cCla:Ljava/lang/Class;
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

.field private static cRi6:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cSi6:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static cTi6:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctCla:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static ctRi6:Ljava/lang/reflect/Constructor;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/reflect/Constructor<",
            "*>;"
        }
    .end annotation
.end field

.field private static mAppendStr:Ljava/lang/reflect/Method;

.field private static mPop:Ljava/lang/reflect/Method;

.field private static mPushLink:Ljava/lang/reflect/Method;

.field private static volatile sLinks:I

.field private static volatile sReady:Z

.field private static volatile sTried:Z

.field private static volatile sWhy:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 58
    const-string v0, "kn"

    const-string v1, "jn"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_IN:[Ljava/lang/String;

    .line 66
    const-string v0, "gm6"

    const-string v1, "yi6"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_SI6:[Ljava/lang/String;

    .line 69
    const-string v0, "wi6"

    const-string v1, "xi6"

    const-string v2, "em6"

    filled-new-array {v2, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_RI6:[Ljava/lang/String;

    .line 71
    const-string v0, "tra"

    const-string v1, "vna"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_CLA:[Ljava/lang/String;

    .line 75
    const-string v0, "hm6"

    const-string v1, "zi6"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_TI6:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 94
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sTried:Z

    .line 95
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    .line 96
    const-string v1, "\u672a\u521d\u59cb\u5316"

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    .line 97
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sLinks:I

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 99
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static bail(Ljava/lang/String;)Z
    .registers 1

    .line 201
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    const/4 p0, 0x0

    return p0
.end method

.method public static emitLink(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 243
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    if-eqz v0, :cond_34

    if-nez p0, :cond_7

    return-void

    :cond_7
    if-eqz p2, :cond_f

    .line 245
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_11

    :cond_f
    const-string p2, "\u25b8"

    .line 246
    :cond_11
    invoke-static {p1, p2, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->newLink(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    .line 247
    sget-object p3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mPushLink:Ljava/lang/reflect/Method;

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {p3, p0, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 248
    sget-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mAppendStr:Ljava/lang/reflect/Method;

    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p1, p0, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 249
    sget-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mPop:Ljava/lang/reflect/Method;

    const/4 p2, 0x0

    invoke-virtual {p1, p0, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 250
    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sLinks:I

    add-int/lit8 p0, p0, 0x1

    sput p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sLinks:I

    return-void

    .line 243
    :cond_34
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "richLink \u672a\u5c31\u7eea\uff1a"

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
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

    .line 206
    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    :goto_3
    if-ge v2, v0, :cond_11

    aget-object v3, p1, v2

    .line 208
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

.method private static newLink(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-eqz p0, :cond_8

    .line 262
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_a

    :cond_8
    const-string p0, "fdm_sug"

    .line 264
    :cond_a
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;

    invoke-direct {v0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 290
    sget-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cTi6:Ljava/lang/Class;

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object p1

    const/4 p2, 0x1

    new-array p2, p2, [Ljava/lang/Class;

    const/4 v1, 0x0

    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cTi6:Ljava/lang/Class;

    aput-object v2, p2, v1

    invoke-static {p1, p2, v0}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p1

    .line 294
    sget-object p2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctCla:Ljava/lang/reflect/Constructor;

    const/4 v0, 0x0

    filled-new-array {v0, v0, v0, v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    .line 296
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctRi6:Ljava/lang/reflect/Constructor;

    filled-new-array {p0, p2, p1}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

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

    .line 219
    :try_start_0
    invoke-virtual {p0, p1, p2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    const/4 p1, 0x1

    .line 220
    invoke-virtual {p0, p1}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_9

    return-object p0

    :catchall_9
    const/4 p0, 0x0

    return-object p0
.end method

.method public static prepare(Ljava/lang/ClassLoader;)Z
    .registers 10

    .line 124
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sTried:Z

    if-eqz v0, :cond_7

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    return p0

    .line 125
    :cond_7
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;

    monitor-enter v0

    .line 126
    :try_start_a
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sTried:Z

    if-eqz v1, :cond_12

    sget-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    monitor-exit v0

    return p0

    :cond_12
    const/4 v1, 0x1

    .line 127
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sTried:Z
    :try_end_15
    .catchall {:try_start_a .. :try_end_15} :catchall_1aa

    const/4 v2, 0x0

    .line 129
    :try_start_16
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_IN:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cIn:Ljava/lang/Class;

    .line 130
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_SI6:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cSi6:Ljava/lang/Class;

    .line 131
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_RI6:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cRi6:Ljava/lang/Class;

    .line 132
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_CLA:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cCla:Ljava/lang/Class;

    .line 133
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->CAND_TI6:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->load(Ljava/lang/ClassLoader;[Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cTi6:Ljava/lang/Class;

    .line 135
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cIn:Ljava/lang/Class;

    if-nez v3, :cond_4a

    const-string p0, "Builder(in) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_48
    .catchall {:try_start_16 .. :try_end_48} :catchall_18d

    :try_start_48
    monitor-exit v0
    :try_end_49
    .catchall {:try_start_48 .. :try_end_49} :catchall_1aa

    return p0

    .line 136
    :cond_4a
    :try_start_4a
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cSi6:Ljava/lang/Class;

    if-nez v3, :cond_56

    const-string p0, "LinkAnnotation(si6) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_54
    .catchall {:try_start_4a .. :try_end_54} :catchall_18d

    :try_start_54
    monitor-exit v0
    :try_end_55
    .catchall {:try_start_54 .. :try_end_55} :catchall_1aa

    return p0

    .line 137
    :cond_56
    :try_start_56
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cRi6:Ljava/lang/Class;

    if-nez v4, :cond_62

    const-string p0, "LinkAnnotation.Clickable(ri6) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_60
    .catchall {:try_start_56 .. :try_end_60} :catchall_18d

    :try_start_60
    monitor-exit v0
    :try_end_61
    .catchall {:try_start_60 .. :try_end_61} :catchall_1aa

    return p0

    .line 138
    :cond_62
    :try_start_62
    sget-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cCla:Ljava/lang/Class;

    if-nez v5, :cond_6e

    const-string p0, "TextLinkStyles(cla) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_6c
    .catchall {:try_start_62 .. :try_end_6c} :catchall_18d

    :try_start_6c
    monitor-exit v0
    :try_end_6d
    .catchall {:try_start_6c .. :try_end_6d} :catchall_1aa

    return p0

    :cond_6e
    if-nez p0, :cond_78

    .line 139
    :try_start_70
    const-string p0, "LinkInteractionListener(ti6) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_76
    .catchall {:try_start_70 .. :try_end_76} :catchall_18d

    :try_start_76
    monitor-exit v0
    :try_end_77
    .catchall {:try_start_76 .. :try_end_77} :catchall_1aa

    return p0

    .line 142
    :cond_78
    :try_start_78
    invoke-virtual {v3, v4}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result p0

    if-nez p0, :cond_86

    const-string p0, "ri6 \u4e0d\u662f si6 \u7684\u5b50\u7c7b\uff08\u4e0d\u50cf Clickable\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_84
    .catchall {:try_start_78 .. :try_end_84} :catchall_18d

    :try_start_84
    monitor-exit v0
    :try_end_85
    .catchall {:try_start_84 .. :try_end_85} :catchall_1aa

    return p0

    .line 143
    :cond_86
    :try_start_86
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cTi6:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->isInterface()Z

    move-result p0

    if-nez p0, :cond_96

    const-string p0, "ti6 \u4e0d\u662f\u63a5\u53e3\uff08\u6ca1\u6cd5\u52a8\u6001\u4ee3\u7406\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_94
    .catchall {:try_start_86 .. :try_end_94} :catchall_18d

    :try_start_94
    monitor-exit v0
    :try_end_95
    .catchall {:try_start_94 .. :try_end_95} :catchall_1aa

    return p0

    .line 146
    :cond_96
    :try_start_96
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cRi6:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v3, p0

    move v4, v2

    :goto_9e
    if-ge v4, v3, :cond_c3

    aget-object v5, p0, v4

    .line 147
    invoke-virtual {v5}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    .line 148
    array-length v7, v6

    const/4 v8, 0x3

    if-ne v7, v8, :cond_c0

    aget-object v7, v6, v2

    const-class v8, Ljava/lang/String;

    if-ne v7, v8, :cond_c0

    aget-object v7, v6, v1

    sget-object v8, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cCla:Ljava/lang/Class;

    if-ne v7, v8, :cond_c0

    const/4 v7, 0x2

    aget-object v6, v6, v7

    sget-object v7, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cTi6:Ljava/lang/Class;

    if-ne v6, v7, :cond_c0

    .line 149
    sput-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctRi6:Ljava/lang/reflect/Constructor;

    goto :goto_c3

    :cond_c0
    add-int/lit8 v4, v4, 0x1

    goto :goto_9e

    .line 153
    :cond_c3
    :goto_c3
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctRi6:Ljava/lang/reflect/Constructor;

    if-nez p0, :cond_cf

    const-string p0, "ri6 \u7684 (String,cla,ti6) \u6784\u9020\u5668\u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_cd
    .catchall {:try_start_96 .. :try_end_cd} :catchall_18d

    :try_start_cd
    monitor-exit v0
    :try_end_ce
    .catchall {:try_start_cd .. :try_end_ce} :catchall_1aa

    return p0

    .line 154
    :cond_cf
    :try_start_cf
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 157
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cCla:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v3, p0

    move v4, v2

    :goto_da
    if-ge v4, v3, :cond_eb

    aget-object v5, p0, v4

    .line 158
    invoke-virtual {v5}, Ljava/lang/reflect/Constructor;->getParameterCount()I

    move-result v6

    const/4 v7, 0x4

    if-ne v6, v7, :cond_e8

    .line 159
    sput-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctCla:Ljava/lang/reflect/Constructor;

    goto :goto_eb

    :cond_e8
    add-int/lit8 v4, v4, 0x1

    goto :goto_da

    .line 163
    :cond_eb
    :goto_eb
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->ctCla:Ljava/lang/reflect/Constructor;

    if-nez p0, :cond_f7

    const-string p0, "cla \u7684 4 \u53c2\u6784\u9020\u5668\u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_f5
    .catchall {:try_start_cf .. :try_end_f5} :catchall_18d

    :try_start_f5
    monitor-exit v0
    :try_end_f6
    .catchall {:try_start_f5 .. :try_end_f6} :catchall_1aa

    return p0

    .line 164
    :cond_f7
    :try_start_f7
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 167
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cIn:Ljava/lang/Class;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v3, p0

    move v4, v2

    :goto_102
    if-ge v4, v3, :cond_12e

    aget-object v5, p0, v4

    .line 168
    const-string v6, "h"

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_113

    goto :goto_12b

    .line 169
    :cond_113
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    .line 170
    array-length v7, v6

    if-ne v7, v1, :cond_12b

    aget-object v6, v6, v2

    sget-object v7, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cSi6:Ljava/lang/Class;

    if-ne v6, v7, :cond_12b

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v6, v7, :cond_12b

    .line 171
    sput-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mPushLink:Ljava/lang/reflect/Method;

    goto :goto_12e

    :cond_12b
    :goto_12b
    add-int/lit8 v4, v4, 0x1

    goto :goto_102

    .line 175
    :cond_12e
    :goto_12e
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mPushLink:Ljava/lang/reflect/Method;

    if-nez p0, :cond_13a

    const-string p0, "Builder.h(si6)I\uff08pushLink\uff09\u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_138
    .catchall {:try_start_f7 .. :try_end_138} :catchall_18d

    :try_start_138
    monitor-exit v0
    :try_end_139
    .catchall {:try_start_138 .. :try_end_139} :catchall_1aa

    return p0

    .line 176
    :cond_13a
    :try_start_13a
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 178
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cIn:Ljava/lang/Class;

    const-string v3, "e"

    new-array v4, v1, [Ljava/lang/Class;

    const-class v5, Ljava/lang/String;

    aput-object v5, v4, v2

    invoke-static {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mAppendStr:Ljava/lang/reflect/Method;

    .line 179
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->cIn:Ljava/lang/Class;

    const-string v3, "f"

    new-array v4, v2, [Ljava/lang/Class;

    invoke-static {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->pick(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mPop:Ljava/lang/reflect/Method;

    .line 180
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->mAppendStr:Ljava/lang/reflect/Method;

    if-nez v3, :cond_165

    const-string p0, "Builder.e(String) \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_163
    .catchall {:try_start_13a .. :try_end_163} :catchall_18d

    :try_start_163
    monitor-exit v0
    :try_end_164
    .catchall {:try_start_163 .. :try_end_164} :catchall_1aa

    return p0

    :cond_165
    if-nez p0, :cond_16f

    .line 181
    :try_start_167
    const-string p0, "Builder.f()\uff08pop\uff09\u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->bail(Ljava/lang/String;)Z

    move-result p0
    :try_end_16d
    .catchall {:try_start_167 .. :try_end_16d} :catchall_18d

    :try_start_16d
    monitor-exit v0
    :try_end_16e
    .catchall {:try_start_16d .. :try_end_16e} :catchall_1aa

    return p0

    .line 183
    :cond_16f
    :try_start_16f
    const-string p0, "\u81ea\u68c0\u5168\u8fc7\uff08in/si6/ri6/cla/ti6\uff09"

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    .line 184
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    .line 185
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "richLink \u81ea\u68c0 OK\uff1a"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_18b
    .catchall {:try_start_16f .. :try_end_18b} :catchall_18d

    .line 186
    :try_start_18b
    monitor-exit v0
    :try_end_18c
    .catchall {:try_start_18b .. :try_end_18c} :catchall_1aa

    return v1

    :catchall_18d
    move-exception p0

    .line 189
    :try_start_18e
    const-string v1, "richLink.prepare"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_193
    .catchall {:try_start_18e .. :try_end_193} :catchall_193

    .line 193
    :catchall_193
    :try_start_193
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u81ea\u68c0\u629b\u5f02\u5e38\uff1a"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    .line 194
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    .line 195
    monitor-exit v0

    return v2

    :catchall_1aa
    move-exception p0

    .line 197
    monitor-exit v0
    :try_end_1ac
    .catchall {:try_start_193 .. :try_end_1ac} :catchall_1aa

    throw p0
.end method

.method public static ready()Z
    .registers 1

    .line 103
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    return v0
.end method

.method public static status()Ljava/lang/String;
    .registers 2

    .line 113
    new-instance v0, Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sReady:Z

    if-eqz v1, :cond_9

    const-string v1, "\u5df2\u5c31\u7eea"

    goto :goto_b

    :cond_9
    const-string v1, "\u672a\u5c31\u7eea"

    :goto_b
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, " \u00b7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08\u5df2\u51fa "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sLinks:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a\u53ef\u70b9\u51fb\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static why()Ljava/lang/String;
    .registers 1

    .line 108
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->sWhy:Ljava/lang/String;

    return-object v0
.end method

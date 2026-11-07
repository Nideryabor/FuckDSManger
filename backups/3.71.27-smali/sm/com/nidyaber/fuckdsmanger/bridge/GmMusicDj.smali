.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;
.super Ljava/lang/Object;
.source "GmMusicDj.java"


# static fields
.field private static final API_COOLDOWN_MS:J = 0x4e20L

.field private static final DEDUP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private static final DEDUP_LOCK:Ljava/lang/Object;

.field private static final DEDUP_MS:J = 0x3a98L

.field private static final FLAG_HIDDEN:Ljava/lang/String; = "hidden"

.field public static final K_OFF:Ljava/lang/String; = "fuckds_dj_off"

.field private static volatile sApiErrAt:J


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 73
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->DEDUP_LOCK:Ljava/lang/Object;

    .line 74
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->DEDUP:Ljava/util/HashMap;

    const-wide/16 v0, 0x0

    .line 84
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->sApiErrAt:J

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 119
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(I)Z
    .registers 1

    .line 38
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->noteApiError(I)Z

    move-result p0

    return p0
.end method

.method static synthetic access$100(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    .line 38
    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->doPick(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static apiCooling()Z
    .registers 4

    .line 88
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->sApiErrAt:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x4e20

    cmp-long v0, v0, v2

    if-gez v0, :cond_f

    const/4 v0, 0x1

    return v0

    :cond_f
    const/4 v0, 0x0

    return v0
.end method

.method public static describe()Ljava/lang/String;
    .registers 1

    .line 333
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_9

    .line 334
    const-string v0, "\u5bbf\u4e3b\u6ca1\u8d77"

    return-object v0

    .line 336
    :cond_9
    :try_start_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->on()Z

    move-result v0

    if-eqz v0, :cond_12

    const-string v0, "\u5df2\u5f00\u542f"

    return-object v0

    :cond_12
    const-string v0, "\u5df2\u5173\u95ed"
    :try_end_14
    .catchall {:try_start_9 .. :try_end_14} :catchall_15

    return-object v0

    .line 338
    :catchall_15
    const-string v0, "\u672a\u77e5"

    return-object v0
.end method

.method private static doPick(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    .registers 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 273
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-nez v0, :cond_8

    goto/16 :goto_12c

    :cond_8
    const/4 v1, 0x0

    const/4 v2, 0x0

    if-eqz p0, :cond_5c

    .line 279
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_10
    :goto_10
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4b

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-nez v4, :cond_1f

    goto :goto_10

    .line 281
    :cond_1f
    iget-object v5, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    const/4 v6, 0x1

    if-eqz v5, :cond_2e

    iget-object v5, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v5, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_2e

    move v5, v6

    goto :goto_2f

    :cond_2e
    move v5, v1

    .line 282
    :goto_2f
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-nez v7, :cond_44

    iget-object v7, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    if-eqz v7, :cond_42

    iget-object v7, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    .line 283
    invoke-virtual {v7, p2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_42

    goto :goto_44

    :cond_42
    move v7, v1

    goto :goto_45

    :cond_44
    :goto_44
    move v7, v6

    :goto_45
    if-eqz v5, :cond_10

    if-eqz v7, :cond_10

    move-object v2, v4

    goto :goto_4c

    :cond_4b
    move v6, v1

    :goto_4c
    if-nez v2, :cond_5b

    .line 291
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_5b

    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    move-object v2, p0

    check-cast v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;
    :try_end_5b
    .catchall {:try_start_0 .. :try_end_5b} :catchall_12d

    :cond_5b
    move v1, v6

    .line 293
    :cond_5c
    const-string p0, " - "

    if-nez v2, :cond_c7

    .line 294
    :try_start_60
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->lastCode()I

    move-result v0

    const/16 v1, 0xc8

    if-eq v0, v1, :cond_8f

    const/4 v1, -0x1

    if-eq v0, v1, :cond_8f

    .line 296
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->noteApiError(I)Z

    move-result p0

    if-eqz p0, :cond_12c

    .line 297
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object p0

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u266a \u7f51\u6613\u4e91\u62d2\u7edd\u4e86\u641c\u7d22\uff08code="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, "\uff09\u2014\u2014 \u53ef\u80fd\u88ab\u9650\u6d41\uff0c\u7a0d\u540e\u518d\u8bd5\uff1b\u4e00\u76f4\u4e0d\u884c\u5c31\u53bb\u97f3\u4e50\u9875\u91cd\u65b0\u767b\u5f55"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    .line 302
    :cond_8f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u266a \u6ca1\u641c\u5230\u300c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\u300d"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 303
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u3010DJ\u3011\u70b9\u6b4c\u5931\u8d25\uff08\u96f6\u7ed3\u679c\uff09\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 306
    :cond_c7
    invoke-virtual {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->play(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    .line 307
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u3010DJ\u3011\u70b9\u6b4c "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " \u21d2 \u653e\u4e86 "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v1, :cond_f4

    .line 309
    const-string p2, "\uff08\u7cbe\u786e\u547d\u4e2d\uff09"

    goto :goto_f6

    :cond_f4
    const-string p2, "\uff08\u515c\u5e95\u7b2c\u4e00\u6761\uff09"

    :goto_f6
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 307
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-nez v1, :cond_12c

    .line 312
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object p2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u266a \u6ca1\u627e\u5230\u300c"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\u300d\uff0c\u7ed9\u4f60\u653e\u4e86\uff1a"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_12c
    .catchall {:try_start_60 .. :try_end_12c} :catchall_12d

    :cond_12c
    :goto_12c
    return-void

    :catchall_12d
    move-exception p0

    .line 316
    const-string p1, "dj.play"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static firstSep(Ljava/lang/String;)I
    .registers 4

    const/4 v0, 0x1

    .line 322
    :goto_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_25

    .line 323
    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x2d

    if-eq v1, v2, :cond_24

    const v2, 0xff0d

    if-eq v1, v2, :cond_24

    const/16 v2, 0x2014

    if-eq v1, v2, :cond_24

    const/16 v2, 0x2013

    if-eq v1, v2, :cond_24

    const/16 v2, 0x2212

    if-ne v1, v2, :cond_21

    goto :goto_24

    :cond_21
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_24
    :goto_24
    return v0

    :cond_25
    const/4 p0, -0x1

    return p0
.end method

.method public static handle(Ljava/lang/String;)Ljava/lang/String;
    .registers 10

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 170
    :cond_4
    :try_start_4
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x7c

    .line 172
    invoke-virtual {p0, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-ltz v2, :cond_3c

    .line 174
    invoke-virtual {p0, v4, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    add-int/2addr v2, v3

    .line 175
    invoke-virtual {p0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    const-string v2, "\\|"

    invoke-virtual {p0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v2, p0

    move v5, v4

    move v6, v5

    :goto_28
    if-ge v5, v2, :cond_3d

    aget-object v7, p0, v5

    .line 176
    const-string v8, "hidden"

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v8, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_39

    move v6, v3

    :cond_39
    add-int/lit8 v5, v5, 0x1

    goto :goto_28

    :cond_3c
    move v6, v4

    .line 179
    :cond_3d
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_44

    return-object v0

    .line 181
    :cond_44
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object p0

    if-nez p0, :cond_4b

    return-object v0

    .line 183
    :cond_4b
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->on()Z

    move-result p0

    if-nez p0, :cond_59

    .line 185
    const-string p0, "dj.off"

    const-string v1, "\u6536\u5230\u70b9\u6b4c\u6807\u8bb0\u4f46\u5f00\u5173\u662f\u5173\u7684\uff08fuckds_dj_off\uff09\u2014\u2014 \u5df2\u541e\u6389"

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    .line 194
    :cond_59
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->firstSep(Ljava/lang/String;)I

    move-result p0
    :try_end_5d
    .catchall {:try_start_4 .. :try_end_5d} :catchall_138

    .line 195
    const-string v2, ""

    if-lez p0, :cond_74

    .line 196
    :try_start_61
    invoke-virtual {v1, v4, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    add-int/2addr p0, v3

    .line 197
    invoke-virtual {v1, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    move-object v1, v4

    goto :goto_75

    :cond_74
    move-object p0, v2

    .line 199
    :goto_75
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_7c

    return-object v0

    .line 203
    :cond_7c
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_84

    move-object v3, v1

    goto :goto_98

    :cond_84
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    :goto_98
    if-eqz v6, :cond_9c

    move-object v4, v0

    goto :goto_c9

    .line 207
    :cond_9c
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u266a \u6b63\u5728\u7ed9\u4f60\u653e\uff1a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_ae

    move-object v5, v1

    goto :goto_c2

    :cond_ae
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " - "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    :goto_c2
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 211
    :goto_c9
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz v6, :cond_d2

    const-string v2, "H|"

    :cond_d2
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "|"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 212
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->recentlyHandled(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_118

    .line 213
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "dj.dup."

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/String;->hashCode()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->abs(I)I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u540c\u4e00\u6761\u70b9\u6b4c\u88ab\u91cd\u590d\u6e32\u67d3 \u21d2 \u8df3\u8fc7\uff08\u4e0d\u91cd\u590d\u641c/\u653e/\u5410\u53f8\uff09\uff1a"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object v4

    .line 219
    :cond_118
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    if-nez v2, :cond_11f

    return-object v4

    .line 222
    :cond_11f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->apiCooling()Z

    move-result v5

    if-eqz v5, :cond_12d

    .line 223
    const-string p0, "dj.api.cool"

    const-string v1, "\u63a5\u53e3\u521a\u62d2\u7edd\u8fc7 \u21d2 \u8df3\u8fc7\u672c\u6b21\u70b9\u6b4c\uff08\u51b7\u5374\u4e2d\uff09"

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object v4

    .line 228
    :cond_12d
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;

    invoke-direct {v5, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    const/16 p0, 0x14

    invoke-virtual {v2, v3, p0, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->search(Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    :try_end_137
    .catchall {:try_start_61 .. :try_end_137} :catchall_138

    return-object v4

    :catchall_138
    move-exception p0

    .line 259
    const-string v1, "dj.handle"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object v0
.end method

.method private static noteApiError(I)Z
    .registers 7

    .line 97
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 98
    sget-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->sApiErrAt:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x4e20

    cmp-long v2, v2, v4

    if-ltz v2, :cond_10

    const/4 v2, 0x1

    goto :goto_11

    :cond_10
    const/4 v2, 0x0

    .line 99
    :goto_11
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->sApiErrAt:J

    .line 100
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010DJ\u3011\u641c\u7d22\u88ab\u63a5\u53e3\u62d2\u7edd\uff1acode="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "\uff08\u8fdb\u5165 20s \u51b7\u5374\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2
.end method

.method public static on()Z
    .registers 3

    .line 134
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 138
    :cond_8
    :try_start_8
    const-string v2, "fuckds_dj_off"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_11

    xor-int/lit8 v0, v0, 0x1

    return v0

    :catchall_11
    return v1
.end method

.method public static promptSection()Ljava/lang/String;
    .registers 1

    .line 151
    const-string v0, "\n\n\u3010\u70b9\u6b4c\u3011\u4f60\u60f3\u7ed9\u7528\u6237\u653e\u9996\u6b4c\u7684\u65f6\u5019\uff0c\u5728\u56de\u590d\u91cc**\u53e6\u8d77\u4e00\u884c**\u5199\uff1a\n\u27e6DJ:\u6b4c\u540d-\u6b4c\u624b\u27e7\n\u4f8b\u5982\uff1a\u27e6DJ:\u6674\u5929-\u5468\u6770\u4f26\u27e7 \u6216 \u27e6DJ:\u6d77\u9614\u5929\u7a7a-Beyond\u27e7\uff08\u53ea\u77e5\u9053\u6b4c\u540d\u3001\u4e0d\u786e\u5b9a\u6b4c\u624b\u65f6\uff0c\u53ea\u5199\u6b4c\u540d\u4e5f\u884c\uff09\u3002\n\u8fd9\u4e00\u884c**\u4e0d\u4f1a\u663e\u793a\u7ed9\u7528\u6237\u770b**\uff0c\u4f1a\u53d8\u6210\u300c\u266a \u6b63\u5728\u7ed9\u4f60\u653e\uff1a\u6b4c\u540d - \u6b4c\u624b\u300d\uff1b\u82e5\u60f3\u8fde\u8fd9\u884c\u63d0\u793a\u90fd\u4e0d\u8981\uff08\u6084\u6084\u653e\uff09\uff0c\u5199\u6210 \u27e6DJ:\u6b4c\u540d-\u6b4c\u624b|hidden\u27e7\u3002\n\u26a0\ufe0f \u53ea\u5728**\u7528\u6237\u660e\u786e\u60f3\u542c\u6b4c**\u65f6\u7528\uff1b\u4e0d\u8981\u628a\u5b83\u5199\u8fdb\u4ee3\u7801\u5757/\u5f15\u53f7\u91cc\uff0c\u4e5f\u4e0d\u8981\u89e3\u91ca\u8fd9\u4e2a\u6807\u8bb0\u3002\n"

    return-object v0
.end method

.method public static raw()Ljava/lang/String;
    .registers 4

    .line 344
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return-object v1

    .line 347
    :cond_8
    :try_start_8
    const-string v2, "fuckds_dj_off"

    const-string v3, "b"

    invoke-static {v0, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_10
    .catchall {:try_start_8 .. :try_end_10} :catchall_11

    return-object v0

    :catchall_11
    return-object v1
.end method

.method private static recentlyHandled(Ljava/lang/String;)Z
    .registers 10

    .line 106
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 107
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->DEDUP_LOCK:Ljava/lang/Object;

    monitor-enter v2

    .line 108
    :try_start_7
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->DEDUP:Ljava/util/HashMap;

    invoke-virtual {v3}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    .line 109
    :cond_11
    :goto_11
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    const-wide/16 v5, 0x3a98

    if-eqz v4, :cond_33

    .line 110
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/Map$Entry;

    invoke-interface {v4}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Long;

    invoke-virtual {v4}, Ljava/lang/Long;->longValue()J

    move-result-wide v7

    sub-long v7, v0, v7

    cmp-long v4, v7, v5

    if-lez v4, :cond_11

    invoke-interface {v3}, Ljava/util/Iterator;->remove()V

    goto :goto_11

    .line 112
    :cond_33
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->DEDUP:Ljava/util/HashMap;

    invoke-virtual {v3, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Long;

    if-eqz v4, :cond_4a

    .line 113
    invoke-virtual {v4}, Ljava/lang/Long;->longValue()J

    move-result-wide v7

    sub-long v7, v0, v7

    cmp-long v4, v7, v5

    if-gez v4, :cond_4a

    const/4 p0, 0x1

    monitor-exit v2

    return p0

    .line 114
    :cond_4a
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v3, p0, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 p0, 0x0

    .line 115
    monitor-exit v2

    return p0

    :catchall_54
    move-exception p0

    .line 116
    monitor-exit v2
    :try_end_56
    .catchall {:try_start_7 .. :try_end_56} :catchall_54

    throw p0
.end method

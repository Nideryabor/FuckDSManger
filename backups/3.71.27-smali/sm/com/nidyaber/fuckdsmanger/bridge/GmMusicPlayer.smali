.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;
    }
.end annotation


# static fields
.field public static final DEF_LEVEL:Ljava/lang/String; = "exhigh"

.field public static final LOOP_LIST:I = 0x0

.field public static final LOOP_ONE:I = 0x1

.field public static final LOOP_SHUFFLE:I = 0x2

.field public static final TAG:Ljava/lang/String; = "FDM-Music"

.field private static volatile sApp:Landroid/content/Context;

.field private static final sCoverCache:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Long;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sInst:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

.field private static final sLyricCache:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Long;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private error:Ljava/lang/String;

.field private index:I

.field private final io:Ljava/util/concurrent/ExecutorService;

.field private level:Ljava/lang/String;

.field private volatile listener:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;

.field private loop:I

.field private mp:Landroid/media/MediaPlayer;

.field private posTickAt:J

.field private preparing:Z

.field private final queue:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;"
        }
    .end annotation
.end field

.field private final ui:Landroid/os/Handler;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 188
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;

    .line 189
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .registers 4

    .line 193
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 174
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->io:Ljava/util/concurrent/ExecutorService;

    .line 175
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;

    .line 177
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    const/4 v1, -0x1

    .line 178
    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    const/4 v1, 0x0

    .line 179
    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    .line 180
    const-string v1, "exhigh"

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->level:Ljava/lang/String;

    const-wide/16 v1, 0x0

    .line 191
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->posTickAt:J

    .line 195
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method static synthetic access$000(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/media/MediaPlayer;
    .registers 1

    .line 58
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    return-object p0
.end method

.method static synthetic access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V
    .registers 1

    .line 58
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    return-void
.end method

.method static synthetic access$1000(Ljava/lang/Object;)J
    .registers 3

    .line 58
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->num(Ljava/lang/Object;)J

    move-result-wide v0

    return-wide v0
.end method

.method static synthetic access$1100(Ljava/lang/Object;)Ljava/lang/String;
    .registers 1

    .line 58
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1200()Ljava/util/Map;
    .registers 1

    .line 58
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$1300()Ljava/util/Map;
    .registers 1

    .line 58
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;
    .registers 1

    .line 58
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Ljava/lang/String;
    .registers 1

    .line 58
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->level:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Z)Z
    .registers 2

    .line 58
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z

    return p1
.end method

.method static synthetic access$502(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 58
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;

    return-object p1
.end method

.method static synthetic access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V
    .registers 1

    .line 58
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

.method static synthetic access$700(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Ljava/util/List;
    .registers 1

    .line 58
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    return-object p0
.end method

.method static synthetic access$800(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V
    .registers 3

    .line 58
    invoke-direct {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->realPlay(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$900(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)I
    .registers 1

    .line 58
    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    return p0
.end method

.method private static applyOsMode(Landroid/content/Context;)V
    .registers 2

    .line 165
    :try_start_0
    const-string p0, "fuckds_music_os"

    const/4 v0, 0x2

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadInt(Ljava/lang/String;I)I

    move-result p0

    .line 166
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setOsMode(I)V
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_a

    :catchall_a
    return-void
.end method

.method public static get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    .registers 1

    .line 129
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sInst:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    return-object v0
.end method

.method public static install(Landroid/content/Context;)V
    .registers 2

    if-nez p0, :cond_3

    goto :goto_34

    .line 135
    :cond_3
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sApp:Landroid/content/Context;

    .line 136
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sInst:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    if-eqz v0, :cond_11

    .line 137
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->applyOsMode(Landroid/content/Context;)V

    return-void

    .line 140
    :cond_11
    const-class p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    monitor-enter p0

    .line 141
    :try_start_14
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sInst:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    if-eqz v0, :cond_1a

    monitor-exit p0
    :try_end_19
    .catchall {:try_start_14 .. :try_end_19} :catchall_35

    return-void

    .line 143
    :cond_1a
    :try_start_1a
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$1;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$1;-><init>()V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setLog(Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;)V
    :try_end_22
    .catchall {:try_start_1a .. :try_end_22} :catchall_22

    .line 156
    :catchall_22
    :try_start_22
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sInst:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    .line 157
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sApp:Landroid/content/Context;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->applyOsMode(Landroid/content/Context;)V

    .line 158
    const-string v0, "\u3010Music\u3011\u64ad\u653e\u5668\u5df2\u5c31\u7eea\uff08\u5bbf\u4e3b\u8fdb\u7a0b\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 159
    monitor-exit p0

    :goto_34
    return-void

    :catchall_35
    move-exception v0

    monitor-exit p0
    :try_end_37
    .catchall {:try_start_22 .. :try_end_37} :catchall_35

    throw v0
.end method

.method private notifyState()V
    .registers 2

    .line 490
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->listener:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;

    if-nez v0, :cond_5

    return-void

    .line 493
    :cond_5
    :try_start_5
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;->onState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
    :try_end_c
    .catchall {:try_start_5 .. :try_end_c} :catchall_d

    return-void

    :catchall_d
    move-exception p0

    .line 495
    const-string v0, "\u3010Music\u3011\u56de\u8c03\u754c\u9762\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static num(Ljava/lang/Object;)J
    .registers 3

    .line 737
    instance-of v0, p0, Ljava/lang/Number;

    if-eqz v0, :cond_b

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide v0

    return-wide v0

    :cond_b
    const-wide/16 v0, 0x0

    return-wide v0
.end method

.method private static parse(Ljava/lang/String;)J
    .registers 3

    .line 795
    :try_start_0
    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0
    :try_end_4
    .catchall {:try_start_0 .. :try_end_4} :catchall_5

    return-wide v0

    :catchall_5
    const-wide/16 v0, 0x0

    return-wide v0
.end method

.method public static parseLrc(Ljava/lang/String;)[Ljava/lang/Object;
    .registers 21

    move-object/from16 v0, p0

    .line 746
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 747
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    const/4 v3, 0x0

    if-nez v0, :cond_18

    .line 748
    new-array v0, v3, [J

    new-array v1, v3, [Ljava/lang/String;

    filled-new-array {v0, v1}, [Ljava/lang/Object;

    move-result-object v0

    return-object v0

    .line 749
    :cond_18
    const-string v4, "\\[(\\d{1,2}):(\\d{1,2})(?:[.:](\\d{1,3}))?\\]"

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    .line 751
    const-string v5, "\n"

    invoke-virtual {v0, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v5, v0

    move v6, v3

    :goto_26
    if-ge v6, v5, :cond_be

    aget-object v7, v0, v6

    .line 752
    invoke-virtual {v4, v7}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v8

    const-wide/16 v9, -0x1

    move v11, v3

    .line 755
    :goto_31
    invoke-virtual {v8}, Ljava/util/regex/Matcher;->find()Z

    move-result v12

    if-eqz v12, :cond_92

    const/4 v9, 0x1

    .line 756
    invoke-virtual {v8, v9}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parse(Ljava/lang/String;)J

    move-result-wide v10

    const/4 v12, 0x2

    .line 757
    invoke-virtual {v8, v12}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v15

    invoke-static {v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parse(Ljava/lang/String;)J

    move-result-wide v15

    const-wide/16 v17, 0x0

    const/4 v13, 0x3

    .line 758
    invoke-virtual {v8, v13}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v14

    if-eqz v14, :cond_7f

    .line 760
    invoke-virtual {v14}, Ljava/lang/String;->length()I

    move-result v19

    if-lez v19, :cond_7f

    .line 761
    invoke-virtual {v14}, Ljava/lang/String;->length()I

    move-result v3

    if-ne v3, v9, :cond_68

    invoke-static {v14}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parse(Ljava/lang/String;)J

    move-result-wide v12

    const-wide/16 v17, 0x64

    :goto_64
    mul-long v13, v12, v17

    const/4 v3, 0x0

    goto :goto_81

    .line 762
    :cond_68
    invoke-virtual {v14}, Ljava/lang/String;->length()I

    move-result v3

    if-ne v3, v12, :cond_75

    invoke-static {v14}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parse(Ljava/lang/String;)J

    move-result-wide v12

    const-wide/16 v17, 0xa

    goto :goto_64

    :cond_75
    const/4 v3, 0x0

    .line 763
    invoke-virtual {v14, v3, v13}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parse(Ljava/lang/String;)J

    move-result-wide v13

    goto :goto_81

    :cond_7f
    move-wide/from16 v13, v17

    :goto_81
    const-wide/32 v17, 0xea60

    mul-long v10, v10, v17

    const-wide/16 v17, 0x3e8

    mul-long v15, v15, v17

    add-long/2addr v10, v15

    add-long v9, v10, v13

    .line 766
    invoke-virtual {v8}, Ljava/util/regex/Matcher;->end()I

    move-result v11

    goto :goto_31

    :cond_92
    const-wide/16 v17, 0x0

    cmp-long v8, v9, v17

    if-gez v8, :cond_99

    goto :goto_ba

    .line 769
    :cond_99
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v8

    invoke-static {v11, v8}, Ljava/lang/Math;->min(II)I

    move-result v8

    invoke-virtual {v7, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    .line 770
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v8

    if-nez v8, :cond_b0

    goto :goto_ba

    .line 771
    :cond_b0
    invoke-static {v9, v10}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-interface {v1, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 772
    invoke-interface {v2, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :goto_ba
    add-int/lit8 v6, v6, 0x1

    goto/16 :goto_26

    .line 775
    :cond_be
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v0

    new-array v4, v0, [Ljava/lang/Integer;

    move v5, v3

    :goto_c5
    if-ge v5, v0, :cond_d0

    .line 776
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v4, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_c5

    .line 778
    :cond_d0
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$10;

    invoke-direct {v5, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$10;-><init>(Ljava/util/List;)V

    invoke-static {v4, v5}, Ljava/util/Arrays;->sort([Ljava/lang/Object;Ljava/util/Comparator;)V

    .line 784
    new-array v5, v0, [J

    .line 785
    new-array v6, v0, [Ljava/lang/String;

    :goto_dc
    if-ge v3, v0, :cond_101

    .line 787
    aget-object v7, v4, v3

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v7

    invoke-interface {v1, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Long;

    invoke-virtual {v7}, Ljava/lang/Long;->longValue()J

    move-result-wide v7

    aput-wide v7, v5, v3

    .line 788
    aget-object v7, v4, v3

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v7

    invoke-interface {v2, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    aput-object v7, v6, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_dc

    .line 790
    :cond_101
    filled-new-array {v5, v6}, [Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method private realPlay(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V
    .registers 6

    .line 431
    const-string v0, "http://"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1b

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "https://"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x7

    invoke-virtual {p2, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 433
    :cond_1b
    :try_start_1b
    new-instance v0, Landroid/media/MediaPlayer;

    invoke-direct {v0}, Landroid/media/MediaPlayer;-><init>()V

    .line 434
    new-instance v1, Landroid/media/AudioAttributes$Builder;

    invoke-direct {v1}, Landroid/media/AudioAttributes$Builder;-><init>()V

    const/4 v2, 0x1

    .line 435
    invoke-virtual {v1, v2}, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    const/4 v2, 0x2

    .line 436
    invoke-virtual {v1, v2}, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    .line 437
    invoke-virtual {v1}, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;

    move-result-object v1

    .line 434
    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setAudioAttributes(Landroid/media/AudioAttributes;)V

    .line 438
    invoke-virtual {v0, p2}, Landroid/media/MediaPlayer;->setDataSource(Ljava/lang/String;)V

    .line 439
    new-instance p2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;

    invoke-direct {p2, p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    invoke-virtual {v0, p2}, Landroid/media/MediaPlayer;->setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V

    .line 453
    new-instance p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;

    invoke-direct {p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->setOnCompletionListener(Landroid/media/MediaPlayer$OnCompletionListener;)V

    .line 467
    new-instance p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;

    invoke-direct {p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V

    .line 477
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    .line 478
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->prepareAsync()V
    :try_end_56
    .catchall {:try_start_1b .. :try_end_56} :catchall_57

    return-void

    :catchall_57
    move-exception p1

    const/4 p2, 0x0

    .line 480
    iput-boolean p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z

    .line 481
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u64ad\u653e\u5668\u521d\u59cb\u5316\u5931\u8d25\uff1a"

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;

    .line 482
    const-string p2, "\u3010Music\u3011\u521d\u59cb\u5316\u5931\u8d25"

    invoke-static {p2, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 483
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    return-void
.end method

.method private saveState()V
    .registers 8

    .line 506
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sApp:Landroid/content/Context;

    if-nez v0, :cond_6

    goto/16 :goto_f1

    .line 508
    :cond_6
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 509
    iget-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->posTickAt:J

    sub-long v3, v1, v3

    const-wide/16 v5, 0x3e8

    cmp-long v3, v3, v5

    if-gez v3, :cond_16

    goto/16 :goto_f1

    .line 510
    :cond_16
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->posTickAt:J

    .line 512
    :try_start_18
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v3

    .line 513
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 514
    const-string v5, "at"

    invoke-virtual {v4, v5, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 515
    const-string v1, "playing"

    iget-boolean v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 516
    const-string v1, "preparing"

    iget-boolean v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->preparing:Z

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 517
    const-string v1, "loop"

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 518
    const-string v1, "index"

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->index:I

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 519
    const-string v1, "queueSize"

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->queueSize:I

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 520
    const-string v1, "pos"

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 521
    const-string v1, "dur"

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 522
    const-string v1, "level"

    iget-object v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->level:Ljava/lang/String;

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 523
    iget-object v1, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    if-eqz v1, :cond_69

    const-string v1, "error"

    iget-object v2, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 524
    :cond_69
    iget-object v1, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-eqz v1, :cond_92

    .line 525
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 526
    const-string v2, "id"

    iget-object v5, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v5, v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    invoke-virtual {v1, v2, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 527
    const-string v2, "name"

    iget-object v5, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v5, v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v1, v2, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 528
    const-string v2, "artist"

    iget-object v3, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v3, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 529
    const-string v2, "track"

    invoke-virtual {v4, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 531
    :cond_92
    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    .line 532
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_9d
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_b1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->toJson()Lorg/json/JSONObject;

    move-result-object v2

    invoke-virtual {v1, v2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_9d

    .line 533
    :cond_b1
    const-string p0, "queue"

    invoke-virtual {v4, p0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 534
    const-string p0, "_note"

    const-string v1, "\u53ea\u6709\u4e8b\u5b9e\u6027\u5143\u6570\u636e\uff1b\u5c01\u9762/\u6b4c\u8bcd/\u97f3\u9891\u4e00\u5f8b\u4e0d\u5728\u672c\u6587\u4ef6\u91cc\uff08\u7248\u6743\uff09"

    invoke-virtual {v4, p0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 536
    new-instance p0, Ljava/io/File;

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    const-string v1, "FDMmusic"

    invoke-direct {p0, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 537
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_d1

    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    .line 538
    :cond_d1
    new-instance v0, Ljava/io/File;

    const-string v1, "state.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 539
    new-instance p0, Ljava/io/FileOutputStream;

    invoke-direct {p0, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/4 v0, 0x1

    .line 540
    invoke-virtual {v4, v0}, Lorg/json/JSONObject;->toString(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "UTF-8"

    invoke-virtual {v0, v1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/io/FileOutputStream;->write([B)V

    .line 541
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->flush()V

    .line 542
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V
    :try_end_f1
    .catchall {:try_start_18 .. :try_end_f1} :catchall_f1

    :catchall_f1
    :goto_f1
    return-void
.end method

.method private startCurrent()V
    .registers 4

    .line 380
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    const/4 v1, 0x0

    if-ltz v0, :cond_18

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v0, v2, :cond_18

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    goto :goto_19

    :cond_18
    move-object v0, v1

    :goto_19
    if-nez v0, :cond_1c

    return-void

    :cond_1c
    const/4 v2, 0x1

    .line 382
    iput-boolean v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z

    .line 383
    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;

    .line 384
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 387
    :try_start_24
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-eqz v2, :cond_2b

    .line 388
    invoke-virtual {v2}, Landroid/media/MediaPlayer;->release()V
    :try_end_2b
    .catchall {:try_start_24 .. :try_end_2b} :catchall_2b

    .line 392
    :catchall_2b
    :cond_2b
    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    .line 394
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->io:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    invoke-direct {v2, p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    invoke-interface {v1, v2}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static str(Ljava/lang/Object;)Ljava/lang/String;
    .registers 1

    if-nez p0, :cond_5

    .line 733
    const-string p0, ""

    return-object p0

    :cond_5
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public cachedLyric(J)Ljava/lang/String;
    .registers 3

    .line 694
    :try_start_0
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;
    :try_end_c
    .catchall {:try_start_0 .. :try_end_c} :catchall_d

    return-object p0

    :catchall_d
    const/4 p0, 0x0

    return-object p0
.end method

.method public clearQueue()V
    .registers 2

    .line 284
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->stop()V

    .line 285
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    const/4 v0, -0x1

    .line 286
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 287
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 288
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

.method public cover(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
            "Landroid/graphics/Bitmap;",
            ">;)V"
        }
    .end annotation

    .line 587
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/graphics/Bitmap;

    if-eqz v0, :cond_18

    .line 588
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_18

    .line 589
    invoke-interface {p3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;->on(Ljava/lang/Object;)V

    return-void

    .line 592
    :cond_18
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->io:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public duration()I
    .registers 3

    .line 347
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-nez v0, :cond_6

    const/4 v0, -0x1

    goto :goto_a

    :cond_6
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->getDuration()I

    move-result v0
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_d

    :goto_a
    if-lez v0, :cond_d

    return v0

    .line 351
    :catchall_d
    :cond_d
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    if-ltz v0, :cond_24

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_24

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    invoke-interface {v0, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    goto :goto_25

    :cond_24
    const/4 p0, 0x0

    :goto_25
    if-nez p0, :cond_29

    const/4 p0, 0x0

    goto :goto_2c

    .line 352
    :cond_29
    iget-wide v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->dur:J

    long-to-int p0, v0

    :goto_2c
    return p0
.end method

.method public enqueue(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V
    .registers 7

    if-nez p1, :cond_3

    goto :goto_1d

    .line 253
    :cond_3
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_9
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1e

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v1, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    iget-wide v3, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    cmp-long v1, v1, v3

    if-nez v1, :cond_9

    :goto_1d
    return-void

    .line 254
    :cond_1e
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 255
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 256
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

.method public isPlaying()Z
    .registers 2

    const/4 v0, 0x0

    .line 357
    :try_start_1
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-eqz p0, :cond_d

    invoke-virtual {p0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result p0
    :try_end_9
    .catchall {:try_start_1 .. :try_end_9} :catchall_d

    if-eqz p0, :cond_d

    const/4 p0, 0x1

    return p0

    :catchall_d
    :cond_d
    return v0
.end method

.method public lyric(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 643
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    if-eqz v0, :cond_12

    .line 645
    invoke-interface {p3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;->on(Ljava/lang/Object;)V

    return-void

    .line 648
    :cond_12
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->io:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public lyricAround(JI)[Ljava/lang/String;
    .registers 11

    .line 707
    invoke-virtual {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->cachedLyric(J)Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    if-eqz p0, :cond_81

    .line 708
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p2

    if-nez p2, :cond_f

    goto/16 :goto_81

    .line 709
    :cond_f
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parseLrc(Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_81

    .line 710
    array-length p2, p0

    const/4 v0, 0x2

    if-ge p2, v0, :cond_1b

    goto/16 :goto_81

    :cond_1b
    const/4 p2, 0x0

    .line 711
    aget-object v0, p0, p2

    check-cast v0, [J

    const/4 v1, 0x1

    .line 712
    aget-object p0, p0, v1

    check-cast p0, [Ljava/lang/String;

    if-eqz v0, :cond_81

    if-eqz p0, :cond_81

    .line 713
    array-length v1, v0

    if-nez v1, :cond_2e

    goto/16 :goto_81

    :cond_2e
    const/4 p1, -0x1

    move v1, p1

    move p1, p2

    .line 716
    :goto_31
    array-length v2, v0

    if-ge p1, v2, :cond_41

    .line 717
    aget-wide v2, v0, p1

    int-to-long v4, p3

    cmp-long v2, v2, v4

    if-gtz v2, :cond_41

    add-int/lit8 v1, p1, 0x1

    move v6, v1

    move v1, p1

    move p1, v6

    goto :goto_31

    .line 720
    :cond_41
    const-string p1, ""

    if-ltz v1, :cond_4f

    array-length p3, p0

    if-ge v1, p3, :cond_4f

    aget-object p3, p0, v1

    invoke-static {p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p3

    goto :goto_50

    :cond_4f
    move-object p3, p1

    :goto_50
    if-lez v1, :cond_5e

    add-int/lit8 v0, v1, -0x1

    .line 721
    array-length v2, p0

    if-ge v0, v2, :cond_5e

    aget-object v0, p0, v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_5f

    :cond_5e
    move-object v0, p1

    :goto_5f
    add-int/lit8 v2, v1, 0x1

    .line 722
    array-length v3, p0

    if-ge v2, v3, :cond_6b

    aget-object v2, p0, v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    goto :goto_6c

    :cond_6b
    move-object v2, p1

    :goto_6c
    if-gez v1, :cond_7b

    .line 725
    array-length v0, p0

    if-lez v0, :cond_79

    aget-object p0, p0, p2

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    move-object v2, p0

    goto :goto_7c

    :cond_79
    move-object v2, p1

    goto :goto_7c

    :cond_7b
    move-object p1, v0

    .line 727
    :goto_7c
    filled-new-array {p3, p1, v2}, [Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_81
    :goto_81
    return-object p1
.end method

.method public next()V
    .registers 5

    .line 307
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    return-void

    .line 308
    :cond_9
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_1c

    .line 309
    invoke-static {}, Ljava/lang/Math;->random()D

    move-result-wide v0

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    int-to-double v2, v2

    mul-double/2addr v0, v2

    double-to-int v0, v0

    goto :goto_27

    .line 310
    :cond_1c
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    add-int/lit8 v0, v0, 0x1

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    rem-int/2addr v0, v1

    :goto_27
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 311
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    return-void
.end method

.method public play(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V
    .registers 7

    if-nez p1, :cond_3

    return-void

    :cond_3
    const/4 v0, 0x0

    .line 236
    :goto_4
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_20

    .line 237
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v1, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    iget-wide v3, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    cmp-long v1, v1, v3

    if-nez v1, :cond_1d

    goto :goto_21

    :cond_1d
    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    :cond_20
    const/4 v0, -0x1

    :goto_21
    if-ltz v0, :cond_26

    .line 242
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    goto :goto_35

    .line 244
    :cond_26
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 245
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    add-int/lit8 p1, p1, -0x1

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 247
    :goto_35
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    return-void
.end method

.method public playAt(I)V
    .registers 3

    if-ltz p1, :cond_10

    .line 260
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lt p1, v0, :cond_b

    goto :goto_10

    .line 261
    :cond_b
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 262
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    :cond_10
    :goto_10
    return-void
.end method

.method public position()I
    .registers 2

    const/4 v0, 0x0

    .line 339
    :try_start_1
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-nez p0, :cond_6

    return v0

    :cond_6
    invoke-virtual {p0}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result p0
    :try_end_a
    .catchall {:try_start_1 .. :try_end_a} :catchall_b

    return p0

    :catchall_b
    return v0
.end method

.method public prev()V
    .registers 5

    .line 315
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    return-void

    .line 316
    :cond_9
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_1c

    .line 317
    invoke-static {}, Ljava/lang/Math;->random()D

    move-result-wide v0

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    int-to-double v2, v2

    mul-double/2addr v0, v2

    double-to-int v0, v0

    goto :goto_28

    .line 318
    :cond_1c
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    if-gtz v0, :cond_26

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    :cond_26
    add-int/lit8 v0, v0, -0x1

    :goto_28
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 319
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    return-void
.end method

.method public queue()Ljava/util/List;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;"
        }
    .end annotation

    .line 229
    new-instance v0, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method public removeAt(I)V
    .registers 4

    if-ltz p1, :cond_45

    .line 266
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lt p1, v0, :cond_b

    goto :goto_45

    .line 267
    :cond_b
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 268
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    if-ge p1, v0, :cond_18

    add-int/lit8 v0, v0, -0x1

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    :cond_18
    if-ne p1, v0, :cond_3f

    .line 270
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_29

    .line 271
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->stop()V

    const/4 p1, -0x1

    .line 272
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    goto :goto_3f

    .line 274
    :cond_29
    iget p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x0

    if-lt p1, v0, :cond_36

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 275
    :cond_36
    iget p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    if-gez p1, :cond_3c

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    .line 276
    :cond_3c
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    .line 279
    :cond_3f
    :goto_3f
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 280
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    :cond_45
    :goto_45
    return-void
.end method

.method public search(Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "I",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;>;)V"
        }
    .end annotation

    .line 552
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->io:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public seekTo(I)V
    .registers 4

    .line 330
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_13

    const/4 v1, 0x0

    invoke-static {v1, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->seekTo(I)V
    :try_end_c
    .catchall {:try_start_0 .. :try_end_c} :catchall_d

    goto :goto_13

    :catchall_d
    move-exception p1

    .line 332
    const-string v0, "\u3010Music\u3011seek \u5931\u8d25"

    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 334
    :cond_13
    :goto_13
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    return-void
.end method

.method public setListener(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;)V
    .registers 2

    .line 208
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->listener:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;

    return-void
.end method

.method public setLoop(I)V
    .registers 2

    .line 323
    rem-int/lit8 p1, p1, 0x3

    add-int/lit8 p1, p1, 0x3

    rem-int/lit8 p1, p1, 0x3

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    .line 324
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 325
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

.method public state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;
    .registers 4

    .line 214
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;-><init>()V

    .line 215
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    if-ltz v1, :cond_1c

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1c

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    goto :goto_1d

    :cond_1c
    const/4 v1, 0x0

    :goto_1d
    iput-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    .line 216
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->isPlaying()Z

    move-result v1

    iput-boolean v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z

    .line 217
    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z

    iput-boolean v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->preparing:Z

    .line 218
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;

    iput-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    .line 219
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I

    iput v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    .line 220
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->index:I

    iput v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->index:I

    .line 221
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    iput v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->queueSize:I

    .line 222
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->position()I

    move-result v1

    iput v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    .line 223
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->duration()I

    move-result v1

    iput v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    .line 224
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->level:Ljava/lang/String;

    iput-object p0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->level:Ljava/lang/String;

    return-object v0
.end method

.method public stop()V
    .registers 2

    const/4 v0, 0x0

    .line 364
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z

    .line 366
    :try_start_3
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_f

    .line 367
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->stop()V

    .line 368
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->release()V
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_f

    :catchall_f
    :cond_f
    const/4 v0, 0x0

    .line 372
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    .line 373
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 374
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

.method public toggle()V
    .registers 3

    .line 292
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-nez v0, :cond_10

    .line 293
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_f

    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V

    :cond_f
    return-void

    .line 297
    :cond_10
    :try_start_10
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v0
    :try_end_14
    .catchall {:try_start_10 .. :try_end_14} :catchall_20

    .line 298
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_1c

    .line 297
    :try_start_18
    invoke-virtual {v1}, Landroid/media/MediaPlayer;->pause()V

    goto :goto_26

    .line 298
    :cond_1c
    invoke-virtual {v1}, Landroid/media/MediaPlayer;->start()V
    :try_end_1f
    .catchall {:try_start_18 .. :try_end_1f} :catchall_20

    goto :goto_26

    :catchall_20
    move-exception v0

    .line 300
    const-string v1, "\u3010Music\u3011toggle \u5931\u8d25"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 302
    :goto_26
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V

    .line 303
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V

    return-void
.end method

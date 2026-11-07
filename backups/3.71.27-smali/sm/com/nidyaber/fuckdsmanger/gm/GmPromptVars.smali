.class public final Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;
.super Ljava/lang/Object;
.source "GmPromptVars.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;
    }
.end annotation


# static fields
.field public static final K_LYRIC:Ljava/lang/String; = "fuckds_pvar_lyric"

.field public static final K_ON:Ljava/lang/String; = "fuckds_pvar_on"

.field public static final NAMES:[Ljava/lang/String;

.field public static final SPEC_TAG:Ljava/lang/String; = "\u3010\u97f3\u4e50\u53d8\u91cf\u3011"

.field private static volatile sWarmAt:J

.field private static volatile sWarmId:J


# direct methods
.method static constructor <clinit>()V
    .registers 12

    .line 95
    const-string v10, "lyric_prev"

    const-string v11, "lyric_next"

    const-string v0, "music"

    const-string v1, "music_or_none"

    const-string v2, "song"

    const-string v3, "artist"

    const-string v4, "album"

    const-string v5, "music_pos"

    const-string v6, "music_dur"

    const-string v7, "music_left"

    const-string v8, "music_state"

    const-string v9, "lyric"

    filled-new-array/range {v0 .. v11}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->NAMES:[Ljava/lang/String;

    const-wide/16 v0, 0x0

    .line 103
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmId:J

    .line 104
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmAt:J

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 106
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$100(I)Ljava/lang/String;
    .registers 1

    .line 81
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static collapse(Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;)Ljava/lang/String;
    .registers 14

    if-eqz p0, :cond_83

    .line 224
    const-string v0, "[["

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_c

    goto/16 :goto_83

    .line 225
    :cond_c
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(I)V

    const/4 v2, 0x0

    move v3, v2

    .line 228
    :goto_17
    invoke-virtual {p0, v0, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v4

    if-gez v4, :cond_25

    .line 230
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {v1, p0, v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;II)Ljava/lang/StringBuilder;

    goto :goto_36

    :cond_25
    add-int/lit8 v5, v4, 0x2

    .line 233
    const-string v6, "]]"

    invoke-virtual {p0, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    if-gez v6, :cond_3b

    .line 235
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {v1, p0, v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;II)Ljava/lang/StringBuilder;

    .line 251
    :goto_36
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 238
    :cond_3b
    invoke-virtual {v1, p0, v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;II)Ljava/lang/StringBuilder;

    .line 239
    invoke-virtual {p0, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x1

    move v5, v2

    move v8, v5

    move v7, v4

    .line 242
    :goto_46
    sget-object v9, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->NAMES:[Ljava/lang/String;

    array-length v10, v9

    if-ge v5, v10, :cond_79

    if-eqz v7, :cond_79

    .line 243
    new-instance v10, Ljava/lang/StringBuilder;

    const-string v11, "{"

    invoke-direct {v10, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v11, v9, v5

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v11, 0x7d

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v3, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v10

    if-ltz v10, :cond_76

    .line 245
    aget-object v8, v9, v5

    invoke-static {v8, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->value(Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-nez v8, :cond_75

    move v7, v2

    :cond_75
    move v8, v4

    :cond_76
    add-int/lit8 v5, v5, 0x1

    goto :goto_46

    :cond_79
    if-eqz v8, :cond_7d

    if-nez v7, :cond_80

    .line 248
    :cond_7d
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_80
    add-int/lit8 v3, v6, 0x2

    goto :goto_17

    :cond_83
    :goto_83
    return-object p0
.end method

.method private static cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    if-nez p0, :cond_5

    .line 387
    const-string p0, ""

    return-object p0

    .line 388
    :cond_5
    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p1

    if-gez p1, :cond_c

    return-object p0

    .line 391
    :cond_c
    const-string v0, "\n\n"

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;I)I

    move-result v1

    const/4 v2, 0x0

    if-ltz v1, :cond_18

    add-int/lit8 v1, v1, 0x2

    goto :goto_19

    :cond_18
    move v1, v2

    .line 393
    :goto_19
    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p1

    if-gez p1, :cond_23

    .line 394
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    .line 395
    :cond_23
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static fmt(I)Ljava/lang/String;
    .registers 3

    if-gtz p0, :cond_5

    .line 414
    const-string p0, "0:00"

    return-object p0

    .line 415
    :cond_5
    div-int/lit16 p0, p0, 0x3e8

    .line 416
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    div-int/lit8 v1, p0, 0x3c

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    rem-int/lit8 p0, p0, 0x3c

    const/16 v1, 0xa

    if-ge p0, v1, :cond_1f

    const-string v1, "0"

    goto :goto_21

    :cond_1f
    const-string v1, ""

    :goto_21
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static hasAny(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_30

    .line 160
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_30

    :cond_a
    move v1, v0

    .line 161
    :goto_b
    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->NAMES:[Ljava/lang/String;

    array-length v3, v2

    if-ge v1, v3, :cond_30

    .line 162
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "{"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v2, v2, v1

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v2, 0x7d

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v2

    if-ltz v2, :cond_2d

    const/4 p0, 0x1

    return p0

    :cond_2d
    add-int/lit8 v1, v1, 0x1

    goto :goto_b

    :cond_30
    :goto_30
    return v0
.end method

.method private static lyr(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;I)Ljava/lang/String;
    .registers 4

    .line 212
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->lyricOn()Z

    move-result v0

    const-string v1, ""

    if-nez v0, :cond_9

    return-object v1

    :cond_9
    if-eqz p0, :cond_24

    .line 213
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    if-nez v0, :cond_10

    goto :goto_24

    :cond_10
    if-nez p1, :cond_18

    .line 214
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    const/4 p1, 0x0

    aget-object p0, p0, p1

    return-object p0

    :cond_18
    const/4 v0, 0x1

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    if-ne p1, v0, :cond_20

    aget-object p0, p0, v0

    return-object p0

    :cond_20
    const/4 p1, 0x2

    aget-object p0, p0, p1

    return-object p0

    :cond_24
    :goto_24
    return-object v1
.end method

.method public static lyricOn()Z
    .registers 3

    .line 131
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 134
    :cond_8
    :try_start_8
    const-string v2, "fuckds_pvar_lyric"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_f

    return v0

    :catchall_f
    return v1
.end method

.method public static mergeIntoSystemPrompt()Ljava/lang/String;
    .registers 6

    .line 348
    const-string v0, "\u3010\u97f3\u4e50\u53d8\u91cf\u3011"

    :try_start_2
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v1
    :try_end_6
    .catchall {:try_start_2 .. :try_end_6} :catchall_7e

    .line 349
    const-string v2, ""

    if-nez v1, :cond_b

    move-object v1, v2

    .line 350
    :cond_b
    :try_start_b
    invoke-virtual {v1, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-ltz v3, :cond_13

    const/4 v3, 0x1

    goto :goto_14

    :cond_13
    const/4 v3, 0x0

    :goto_14
    if-eqz v3, :cond_1f

    .line 351
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->tidy(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_20

    :cond_1f
    move-object v0, v1

    .line 352
    :goto_20
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_2b

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->spec()Ljava/lang/String;

    move-result-object v0

    goto :goto_43

    :cond_2b
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\n\n"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->spec()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 353
    :goto_43
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 354
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz v3, :cond_50

    const-string v5, "\u5df2\u66f4\u65b0"

    goto :goto_52

    :cond_50
    const-string v5, "\u5df2\u5199\u8fdb"

    :goto_52
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "\u7cfb\u7edf\u63d0\u793a\u8bcd\uff08"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 355
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u5b57 \u2192 "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v3, :cond_76

    .line 356
    const-string v2, "\uff1b\u65e7\u7684\u90a3\u6bb5\u88ab\u6362\u6210\u65b0\u7248\uff0c\u4f60\u81ea\u5df1\u5199\u7684\u5185\u5bb9\u6ca1\u52a8"

    :cond_76
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_7d
    .catchall {:try_start_b .. :try_end_7d} :catchall_7e

    return-object v0

    :catchall_7e
    move-exception v0

    .line 358
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u5199\u63d0\u793a\u8bcd\u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static on()Z
    .registers 3

    .line 111
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 114
    :cond_8
    :try_start_8
    const-string v2, "fuckds_pvar_on"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_f

    return v0

    :catchall_f
    return v1
.end method

.method public static removeSpec()Ljava/lang/String;
    .registers 4

    .line 371
    const-string v0, "\u3010\u97f3\u4e50\u53d8\u91cf\u3011"

    const-string v1, "\u5df2\u6e05\u7a7a\u97f3\u4e50\u53d8\u91cf\u793a\u4f8b\uff08"

    :try_start_4
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_47

    .line 372
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_11

    goto :goto_47

    .line 373
    :cond_11
    invoke-virtual {v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-gez v3, :cond_1a

    const-string v0, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u91cc\u6ca1\u6709\u3010\u97f3\u4e50\u53d8\u91cf\u3011\u8fd9\u4e00\u6bb5\uff08\u53ef\u80fd\u672c\u6765\u5c31\u6ca1\u704c\uff09"

    return-object v0

    .line 375
    :cond_1a
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    .line 376
    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->tidy(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 377
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 378
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u5b57 \u2192 "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09\uff1b\u4f60\u81ea\u5df1\u5199\u7684\u5185\u5bb9\u539f\u6837\u4fdd\u7559"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 372
    :cond_47
    :goto_47
    const-string v0, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u672c\u6765\u662f\u7a7a\u7684\uff0c\u6ca1\u4ec0\u4e48\u53ef\u6e05"
    :try_end_49
    .catchall {:try_start_4 .. :try_end_49} :catchall_4a

    return-object v0

    :catchall_4a
    move-exception v0

    .line 381
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6e05\u7a7a\u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static resolve(Ljava/lang/String;)Ljava/lang/String;
    .registers 7

    if-eqz p0, :cond_43

    .line 173
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_43

    .line 175
    :cond_9
    :try_start_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->snap()Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;

    move-result-object v0

    .line 176
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->collapse(Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    .line 177
    :goto_12
    sget-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->NAMES:[Ljava/lang/String;

    array-length v4, v3

    if-ge v2, v4, :cond_3c

    .line 178
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "{"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v5, v3, v2

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "}"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    aget-object v3, v3, v2

    invoke-static {v3, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->value(Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v4, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1
    :try_end_39
    .catchall {:try_start_9 .. :try_end_39} :catchall_3d

    add-int/lit8 v2, v2, 0x1

    goto :goto_12

    :cond_3c
    return-object v1

    :catchall_3d
    move-exception v0

    .line 182
    const-string v1, "pvar.resolve"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_43
    :goto_43
    return-object p0
.end method

.method public static setLyricOn(Z)V
    .registers 4

    .line 141
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 144
    :cond_7
    :try_start_7
    const-string v1, "fuckds_pvar_lyric"

    if-eqz p0, :cond_e

    const-string p0, "true"

    goto :goto_10

    :cond_e
    const-string p0, "false"

    :goto_10
    const-string v2, "b"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_15
    .catchall {:try_start_7 .. :try_end_15} :catchall_16

    return-void

    :catchall_16
    move-exception p0

    .line 146
    const-string v0, "pvar.setLyricOn"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setOn(Z)V
    .registers 4

    .line 121
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 124
    :cond_7
    :try_start_7
    const-string v1, "fuckds_pvar_on"

    if-eqz p0, :cond_e

    const-string p0, "true"

    goto :goto_10

    :cond_e
    const-string p0, "false"

    :goto_10
    const-string v2, "b"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_15
    .catchall {:try_start_7 .. :try_end_15} :catchall_16

    return-void

    :catchall_16
    move-exception p0

    .line 126
    const-string v0, "pvar.setOn"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static snap()Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;
    .registers 8

    .line 258
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->on()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return-object v1

    .line 259
    :cond_8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-nez v0, :cond_f

    return-object v1

    .line 263
    :cond_f
    :try_start_f
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v2
    :try_end_13
    .catchall {:try_start_f .. :try_end_13} :catchall_74

    if-eqz v2, :cond_74

    .line 267
    iget-object v3, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-nez v3, :cond_1a

    goto :goto_74

    .line 269
    :cond_1a
    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;

    invoke-direct {v3, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;-><init>(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;)V

    .line 270
    iget-object v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v4, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->name:Ljava/lang/String;

    .line 271
    iget-object v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v4, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->artist:Ljava/lang/String;

    .line 272
    iget-object v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v4, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->album:Ljava/lang/String;

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->album:Ljava/lang/String;

    .line 273
    iget-object v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v4, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    iput-wide v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->id:J

    .line 274
    iget v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    iput v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    .line 275
    iget v4, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    iput v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    .line 276
    iget-boolean v2, v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z

    iput-boolean v2, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->playing:Z

    .line 279
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->lyricOn()Z

    move-result v2

    if-eqz v2, :cond_73

    iget-wide v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->id:J

    const-wide/16 v6, 0x0

    cmp-long v2, v4, v6

    if-lez v2, :cond_73

    .line 281
    :try_start_5d
    iget-wide v4, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->id:J

    iget v2, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    invoke-virtual {v0, v4, v5, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->lyricAround(JI)[Ljava/lang/String;

    move-result-object v0

    iput-object v0, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;
    :try_end_67
    .catchall {:try_start_5d .. :try_end_67} :catchall_68

    goto :goto_6a

    .line 283
    :catchall_68
    iput-object v1, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    .line 285
    :goto_6a
    iget-object v0, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    if-nez v0, :cond_73

    iget-wide v0, v3, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->id:J

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->warm(J)V

    :cond_73
    return-object v3

    :catchall_74
    :cond_74
    :goto_74
    return-object v1
.end method

.method public static spec()Ljava/lang/String;
    .registers 1

    .line 329
    const-string v0, "\u3010\u97f3\u4e50\u53d8\u91cf\u3011\u4e0b\u9762\u4e24\u884c\u662f\u53d1\u6d88\u606f\u90a3\u4e00\u523b\u6211\u5728\u542c\u7684\u6b4c\uff1a\n[[\u6b63\u5728\u542c\uff1a{music}]]\n[[\u5f53\u524d\u5531\u5230\uff1a{lyric}]]"

    return-object v0
.end method

.method private static str(Ljava/lang/Object;)Ljava/lang/String;
    .registers 1

    if-nez p0, :cond_5

    .line 409
    const-string p0, ""

    return-object p0

    :cond_5
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static tidy(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_5

    .line 400
    const-string p0, ""

    return-object p0

    .line 401
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 402
    :goto_9
    const-string v0, "\n\n\n"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_18

    const-string v1, "\n\n"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    goto :goto_9

    :cond_18
    return-object p0
.end method

.method private static value(Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;)Ljava/lang/String;
    .registers 5

    .line 189
    const-string v0, "music_or_none"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, ""

    if-eqz v0, :cond_1a

    if-nez p1, :cond_d

    return-object v1

    .line 193
    :cond_d
    invoke-virtual {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->summary()Ljava/lang/String;

    move-result-object p0

    .line 194
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_19

    const-string p0, "\u6ca1\u6709\u5728\u542c\u6b4c"

    :cond_19
    return-object p0

    :cond_1a
    if-nez p1, :cond_1d

    return-object v1

    .line 197
    :cond_1d
    const-string v0, "song"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_28

    iget-object p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->name:Ljava/lang/String;

    return-object p0

    .line 198
    :cond_28
    const-string v0, "artist"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_33

    iget-object p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->artist:Ljava/lang/String;

    return-object p0

    .line 199
    :cond_33
    const-string v0, "album"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3e

    iget-object p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->album:Ljava/lang/String;

    return-object p0

    .line 200
    :cond_3e
    const-string v0, "music"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4b

    invoke-virtual {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->summary()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 201
    :cond_4b
    const-string v0, "music_pos"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5a

    iget p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 202
    :cond_5a
    const-string v0, "music_dur"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_69

    iget p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 203
    :cond_69
    const-string v0, "music_left"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v2, 0x0

    if-eqz v0, :cond_85

    iget p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    if-lez p0, :cond_84

    iget p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    iget p1, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    sub-int/2addr p0, p1

    invoke-static {v2, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_84
    return-object v1

    .line 204
    :cond_85
    const-string v0, "music_state"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_97

    iget-boolean p0, p1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->playing:Z

    if-eqz p0, :cond_94

    const-string p0, "playing"

    return-object p0

    :cond_94
    const-string p0, "paused"

    return-object p0

    .line 205
    :cond_97
    const-string v0, "lyric"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a4

    invoke-static {p1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->lyr(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 206
    :cond_a4
    const-string v0, "lyric_prev"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b2

    const/4 p0, 0x1

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->lyr(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 207
    :cond_b2
    const-string v0, "lyric_next"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_c0

    const/4 p0, 0x2

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->lyr(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_c0
    return-object v1
.end method

.method private static warm(J)V
    .registers 8

    .line 299
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 300
    sget-wide v2, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmId:J

    cmp-long v2, v2, p0

    if-nez v2, :cond_16

    sget-wide v2, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmAt:J

    sub-long v2, v0, v2

    const-wide/32 v4, 0xea60

    cmp-long v2, v2, v4

    if-gez v2, :cond_16

    goto :goto_29

    .line 301
    :cond_16
    sput-wide p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmId:J

    .line 302
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->sWarmAt:J

    .line 304
    :try_start_1a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-nez v0, :cond_21

    goto :goto_29

    .line 306
    :cond_21
    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;

    invoke-direct {v1, p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;-><init>(J)V

    invoke-virtual {v0, p0, p1, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->lyric(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    :try_end_29
    .catchall {:try_start_1a .. :try_end_29} :catchall_29

    :catchall_29
    :goto_29
    return-void
.end method

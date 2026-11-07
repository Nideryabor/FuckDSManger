.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;
.super Ljava/lang/Object;
.source "GmSysPrompt.java"


# static fields
.field private static final BS:C = '\\'

.field public static final CARRIER_PLAIN:I = 0x1

.field public static final CARRIER_TAG:I = 0x0

.field public static final DEF_HEAD:Ljava/lang/String; = "My standing preference for this whole conversation: "

.field public static final DEF_TAIL:Ljava/lang/String; = ""

.field public static final K_CARRIER:Ljava/lang/String; = "fuckds_sysprompt_carrier"

.field public static final K_HEAD:Ljava/lang/String; = "fuckds_sysprompt_head"

.field public static final K_MODE:Ljava/lang/String; = "fuckds_sysprompt_mode"

.field public static final K_ON:Ljava/lang/String; = "fuckds_sysprompt_on"

.field public static final K_TAIL:Ljava/lang/String; = "fuckds_sysprompt_tail"

.field public static final K_TEXT:Ljava/lang/String; = "fuckds_sysprompt_text"

.field public static final MODE_EVERY:I = 0x1

.field public static final MODE_FIRST:I = 0x0

.field public static final PLAIN_CLOSE:Ljava/lang/String; = "\u27e6/FDM\u27e7"

.field public static final PLAIN_OPEN:Ljava/lang/String; = "\u27e6FDM\u27e7"

.field private static final TAG_BASE:I = 0xe0000


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 104
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static asciiOk(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x1

    if-nez p0, :cond_4

    return v0

    :cond_4
    const/4 v1, 0x0

    move v2, v1

    .line 347
    :goto_6
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v2, v3, :cond_18

    .line 348
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x80

    if-lt v3, v4, :cond_15

    return v1

    :cond_15
    add-int/lit8 v2, v2, 0x1

    goto :goto_6

    :cond_18
    return v0
.end method

.method static boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z
    .registers 10

    .line 140
    const-string v0, "b"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 141
    const-string v1, "true"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x1

    if-nez v2, :cond_62

    const-string v2, "1"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_18

    goto :goto_62

    .line 142
    :cond_18
    const-string v4, "false"

    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const/4 v6, 0x0

    if-nez v5, :cond_61

    const-string v5, "0"

    invoke-virtual {v5, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2a

    goto :goto_61

    .line 143
    :cond_2a
    const-string v0, "s"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 144
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_60

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3d

    goto :goto_60

    .line 145
    :cond_3d
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_5f

    invoke-virtual {v5, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4a

    goto :goto_5f

    .line 146
    :cond_4a
    const-string v0, "i"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 147
    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_57

    return v3

    .line 148
    :cond_57
    invoke-virtual {v5, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_5e

    return v6

    :cond_5e
    return p2

    :cond_5f
    :goto_5f
    return v6

    :cond_60
    :goto_60
    return v3

    :cond_61
    :goto_61
    return v6

    :cond_62
    :goto_62
    return v3
.end method

.method public static carrier()I
    .registers 3

    .line 290
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 293
    :cond_8
    :try_start_8
    const-string v2, "fuckds_sysprompt_carrier"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_12

    const/4 v2, 0x1

    if-ne v0, v2, :cond_12

    return v2

    :catchall_12
    :cond_12
    return v1
.end method

.method public static describe()Ljava/lang/String;
    .registers 4

    .line 554
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->on()Z

    move-result v0

    if-nez v0, :cond_9

    const-string v0, "\u5df2\u5173\u95ed"

    return-object v0

    .line 555
    :cond_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v0

    .line 556
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_16

    const-string v0, "\u5df2\u5f00\u542f\uff08\u63d0\u793a\u8bcd\u4e3a\u7a7a\uff09"

    return-object v0

    .line 558
    :cond_16
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u5df2\u5f00\u542f \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->mode()I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_27

    const-string v2, "\u6bcf\u8f6e\u6ce8\u5165"

    goto :goto_29

    :cond_27
    const-string v2, "\u4ec5\u9996\u6761"

    :goto_29
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\u7b26"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static djSection(Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    const-string v0, "\u70b9\u6b4c\u7ea6\u5b9a\u5df2\u8865\u5165\u7cfb\u7edf\u63d0\u793a\u8bcd\uff08+"

    .line 540
    :try_start_2
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_9

    goto :goto_3d

    .line 543
    :cond_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->on()Z

    move-result v1

    if-nez v1, :cond_10

    goto :goto_3d

    .line 544
    :cond_10
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->promptSection()Ljava/lang/String;

    move-result-object v1

    .line 545
    const-string v2, "dj.section"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 546
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_3d
    .catchall {:try_start_2 .. :try_end_3d} :catchall_3d

    :catchall_3d
    :goto_3d
    return-object p0
.end method

.method public static firstNonAscii(Ljava/lang/String;)I
    .registers 5

    const/4 v0, -0x1

    if-nez p0, :cond_4

    return v0

    :cond_4
    const/4 v1, 0x0

    .line 356
    :goto_5
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_17

    .line 357
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x80

    if-lt v2, v3, :cond_14

    return v1

    :cond_14
    add-int/lit8 v1, v1, 0x1

    goto :goto_5

    :cond_17
    return v0
.end method

.method public static fromTag(Ljava/lang/String;)Ljava/lang/String;
    .registers 7

    if-nez p0, :cond_5

    .line 399
    const-string p0, ""

    return-object p0

    .line 400
    :cond_5
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    const/4 v1, 0x0

    move v2, v1

    .line 401
    :cond_10
    :goto_10
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v2, v3, :cond_2e

    .line 402
    invoke-virtual {p0, v2}, Ljava/lang/String;->codePointAt(I)I

    move-result v3

    .line 403
    invoke-static {v3}, Ljava/lang/Character;->charCount(I)I

    move-result v4

    add-int/2addr v2, v4

    const/high16 v4, 0xe0000

    if-lt v3, v4, :cond_10

    const v5, 0xe007f

    if-gt v3, v5, :cond_10

    sub-int/2addr v3, v4

    int-to-char v3, v3

    .line 405
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_10

    .line 409
    :cond_2e
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 410
    :goto_37
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-ge v1, v2, :cond_79

    .line 411
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->charAt(I)C

    move-result v2

    const/16 v3, 0x5c

    if-ne v2, v3, :cond_6f

    add-int/lit8 v2, v1, 0x1

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-ge v2, v3, :cond_6f

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->charAt(I)C

    move-result v2

    const/16 v3, 0x75

    if-ne v2, v3, :cond_6f

    add-int/lit8 v2, v1, 0x6

    .line 412
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-gt v2, v3, :cond_6f

    add-int/lit8 v3, v1, 0x2

    .line 414
    :try_start_5f
    invoke-virtual {v0, v3, v2}, Ljava/lang/StringBuilder;->substring(II)Ljava/lang/String;

    move-result-object v3

    const/16 v4, 0x10

    invoke-static {v3, v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v3

    int-to-char v3, v3

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_6d
    .catch Ljava/lang/NumberFormatException; {:try_start_5f .. :try_end_6d} :catch_6f

    move v1, v2

    goto :goto_37

    .line 422
    :catch_6f
    :cond_6f
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->charAt(I)C

    move-result v2

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_37

    .line 425
    :cond_79
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static hasPlainMark(Ljava/lang/String;)Z
    .registers 2

    if-eqz p0, :cond_c

    .line 336
    const-string v0, "\u27e6FDM\u27e7"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_c

    const/4 p0, 0x1

    return p0

    :cond_c
    const/4 p0, 0x0

    return p0
.end method

.method public static hasTag(Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    :cond_4
    move v1, v0

    .line 431
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_1f

    .line 432
    invoke-virtual {p0, v1}, Ljava/lang/String;->codePointAt(I)I

    move-result v2

    .line 433
    invoke-static {v2}, Ljava/lang/Character;->charCount(I)I

    move-result v3

    add-int/2addr v1, v3

    const/high16 v3, 0xe0000

    if-lt v2, v3, :cond_5

    const v3, 0xe007f

    if-gt v2, v3, :cond_5

    const/4 p0, 0x1

    return p0

    :cond_1f
    return v0
.end method

.method public static head()Ljava/lang/String;
    .registers 3

    .line 228
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    .line 229
    const-string v1, "My standing preference for this whole conversation: "

    if-nez v0, :cond_9

    return-object v1

    .line 231
    :cond_9
    :try_start_9
    const-string v2, "fuckds_sysprompt_head"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->textOr(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_f
    .catchall {:try_start_9 .. :try_end_f} :catchall_10

    return-object v0

    :catchall_10
    return-object v1
.end method

.method private static hex4(C)Ljava/lang/String;
    .registers 7

    const/16 v0, 0x10

    .line 388
    new-array v0, v0, [C

    fill-array-data v0, :array_32

    .line 389
    new-instance v1, Ljava/lang/String;

    shr-int/lit8 v2, p0, 0xc

    and-int/lit8 v2, v2, 0xf

    aget-char v2, v0, v2

    shr-int/lit8 v3, p0, 0x8

    and-int/lit8 v3, v3, 0xf

    aget-char v3, v0, v3

    shr-int/lit8 v4, p0, 0x4

    and-int/lit8 v4, v4, 0xf

    aget-char v4, v0, v4

    and-int/lit8 p0, p0, 0xf

    aget-char p0, v0, p0

    const/4 v0, 0x4

    new-array v0, v0, [C

    const/4 v5, 0x0

    aput-char v2, v0, v5

    const/4 v2, 0x1

    aput-char v3, v0, v2

    const/4 v2, 0x2

    aput-char v4, v0, v2

    const/4 v2, 0x3

    aput-char p0, v0, v2

    invoke-direct {v1, v0}, Ljava/lang/String;-><init>([C)V

    return-object v1

    :array_32
    .array-data 2
        0x30s
        0x31s
        0x32s
        0x33s
        0x34s
        0x35s
        0x36s
        0x37s
        0x38s
        0x39s
        0x41s
        0x42s
        0x43s
        0x44s
        0x45s
        0x46s
    .end array-data
.end method

.method public static inject(Ljava/lang/String;Z)Ljava/lang/String;
    .registers 10

    .line 490
    const-string v0, "sysprompt.inject"

    .line 0
    const-string v1, "sp="

    .line 490
    :try_start_4
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->on()Z

    move-result v2

    if-nez v2, :cond_b

    goto :goto_48

    .line 491
    :cond_b
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v2

    .line 492
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_16

    goto :goto_48

    :cond_16
    if-nez p0, :cond_19

    goto :goto_48

    .line 494
    :cond_19
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasTag(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_20

    goto :goto_48

    .line 496
    :cond_20
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->mode()I

    move-result v3

    .line 504
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->hasAny(Ljava/lang/String;)Z

    move-result v4

    if-nez v3, :cond_2f

    if-nez p1, :cond_2f

    if-nez v4, :cond_2f

    goto :goto_48

    .line 507
    :cond_2f
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->resolve(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 508
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_3a

    goto :goto_48

    .line 509
    :cond_3a
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->djSection(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 511
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->wrap(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 512
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_49

    :goto_48
    return-object p0

    .line 514
    :cond_49
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 515
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " body="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " first="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " mode="

    invoke-virtual {v7, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " pvar="

    invoke-virtual {v7, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 514
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 517
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_8f
    .catchall {:try_start_4 .. :try_end_8f} :catchall_90

    return-object p0

    :catchall_90
    move-exception p1

    .line 519
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object p0
.end method

.method private static intOf(Landroid/content/Context;Ljava/lang/String;I)I
    .registers 7

    .line 154
    const-string v0, "i"

    const-string v1, "s"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    :goto_9
    const/4 v2, 0x2

    if-ge v1, v2, :cond_26

    aget-object v2, v0, v1

    .line 156
    :try_start_e
    invoke-static {p0, p1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_23

    .line 157
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_23

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_22
    .catchall {:try_start_e .. :try_end_22} :catchall_23

    return p0

    :catchall_23
    :cond_23
    add-int/lit8 v1, v1, 0x1

    goto :goto_9

    :cond_26
    return p2
.end method

.method public static mode()I
    .registers 3

    .line 269
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 272
    :cond_8
    :try_start_8
    const-string v2, "fuckds_sysprompt_mode"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_12

    const/4 v2, 0x1

    if-ne v0, v2, :cond_12

    return v2

    :catchall_12
    :cond_12
    return v1
.end method

.method public static on()Z
    .registers 3

    .line 168
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 171
    :cond_8
    :try_start_8
    const-string v2, "fuckds_sysprompt_on"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_f

    return v0

    :catchall_f
    return v1
.end method

.method public static setCarrier(I)V
    .registers 4

    .line 300
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 303
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_carrier"

    const/4 v2, 0x1

    if-ne p0, v2, :cond_f

    const-string p0, "1"

    goto :goto_11

    :cond_f
    const-string p0, "0"

    :goto_11
    const-string v2, "i"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_16
    .catchall {:try_start_7 .. :try_end_16} :catchall_17

    return-void

    :catchall_17
    move-exception p0

    .line 305
    const-string v0, "sysprompt.setCarrier"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setHead(Ljava/lang/String;)V
    .registers 4

    .line 238
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 241
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_head"

    if-nez p0, :cond_d

    const-string p0, ""

    :cond_d
    const-string v2, "s"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_12
    .catchall {:try_start_7 .. :try_end_12} :catchall_13

    return-void

    :catchall_13
    move-exception p0

    .line 243
    const-string v0, "sysprompt.setHead"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setMode(I)V
    .registers 4

    .line 279
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 282
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_mode"

    const/4 v2, 0x1

    if-ne p0, v2, :cond_f

    const-string p0, "1"

    goto :goto_11

    :cond_f
    const-string p0, "0"

    :goto_11
    const-string v2, "i"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_16
    .catchall {:try_start_7 .. :try_end_16} :catchall_17

    return-void

    :catchall_17
    move-exception p0

    .line 284
    const-string v0, "sysprompt.setMode"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setOn(Z)V
    .registers 4

    .line 178
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 181
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_on"

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

    .line 183
    const-string v0, "sysprompt.setOn"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setTail(Ljava/lang/String;)V
    .registers 4

    .line 259
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 262
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_tail"

    if-nez p0, :cond_d

    const-string p0, ""

    :cond_d
    const-string v2, "s"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_12
    .catchall {:try_start_7 .. :try_end_12} :catchall_13

    return-void

    :catchall_13
    move-exception p0

    .line 264
    const-string v0, "sysprompt.setTail"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setText(Ljava/lang/String;)V
    .registers 4

    .line 199
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 202
    :cond_7
    :try_start_7
    const-string v1, "fuckds_sysprompt_text"

    if-nez p0, :cond_d

    const-string p0, ""

    :cond_d
    const-string v2, "s"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_12
    .catchall {:try_start_7 .. :try_end_12} :catchall_13

    return-void

    :catchall_13
    move-exception p0

    .line 204
    const-string v0, "sysprompt.setText"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static strip(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    if-eqz p0, :cond_39

    .line 325
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_39

    .line 326
    :cond_9
    const-string v0, "\u27e6FDM\u27e7"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    if-gez v0, :cond_12

    goto :goto_39

    :cond_12
    add-int/lit8 v1, v0, 0x5

    .line 328
    const-string v2, "\u27e6/FDM\u27e7"

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    const/4 v2, 0x0

    .line 329
    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    if-gez v1, :cond_24

    .line 330
    const-string p0, ""

    goto :goto_2a

    :cond_24
    add-int/lit8 v1, v1, 0x6

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 331
    :goto_2a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :cond_39
    :goto_39
    return-object p0
.end method

.method public static tail()Ljava/lang/String;
    .registers 3

    .line 249
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    .line 250
    const-string v1, ""

    if-nez v0, :cond_9

    return-object v1

    .line 252
    :cond_9
    :try_start_9
    const-string v2, "fuckds_sysprompt_tail"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->textOr(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_f
    .catchall {:try_start_9 .. :try_end_f} :catchall_10

    return-object v0

    :catchall_10
    return-object v1
.end method

.method public static text()Ljava/lang/String;
    .registers 4

    .line 188
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    .line 189
    const-string v1, ""

    if-nez v0, :cond_9

    return-object v1

    .line 191
    :cond_9
    :try_start_9
    const-string v2, "fuckds_sysprompt_text"

    const-string v3, "s"

    invoke-static {v0, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_11
    .catchall {:try_start_9 .. :try_end_11} :catchall_15

    if-nez v0, :cond_14

    return-object v1

    :cond_14
    return-object v0

    :catchall_15
    return-object v1
.end method

.method private static textOr(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 217
    :try_start_0
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    if-eqz v0, :cond_d

    .line 218
    invoke-interface {v0, p1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_d

    if-nez v0, :cond_d

    return-object p2

    .line 222
    :catchall_d
    :cond_d
    const-string v0, "s"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_16

    goto :goto_17

    :cond_16
    move-object p2, p0

    :goto_17
    return-object p2
.end method

.method public static toTag(Ljava/lang/String;)Ljava/lang/String;
    .registers 8

    if-eqz p0, :cond_57

    .line 371
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_57

    .line 372
    :cond_9
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    mul-int/lit8 v1, v1, 0x6

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    const/4 v1, 0x0

    move v2, v1

    .line 373
    :goto_16
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v2, v3, :cond_52

    .line 374
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x80

    const/high16 v5, 0xe0000

    if-ge v3, v4, :cond_2b

    add-int/2addr v3, v5

    .line 376
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->appendCodePoint(I)Ljava/lang/StringBuilder;

    goto :goto_4f

    .line 378
    :cond_2b
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v6, "\\u"

    invoke-direct {v4, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hex4(C)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move v4, v1

    .line 379
    :goto_3e
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v4, v6, :cond_4f

    .line 380
    invoke-virtual {v3, v4}, Ljava/lang/String;->charAt(I)C

    move-result v6

    add-int/2addr v6, v5

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->appendCodePoint(I)Ljava/lang/StringBuilder;

    add-int/lit8 v4, v4, 0x1

    goto :goto_3e

    :cond_4f
    :goto_4f
    add-int/lit8 v2, v2, 0x1

    goto :goto_16

    .line 384
    :cond_52
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 371
    :cond_57
    :goto_57
    const-string p0, ""

    return-object p0
.end method

.method public static wrap(Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    if-eqz p0, :cond_71

    .line 452
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_71

    .line 454
    :cond_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->head()Ljava/lang/String;

    move-result-object v0

    .line 455
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->tail()Ljava/lang/String;

    move-result-object v1

    .line 463
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->carrier()I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_42

    .line 464
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u27e6FDM\u27e7"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz v0, :cond_2a

    .line 466
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_2a

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 467
    :cond_2a
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v1, :cond_38

    .line 468
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_38

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 469
    :cond_38
    const-string p0, "\u27e6/FDM\u27e7"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 470
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 474
    :cond_42
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz v0, :cond_56

    .line 475
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_56

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->toTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 476
    :cond_56
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->toTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v1, :cond_6c

    .line 477
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_6c

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->toTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 478
    :cond_6c
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 452
    :cond_71
    :goto_71
    const-string p0, ""

    return-object p0
.end method

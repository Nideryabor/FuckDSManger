.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;
.super Ljava/lang/Object;
.source "GmSuggest.java"


# static fields
.field static final DEF:Ljava/lang/String;

.field static final KAI:Ljava/lang/String;

.field static final KCNT:Ljava/lang/String;

.field static final KEY:Ljava/lang/String;

.field static final KON:Ljava/lang/String;

.field static sAi:Ljava/util/List;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_suggest_text"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KEY:Ljava/lang/String;

    const-string v0, "fuckds_suggest_on"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KON:Ljava/lang/String;

    const-string v0, "fuckds_suggest_count"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KCNT:Ljava/lang/String;

    const-string v0, "fuckds_suggest_ai"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KAI:Ljava/lang/String;

    const-string v0, "\u80fd\u518d\u5c55\u5f00\u8bb2\u8bb2\u5417\uff1f\n\u4e3e\u4e2a\u5177\u4f53\u7684\u4f8b\u5b50\n\u7528\u8868\u683c\u603b\u7ed3\u4e00\u4e0b"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->DEF:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static aiClear()V
    .registers 1

    const/4 v0, 0x0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->sAi:Ljava/util/List;

    return-void
.end method

.method public static aiGet()Ljava/util/List;
    .registers 1

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->sAi:Ljava/util/List;

    return-object v0
.end method

.method public static aiOn(Landroid/content/Context;)Z
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KAI:Ljava/lang/String;

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "true"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_12

    const/4 v0, 0x0

    return v0

    :cond_12
    const/4 v0, 0x1

    return v0
.end method

.method public static aiPut(Ljava/util/List;)V
    .registers 2

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->sAi:Ljava/util/List;

    return-void
.end method

.method public static count(Landroid/content/Context;)I
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KCNT:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x3

    :try_start_9
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2
    :try_end_d
    .catch Ljava/lang/NumberFormatException; {:try_start_9 .. :try_end_d} :catch_15

    if-lez v2, :cond_14

    const/16 p0, 0xa

    if-gt v2, p0, :cond_14

    return v2

    :cond_14
    return v1

    :catch_15
    move-exception v0

    return v1
.end method

.method public static on(Landroid/content/Context;)Z
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KON:Ljava/lang/String;

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "false"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_12

    const/4 v0, 0x1

    return v0

    :cond_12
    const/4 v0, 0x0

    return v0
.end method

.method public static restore(Landroid/content/Context;)V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KEY:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KON:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KCNT:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KAI:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static setAi(Landroid/content/Context;Z)V
    .registers 5

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KAI:Ljava/lang/String;

    if-eqz p1, :cond_7

    const-string v1, "true"

    goto :goto_9

    :cond_7
    const-string v1, "false"

    :goto_9
    const-string v2, "b"

    invoke-static {p0, v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setCount(Landroid/content/Context;I)V
    .registers 5

    if-gtz p1, :cond_3

    const/4 p1, 0x3

    :cond_3
    const/16 v0, 0xa

    if-le p1, v0, :cond_9

    const/16 p1, 0xa

    :cond_9
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KCNT:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 5

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KON:Ljava/lang/String;

    if-eqz p1, :cond_7

    const-string v1, "true"

    goto :goto_9

    :cond_7
    const-string v1, "false"

    :goto_9
    const-string v2, "b"

    invoke-static {p0, v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setText(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KEY:Ljava/lang/String;

    if-nez p1, :cond_6

    const-string p1, ""

    :cond_6
    const-string v1, "s"

    invoke-static {p0, v0, p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static templates(Landroid/content/Context;)Ljava/util/List;
    .registers 8

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->sAi:Ljava/util/List;

    if-eqz v0, :cond_11

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_11

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->aiOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_11

    return-object v0

    :cond_11
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->text(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "\n"

    const/4 v3, -0x1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v1

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->count(Landroid/content/Context;)I

    move-result v2

    const/4 v3, 0x0

    :goto_26
    array-length v4, v1

    if-ge v3, v4, :cond_43

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v4

    if-lt v4, v2, :cond_30

    goto :goto_43

    :cond_30
    aget-object v4, v1, v3

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_3d

    goto :goto_40

    :cond_3d
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :goto_40
    add-int/lit8 v3, v3, 0x1

    goto :goto_26

    :cond_43
    :goto_43
    return-object v0
.end method

.method public static text(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_14

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_17

    :cond_14
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->DEF:Ljava/lang/String;

    return-object v0

    :cond_17
    return-object v0
.end method

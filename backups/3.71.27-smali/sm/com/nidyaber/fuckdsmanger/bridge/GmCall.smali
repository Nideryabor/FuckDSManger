.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmCall;
.super Ljava/lang/Object;
.source "GmCall.java"


# static fields
.field private static final BAK_MODEL:Ljava/lang/String; = "fuckds_bak_kv_remote_settings_model_configs_v1"

.field public static final KEY_MODEL:Ljava/lang/String; = "kv_remote_settings_model_configs_v1"

.field public static final KEY_ON:Ljava/lang/String; = "fuckds_call_on"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensure(Landroid/content/Context;)V
    .registers 7

    .line 92
    const-string v0, "s"

    const-string v1, "kv_remote_settings_model_configs_v1"

    .line 0
    const-string v2, "\u3010\u901a\u8bdd\u3011\u5df2\u8865 call_feature\uff08"

    if-eqz p0, :cond_58

    .line 92
    :try_start_8
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->on(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_f

    goto :goto_58

    .line 93
    :cond_f
    invoke-static {p0, v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 94
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->looksJson(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1a

    goto :goto_58

    .line 95
    :cond_1a
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->fix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_58

    .line 96
    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_27

    goto :goto_58

    .line 97
    :cond_27
    invoke-static {p0, v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 98
    invoke-static {p0, v1, v4, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 99
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u2192 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_51
    .catchall {:try_start_8 .. :try_end_51} :catchall_52

    return-void

    :catchall_52
    move-exception p0

    .line 101
    const-string v0, "\u3010\u901a\u8bdd\u3011ensure \u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_58
    :goto_58
    return-void
.end method

.method public static fix(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_4

    const/4 p0, 0x0

    return-object p0

    .line 61
    :cond_4
    const-string v0, "call_feature"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_d

    return-object p0

    .line 62
    :cond_d
    const-string v0, "\"model_type\":\""

    const-string v1, "\"call_feature\":{},\"model_type\":\""

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static looksJson(Ljava/lang/String;)Z
    .registers 4

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 71
    :cond_4
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 72
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x2

    if-le v1, v2, :cond_21

    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x5b

    if-eq v1, v2, :cond_1f

    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result p0

    const/16 v1, 0x7b

    if-ne p0, v1, :cond_21

    :cond_1f
    const/4 p0, 0x1

    return p0

    :cond_21
    return v0
.end method

.method public static on(Landroid/content/Context;)Z
    .registers 4

    .line 78
    :try_start_0
    const-string v0, "1"

    const-string v1, "fuckds_call_on"

    const-string v2, "s"

    invoke-static {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return p0

    :catchall_f
    const/4 p0, 0x0

    return p0
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 5

    .line 114
    const-string v0, "s"

    if-nez p0, :cond_5

    return-void

    .line 115
    :cond_5
    :try_start_5
    const-string v1, "fuckds_call_on"

    if-eqz p1, :cond_c

    const-string v2, "1"

    goto :goto_e

    :cond_c
    const-string v2, "0"

    :goto_e
    invoke-static {p0, v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_17

    .line 117
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->ensure(Landroid/content/Context;)V

    return-void

    .line 118
    :cond_17
    const-string p1, "fuckds_bak_kv_remote_settings_model_configs_v1"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_2a

    .line 119
    const-string p1, "kv_remote_settings_model_configs_v1"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->restore(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 120
    const-string p0, "\u3010\u901a\u8bdd\u3011\u5df2\u5173\u95ed\uff0cmodel_configs \u5df2\u4ece\u5907\u4efd\u8fd8\u539f"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 122
    :cond_2a
    const-string p0, "\u3010\u901a\u8bdd\u3011\u5df2\u5173\u95ed\uff08\u65e0\u5907\u4efd \u21d2 \u4e0d\u52a8\u5bbf\u4e3b\u5b58\u50a8\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_2f
    .catchall {:try_start_5 .. :try_end_2f} :catchall_30

    return-void

    :catchall_30
    move-exception p0

    .line 125
    const-string p1, "\u3010\u901a\u8bdd\u3011setOn \u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static state(Landroid/content/Context;)Ljava/lang/String;
    .registers 5

    const/4 v0, 0x0

    .line 142
    :try_start_1
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->on(Landroid/content/Context;)Z

    move-result v1
    :try_end_5
    .catchall {:try_start_1 .. :try_end_5} :catchall_1a

    .line 143
    :try_start_5
    const-string v2, "kv_remote_settings_model_configs_v1"

    const-string v3, "s"

    invoke-static {p0, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_1b

    .line 144
    const-string v2, "call_feature"

    invoke-virtual {p0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0
    :try_end_15
    .catchall {:try_start_5 .. :try_end_15} :catchall_1b

    if-eqz p0, :cond_1b

    const/4 p0, 0x1

    move v0, p0

    goto :goto_1b

    :catchall_1a
    move v1, v0

    .line 148
    :catchall_1b
    :cond_1b
    :goto_1b
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "|"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

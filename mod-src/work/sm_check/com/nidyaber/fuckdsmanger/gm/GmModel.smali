.class public final Lcom/nidyaber/fuckdsmanger/gm/GmModel;
.super Ljava/lang/Object;
.source "GmModel.java"


# static fields
.field static final FALSE:Ljava/lang/String;

.field static final KEY:Ljava/lang/String;

.field static final MK:Ljava/lang/String;

.field static final TRUE:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_model_switch"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->KEY:Ljava/lang/String;

    const-string v0, "kv_remote_settings_model_configs_v1"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->MK:Ljava/lang/String;

    const-string v0, "\"switchable\":false"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->FALSE:Ljava/lang/String;

    const-string v0, "\"switchable\":true"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->TRUE:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static dump(Ljava/lang/String;)V
    .registers 5

    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x12c

    if-ge v0, v1, :cond_c

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_16

    :cond_c
    const/4 v1, 0x0

    const/16 v2, 0x12c

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_17

    :goto_16
    return-void

    :catchall_17
    move-exception v0

    return-void
.end method

.method public static fix(Ljava/lang/String;)Ljava/lang/String;
    .registers 8

    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x4

    if-ge v0, v1, :cond_3c

    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0, p0}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_e
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_35

    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v3

    if-eqz v3, :cond_32

    const-string v4, "switchable"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_32

    const-string v4, "switchable"

    const/4 v5, 0x1

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v4

    if-eqz v4, :cond_32

    const-string v4, "switchable"

    const/4 v5, 0x1

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const/4 v1, 0x1

    :cond_32
    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    :cond_35
    if-eqz v1, :cond_3c

    invoke-virtual {v0}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_3c
    .catchall {:try_start_0 .. :try_end_3c} :catchall_3d

    :cond_3c
    return-object p0

    :catchall_3d
    move-exception v0

    return-object p0
.end method

.method public static hasBak(Landroid/content/Context;)Z
    .registers 4

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "fuckds_bak_"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->MK:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public static isOn(Landroid/content/Context;)Z
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->KEY:Ljava/lang/String;

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public static reapply(Landroid/content/Context;)Z
    .registers 8

    const/4 v0, 0x0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_6d

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_73

    const-string v4, "[model] v60 \u62ff\u5230\u5bbf\u4e3b\u914d\u7f6e\uff0c\u8bc4\u4f30\u4e2d"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v3, "\"switchable\"\\s*:\\s*false"

    const-string v4, "\"switchable\":true"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_2e

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->fix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_79

    :cond_2e
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->hostPut(Ljava/lang/String;)Z

    move-result v0

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[model] v60 \u5df2\u66ff\u6362\uff0c\u5199\u5bbf\u4e3b="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "[model] \u5199\u5165\u540e\u56de\u8bfb\u662f\u5426\u5df2\u542b true = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v4, :cond_60

    sget-object v6, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->TRUE:Ljava/lang/String;

    invoke-virtual {v4, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    goto :goto_65

    :cond_60
    const-string v6, "(\u56de\u8bfb\u4e3a null)"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_65
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_81

    :cond_6d
    const-string v2, "[model] reapply \u8df3\u8fc7\uff1a\u6a21\u578b\u5207\u6362\u5f00\u5173\u672a\u5f00"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_81

    :cond_73
    const-string v2, "[model] reapply \u8df3\u8fc7\uff1a\u8bfb\u4e0d\u5230\u5bbf\u4e3b\u914d\u7f6e\uff08host=null\uff09"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_81

    :cond_79
    const-string v3, "[model] v60 \u6b63\u5219\u4e0e JSON \u5747\u672a\u6539\u52a8\uff0c\u6837\u672c(\u524d300)\uff1a"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->dump(Ljava/lang/String;)V

    :goto_81
    return v0
.end method

.method public static setOn(Landroid/content/Context;Z)Z
    .registers 9

    const/4 v0, 0x0

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->KEY:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    const-string v3, "b"

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_29

    if-nez p1, :cond_1d

    const-string v3, "\"switchable\"\\s*:\\s*true"

    const-string v4, "\"switchable\":false"

    goto :goto_21

    :cond_1d
    const-string v3, "\"switchable\"\\s*:\\s*false"

    const-string v4, "\"switchable\":true"

    :goto_21
    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->hostPut(Ljava/lang/String;)Z

    move-result v0

    :cond_29
    return v0
.end method

.class public final Lcom/nidyaber/fuckdsmanger/gm/GmTts;
.super Ljava/lang/Object;
.source "GmTts.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensure(Landroid/content/Context;)V
    .registers 6

    const-string v0, "kv_remote_settings_model_configs_v1"

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_22

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmTts;->fix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_22

    const-string v3, "s"

    invoke-static {p0, v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const-string v3, "s"

    invoke-static {p0, v0, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_22
    return-void
.end method

.method public static fix(Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    if-nez p0, :cond_3

    return-object p0

    :cond_3
    const-string v0, "tts_feature"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_c

    return-object p0

    :cond_c
    const-string v0, "\"search_feature\":{}"

    const-string v1, "\"search_feature\":{},\"tts_feature\":{\"auto_tts_enable_by_default\":true}"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1b

    return-object v2

    :cond_1b
    const-string v0, "\"think_feature\":{}"

    const-string v1, "\"think_feature\":{},\"tts_feature\":{\"auto_tts_enable_by_default\":true}"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

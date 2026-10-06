.class public final Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;
.super Ljava/lang/Object;
.source "GmPrompt.java"


# static fields
.field static final DEF:Ljava/lang/String;

.field static final KEY:Ljava/lang/String;

.field static final MK:Ljava/lang/String;

.field static final NEEDLE:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_prompt_feature"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->KEY:Ljava/lang/String;

    const-string v0, "kv_remote_settings_model_configs_v1"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->MK:Ljava/lang/String;

    const-string v0, "\"prompt_feature\":["

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->NEEDLE:Ljava/lang/String;

    const-string v0, "[{\"id\":9,\"scene\":\"image\",\"content\":\"\u8fd9\u662f\u4ec0\u4e48\"},{\"id\":10,\"scene\":\"image\",\"content\":\"\u5206\u6790\u4e00\u4e0b\"},{\"id\":11,\"scene\":\"image\",\"content\":\"\u600e\u4e48\u529e\"},{\"id\":12,\"scene\":\"image\",\"content\":\"\u89e3\u91ca\u4e00\u4e0b\"},{\"id\":13,\"scene\":\"file\",\"content\":\"\u5206\u6790\u4e00\u4e0b\"},{\"id\":14,\"scene\":\"file\",\"content\":\"\u7b54\u6848\u662f\u4ec0\u4e48\"},{\"id\":15,\"scene\":\"file\",\"content\":\"\u603b\u7ed3\"},{\"id\":16,\"scene\":\"file\",\"content\":\"\u89e3\u91ca\u4e00\u4e0b\"}]"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->DEF:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apply(Landroid/content/Context;)Z
    .registers 8

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3c

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_19

    goto :goto_21

    :cond_19
    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->MK:Ljava/lang/String;

    const-string v4, "s"

    invoke-static {p0, v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_21
    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3c

    invoke-static {v2, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->patch(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->hostPut(Ljava/lang/String;)Z

    move-result v4

    sget-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->MK:Ljava/lang/String;

    const-string v6, "s"

    invoke-static {p0, v5, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const-string v6, "s"

    invoke-static {p0, v5, v3, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return v4

    :cond_3c
    const/4 v0, 0x0

    return v0
.end method

.method public static build(Ljava/util/List;)Ljava/lang/String;
    .registers 9

    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    const/4 v1, 0x0

    :goto_6
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_20

    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Ljava/lang/String;

    if-eqz v3, :cond_1d

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->row([Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    if-eqz v4, :cond_1d

    invoke-virtual {v0, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    :cond_1d
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    :cond_20
    invoke-virtual {v0}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static current(Landroid/content/Context;)Ljava/lang/String;
    .registers 5

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_12

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->MK:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_12
    if-eqz v0, :cond_34

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->NEEDLE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_34

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->NEEDLE:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    add-int/2addr v2, v1

    add-int/lit8 v2, v2, -0x1

    const/16 v3, 0x5d

    invoke-virtual {v0, v3, v2}, Ljava/lang/String;->indexOf(II)I

    move-result v3

    if-gez v3, :cond_34

    add-int/lit8 v3, v3, 0x1

    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    return-object v1

    :cond_34
    const-string v0, ""

    return-object v0
.end method

.method public static display(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->get(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_b

    return-object v0

    :cond_b
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->current(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_16

    return-object v0

    :cond_16
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->DEF:Ljava/lang/String;

    return-object v0
.end method

.method public static get(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static host()Ljava/lang/String;
    .registers 12

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_42

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "com.tencent.mmkv.MMKV"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Object;

    const-string v3, "l"

    invoke-static {v2, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_42

    const-string v3, "nativeHandle"

    invoke-static {v2, v3}, Lde/robv/android/xposed/XposedHelpers;->getLongField(Ljava/lang/Object;Ljava/lang/String;)J

    move-result-wide v4

    const/4 v3, 0x3

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v6, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    aput-object v7, v3, v6

    const/4 v6, 0x1

    const-string v7, "kv_remote_settings_model_configs_v1"

    aput-object v7, v3, v6

    const/4 v6, 0x2

    const/4 v7, 0x0

    aput-object v7, v3, v6

    const-string v6, "decodeString"

    invoke-static {v2, v6, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :cond_42

    check-cast v2, Ljava/lang/String;

    move-object v0, v2
    :try_end_42
    .catchall {:try_start_1 .. :try_end_42} :catchall_43

    :cond_42
    return-object v0

    :catchall_43
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static hostPut(Ljava/lang/String;)Z
    .registers 13

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_44

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "com.tencent.mmkv.MMKV"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Object;

    const-string v3, "l"

    invoke-static {v2, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_44

    const-string v3, "nativeHandle"

    invoke-static {v2, v3}, Lde/robv/android/xposed/XposedHelpers;->getLongField(Ljava/lang/Object;Ljava/lang/String;)J

    move-result-wide v4

    const/4 v3, 0x3

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v6, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    aput-object v7, v3, v6

    const/4 v6, 0x1

    const-string v7, "kv_remote_settings_model_configs_v1"

    aput-object v7, v3, v6

    const/4 v6, 0x2

    aput-object p0, v3, v6

    const-string v6, "encodeString"

    invoke-static {v2, v6, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Ljava/lang/Boolean;

    if-eqz v3, :cond_44

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0
    :try_end_44
    .catchall {:try_start_1 .. :try_end_44} :catchall_45

    :cond_44
    return v0

    :catchall_45
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return v0
.end method

.method public static items(Landroid/content/Context;)Ljava/util/List;
    .registers 9

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->display(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    :try_start_9
    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2, v1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V
    :try_end_e
    .catch Lorg/json/JSONException; {:try_start_9 .. :try_end_e} :catch_f

    goto :goto_11

    :catch_f
    move-exception v3

    return-object v0

    :goto_11
    const/4 v3, 0x0

    :goto_12
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_42

    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    if-eqz v4, :cond_3f

    const/4 v5, 0x3

    new-array v6, v5, [Ljava/lang/String;

    const/4 v5, 0x0

    const-string v7, "id"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v6, v5

    const/4 v5, 0x1

    const-string v7, "scene"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v6, v5

    const/4 v5, 0x2

    const-string v7, "content"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v6, v5

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_3f
    add-int/lit8 v3, v3, 0x1

    goto :goto_12

    :cond_42
    return-object v0
.end method

.method static ok(Ljava/lang/String;)Z
    .registers 3

    const/4 v0, 0x0

    if-eqz p0, :cond_a

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_a

    const/4 v0, 0x1

    :cond_a
    return v0
.end method

.method public static patch(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 10

    if-eqz p0, :cond_36

    if-eqz p1, :cond_36

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_36

    :try_start_a
    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0, p0}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1, p1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_16
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_2b

    invoke-virtual {v0, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    if-eqz v4, :cond_28

    const-string v5, "prompt_feature"

    invoke-virtual {v4, v5, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const/4 v2, 0x1

    :cond_28
    add-int/lit8 v3, v3, 0x1

    goto :goto_16

    :cond_2b
    if-eqz v2, :cond_36

    invoke-virtual {v0}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_31
    .catchall {:try_start_a .. :try_end_31} :catchall_32

    return-object v0

    :catchall_32
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    :cond_36
    return-object p0
.end method

.method public static put(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, p1, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static reapply(Landroid/content/Context;)Z
    .registers 8

    const/4 v0, 0x0

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->get(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_2e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_2e

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->patch(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_29

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->hostPut(Ljava/lang/String;)Z

    move-result v0

    const-string v4, "[prompt] reapply \u5df2\u628a\u7f16\u8f91\u5185\u5bb9\u5199\u56de\u5bbf\u4e3b"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_2e

    :cond_29
    const-string v4, "[prompt] reapply \u8df3\u8fc7\uff1a\u5bbf\u4e3b\u5df2\u662f\u6700\u65b0"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_2e
    :goto_2e
    return v0
.end method

.method public static restore(Landroid/content/Context;)V
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->MK:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->restore(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->KEY:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static row([Ljava/lang/String;)Lorg/json/JSONObject;
    .registers 6

    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "id"

    const/4 v3, 0x0

    aget-object v3, p0, v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v1, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "scene"

    const/4 v3, 0x1

    aget-object v3, p0, v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "content"

    const/4 v3, 0x2

    aget-object v3, p0, v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-object v0, v1
    :try_end_23
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_23} :catch_24

    goto :goto_25

    :catch_24
    move-exception v1

    :goto_25
    return-object v0
.end method

.method static toInt(Ljava/lang/String;)I
    .registers 3

    const/4 v0, 0x0

    if-eqz p0, :cond_b

    :try_start_3
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    move v0, v1
    :try_end_8
    .catch Ljava/lang/NumberFormatException; {:try_start_3 .. :try_end_8} :catch_9

    goto :goto_b

    :catch_9
    move-exception v1

    const/4 v0, 0x0

    :cond_b
    :goto_b
    return v0
.end method

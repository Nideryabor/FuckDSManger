.class public final Lcom/varuns2002/disable_flag_secure/gm/GmHello;
.super Ljava/lang/Object;
.source "GmHello.java"


# static fields
.field static final DEF:Ljava/lang/String;

.field static final KEY:Ljava/lang/String;

.field static final MK:Ljava/lang/String;

.field static sRoot:Lorg/json/JSONObject;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_welcome_msg"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->KEY:Ljava/lang/String;

    const-string v0, "kv_remote_settings_welcome_msg"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->MK:Ljava/lang/String;

    const-string v0, "{\"messages\":[{\"id\":0,\"text\":\"\u4f60\u597d\uff0c\u6211\u80fd\u5e2e\u4ec0\u4e48\u5fd9\u5417\uff1f\"},{\"id\":1,\"text\":\"\u4f60\u597d\uff0c\u6709\u4ec0\u4e48\u6211\u80fd\u5e2e\u4f60\u7684\u5417\uff1f\"},{\"id\":2,\"text\":\"\u4f60\u597d\uff0c\u8ba9\u6211\u4eec\u5f00\u59cb\u804a\u5929\u5427\"},{\"id\":3,\"text\":\"\u55e8\uff01\u4eca\u5929\u60f3\u804a\u4e9b\u4ec0\u4e48\uff1f\"},{\"id\":4,\"text\":\"\u6b22\u8fce\u56de\u6765\uff0c\u968f\u65f6\u5f00\u59cb\u5427\"},{\"id\":5,\"text\":\"\u6b22\u8fce\u56de\u6765\uff0c\u60f3\u4ece\u54ea\u91cc\u5f00\u59cb\uff1f\"},{\"id\":6,\"text\":\"\u65e9\u4e0a\u597d\uff0c\u4eca\u5929\u6709\u4ec0\u4e48\u8ba1\u5212\uff1f\"},{\"id\":7,\"text\":\"\u65e9\u4e0a\u597d\uff0c\u4eca\u5929\u60f3\u505a\u70b9\u4ec0\u4e48\uff1f\"},{\"id\":8,\"text\":\"\u65e9\u4e0a\u597d\uff0c\u5f00\u59cb\u804a\u5929\u5427\"},{\"id\":9,\"text\":\"\u65e9\u4e0a\u597d\uff0c\u4eca\u5929\u60f3\u804a\u4e9b\u4ec0\u4e48\uff1f\"},{\"id\":10,\"text\":\"\u4e0b\u5348\u597d\uff0c\u6211\u80fd\u5e2e\u4ec0\u4e48\u5fd9\u5417\uff1f\"},{\"id\":11,\"text\":\"\u665a\u4e0a\u597d\uff0c\u6709\u4ec0\u4e48\u6211\u80fd\u5e2e\u4f60\u7684\u5417\uff1f\"}],\"time_config\":[{\"start\":360,\"end\":660,\"use\":[0,1,2,3,4,5,6,7,8,9]},{\"start\":780,\"end\":1050,\"use\":[0,1,2,3,4,5,10]},{\"start\":1050,\"end\":1320,\"use\":[0,1,2,3,4,5,11]}],\"fallback_message\":[0,1,2,3,4,5]}"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->DEF:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apply(Landroid/content/Context;Ljava/lang/String;)Z
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->find(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "s"

    invoke-static {p0, v0, p1, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x1

    return v0
.end method

.method public static build(Ljava/util/List;)Ljava/lang/String;
    .registers 11

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->sRoot:Lorg/json/JSONObject;

    if-nez v0, :cond_b

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->sRoot:Lorg/json/JSONObject;

    :cond_b
    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    const/4 v3, 0x0

    :goto_16
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v4

    if-ge v3, v4, :cond_52

    invoke-interface {p0, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, [Ljava/lang/String;

    if-eqz v4, :cond_4f

    const/4 v5, 0x0

    aget-object v5, v4, v5

    const/4 v6, 0x1

    aget-object v6, v4, v6

    if-eqz v6, :cond_4f

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-nez v7, :cond_4f

    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V

    const-string v8, "id"

    invoke-static {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v9

    invoke-virtual {v7, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v8, "text"

    invoke-virtual {v7, v8, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-virtual {v1, v7}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    invoke-static {v9}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v2, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_4f
    add-int/lit8 v3, v3, 0x1

    goto :goto_16

    :cond_52
    const-string v3, "messages"

    invoke-virtual {v0, v3, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->fix(Lorg/json/JSONObject;Ljava/util/List;)V

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static display(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->get(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_b

    return-object v0

    :cond_b
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->read(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_16

    return-object v0

    :cond_16
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->DEF:Ljava/lang/String;

    return-object v0
.end method

.method public static find(Landroid/content/Context;)Ljava/lang/String;
    .registers 6

    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "kv_remote_settings_welcome_msg"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "kv_remote_settings_welcome_msg_v1"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "welcome_msg"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "kv_welcome_msg"

    aput-object v2, v0, v1

    const/4 v1, 0x0

    :goto_18
    array-length v2, v0

    if-ge v1, v2, :cond_2d

    aget-object v2, v0, v1

    const-string v3, "s"

    invoke-static {p0, v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_2a

    return-object v2

    :cond_2a
    add-int/lit8 v1, v1, 0x1

    goto :goto_18

    :cond_2d
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->scan(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static fix(Lorg/json/JSONObject;Ljava/util/List;)V
    .registers 8

    const-string v0, "time_config"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    if-eqz v0, :cond_27

    const/4 v1, 0x0

    :goto_9
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v1, v2, :cond_27

    invoke-virtual {v0, v1}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    if-eqz v2, :cond_24

    const-string v3, "use"

    const-string v4, "use"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v4

    invoke-static {v4, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->flt(Lorg/json/JSONArray;Ljava/util/List;)Lorg/json/JSONArray;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_24
    add-int/lit8 v1, v1, 0x1

    goto :goto_9

    :cond_27
    const-string v0, "fallback_message"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v1

    invoke-static {v1, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->flt(Lorg/json/JSONArray;Ljava/util/List;)Lorg/json/JSONArray;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    return-void
.end method

.method static flt(Lorg/json/JSONArray;Ljava/util/List;)Lorg/json/JSONArray;
    .registers 8

    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz p0, :cond_2a

    const/4 v2, 0x0

    :goto_d
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_2a

    invoke-virtual {p0, v2}, Lorg/json/JSONArray;->optInt(I)I

    move-result v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    invoke-interface {p1, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_27

    invoke-virtual {v0, v3}, Lorg/json/JSONArray;->put(I)Lorg/json/JSONArray;

    :cond_27
    add-int/lit8 v2, v2, 0x1

    goto :goto_d

    :cond_2a
    const/4 v2, 0x0

    :goto_2b
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v3

    if-ge v2, v3, :cond_47

    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_44

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v0, v4}, Lorg/json/JSONArray;->put(I)Lorg/json/JSONArray;

    :cond_44
    add-int/lit8 v2, v2, 0x1

    goto :goto_2b

    :cond_47
    return-object v0
.end method

.method public static get(Landroid/content/Context;)Ljava/lang/String;
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static has(Ljava/lang/String;)Z
    .registers 3

    const/4 v0, 0x0

    if-eqz p0, :cond_c

    const-string v1, "\"time_config\""

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_c

    const/4 v0, 0x1

    :cond_c
    return v0
.end method

.method public static items(Landroid/content/Context;)Ljava/util/List;
    .registers 9

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->display(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->sRoot:Lorg/json/JSONObject;

    :try_start_c
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->sRoot:Lorg/json/JSONObject;
    :try_end_13
    .catch Lorg/json/JSONException; {:try_start_c .. :try_end_13} :catch_14

    goto :goto_16

    :catch_14
    move-exception v2

    return-object v0

    :goto_16
    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->sRoot:Lorg/json/JSONObject;

    const-string v3, "messages"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-eqz v2, :cond_4c

    const/4 v3, 0x0

    :goto_21
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_4c

    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    if-eqz v4, :cond_49

    const/4 v5, 0x2

    new-array v6, v5, [Ljava/lang/String;

    const/4 v5, 0x0

    const-string v7, "id"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v7

    invoke-static {v7}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v6, v5

    const/4 v5, 0x1

    const-string v7, "text"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v6, v5

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_49
    add-int/lit8 v3, v3, 0x1

    goto :goto_21

    :cond_4c
    return-object v0
.end method

.method public static put(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->KEY:Ljava/lang/String;

    const-string v1, "s"

    invoke-static {p0, v0, p1, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static read(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->find(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static reapply(Landroid/content/Context;)Z
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->get(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_24

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->MK:Ljava/lang/String;

    const-string v2, "s"

    invoke-static {p0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_24

    const-string v3, "s"

    invoke-static {p0, v1, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const-string v3, "s"

    invoke-static {p0, v1, v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x1

    return v0

    :cond_24
    const/4 v0, 0x0

    return v0
.end method

.method public static restore(Landroid/content/Context;)V
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->find(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "s"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->restore(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->KEY:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static scan(Landroid/content/Context;)Ljava/lang/String;
    .registers 6

    :try_start_0
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "allKeys"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_18
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_33

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmHello;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_18

    return-object v2
    :try_end_33
    .catchall {:try_start_0 .. :try_end_33} :catchall_34

    :cond_33
    goto :goto_35

    :catchall_34
    move-exception v0

    :goto_35
    const-string v0, "kv_remote_settings_welcome_msg"

    return-object v0
.end method

.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;
.super Ljava/lang/Object;
.source "FdmPush.java"


# static fields
.field public static final ACTION_APPLIED:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_APPLIED"

.field public static final ACTION_CMD:Ljava/lang/String; = "com.little_femaleboy.fdm.CMD"

.field public static final ACTION_PUSH:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_PUSH"

.field public static final ACTION_REQ:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_REQ"

.field public static final ACTION_RESULT:Ljava/lang/String; = "com.little_femaleboy.fdm.CMD_RESULT"

.field public static final ACTION_STATE:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_STATE"

.field public static final HOST_PREFIX:Ljava/lang/String; = "host."

.field private static final SP:Ljava/lang/String; = "fdm_ui"

.field private static final TAG:Ljava/lang/String; = "FDM-DIAG"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 67
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 299
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    :goto_8
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1e

    .line 300
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 301
    invoke-virtual {p1, v2}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {p0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    add-int/lit8 v0, v0, 0x1

    goto :goto_8

    :cond_1e
    return v0
.end method

.method public static hostValue(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    .line 91
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "host."

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static push(Landroid/content/Context;)I
    .registers 22

    move-object/from16 v1, p0

    .line 119
    const-string v2, "rev"

    const-string v3, "FDM-DIAG"

    :try_start_6
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    .line 120
    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V

    new-instance v8, Lorg/json/JSONObject;

    invoke-direct {v8}, Lorg/json/JSONObject;-><init>()V

    .line 122
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v12

    .line 138
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 139
    invoke-interface {v12}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :cond_34
    :goto_34
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-eqz v10, :cond_58

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/util/Map$Entry;

    .line 140
    invoke-interface {v10}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Ljava/lang/String;

    if-eqz v11, :cond_34

    .line 141
    const-string v13, "fuckds_"

    invoke-virtual {v11, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_34

    invoke-interface {v10}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v10

    invoke-interface {v0, v11, v10}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_34

    .line 144
    :cond_58
    new-instance v13, Ljava/util/HashSet;

    invoke-direct {v13}, Ljava/util/HashSet;-><init>()V

    .line 145
    invoke-interface {v12}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v14

    const/16 v16, 0x0

    :cond_6b
    :goto_6b
    invoke-interface {v14}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-eqz v9, :cond_c6

    invoke-interface {v14}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/util/Map$Entry;

    .line 146
    invoke-interface {v9}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/String;

    if-eqz v10, :cond_6b

    .line 147
    const-string v11, "cfg.fuckds_"

    invoke-virtual {v10, v11}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_88

    goto :goto_6b

    :cond_88
    const/4 v11, 0x4

    .line 148
    invoke-virtual {v10, v11}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v10

    .line 149
    const-string v11, ".at"

    invoke-virtual {v10, v11}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_6b

    const-string v11, ".ok"

    invoke-virtual {v10, v11}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_9e

    goto :goto_6b

    .line 150
    :cond_9e
    invoke-interface {v9}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v9

    .line 151
    instance-of v11, v9, Ljava/lang/String;

    if-nez v11, :cond_a7

    goto :goto_6b

    .line 152
    :cond_a7
    check-cast v9, Ljava/lang/String;

    .line 153
    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v11

    if-nez v11, :cond_b3

    invoke-interface {v13, v10}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_6b

    .line 154
    :cond_b3
    invoke-interface {v0, v10}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v11

    move-object/from16 v20, v10

    move-object v10, v9

    move-object/from16 v9, v20

    .line 155
    invoke-static/range {v4 .. v11}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->putTyped(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)I

    move-result v10

    add-int v16, v16, v10

    .line 156
    invoke-interface {v13, v9}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_6b

    .line 160
    :cond_c6
    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v11

    :goto_ce
    invoke-interface {v11}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-eqz v9, :cond_fb

    invoke-interface {v11}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/util/Map$Entry;

    .line 161
    invoke-interface {v9}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v10

    invoke-interface {v13, v10}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_e5

    goto :goto_ce

    .line 162
    :cond_e5
    invoke-interface {v9}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/String;

    invoke-interface {v9}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v9

    move-object/from16 v20, v10

    move-object v10, v9

    move-object/from16 v9, v20

    invoke-static/range {v4 .. v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->putAuto(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/Object;)I

    move-result v9
    :try_end_f8
    .catchall {:try_start_6 .. :try_end_f8} :catchall_2ad

    add-int v16, v16, v9

    goto :goto_ce

    :cond_fb
    const/4 v9, 0x0

    .line 177
    :try_start_fc
    invoke-interface {v13}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v10

    move-object v11, v9

    const/4 v13, 0x0

    :cond_102
    :goto_102
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v14

    if-eqz v14, :cond_120

    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/String;

    .line 178
    invoke-interface {v0, v14}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v17

    if-eqz v17, :cond_102

    if-nez v11, :cond_11a

    .line 179
    invoke-interface {v12}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 180
    :cond_11a
    invoke-interface {v11, v14}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v13, v13, 0x1

    goto :goto_102

    :cond_120
    if-eqz v11, :cond_145

    .line 185
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "\ud83e\uddf9 \u6e05\u7406\u8fc1\u79fb\u9057\u7559\u7684\u65e7\u683c\u5f0f\u952e "

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " \u4e2a\uff08\u65b0\u683c\u5f0f\u5df2\u6709\u503c\uff09"

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_13e
    .catchall {:try_start_fc .. :try_end_13e} :catchall_13f

    goto :goto_145

    :catchall_13f
    move-exception v0

    .line 189
    :try_start_140
    const-string v10, "\u6e05\u7406\u65e7\u683c\u5f0f\u952e\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u63a8\u9001\uff09"

    invoke-static {v3, v10, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 192
    :cond_145
    :goto_145
    invoke-virtual {v1, v9}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    if-nez v0, :cond_14c

    goto :goto_153

    .line 193
    :cond_14c
    new-instance v9, Ljava/io/File;

    const-string v10, "fdm-config.json"

    invoke-direct {v9, v0, v10}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_end_153
    .catchall {:try_start_140 .. :try_end_153} :catchall_2ad

    .line 194
    :goto_153
    const-string v0, "strings"

    const-string v11, "floats"

    const-string v13, "longs"

    const-string v14, "ints"

    const-string v10, "bools"

    if-eqz v9, :cond_1fb

    :try_start_15f
    invoke-virtual {v9}, Ljava/io/File;->isFile()Z

    move-result v17

    if-eqz v17, :cond_1fb

    .line 195
    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->readText(Ljava/io/File;)Ljava/lang/String;

    move-result-object v15

    move-object/from16 v18, v4

    .line 196
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v19, v5

    const-string v5, "\u8bfb\u5230\u5916\u90e8\u914d\u7f6e "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, "\uff08"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v15, :cond_183

    const/4 v5, 0x0

    goto :goto_187

    :cond_183
    invoke-virtual {v15}, Ljava/lang/String;->length()I

    move-result v5

    :goto_187
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u5b57\u7b26\uff09"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v15, :cond_23a

    .line 197
    invoke-virtual {v15}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_23a

    .line 198
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v15}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 199
    invoke-virtual {v4, v10}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_1ff

    invoke-virtual {v4, v14}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_1ff

    invoke-virtual {v4, v13}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_1ff

    .line 200
    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_1ff

    invoke-virtual {v4, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1c6

    goto :goto_1ff

    .line 207
    :cond_1c6
    invoke-virtual {v4}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v15

    :goto_1ca
    invoke-interface {v15}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1f7

    .line 208
    invoke-interface {v15}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    move-object v9, v5

    check-cast v9, Ljava/lang/String;

    move-object v5, v10

    .line 209
    invoke-virtual {v4, v9}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v10
    :try_end_1dc
    .catchall {:try_start_15f .. :try_end_1dc} :catchall_23f

    move-object/from16 v17, v15

    move-object v15, v4

    move-object/from16 v4, v18

    move-object/from16 v18, v3

    move-object v3, v5

    move-object/from16 v5, v19

    :try_start_1e6
    invoke-static/range {v4 .. v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->putAuto(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/Object;)I

    move-result v9

    add-int v16, v16, v9

    move-object v10, v3

    move-object/from16 v19, v5

    move-object/from16 v3, v18

    move-object/from16 v18, v4

    move-object v4, v15

    move-object/from16 v15, v17

    goto :goto_1ca

    :cond_1f7
    move-object/from16 v4, v18

    move-object/from16 v5, v19

    :cond_1fb
    :goto_1fb
    move-object/from16 v18, v3

    move-object v3, v10

    goto :goto_243

    :cond_1ff
    :goto_1ff
    move-object v15, v4

    move-object/from16 v4, v18

    move-object/from16 v5, v19

    move-object/from16 v18, v3

    move-object v3, v10

    .line 201
    invoke-virtual {v15, v3}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v4, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I

    move-result v9

    add-int v16, v16, v9

    .line 202
    invoke-virtual {v15, v14}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v5, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I

    move-result v9

    add-int v16, v16, v9

    .line 203
    invoke-virtual {v15, v13}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v6, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I

    move-result v9

    add-int v16, v16, v9

    .line 204
    invoke-virtual {v15, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v7, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I

    move-result v9

    add-int v16, v16, v9

    .line 205
    invoke-virtual {v15, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v8, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->copyInto(Lorg/json/JSONObject;Lorg/json/JSONObject;)I

    move-result v9

    add-int v16, v16, v9

    goto :goto_243

    :cond_23a
    move-object/from16 v4, v18

    move-object/from16 v5, v19

    goto :goto_1fb

    :catchall_23f
    move-exception v0

    move-object/from16 v18, v3

    goto :goto_2aa

    :goto_243
    move/from16 v9, v16

    .line 215
    new-instance v10, Lorg/json/JSONObject;

    invoke-direct {v10}, Lorg/json/JSONObject;-><init>()V

    const/4 v15, 0x1

    move/from16 v16, v9

    .line 216
    invoke-interface {v12, v2, v15}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v9

    invoke-virtual {v10, v2, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 217
    invoke-virtual {v10, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 218
    invoke-virtual {v10, v14, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 219
    invoke-virtual {v10, v13, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 220
    invoke-virtual {v10, v11, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 221
    invoke-virtual {v10, v0, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 223
    new-instance v0, Landroid/content/Intent;

    const-string v3, "com.little_femaleboy.fdm.CONFIG_PUSH"

    invoke-direct {v0, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 224
    invoke-interface {v12, v2, v15}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v3

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 225
    const-string v2, "json"

    invoke-virtual {v10}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 227
    const-string v2, "bridge_token"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->ensureToken(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 228
    invoke-virtual {v1, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 229
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5df2\u63a8\u9001\u914d\u7f6e\uff08"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v1, v16

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u9879\uff09\uff1a"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_2a1
    .catchall {:try_start_1e6 .. :try_end_2a1} :catchall_2a9

    move-object/from16 v2, v18

    :try_start_2a3
    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2a6
    .catchall {:try_start_2a3 .. :try_end_2a6} :catchall_2a7

    return v1

    :catchall_2a7
    move-exception v0

    goto :goto_2af

    :catchall_2a9
    move-exception v0

    :goto_2aa
    move-object/from16 v2, v18

    goto :goto_2af

    :catchall_2ad
    move-exception v0

    move-object v2, v3

    .line 232
    :goto_2af
    const-string v1, "\u63a8\u9001\u914d\u7f6e\u5931\u8d25"

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const/4 v0, -0x1

    return v0
.end method

.method private static putAuto(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/Object;)I
    .registers 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p5, :cond_41

    .line 279
    const-string v1, "fuckds_"

    invoke-virtual {p5, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_41

    if-nez p6, :cond_e

    goto :goto_41

    .line 280
    :cond_e
    instance-of v1, p6, Ljava/lang/Boolean;

    if-eqz v1, :cond_18

    .line 281
    check-cast p6, Ljava/lang/Boolean;

    invoke-virtual {p0, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_3f

    .line 282
    :cond_18
    instance-of p0, p6, Ljava/lang/Integer;

    if-eqz p0, :cond_22

    .line 283
    check-cast p6, Ljava/lang/Integer;

    invoke-virtual {p1, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_3f

    .line 284
    :cond_22
    instance-of p0, p6, Ljava/lang/Long;

    if-eqz p0, :cond_2c

    .line 285
    check-cast p6, Ljava/lang/Long;

    invoke-virtual {p2, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_3f

    .line 286
    :cond_2c
    instance-of p0, p6, Ljava/lang/Float;

    if-eqz p0, :cond_36

    .line 287
    check-cast p6, Ljava/lang/Float;

    invoke-virtual {p3, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    goto :goto_3f

    .line 288
    :cond_36
    instance-of p0, p6, Ljava/lang/String;

    if-eqz p0, :cond_41

    .line 289
    check-cast p6, Ljava/lang/String;

    invoke-virtual {p4, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_3f
    const/4 p0, 0x1

    return p0

    :cond_41
    :goto_41
    return v0
.end method

.method private static putTyped(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)I
    .registers 14
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 252
    invoke-virtual {p6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    .line 254
    :try_start_5
    instance-of v2, p7, Ljava/lang/Boolean;

    const/4 v3, 0x0

    if-eqz v2, :cond_1d

    .line 255
    invoke-static {v0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_18

    const-string p1, "1"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_19

    :cond_18
    move v3, v1

    :cond_19
    invoke-virtual {p0, p5, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    return v1

    .line 257
    :cond_1d
    instance-of v2, p7, Ljava/lang/Long;

    if-eqz v2, :cond_29

    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide p0

    invoke-virtual {p2, p5, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    return v1

    .line 258
    :cond_29
    instance-of v2, p7, Ljava/lang/Float;

    if-nez v2, :cond_7e

    instance-of v2, p7, Ljava/lang/Double;

    if-eqz v2, :cond_32

    goto :goto_7e

    .line 261
    :cond_32
    instance-of p3, p7, Ljava/lang/Integer;

    if-eqz p3, :cond_3e

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    invoke-virtual {p1, p5, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    return v1

    .line 264
    :cond_3e
    const-string p3, "true"

    invoke-virtual {p3, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_4a

    invoke-virtual {p0, p5, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    return v1

    .line 265
    :cond_4a
    const-string p3, "false"

    invoke-virtual {p3, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_56

    invoke-virtual {p0, p5, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    return v1

    .line 266
    :cond_56
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    .line 267
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const-wide/32 v4, -0x80000000

    cmp-long p3, v2, v4

    if-ltz p3, :cond_7a

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const-wide/32 v4, 0x7fffffff

    cmp-long p3, v2, v4

    if-gtz p3, :cond_7a

    invoke-virtual {p0}, Ljava/lang/Long;->intValue()I

    move-result p0

    invoke-virtual {p1, p5, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    goto :goto_7d

    .line 268
    :cond_7a
    invoke-virtual {p2, p5, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :goto_7d
    return v1

    .line 259
    :cond_7e
    :goto_7e
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result p0

    float-to-double p0, p0

    invoke-virtual {p3, p5, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;
    :try_end_86
    .catchall {:try_start_5 .. :try_end_86} :catchall_87

    return v1

    .line 271
    :catchall_87
    invoke-virtual {p4, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    return v1
.end method

.method private static readText(Ljava/io/File;)Ljava/lang/String;
    .registers 7

    const/4 v0, 0x0

    .line 310
    :try_start_1
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_6
    .catchall {:try_start_1 .. :try_end_6} :catchall_2e

    .line 311
    :try_start_6
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/32 v4, 0x100000

    invoke-static {v2, v3, v4, v5}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v2

    long-to-int p0, v2

    new-array p0, p0, [B

    .line 312
    invoke-virtual {v1, p0}, Ljava/io/FileInputStream;->read([B)I

    move-result v2

    if-gtz v2, :cond_1d

    .line 313
    const-string p0, ""

    goto :goto_2a

    :cond_1d
    new-instance v3, Ljava/lang/String;

    const-string v4, "UTF-8"

    invoke-static {v4}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v4

    const/4 v5, 0x0

    invoke-direct {v3, p0, v5, v2, v4}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V
    :try_end_29
    .catchall {:try_start_6 .. :try_end_29} :catchall_2f

    move-object p0, v3

    .line 318
    :goto_2a
    :try_start_2a
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_2d
    .catchall {:try_start_2a .. :try_end_2d} :catchall_2d

    :catchall_2d
    return-object p0

    :catchall_2e
    move-object v1, v0

    :catchall_2f
    if-eqz v1, :cond_34

    :try_start_31
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_34
    .catchall {:try_start_31 .. :try_end_34} :catchall_34

    :catchall_34
    :cond_34
    return-object v0
.end method

.method public static saveHostState(Landroid/content/Context;Ljava/lang/String;)I
    .registers 8

    .line 72
    const-string v0, "FDM-DIAG"

    const/4 v1, 0x0

    .line 74
    :try_start_3
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 75
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 76
    invoke-virtual {v2}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object p1

    :goto_14
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3f

    .line 77
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 78
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "host."

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {p0, v4, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v1, v1, 0x1

    goto :goto_14

    .line 81
    :cond_3f
    const-string p1, "host.at"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-interface {p0, p1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 82
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "\u5df2\u8bb0\u4e0b\u5bbf\u4e3b\u771f\u503c "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u4e2a\u952e"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_65
    .catchall {:try_start_3 .. :try_end_65} :catchall_66

    return v1

    :catchall_66
    move-exception p0

    .line 84
    const-string p1, "\u89e3\u6790\u5bbf\u4e3b\u72b6\u6001\u5931\u8d25"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return v1
.end method

.method public static sendCmd(Landroid/content/Context;Ljava/lang/String;Ljava/lang/Object;)V
    .registers 8

    .line 48
    const-string v0, "FDM-DIAG"

    .line 0
    const-string v1, "\u2192 \u52a8\u4f5c "

    .line 48
    :try_start_4
    new-instance v2, Landroid/content/Intent;

    const-string v3, "com.little_femaleboy.fdm.CMD"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 49
    const-string v3, "cmd"

    invoke-virtual {v2, v3, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 50
    instance-of v3, p2, Ljava/lang/Boolean;
    :try_end_12
    .catchall {:try_start_4 .. :try_end_12} :catchall_57

    const-string v4, "arg"

    if-eqz v3, :cond_1d

    .line 51
    :try_start_16
    move-object v3, p2

    check-cast v3, Ljava/lang/Boolean;

    invoke-virtual {v2, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    goto :goto_33

    .line 52
    :cond_1d
    instance-of v3, p2, Ljava/lang/Integer;

    if-eqz v3, :cond_28

    .line 53
    move-object v3, p2

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v2, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    goto :goto_33

    :cond_28
    if-nez p2, :cond_2c

    const/4 v3, 0x0

    goto :goto_30

    .line 55
    :cond_2c
    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    :goto_30
    invoke-virtual {v2, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 57
    :goto_33
    const-string v3, "pkg"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 58
    invoke-virtual {p0, v2}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 59
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " arg="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_56
    .catchall {:try_start_16 .. :try_end_56} :catchall_57

    return-void

    :catchall_57
    move-exception p0

    .line 61
    const-string p1, "\u53d1\u52a8\u4f5c\u5931\u8d25"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method public static set(Landroid/content/Context;Ljava/lang/String;Ljava/lang/Object;)V
    .registers 6

    .line 96
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 97
    instance-of v1, p2, Ljava/lang/Boolean;

    if-eqz v1, :cond_16

    .line 98
    check-cast p2, Ljava/lang/Boolean;

    invoke-virtual {p2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p2

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    goto :goto_47

    .line 99
    :cond_16
    instance-of v1, p2, Ljava/lang/Integer;

    if-eqz v1, :cond_24

    .line 100
    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    goto :goto_47

    .line 101
    :cond_24
    instance-of v1, p2, Ljava/lang/Long;

    if-eqz v1, :cond_32

    .line 102
    check-cast p2, Ljava/lang/Long;

    invoke-virtual {p2}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    invoke-interface {v0, p1, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    goto :goto_47

    .line 103
    :cond_32
    instance-of v1, p2, Ljava/lang/Float;

    if-eqz v1, :cond_40

    .line 104
    check-cast p2, Ljava/lang/Float;

    invoke-virtual {p2}, Ljava/lang/Float;->floatValue()F

    move-result p2

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    goto :goto_47

    .line 106
    :cond_40
    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 108
    :goto_47
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 109
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I

    return-void
.end method

.method public static sp(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 3

    .line 113
    const-string v0, "fdm_ui"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

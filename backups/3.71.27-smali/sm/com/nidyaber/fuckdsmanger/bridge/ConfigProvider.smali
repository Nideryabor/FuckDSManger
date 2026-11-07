.class public final Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;
.super Landroid/content/ContentProvider;
.source "ConfigProvider.java"


# static fields
.field public static final AUTHORITY_SUFFIX:Ljava/lang/String; = ".config"

.field public static final KEY_APPLIED_REV:Ljava/lang/String; = "applied_rev"

.field public static final KEY_HOST_AT:Ljava/lang/String; = "host_at"

.field public static final KEY_HOST_VER:Ljava/lang/String; = "host_ver"

.field public static final KEY_JSON:Ljava/lang/String; = "json"

.field public static final KEY_REV:Ljava/lang/String; = "rev"

.field public static final KEY_TOKEN:Ljava/lang/String; = "bridge_token"

.field public static final KEY_TRUSTED_UID:Ljava/lang/String; = "trusted_uid"

.field public static final PREFS:Ljava/lang/String; = "fdm_ui"

.field private static final TAG:Ljava/lang/String; = "FdmConfig"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 32
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    return-void
.end method

.method private callerAllowed(Landroid/os/Bundle;)Z
    .registers 9

    .line 74
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v0

    .line 75
    invoke-static {}, Landroid/os/Process;->myUid()I

    move-result v1

    const/4 v2, 0x1

    if-ne v0, v1, :cond_c

    return v2

    :cond_c
    if-eqz v0, :cond_6b

    const/16 v1, 0x3e8

    if-ne v0, v1, :cond_13

    goto :goto_6b

    .line 77
    :cond_13
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->getContext()Landroid/content/Context;

    move-result-object p0

    const/4 v1, 0x0

    if-nez p0, :cond_1b

    return v1

    .line 79
    :cond_1b
    const-string v3, "fdm_ui"

    invoke-virtual {p0, v3, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 80
    const-string v3, "bridge_token"

    const/4 v4, 0x0

    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_6a

    .line 81
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_31

    goto :goto_6a

    :cond_31
    if-nez p1, :cond_34

    goto :goto_38

    .line 82
    :cond_34
    invoke-virtual {p1, v3}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 83
    :goto_38
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_3f

    return v1

    .line 84
    :cond_3f
    const-string p1, "trusted_uid"

    const/4 v3, -0x1

    invoke-interface {p0, p1, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    if-ne v4, v3, :cond_67

    .line 86
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 87
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "trusted uid recorded = "

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "FdmConfig"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :cond_67
    if-ne v4, v0, :cond_6a

    return v2

    :cond_6a
    :goto_6a
    return v1

    :cond_6b
    :goto_6b
    return v2
.end method

.method public static ensureToken(Landroid/content/Context;)Ljava/lang/String;
    .registers 5

    .line 56
    const-string v0, "fdm_ui"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const/4 v0, 0x0

    .line 57
    const-string v1, "bridge_token"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_18

    .line 58
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_17

    goto :goto_18

    :cond_17
    return-object v0

    .line 59
    :cond_18
    :goto_18
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "-"

    const-string v3, ""

    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    .line 60
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-object v0
.end method

.method public static uriOf(Landroid/content/Context;)Landroid/net/Uri;
    .registers 3

    .line 51
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "content://"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ".config"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public call(Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;
    .registers 11

    .line 102
    new-instance p2, Landroid/os/Bundle;

    invoke-direct {p2}, Landroid/os/Bundle;-><init>()V

    .line 103
    invoke-direct {p0, p3}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->callerAllowed(Landroid/os/Bundle;)Z

    move-result v0

    const-string v1, "FdmConfig"

    const-string v2, "error"

    const/4 v3, 0x0

    const-string v4, "ok"

    if-nez v0, :cond_48

    .line 104
    invoke-virtual {p2, v4, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 105
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "caller not trusted: uid="

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result p3

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, v2, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 106
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "rejected "

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " from uid="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object p2

    .line 110
    :cond_48
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->getContext()Landroid/content/Context;

    move-result-object p0

    if-nez p0, :cond_57

    .line 112
    invoke-virtual {p2, v4, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 113
    const-string p0, "no context"

    invoke-virtual {p2, v2, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    return-object p2

    .line 116
    :cond_57
    const-string v0, "fdm_ui"

    invoke-virtual {p0, v0, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 118
    const-string v0, "getConfig"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v5, "rev"

    const/4 v6, 0x1

    if-eqz v0, :cond_7f

    .line 119
    invoke-virtual {p2, v4, v6}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 120
    invoke-interface {p0, v5, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    invoke-virtual {p2, v5, p3}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 121
    const-string p3, "{}"

    const-string v0, "json"

    invoke-interface {p0, v0, p3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, v0, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_f3

    .line 122
    :cond_7f
    const-string v0, "heartbeat"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_ad

    .line 123
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "host_at"

    .line 124
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-interface {p0, v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 125
    const-string v0, "?"

    if-nez p3, :cond_9a

    goto :goto_a0

    :cond_9a
    const-string v2, "version"

    invoke-virtual {p3, v2, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_a0
    const-string p3, "host_ver"

    invoke-interface {p0, p3, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 126
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 127
    invoke-virtual {p2, v4, v6}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    goto :goto_f3

    .line 128
    :cond_ad
    const-string v0, "applied"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_df

    const/4 v0, -0x1

    if-nez p3, :cond_b9

    goto :goto_bd

    .line 129
    :cond_b9
    invoke-virtual {p3, v5, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 130
    :goto_bd
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p3, "applied_rev"

    invoke-interface {p0, p3, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 131
    invoke-virtual {p2, v4, v6}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 132
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "applied rev="

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_f3

    .line 134
    :cond_df
    invoke-virtual {p2, v4, v3}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 135
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "unknown method: "

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, v2, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 137
    :goto_f3
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "call "

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " \u2192 "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p2
.end method

.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 4

    const/4 p0, 0x0

    return p0
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .registers 2

    const/4 p0, 0x0

    return-object p0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .registers 3

    const/4 p0, 0x0

    return-object p0
.end method

.method public onCreate()Z
    .registers 3

    .line 95
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "ConfigProvider.onCreate \u2705 authority="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 96
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->getContext()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_10

    const-string p0, "?"

    goto :goto_18

    :cond_10
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/ConfigProvider;->uriOf(Landroid/content/Context;)Landroid/net/Uri;

    move-result-object p0

    :goto_18
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 95
    const-string v0, "FdmConfig"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .registers 6

    const/4 p0, 0x0

    return-object p0
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 5

    const/4 p0, 0x0

    return p0
.end method

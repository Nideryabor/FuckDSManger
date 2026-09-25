.class public final Lcom/nidyaber/fuckdsmanger/gm/GmRevokeHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmRevokeHook.java"


# static fields
.field static sLast:J


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static asList(Ljava/lang/Object;)Ljava/util/List;
    .registers 5

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    :cond_4
    :try_start_4
    instance-of v1, p0, Ljava/util/List;

    if-eqz v1, :cond_b

    check-cast p0, Ljava/util/List;

    return-object p0

    :cond_b
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "j"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    invoke-static {p0, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    instance-of v2, v1, Ljava/util/List;

    if-nez v2, :cond_1e

    const/4 v1, 0x0

    return-object v1

    :cond_1e
    check-cast v1, Ljava/util/List;
    :try_end_20
    .catchall {:try_start_4 .. :try_end_20} :catchall_21

    return-object v1

    :catchall_21
    move-exception v1

    return-object v0
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 14

    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sget-wide v8, Lcom/nidyaber/fuckdsmanger/gm/GmRevokeHook;->sLast:J

    sub-long/2addr v6, v8

    const-wide/16 v8, 0xbb8

    cmp-long v10, v6, v8

    if-ltz v10, :cond_42

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sput-wide v6, Lcom/nidyaber/fuckdsmanger/gm/GmRevokeHook;->sLast:J

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_42

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_42

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRevokeHook;->asList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_42

    const-string v2, "chat"

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_2e
    :goto_2e
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_42

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_2e

    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v2, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->save(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2e
    :try_end_42
    .catchall {:try_start_0 .. :try_end_42} :catchall_43

    :cond_42
    return-void

    :catchall_43
    move-exception v0

    return-void
.end method

.class public final Lcom/varuns2002/disable_flag_secure/gm/GmRevokeHook;
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


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 14

    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sget-wide v8, Lcom/varuns2002/disable_flag_secure/gm/GmRevokeHook;->sLast:J

    sub-long/2addr v6, v8

    const-wide/16 v8, 0xbb8

    cmp-long v10, v6, v8

    if-ltz v10, :cond_40

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sput-wide v6, Lcom/varuns2002/disable_flag_secure/gm/GmRevokeHook;->sLast:J

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_40

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDb;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_40

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    check-cast v1, Ljava/util/List;

    if-eqz v1, :cond_40

    const-string v2, "chat"

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_2c
    :goto_2c
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_40

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_2c

    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v2, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmDb;->save(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2c
    :try_end_40
    .catchall {:try_start_0 .. :try_end_40} :catchall_41

    :cond_40
    return-void

    :catchall_41
    move-exception v0

    return-void
.end method

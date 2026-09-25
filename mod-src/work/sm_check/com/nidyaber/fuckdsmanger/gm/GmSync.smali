.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSync;
.super Ljava/lang/Object;
.source "GmSync.java"


# static fields
.field static sDone:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static ctx()Landroid/content/Context;
    .registers 2

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    return-object v0
.end method

.method public static ensure(Landroid/content/Context;)V
    .registers 5

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->sDone:Z

    if-nez v0, :cond_42

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->sDone:Z

    :try_start_7
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "p66"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmSyncHook;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmSyncHook;-><init>()V

    const-string v0, "h"

    invoke-static {v2, v0, v3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v2, "h02"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmSyncHook;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmSyncHook;-><init>()V

    const-string v0, "u"

    invoke-static {v2, v0, v3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v2, "com.tencent.mmkv.MMKV"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;-><init>()V

    const-string v0, "q"

    invoke-static {v2, v0, v3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v0, "sync hooks ensured"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_40
    .catchall {:try_start_7 .. :try_end_40} :catchall_41

    return-void

    :catchall_41
    move-exception v0

    :cond_42
    return-void
.end method

.method public static reapplyAll()V
    .registers 3

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->ctx()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_14

    :try_start_6
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->reapply(Landroid/content/Context;)Z

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->reapply(Landroid/content/Context;)Z

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->reapply(Landroid/content/Context;)Z

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmTts;->ensure(Landroid/content/Context;)V
    :try_end_12
    .catchall {:try_start_6 .. :try_end_12} :catchall_13

    return-void

    :catchall_13
    move-exception v1

    :cond_14
    return-void
.end method

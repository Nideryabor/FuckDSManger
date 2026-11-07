.class Lcom/nidyaber/fuckdsmanger/bridge/GmSender$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSender.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 259
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 263
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz p0, :cond_e

    .line 265
    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecent:Ljava/lang/Object;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$102(Ljava/lang/Object;)Ljava/lang/Object;

    .line 266
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sRecentAt:J
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$202(J)J
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_e

    :catchall_e
    :cond_e
    return-void
.end method

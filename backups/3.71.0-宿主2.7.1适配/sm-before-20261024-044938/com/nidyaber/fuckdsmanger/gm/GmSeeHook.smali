.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSeeHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSeeHook.java"


# static fields
.field static sLast:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    :try_start_0
    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_c

    check-cast v0, Ljava/lang/String;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSeeHook;->sLast:Ljava/lang/String;

    :cond_c
    return-void
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_d

    :catchall_d
    move-exception v0

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    const-string v0, "chat.in"

    const-string v1, "[\u5efa\u8bae] \u5fc3\u8df3\uff1a\u804a\u5929\u8f93\u5165\u533a\u5728\u6e32\u67d3\uff08yp1.b \u547d\u4e2d\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v0, :cond_d

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sYp1:Ljava/lang/Object;
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    :cond_d
    return-void

    :catchall_e
    move-exception v0

    return-void
.end method

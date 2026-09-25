.class public final Lcom/nidyaber/fuckdsmanger/gm/GmTraceHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmTraceHook.java"


# static fields
.field private static sTold:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmTraceHook;->sTold:Z

    if-nez v0, :cond_15

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmTraceHook;->sTold:Z

    const-string v0, "p96.b hit"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_15

    const-string v1, "Trace p96.b \u5df2\u8fdb\u5165"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_15
    return-void
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_16

    :catchall_16
    move-exception v0

    return-void
.end method

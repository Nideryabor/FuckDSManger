.class Lcom/nidyaber/fuckdsmanger/bridge/GmNote$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmNote.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 74
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 78
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 79
    instance-of p1, p0, Landroid/app/Activity;

    if-nez p1, :cond_7

    return-void

    .line 80
    :cond_7
    check-cast p0, Landroid/app/Activity;

    .line 81
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->access$002(Landroid/content/Context;)Landroid/content/Context;

    .line 82
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sSessionClosed:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->access$100()Z

    move-result p1

    if-nez p1, :cond_21

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->enabled(Landroid/content/Context;)Z

    move-result p1

    if-nez p1, :cond_1d

    goto :goto_21

    .line 86
    :cond_1d
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->attach(Landroid/app/Activity;)V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->access$300(Landroid/app/Activity;)V

    return-void

    .line 83
    :cond_21
    :goto_21
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->detachAll()V
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->access$200()V
    :try_end_24
    .catchall {:try_start_0 .. :try_end_24} :catchall_25

    return-void

    :catchall_25
    move-exception p0

    .line 88
    const-string p1, "\u3010GmNote\u3011onResume \u5904\u7406\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

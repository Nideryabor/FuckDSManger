.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmMiniBar.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 63
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 67
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 68
    instance-of p1, p0, Landroid/app/Activity;

    if-nez p1, :cond_7

    return-void

    .line 69
    :cond_7
    check-cast p0, Landroid/app/Activity;

    .line 70
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$002(Landroid/content/Context;)Landroid/content/Context;

    .line 72
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$000()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->install(Landroid/content/Context;)V

    .line 73
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sSessionClosed:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$100()Z

    move-result p1

    if-nez p1, :cond_2c

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$000()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->enabled(Landroid/content/Context;)Z

    move-result p1

    if-nez p1, :cond_28

    goto :goto_2c

    .line 77
    :cond_28
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->attach(Landroid/app/Activity;)V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$300(Landroid/app/Activity;)V

    return-void

    .line 74
    :cond_2c
    :goto_2c
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$200()V
    :try_end_2f
    .catchall {:try_start_0 .. :try_end_2f} :catchall_30

    return-void

    :catchall_30
    move-exception p0

    .line 79
    const-string p1, "\u3010GmMiniBar\u3011onResume \u5904\u7406\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

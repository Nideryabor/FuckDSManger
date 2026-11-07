.class Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallPin.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 99
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    .line 103
    :try_start_0
    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1c

    .line 105
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->sOpened:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->access$000()Z

    move-result p0

    if-nez p0, :cond_3c

    const/4 p0, 0x1

    .line 106
    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->sOpened:Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->access$002(Z)Z

    .line 107
    const-string p0, "[\u7559\u9a7b] \u901a\u8bdd\u9875\u5df2\u6d3b\u8dc3 \u21d2 \u672c\u8fdb\u7a0b\u5185\u5f00\u59cb\u7559\u9a7b"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 113
    :cond_1c
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->sOpened:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->access$000()Z

    move-result p0

    if-nez p0, :cond_23

    goto :goto_3c

    .line 114
    :cond_23
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object p0

    if-nez p0, :cond_2a

    goto :goto_3c

    .line 116
    :cond_2a
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->on(Landroid/content/Context;)Z

    move-result p0

    if-eqz p0, :cond_3c

    .line 117
    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 118
    const-string p0, "[\u7559\u9a7b]"

    const-string p1, "\u901a\u8bdd\u9875 a()=false \u2192 \u5f3a\u5236 true\uff08\u901a\u8bdd\u9875\u7559\u9a7b\u4e2d\uff1b\u5173\u5f00\u5173\u5373\u8fd8\u539f\uff09"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_3c
    .catchall {:try_start_0 .. :try_end_3c} :catchall_3c

    :catchall_3c
    :cond_3c
    :goto_3c
    return-void
.end method

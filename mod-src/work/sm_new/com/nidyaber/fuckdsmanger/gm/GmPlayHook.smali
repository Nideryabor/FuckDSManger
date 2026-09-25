.class public final Lcom/nidyaber/fuckdsmanger/gm/GmPlayHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPlayHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "start"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_19

    const-string v3, "\u6717\u8bfb\u4e2d\u2026"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const-string v3, "[\u901a\u8bdd][TTS] \u64ad\u653e\u5f00\u59cb \u21d2 \u6717\u8bfb\u4e2d"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_27

    :cond_19
    const-string v3, "\u5f85\u673a\uff5c\u6309\u4f4f\u8bf4\u8bdd"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const-string v3, "[\u901a\u8bdd][TTS] \u64ad\u653e\u7ed3\u675f\u4e8b\u4ef6="

    invoke-virtual {v3, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_27
    .catchall {:try_start_0 .. :try_end_27} :catchall_27

    :catchall_27
    :goto_27
    return-void
.end method

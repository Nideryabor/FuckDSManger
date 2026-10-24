.class public final Lcom/nidyaber/fuckdsmanger/gm/GmAiTextHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmAiTextHook.java"


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
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_2e

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_2e

    const/4 v1, 0x0

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_2e

    check-cast v0, Ljava/lang/String;

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_21

    const-string v2, "USER"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_27

    :cond_21
    const-string v1, "S"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->applyAiText(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2e

    :cond_27
    const-string v1, "[\u901a\u8bdd][AI]"

    const-string v2, "vq.S \u547d\u4e2d\u4f46\u89d2\u8272=USER\uff08\u5df2\u8df3\u8fc7\uff09"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2e
    .catchall {:try_start_0 .. :try_end_2e} :catchall_2e

    :catchall_2e
    :cond_2e
    :goto_2e
    return-void
.end method

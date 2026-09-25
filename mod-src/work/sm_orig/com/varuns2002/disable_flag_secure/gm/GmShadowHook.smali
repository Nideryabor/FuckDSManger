.class public final Lcom/varuns2002/disable_flag_secure/gm/GmShadowHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmShadowHook.java"


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
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-lez v0, :cond_20

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->on()Z

    move-result v0

    if-eqz v0, :cond_20

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_20

    array-length v1, v0

    if-lez v1, :cond_20

    const/4 v1, 0x0

    const/4 p0, 0x0

    invoke-static {p0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object p0

    aput-object p0, v0, v1

    const-string v0, "[\u6c14\u6ce1] \u9634\u5f71\u5df2\u5173\u95ed"

    const-string v1, "\u52a9\u624b\u4f5c\u7528\u57df\u5185 Modifier.shadow \u7684 elevation \u5df2\u5f52\u96f6\uff08NL 2.22.29 \u8d77\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_20
    .catchall {:try_start_0 .. :try_end_20} :catchall_21

    :cond_20
    return-void

    :catchall_21
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

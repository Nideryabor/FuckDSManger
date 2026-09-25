.class public final Lcom/nidyaber/fuckdsmanger/gm/GmResTextHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmResTextHook.java"


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

    if-eqz v0, :cond_43

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_43

    const/4 v1, 0x0

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/lang/Integer;

    if-eqz v3, :cond_43

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    const v3, 0x7f0f0221

    if-ne v2, v3, :cond_27

    const-string v2, ""

    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v2, "res.dead"

    const-string v3, "\u5df2\u62e6\u622a\u4e0d\u5b58\u5728\u7684\u8d44\u6e90 id 0x7f0f0221\uff08\u9632 NotFoundException \u5d29\u6e83\uff09"

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_43

    :cond_27
    const v3, 0x7f0f0222

    if-ne v2, v3, :cond_32

    const-string v2, ""

    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    goto :goto_43

    :cond_32
    const v3, 0x7f0f021f

    if-ne v2, v3, :cond_43

    const-string v2, "FuckDSManger"

    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v2, "resText"

    const-string v3, "Resources text replaced -> FuckDSManger"

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_43
    .catchall {:try_start_0 .. :try_end_43} :catchall_44

    :cond_43
    :goto_43
    return-void

    :catchall_44
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

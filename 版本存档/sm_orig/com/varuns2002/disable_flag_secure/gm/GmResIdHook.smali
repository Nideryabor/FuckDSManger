.class public final Lcom/varuns2002/disable_flag_secure/gm/GmResIdHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmResIdHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 11

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/lang/Integer;

    if-eqz v3, :cond_3b

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v3

    const v4, 0x7f7f0000

    if-ge v3, v4, :cond_15

    goto :goto_3b

    :cond_15
    const v5, 0x7f7f0100

    if-ge v3, v5, :cond_3b

    sub-int/2addr v3, v4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v5

    if-eqz v5, :cond_3b

    invoke-static {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v6

    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v7

    const/4 v8, 0x1

    if-lt v7, v8, :cond_3b

    rem-int/2addr v3, v7

    invoke-interface {v6, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v6

    invoke-virtual {p1, v6}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v7, "suggest.resid"

    const-string v8, "[\u5efa\u8bae] \u6587\u6848\u5df2\u6309\u8d44\u6e90 id \u63a5\u7ba1"

    invoke-static {v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3b
    :goto_3b
    return-void
    :try_end_3c
    .catchall {:try_start_0 .. :try_end_3c} :catchall_3c

    :catchall_3c
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

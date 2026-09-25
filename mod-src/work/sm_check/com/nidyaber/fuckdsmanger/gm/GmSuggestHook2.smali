.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSuggestHook2.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_2a

    const/4 v1, 0x0

    :goto_5
    array-length v3, v0

    if-ge v1, v3, :cond_2a

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/util/List;

    if-eqz v3, :cond_27

    check-cast v2, Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->reportF(I)V

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->buildMut2(Ljava/util/List;)Ljava/util/List;

    move-result-object v4

    if-eqz v4, :cond_2a

    aput-object v4, v0, v1

    const-string v3, "suggest.on2"

    const-string v4, "[\u5efa\u8bae] \u5217\u8868\u5df2\u63a5\u7ba1\uff08buildMut2\uff09"

    invoke-static {v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2a

    :cond_27
    add-int/lit8 v1, v1, 0x1

    goto :goto_5
    :try_end_2a
    .catchall {:try_start_0 .. :try_end_2a} :catchall_2b

    :cond_2a
    :goto_2a
    return-void

    :catchall_2b
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.class public final Lcom/nidyaber/fuckdsmanger/gm/GmPromptTextHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPromptTextHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method static idxOf(I)I
    .registers 2

    const/16 v0, 0x9

    sub-int/2addr p0, v0

    if-ltz p0, :cond_b

    const/16 v0, 0x8

    if-lt p0, v0, :cond_d

    const/4 v0, -0x1

    return v0

    :cond_b
    const/4 v0, -0x1

    return v0

    :cond_d
    return p0
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 12

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :cond_88

    const/4 v1, 0x0

    aget-object v3, v0, v1

    if-eqz v3, :cond_88

    const/4 v1, 0x1

    aget-object v4, v0, v1

    instance-of v6, v4, Landroid/content/Context;

    if-eqz v6, :cond_16

    check-cast v4, Landroid/content/Context;

    sput-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmGateHook;->sCtx:Landroid/content/Context;

    :cond_16
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v5

    if-eqz v5, :cond_88

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->on(Landroid/content/Context;)Z

    move-result v6

    if-eqz v6, :cond_88

    const-string v6, "a"

    invoke-static {v3, v6}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "[\u5efa\u8bae] g56.id="

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    const-string v8, "suggest.gid"

    invoke-static {v8, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const/16 v7, 0x2329

    if-lt v6, v7, :cond_44

    sub-int/2addr v6, v7

    goto :goto_48

    :cond_44
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptTextHook;->idxOf(I)I

    move-result v6

    :goto_48
    if-ltz v6, :cond_88

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v7

    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v8

    const/4 v9, 0x1

    if-lt v8, v9, :cond_88

    rem-int/2addr v6, v8

    invoke-interface {v7, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-virtual {p1, v6}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v7, "\u5df2\u63a5\u7ba1\u6587\u6848"

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->noteOk(Ljava/lang/String;)V

    const-string v7, "suggest.text"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "[\u5efa\u8bae] \u6587\u6848\u5df2\u63a5\u7ba1("

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v9, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v9}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ") "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v7, v8}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_88
    .catchall {:try_start_0 .. :try_end_88} :catchall_89

    :cond_88
    return-void

    :catchall_89
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmBubblePaintHook.java"
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static dg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    if-gtz v0, :end

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    const/4 v1, 0x5

    if-ge v0, v1, :end

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[页内bg] #"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v2}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :wr

    array-length v4, v2

    const/4 v5, 0x2

    if-lt v4, v5, :wr

    const/4 v4, 0x1

    aget-object v6, v2, v4

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    :wr
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :end
    return-void

    :catchall_0
    move-exception v0

    return-void
.end method

.method private static pg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    if-gtz v0, :end

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    const/4 v1, 0x4

    if-ge v0, v1, :end

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :end

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :end

    iget-object v1, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v1}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "v"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :end

    const/4 v1, 0x1

    aget-object v3, v0, v1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->colorLong()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :end

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->real(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :end

    const-wide/16 v2, 0x0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const-string v1, "[气泡] 背景实化"

    const-string v2, "聊天页底色已透明化 ⇒ 底图真正可见（NL 2.22.32 起）"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :end
    return-void

    :catchall_0
    move-exception v0

    return-void
.end method
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->dg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->pg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    iget-object v4, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v4}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v4

    const-string v5, "v"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_15

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    goto :goto_1b

    :cond_15
    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntU:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntU:I

    :goto_1b
    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    const/16 v5, 0x14

    if-ne v4, v5, :cond_28

    const-string v4, "[气泡] 警告v"

    const-string v5, "Luia.v 已调用 20 次但都不在助手作用域内（作用域假设失败）"

    invoke-static {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_28
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->on()Z

    move-result v0

    if-eqz v0, :cond_9a

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-lez v0, :cond_9a

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_9a

    array-length v2, v0

    const/4 v1, 0x2

    if-lt v2, v1, :cond_9a

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v1}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "v"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_73

    const/4 v2, 0x1

    aget-object v2, v0, v2

    if-eqz v2, :cond_9a

    instance-of v3, v2, Ljava/lang/Long;

    if-eqz v3, :cond_9a

    check-cast v2, Ljava/lang/Long;

    invoke-virtual {v2}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->colorLong()J

    move-result-wide v4

    cmp-long v1, v2, v4

    if-eqz v1, :cond_9a

    const-wide/16 v2, 0x0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHit:Z

    const-string v2, "[气泡][v]"

    const-string v3, "项内小卡背景已透明化（已跳过自身注入色）"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_9a

    :cond_73
    const-string v2, "u"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_9a

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    check-cast v2, Ljava/lang/reflect/Method;

    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->brush(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_9a

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHit:Z

    const-string v2, "[气泡][u]"

    const-string v3, "助手背景 Brush 已接管（紫→青渐变）"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_9a
    .catchall {:try_start_0 .. :try_end_9a} :catchall_9b

    :cond_9a
    :goto_9a
    return-void

    :catchall_9b
    move-exception v0

    const-string v1, "[气泡] hook 内部异常（已吞，不影响宿主）"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;
.super Ljava/lang/Object;

.method private static pg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 10

    :try_start_0
    const/4 v6, 0x1

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "v"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :end

    const/4 v6, 0x2

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :end

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :end

    const/4 v1, 0x1

    aget-object v3, v0, v1

    instance-of v1, v3, Ljava/lang/Long;

    if-eqz v1, :end

    const/4 v6, 0x3

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-gtz v1, :end

    check-cast v3, Ljava/lang/Long;

    invoke-virtual {v3}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    const/4 v6, 0x4

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    const-wide v6, -67818912288342016L

    cmp-long v8, v4, v6

    if-nez v8, :do

    const-wide v6, -4294967296L

    cmp-long v8, v4, v6

    if-nez v8, :do

    goto :end

    :do
    const/4 v6, 0x0

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->real(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :end

    const/4 v6, 0x6

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    const-wide/16 v2, 0x0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const-string v1, "x"

    const-string v2, "y"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :end
    return-void

    :catchall_0
    move-exception v0

    const-string v1, "z"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

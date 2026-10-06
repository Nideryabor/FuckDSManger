.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;
.super Ljava/lang/Object;

.field public static sPageColor:J

.method private static rec(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    sget-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :end

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "v"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :end

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :end

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :end

    const/4 v1, 0x1

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/Long;

    if-eqz v1, :end

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J
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

    check-cast v3, Ljava/lang/Long;

    invoke-virtual {v3}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    cmp-long v6, v4, v1

    if-eqz v6, :end

    const/4 v6, 0x4

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-gtz v1, :end

    const/4 v6, 0x5

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    const/16 v2, 0x8

    if-ge v1, v2, :end

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

    const/4 v6, 0x7

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

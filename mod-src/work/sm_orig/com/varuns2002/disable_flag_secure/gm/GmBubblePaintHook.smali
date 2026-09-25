.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmBubblePaintHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static collect(Ljava/lang/String;)V
    .registers 5

    :try_start_0
    const-string v0, "[\u91c7\u96c6] collect"

    const-string v1, "collect() \u5df2\u88ab\u8c03\u7528\uff08\u91c7\u96c6\u94fe\u8def\u6d3b\u8457\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    sget-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sTouchOn:Z

    if-eqz v3, :cond_e

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->learn(Ljava/lang/String;)V

    :cond_e
    if-eqz p0, :cond_39

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_39

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateList:Ljava/lang/String;

    if-eqz v0, :cond_37

    invoke-virtual {v0, p0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_39

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "|"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateList:Ljava/lang/String;

    goto :goto_39

    :cond_37
    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateList:Ljava/lang/String;
    :try_end_39
    .catchall {:try_start_0 .. :try_end_39} :catchall_3a

    :cond_39
    :goto_39
    return-void

    :catchall_3a
    move-exception v0

    return-void
.end method

.method private static dg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeArm:Z

    if-eqz v0, :cond_a9

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[\u5b9e\u5316] bg#"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " depth="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " cnt="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " why="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v2}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :cond_56

    array-length v4, v2

    const/4 v5, 0x2

    if-lt v4, v5, :cond_56

    const/4 v4, 0x1

    aget-object v6, v2, v4

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    :cond_56
    const-string v2, "  cls="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :cond_73

    array-length v4, v2

    const/4 v5, 0x1

    if-lt v4, v5, :cond_73

    const/4 v4, 0x0

    aget-object v6, v2, v4

    if-eqz v6, :cond_73

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_73
    const-string v2, "  C="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->caller()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->collect(Ljava/lang/String;)V

    const-string v2, "  sd="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "  from="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->stack()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x7d0

    if-gt v0, v2, :cond_a6

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->w(Ljava/lang/String;)V

    :cond_a6
    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->push(Ljava/lang/String;)V
    :try_end_a9
    .catchall {:try_start_0 .. :try_end_a9} :catchall_aa

    :cond_a9
    return-void

    :catchall_aa
    move-exception v0

    return-void
.end method

.method public static learn(Ljava/lang/String;)V
    .registers 5

    :try_start_0
    if-eqz p0, :cond_5d

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_5d

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipList:Ljava/lang/String;

    if-eqz v0, :cond_29

    invoke-virtual {v0, p0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_5d

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "|"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipList:Ljava/lang/String;

    goto :goto_2b

    :cond_29
    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipList:Ljava/lang/String;

    :goto_2b
    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipCount:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipCount:I

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u6392"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v1, :cond_49

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_49
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[\u4ea4\u4e92\u6392\u9664] \u5b66\u5230 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_5d
    .catchall {:try_start_0 .. :try_end_5d} :catchall_5e

    :cond_5d
    return-void

    :catchall_5e
    move-exception v0

    return-void
.end method

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

    if-eqz v0, :cond_120

    const/4 v6, 0x2

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_120

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :cond_120

    const/4 v1, 0x1

    aget-object v3, v0, v1

    instance-of v1, v3, Ljava/lang/Long;

    if-eqz v1, :cond_120

    const/4 v6, 0x3

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-gtz v1, :cond_120

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->caller()Ljava/lang/String;

    move-result-object v1

    sget-object v7, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSkipList:Ljava/lang/String;

    if-eqz v7, :cond_3f

    invoke-virtual {v7, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_3f

    return-void

    :cond_3f
    sget-object v7, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateCur:Ljava/lang/String;

    if-eqz v7, :cond_61

    invoke-virtual {v7, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_61

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x1

    const-wide v4, 0xffffff00000000L

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v6

    aput-object v6, v0, v2

    sget v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateHits:I

    add-int/lit8 v6, v6, 0x1

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAblateHits:I

    const/4 v6, 0x7

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    return-void

    :cond_61
    const-string v2, "zc.s:1417"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_6a

    goto :goto_c1

    :cond_6a
    const-string v2, "vz8.c:58"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_73

    goto :goto_c1

    :cond_73
    const-string v2, "pa1.l:308"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_7c

    goto :goto_c1

    :cond_7c
    const-string v2, "ve7.b:340"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_85

    goto :goto_c1

    :cond_85
    const-string v2, "eb1.h:548"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_8e

    goto :goto_c1

    :cond_8e
    const-string v2, "xd5.c:184"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_97

    goto :goto_c1

    :cond_97
    const-string v2, "uia.a:461"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_a0

    goto :goto_c1

    :cond_a0
    const-string v2, "uia.a:672"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_a9

    goto :goto_c1

    :cond_a9
    const-string v2, "ob8.a:82"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_b2

    goto :goto_c1

    :cond_b2
    const-string v2, "cka.d:241"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_c1

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    const/16 v2, 0x6

    if-gt v1, v2, :cond_c1

    goto :goto_120

    :cond_c1
    :goto_c1
    check-cast v3, Ljava/lang/Long;

    invoke-virtual {v3}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    cmp-long v6, v4, v1

    if-eqz v6, :cond_f5

    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSurfaceColor:J

    cmp-long v6, v4, v1

    if-eqz v6, :cond_f5

    const/4 v6, 0x4

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sExtraColor:J

    cmp-long v6, v4, v1

    if-eqz v6, :cond_f5

    const/4 v6, 0x5

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    const-wide/16 v6, 0x0

    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    cmp-long v1, v1, v6

    if-nez v1, :cond_ea

    sput-wide v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    goto :goto_f5

    :cond_ea
    sget-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSurfaceColor:J

    cmp-long v1, v1, v6

    if-nez v1, :cond_f3

    sput-wide v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSurfaceColor:J

    goto :goto_f5

    :cond_f3
    sput-wide v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sExtraColor:J

    :cond_f5
    :goto_f5
    const/4 v6, 0x0

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->real(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_120

    const/4 v6, 0x6

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgWhy:I

    const-wide v2, 0xffffffffffffffL

    and-long/2addr v4, v2

    const/16 v2, 0x80

    int-to-long v2, v2

    const/16 v6, 0x38

    shl-long/2addr v2, v6

    or-long/2addr v4, v2

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const-string v1, "[\u5b9e\u5316] \u547d\u4e2d \u21d2 \u5df2\u5168\u900f"

    const-string v2, "\u547d\u4e2d\uff1a\u8c03\u7528\u70b9\u767d\u540d\u5355\uff0810 \u4e2a\uff09\u21d2 \u534a\u900f 50%\uff08\u6863\u4f4d 1\uff0c\u5df2\u4ece\u6863\u4f4d 2 \u56de\u9000\uff09\uff5c\u672c\u9875\u524d 6 \u5c42\u515c\u5e95"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_120
    .catchall {:try_start_0 .. :try_end_120} :catchall_121

    :cond_120
    :goto_120
    return-void

    :catchall_121
    move-exception v0

    const-string v1, "[\u5b9e\u5316] pg \u5185\u90e8\u5f02\u5e38\uff08\u5df2\u541e\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static push(Ljava/lang/String;)V
    .registers 5

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    if-nez v0, :cond_c

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_c
    const-string v0, "\n"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x4e20

    if-gt v1, v2, :cond_23

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    goto :goto_25

    :cond_23
    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    :goto_25
    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    const/4 v2, 0x1

    if-ne v3, v2, :cond_4b

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[push\u81ea\u68c0] \u9996\u6b21 push \u5b8c\u6210\uff0c\u7f13\u51b2\u957f\u5ea6="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    if-eqz v3, :cond_3d

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    goto :goto_3e

    :cond_3d
    const/4 v3, -0x1

    :goto_3e
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->w(Ljava/lang/String;)V

    :cond_4b
    return-void
    :try_end_4c
    .catchall {:try_start_0 .. :try_end_4c} :catchall_4c

    :catchall_4c
    move-exception v0

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPgLogCnt:I

    const/4 v1, 0x5

    if-gt v0, v1, :cond_5a

    const-string v0, "[push\u81ea\u68c0] push \u5185\u90e8\u629b\u5f02\u5e38\uff08\u7f13\u51b2\u6ca1\u5199\u8fdb\u53bb\uff09"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->w(Ljava/lang/String;)V

    :cond_5a
    return-void
.end method

.method private static rec(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    sget-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_2d

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "v"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2d

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_2d

    array-length v1, v0

    const/4 v2, 0x2

    if-lt v1, v2, :cond_2d

    const/4 v1, 0x1

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/Long;

    if-eqz v1, :cond_2d

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J
    :try_end_2d
    .catchall {:try_start_0 .. :try_end_2d} :catchall_2e

    :cond_2d
    return-void

    :catchall_2e
    move-exception v0

    return-void
.end method

.method private static ub(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->uOn()Z

    move-result v0

    if-eqz v0, :cond_a3

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "v"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a3

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_a3

    array-length v1, v0

    const/4 v2, 0x3

    if-lt v1, v2, :cond_a3

    iget-object v1, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    check-cast v1, Ljava/lang/reflect/Method;

    invoke-virtual {v1}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->caller()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " | \u8272="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v4, 0x1

    aget-object v4, v0, v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " | sd="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " | ub="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUBub:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " | ud="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " | \u5f62="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v4, 0x2

    aget-object v4, v0, v4

    if-eqz v4, :cond_72

    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_72
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    if-lez v2, :cond_89

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->caller()Ljava/lang/String;

    move-result-object v2

    const-string v3, "ls9.f"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_a3

    :cond_89
    const/4 v2, 0x2

    aget-object v2, v0, v2

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->hostShape(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_a3

    if-eq v2, v3, :cond_a3

    const/4 v2, 0x0

    aget-object v2, v0, v2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->useUImgName()V

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->ubMod(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_a3

    invoke-virtual {p0, v3}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V
    :try_end_a3
    .catchall {:try_start_0 .. :try_end_a3} :catchall_a4

    :cond_a3
    return-void

    :catchall_a4
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->rec(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->dg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->pg(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubblePaintHook;->ub(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    iget-object v4, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v4}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v4

    const-string v5, "v"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_21

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    goto :goto_27

    :cond_21
    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntU:I

    add-int/lit8 v4, v4, 0x1

    sput v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntU:I

    :goto_27
    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntV:I

    const/16 v5, 0x14

    if-ne v4, v5, :cond_34

    const-string v4, "[\u6c14\u6ce1] \u8b66\u544av"

    const-string v5, "Luia.v \u5df2\u8c03\u7528 20 \u6b21\u4f46\u90fd\u4e0d\u5728\u52a9\u624b\u4f5c\u7528\u57df\u5185\uff08\u4f5c\u7528\u57df\u5047\u8bbe\u5931\u8d25\uff09"

    invoke-static {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_34
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->inScope()Z

    move-result v0

    if-eqz v0, :cond_a2

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_a2

    array-length v2, v0

    const/4 v1, 0x2

    if-lt v2, v1, :cond_a2

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v1}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "v"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_7b

    const/4 v2, 0x1

    aget-object v2, v0, v2

    if-eqz v2, :cond_a2

    instance-of v3, v2, Ljava/lang/Long;

    if-eqz v3, :cond_a2

    check-cast v2, Ljava/lang/Long;

    invoke-virtual {v2}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->colorLong()J

    move-result-wide v4

    cmp-long v1, v2, v4

    if-eqz v1, :cond_a2

    const-wide/16 v2, 0x0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHit:Z

    const-string v2, "[\u6c14\u6ce1][v]"

    const-string v3, "\u9879\u5185\u5c0f\u5361\u80cc\u666f\u5df2\u900f\u660e\u5316\uff08\u5df2\u8df3\u8fc7\u81ea\u8eab\u6ce8\u5165\u8272\uff09"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_a2

    :cond_7b
    const-string v2, "u"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_a2

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    check-cast v2, Ljava/lang/reflect/Method;

    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->brush(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_a2

    const/4 v3, 0x1

    aput-object v2, v0, v3

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHit:Z

    const-string v2, "[\u6c14\u6ce1][u]"

    const-string v3, "\u52a9\u624b\u80cc\u666f Brush \u5df2\u63a5\u7ba1\uff08\u7d2b\u2192\u9752\u6e10\u53d8\uff09"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_a2
    .catchall {:try_start_0 .. :try_end_a2} :catchall_a3

    :cond_a2
    :goto_a2
    return-void

    :catchall_a3
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] hook \u5185\u90e8\u5f02\u5e38\uff08\u5df2\u541e\uff0c\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

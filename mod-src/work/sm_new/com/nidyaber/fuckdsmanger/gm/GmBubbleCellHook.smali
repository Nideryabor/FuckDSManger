.class public final Lcom/nidyaber/fuckdsmanger/gm/GmBubbleCellHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmBubbleCellHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static roleLog(Ljava/lang/Class;[Ljava/lang/Object;)V
    .registers 11

    :try_start_0
    if-nez p0, :cond_6f

    const-string v0, "[ROLE] roleLog \u5df2\u8fd0\u884c\uff08\u53c2\u6570\u5982\u4e0b\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    array-length v1, p1

    const-string v2, "[ROLE] \u53c2\u6570\u4e2a\u6570 = "

    invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v1, 0x0

    :goto_21
    array-length v2, p1

    if-ge v1, v2, :cond_6f

    const/16 v2, 0xc

    if-ge v1, v2, :cond_29

    goto :goto_6f

    :cond_29
    aget-object v2, p1, v1

    if-eqz v2, :cond_6c

    invoke-virtual {p0, v2}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_6c

    const-string v3, "D"

    const/4 v4, 0x0

    new-array v4, v4, [Ljava/lang/Object;

    invoke-static {v2, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "#"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " role="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_6c
    add-int/lit8 v1, v1, 0x1

    goto :goto_21
    :try_end_6f
    .catchall {:try_start_0 .. :try_end_6f} :catchall_70

    :cond_6f
    :goto_6f
    return-void

    :catchall_70
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    :try_start_0
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sDepth:I

    if-lez v0, :cond_9

    add-int/lit8 v0, v0, -0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sDepth:I

    goto :goto_11

    :cond_9
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUDepth:I

    if-lez v0, :cond_11

    add-int/lit8 v0, v0, -0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUDepth:I
    :try_end_11
    .catchall {:try_start_0 .. :try_end_11} :catchall_12

    :cond_11
    :goto_11
    return-void

    :catchall_12
    move-exception v0

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 9

    :try_start_0
    sget v1, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCellAll:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCellAll:I

    const-string v2, "[CELL] \u603b\u9879\u6570 = "

    invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->uOn()Z

    move-result v5

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[UCFG] \u7528\u6237\u6c14\u6ce1\u5f00\u5173 = "

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_132

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    check-cast v1, Ljava/lang/reflect/Method;

    invoke-virtual {v1}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "vq"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    if-eqz v2, :cond_132

    array-length v3, v0

    const/4 v4, 0x0

    const/4 v5, 0x0

    :goto_51
    if-ge v4, v3, :cond_63

    aget-object v6, v0, v4

    if-eqz v6, :cond_60

    invoke-virtual {v2, v6}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_60

    aget-object v5, v0, v4

    goto :goto_63

    :cond_60
    add-int/lit8 v4, v4, 0x1

    goto :goto_51

    :cond_63
    :goto_63
    if-eqz v5, :cond_132

    const-string v6, "[HOOK] \u627e\u5230\u6d88\u606f\u9879\uff0c\u5f00\u59cb\u6253\u5370\u53c2\u6570"

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[ROLE] "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " role="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "D"

    const/4 v6, 0x0

    new-array v6, v6, [Ljava/lang/Object;

    invoke-static {v5, v4, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v3, "D"

    const/4 v4, 0x0

    new-array v4, v4, [Ljava/lang/Object;

    invoke-static {v5, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    instance-of v4, v3, Ljava/lang/String;

    if-nez v4, :cond_b2

    check-cast v3, Ljava/lang/String;

    const-string v4, "USER"

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_df

    :cond_b2
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCntCell:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCntCell:I

    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sDepth:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sDepth:I

    const/4 v0, 0x0

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sHit:Z

    const-string v0, "[\u6c14\u6ce1] \u52a9\u624b\u81ea\u68c0"

    const-string v1, "pn9.c \u52a9\u624b\u9879\u5df2\u88ab\u8c03\u7528\uff08\u6a21\u5757 NL 2.22.110 \u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCntCell:I

    const/4 v1, 0x5

    if-ne v0, v1, :cond_d8

    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sCntInj:I

    if-nez v0, :cond_d8

    const-string v0, "[\u6c14\u6ce1] \u8b66\u544a"

    const-string v1, "5 \u4e2a\u6d88\u606f\u9879\u4e86\u4f46\u4e00\u6b21\u90fd\u6ca1\u6ce8\u5165\u6210\u529f\uff08args \u91cc\u6ca1\u6709 Modifier\uff1f\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_d8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->on()Z

    move-result v0

    if-eqz v0, :cond_132

    goto :goto_f6

    :cond_df
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUCntCell:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUCntCell:I

    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUDepth:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUDepth:I

    const/4 v0, 0x0

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sHit:Z

    const-string v0, "[\u6c14\u6ce1] \u7528\u6237\u81ea\u68c0"

    const-string v1, "pn9.c \u7528\u6237\u9879\u5df2\u88ab\u8c03\u7528\uff08\u6a21\u5757 NL 2.22.110 \u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_132

    :goto_f6
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_132

    array-length v1, v0

    const/4 v2, 0x0

    :goto_fc
    if-ge v2, v1, :cond_132

    aget-object v3, v0, v2

    if-eqz v3, :cond_12f

    iget-object v4, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    check-cast v4, Ljava/lang/reflect/Method;

    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    const-string v5, "c76"

    invoke-static {v5, v4}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    if-eqz v5, :cond_12f

    invoke-virtual {v5, v3}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_12f

    invoke-static {v4, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->wrap(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    if-eq v5, v3, :cond_12f

    aput-object v5, v0, v2

    const/4 v5, 0x1

    sput-boolean v5, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sHit:Z

    const-string v5, "[\u6c14\u6ce1] \u5e95\u677f\u5df2\u6ce8\u5165"

    const-string v6, "\u5df2\u7ed9\u6d88\u606f\u9879\u7684 Modifier \u5957\u4e0a\u6c14\u6ce1\u5e95\uff08\u52a9\u624b/\u7528\u6237\u5404\u81ea\u914d\u8272\uff09"

    invoke-static {v5, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_132

    :cond_12f
    add-int/lit8 v2, v2, 0x1

    goto :goto_fc
    :try_end_132
    .catchall {:try_start_0 .. :try_end_132} :catchall_133

    :cond_132
    :goto_132
    return-void

    :catchall_133
    move-exception v0

    return-void
.end method

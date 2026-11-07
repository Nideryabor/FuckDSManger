.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;
.super Ljava/lang/Object;
.source "GmGlassScope.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$DepthHook;
    }
.end annotation


# static fields
.field private static final BTN_ANCHORS:[[Ljava/lang/String;

.field private static volatile sDepth:I


# direct methods
.method static constructor <clinit>()V
    .registers 15

    .line 59
    const-string v0, "kmc"

    const-string v1, "b"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v2

    const-string v3, "c"

    move-object v4, v3

    filled-new-array {v0, v4}, [Ljava/lang/String;

    move-result-object v3

    const-string v5, "d"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    const-string v6, "a"

    const-string v7, "rb3"

    filled-new-array {v7, v6}, [Ljava/lang/String;

    move-result-object v6

    move-object v8, v5

    move-object v5, v6

    filled-new-array {v7, v1}, [Ljava/lang/String;

    move-result-object v6

    move-object v9, v7

    filled-new-array {v9, v4}, [Ljava/lang/String;

    move-result-object v7

    filled-new-array {v9, v8}, [Ljava/lang/String;

    move-result-object v8

    const-string v9, "x4c"

    const-string v10, "q"

    filled-new-array {v9, v10}, [Ljava/lang/String;

    move-result-object v9

    const-string v10, "lv6"

    filled-new-array {v10, v4}, [Ljava/lang/String;

    move-result-object v10

    const-string v11, "oh7"

    filled-new-array {v11, v1}, [Ljava/lang/String;

    move-result-object v1

    filled-new-array {v11, v4}, [Ljava/lang/String;

    move-result-object v12

    const-string v4, "h"

    const-string v11, "fxb"

    filled-new-array {v11, v4}, [Ljava/lang/String;

    move-result-object v13

    const-string v4, "r"

    filled-new-array {v11, v4}, [Ljava/lang/String;

    move-result-object v14

    move-object v4, v0

    move-object v11, v1

    filled-new-array/range {v2 .. v14}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->BTN_ANCHORS:[[Ljava/lang/String;

    const/4 v0, 0x0

    .line 103
    sput v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$100()I
    .registers 1

    .line 46
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    return v0
.end method

.method static synthetic access$108()I
    .registers 2

    .line 46
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    add-int/lit8 v1, v0, 0x1

    sput v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    return v0
.end method

.method static synthetic access$110()I
    .registers 2

    .line 46
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    add-int/lit8 v1, v0, -0x1

    sput v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    return v0
.end method

.method public static depth()I
    .registers 1

    .line 110
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    return v0
.end method

.method public static inButton()Z
    .registers 1

    .line 106
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I

    if-lez v0, :cond_6

    const/4 v0, 0x1

    return v0

    :cond_6
    const/4 v0, 0x0

    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)I
    .registers 16

    .line 115
    const-string v0, "->"

    .line 116
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->BTN_ANCHORS:[[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    move v5, v4

    :goto_8
    if-ge v4, v2, :cond_a0

    aget-object v6, v1, v4

    const/4 v7, 0x1

    .line 118
    :try_start_d
    aget-object v8, v6, v3

    invoke-static {v8, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v8

    .line 120
    invoke-virtual {v8}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v8

    array-length v9, v8
    :try_end_18
    .catchall {:try_start_d .. :try_end_18} :catchall_65

    move v10, v3

    move v11, v5

    :goto_1a
    if-ge v10, v9, :cond_42

    :try_start_1c
    aget-object v12, v8, v10

    .line 121
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v13

    aget-object v14, v6, v7

    invoke-virtual {v13, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_2b

    goto :goto_3d

    .line 122
    :cond_2b
    invoke-static {v12}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->looksLikeComposable(Ljava/lang/reflect/Method;)Z

    move-result v13

    if-nez v13, :cond_32

    goto :goto_3d

    .line 123
    :cond_32
    new-instance v13, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$DepthHook;

    const/4 v14, 0x0

    invoke-direct {v13, v14}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$DepthHook;-><init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$1;)V

    invoke-static {v12, v13}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v11, v11, 0x1

    :goto_3d
    add-int/lit8 v10, v10, 0x1

    goto :goto_1a

    :catchall_40
    move-exception v5

    goto :goto_68

    :cond_42
    if-ne v11, v5, :cond_9b

    .line 127
    const-string v5, "glass.btn.miss"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "\u3010GmGlass\u3011\u6309\u94ae\u951a\u70b9\u6ca1\u6302\u4e0a\uff1a"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v9, v6, v3

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v9, v6, v7

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v5, v8}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_64
    .catchall {:try_start_1c .. :try_end_64} :catchall_40

    goto :goto_9b

    :catchall_65
    move-exception v8

    move v11, v5

    move-object v5, v8

    .line 131
    :goto_68
    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "glass.btn.err."

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v9, v6, v3

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "\u3010GmGlass\u3011\u6309\u94ae\u951a\u70b9\u5f02\u5e38 "

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v10, v6, v3

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v6, v6, v7

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\uff1a"

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v8, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_9b
    :goto_9b
    move v5, v11

    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_8

    .line 134
    :cond_a0
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "\u3010GmGlass\u3011\u6309\u94ae\u4f5c\u7528\u57df\u94a9\u5b50 "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u6761"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v5
.end method

.method private static looksLikeComposable(Ljava/lang/reflect/Method;)Z
    .registers 6

    .line 89
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v0

    sget-object v1, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    const/4 v2, 0x0

    if-eq v0, v1, :cond_a

    return v2

    .line 90
    :cond_a
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object p0

    .line 94
    array-length v0, p0

    const/4 v1, 0x4

    if-ge v0, v1, :cond_13

    return v2

    .line 95
    :cond_13
    array-length v0, p0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    aget-object v0, p0, v0

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v0, v3, :cond_1d

    return v2

    .line 96
    :cond_1d
    array-length v0, p0

    move v3, v2

    :goto_1f
    if-ge v3, v0, :cond_2d

    aget-object v4, p0, v3

    .line 97
    invoke-virtual {v4}, Ljava/lang/Class;->isInterface()Z

    move-result v4

    if-eqz v4, :cond_2a

    return v1

    :cond_2a
    add-int/lit8 v3, v3, 0x1

    goto :goto_1f

    :cond_2d
    return v2
.end method

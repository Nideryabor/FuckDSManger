.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSysPromptHook.java"


# static fields
.field private static final CANDIDATE_NAMES:[Ljava/lang/String;

.field private static final CTOR_SIG:[Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "[",
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static volatile sHits:I


# direct methods
.method static constructor <clinit>()V
    .registers 5

    const/16 v0, 0xb

    .line 43
    new-array v0, v0, [Ljava/lang/Class;

    const/4 v1, 0x0

    const-class v2, Ljava/lang/String;

    aput-object v2, v0, v1

    const/4 v3, 0x1

    const-class v4, Ljava/lang/Integer;

    aput-object v4, v0, v3

    const/4 v3, 0x2

    aput-object v2, v0, v3

    const/4 v3, 0x3

    const-class v4, Ljava/util/ArrayList;

    aput-object v4, v0, v3

    const/4 v3, 0x4

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v4, v0, v3

    const/4 v3, 0x5

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v4, v0, v3

    const/4 v3, 0x6

    aput-object v2, v0, v3

    const/4 v3, 0x7

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v4, v0, v3

    const/16 v3, 0x8

    aput-object v2, v0, v3

    const/16 v3, 0x9

    aput-object v2, v0, v3

    const/16 v2, 0xa

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v0, v2

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->CTOR_SIG:[Ljava/lang/Class;

    .line 58
    sput v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->sHits:I

    .line 109
    const-string v0, "sx1"

    const-string v1, "tv1"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->CANDIDATE_NAMES:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 40
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method public static hits()I
    .registers 1

    .line 60
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->sHits:I

    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)I
    .registers 10

    .line 123
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->CANDIDATE_NAMES:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_5
    if-ge v3, v1, :cond_74

    aget-object v4, v0, v3

    .line 125
    :try_start_9
    invoke-static {v4, v2, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    if-nez v5, :cond_10

    goto :goto_71

    .line 128
    :cond_10
    sget-object v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->CTOR_SIG:[Ljava/lang/Class;

    invoke-virtual {v5, v6}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v6

    const/4 v7, 0x1

    .line 129
    invoke-virtual {v6, v7}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 130
    new-instance v8, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;

    invoke-direct {v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;-><init>()V

    invoke-static {v6, v8}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 132
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "hookM sysprompt count=1 cls="

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, " ("

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 133
    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ")"

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 132
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_47
    .catch Ljava/lang/NoSuchMethodException; {:try_start_9 .. :try_end_47} :catch_5b
    .catchall {:try_start_9 .. :try_end_47} :catchall_48

    return v7

    :catchall_48
    move-exception v5

    .line 140
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "syspromptHook.install/"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    goto :goto_71

    .line 137
    :catch_5b
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "hookM FAIL sysprompt "

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \u2192 \u7c7b\u5728\u4f46\u65e0\u5339\u914d\u6784\u9020\u5668\uff08\u540d\u5b57\u88ab\u590d\u7528\uff1f\u8be5\u91cd\u65b0\u53cd\u67e5\u4e86\uff09"

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_71
    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    .line 143
    :cond_74
    const-string p0, "hookM FAIL sysprompt \u2192 \u5168\u90e8\u5019\u9009\u672a\u547d\u4e2d\uff0c\u5bbf\u4e3b\u53ef\u80fd\u5df2\u6539\u7248"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    const-string p0, "hook \u6d3b\u4e86 on="

    .line 65
    :try_start_2
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_6f

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, v0

    const/16 v1, 0xb

    if-ge v0, v1, :cond_e

    goto :goto_6f

    .line 73
    :cond_e
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    instance-of v0, v0, Ljava/lang/String;

    if-eqz v0, :cond_48

    .line 74
    const-string v0, "sysprompt.state"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 75
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->on()Z

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " mode="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 76
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->mode()I

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " textLen="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 77
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 74
    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 80
    :cond_48
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v0, 0x1

    aget-object p0, p0, v0

    if-nez p0, :cond_51

    move p0, v0

    goto :goto_52

    :cond_51
    const/4 p0, 0x0

    .line 83
    :goto_52
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object v2, v2, v1

    .line 84
    instance-of v3, v2, Ljava/lang/String;

    if-nez v3, :cond_5b

    goto :goto_6f

    .line 86
    :cond_5b
    move-object v3, v2

    check-cast v3, Ljava/lang/String;

    invoke-static {v3, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->inject(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_6f

    if-eq p0, v2, :cond_6f

    .line 88
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aput-object p0, p1, v1

    .line 89
    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->sHits:I

    add-int/2addr p0, v0

    sput p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->sHits:I
    :try_end_6f
    .catchall {:try_start_2 .. :try_end_6f} :catchall_70

    :cond_6f
    :goto_6f
    return-void

    :catchall_70
    move-exception p0

    .line 93
    const-string p1, "syspromptHook"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

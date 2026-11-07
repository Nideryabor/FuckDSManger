.class final Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$RetHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSysPromptHideHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "RetHook"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 109
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$1;)V
    .registers 2

    .line 109
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$RetHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    const-string p0, "ret:"

    .line 113
    :try_start_2
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->carrier()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    goto :goto_40

    .line 114
    :cond_a
    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    .line 115
    instance-of v1, v0, Ljava/lang/String;

    if-nez v1, :cond_13

    goto :goto_40

    .line 116
    :cond_13
    check-cast v0, Ljava/lang/String;

    .line 117
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1c

    goto :goto_40

    .line 118
    :cond_1c
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 119
    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 120
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {p0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V
    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->access$000(Ljava/lang/String;II)V
    :try_end_40
    .catchall {:try_start_2 .. :try_end_40} :catchall_40

    :catchall_40
    :goto_40
    return-void
.end method

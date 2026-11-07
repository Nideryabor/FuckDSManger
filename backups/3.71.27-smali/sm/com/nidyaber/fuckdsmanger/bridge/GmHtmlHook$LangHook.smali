.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LangHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "LangHook"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 306
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 306
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LangHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    .line 310
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result p0

    if-nez p0, :cond_7

    goto :goto_4e

    .line 311
    :cond_7
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz p0, :cond_4e

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length p0, p0

    const/4 v0, 0x2

    if-ge p0, v0, :cond_12

    goto :goto_4e

    .line 312
    :cond_12
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v0, 0x0

    aget-object p0, p0, v0

    .line 313
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x1

    aget-object v0, v0, v1

    .line 316
    instance-of v1, p0, Ljava/lang/String;

    if-eqz v1, :cond_4e

    instance-of v1, v0, Ljava/lang/String;

    if-nez v1, :cond_25

    goto :goto_4e

    .line 317
    :cond_25
    const-string v1, "mermaid"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2e

    goto :goto_4e

    .line 318
    :cond_2e
    check-cast p0, Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 319
    const-string v0, "html"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_49

    const-string v0, "htm"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_49

    goto :goto_4e

    .line 320
    :cond_49
    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V
    :try_end_4e
    .catchall {:try_start_0 .. :try_end_4e} :catchall_4f

    :cond_4e
    :goto_4e
    return-void

    :catchall_4f
    move-exception p0

    .line 322
    const-string p1, "htmlHook.lang"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

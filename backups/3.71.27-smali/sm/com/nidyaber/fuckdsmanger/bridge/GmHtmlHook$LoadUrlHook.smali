.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "LoadUrlHook"
.end annotation


# static fields
.field private static volatile sN:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 477
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 477
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 9

    const-string p0, "\u3010HTML\u63a2\u9488\u3011"

    const-string v0, "\u3010HTML\u3011\u5df2\u628a generator.html \u6362\u6210\u81ea\u5efa\u9875\uff1a"

    const-string v1, "loadUrl #"

    .line 483
    :try_start_6
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :cond_b2

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v2, v2

    const/4 v3, 0x1

    if-ge v2, v3, :cond_12

    goto/16 :goto_b2

    .line 484
    :cond_12
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v4, 0x0

    aget-object v2, v2, v4

    .line 485
    instance-of v5, v2, Ljava/lang/String;

    if-nez v5, :cond_1d

    goto/16 :goto_b2

    .line 486
    :cond_1d
    check-cast v2, Ljava/lang/String;

    .line 487
    const-string v5, "generator.html"

    invoke-virtual {v2, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v5

    if-gez v5, :cond_31

    const-string v5, "viewer.html"

    invoke-virtual {v2, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v5

    if-gez v5, :cond_31

    goto/16 :goto_b2

    .line 489
    :cond_31
    sget v5, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;->sN:I

    const/4 v6, 0x6

    if-ge v5, v6, :cond_83

    .line 490
    sget v5, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;->sN:I

    add-int/2addr v5, v3

    sput v5, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;->sN:I

    .line 491
    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 492
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;->sN:I

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " url="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u5b9e\u4f8b\u7c7b="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v3, :cond_59

    .line 493
    const-string v1, "?"

    goto :goto_61

    :cond_59
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    :goto_61
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u5f00\u5173="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 494
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 495
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 498
    :cond_83
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result p0

    if-nez p0, :cond_8a

    goto :goto_b2

    .line 505
    :cond_8a
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 506
    instance-of p0, p0, Landroid/webkit/WebView;

    if-nez p0, :cond_91

    goto :goto_b2

    .line 509
    :cond_91
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->pageDataUrl()Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_9d

    .line 511
    const-string p0, "\u3010HTML\u3011\u81ea\u5efa\u9875\u751f\u6210\u5931\u8d25 \u21d2 \u653e\u884c\u539f\u903b\u8f91"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 515
    :cond_9d
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aput-object p0, p1, v4

    .line 516
    const-string p1, "htmlHook.swap"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_b2
    .catchall {:try_start_6 .. :try_end_b2} :catchall_b3

    :cond_b2
    :goto_b2
    return-void

    :catchall_b3
    move-exception p0

    .line 518
    const-string p1, "htmlHook.loadUrl"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$4;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->catchCanvas(Ljava/lang/Class;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 1479
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    .line 1483
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-nez p0, :cond_5

    goto :goto_55

    .line 1484
    :cond_5
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_9
    if-ge v1, v0, :cond_55

    aget-object v2, p0, v1

    if-nez v2, :cond_10

    goto :goto_52

    .line 1486
    :cond_10
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->nativeOf(Ljava/lang/Object;)Landroid/graphics/Canvas;
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3200(Ljava/lang/Object;)Landroid/graphics/Canvas;

    move-result-object v3

    if-eqz v3, :cond_52

    .line 1488
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCurCanvas:Ljava/lang/ThreadLocal;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3300()Ljava/lang/ThreadLocal;

    move-result-object p0

    invoke-virtual {p0, v3}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    .line 1489
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3400()Z

    move-result p0

    if-nez p0, :cond_55

    const/4 p0, 0x1

    .line 1490
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasLogged:Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$3402(Z)Z

    .line 1491
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u3010GmGlass\u3011\u753b\u5e03\u622a\u83b7 \u2713 \u6765\u81ea "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1492
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " @ "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    .line 1493
    invoke-interface {p1}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 1491
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_51
    .catchall {:try_start_0 .. :try_end_51} :catchall_55

    return-void

    :cond_52
    :goto_52
    add-int/lit8 v1, v1, 0x1

    goto :goto_9

    :catchall_55
    :cond_55
    :goto_55
    return-void
.end method

.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$GlassDrawHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "GlassDrawHook"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 605
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V
    .registers 2

    .line 605
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$GlassDrawHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    const-string p0, "\u3010GmGlass\u3011\u6362\u6389\u7ed8\u5236 #"

    const-string v0, " \u21d2 \u73bb\u7483\u8ba9\u884c"

    const-string v1, "\u3010GmGlass\u3011\u7ed8\u5236\u94a9\u5b50\u7b2c "

    const-string v2, "glass.enter"

    .line 608
    # ++operator for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawEnters:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1804()I

    move-result v3

    const/4 v4, 0x3

    const/4 v5, 0x1

    if-le v3, v4, :cond_18

    const/16 v4, 0x12c

    if-eq v3, v4, :cond_18

    const/16 v4, 0xbb8

    if-ne v3, v4, :cond_4c

    .line 611
    :cond_18
    :try_start_18
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6b21\u8fdb\u5165 \u00b7 \u7c7b="

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 613
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-nez v1, :cond_38

    const-string v1, "?"

    goto :goto_42

    :cond_38
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    :goto_42
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 611
    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 615
    :cond_4c
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1900()Z

    move-result v1

    if-eqz v1, :cond_5a

    const-string p0, "autoff"

    const-string p1, "\u81ea\u52a8\u505c\u7528\u4e86"

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 616
    :cond_5a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result v1

    if-nez v1, :cond_68

    const-string p0, "off"

    const-string p1, "\u5f00\u5173\u662f\u5173\u7684"

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 617
    :cond_68
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v1, :cond_ff

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v1, v1

    if-nez v1, :cond_73

    goto/16 :goto_ff

    .line 618
    :cond_73
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    if-nez v1, :cond_82

    .line 619
    const-string p0, "nullscope"

    const-string p1, "scope \u662f null"

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 620
    :cond_82
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->looksLikeDrawScope(Ljava/lang/Object;)Z
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2100(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_8a

    goto/16 :goto_11e

    .line 626
    :cond_8a
    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->nodeBrushOf(Ljava/lang/Object;)Ljava/lang/Object;
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2200(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_9a

    .line 627
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->brushIsRuntimeBacked(Ljava/lang/Object;)Z
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2300(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_9a

    move v4, v5

    goto :goto_9b

    :cond_9a
    move v4, v2

    :goto_9b
    if-eqz v3, :cond_ae

    .line 629
    const-string p0, "reserved"

    if-eqz v4, :cond_a4

    const-string p1, "\u6211\u4eec\u7684\u56fe\u5e95"

    goto :goto_a6

    :cond_a4
    const-string p1, "\u5237\u5b50\u5e95"

    :goto_a6
    invoke-virtual {p1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 634
    :cond_ae
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object v0

    iget v0, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->scope:I

    if-ne v0, v5, :cond_c3

    .line 635
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1200()Ljava/util/Set;

    move-result-object v0

    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-interface {v0, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_c3

    goto :goto_11e

    .line 639
    :cond_c3
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->paintGlass(Ljava/lang/Object;Ljava/lang/Object;)Z
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2400(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_cc

    goto :goto_11e

    :cond_cc
    const/4 v0, 0x0

    .line 641
    invoke-virtual {p1, v0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 642
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2502(I)I

    .line 643
    # ++operator for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2604()I

    move-result p1

    if-ne p1, v5, :cond_df

    .line 647
    const-string p0, "\u3010GmGlass\u3011\u6362\u6389\u7ed8\u5236 #1\uff08\u5f00\u59cb\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    :cond_df
    const/16 v0, 0x32

    if-eq p1, v0, :cond_ef

    const/16 v0, 0xc8

    if-eq p1, v0, :cond_ef

    const/16 v0, 0x3e8

    if-eq p1, v0, :cond_ef

    .line 648
    rem-int/lit16 v0, p1, 0x7d0

    if-nez v0, :cond_11e

    .line 649
    :cond_ef
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 617
    :cond_ff
    :goto_ff
    const-string p0, "noarg"

    const-string p1, "\u6ca1\u6709\u53c2\u6570"

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2000(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_106
    .catchall {:try_start_18 .. :try_end_106} :catchall_107

    return-void

    :catchall_107
    move-exception p0

    .line 653
    # ++operator for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$2504()I

    move-result p1

    const/16 v0, 0x1e

    if-le p1, v0, :cond_11e

    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1900()Z

    move-result p1

    if-nez p1, :cond_11e

    .line 654
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1902(Z)Z

    .line 655
    const-string p1, "\u3010GmGlass\u3011\u8fde\u7eed\u51fa\u9519\uff0c\u81ea\u52a8\u505c\u7528\u73bb\u7483\uff08\u5bbf\u4e3b\u4e0d\u53d7\u5f71\u54cd\uff09"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_11e
    :goto_11e
    return-void
.end method

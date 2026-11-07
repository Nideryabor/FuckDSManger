.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NodeFactoryHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "NodeFactoryHook"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 491
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V
    .registers 2

    .line 491
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NodeFactoryHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    const-string p0, "\u3010GmGlass\u3011\u2705 Node \u771f\u8eab "

    const-string v0, "\u3010GmGlass\u3011\u6309\u94ae Node \u8bb0\u53f7\u5df2\u5efa\u7acb\uff08"

    .line 495
    :try_start_4
    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_c

    goto/16 :goto_c7

    .line 499
    :cond_c
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$400()Ljava/util/Set;

    move-result-object v2

    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-interface {v2, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_4f

    .line 500
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1200()Ljava/util/Set;

    move-result-object v2

    monitor-enter v2
    :try_end_1d
    .catchall {:try_start_4 .. :try_end_1d} :catchall_c7

    .line 501
    :try_start_1d
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1200()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 502
    monitor-exit v2
    :try_end_25
    .catchall {:try_start_1d .. :try_end_25} :catchall_4c

    .line 503
    :try_start_25
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodeLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1300()Z

    move-result v2

    if-nez v2, :cond_4f

    const/4 v2, 0x1

    .line 504
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodeLogged:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1302(Z)Z

    .line 505
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_4b
    .catchall {:try_start_25 .. :try_end_4b} :catchall_c7

    goto :goto_4f

    :catchall_4c
    move-exception p0

    .line 502
    :try_start_4d
    monitor-exit v2
    :try_end_4e
    .catchall {:try_start_4d .. :try_end_4e} :catchall_4c

    :try_start_4e
    throw p0

    .line 510
    :cond_4f
    :goto_4f
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementColor:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$900()Ljava/util/Map;

    move-result-object v0

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-eqz v0, :cond_64

    .line 512
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeColor:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1400()Ljava/util/Map;

    move-result-object v2

    invoke-interface {v2, v1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 516
    :cond_64
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementShape:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1000()Ljava/util/Map;

    move-result-object v0

    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_77

    .line 518
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeShape:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1500()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 521
    :cond_77
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    .line 522
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$600()Ljava/util/Set;

    move-result-object v0

    monitor-enter v0
    :try_end_80
    .catchall {:try_start_4e .. :try_end_80} :catchall_c7

    .line 523
    :try_start_80
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$600()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_8c

    monitor-exit v0

    return-void

    .line 524
    :cond_8c
    monitor-exit v0
    :try_end_8d
    .catchall {:try_start_80 .. :try_end_8d} :catchall_c4

    .line 525
    :try_start_8d
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookDrawLike(Ljava/lang/Class;)I
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1600(Ljava/lang/Class;)I

    move-result v0

    if-lez v0, :cond_c7

    .line 527
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$600()Ljava/util/Set;

    move-result-object v1

    monitor-enter v1
    :try_end_98
    .catchall {:try_start_8d .. :try_end_98} :catchall_c7

    .line 528
    :try_start_98
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$600()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 529
    monitor-exit v1
    :try_end_a0
    .catchall {:try_start_98 .. :try_end_a0} :catchall_c1

    .line 530
    :try_start_a0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u2192 \u6302\u4e0a "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u4e2a\u7ed8\u5236\u65b9\u6cd5"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_c0
    .catchall {:try_start_a0 .. :try_end_c0} :catchall_c7

    return-void

    :catchall_c1
    move-exception p0

    .line 529
    :try_start_c2
    monitor-exit v1
    :try_end_c3
    .catchall {:try_start_c2 .. :try_end_c3} :catchall_c1

    :try_start_c3
    throw p0
    :try_end_c4
    .catchall {:try_start_c3 .. :try_end_c4} :catchall_c7

    :catchall_c4
    move-exception p0

    .line 524
    :try_start_c5
    monitor-exit v0
    :try_end_c6
    .catchall {:try_start_c5 .. :try_end_c6} :catchall_c4

    :try_start_c6
    throw p0
    :try_end_c7
    .catchall {:try_start_c6 .. :try_end_c7} :catchall_c7

    :catchall_c7
    :cond_c7
    :goto_c7
    return-void
.end method

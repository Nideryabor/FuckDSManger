.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "PrimitiveHook"
.end annotation


# instance fields
.field private volatile attempts:I

.field private final modifierCls:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private volatile tried:Z


# direct methods
.method constructor <init>(Ljava/lang/Class;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)V"
        }
    .end annotation

    .line 219
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    const/4 v0, 0x0

    .line 217
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->tried:Z

    .line 223
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->attempts:I

    .line 220
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->modifierCls:Ljava/lang/Class;

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 245
    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object p1

    if-nez p1, :cond_7

    goto :goto_50

    .line 250
    :cond_7
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->inButton()Z

    move-result v0

    if-eqz v0, :cond_26

    .line 252
    :try_start_d
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->modifierCls:Ljava/lang/Class;

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->lastElement(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$300(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_26

    .line 254
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$400()Ljava/util/Set;

    move-result-object v1

    monitor-enter v1
    :try_end_1a
    .catchall {:try_start_d .. :try_end_1a} :catchall_26

    .line 255
    :try_start_1a
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$400()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 256
    monitor-exit v1

    goto :goto_26

    :catchall_23
    move-exception v0

    monitor-exit v1
    :try_end_25
    .catchall {:try_start_1a .. :try_end_25} :catchall_23

    :try_start_25
    throw v0
    :try_end_26
    .catchall {:try_start_25 .. :try_end_26} :catchall_26

    .line 262
    :catchall_26
    :cond_26
    :goto_26
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->tried:Z

    if-eqz v0, :cond_2b

    goto :goto_50

    .line 264
    :cond_2b
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->attempts:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->attempts:I

    const/16 v2, 0x28

    if-le v0, v2, :cond_38

    .line 265
    iput-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->tried:Z

    return-void

    .line 269
    :cond_38
    :try_start_38
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->modifierCls:Ljava/lang/Class;

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->discover(Ljava/lang/Class;Ljava/lang/Object;)V
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$500(Ljava/lang/Class;Ljava/lang/Object;)V

    .line 270
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$600()Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_50

    iput-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;->tried:Z
    :try_end_49
    .catchall {:try_start_38 .. :try_end_49} :catchall_4a

    goto :goto_50

    :catchall_4a
    move-exception p0

    .line 272
    const-string p1, "\u3010GmGlass\u3011\u6252\u80cc\u666f\u5143\u7d20\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_50
    :goto_50
    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 229
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz p0, :cond_2e

    .line 231
    array-length p1, p0

    const/4 v0, 0x0

    :goto_6
    if-ge v0, p1, :cond_2e

    aget-object v1, p0, v0

    .line 232
    instance-of v2, v1, Ljava/lang/Long;

    if-eqz v2, :cond_18

    .line 233
    check-cast v1, Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingColor:J
    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$002(J)J

    goto :goto_2b

    .line 234
    :cond_18
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$100()Ljava/lang/Class;

    move-result-object v2

    if-eqz v2, :cond_2b

    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$100()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2b

    .line 235
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingShape:Ljava/lang/Object;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$202(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2b
    .catchall {:try_start_0 .. :try_end_2b} :catchall_2e

    :cond_2b
    :goto_2b
    add-int/lit8 v0, v0, 0x1

    goto :goto_6

    :catchall_2e
    :cond_2e
    return-void
.end method

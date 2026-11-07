.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookIfElement(Ljava/lang/Class;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 425
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 12

    .line 429
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 430
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingColor:J
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$000()J

    move-result-wide v0

    long-to-int p1, v0

    .line 436
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    move v4, v2

    move-object v5, v3

    move v3, v4

    :goto_15
    if-ge v2, v1, :cond_47

    aget-object v6, v0, v2
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_63

    const/4 v7, 0x1

    .line 438
    :try_start_1a
    invoke-virtual {v6, v7}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 439
    invoke-virtual {v6}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v8

    sget-object v9, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v8, v9, :cond_2c

    .line 440
    invoke-virtual {v6, p0}, Ljava/lang/reflect/Field;->getLong(Ljava/lang/Object;)J

    move-result-wide v8

    long-to-int p1, v8

    move v4, v7

    goto :goto_44

    .line 442
    :cond_2c
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$100()Ljava/lang/Class;

    move-result-object v8

    if-eqz v8, :cond_44

    invoke-virtual {v6}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v8

    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$100()Ljava/lang/Class;

    move-result-object v9

    if-ne v8, v9, :cond_44

    .line 443
    invoke-virtual {v6, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6
    :try_end_40
    .catchall {:try_start_1a .. :try_end_40} :catchall_44

    if-eqz v6, :cond_44

    move-object v5, v6

    move v3, v7

    :catchall_44
    :cond_44
    :goto_44
    add-int/lit8 v2, v2, 0x1

    goto :goto_15

    :cond_47
    if-nez v3, :cond_4f

    if-eqz v4, :cond_4f

    .line 452
    :try_start_4b
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingShape:Ljava/lang/Object;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$200()Ljava/lang/Object;

    move-result-object v5

    .line 453
    :cond_4f
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementColor:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$900()Ljava/util/Map;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    if-eqz v5, :cond_63

    .line 454
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementShape:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$1000()Ljava/util/Map;

    move-result-object p1

    invoke-interface {p1, p0, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_63
    .catchall {:try_start_4b .. :try_end_63} :catchall_63

    :catchall_63
    :cond_63
    return-void
.end method

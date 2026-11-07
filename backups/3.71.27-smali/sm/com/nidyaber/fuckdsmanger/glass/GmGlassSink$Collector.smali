.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Collector;
.super Ljava/lang/Object;
.source "GmGlassSink.java"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Collector"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 382
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V
    .registers 2

    .line 382
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Collector;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 6

    const/4 p0, 0x0

    if-eqz p3, :cond_1e

    .line 387
    :try_start_3
    array-length p1, p3

    move p2, p0

    :goto_5
    if-ge p2, p1, :cond_1e

    aget-object v0, p3, p2

    if-eqz v0, :cond_1b

    .line 388
    instance-of v1, v0, Ljava/lang/Long;

    if-nez v1, :cond_1b

    instance-of v1, v0, Ljava/lang/Integer;

    if-eqz v1, :cond_14

    goto :goto_1b

    .line 389
    :cond_14
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookIfElement(Ljava/lang/Class;)V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->access$800(Ljava/lang/Class;)V
    :try_end_1b
    .catchall {:try_start_3 .. :try_end_1b} :catchall_1e

    :cond_1b
    :goto_1b
    add-int/lit8 p2, p2, 0x1

    goto :goto_5

    :catchall_1e
    :cond_1e
    if-eqz p3, :cond_26

    .line 394
    array-length p1, p3

    if-lez p1, :cond_26

    aget-object p0, p3, p0

    goto :goto_27

    :cond_26
    const/4 p0, 0x0

    :goto_27
    return-object p0
.end method

.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;
.super Ljava/lang/Object;
.source "GmGlassSink.java"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->lastElement(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$holder:[Ljava/lang/Object;


# direct methods
.method constructor <init>([Ljava/lang/Object;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 301
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;->val$holder:[Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 7

    const/4 p1, 0x0

    if-eqz p3, :cond_1a

    .line 305
    array-length p2, p3

    move v0, p1

    :goto_5
    if-ge v0, p2, :cond_1a

    aget-object v1, p3, v0

    if-eqz v1, :cond_17

    .line 306
    instance-of v2, v1, Ljava/lang/Long;

    if-nez v2, :cond_17

    instance-of v2, v1, Ljava/lang/Integer;

    if-nez v2, :cond_17

    .line 307
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;->val$holder:[Ljava/lang/Object;

    aput-object v1, v2, p1

    :cond_17
    add-int/lit8 v0, v0, 0x1

    goto :goto_5

    :cond_1a
    if-eqz p3, :cond_22

    .line 311
    array-length p0, p3

    if-lez p0, :cond_22

    aget-object p0, p3, p1

    return-object p0

    :cond_22
    const/4 p0, 0x0

    return-object p0
.end method

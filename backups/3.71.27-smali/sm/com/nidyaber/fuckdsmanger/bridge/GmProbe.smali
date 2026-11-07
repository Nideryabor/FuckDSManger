.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmProbe;
.super Ljava/lang/Object;
.source "GmProbe.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmProbe$ProbeHook;
    }
.end annotation


# static fields
.field public static final ENABLED:Z = false

.field private static final TARGETS:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 5

    .line 27
    const-string v0, "tu2"

    const-string v1, "vu2"

    const-string v2, "xu2"

    const-string v3, "uu2"

    const-string v4, "wu2"

    filled-new-array {v2, v3, v4, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmProbe;->TARGETS:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 1

    return-void
.end method

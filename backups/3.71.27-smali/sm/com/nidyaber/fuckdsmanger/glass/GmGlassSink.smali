.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;
.super Ljava/lang/Object;
.source "GmGlassSink.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;,
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Collector;,
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NodeFactoryHook;,
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$GlassDrawHook;,
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;,
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NativePainter;
    }
.end annotation


# static fields
.field private static final BG_CLS:Ljava/lang/String; = "p68"

.field private static final BG_METHOD:Ljava/lang/String; = "C"

.field private static volatile sAutoOff:Z

.field private static final sBitmapPaint:Landroid/graphics/Paint;

.field private static volatile sBrushCls:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static final sBtnElements:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sBtnNodeLogged:Z

.field private static final sBtnNodes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sCanvasHooked:Z

.field private static volatile sCanvasLogged:Z

.field private static volatile sChain:[Ljava/lang/reflect/Method;

.field private static volatile sChainText:Ljava/lang/String;

.field private static final sClip:Landroid/graphics/Rect;

.field private static volatile sColorLogged:Z

.field private static final sCurCanvas:Ljava/lang/ThreadLocal;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ThreadLocal<",
            "Landroid/graphics/Canvas;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sDimLogged:Z

.field private static volatile sDrawContentLogged:Z

.field private static volatile sDrawEnters:I

.field private static final sElementColor:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final sElementShape:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static final sElements:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Class<",
            "*>;>;"
        }
    .end annotation
.end field

.field private static volatile sFailStreak:I

.field private static final sFill:Landroid/graphics/Paint;

.field private static volatile sFitFail:Z

.field private static volatile sFitLogged:Z

.field private static volatile sFitOriginLogged:Z

.field private static final sHooked:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Class<",
            "*>;>;"
        }
    .end annotation
.end field

.field private static volatile sLensLogged:Z

.field private static final sLensPaint:Landroid/graphics/Paint;

.field private static final sNodeColor:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final sNodeFit:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "[",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static final sNodeShape:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sOutlineA:Ljava/lang/reflect/Method;

.field private static volatile sOutlineCls:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static volatile sOutlineM:Ljava/lang/reflect/Method;

.field private static volatile sPaintCount:I

.field private static final sPath:Landroid/graphics/Path;

.field private static volatile sPendingColor:J

.field private static volatile sPendingShape:Ljava/lang/Object;

.field private static final sRecipe:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Class<",
            "*>;[",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static final sRect:Landroid/graphics/RectF;

.field private static final sRim:Landroid/graphics/Paint;

.field private static volatile sShapeCls:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation
.end field

.field private static final sSheen:Landroid/graphics/Paint;

.field private static final sSizes:Ljava/util/LinkedHashSet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashSet<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sWallBackLogged:Z


# direct methods
.method static constructor <clinit>()V
    .registers 5

    .line 86
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    .line 87
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElements:Ljava/util/List;

    .line 96
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    .line 97
    invoke-static {v0}, Ljava/util/Collections;->newSetFromMap(Ljava/util/Map;)Ljava/util/Set;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;

    .line 99
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    .line 100
    invoke-static {v0}, Ljava/util/Collections;->newSetFromMap(Ljava/util/Map;)Ljava/util/Set;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;

    const-wide/16 v0, 0x0

    .line 109
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingColor:J

    .line 110
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    .line 111
    invoke-static {v0}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementColor:Ljava/util/Map;

    .line 112
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    .line 113
    invoke-static {v0}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeColor:Ljava/util/Map;

    const/4 v0, 0x0

    .line 124
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    .line 125
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingShape:Ljava/lang/Object;

    .line 126
    new-instance v1, Ljava/util/WeakHashMap;

    invoke-direct {v1}, Ljava/util/WeakHashMap;-><init>()V

    .line 127
    invoke-static {v1}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementShape:Ljava/util/Map;

    .line 128
    new-instance v1, Ljava/util/WeakHashMap;

    invoke-direct {v1}, Ljava/util/WeakHashMap;-><init>()V

    .line 129
    invoke-static {v1}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeShape:Ljava/util/Map;

    .line 131
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 132
    invoke-static {v1}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRecipe:Ljava/util/Map;

    .line 134
    new-instance v1, Ljava/util/WeakHashMap;

    invoke-direct {v1}, Ljava/util/WeakHashMap;-><init>()V

    .line 135
    invoke-static {v1}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeFit:Ljava/util/Map;

    .line 136
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineM:Ljava/lang/reflect/Method;

    .line 137
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineCls:Ljava/lang/Class;

    .line 138
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineA:Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    .line 139
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitLogged:Z

    .line 140
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitFail:Z

    .line 142
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitOriginLogged:Z

    .line 150
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBrushCls:Ljava/lang/Class;

    .line 152
    sput v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I

    .line 153
    sput v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I

    .line 154
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z

    .line 579
    sput v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawEnters:I

    .line 580
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodeLogged:Z

    .line 581
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sColorLogged:Z

    .line 582
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sWallBackLogged:Z

    .line 585
    new-instance v2, Ljava/util/LinkedHashSet;

    invoke-direct {v2}, Ljava/util/LinkedHashSet;-><init>()V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sSizes:Ljava/util/LinkedHashSet;

    .line 663
    new-instance v2, Landroid/graphics/Paint;

    const/4 v3, 0x1

    invoke-direct {v2, v3}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;

    .line 664
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensLogged:Z

    .line 665
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2, v3}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFill:Landroid/graphics/Paint;

    .line 666
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2, v3}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sSheen:Landroid/graphics/Paint;

    .line 667
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2, v3}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRim:Landroid/graphics/Paint;

    .line 668
    new-instance v3, Landroid/graphics/Paint;

    const/4 v4, 0x3

    invoke-direct {v3, v4}, Landroid/graphics/Paint;-><init>(I)V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBitmapPaint:Landroid/graphics/Paint;

    .line 669
    new-instance v4, Landroid/graphics/Path;

    invoke-direct {v4}, Landroid/graphics/Path;-><init>()V

    sput-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPath:Landroid/graphics/Path;

    .line 670
    new-instance v4, Landroid/graphics/RectF;

    invoke-direct {v4}, Landroid/graphics/RectF;-><init>()V

    sput-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRect:Landroid/graphics/RectF;

    .line 671
    new-instance v4, Landroid/graphics/Rect;

    invoke-direct {v4}, Landroid/graphics/Rect;-><init>()V

    sput-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sClip:Landroid/graphics/Rect;

    .line 674
    sget-object v4, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 675
    new-instance v2, Landroid/graphics/PorterDuffXfermode;

    sget-object v4, Landroid/graphics/PorterDuff$Mode;->SRC_OVER:Landroid/graphics/PorterDuff$Mode;

    invoke-direct {v2, v4}, Landroid/graphics/PorterDuffXfermode;-><init>(Landroid/graphics/PorterDuff$Mode;)V

    invoke-virtual {v3, v2}, Landroid/graphics/Paint;->setXfermode(Landroid/graphics/Xfermode;)Landroid/graphics/Xfermode;

    .line 894
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawContentLogged:Z

    .line 1413
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDimLogged:Z

    .line 1418
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChain:[Ljava/lang/reflect/Method;

    .line 1419
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    .line 1434
    new-instance v0, Ljava/lang/ThreadLocal;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCurCanvas:Ljava/lang/ThreadLocal;

    .line 1435
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasHooked:Z

    .line 1436
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasLogged:Z

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 72
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()J
    .registers 2

    .line 70
    sget-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingColor:J

    return-wide v0
.end method

.method static synthetic access$002(J)J
    .registers 2

    .line 70
    sput-wide p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingColor:J

    return-wide p0
.end method

.method static synthetic access$100()Ljava/lang/Class;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    return-object v0
.end method

.method static synthetic access$1000()Ljava/util/Map;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementShape:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$1200()Ljava/util/Set;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;

    return-object v0
.end method

.method static synthetic access$1300()Z
    .registers 1

    .line 70
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodeLogged:Z

    return v0
.end method

.method static synthetic access$1302(Z)Z
    .registers 1

    .line 70
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodeLogged:Z

    return p0
.end method

.method static synthetic access$1400()Ljava/util/Map;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeColor:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$1500()Ljava/util/Map;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeShape:Ljava/util/Map;

    return-object v0
.end method

.method static synthetic access$1600(Ljava/lang/Class;)I
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookDrawLike(Ljava/lang/Class;)I

    move-result p0

    return p0
.end method

.method static synthetic access$1804()I
    .registers 1

    .line 70
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawEnters:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawEnters:I

    return v0
.end method

.method static synthetic access$1900()Z
    .registers 1

    .line 70
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z

    return v0
.end method

.method static synthetic access$1902(Z)Z
    .registers 1

    .line 70
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sAutoOff:Z

    return p0
.end method

.method static synthetic access$200()Ljava/lang/Object;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingShape:Ljava/lang/Object;

    return-object v0
.end method

.method static synthetic access$2000(Ljava/lang/String;Ljava/lang/String;)V
    .registers 2

    .line 70
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$202(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 1

    .line 70
    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPendingShape:Ljava/lang/Object;

    return-object p0
.end method

.method static synthetic access$2100(Ljava/lang/Object;)Z
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->looksLikeDrawScope(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$2200(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->nodeBrushOf(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2300(Ljava/lang/Object;)Z
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->brushIsRuntimeBacked(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$2400(Ljava/lang/Object;Ljava/lang/Object;)Z
    .registers 2

    .line 70
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->paintGlass(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$2502(I)I
    .registers 1

    .line 70
    sput p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I

    return p0
.end method

.method static synthetic access$2504()I
    .registers 1

    .line 70
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFailStreak:I

    return v0
.end method

.method static synthetic access$2604()I
    .registers 1

    .line 70
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I

    return v0
.end method

.method static synthetic access$2700()Landroid/graphics/RectF;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRect:Landroid/graphics/RectF;

    return-object v0
.end method

.method static synthetic access$2800()Landroid/graphics/Path;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPath:Landroid/graphics/Path;

    return-object v0
.end method

.method static synthetic access$2900()Landroid/graphics/Paint;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensPaint:Landroid/graphics/Paint;

    return-object v0
.end method

.method static synthetic access$300(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 2

    .line 70
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->lastElement(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$3000()Z
    .registers 1

    .line 70
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensLogged:Z

    return v0
.end method

.method static synthetic access$3002(Z)Z
    .registers 1

    .line 70
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sLensLogged:Z

    return p0
.end method

.method static synthetic access$3100()Landroid/graphics/Paint;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBitmapPaint:Landroid/graphics/Paint;

    return-object v0
.end method

.method static synthetic access$3200(Ljava/lang/Object;)Landroid/graphics/Canvas;
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->nativeOf(Ljava/lang/Object;)Landroid/graphics/Canvas;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$3300()Ljava/lang/ThreadLocal;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCurCanvas:Ljava/lang/ThreadLocal;

    return-object v0
.end method

.method static synthetic access$3400()Z
    .registers 1

    .line 70
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasLogged:Z

    return v0
.end method

.method static synthetic access$3402(Z)Z
    .registers 1

    .line 70
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasLogged:Z

    return p0
.end method

.method static synthetic access$400()Ljava/util/Set;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;

    return-object v0
.end method

.method static synthetic access$500(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 2

    .line 70
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->discover(Ljava/lang/Class;Ljava/lang/Object;)V

    return-void
.end method

.method static synthetic access$600()Ljava/util/Set;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    return-object v0
.end method

.method static synthetic access$800(Ljava/lang/Class;)V
    .registers 1

    .line 70
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookIfElement(Ljava/lang/Class;)V

    return-void
.end method

.method static synthetic access$900()Ljava/util/Map;
    .registers 1

    .line 70
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElementColor:Ljava/util/Map;

    return-object v0
.end method

.method private static androidPathFieldOf(Ljava/lang/Class;)Ljava/lang/reflect/Field;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Field;"
        }
    .end annotation

    :goto_0
    if-eqz p0, :cond_21

    .line 1269
    const-class v0, Ljava/lang/Object;

    if-eq p0, v0, :cond_21

    .line 1270
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_c
    if-ge v2, v1, :cond_1c

    aget-object v3, v0, v2

    .line 1271
    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v4

    const-class v5, Landroid/graphics/Path;

    if-ne v4, v5, :cond_19

    return-object v3

    :cond_19
    add-int/lit8 v2, v2, 0x1

    goto :goto_c

    .line 1269
    :cond_1c
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object p0

    goto :goto_0

    :cond_21
    const/4 p0, 0x0

    return-object p0
.end method

.method private static androidPathOf(Ljava/lang/Object;)Landroid/graphics/Path;
    .registers 12

    const/4 v0, 0x2

    const/4 v1, 0x0

    const/4 v2, 0x1

    .line 1205
    :try_start_3
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    .line 1206
    sget-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sRecipe:Ljava/util/Map;

    invoke-interface {v4, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Ljava/lang/Object;

    if-nez v5, :cond_1c

    .line 1208
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->recipeFor(Ljava/lang/Class;)[Ljava/lang/Object;

    move-result-object v5

    if-nez v5, :cond_19

    .line 1209
    new-array v5, v1, [Ljava/lang/Object;

    .line 1210
    :cond_19
    invoke-interface {v4, v3, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1212
    :cond_1c
    array-length v3, v5

    if-ne v3, v0, :cond_3e

    .line 1213
    aget-object v3, v5, v1

    check-cast v3, Ljava/lang/reflect/Field;

    .line 1214
    aget-object v4, v5, v2

    check-cast v4, Ljava/lang/reflect/Field;

    .line 1215
    invoke-virtual {v3, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1216
    invoke-virtual {v4, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1217
    invoke-virtual {v3, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_3e

    .line 1219
    invoke-virtual {v4, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    .line 1220
    instance-of v4, v3, Landroid/graphics/Path;

    if-eqz v4, :cond_3e

    check-cast v3, Landroid/graphics/Path;
    :try_end_3d
    .catchall {:try_start_3 .. :try_end_3d} :catchall_3e

    return-object v3

    :catchall_3e
    :cond_3e
    const/4 v3, 0x0

    .line 1226
    :try_start_3f
    sget-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineA:Ljava/lang/reflect/Method;

    if-nez v4, :cond_73

    .line 1227
    sget-object v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineCls:Ljava/lang/Class;

    if-eqz v5, :cond_73

    .line 1228
    sget-object v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineCls:Ljava/lang/Class;

    invoke-virtual {v5}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v5

    array-length v6, v5

    move v7, v1

    :goto_4f
    if-ge v7, v6, :cond_71

    aget-object v8, v5, v7

    .line 1229
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v9

    if-eqz v9, :cond_5a

    goto :goto_6d

    .line 1230
    :cond_5a
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v9

    sget-object v10, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-ne v9, v10, :cond_63

    goto :goto_6d

    .line 1231
    :cond_63
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v9

    invoke-static {v9}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v9

    if-eqz v9, :cond_70

    :goto_6d
    add-int/lit8 v7, v7, 0x1

    goto :goto_4f

    :cond_70
    move-object v4, v8

    .line 1235
    :cond_71
    sput-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineA:Ljava/lang/reflect/Method;

    :cond_73
    if-eqz v4, :cond_98

    .line 1238
    invoke-virtual {v4, v2}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1239
    invoke-virtual {v4, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_98

    .line 1241
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->fourFloatsOf(Ljava/lang/Object;)[F

    move-result-object p0

    if-eqz p0, :cond_98

    .line 1243
    new-instance v4, Landroid/graphics/Path;

    invoke-direct {v4}, Landroid/graphics/Path;-><init>()V

    .line 1244
    aget v5, p0, v1

    aget v6, p0, v2

    aget v7, p0, v0

    const/4 v0, 0x3

    aget v8, p0, v0

    sget-object v9, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V
    :try_end_97
    .catchall {:try_start_3f .. :try_end_97} :catchall_98

    return-object v4

    :catchall_98
    :cond_98
    return-object v3
.end method

.method private static brushIsRuntimeBacked(Ljava/lang/Object;)Z
    .registers 9

    const/4 v0, 0x0

    .line 1318
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    :goto_5
    if-eqz v1, :cond_4a

    const-class v2, Ljava/lang/Object;

    if-eq v1, v2, :cond_4a

    .line 1319
    invoke-virtual {v1}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    move v4, v0

    :goto_11
    if-ge v4, v3, :cond_45

    aget-object v5, v2, v4

    .line 1320
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v6

    invoke-static {v6}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v6

    if-eqz v6, :cond_20

    goto :goto_42

    .line 1321
    :cond_20
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v6

    .line 1322
    invoke-virtual {v6}, Ljava/lang/Class;->isPrimitive()Z

    move-result v7

    if-nez v7, :cond_42

    invoke-virtual {v6}, Ljava/lang/Class;->isArray()Z

    move-result v7

    if-nez v7, :cond_42

    const-class v7, Ljava/lang/String;

    if-ne v6, v7, :cond_35

    goto :goto_42

    :cond_35
    const/4 v6, 0x1

    .line 1323
    invoke-virtual {v5, v6}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1324
    invoke-virtual {v5, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 1325
    instance-of v5, v5, Landroid/graphics/RuntimeShader;

    if-eqz v5, :cond_42

    return v6

    :cond_42
    :goto_42
    add-int/lit8 v4, v4, 0x1

    goto :goto_11

    .line 1318
    :cond_45
    invoke-virtual {v1}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v1
    :try_end_49
    .catchall {:try_start_1 .. :try_end_49} :catchall_4a

    goto :goto_5

    :catchall_4a
    :cond_4a
    return v0
.end method

.method private static canvasByFields(Ljava/lang/Object;)Landroid/graphics/Canvas;
    .registers 12

    .line 1586
    :try_start_0
    new-instance v0, Ljava/util/ArrayDeque;

    invoke-direct {v0}, Ljava/util/ArrayDeque;-><init>()V

    .line 1587
    new-instance v1, Ljava/util/IdentityHashMap;

    invoke-direct {v1}, Ljava/util/IdentityHashMap;-><init>()V

    .line 1588
    invoke-virtual {v0, p0}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z

    const/4 v2, 0x0

    .line 1589
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, p0, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move p0, v2

    .line 1591
    :cond_16
    :goto_16
    invoke-virtual {v0}, Ljava/util/ArrayDeque;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_f2

    const/16 v3, 0x190

    if-ge p0, v3, :cond_f2

    .line 1592
    invoke-virtual {v0}, Ljava/util/ArrayDeque;->poll()Ljava/lang/Object;

    move-result-object v3

    .line 1593
    invoke-virtual {v1, v3}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    add-int/lit8 p0, p0, 0x1

    .line 1596
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v5

    array-length v6, v5

    move v7, v2

    :goto_3a
    if-ge v7, v6, :cond_99

    aget-object v8, v5, v7

    .line 1597
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v9

    if-eqz v9, :cond_45

    goto :goto_96

    .line 1598
    :cond_45
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v9

    const-class v10, Landroid/graphics/Canvas;

    if-eq v9, v10, :cond_4e

    goto :goto_96

    .line 1599
    :cond_4e
    invoke-static {v8, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    .line 1600
    instance-of v10, v9, Landroid/graphics/Canvas;

    if-eqz v10, :cond_96

    .line 1601
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "field:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    .line 1602
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u3010GmGlass\u3011\u753b\u5e03\u94fe\uff1a"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1603
    check-cast v9, Landroid/graphics/Canvas;

    return-object v9

    :cond_96
    :goto_96
    add-int/lit8 v7, v7, 0x1

    goto :goto_3a

    :cond_99
    const/4 v5, 0x4

    if-lt v4, v5, :cond_9e

    goto/16 :goto_16

    .line 1607
    :cond_9e
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v5

    array-length v6, v5

    move v7, v2

    :goto_a8
    if-ge v7, v6, :cond_16

    aget-object v8, v5, v7

    .line 1608
    invoke-virtual {v8}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v9

    .line 1609
    invoke-virtual {v9}, Ljava/lang/Class;->isPrimitive()Z

    move-result v10

    if-nez v10, :cond_ef

    const-class v10, Ljava/lang/String;

    if-eq v9, v10, :cond_ef

    invoke-virtual {v9}, Ljava/lang/Class;->isArray()Z

    move-result v10

    if-eqz v10, :cond_c1

    goto :goto_ef

    .line 1610
    :cond_c1
    const-class v10, Ljava/lang/Class;

    if-eq v9, v10, :cond_ef

    invoke-virtual {v9}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v9

    const-string v10, "java."

    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9
    :try_end_cf
    .catchall {:try_start_0 .. :try_end_cf} :catchall_10c

    if-eqz v9, :cond_d2

    goto :goto_ef

    :cond_d2
    const/4 v9, 0x1

    .line 1612
    :try_start_d3
    invoke-virtual {v8, v9}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1613
    invoke-virtual {v8, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    if-eqz v8, :cond_ef

    .line 1614
    invoke-virtual {v1, v8}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_e3

    goto :goto_ef

    :cond_e3
    add-int/lit8 v9, v4, 0x1

    .line 1615
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-virtual {v1, v8, v9}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1616
    invoke-virtual {v0, v8}, Ljava/util/ArrayDeque;->add(Ljava/lang/Object;)Z
    :try_end_ef
    .catchall {:try_start_d3 .. :try_end_ef} :catchall_ef

    :catchall_ef
    :cond_ef
    :goto_ef
    add-int/lit8 v7, v7, 0x1

    goto :goto_a8

    .line 1621
    :cond_f2
    :try_start_f2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u3010GmGlass\u3011\u5b57\u6bb5\u722c\u884c\u6ca1\u627e\u5230\u753b\u5e03\uff08\u8d70\u4e86 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u4e2a\u5bf9\u8c61\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_10b
    .catchall {:try_start_f2 .. :try_end_10b} :catchall_10c

    goto :goto_120

    :catchall_10c
    move-exception p0

    .line 1623
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u5b57\u6bb5\u722c\u884c\u51fa\u9519\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "glass.field.err"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :goto_120
    const/4 p0, 0x0

    return-object p0
.end method

.method private static canvasOf(Ljava/lang/Object;)Landroid/graphics/Canvas;
    .registers 25

    .line 1520
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChain:[Ljava/lang/reflect/Method;

    const/4 v1, 0x0

    if-eqz v0, :cond_1d

    .line 1524
    :try_start_5
    array-length v3, v0

    move-object/from16 v5, p0

    const/4 v4, 0x0

    :goto_9
    if-ge v4, v3, :cond_14

    aget-object v6, v0, v4

    invoke-virtual {v6, v5, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    add-int/lit8 v4, v4, 0x1

    goto :goto_9

    .line 1525
    :cond_14
    instance-of v0, v5, Landroid/graphics/Canvas;

    if-eqz v0, :cond_1b

    check-cast v5, Landroid/graphics/Canvas;
    :try_end_1a
    .catchall {:try_start_5 .. :try_end_1a} :catchall_1b

    return-object v5

    .line 1528
    :catchall_1b
    :cond_1b
    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChain:[Ljava/lang/reflect/Method;

    .line 1532
    :cond_1d
    :try_start_1d
    invoke-virtual/range {p0 .. p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v0

    array-length v3, v0

    const/4 v4, 0x0

    :goto_27
    if-ge v4, v3, :cond_183

    aget-object v5, v0, v4

    .line 1533
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-eqz v6, :cond_3d

    :cond_31
    :goto_31
    move-object/from16 v6, p0

    :cond_33
    :goto_33
    move-object/from16 v20, v0

    move-object/from16 v16, v1

    move/from16 v23, v3

    const/16 v17, 0x0

    goto/16 :goto_179

    .line 1534
    :cond_3d
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    .line 1535
    invoke-virtual {v6}, Ljava/lang/Class;->isPrimitive()Z

    move-result v7
    :try_end_45
    .catchall {:try_start_1d .. :try_end_45} :catchall_188

    if-nez v7, :cond_31

    const-class v7, Ljava/lang/String;

    if-eq v6, v7, :cond_31

    :try_start_4b
    invoke-virtual {v6}, Ljava/lang/Class;->isArray()Z

    move-result v6
    :try_end_4f
    .catchall {:try_start_4b .. :try_end_4f} :catchall_188

    if-eqz v6, :cond_52

    goto :goto_31

    :cond_52
    move-object/from16 v6, p0

    .line 1536
    :try_start_54
    invoke-static {v5, v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    if-nez v8, :cond_5b

    goto :goto_33

    .line 1538
    :cond_5b
    invoke-virtual {v8}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v9

    array-length v10, v9

    const/4 v11, 0x0

    :goto_65
    if-ge v11, v10, :cond_33

    aget-object v12, v9, v11

    .line 1539
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v13

    if-eqz v13, :cond_79

    move-object/from16 v20, v0

    move-object/from16 v16, v1

    move/from16 v23, v3

    const/16 v17, 0x0

    goto/16 :goto_16b

    .line 1540
    :cond_79
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v13

    .line 1541
    const-class v14, Landroid/graphics/Canvas;
    :try_end_7f
    .catchall {:try_start_54 .. :try_end_7f} :catchall_177

    const-string v15, "\u3010GmGlass\u3011\u753b\u5e03\u94fe\uff1a"

    move-object/from16 v16, v1

    const/4 v1, 0x2

    const/16 v17, 0x0

    const-string v2, "\u2192"

    const/16 v18, 0x1

    if-ne v13, v14, :cond_cb

    .line 1542
    :try_start_8c
    new-array v0, v1, [Ljava/lang/reflect/Method;

    aput-object v5, v0, v17

    aput-object v12, v0, v18

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChain:[Ljava/lang/reflect/Method;

    .line 1543
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    .line 1544
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1545
    invoke-static {v12, v8}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/graphics/Canvas;

    return-object v0

    .line 1547
    :cond_cb
    invoke-virtual {v13}, Ljava/lang/Class;->isPrimitive()Z

    move-result v14

    if-nez v14, :cond_167

    if-eq v13, v7, :cond_167

    invoke-virtual {v13}, Ljava/lang/Class;->isArray()Z

    move-result v13

    if-eqz v13, :cond_db

    goto/16 :goto_167

    .line 1548
    :cond_db
    invoke-static {v12, v8}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    if-nez v13, :cond_e3

    goto/16 :goto_167

    .line 1550
    :cond_e3
    invoke-virtual {v13}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v14

    invoke-virtual {v14}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v14

    move/from16 v19, v1

    array-length v1, v14

    move-object/from16 v20, v0

    move/from16 v0, v17

    :goto_f2
    if-ge v0, v1, :cond_169

    move/from16 v21, v0

    aget-object v0, v14, v21

    .line 1551
    invoke-virtual {v0}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v22

    if-eqz v22, :cond_103

    move/from16 v22, v1

    move/from16 v23, v3

    goto :goto_160

    :cond_103
    move/from16 v22, v1

    .line 1552
    invoke-virtual {v0}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v1

    move/from16 v23, v3

    const-class v3, Landroid/graphics/Canvas;

    if-eq v1, v3, :cond_110

    goto :goto_160

    .line 1553
    :cond_110
    invoke-static {v0, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 1554
    instance-of v3, v1, Landroid/graphics/Canvas;

    if-eqz v3, :cond_160

    const/4 v3, 0x3

    .line 1555
    new-array v3, v3, [Ljava/lang/reflect/Method;

    aput-object v5, v3, v17

    aput-object v12, v3, v18

    aput-object v0, v3, v19

    sput-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChain:[Ljava/lang/reflect/Method;

    .line 1556
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    .line 1557
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1558
    check-cast v1, Landroid/graphics/Canvas;
    :try_end_15f
    .catchall {:try_start_8c .. :try_end_15f} :catchall_175

    return-object v1

    :cond_160
    :goto_160
    add-int/lit8 v0, v21, 0x1

    move/from16 v1, v22

    move/from16 v3, v23

    goto :goto_f2

    :cond_167
    :goto_167
    move-object/from16 v20, v0

    :cond_169
    move/from16 v23, v3

    :goto_16b
    add-int/lit8 v11, v11, 0x1

    move-object/from16 v1, v16

    move-object/from16 v0, v20

    move/from16 v3, v23

    goto/16 :goto_65

    :catchall_175
    move-exception v0

    goto :goto_18d

    :catchall_177
    move-exception v0

    goto :goto_18b

    :goto_179
    add-int/lit8 v4, v4, 0x1

    move-object/from16 v1, v16

    move-object/from16 v0, v20

    move/from16 v3, v23

    goto/16 :goto_27

    :cond_183
    move-object/from16 v6, p0

    move-object/from16 v16, v1

    goto :goto_190

    :catchall_188
    move-exception v0

    move-object/from16 v6, p0

    :goto_18b
    move-object/from16 v16, v1

    .line 1564
    :goto_18d
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    .line 1569
    :goto_190
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->canvasByFields(Ljava/lang/Object;)Landroid/graphics/Canvas;

    move-result-object v0

    if-eqz v0, :cond_197

    return-object v0

    .line 1572
    :cond_197
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sChainText:Ljava/lang/String;

    if-nez v0, :cond_1c2

    .line 1573
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u627e\u4e0d\u5230\u539f\u751f\u753b\u5e03 \u00b7 scopeCls="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u00b7 \u63a2\u67e5="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1574
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->dumpScope(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1573
    const-string v1, "nochain"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1c2
    return-object v16
.end method

.method private static catchCanvas(Ljava/lang/Class;)V
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)V"
        }
    .end annotation

    .line 1467
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasHooked:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    .line 1468
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCanvasHooked:Z

    const/4 v1, 0x0

    .line 1471
    :try_start_9
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v3, v2
    :try_end_e
    .catchall {:try_start_9 .. :try_end_e} :catchall_3a

    move v4, v1

    :goto_f
    if-ge v1, v3, :cond_4f

    :try_start_11
    aget-object v5, v2, v1

    .line 1472
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-lt v6, v0, :cond_34

    const/16 v7, 0x8

    if-le v6, v7, :cond_1e

    goto :goto_34

    .line 1474
    :cond_1e
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Ljava/lang/Void;->TYPE:Ljava/lang/Class;
    :try_end_24
    .catchall {:try_start_11 .. :try_end_24} :catchall_37

    if-eq v6, v7, :cond_27

    goto :goto_34

    .line 1476
    :cond_27
    :try_start_27
    invoke-virtual {v5, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_2a
    .catchall {:try_start_27 .. :try_end_2a} :catchall_2a

    .line 1479
    :catchall_2a
    :try_start_2a
    new-instance v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$4;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$4;-><init>()V

    invoke-static {v5, v6}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_32
    .catchall {:try_start_2a .. :try_end_32} :catchall_37

    add-int/lit8 v4, v4, 0x1

    :cond_34
    :goto_34
    add-int/lit8 v1, v1, 0x1

    goto :goto_f

    :catchall_37
    move-exception v0

    move v1, v4

    goto :goto_3b

    :catchall_3a
    move-exception v0

    .line 1505
    :goto_3b
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010GmGlass\u3011\u753b\u5e03\u622a\u83b7\u6302\u8f7d\u5931\u8d25\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "glass.catch.err"

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    move v4, v1

    .line 1507
    :cond_4f
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u753b\u5e03\u622a\u83b7\u94a9\u5b50 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6761\uff08"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static densityOf(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/Object;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 1167
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_b
    if-ge v3, v2, :cond_2b

    aget-object v4, v1, v3

    .line 1168
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v5

    if-eqz v5, :cond_16

    goto :goto_28

    .line 1169
    :cond_16
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    if-eq v5, p1, :cond_1d

    goto :goto_28

    :cond_1d
    const/4 v5, 0x1

    .line 1170
    invoke-virtual {v4, v5}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1171
    invoke-virtual {v4, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4
    :try_end_25
    .catchall {:try_start_1 .. :try_end_25} :catchall_2b

    if-eqz v4, :cond_28

    return-object v4

    :cond_28
    :goto_28
    add-int/lit8 v3, v3, 0x1

    goto :goto_b

    :catchall_2b
    :cond_2b
    return-object v0
.end method

.method private static densityProxy(Ljava/lang/Class;)Ljava/lang/Object;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/Object;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 1182
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Class;->isInterface()Z

    move-result v1

    if-nez v1, :cond_8

    return-object v0

    .line 1183
    :cond_8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->density()F

    move-result v1

    .line 1184
    invoke-virtual {p0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Class;

    const/4 v4, 0x0

    aput-object p0, v3, v4

    new-instance p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$3;

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$3;-><init>(F)V

    invoke-static {v2, v3, p0}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0
    :try_end_1f
    .catchall {:try_start_1 .. :try_end_1f} :catchall_20

    return-object p0

    :catchall_20
    return-object v0
.end method

.method static dim(Ljava/lang/Object;I)F
    .registers 16

    const/high16 v0, -0x40800000    # -1.0f

    .line 1361
    :try_start_2
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 1362
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 1363
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v3

    array-length v4, v3

    const/4 v5, 0x0

    move v6, v5

    :goto_17
    const/16 v7, 0x20

    const/4 v8, 0x1

    if-ge v6, v4, :cond_71

    aget-object v9, v3, v6

    .line 1364
    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v10

    if-eqz v10, :cond_25

    goto :goto_6e

    .line 1365
    :cond_25
    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v10

    sget-object v11, Ljava/lang/Long;->TYPE:Ljava/lang/Class;
    :try_end_2b
    .catchall {:try_start_2 .. :try_end_2b} :catchall_17b

    if-eq v10, v11, :cond_2e

    goto :goto_6e

    :cond_2e
    const/4 v10, 0x0

    .line 1367
    :try_start_2f
    invoke-virtual {v9, p0, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/Long;

    invoke-virtual {v10}, Ljava/lang/Long;->longValue()J

    move-result-wide v10

    shr-long v12, v10, v7

    long-to-int v7, v12

    .line 1368
    invoke-static {v7}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result v7

    const-wide v12, 0xffffffffL

    and-long/2addr v10, v12

    long-to-int v10, v10

    .line 1369
    invoke-static {v10}, Ljava/lang/Float;->intBitsToFloat(I)F

    move-result v10

    const/high16 v11, 0x3f800000    # 1.0f

    cmpl-float v12, v7, v11

    if-lez v12, :cond_6e

    cmpl-float v11, v10, v11

    if-lez v11, :cond_6e

    .line 1370
    invoke-static {v7}, Ljava/lang/Float;->isNaN(F)Z

    move-result v11

    if-nez v11, :cond_6e

    invoke-static {v10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v11

    if-nez v11, :cond_6e

    const/4 v11, 0x2

    .line 1371
    new-array v11, v11, [F

    aput v7, v11, v5

    aput v10, v11, v8

    invoke-interface {v1, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1372
    invoke-interface {v2, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_6e
    .catchall {:try_start_2f .. :try_end_6e} :catchall_6e

    :catchall_6e
    :cond_6e
    :goto_6e
    add-int/lit8 v6, v6, 0x1

    goto :goto_17

    .line 1377
    :cond_71
    :try_start_71
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_78

    return v0

    .line 1379
    :cond_78
    invoke-interface {v1, v5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [F

    .line 1380
    const-string v3, "\u9996\u4e2a\u5019\u9009"

    move v4, v5

    .line 1383
    :goto_81
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v6

    if-ge v4, v6, :cond_ed

    move v6, v5

    .line 1384
    :goto_88
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v9

    if-ge v6, v9, :cond_ea

    if-ne v4, v6, :cond_91

    goto :goto_e7

    .line 1386
    :cond_91
    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, [F

    invoke-interface {v1, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, [F

    .line 1387
    aget v11, v9, v5

    const/high16 v12, 0x40000000    # 2.0f

    mul-float/2addr v11, v12

    aget v13, v10, v5

    sub-float/2addr v11, v13

    invoke-static {v11}, Ljava/lang/Math;->abs(F)F

    move-result v11

    const/high16 v13, 0x3fc00000    # 1.5f

    cmpg-float v11, v11, v13

    if-gtz v11, :cond_e7

    aget v9, v9, v8

    mul-float/2addr v9, v12

    aget v11, v10, v8

    sub-float/2addr v9, v11

    invoke-static {v9}, Ljava/lang/Math;->abs(F)F

    move-result v9

    cmpg-float v9, v9, v13

    if-gtz v9, :cond_e7

    .line 1389
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-interface {v2, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/reflect/Method;

    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \u662f center \u21d2 \u53d6 "

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1390
    invoke-interface {v2, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/reflect/Method;

    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object p0, v10

    goto :goto_ed

    :cond_e7
    :goto_e7
    add-int/lit8 v6, v6, 0x1

    goto :goto_88

    :cond_ea
    add-int/lit8 v4, v4, 0x1

    goto :goto_81

    .line 1395
    :cond_ed
    :goto_ed
    sget-boolean v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDimLogged:Z

    if-nez v4, :cond_173

    .line 1396
    sput-boolean v8, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDimLogged:Z

    .line 1397
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    move v6, v5

    .line 1398
    :goto_f9
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v9

    if-ge v6, v9, :cond_134

    .line 1399
    invoke-interface {v2, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/reflect/Method;

    invoke-virtual {v9}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "()="

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1400
    invoke-interface {v1, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, [F

    aget v9, v9, v5

    float-to-int v9, v9

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "x"

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1401
    invoke-interface {v1, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, [F

    aget v9, v9, v8

    float-to-int v9, v9

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v6, v6, 0x1

    goto :goto_f9

    .line 1403
    :cond_134
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010GmGlass\u3011\u5c3a\u5bf8\u62ff\u6cd5\uff1a"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " \u2192 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v2, p0, v5

    float-to-int v2, v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " x "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v2, p0, v8

    float-to-int v2, v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u5019\u9009{m"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1405
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "}"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1403
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_173
    if-nez p1, :cond_178

    .line 1407
    aget p0, p0, v5

    goto :goto_17a

    :cond_178
    aget p0, p0, v8
    :try_end_17a
    .catchall {:try_start_71 .. :try_end_17a} :catchall_17b

    :goto_17a
    return p0

    :catchall_17b
    return v0
.end method

.method private static discover(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 15
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/Object;",
            ")V"
        }
    .end annotation

    .line 340
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 341
    invoke-virtual {p0}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    move v5, v4

    :goto_d
    const/4 v6, 0x0

    if-ge v4, v2, :cond_9e

    aget-object v7, v1, v4

    .line 342
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 343
    array-length v9, v8

    const/4 v10, 0x2

    if-eq v9, v10, :cond_1c

    goto/16 :goto_9a

    .line 344
    :cond_1c
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v9

    sget-object v11, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-ne v9, v11, :cond_26

    goto/16 :goto_9a

    :cond_26
    move v9, v3

    :goto_27
    if-ge v9, v10, :cond_39

    .line 347
    aget-object v11, v8, v9

    invoke-virtual {v11}, Ljava/lang/Class;->isInterface()Z

    move-result v11

    if-eqz v11, :cond_36

    aget-object v11, v8, v9

    if-eq v11, p0, :cond_36

    goto :goto_3a

    :cond_36
    add-int/lit8 v9, v9, 0x1

    goto :goto_27

    :cond_39
    const/4 v9, -0x1

    :goto_3a
    if-gez v9, :cond_3d

    goto :goto_9a

    :cond_3d
    const/4 v11, 0x1

    .line 355
    :try_start_3e
    invoke-virtual {v7, v11}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 356
    invoke-virtual {p0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v12

    new-array v11, v11, [Ljava/lang/Class;

    aget-object v8, v8, v9

    aput-object v8, v11, v3

    new-instance v8, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Collector;

    invoke-direct {v8, v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Collector;-><init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V

    invoke-static {v12, v11, v8}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v6

    .line 358
    new-array v8, v10, [Ljava/lang/Object;

    .line 359
    aput-object v6, v8, v9

    .line 360
    invoke-virtual {v7, p1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v5, v5, 0x1

    .line 362
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v6

    const/16 v8, 0x12c

    if-ge v6, v8, :cond_9a

    .line 363
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "(proxy@"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, ") "

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_79
    .catchall {:try_start_3e .. :try_end_79} :catchall_7a

    goto :goto_9a

    :catchall_7a
    move-exception v6

    .line 366
    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "\u3010GmGlass\u3011"

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " \u6316\u5143\u7d20\u5931\u8d25\uff1a"

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const-string v7, "glass.fold.err"

    invoke-static {v7, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_9a
    :goto_9a
    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_d

    .line 369
    :cond_9e
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "\u3010GmGlass\u3011\u6316\u5143\u7d20\uff1a\u8bd5\u4e86 "

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u4e2a\u6298\u53e0\u65b9\u6cd5["

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, "]\u00b7 \u5143\u7d20\u7c7b "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElements:Ljava/util/List;

    .line 370
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a \u00b7 \u6302\u4e0a\u7ed8\u5236 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 369
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 373
    invoke-interface {v0}, Ljava/util/Set;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_111

    .line 374
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 375
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_e7
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_100

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Class;

    .line 376
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v0, 0x20

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_e7

    .line 378
    :cond_100
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u3010GmGlass\u3011\u4e00\u4e2a\u7ed8\u5236\u65b9\u6cd5\u90fd\u6ca1\u6302\u4e0a\uff01\u5019\u9009\u5143\u7d20\u7c7b="

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_111
    return-void
.end method

.method private static drawContentOf(Ljava/lang/Object;)V
    .registers 11

    const/4 v0, 0x0

    .line 906
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const/4 v2, 0x0

    move-object v3, v2

    :goto_7
    if-eqz v1, :cond_4f

    const-class v4, Ljava/lang/Object;

    if-eq v1, v4, :cond_4f

    .line 907
    invoke-virtual {v1}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v4

    array-length v5, v4

    move v6, v0

    :goto_13
    if-ge v6, v5, :cond_4a

    aget-object v7, v4, v6

    .line 908
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v8

    if-eqz v8, :cond_1e

    goto :goto_47

    .line 909
    :cond_1e
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v8

    sget-object v9, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-eq v8, v9, :cond_27

    goto :goto_47

    .line 910
    :cond_27
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v8

    invoke-static {v8}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v8

    if-eqz v8, :cond_32

    goto :goto_47

    :cond_32
    if-eqz v3, :cond_46

    .line 911
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v9

    if-ge v8, v9, :cond_47

    :cond_46
    move-object v3, v7

    :cond_47
    :goto_47
    add-int/lit8 v6, v6, 0x1

    goto :goto_13

    .line 906
    :cond_4a
    invoke-virtual {v1}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v1

    goto :goto_7

    :cond_4f
    if-nez v3, :cond_70

    .line 915
    const-string v1, "nocontent"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u627e\u4e0d\u5230 drawContent\uff080 \u53c2 void \u65b9\u6cd5\uff09\u00b7 scopeCls="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 916
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 915
    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_70
    const/4 v1, 0x1

    .line 919
    invoke-virtual {v3, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 920
    invoke-virtual {v3, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 921
    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawContentLogged:Z

    if-nez v2, :cond_aa

    .line 922
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sDrawContentLogged:Z

    .line 923
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010GmGlass\u3011drawContent \u5df2\u63a5\u56de\uff1a"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "."

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 924
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "()"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 923
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_aa
    .catchall {:try_start_1 .. :try_end_aa} :catchall_ab

    :cond_aa
    return-void

    :catchall_ab
    move-exception p0

    .line 928
    instance-of v1, p0, Ljava/lang/reflect/InvocationTargetException;

    if-eqz v1, :cond_ba

    .line 929
    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object v1

    if-eqz v1, :cond_ba

    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p0

    .line 930
    :cond_ba
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "drawContent \u8c03\u7528\u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " @"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 931
    invoke-virtual {p0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v2

    array-length v2, v2

    if-lez v2, :cond_d7

    invoke-virtual {p0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object p0

    aget-object p0, p0, v0

    goto :goto_d9

    :cond_d7
    const-string p0, "?"

    :goto_d9
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 930
    const-string v0, "contenterr"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static dumpScope(Ljava/lang/Object;)Ljava/lang/String;
    .registers 21

    .line 1630
    const-string v0, "."

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 1633
    :try_start_7
    invoke-virtual/range {p0 .. p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v3, v2

    const/4 v5, 0x0

    const/4 v6, 0x0

    :goto_12
    if-ge v5, v3, :cond_13b

    aget-object v7, v2, v5

    .line 1634
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v8

    if-eqz v8, :cond_1f

    :cond_1c
    :goto_1c
    move-object/from16 v8, p0

    goto :goto_65

    .line 1635
    :cond_1f
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v8

    .line 1636
    invoke-virtual {v8}, Ljava/lang/Class;->isPrimitive()Z

    move-result v9
    :try_end_27
    .catchall {:try_start_7 .. :try_end_27} :catchall_132

    if-nez v9, :cond_1c

    const-class v9, Ljava/lang/String;

    if-eq v8, v9, :cond_1c

    :try_start_2d
    invoke-virtual {v8}, Ljava/lang/Class;->isArray()Z

    move-result v8

    if-eqz v8, :cond_34

    goto :goto_1c

    :cond_34
    const/16 v8, 0x8

    if-lt v6, v8, :cond_3a

    goto/16 :goto_13b

    :cond_3a
    move-object/from16 v8, p0

    .line 1638
    invoke-static {v7, v8}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    .line 1639
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, "->"

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v10, :cond_51

    .line 1640
    const-string v11, "null"

    goto :goto_59

    :cond_51
    invoke-virtual {v10}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v11

    :goto_59
    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v11, 0x20

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v6, v6, 0x1

    if-nez v10, :cond_6b

    :cond_65
    :goto_65
    move-object/from16 v16, v2

    move/from16 v19, v3

    goto/16 :goto_12a

    .line 1644
    :cond_6b
    invoke-virtual {v10}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v11

    array-length v12, v11

    const/4 v13, 0x0

    :goto_75
    if-ge v13, v12, :cond_9d

    aget-object v14, v11, v13

    .line 1645
    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v15

    if-eqz v15, :cond_80

    goto :goto_9a

    .line 1646
    :cond_80
    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v15

    const-class v4, Landroid/graphics/Canvas;

    if-eq v15, v4, :cond_89

    goto :goto_9a

    .line 1647
    :cond_89
    const-string v4, "[Canvas via "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "!] "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_9a
    add-int/lit8 v13, v13, 0x1

    goto :goto_75

    .line 1650
    :cond_9d
    invoke-virtual {v10}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v4

    array-length v11, v4

    const/4 v12, 0x0

    :goto_a7
    if-ge v12, v11, :cond_65

    aget-object v13, v4, v12

    .line 1651
    invoke-virtual {v13}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v14

    if-eqz v14, :cond_b7

    :cond_b1
    :goto_b1
    move-object/from16 v16, v2

    :cond_b3
    move/from16 v19, v3

    goto/16 :goto_122

    .line 1652
    :cond_b7
    invoke-virtual {v13}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v14

    .line 1653
    invoke-virtual {v14}, Ljava/lang/Class;->isPrimitive()Z

    move-result v15

    if-nez v15, :cond_b1

    if-eq v14, v9, :cond_b1

    invoke-virtual {v14}, Ljava/lang/Class;->isArray()Z

    move-result v14

    if-eqz v14, :cond_ca

    goto :goto_b1

    .line 1654
    :cond_ca
    invoke-static {v13, v10}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    if-nez v14, :cond_d1

    goto :goto_b1

    .line 1656
    :cond_d1
    invoke-virtual {v14}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v14

    invoke-virtual {v14}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v14

    array-length v15, v14

    move-object/from16 v16, v2

    const/4 v2, 0x0

    :goto_dd
    if-ge v2, v15, :cond_b3

    aget-object v17, v14, v2

    .line 1657
    invoke-virtual/range {v17 .. v17}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v18

    if-nez v18, :cond_119

    move/from16 v18, v2

    invoke-virtual/range {v17 .. v17}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v2

    move/from16 v19, v3

    const-class v3, Landroid/graphics/Canvas;

    if-ne v2, v3, :cond_11d

    .line 1658
    const-string v2, "{"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1659
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual/range {v17 .. v17}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "=Canvas}"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_118
    .catchall {:try_start_2d .. :try_end_118} :catchall_132

    goto :goto_11d

    :cond_119
    move/from16 v18, v2

    move/from16 v19, v3

    :cond_11d
    :goto_11d
    add-int/lit8 v2, v18, 0x1

    move/from16 v3, v19

    goto :goto_dd

    :goto_122
    add-int/lit8 v12, v12, 0x1

    move-object/from16 v2, v16

    move/from16 v3, v19

    goto/16 :goto_a7

    :goto_12a
    add-int/lit8 v5, v5, 0x1

    move-object/from16 v2, v16

    move/from16 v3, v19

    goto/16 :goto_12

    :catchall_132
    move-exception v0

    .line 1665
    const-string v2, "err="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 1667
    :cond_13b
    :goto_13b
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static fitPathFrom(Ljava/lang/Object;Ljava/lang/Object;FF)Landroid/graphics/Path;
    .registers 15

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 1099
    :try_start_2
    sget-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineM:Ljava/lang/reflect/Method;

    if-nez v2, :cond_3e

    .line 1101
    sget-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    if-nez v3, :cond_b

    return-object v1

    .line 1102
    :cond_b
    sget-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    invoke-virtual {v3}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v3

    array-length v4, v3

    const/4 v5, 0x0

    move v6, v5

    :goto_14
    if-ge v6, v4, :cond_33

    aget-object v7, v3, v6

    .line 1103
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 1104
    array-length v9, v8

    const/4 v10, 0x3

    if-ne v9, v10, :cond_30

    aget-object v8, v8, v5

    sget-object v9, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne v8, v9, :cond_30

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v8

    sget-object v9, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-eq v8, v9, :cond_30

    move-object v2, v7

    goto :goto_33

    :cond_30
    add-int/lit8 v6, v6, 0x1

    goto :goto_14

    :cond_33
    :goto_33
    if-nez v2, :cond_36

    return-object v1

    .line 1110
    :cond_36
    sput-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineM:Ljava/lang/reflect/Method;

    .line 1111
    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sOutlineCls:Ljava/lang/Class;

    .line 1113
    :cond_3e
    invoke-virtual {v2, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1114
    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v3

    .line 1115
    invoke-static {p2}, Ljava/lang/Float;->floatToRawIntBits(F)I

    move-result p2

    int-to-long v4, p2

    const/16 p2, 0x20

    shl-long/2addr v4, p2

    .line 1116
    invoke-static {p3}, Ljava/lang/Float;->floatToRawIntBits(F)I

    move-result p2

    int-to-long p2, p2

    const-wide v6, 0xffffffffL

    and-long/2addr p2, v6

    or-long/2addr p2, v4

    .line 1117
    aget-object v4, v3, v0

    invoke-static {p1, v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->layoutDirOf(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v4

    const/4 v5, 0x2

    .line 1118
    aget-object v6, v3, v5

    invoke-virtual {v6, p1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_6a

    move-object v6, p1

    goto :goto_6b

    :cond_6a
    move-object v6, v1

    :goto_6b
    if-nez v6, :cond_73

    .line 1119
    aget-object v6, v3, v5

    invoke-static {p1, v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->densityOf(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v6

    :cond_73
    if-nez v6, :cond_7b

    .line 1120
    aget-object v3, v3, v5

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->densityProxy(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v6

    :cond_7b
    if-nez v6, :cond_7e

    goto :goto_7f

    :cond_7e
    move-object p1, v6

    .line 1122
    :goto_7f
    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    filled-new-array {p2, v4, p1}, [Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {v2, p0, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_8e

    return-object v1

    .line 1124
    :cond_8e
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->androidPathOf(Ljava/lang/Object;)Landroid/graphics/Path;

    move-result-object p0

    if-nez p0, :cond_95

    return-object v1

    .line 1126
    :cond_95
    sget-boolean p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitLogged:Z

    if-nez p1, :cond_a0

    .line 1127
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitLogged:Z

    .line 1128
    const-string p1, "\u3010GmGlass\u3011\u8f6e\u5ed3\u63a5\u529b \u2713\uff08createOutline \u2192 Path\uff0c\u8d34\u5408\u5f62\u72b6\u5df2\u5c31\u7eea\uff09"

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1130
    :cond_a0
    new-instance p1, Landroid/graphics/Path;

    invoke-direct {p1, p0}, Landroid/graphics/Path;-><init>(Landroid/graphics/Path;)V
    :try_end_a5
    .catchall {:try_start_2 .. :try_end_a5} :catchall_a6

    return-object p1

    :catchall_a6
    move-exception p0

    .line 1132
    sget-boolean p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitFail:Z

    if-nez p1, :cond_c0

    .line 1133
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitFail:Z

    .line 1134
    instance-of p1, p0, Ljava/lang/reflect/InvocationTargetException;

    if-eqz p1, :cond_bb

    .line 1135
    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p1

    if-eqz p1, :cond_bb

    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p0

    .line 1136
    :cond_bb
    const-string p1, "\u3010GmGlass\u3011\u8d34\u5408\u5f62\u72b6\u5931\u8d25\uff08\u5df2\u81ea\u52a8\u8df3\u8fc7\uff0c\u73bb\u7483\u7167\u5e38\uff09"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_c0
    return-object v1
.end method

.method private static fourFloatsOf(Ljava/lang/Object;)[F
    .registers 12

    const/4 v0, 0x4

    .line 1279
    new-array v1, v0, [F

    .line 1282
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const/4 v3, 0x0

    move v4, v3

    :goto_9
    if-eqz v2, :cond_3a

    const-class v5, Ljava/lang/Object;

    if-eq v2, v5, :cond_3a

    .line 1283
    invoke-virtual {v2}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v5

    array-length v6, v5

    move v7, v3

    :goto_15
    if-ge v7, v6, :cond_35

    aget-object v8, v5, v7

    .line 1284
    invoke-virtual {v8}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v9

    sget-object v10, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    if-eq v9, v10, :cond_22

    goto :goto_32

    :cond_22
    if-lt v4, v0, :cond_25

    goto :goto_3a

    :cond_25
    const/4 v9, 0x1

    .line 1287
    :try_start_26
    invoke-virtual {v8, v9}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_29
    .catchall {:try_start_26 .. :try_end_29} :catchall_32

    add-int/lit8 v9, v4, 0x1

    .line 1288
    :try_start_2b
    invoke-virtual {v8, p0}, Ljava/lang/reflect/Field;->getFloat(Ljava/lang/Object;)F

    move-result v8

    aput v8, v1, v4
    :try_end_31
    .catchall {:try_start_2b .. :try_end_31} :catchall_31

    :catchall_31
    move v4, v9

    :catchall_32
    :goto_32
    add-int/lit8 v7, v7, 0x1

    goto :goto_15

    .line 1282
    :cond_35
    invoke-virtual {v2}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v2

    goto :goto_9

    :cond_3a
    :goto_3a
    if-ne v4, v0, :cond_3d

    goto :goto_3e

    :cond_3d
    const/4 v1, 0x0

    :goto_3e
    return-object v1
.end method

.method private static hookDrawLike(Ljava/lang/Class;)I
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)I"
        }
    .end annotation

    .line 549
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    :goto_8
    if-ge v2, v0, :cond_45

    aget-object v4, p0, v2

    .line 550
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    sget-object v6, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-eq v5, v6, :cond_15

    goto :goto_42

    .line 551
    :cond_15
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v5

    const/4 v6, 0x1

    if-eq v5, v6, :cond_1d

    goto :goto_42

    .line 552
    :cond_1d
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    aget-object v5, v5, v1

    .line 553
    invoke-virtual {v5}, Ljava/lang/Class;->isPrimitive()Z

    move-result v7

    if-nez v7, :cond_42

    const-class v7, Ljava/lang/String;

    if-eq v5, v7, :cond_42

    invoke-virtual {v5}, Ljava/lang/Class;->isArray()Z

    move-result v5

    if-eqz v5, :cond_34

    goto :goto_42

    .line 555
    :cond_34
    :try_start_34
    invoke-virtual {v4, v6}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_37
    .catchall {:try_start_34 .. :try_end_37} :catchall_37

    .line 558
    :catchall_37
    new-instance v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$GlassDrawHook;

    const/4 v6, 0x0

    invoke-direct {v5, v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$GlassDrawHook;-><init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V

    invoke-static {v4, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v3, v3, 0x1

    :cond_42
    :goto_42
    add-int/lit8 v2, v2, 0x1

    goto :goto_8

    :cond_45
    return v3
.end method

.method private static hookIfElement(Ljava/lang/Class;)V
    .registers 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)V"
        }
    .end annotation

    .line 413
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sElements:Ljava/util/List;

    monitor-enter v0

    .line 414
    :try_start_3
    invoke-interface {v0, p0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_c

    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 415
    :cond_c
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    invoke-interface {v1, p0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_16

    monitor-exit v0

    return-void

    .line 416
    :cond_16
    monitor-exit v0
    :try_end_17
    .catchall {:try_start_3 .. :try_end_17} :catchall_e5

    const/4 v0, 0x0

    .line 420
    :try_start_18
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v1

    array-length v2, v1

    move v3, v0

    :goto_1e
    const/4 v4, 0x1

    if-ge v3, v2, :cond_31

    aget-object v5, v1, v3
    :try_end_23
    .catchall {:try_start_18 .. :try_end_23} :catchall_94

    .line 422
    :try_start_23
    invoke-virtual {v5, v4}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V
    :try_end_26
    .catchall {:try_start_23 .. :try_end_26} :catchall_26

    .line 425
    :catchall_26
    :try_start_26
    new-instance v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$2;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$2;-><init>()V

    invoke-static {v5, v4}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v3, v3, 0x1

    goto :goto_1e

    .line 461
    :cond_31
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->hookDrawLike(Ljava/lang/Class;)I

    move-result v1
    :try_end_35
    .catchall {:try_start_26 .. :try_end_35} :catchall_94

    .line 466
    :try_start_35
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v3, v2

    :goto_3a
    if-ge v0, v3, :cond_b5

    aget-object v5, v2, v0

    .line 467
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-eqz v6, :cond_45

    goto :goto_8c

    .line 468
    :cond_45
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    .line 469
    invoke-virtual {v6}, Ljava/lang/Class;->isPrimitive()Z

    move-result v7

    if-nez v7, :cond_8c

    sget-object v7, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-ne v6, v7, :cond_54

    goto :goto_8c

    .line 470
    :cond_54
    const-class v7, Ljava/lang/String;

    if-eq v6, v7, :cond_8c

    invoke-virtual {v6}, Ljava/lang/Class;->isArray()Z

    move-result v7

    if-nez v7, :cond_8c

    invoke-virtual {v6}, Ljava/lang/Class;->isInterface()Z

    move-result v7

    if-eqz v7, :cond_65

    goto :goto_8c

    .line 471
    :cond_65
    invoke-virtual {v6}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v7

    const-string v8, "java."

    invoke-virtual {v7, v8}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_8c

    invoke-virtual {v6}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "android."

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6
    :try_end_7b
    .catchall {:try_start_35 .. :try_end_7b} :catchall_8f

    if-eqz v6, :cond_7e

    goto :goto_8c

    .line 473
    :cond_7e
    :try_start_7e
    invoke-virtual {v5, v4}, Ljava/lang/reflect/Method;->setAccessible(Z)V
    :try_end_81
    .catchall {:try_start_7e .. :try_end_81} :catchall_81

    .line 476
    :catchall_81
    :try_start_81
    new-instance v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NodeFactoryHook;

    const/4 v7, 0x0

    invoke-direct {v6, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$NodeFactoryHook;-><init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;)V

    invoke-static {v5, v6}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_8a
    .catchall {:try_start_81 .. :try_end_8a} :catchall_8f

    add-int/lit8 v1, v1, 0x1

    :cond_8c
    :goto_8c
    add-int/lit8 v0, v0, 0x1

    goto :goto_3a

    :catchall_8f
    move-exception v0

    move v9, v1

    move-object v1, v0

    move v0, v9

    goto :goto_95

    :catchall_94
    move-exception v1

    .line 480
    :goto_95
    const-string v2, "glass.hook.err"

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u3010GmGlass\u3011\u94a9 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \u5931\u8d25\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    move v1, v0

    :cond_b5
    if-lez v1, :cond_e4

    .line 483
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    monitor-enter v0

    .line 484
    :try_start_ba
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 485
    monitor-exit v0
    :try_end_be
    .catchall {:try_start_ba .. :try_end_be} :catchall_e1

    .line 486
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "\u3010GmGlass\u3011\u2705 "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u2192 \u6302\u4e0a "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u4e2a\u7ed8\u5236\u65b9\u6cd5"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_e4

    :catchall_e1
    move-exception p0

    .line 485
    :try_start_e2
    monitor-exit v0
    :try_end_e3
    .catchall {:try_start_e2 .. :try_end_e3} :catchall_e1

    throw p0

    :cond_e4
    :goto_e4
    return-void

    :catchall_e5
    move-exception p0

    .line 416
    :try_start_e6
    monitor-exit v0
    :try_end_e7
    .catchall {:try_start_e6 .. :try_end_e7} :catchall_e5

    throw p0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 12

    .line 175
    :try_start_0
    const-string v0, "p68"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 177
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    :goto_e
    const/4 v5, 0x2

    const/4 v6, 0x1

    if-ge v3, v1, :cond_51

    aget-object v7, v0, v3

    .line 178
    const-string v8, "C"

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_21

    goto :goto_4e

    .line 179
    :cond_21
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 180
    array-length v9, v8

    const/4 v10, 0x3

    if-eq v9, v10, :cond_2a

    goto :goto_4e

    .line 181
    :cond_2a
    aget-object v6, v8, v6

    sget-object v9, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-eq v6, v9, :cond_31

    goto :goto_4e

    .line 182
    :cond_31
    aget-object v6, v8, v2

    invoke-virtual {v6}, Ljava/lang/Class;->isInterface()Z

    move-result v6

    if-nez v6, :cond_3a

    goto :goto_4e

    .line 183
    :cond_3a
    sget-object v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    if-nez v6, :cond_42

    aget-object v5, v8, v5

    sput-object v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    .line 184
    :cond_42
    new-instance v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;

    aget-object v6, v8, v2

    invoke-direct {v5, v6}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$PrimitiveHook;-><init>(Ljava/lang/Class;)V

    invoke-static {v7, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v4, v4, 0x1

    :goto_4e
    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    .line 192
    :cond_51
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    if-eqz v0, :cond_95

    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBrushCls:Ljava/lang/Class;

    if-nez v0, :cond_95

    .line 193
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v0, p0

    move v1, v2

    :goto_5f
    if-ge v1, v0, :cond_95

    aget-object v3, p0, v1

    .line 194
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v3

    .line 195
    array-length v7, v3

    const/4 v8, 0x4

    if-eq v7, v8, :cond_6c

    goto :goto_92

    .line 196
    :cond_6c
    aget-object v7, v3, v2

    invoke-virtual {v7}, Ljava/lang/Class;->isInterface()Z

    move-result v7

    if-nez v7, :cond_75

    goto :goto_92

    .line 197
    :cond_75
    aget-object v7, v3, v5

    sget-object v8, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sShapeCls:Ljava/lang/Class;

    if-eq v7, v8, :cond_7c

    goto :goto_92

    .line 198
    :cond_7c
    aget-object v7, v3, v6

    invoke-virtual {v7}, Ljava/lang/Class;->isPrimitive()Z

    move-result v7

    if-nez v7, :cond_92

    aget-object v7, v3, v6

    invoke-virtual {v7}, Ljava/lang/Class;->isArray()Z

    move-result v7

    if-eqz v7, :cond_8d

    goto :goto_92

    .line 199
    :cond_8d
    aget-object p0, v3, v6

    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBrushCls:Ljava/lang/Class;

    goto :goto_95

    :cond_92
    :goto_92
    add-int/lit8 v1, v1, 0x1

    goto :goto_5f

    :cond_95
    :goto_95
    if-nez v4, :cond_9e

    .line 204
    const-string p0, "\u3010GmGlass\u3011\u6ca1\u627e\u5230\u753b\u5e95\u539f\u8bed p68->C"

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void

    .line 207
    :cond_9e
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u3010GmGlass\u3011\u753b\u5e95\u539f\u8bed\u5df2\u6302\uff08p68->C \u00d7 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b7
    .catchall {:try_start_0 .. :try_end_b7} :catchall_b8

    return-void

    :catchall_b8
    move-exception p0

    .line 209
    const-string v0, "\u3010GmGlass\u3011\u753b\u5e95\u539f\u8bed\u6302\u8f7d\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 4

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 1672
    :try_start_2
    invoke-virtual {p0, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1673
    invoke-virtual {p0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_9
    .catchall {:try_start_2 .. :try_end_9} :catchall_a

    return-object p0

    :catchall_a
    return-object v1
.end method

.method private static lastElement(Ljava/lang/Class;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 285
    invoke-virtual {p0}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_7
    if-ge v3, v1, :cond_5a

    aget-object v4, v0, v3

    .line 286
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    .line 287
    array-length v6, v5

    const/4 v7, 0x2

    if-eq v6, v7, :cond_14

    goto :goto_57

    .line 288
    :cond_14
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    sget-object v8, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-ne v6, v8, :cond_1d

    goto :goto_57

    :cond_1d
    move v6, v2

    :goto_1e
    if-ge v6, v7, :cond_30

    .line 291
    aget-object v8, v5, v6

    invoke-virtual {v8}, Ljava/lang/Class;->isInterface()Z

    move-result v8

    if-eqz v8, :cond_2d

    aget-object v8, v5, v6

    if-eq v8, p0, :cond_2d

    goto :goto_31

    :cond_2d
    add-int/lit8 v6, v6, 0x1

    goto :goto_1e

    :cond_30
    const/4 v6, -0x1

    :goto_31
    if-gez v6, :cond_34

    goto :goto_57

    :cond_34
    const/4 v8, 0x1

    .line 298
    :try_start_35
    invoke-virtual {v4, v8}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 299
    new-array v9, v8, [Ljava/lang/Object;

    .line 300
    invoke-virtual {p0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v10

    new-array v8, v8, [Ljava/lang/Class;

    aget-object v5, v5, v6

    aput-object v5, v8, v2

    new-instance v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;

    invoke-direct {v5, v9}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$1;-><init>([Ljava/lang/Object;)V

    invoke-static {v10, v8, v5}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v5

    .line 314
    new-array v7, v7, [Ljava/lang/Object;

    .line 315
    aput-object v5, v7, v6

    .line 316
    invoke-virtual {v4, p1, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 317
    aget-object p0, v9, v2
    :try_end_56
    .catchall {:try_start_35 .. :try_end_56} :catchall_57

    return-object p0

    :catchall_57
    :goto_57
    add-int/lit8 v3, v3, 0x1

    goto :goto_7

    :cond_5a
    const/4 p0, 0x0

    return-object p0
.end method

.method private static layoutDirOf(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/Object;"
        }
    .end annotation

    const/4 v0, 0x0

    const/4 v1, 0x0

    .line 1145
    :try_start_2
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v3, v2

    move v4, v1

    :goto_c
    if-ge v4, v3, :cond_2c

    aget-object v5, v2, v4

    .line 1146
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-eqz v6, :cond_17

    goto :goto_29

    .line 1147
    :cond_17
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    if-eq v6, p1, :cond_1e

    goto :goto_29

    :cond_1e
    const/4 v6, 0x1

    .line 1148
    invoke-virtual {v5, v6}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1149
    invoke-virtual {v5, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5
    :try_end_26
    .catchall {:try_start_2 .. :try_end_26} :catchall_2c

    if-eqz v5, :cond_29

    return-object v5

    :cond_29
    :goto_29
    add-int/lit8 v4, v4, 0x1

    goto :goto_c

    .line 1155
    :catchall_2c
    :cond_2c
    :try_start_2c
    invoke-virtual {p1}, Ljava/lang/Class;->isEnum()Z

    move-result p0

    if-eqz p0, :cond_3e

    .line 1156
    invoke-virtual {p1}, Ljava/lang/Class;->getEnumConstants()[Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_3e

    .line 1157
    array-length p1, p0

    if-lez p1, :cond_3e

    aget-object p0, p0, v1
    :try_end_3d
    .catchall {:try_start_2c .. :try_end_3d} :catchall_3e

    return-object p0

    :catchall_3e
    :cond_3e
    return-object v0
.end method

.method private static logSizeOnce(FF)V
    .registers 6

    const-string v0, "\u3010GmGlass\u3011\u4e0a\u73bb\u7483\u7684\u5c3a\u5bf8#"

    .line 589
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sSizes:Ljava/util/LinkedHashSet;

    monitor-enter v1

    .line 590
    :try_start_5
    invoke-virtual {v1}, Ljava/util/LinkedHashSet;->size()I

    move-result v2

    const/16 v3, 0xc

    if-lt v2, v3, :cond_f

    monitor-exit v1

    return-void

    .line 591
    :cond_f
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 592
    invoke-virtual {v1, p1}, Ljava/util/LinkedHashSet;->add(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_6d

    .line 593
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/util/LinkedHashSet;->size()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\uff1a"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\uff08"

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/high16 p1, 0x44af0000    # 1400.0f

    cmpl-float p1, p0, p1

    if-ltz p1, :cond_53

    .line 594
    const-string p0, "\u6574\u5e45\u5bbd\u6a2a\u6761"

    goto :goto_5e

    :cond_53
    const/high16 p1, 0x44160000    # 600.0f

    cmpl-float p0, p0, p1

    if-ltz p0, :cond_5c

    const-string p0, "\u5bbd\u5757"

    goto :goto_5e

    :cond_5c
    const-string p0, "\u5c0f\u63a7\u4ef6"

    :goto_5e
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff09"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 593
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 597
    :cond_6d
    monitor-exit v1

    return-void

    :catchall_6f
    move-exception p0

    monitor-exit v1
    :try_end_71
    .catchall {:try_start_5 .. :try_end_71} :catchall_6f

    throw p0
.end method

.method private static looksLikeDrawScope(Ljava/lang/Object;)Z
    .registers 10

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 568
    :cond_4
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v1, p0

    move v2, v0

    move v3, v2

    move v4, v3

    :goto_10
    if-ge v2, v1, :cond_37

    aget-object v5, p0, v2

    .line 569
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-eqz v6, :cond_1b

    goto :goto_34

    .line 570
    :cond_1b
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    const/4 v8, 0x1

    if-ne v6, v7, :cond_26

    move v3, v8

    goto :goto_2f

    .line 571
    :cond_26
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    sget-object v6, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    if-ne v5, v6, :cond_2f

    move v4, v8

    :cond_2f
    :goto_2f
    if-eqz v3, :cond_34

    if-eqz v4, :cond_34

    return v8

    :cond_34
    :goto_34
    add-int/lit8 v2, v2, 0x1

    goto :goto_10

    :cond_37
    return v0
.end method

.method private static nativeOf(Ljava/lang/Object;)Landroid/graphics/Canvas;
    .registers 9

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    :cond_4
    const/4 v1, 0x0

    .line 1442
    :try_start_5
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v3, v2

    move v4, v1

    :goto_f
    if-ge v4, v3, :cond_31

    aget-object v5, v2, v4

    .line 1443
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v6

    if-eqz v6, :cond_1a

    goto :goto_2e

    .line 1444
    :cond_1a
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    const-class v7, Landroid/graphics/Canvas;

    if-eq v6, v7, :cond_23

    goto :goto_2e

    .line 1445
    :cond_23
    invoke-static {v5, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->invokeQuiet(Ljava/lang/reflect/Method;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 1446
    instance-of v6, v5, Landroid/graphics/Canvas;

    if-eqz v6, :cond_2e

    check-cast v5, Landroid/graphics/Canvas;
    :try_end_2d
    .catchall {:try_start_5 .. :try_end_2d} :catchall_31

    return-object v5

    :cond_2e
    :goto_2e
    add-int/lit8 v4, v4, 0x1

    goto :goto_f

    .line 1451
    :catchall_31
    :cond_31
    :try_start_31
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    :goto_3a
    if-ge v1, v3, :cond_59

    aget-object v4, v2, v1

    .line 1452
    invoke-virtual {v4}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v5

    const-class v6, Landroid/graphics/Canvas;

    if-eq v5, v6, :cond_47

    goto :goto_56

    :cond_47
    const/4 v5, 0x1

    .line 1453
    invoke-virtual {v4, v5}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1454
    invoke-virtual {v4, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 1455
    instance-of v5, v4, Landroid/graphics/Canvas;

    if-eqz v5, :cond_56

    check-cast v4, Landroid/graphics/Canvas;
    :try_end_55
    .catchall {:try_start_31 .. :try_end_55} :catchall_59

    return-object v4

    :cond_56
    :goto_56
    add-int/lit8 v1, v1, 0x1

    goto :goto_3a

    :catchall_59
    :cond_59
    return-object v0
.end method

.method private static nodeBrushOf(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 9

    .line 1300
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBrushCls:Ljava/lang/Class;

    const/4 v1, 0x0

    if-eqz v0, :cond_38

    if-nez p0, :cond_8

    goto :goto_38

    .line 1302
    :cond_8
    :try_start_8
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    :goto_c
    if-eqz v0, :cond_38

    const-class v2, Ljava/lang/Object;

    if-eq v0, v2, :cond_38

    .line 1303
    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    :goto_18
    if-ge v4, v3, :cond_33

    aget-object v5, v2, v4

    .line 1304
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBrushCls:Ljava/lang/Class;

    if-eq v6, v7, :cond_25

    goto :goto_30

    :cond_25
    const/4 v6, 0x1

    .line 1305
    invoke-virtual {v5, v6}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 1306
    invoke-virtual {v5, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    if-eqz v5, :cond_30

    return-object v5

    :cond_30
    :goto_30
    add-int/lit8 v4, v4, 0x1

    goto :goto_18

    .line 1302
    :cond_33
    invoke-virtual {v0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v0
    :try_end_37
    .catchall {:try_start_8 .. :try_end_37} :catchall_38

    goto :goto_c

    :catchall_38
    :cond_38
    :goto_38
    return-object v1
.end method

.method public static paintCount()I
    .registers 1

    .line 157
    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I

    return v0
.end method

.method private static paintGlass(Ljava/lang/Object;Ljava/lang/Object;)Z
    .registers 24

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 680
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->capturing()Z

    move-result v2

    const/4 v3, 0x0

    if-eqz v2, :cond_c

    return v3

    .line 682
    :cond_c
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->dim(Ljava/lang/Object;I)F

    move-result v6

    const/4 v2, 0x1

    .line 683
    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->dim(Ljava/lang/Object;I)F

    move-result v7

    const/high16 v4, 0x3f800000    # 1.0f

    cmpg-float v5, v6, v4

    if-lez v5, :cond_378

    cmpg-float v5, v7, v4

    if-gtz v5, :cond_21

    goto/16 :goto_378

    .line 690
    :cond_21
    invoke-static {v6, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->logSizeOnce(FF)V

    .line 692
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object v5

    .line 695
    iget v8, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->scope:I

    if-ne v8, v2, :cond_33

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->inButton()Z

    move-result v8

    if-nez v8, :cond_33

    return v3

    .line 699
    :cond_33
    invoke-static {v6, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->isFullPage(FF)Z

    move-result v8

    const-string v9, "x"

    if-eqz v8, :cond_57

    .line 700
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6574\u9875\u6839\u8282\u70b9\uff08\u6d82\u5b83\u4f1a\u8ba9\u5168\u5c4f\u504f\u767d\uff09"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    float-to-int v1, v6

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v1, v7

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "rootpage"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v3

    .line 704
    :cond_57
    iget v8, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->radiusDp:I

    int-to-float v8, v8

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->density()F

    move-result v10

    mul-float/2addr v8, v10

    .line 705
    invoke-static {v6, v7}, Ljava/lang/Math;->min(FF)F

    move-result v10

    const/high16 v11, 0x40000000    # 2.0f

    div-float/2addr v10, v11

    invoke-static {v8, v10}, Ljava/lang/Math;->min(FF)F

    move-result v8

    .line 710
    iget v10, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->form:I

    if-ne v10, v2, :cond_72

    .line 711
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->drawContentOf(Ljava/lang/Object;)V

    return v2

    .line 722
    :cond_72
    iget v10, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->form:I

    const/4 v11, 0x2

    if-ne v10, v11, :cond_79

    move v10, v2

    goto :goto_7a

    :cond_79
    move v10, v3

    :goto_7a
    if-eqz v10, :cond_9b

    .line 725
    iget v13, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->edge:I

    int-to-float v13, v13

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->density()F

    move-result v14

    mul-float/2addr v13, v14

    invoke-static {v4, v13}, Ljava/lang/Math;->max(FF)F

    move-result v13

    .line 726
    invoke-static {v6, v7}, Ljava/lang/Math;->min(FF)F

    move-result v14

    const v15, 0x3eae147b    # 0.34f

    mul-float/2addr v14, v15

    cmpg-float v15, v14, v4

    if-gez v15, :cond_95

    move v14, v4

    :cond_95
    cmpl-float v15, v13, v14

    if-lez v15, :cond_9c

    move v13, v14

    goto :goto_9c

    :cond_9b
    const/4 v13, 0x0

    .line 730
    :cond_9c
    :goto_9c
    iget-boolean v14, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fit:Z

    move/from16 v16, v3

    const-string v3, ","

    if-nez v14, :cond_ae

    if-eqz v10, :cond_a7

    goto :goto_ae

    :cond_a7
    move/from16 v18, v2

    move/from16 v19, v11

    const/4 v11, 0x0

    goto/16 :goto_1d6

    .line 731
    :cond_ae
    :goto_ae
    sget-object v14, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeShape:Ljava/util/Map;

    invoke-interface {v14, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    .line 732
    sget-object v15, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeFit:Ljava/util/Map;

    invoke-interface {v15, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v18

    check-cast v18, [Ljava/lang/Object;

    if-eqz v18, :cond_eb

    .line 733
    aget-object v19, v18, v16

    check-cast v19, Ljava/lang/Float;

    .line 734
    invoke-virtual/range {v19 .. v19}, Ljava/lang/Float;->floatValue()F

    move-result v19

    cmpl-float v19, v19, v6

    if-nez v19, :cond_eb

    aget-object v19, v18, v2

    check-cast v19, Ljava/lang/Float;

    invoke-virtual/range {v19 .. v19}, Ljava/lang/Float;->floatValue()F

    move-result v19

    cmpl-float v19, v19, v7

    if-nez v19, :cond_eb

    aget-object v19, v18, v11

    if-nez v19, :cond_e1

    move/from16 v19, v11

    iget-boolean v11, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fit:Z

    if-nez v11, :cond_ed

    goto :goto_e3

    :cond_e1
    move/from16 v19, v11

    .line 737
    :goto_e3
    aget-object v11, v18, v19

    check-cast v11, Landroid/graphics/Path;

    move/from16 v18, v2

    goto/16 :goto_1d6

    :cond_eb
    move/from16 v19, v11

    .line 739
    :cond_ed
    iget-boolean v11, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fit:Z

    if-nez v11, :cond_f3

    if-eqz v10, :cond_fa

    :cond_f3
    if-eqz v14, :cond_fa

    invoke-static {v14, v0, v6, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->fitPathFrom(Ljava/lang/Object;Ljava/lang/Object;FF)Landroid/graphics/Path;

    move-result-object v11

    goto :goto_fb

    :cond_fa
    const/4 v11, 0x0

    :goto_fb
    if-eqz v11, :cond_1c5

    .line 743
    new-instance v14, Landroid/graphics/RectF;

    invoke-direct {v14}, Landroid/graphics/RectF;-><init>()V

    .line 744
    invoke-virtual {v11, v14, v2}, Landroid/graphics/Path;->computeBounds(Landroid/graphics/RectF;Z)V

    .line 745
    invoke-virtual {v14}, Landroid/graphics/RectF;->width()F

    move-result v18

    const v20, 0x3f0ccccd    # 0.55f

    mul-float v21, v6, v20

    cmpg-float v18, v18, v21

    if-ltz v18, :cond_189

    invoke-virtual {v14}, Landroid/graphics/RectF;->height()F

    move-result v18

    mul-float v20, v20, v7

    cmpg-float v18, v18, v20

    if-gez v18, :cond_11d

    goto :goto_189

    :cond_11d
    move/from16 v18, v2

    .line 749
    iget v2, v14, Landroid/graphics/RectF;->left:F

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    const/high16 v20, 0x3f000000    # 0.5f

    cmpl-float v2, v2, v20

    if-gtz v2, :cond_135

    iget v2, v14, Landroid/graphics/RectF;->top:F

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    cmpl-float v2, v2, v20

    if-lez v2, :cond_1c7

    .line 757
    :cond_135
    iget v2, v14, Landroid/graphics/RectF;->left:F

    neg-float v2, v2

    iget v12, v14, Landroid/graphics/RectF;->top:F

    neg-float v12, v12

    invoke-virtual {v11, v2, v12}, Landroid/graphics/Path;->offset(FF)V

    .line 758
    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitOriginLogged:Z

    if-nez v2, :cond_1c7

    .line 759
    sput-boolean v18, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sFitOriginLogged:Z

    .line 760
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v12, "\u3010GmGlass\u3011\u8f6e\u5ed3\u539f\u70b9 \u2260 (0,0) \u21d2 \u5df2\u5e73\u79fb\u56de\u539f\u70b9\uff08\u5143\u7d20 "

    invoke-direct {v2, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    float-to-int v12, v6

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v12, v7

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " \u00b7 \u539f bounds=("

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v14, Landroid/graphics/RectF;->left:F

    float-to-int v12, v12

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v14, Landroid/graphics/RectF;->top:F

    float-to-int v12, v12

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v14, Landroid/graphics/RectF;->right:F

    float-to-int v12, v12

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v14, Landroid/graphics/RectF;->bottom:F

    float-to-int v12, v12

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, ") \u00b7 \u8fd9\u662f\u300c\u73bb\u7483\u53ea\u5728\u5de6\u4e0a\u89d2\u300d\u7684\u6839\u56e0\uff09"

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_1c7

    :cond_189
    :goto_189
    move/from16 v18, v2

    .line 746
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v11, "\u8f6e\u5ed3\u8def\u5f84\u5f02\u5e38("

    invoke-direct {v2, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v14}, Landroid/graphics/RectF;->width()F

    move-result v11

    float-to-int v11, v11

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Landroid/graphics/RectF;->height()F

    move-result v11

    float-to-int v11, v11

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " vs \u5143\u7d20 "

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v11, v6

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v11, v7

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, ") \u21d2 \u5f53\u62ff\u4e0d\u5230\u5904\u7406"

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v11, "fit.bad"

    invoke-static {v11, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v11, 0x0

    goto :goto_1c7

    :cond_1c5
    move/from16 v18, v2

    .line 768
    :cond_1c7
    :goto_1c7
    invoke-static {v6}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    invoke-static {v7}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v12

    filled-new-array {v2, v12, v11}, [Ljava/lang/Object;

    move-result-object v2

    invoke-interface {v15, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1d6
    if-eqz v10, :cond_1e2

    if-nez v11, :cond_1e2

    .line 777
    const-string v0, "edge.nofit"

    const-string v1, "\u4ec5\u8fb9\u7f18\uff1a\u62ff\u4e0d\u5230\u5143\u7d20\u8f6e\u5ed3 \u21d2 \u4e0d\u753b\uff08\u907f\u514d\u8dd1\u5230\u5143\u7d20\u5916\u9762\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16

    :cond_1e2
    if-eqz v10, :cond_1e6

    move v14, v4

    goto :goto_1f6

    .line 784
    :cond_1e6
    iget v2, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fade:I

    int-to-float v2, v2

    const/high16 v12, 0x42c80000    # 100.0f

    div-float/2addr v2, v12

    invoke-static {v4, v2}, Ljava/lang/Math;->min(FF)F

    move-result v2

    const/4 v12, 0x0

    invoke-static {v12, v2}, Ljava/lang/Math;->max(FF)F

    move-result v2

    move v14, v2

    :goto_1f6
    if-eqz v10, :cond_1fd

    .line 785
    invoke-static {v4, v13}, Ljava/lang/Math;->max(FF)F

    move-result v2

    goto :goto_209

    :cond_1fd
    invoke-static {v6, v7}, Ljava/lang/Math;->min(FF)F

    move-result v2

    const v10, 0x3ee66666    # 0.45f

    mul-float/2addr v2, v10

    invoke-static {v4, v2}, Ljava/lang/Math;->max(FF)F

    move-result v2

    :goto_209
    move v15, v2

    .line 788
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->catchCanvas(Ljava/lang/Class;)V

    .line 789
    sget-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sCurCanvas:Ljava/lang/ThreadLocal;

    invoke-virtual {v2}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Canvas;

    if-nez v2, :cond_21f

    .line 790
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->canvasOf(Ljava/lang/Object;)Landroid/graphics/Canvas;

    move-result-object v2

    :cond_21f
    if-nez v2, :cond_222

    return v16

    .line 804
    :cond_222
    iget v4, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->src:I

    if-nez v4, :cond_229

    move/from16 v4, v18

    goto :goto_22b

    :cond_229
    move/from16 v4, v16

    .line 805
    :goto_22b
    iget v10, v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->src:I

    move/from16 v12, v19

    if-ne v10, v12, :cond_234

    move/from16 v10, v18

    goto :goto_236

    :cond_234
    move/from16 v10, v16

    :goto_236
    if-eqz v10, :cond_283

    .line 816
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v4

    if-nez v4, :cond_241

    const/16 v17, 0x0

    goto :goto_24f

    .line 818
    :cond_241
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->winW()I

    move-result v10

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->winH()I

    move-result v12

    invoke-static {v4, v10, v12}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->get(Landroid/content/Context;II)Landroid/graphics/Bitmap;

    move-result-object v4

    move-object/from16 v17, v4

    :goto_24f
    if-eqz v17, :cond_25b

    .line 819
    invoke-virtual/range {v17 .. v17}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v4

    if-nez v4, :cond_25b

    move/from16 v4, v16

    goto/16 :goto_2d9

    .line 823
    :cond_25b
    sget-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeColor:Ljava/util/Map;

    invoke-interface {v4, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    if-nez v1, :cond_26d

    .line 825
    const-string v0, "wallback"

    const-string v1, "\u80cc\u666f\u56fe\u4e0d\u53ef\u7528\u4e14\u62ff\u4e0d\u5230\u5143\u7d20\u5e95\u8272 \u21d2 \u8fd9\u4e00\u5e27\u4e0d\u753b"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16

    .line 828
    :cond_26d
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->make(I)Landroid/graphics/Bitmap;

    move-result-object v17

    .line 830
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sWallBackLogged:Z

    if-nez v1, :cond_280

    .line 831
    sput-boolean v18, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sWallBackLogged:Z

    .line 832
    const-string v1, "\u3010GmGlass\u3011\u80cc\u666f\u56fe\u4e0d\u53ef\u7528 \u21d2 \u5df2\u56de\u9000\u300c\u5143\u7d20\u5e95\u8272\u300d\uff08\u73bb\u7483\u7167\u5e38\u663e\u793a\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_280
    move/from16 v4, v18

    goto :goto_2d9

    :cond_283
    if-eqz v4, :cond_2d0

    .line 836
    sget-object v10, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sNodeColor:Ljava/util/Map;

    invoke-interface {v10, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    if-nez v1, :cond_297

    .line 848
    const-string v0, "nocolor"

    const-string v1, "\u5e95\u8272\u6a21\u5f0f\u4f46\u8fd8\u6ca1\u62ff\u5230\u5143\u7d20\u989c\u8272 \u21d2 \u8fd9\u4e00\u5e27\u4e0d\u753b\uff08\u907f\u514d\u524d\u540e\u4e0d\u4e00\u81f4\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16

    .line 851
    :cond_297
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v12

    invoke-static {v12}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSolid;->make(I)Landroid/graphics/Bitmap;

    move-result-object v17

    .line 852
    sget-boolean v12, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sColorLogged:Z

    if-nez v12, :cond_2d9

    .line 853
    sput-boolean v18, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sColorLogged:Z

    .line 854
    new-instance v12, Ljava/lang/StringBuilder;

    const-string v13, "\u3010GmGlass\u3011\u5e95\u8272\u63a5\u529b \u2713 \u62ff\u5230 #"

    invoke-direct {v12, v13}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08"

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 855
    invoke-interface {v10}, Ljava/util/Map;->size()I

    move-result v1

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a\u5143\u7d20\u6709\u5e95\u8272\uff09"

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 854
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_2d9

    .line 859
    :cond_2d0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->get()Landroid/graphics/Bitmap;

    move-result-object v17

    if-nez v17, :cond_2d9

    .line 860
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->request()V

    :cond_2d9
    :goto_2d9
    move v12, v4

    if-nez v12, :cond_366

    .line 865
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->originFromCanvas(Ljava/lang/Object;)[I

    move-result-object v1

    if-nez v1, :cond_2ea

    .line 867
    const-string v0, "noorigin"

    const-string v1, "\u62ff\u4e0d\u5230\u5143\u7d20\u4f4d\u7f6e \u21d2 \u8df3\u8fc7\uff08\u4e0d\u6d82\u9519\u5730\u65b9\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16

    :cond_2ea
    if-nez v17, :cond_2ef

    move/from16 v4, v16

    goto :goto_2f5

    .line 870
    :cond_2ef
    invoke-virtual/range {v17 .. v17}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    mul-int/lit8 v4, v4, 0x4

    :goto_2f5
    if-nez v17, :cond_2fa

    move/from16 v10, v16

    goto :goto_300

    .line 871
    :cond_2fa
    invoke-virtual/range {v17 .. v17}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v10

    mul-int/lit8 v10, v10, 0x4

    :goto_300
    if-eqz v17, :cond_35d

    .line 872
    aget v13, v1, v16

    if-ltz v13, :cond_31f

    aget v0, v1, v18

    if-ltz v0, :cond_31f

    int-to-float v13, v13

    add-float/2addr v13, v6

    move-object/from16 p1, v1

    add-int/lit8 v1, v4, 0x1

    int-to-float v1, v1

    cmpl-float v1, v13, v1

    if-gtz v1, :cond_321

    int-to-float v0, v0

    add-float/2addr v0, v7

    add-int/lit8 v1, v10, 0x1

    int-to-float v1, v1

    cmpl-float v0, v0, v1

    if-lez v0, :cond_35f

    goto :goto_321

    :cond_31f
    move-object/from16 p1, v1

    .line 874
    :cond_321
    :goto_321
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u91c7\u6837\u533a\u8d8a\u754c \u21d2 \u8df3\u8fc7 org=("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget v1, p1, v16

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, p1, v18

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ") "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v1, v6

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v1, v7

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u7a97\u53e3="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "outofrange"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16

    :cond_35d
    move-object/from16 p1, v1

    .line 878
    :cond_35f
    aget v3, p1, v16

    .line 879
    aget v0, p1, v18

    move v10, v0

    move v9, v3

    goto :goto_369

    :cond_366
    move/from16 v9, v16

    move v10, v9

    .line 883
    :goto_369
    new-instance v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;

    move-object v13, v11

    move-object/from16 v11, v17

    invoke-direct/range {v4 .. v15}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;-><init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;FFFIILandroid/graphics/Bitmap;ZLandroid/graphics/Path;FF)V

    invoke-virtual {v4, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink$Painter;->paint(Landroid/graphics/Canvas;)V

    .line 890
    invoke-static/range {p0 .. p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->drawContentOf(Ljava/lang/Object;)V

    return v18

    :cond_378
    :goto_378
    move/from16 v16, v3

    .line 685
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u53d6\u4e0d\u5230\u5c3a\u5bf8 w="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, " h="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, " \u00b7 scopeCls="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 686
    invoke-virtual/range {p0 .. p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 685
    const-string v1, "size"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->why(Ljava/lang/String;Ljava/lang/String;)V

    return v16
.end method

.method private static recipeFor(Ljava/lang/Class;)[Ljava/lang/Object;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)[",
            "Ljava/lang/Object;"
        }
    .end annotation

    :goto_0
    if-eqz p0, :cond_43

    .line 1256
    const-class v0, Ljava/lang/Object;

    if-eq p0, v0, :cond_43

    .line 1257
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_c
    if-ge v2, v1, :cond_3e

    aget-object v3, v0, v2

    .line 1258
    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v4

    invoke-static {v4}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v4

    if-eqz v4, :cond_1b

    goto :goto_3b

    .line 1259
    :cond_1b
    invoke-virtual {v3}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v4

    .line 1260
    invoke-virtual {v4}, Ljava/lang/Class;->isPrimitive()Z

    move-result v5

    if-nez v5, :cond_3b

    invoke-virtual {v4}, Ljava/lang/Class;->isArray()Z

    move-result v5

    if-nez v5, :cond_3b

    const-class v5, Ljava/lang/String;

    if-ne v4, v5, :cond_30

    goto :goto_3b

    .line 1261
    :cond_30
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->androidPathFieldOf(Ljava/lang/Class;)Ljava/lang/reflect/Field;

    move-result-object v4

    if-eqz v4, :cond_3b

    .line 1262
    filled-new-array {v3, v4}, [Ljava/lang/Object;

    move-result-object p0

    return-object p0

    :cond_3b
    :goto_3b
    add-int/lit8 v2, v2, 0x1

    goto :goto_c

    .line 1256
    :cond_3e
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object p0

    goto :goto_0

    :cond_43
    const/4 p0, 0x0

    return-object p0
.end method

.method public static stats()Ljava/lang/String;
    .registers 4

    .line 163
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnElements:Ljava/util/Set;

    monitor-enter v0

    .line 164
    :try_start_3
    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v1

    .line 165
    monitor-exit v0
    :try_end_8
    .catchall {:try_start_3 .. :try_end_8} :catchall_42

    .line 166
    sget-object v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sBtnNodes:Ljava/util/Set;

    monitor-enter v2

    .line 167
    :try_start_b
    invoke-interface {v2}, Ljava/util/Set;->size()I

    move-result v0

    .line 168
    monitor-exit v2
    :try_end_10
    .catchall {:try_start_b .. :try_end_10} :catchall_3f

    .line 169
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u5df2\u94a9\u7c7b="

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sHooked:Ljava/util/Set;

    invoke-interface {v3}, Ljava/util/Set;->size()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " \u6309\u94ae\u5143\u7d20="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6309\u94aeNode="

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u7ed8\u5236\u6b21\u6570="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->sPaintCount:I

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :catchall_3f
    move-exception v0

    .line 168
    :try_start_40
    monitor-exit v2
    :try_end_41
    .catchall {:try_start_40 .. :try_end_41} :catchall_3f

    throw v0

    :catchall_42
    move-exception v1

    .line 165
    :try_start_43
    monitor-exit v0
    :try_end_44
    .catchall {:try_start_43 .. :try_end_44} :catchall_42

    throw v1
.end method

.method private static why(Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    .line 602
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "glass.why."

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u6ca1\u753b\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$DepthHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassScope.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "DepthHook"
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 139
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$1;)V
    .registers 2

    .line 139
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope$DepthHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 147
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->access$100()I

    move-result p0

    if-lez p0, :cond_9

    # operator-- for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->access$110()I

    :cond_9
    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 142
    # operator++ for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->sDepth:I
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->access$108()I

    return-void
.end method

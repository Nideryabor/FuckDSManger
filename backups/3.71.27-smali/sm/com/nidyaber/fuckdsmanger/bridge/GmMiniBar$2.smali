.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmMiniBar.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 83
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 87
    :try_start_0
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$200()V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_3

    :catchall_3
    return-void
.end method

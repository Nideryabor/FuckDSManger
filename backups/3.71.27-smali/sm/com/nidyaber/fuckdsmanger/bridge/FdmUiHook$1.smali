.class Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "FdmUiHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 80
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 84
    :try_start_0
    const-class p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;

    invoke-virtual {p0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object p0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->openCompose(Ljava/lang/ClassLoader;)Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->access$000(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_10

    const/4 p0, 0x0

    .line 86
    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_11

    :cond_10
    return-void

    :catchall_11
    move-exception p0

    .line 89
    const-string p1, "\u3010FdmUiHook\u3011\u6362\u4e58\u5931\u8d25\uff08\u653e\u884c\u65e7 UI\uff09"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

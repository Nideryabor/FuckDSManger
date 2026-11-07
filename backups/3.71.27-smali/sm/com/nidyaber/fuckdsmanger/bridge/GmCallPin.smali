.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;
.super Ljava/lang/Object;
.source "GmCallPin.java"


# static fields
.field private static final CLS_VM:Ljava/lang/String; = "ps1"

.field public static final KEY_ON:Ljava/lang/String; = "fuckds_call_pin"

.field private static final M_SHOW:Ljava/lang/String; = "a"

.field private static volatile sOpened:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Z
    .registers 1

    .line 46
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->sOpened:Z

    return v0
.end method

.method static synthetic access$002(Z)Z
    .registers 1

    .line 46
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->sOpened:Z

    return p0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 3

    .line 98
    :try_start_0
    const-string v0, "ps1"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 99
    const-string v0, "a"

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin$1;

    invoke-direct {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin$1;-><init>()V

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 126
    const-string p0, "[\u7559\u9a7b] \u5df2\u6302\u94a9\u5b50 ps1.aZ\uff08\u901a\u8bdd\u9875\u7559\u9a7b\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_1a

    return-void

    :catchall_1a
    move-exception p0

    .line 129
    const-string v0, "[\u7559\u9a7b] \u94a9\u5b50\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static on(Landroid/content/Context;)Z
    .registers 4

    .line 73
    :try_start_0
    const-string v0, "1"

    const-string v1, "fuckds_call_pin"

    const-string v2, "s"

    invoke-static {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return p0

    :catchall_f
    const/4 p0, 0x0

    return p0
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 4

    .line 81
    :try_start_0
    const-string v0, "fuckds_call_pin"

    if-eqz p1, :cond_7

    const-string p1, "1"

    goto :goto_9

    :cond_7
    const-string p1, "0"

    :goto_9
    const-string v1, "s"

    invoke-static {p0, v0, p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_f

    return-void

    :catchall_f
    move-exception p0

    .line 83
    const-string p1, "[\u7559\u9a7b] setOn \u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static state(Landroid/content/Context;)Ljava/lang/String;
    .registers 1

    .line 89
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->on(Landroid/content/Context;)Z

    move-result p0

    if-eqz p0, :cond_9

    const-string p0, "1"

    return-object p0

    :cond_9
    const-string p0, "0"

    return-object p0
.end method

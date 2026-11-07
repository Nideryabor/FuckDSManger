.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;
.super Ljava/lang/Object;
.source "FdmUiHook.java"


# static fields
.field private static final BASE_ENTRY:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.gm.GmEntry"

.field private static final OLD_UI:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.gm.GmHomeUi"

.field private static final UI_ACT:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.MainActivity"

.field private static final UI_URI:Ljava/lang/String; = "fdm://open"

.field private static volatile sInstalled:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 57
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/ClassLoader;)Z
    .registers 1

    .line 39
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->openCompose(Ljava/lang/ClassLoader;)Z

    move-result p0

    return p0
.end method

.method private static hostContext(Ljava/lang/ClassLoader;)Landroid/content/Context;
    .registers 4

    const/4 v0, 0x0

    .line 153
    :try_start_1
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmEntry"

    invoke-static {v1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 154
    const-string v1, "sAct"

    invoke-static {p0, v1}, Lde/robv/android/xposed/XposedHelpers;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    const/4 v1, 0x1

    .line 155
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 156
    invoke-virtual {p0, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 157
    instance-of v1, p0, Landroid/content/Context;

    if-eqz v1, :cond_2e

    check-cast p0, Landroid/content/Context;
    :try_end_1b
    .catchall {:try_start_1 .. :try_end_1b} :catchall_1c

    return-object p0

    :catchall_1c
    move-exception p0

    .line 159
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010FdmUiHook\u3011\u53d6 GmEntry.sAct \u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 162
    :cond_2e
    :try_start_2e
    const-string p0, "android.app.ActivityThread"

    .line 163
    invoke-static {p0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    const-string v1, "currentApplication"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    .line 162
    invoke-static {p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 164
    instance-of v1, p0, Landroid/content/Context;

    if-eqz v1, :cond_44

    check-cast p0, Landroid/content/Context;
    :try_end_43
    .catchall {:try_start_2e .. :try_end_43} :catchall_44

    return-object p0

    :catchall_44
    :cond_44
    return-object v0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 3

    .line 70
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->sInstalled:Z

    if-eqz v0, :cond_5

    goto :goto_3e

    .line 74
    :cond_5
    :try_start_5
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmHomeUi"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0
    :try_end_b
    .catchall {:try_start_5 .. :try_end_b} :catchall_3e

    .line 80
    :try_start_b
    const-string v0, "open"

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook$1;

    invoke-direct {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook$1;-><init>()V

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    const/4 p0, 0x1

    .line 93
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->sInstalled:Z

    .line 94
    const-string p0, "\u3010FdmUiHook\u3011\u5df2\u63a5\u7ba1\u300c\u68c0\u67e5\u66f4\u65b0\u300d\u2192 Compose UI \u2713"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 95
    const-string p0, "[FDM] \u5df2\u63a5\u7ba1\u300c\u68c0\u67e5\u66f4\u65b0\u300d\u2192 Compose UI \u2713"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_26
    .catchall {:try_start_b .. :try_end_26} :catchall_27

    return-void

    :catchall_27
    move-exception p0

    .line 97
    const-string v0, "\u3010FdmUiHook\u3011\u6302\u8f7d\u5931\u8d25\uff08\u4fdd\u7559\u65e7 View UI\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 98
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] FdmUiHook \u6302\u8f7d\u5931\u8d25\uff08\u4fdd\u7559\u65e7 View UI\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    :catchall_3e
    :goto_3e
    return-void
.end method

.method private static openCompose(Ljava/lang/ClassLoader;)Z
    .registers 7

    .line 108
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->hostContext(Ljava/lang/ClassLoader;)Landroid/content/Context;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_d

    .line 110
    const-string p0, "\u3010FdmUiHook\u3011\u62ff\u4e0d\u5230\u5bbf\u4e3b Context \u21d2 \u4e0d\u6362\u4e58\uff0c\u8d70\u65e7 UI"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v0

    .line 117
    :cond_d
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 118
    new-instance v3, Landroid/content/ComponentName;

    const-string v4, "com.nidyaber.fuckdsmanger.MainActivity"

    const-string v5, "com.little_femaleboy.cannot_show.the_big_won_whale"

    invoke-direct {v3, v5, v4}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v1, v3}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    const/high16 v3, 0x14000000

    .line 119
    invoke-virtual {v1, v3}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 120
    const-string v3, "\u663e\u5f0f"

    invoke-static {p0, v1, v3}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->start(Landroid/content/Context;Landroid/content/Intent;Ljava/lang/String;)Z

    move-result v1

    const/4 v3, 0x1

    if-eqz v1, :cond_2f

    return v3

    .line 123
    :cond_2f
    new-instance v1, Landroid/content/Intent;

    const-string v4, "fdm://open"

    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-direct {v1, v2, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 124
    invoke-virtual {v1, v5}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v2, 0x10000000

    .line 125
    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 126
    const-string v2, "scheme"

    invoke-static {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->start(Landroid/content/Context;Landroid/content/Intent;Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_4b

    return v3

    .line 128
    :cond_4b
    const-string p0, "\u3010FdmUiHook\u3011\u4e24\u6761\u8def\u90fd\u6ca1\u8d77\u6765 \u21d2 \u56de\u9000\u65e7 View UI"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v0
.end method

.method private static start(Landroid/content/Context;Landroid/content/Intent;Ljava/lang/String;)Z
    .registers 4

    const-string v0, "\u3010FdmUiHook\u3011\u5df2\u62c9\u8d77 Compose UI \u2713\uff08"

    .line 134
    :try_start_2
    invoke-virtual {p0, p1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    .line 135
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\uff09"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_2 .. :try_end_19} :catchall_1b

    const/4 p0, 0x1

    return p0

    :catchall_1b
    move-exception p0

    .line 138
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u3010FdmUiHook\u3011"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " \u62c9\u8d77\u5931\u8d25\uff1a"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

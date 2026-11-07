.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;
.super Ljava/lang/Object;
.source "GmCatchUp.java"


# static fields
.field private static final INTERVAL_MS:J = 0xfaL

.field private static final MAX_ATTEMPTS:I = 0x18

.field private static sDone:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Z
    .registers 1

    .line 51
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z

    return v0
.end method

.method static synthetic access$002(Z)Z
    .registers 1

    .line 51
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z

    return p0
.end method

.method static synthetic access$100()Landroid/app/Activity;
    .registers 1

    .line 51
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->currentActivity()Landroid/app/Activity;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$200(Landroid/app/Activity;Ljava/lang/ClassLoader;I)V
    .registers 3

    .line 51
    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->bind(Landroid/app/Activity;Ljava/lang/ClassLoader;I)V

    return-void
.end method

.method private static bind(Landroid/app/Activity;Ljava/lang/ClassLoader;I)V
    .registers 5

    .line 93
    const-string p1, ")"

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010FDM\u3011\u8fdf\u5230\u7ed1\u5b9a \u2713 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 94
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08\u7b2c "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " \u6b21\u63a2\u6d4b\u547d\u4e2d\uff09"

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 98
    :try_start_21
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->bind(Landroid/app/Activity;)V

    .line 99
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->reload(Landroid/content/Context;)Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    .line 100
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result p2

    if-eqz p2, :cond_30

    .line 101
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->request()V

    .line 103
    :cond_30
    const-string p2, " \u00b7 \u73bb\u7483\u2713"

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_35
    .catchall {:try_start_21 .. :try_end_35} :catchall_36

    goto :goto_4a

    :catchall_36
    move-exception p2

    .line 105
    const-string v1, " \u00b7 \u73bb\u7483\u2717("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 112
    :goto_4a
    :try_start_4a
    const-string p2, "com.nidyaber.fuckdsmanger.gm.GmBg"

    const-class v1, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;

    .line 113
    invoke-virtual {v1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    .line 112
    invoke-static {p2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p2

    .line 114
    const-string v1, "ensure"

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p2, v1, p0}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 115
    const-string p0, " \u00b7 \u80cc\u666f\u2713"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_64
    .catchall {:try_start_4a .. :try_end_64} :catchall_65

    goto :goto_79

    :catchall_65
    move-exception p0

    .line 117
    const-string p2, " \u00b7 \u80cc\u666f\u2717("

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 120
    :goto_79
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static currentActivity()Landroid/app/Activity;
    .registers 5

    const/4 v0, 0x0

    .line 132
    :try_start_1
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 133
    const-string v2, "currentActivityThread"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    invoke-static {v1, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_13

    return-object v0

    .line 136
    :cond_13
    const-string v3, "mActivities"

    invoke-virtual {v1, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v3, 0x1

    .line 137
    invoke-virtual {v1, v3}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 138
    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 139
    instance-of v2, v1, Ljava/util/Map;

    if-nez v2, :cond_26

    return-object v0

    .line 141
    :cond_26
    check-cast v1, Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    .line 143
    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    move-object v2, v0

    :cond_31
    :goto_31
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_71

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    if-nez v3, :cond_3e

    goto :goto_31

    .line 145
    :cond_3e
    const-string v4, "activity"

    invoke-static {v3, v4}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 146
    instance-of v4, v3, Landroid/app/Activity;

    if-nez v4, :cond_49

    goto :goto_31

    .line 147
    :cond_49
    check-cast v3, Landroid/app/Activity;

    .line 148
    invoke-virtual {v3}, Landroid/app/Activity;->isFinishing()Z

    move-result v4

    if-nez v4, :cond_31

    invoke-virtual {v3}, Landroid/app/Activity;->isDestroyed()Z

    move-result v4

    if-eqz v4, :cond_58

    goto :goto_31

    .line 149
    :cond_58
    invoke-virtual {v3}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v4

    if-eqz v4, :cond_6d

    invoke-virtual {v3}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->isShown()Z

    move-result v4
    :try_end_6a
    .catchall {:try_start_1 .. :try_end_6a} :catchall_72

    if-eqz v4, :cond_6d

    return-object v3

    :cond_6d
    if-nez v2, :cond_31

    move-object v2, v3

    goto :goto_31

    :cond_71
    return-object v2

    :catchall_72
    move-exception v1

    .line 156
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010FDM\u3011\u8fdf\u5230\u7ed1\u5b9a\uff1a\u53d6\u5f53\u524d Activity \u5931\u8d25 "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-object v0
.end method

.method public static done()Z
    .registers 1

    .line 163
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z

    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 5

    .line 66
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 67
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;

    invoke-direct {v1, p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;-><init>(Ljava/lang/ClassLoader;Landroid/os/Handler;)V

    const-wide/16 v2, 0xfa

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

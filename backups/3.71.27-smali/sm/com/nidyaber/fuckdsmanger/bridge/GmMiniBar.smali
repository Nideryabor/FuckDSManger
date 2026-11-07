.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;
.super Ljava/lang/Object;
.source "GmMiniBar.java"


# static fields
.field public static final K_H:Ljava/lang/String; = "fuckds_bar_h"

.field public static final K_ON:Ljava/lang/String; = "fuckds_bar_on"

.field public static final K_W:Ljava/lang/String; = "fuckds_bar_w"

.field public static final K_X:Ljava/lang/String; = "fuckds_bar_x"

.field public static final K_Y:Ljava/lang/String; = "fuckds_bar_y"

.field private static volatile sCtx:Landroid/content/Context; = null

.field private static volatile sDecor:Landroid/view/ViewGroup; = null

.field private static volatile sInstalled:Z = false

.field private static volatile sSessionClosed:Z = false

.field private static volatile sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Landroid/content/Context;
    .registers 1

    .line 40
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;

    return-object v0
.end method

.method static synthetic access$002(Landroid/content/Context;)Landroid/content/Context;
    .registers 1

    .line 40
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;

    return-object p0
.end method

.method static synthetic access$100()Z
    .registers 1

    .line 40
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sSessionClosed:Z

    return v0
.end method

.method static synthetic access$200()V
    .registers 0

    .line 40
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V

    return-void
.end method

.method static synthetic access$300(Landroid/app/Activity;)V
    .registers 1

    .line 40
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->attach(Landroid/app/Activity;)V

    return-void
.end method

.method static synthetic access$400()Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
    .registers 1

    .line 40
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    return-object v0
.end method

.method private static attach(Landroid/app/Activity;)V
    .registers 9

    const-string v0, "\u3010GmMiniBar\u3011\u8ff7\u4f60\u5361\u5df2\u6302\u4e0a "

    if-eqz p0, :cond_b9

    .line 192
    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v1

    if-eqz v1, :cond_c

    goto/16 :goto_b9

    .line 194
    :cond_c
    :try_start_c
    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v1
    :try_end_10
    .catchall {:try_start_c .. :try_end_10} :catchall_14

    if-eqz v1, :cond_14

    goto/16 :goto_b9

    .line 199
    :catchall_14
    :cond_14
    :try_start_14
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;
    :try_end_1e
    .catchall {:try_start_14 .. :try_end_1e} :catchall_b9

    if-nez v1, :cond_22

    goto/16 :goto_b9

    .line 206
    :cond_22
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    if-eqz v2, :cond_2e

    .line 207
    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sDecor:Landroid/view/ViewGroup;

    if-eq v1, v3, :cond_2e

    .line 208
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V

    const/4 v2, 0x0

    :cond_2e
    if-eqz v2, :cond_32

    goto/16 :goto_b9

    .line 214
    :cond_32
    const-string v2, "fuckds_bar_w"

    const/16 v3, 0x14a

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadInt(Ljava/lang/String;I)I

    move-result v2

    .line 215
    const-string v4, "fuckds_bar_h"

    const/16 v5, 0xd2

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadInt(Ljava/lang/String;I)I

    move-result v4

    const/16 v6, 0xf0

    if-ge v2, v6, :cond_47

    goto :goto_48

    :cond_47
    move v3, v2

    :goto_48
    const/16 v2, 0x96

    if-ge v4, v2, :cond_4d

    goto :goto_4e

    :cond_4d
    move v5, v4

    .line 220
    :goto_4e
    :try_start_4e
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;-><init>(Landroid/app/Activity;)V

    .line 221
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    int-to-float v6, v3

    .line 222
    invoke-static {p0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->dp(Landroid/content/Context;F)I

    move-result v6

    int-to-float v7, v5

    invoke-static {p0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->dp(Landroid/content/Context;F)I

    move-result v7

    invoke-direct {v4, v6, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const v6, 0x800033

    .line 223
    iput v6, v4, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 224
    invoke-virtual {v1, v2, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 225
    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 226
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sDecor:Landroid/view/ViewGroup;

    .line 227
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->bootstrap()V

    .line 230
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v1

    if-eqz v1, :cond_86

    .line 232
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;

    invoke-direct {v4, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v1, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->setListener(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;)V

    .line 239
    invoke-virtual {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v1

    invoke-virtual {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V

    .line 241
    :cond_86
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff08"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "\u00d7"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "dp\uff09"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b2
    .catchall {:try_start_4e .. :try_end_b2} :catchall_b3

    goto :goto_b9

    :catchall_b3
    move-exception p0

    .line 244
    const-string v0, "\u3010GmMiniBar\u3011\u6302\u5230\u7a97\u53e3\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :catchall_b9
    :cond_b9
    :goto_b9
    return-void
.end method

.method static closeSession()V
    .registers 1

    const/4 v0, 0x1

    .line 144
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sSessionClosed:Z

    .line 145
    const-string v0, "\u3010GmMiniBar\u3011\u672c\u4f1a\u8bdd\u6536\u8d77\uff08\u62e8\u5f00\u5173\u6216\u91cd\u542f\u5bbf\u4e3b\u6062\u590d\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 146
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V

    return-void
.end method

.method private static curActivity()Landroid/app/Activity;
    .registers 3

    const/4 v0, 0x0

    .line 267
    :try_start_1
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmEntry"

    const-class v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;

    .line 268
    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    .line 267
    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 269
    const-string v2, "sAct"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x1

    .line 270
    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 271
    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 272
    instance-of v2, v1, Landroid/app/Activity;

    if-eqz v2, :cond_22

    check-cast v1, Landroid/app/Activity;
    :try_end_21
    .catchall {:try_start_1 .. :try_end_21} :catchall_22

    return-object v1

    :catchall_22
    :cond_22
    return-object v0
.end method

.method private static detachAll()V
    .registers 3

    .line 249
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x0

    .line 250
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 251
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sDecor:Landroid/view/ViewGroup;

    .line 253
    :try_start_7
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    if-eqz v2, :cond_10

    .line 254
    invoke-virtual {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->setListener(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;)V
    :try_end_10
    .catchall {:try_start_7 .. :try_end_10} :catchall_10

    :catchall_10
    :cond_10
    if-nez v0, :cond_13

    goto :goto_1e

    .line 259
    :cond_13
    :try_start_13
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_1e

    .line 260
    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V
    :try_end_1e
    .catchall {:try_start_13 .. :try_end_1e} :catchall_1e

    :catchall_1e
    :cond_1e
    :goto_1e
    return-void
.end method

.method static dp(Landroid/content/Context;F)I
    .registers 2

    .line 280
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_10

    mul-float/2addr p1, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr p1, p0

    float-to-int p0, p1

    return p0

    :catchall_10
    float-to-int p0, p1

    return p0
.end method

.method static enabled(Landroid/content/Context;)Z
    .registers 3

    const/4 v0, 0x0

    .line 127
    :try_start_1
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-eqz p0, :cond_11

    .line 128
    const-string v1, "fuckds_bar_on"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0
    :try_end_d
    .catchall {:try_start_1 .. :try_end_d} :catchall_11

    if-eqz p0, :cond_11

    const/4 p0, 0x1

    return p0

    :catchall_11
    :cond_11
    return v0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 4

    .line 61
    const-string v0, "android.app.Activity"

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sInstalled:Z

    if-eqz v1, :cond_7

    return-void

    .line 63
    :cond_7
    :try_start_7
    const-string v1, "onResume"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$1;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$1;-><init>()V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 83
    const-string v1, "onPause"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$2;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$2;-><init>()V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    const/4 p0, 0x1

    .line 92
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sInstalled:Z

    .line 93
    const-string p0, "\u3010GmMiniBar\u3011\u8ff7\u4f60\u5361\u94a9\u5b50\u5df2\u6302 \u2713\uff08\u5e38\u9a7b\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 94
    const-string p0, "[FDM] \u8ff7\u4f60\u5361\u94a9\u5b50\u5df2\u6302 \u2713"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_30
    .catchall {:try_start_7 .. :try_end_30} :catchall_31

    return-void

    :catchall_31
    move-exception p0

    .line 96
    const-string v0, "\u3010GmMiniBar\u3011\u6302\u8f7d\u5931\u8d25\uff08\u7b49\u4e8e\u6ca1\u88c5\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 97
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] GmMiniBar \u6302\u8f7d\u5931\u8d25\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static isOn(Landroid/content/Context;)Z
    .registers 1

    .line 122
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->enabled(Landroid/content/Context;)Z

    move-result p0

    return p0
.end method

.method static loadInt(Ljava/lang/String;I)I
    .registers 3

    .line 174
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    if-nez v0, :cond_9

    goto :goto_e

    .line 175
    :cond_9
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    return p0

    :catchall_e
    :goto_e
    return p1
.end method

.method static loadX(I)I
    .registers 2

    .line 186
    const-string v0, "fuckds_bar_x"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadInt(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method static loadY(I)I
    .registers 2

    .line 182
    const-string v0, "fuckds_bar_y"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadInt(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method static px2dp(Landroid/content/Context;F)I
    .registers 2

    .line 288
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_10

    div-float/2addr p1, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr p1, p0

    float-to-int p0, p1

    return p0

    :catchall_10
    float-to-int p0, p1

    return p0
.end method

.method static savePos(II)V
    .registers 3

    .line 152
    const-string v0, "fuckds_bar_x"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    .line 153
    const-string p0, "fuckds_bar_y"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    return-void
.end method

.method static saveSize(IIII)V
    .registers 5

    .line 157
    const-string v0, "fuckds_bar_w"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    .line 158
    const-string p0, "fuckds_bar_h"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    .line 159
    const-string p0, "fuckds_bar_x"

    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    .line 160
    const-string p0, "fuckds_bar_y"

    invoke-static {p0, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->writeInt(Ljava/lang/String;I)V

    return-void
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 6

    const-string v0, "\u3010GmMiniBar\u3011\u5f00\u5173 \u2192 "

    .line 105
    :try_start_2
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;

    const/4 v1, 0x0

    .line 106
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sSessionClosed:Z

    .line 107
    const-string v1, "fuckds_bar_on"

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    const-string v3, "b"

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 108
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-nez p1, :cond_27

    .line 110
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->detachAll()V

    return-void

    .line 113
    :cond_27
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->install(Landroid/content/Context;)V

    .line 114
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->curActivity()Landroid/app/Activity;

    move-result-object p0

    if-eqz p0, :cond_33

    .line 115
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->attach(Landroid/app/Activity;)V
    :try_end_33
    .catchall {:try_start_2 .. :try_end_33} :catchall_34

    :cond_33
    return-void

    :catchall_34
    move-exception p0

    .line 117
    const-string p1, "\u3010GmMiniBar\u3011setOn \u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method static sp(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 1

    .line 136
    :try_start_0
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0
    :try_end_4
    .catchall {:try_start_0 .. :try_end_4} :catchall_5

    return-object p0

    :catchall_5
    const/4 p0, 0x0

    return-object p0
.end method

.method private static writeInt(Ljava/lang/String;I)V
    .registers 4

    .line 165
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sCtx:Landroid/content/Context;

    if-nez v0, :cond_5

    goto :goto_e

    .line 167
    :cond_5
    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p1

    const-string v1, "i"

    invoke-static {v0, p0, p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_e

    :catchall_e
    :goto_e
    return-void
.end method

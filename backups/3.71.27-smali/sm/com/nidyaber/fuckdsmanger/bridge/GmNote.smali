.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmNote;
.super Ljava/lang/Object;
.source "GmNote.java"


# static fields
.field private static final BASE_ENTRY:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.gm.GmEntry"

.field public static final DEF_ALPHA:I = 0xe6

.field public static final DEF_BG:I = -0xc50

.field public static final DEF_SIZE:I = 0xe

.field public static final K_ALPHA:Ljava/lang/String; = "fuckds_note_alpha"

.field public static final K_BG:Ljava/lang/String; = "fuckds_note_bg"

.field public static final K_DATA:Ljava/lang/String; = "fuckds_note_data"

.field public static final K_ON:Ljava/lang/String; = "fuckds_note_on"

.field public static final K_SIZE:Ljava/lang/String; = "fuckds_note_size"

.field public static final K_TEXT:Ljava/lang/String; = "fuckds_note_text"

.field private static volatile sCtx:Landroid/content/Context; = null

.field private static volatile sInstalled:Z = false

.field private static volatile sSessionClosed:Z = false

.field private static volatile sState:Lorg/json/JSONObject;

.field private static volatile sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 66
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$002(Landroid/content/Context;)Landroid/content/Context;
    .registers 1

    .line 40
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;

    return-object p0
.end method

.method static synthetic access$100()Z
    .registers 1

    .line 40
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sSessionClosed:Z

    return v0
.end method

.method static synthetic access$200()V
    .registers 0

    .line 40
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->detachAll()V

    return-void
.end method

.method static synthetic access$300(Landroid/app/Activity;)V
    .registers 1

    .line 40
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->attach(Landroid/app/Activity;)V

    return-void
.end method

.method static declared-synchronized addItem()V
    .registers 4

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 307
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    .line 308
    const-string v2, "items"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-nez v2, :cond_19

    .line 310
    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2}, Lorg/json/JSONArray;-><init>()V

    .line 311
    const-string v3, "items"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 313
    :cond_19
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 314
    const-string v3, "idx"

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v2

    add-int/lit8 v2, v2, -0x1

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 315
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_2f
    .catchall {:try_start_3 .. :try_end_2f} :catchall_30

    goto :goto_36

    :catchall_30
    move-exception v1

    .line 317
    :try_start_31
    const-string v2, "\u3010GmNote\u3011\u65b0\u5efa\u4fbf\u7b7e\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_36
    .catchall {:try_start_31 .. :try_end_36} :catchall_38

    .line 319
    :goto_36
    monitor-exit v0

    return-void

    :catchall_38
    move-exception v1

    :try_start_39
    monitor-exit v0
    :try_end_3a
    .catchall {:try_start_39 .. :try_end_3a} :catchall_38

    throw v1
.end method

.method private static attach(Landroid/app/Activity;)V
    .registers 6

    const-string v0, "\u3010GmNote\u3011\u4fbf\u7b7e\u5df2\u6302\u4e0a\u7a97\u53e3 "

    if-eqz p0, :cond_61

    .line 397
    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v1

    if-eqz v1, :cond_b

    goto :goto_61

    .line 399
    :cond_b
    :try_start_b
    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v1
    :try_end_f
    .catchall {:try_start_b .. :try_end_f} :catchall_12

    if-eqz v1, :cond_12

    goto :goto_61

    .line 405
    :catchall_12
    :cond_12
    :try_start_12
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;
    :try_end_1c
    .catchall {:try_start_12 .. :try_end_1c} :catchall_61

    if-nez v1, :cond_1f

    goto :goto_61

    .line 411
    :cond_1f
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    if-eqz v2, :cond_2d

    .line 412
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    if-ne v2, v1, :cond_2d

    .line 413
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->refresh()V

    return-void

    .line 416
    :cond_2d
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->detachAll()V

    .line 418
    :try_start_30
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;-><init>(Landroid/app/Activity;)V

    .line 419
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x2

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 422
    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    .line 423
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->bootstrap()V

    .line 424
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_5a
    .catchall {:try_start_30 .. :try_end_5a} :catchall_5b

    goto :goto_61

    :catchall_5b
    move-exception p0

    .line 426
    const-string v0, "\u3010GmNote\u3011\u6302\u5230\u7a97\u53e3\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :catchall_61
    :cond_61
    :goto_61
    return-void
.end method

.method static cfgAlpha(Landroid/content/Context;)I
    .registers 3

    const/16 v0, 0xe6

    .line 144
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_9

    return v0

    .line 145
    :cond_9
    const-string v1, "fuckds_note_alpha"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0
    :try_end_f
    .catchall {:try_start_2 .. :try_end_f} :catchall_10

    return p0

    :catchall_10
    return v0
.end method

.method static cfgBg(Landroid/content/Context;)I
    .registers 3

    const/16 v0, -0xc50

    .line 134
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_a

    move p0, v0

    goto :goto_10

    .line 135
    :cond_a
    const-string v1, "fuckds_note_bg"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0
    :try_end_10
    .catchall {:try_start_2 .. :try_end_10} :catchall_14

    :goto_10
    if-nez p0, :cond_13

    return v0

    :cond_13
    return p0

    :catchall_14
    return v0
.end method

.method static cfgSize(Landroid/content/Context;)I
    .registers 3

    const/16 v0, 0xe

    .line 153
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_a

    move p0, v0

    goto :goto_10

    .line 154
    :cond_a
    const-string v1, "fuckds_note_size"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0
    :try_end_10
    .catchall {:try_start_2 .. :try_end_10} :catchall_14

    :goto_10
    if-gtz p0, :cond_13

    return v0

    :cond_13
    return p0

    :catchall_14
    return v0
.end method

.method public static closeSession()V
    .registers 1

    const/4 v0, 0x1

    .line 286
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sSessionClosed:Z

    .line 287
    const-string v0, "\u3010GmNote\u3011\u672c\u4f1a\u8bdd\u5173\u95ed\uff08\u62e8\u5f00\u5173\u6216\u91cd\u542f\u5bbf\u4e3b\u6062\u590d\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 288
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->detachAll()V

    return-void
.end method

.method private static curActivity()Landroid/app/Activity;
    .registers 3

    const/4 v0, 0x0

    .line 448
    :try_start_1
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmEntry"

    const-class v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 449
    const-string v2, "sAct"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x1

    .line 450
    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 451
    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 452
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

.method static declared-synchronized curIdx()I
    .registers 4

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 221
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "idx"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v1

    .line 222
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->total()I

    move-result v2
    :try_end_12
    .catchall {:try_start_3 .. :try_end_12} :catchall_1c

    if-gez v1, :cond_15

    goto :goto_16

    :cond_15
    move v3, v1

    :goto_16
    if-lt v3, v2, :cond_1a

    add-int/lit8 v3, v2, -0x1

    .line 225
    :cond_1a
    monitor-exit v0

    return v3

    :catchall_1c
    move-exception v1

    :try_start_1d
    monitor-exit v0
    :try_end_1e
    .catchall {:try_start_1d .. :try_end_1e} :catchall_1c

    throw v1
.end method

.method static declared-synchronized curItem()Lorg/json/JSONObject;
    .registers 5

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 205
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    .line 206
    const-string v2, "items"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-eqz v2, :cond_3a

    .line 207
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-nez v3, :cond_16

    goto :goto_3a

    .line 208
    :cond_16
    const-string v3, "idx"

    const/4 v4, 0x0

    invoke-virtual {v1, v3, v4}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v1

    if-gez v1, :cond_20

    goto :goto_21

    :cond_20
    move v4, v1

    .line 210
    :goto_21
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-lt v4, v1, :cond_2d

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v1

    add-int/lit8 v4, v1, -0x1

    .line 211
    :cond_2d
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v1

    if-nez v1, :cond_38

    .line 212
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V
    :try_end_38
    .catchall {:try_start_3 .. :try_end_38} :catchall_41

    :cond_38
    monitor-exit v0

    return-object v1

    .line 207
    :cond_3a
    :goto_3a
    :try_start_3a
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V
    :try_end_3f
    .catchall {:try_start_3a .. :try_end_3f} :catchall_41

    monitor-exit v0

    return-object v1

    :catchall_41
    move-exception v1

    :try_start_42
    monitor-exit v0
    :try_end_43
    .catchall {:try_start_42 .. :try_end_43} :catchall_41

    throw v1
.end method

.method static declared-synchronized delItem()V
    .registers 8

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 323
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    .line 324
    const-string v2, "items"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-eqz v2, :cond_5f

    .line 325
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-nez v3, :cond_16

    goto :goto_5f

    .line 326
    :cond_16
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curIdx()I

    move-result v3

    .line 327
    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    const/4 v5, 0x0

    move v6, v5

    .line 328
    :goto_21
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v7

    if-ge v6, v7, :cond_33

    if-eq v6, v3, :cond_30

    .line 329
    invoke-virtual {v2, v6}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v7

    invoke-virtual {v4, v7}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    :cond_30
    add-int/lit8 v6, v6, 0x1

    goto :goto_21

    .line 331
    :cond_33
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-nez v2, :cond_41

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v4, v2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 332
    :cond_41
    const-string v2, "items"

    invoke-virtual {v1, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 333
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-lt v3, v2, :cond_52

    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I

    move-result v2

    add-int/lit8 v3, v2, -0x1

    .line 334
    :cond_52
    const-string v2, "idx"

    if-gez v3, :cond_57

    goto :goto_58

    :cond_57
    move v5, v3

    :goto_58
    invoke-virtual {v1, v2, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 335
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_5e
    .catchall {:try_start_3 .. :try_end_5e} :catchall_61

    goto :goto_67

    .line 325
    :cond_5f
    :goto_5f
    monitor-exit v0

    return-void

    :catchall_61
    move-exception v1

    .line 337
    :try_start_62
    const-string v2, "\u3010GmNote\u3011\u5220\u9664\u4fbf\u7b7e\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_67
    .catchall {:try_start_62 .. :try_end_67} :catchall_69

    .line 339
    :goto_67
    monitor-exit v0

    return-void

    :catchall_69
    move-exception v1

    :try_start_6a
    monitor-exit v0
    :try_end_6b
    .catchall {:try_start_6a .. :try_end_6b} :catchall_69

    throw v1
.end method

.method private static detachAll()V
    .registers 2

    .line 431
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    const/4 v1, 0x0

    .line 432
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    if-nez v0, :cond_8

    goto :goto_16

    .line 435
    :cond_8
    :try_start_8
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->saveNow()V
    :try_end_b
    .catchall {:try_start_8 .. :try_end_b} :catchall_b

    .line 439
    :catchall_b
    :try_start_b
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_16

    .line 440
    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V
    :try_end_16
    .catchall {:try_start_b .. :try_end_16} :catchall_16

    :catchall_16
    :cond_16
    :goto_16
    return-void
.end method

.method static dp(Landroid/content/Context;F)I
    .registers 2

    .line 462
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

    .line 125
    :try_start_1
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-eqz p0, :cond_11

    .line 126
    const-string v1, "fuckds_note_on"

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

    .line 72
    const-string v0, "android.app.Activity"

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sInstalled:Z

    if-eqz v1, :cond_7

    return-void

    .line 74
    :cond_7
    :try_start_7
    const-string v1, "onResume"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$1;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$1;-><init>()V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 92
    const-string v1, "onPause"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$2;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$2;-><init>()V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    const/4 p0, 0x1

    .line 101
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sInstalled:Z

    .line 102
    const-string p0, "\u3010GmNote\u3011\u60ac\u6d6e\u4fbf\u7b7e\u94a9\u5b50\u5df2\u6302 \u2713\uff08activity.onResume/onPause\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 103
    const-string p0, "[FDM] \u60ac\u6d6e\u4fbf\u7b7e\u94a9\u5b50\u5df2\u6302 \u2713"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_30
    .catchall {:try_start_7 .. :try_end_30} :catchall_31

    return-void

    :catchall_31
    move-exception p0

    .line 105
    const-string v0, "\u3010GmNote\u3011\u6302\u8f7d\u5931\u8d25\uff08\u7b49\u4e8e\u6ca1\u88c5\uff0c\u5bbf\u4e3b\u4e0d\u53d7\u5f71\u54cd\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] GmNote \u6302\u8f7d\u5931\u8d25\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static declared-synchronized invalidate()V
    .registers 2

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    const/4 v1, 0x0

    .line 230
    :try_start_4
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;
    :try_end_6
    .catchall {:try_start_4 .. :try_end_6} :catchall_8

    .line 231
    monitor-exit v0

    return-void

    :catchall_8
    move-exception v1

    :try_start_9
    monitor-exit v0
    :try_end_a
    .catchall {:try_start_9 .. :try_end_a} :catchall_8

    throw v1
.end method

.method public static isOn(Landroid/content/Context;)Z
    .registers 1

    .line 260
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->enabled(Landroid/content/Context;)Z

    move-result p0

    return p0
.end method

.method static px2dp(Landroid/content/Context;F)I
    .registers 2

    .line 470
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

.method public static refresh()V
    .registers 2

    .line 268
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    if-nez v0, :cond_5

    goto :goto_d

    .line 271
    :cond_5
    :try_start_5
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$3;

    invoke-direct {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->post(Ljava/lang/Runnable;)Z
    :try_end_d
    .catchall {:try_start_5 .. :try_end_d} :catchall_d

    :catchall_d
    :goto_d
    return-void
.end method

.method private static declared-synchronized save()V
    .registers 5

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 386
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;

    if-eqz v1, :cond_1a

    .line 387
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;

    if-nez v2, :cond_c

    goto :goto_1a

    .line 388
    :cond_c
    const-string v2, "fuckds_note_data"

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;

    invoke-virtual {v3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "s"

    invoke-static {v1, v2, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_3 .. :try_end_19} :catchall_1c

    goto :goto_22

    .line 387
    :cond_1a
    :goto_1a
    monitor-exit v0

    return-void

    :catchall_1c
    move-exception v1

    .line 390
    :try_start_1d
    const-string v2, "\u3010GmNote\u3011\u843d\u76d8\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_22
    .catchall {:try_start_1d .. :try_end_22} :catchall_24

    .line 392
    :goto_22
    monitor-exit v0

    return-void

    :catchall_24
    move-exception v1

    :try_start_25
    monitor-exit v0
    :try_end_26
    .catchall {:try_start_25 .. :try_end_26} :catchall_24

    throw v1
.end method

.method static declared-synchronized setIdx(I)V
    .registers 4

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 343
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    .line 344
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->total()I

    move-result v2

    if-gez p0, :cond_e

    const/4 p0, 0x0

    :cond_e
    if-lt p0, v2, :cond_12

    add-int/lit8 p0, v2, -0x1

    .line 347
    :cond_12
    const-string v2, "idx"

    invoke-virtual {v1, v2, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 348
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_1a
    .catchall {:try_start_3 .. :try_end_1a} :catchall_1b

    goto :goto_21

    :catchall_1b
    move-exception p0

    .line 350
    :try_start_1c
    const-string v1, "\u3010GmNote\u3011\u5207\u6362\u4fbf\u7b7e\u5931\u8d25"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_21
    .catchall {:try_start_1c .. :try_end_21} :catchall_23

    .line 352
    :goto_21
    monitor-exit v0

    return-void

    :catchall_23
    move-exception p0

    :try_start_24
    monitor-exit v0
    :try_end_25
    .catchall {:try_start_24 .. :try_end_25} :catchall_23

    throw p0
.end method

.method static declared-synchronized setMin(Z)V
    .registers 4

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 365
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "min"

    invoke-virtual {v1, v2, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 366
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_10

    goto :goto_16

    :catchall_10
    move-exception p0

    .line 368
    :try_start_11
    const-string v1, "\u3010GmNote\u3011\u6700\u5c0f\u5316\u5931\u8d25"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_16
    .catchall {:try_start_11 .. :try_end_16} :catchall_18

    .line 370
    :goto_16
    monitor-exit v0

    return-void

    :catchall_18
    move-exception p0

    :try_start_19
    monitor-exit v0
    :try_end_1a
    .catchall {:try_start_19 .. :try_end_1a} :catchall_18

    throw p0
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 6

    const-string v0, "\u3010GmNote\u3011\u5f00\u5173 \u2192 "

    .line 243
    :try_start_2
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;

    const/4 v1, 0x0

    .line 244
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sSessionClosed:Z

    .line 245
    const-string v1, "fuckds_note_on"

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    const-string v3, "b"

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 246
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, "\uff08\u672c\u4f1a\u8bdd\u5173\u95ed\u6807\u8bb0\u5df2\u6e05\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-nez p1, :cond_2c

    .line 248
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->detachAll()V

    return-void

    .line 251
    :cond_2c
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curActivity()Landroid/app/Activity;

    move-result-object p0

    if-eqz p0, :cond_35

    .line 252
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->attach(Landroid/app/Activity;)V
    :try_end_35
    .catchall {:try_start_2 .. :try_end_35} :catchall_36

    :cond_35
    return-void

    :catchall_36
    move-exception p0

    .line 254
    const-string p1, "\u3010GmNote\u3011setOn \u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method static declared-synchronized setPos(II)V
    .registers 5

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 375
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curItem()Lorg/json/JSONObject;

    move-result-object v1

    .line 376
    const-string v2, "x"

    invoke-virtual {v1, v2, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 377
    const-string p0, "y"

    invoke-virtual {v1, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 378
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_14
    .catchall {:try_start_3 .. :try_end_14} :catchall_15

    goto :goto_1b

    :catchall_15
    move-exception p0

    .line 380
    :try_start_16
    const-string p1, "\u3010GmNote\u3011\u8bb0\u4f4d\u7f6e\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_1b
    .catchall {:try_start_16 .. :try_end_1b} :catchall_1d

    .line 382
    :goto_1b
    monitor-exit v0

    return-void

    :catchall_1d
    move-exception p0

    :try_start_1e
    monitor-exit v0
    :try_end_1f
    .catchall {:try_start_1e .. :try_end_1f} :catchall_1d

    throw p0
.end method

.method static declared-synchronized setText(Ljava/lang/String;)V
    .registers 4

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 356
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curItem()Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "t"

    if-nez p0, :cond_d

    const-string p0, ""

    :cond_d
    invoke-virtual {v1, v2, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 357
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->save()V
    :try_end_13
    .catchall {:try_start_3 .. :try_end_13} :catchall_14

    goto :goto_1a

    :catchall_14
    move-exception p0

    .line 359
    :try_start_15
    const-string v1, "\u3010GmNote\u3011\u5b58\u6587\u5b57\u5931\u8d25"

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_1a
    .catchall {:try_start_15 .. :try_end_1a} :catchall_1c

    .line 361
    :goto_1a
    monitor-exit v0

    return-void

    :catchall_1c
    move-exception p0

    :try_start_1d
    monitor-exit v0
    :try_end_1e
    .catchall {:try_start_1d .. :try_end_1e} :catchall_1c

    throw p0
.end method

.method public static setTextFromCfg(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    const-string v0, "\u3010GmNote\u3011\u754c\u9762\u63a8\u6765\u7684\u4fbf\u7b7e\u5185\u5bb9 \u2192 \u5f53\u524d\u8fd9\u5f20\uff08"

    .line 294
    :try_start_2
    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;

    if-nez p1, :cond_9

    .line 295
    const-string p0, ""

    goto :goto_a

    :cond_9
    move-object p0, p1

    :goto_a
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setText(Ljava/lang/String;)V

    .line 296
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez p1, :cond_16

    const/4 p1, 0x0

    goto :goto_1a

    .line 297
    :cond_16
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    :goto_1a
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u5b57\uff09"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 296
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_29
    .catchall {:try_start_2 .. :try_end_29} :catchall_2a

    return-void

    :catchall_2a
    move-exception p0

    .line 299
    const-string p1, "\u3010GmNote\u3011setTextFromCfg \u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method static sp(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 1

    .line 117
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

.method static declared-synchronized state()Lorg/json/JSONObject;
    .registers 6

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 165
    :try_start_3
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;

    if-eqz v1, :cond_b

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;
    :try_end_9
    .catchall {:try_start_3 .. :try_end_9} :catchall_a6

    monitor-exit v0

    return-object v1

    :cond_b
    const/4 v1, 0x0

    .line 168
    :try_start_c
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sCtx:Landroid/content/Context;

    if-nez v2, :cond_12

    move-object v2, v1

    goto :goto_16

    .line 169
    :cond_12
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    :goto_16
    if-nez v2, :cond_1a

    move-object v2, v1

    goto :goto_20

    .line 170
    :cond_1a
    const-string v3, "fuckds_note_data"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_20
    if-eqz v2, :cond_2e

    .line 171
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_2e

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_2d
    .catchall {:try_start_c .. :try_end_2d} :catchall_2e

    move-object v1, v3

    :catchall_2e
    :cond_2e
    const/4 v2, 0x0

    if-nez v1, :cond_4a

    .line 175
    :try_start_31
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V
    :try_end_36
    .catchall {:try_start_31 .. :try_end_36} :catchall_a6

    .line 177
    :try_start_36
    const-string v3, "idx"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 178
    const-string v3, "min"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 179
    const-string v3, "items"

    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    invoke-virtual {v1, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_4a
    .catchall {:try_start_36 .. :try_end_4a} :catchall_4a

    .line 185
    :catchall_4a
    :cond_4a
    :try_start_4a
    const-string v3, "items"

    invoke-virtual {v1, v3}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v3

    if-nez v3, :cond_5c

    .line 187
    new-instance v3, Lorg/json/JSONArray;

    invoke-direct {v3}, Lorg/json/JSONArray;-><init>()V

    .line 188
    const-string v4, "items"

    invoke-virtual {v1, v4, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 190
    :cond_5c
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-nez v4, :cond_6a

    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v3, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    :cond_6a
    move v4, v2

    .line 191
    :goto_6b
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_82

    .line 192
    invoke-virtual {v3, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    if-nez v5, :cond_7f

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v3, v4, v5}, Lorg/json/JSONArray;->put(ILjava/lang/Object;)Lorg/json/JSONArray;

    :cond_7f
    add-int/lit8 v4, v4, 0x1

    goto :goto_6b

    .line 194
    :cond_82
    const-string v4, "idx"

    invoke-virtual {v1, v4, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v4

    if-gez v4, :cond_8f

    .line 195
    const-string v5, "idx"

    invoke-virtual {v1, v5, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 196
    :cond_8f
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-lt v4, v2, :cond_a0

    const-string v2, "idx"

    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v3

    add-int/lit8 v3, v3, -0x1

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_a0
    .catchall {:try_start_4a .. :try_end_a0} :catchall_a0

    .line 199
    :catchall_a0
    :cond_a0
    :try_start_a0
    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;

    .line 200
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->sState:Lorg/json/JSONObject;
    :try_end_a4
    .catchall {:try_start_a0 .. :try_end_a4} :catchall_a6

    monitor-exit v0

    return-object v1

    :catchall_a6
    move-exception v1

    :try_start_a7
    monitor-exit v0
    :try_end_a8
    .catchall {:try_start_a7 .. :try_end_a8} :catchall_a6

    throw v1
.end method

.method static declared-synchronized total()I
    .registers 3

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;

    monitor-enter v0

    .line 216
    :try_start_3
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "items"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v1

    if-eqz v1, :cond_1b

    .line 217
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-nez v2, :cond_16

    goto :goto_1b

    :cond_16
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v1
    :try_end_1a
    .catchall {:try_start_3 .. :try_end_1a} :catchall_1e

    goto :goto_1c

    :cond_1b
    :goto_1b
    const/4 v1, 0x1

    :goto_1c
    monitor-exit v0

    return v1

    :catchall_1e
    move-exception v1

    :try_start_1f
    monitor-exit v0
    :try_end_20
    .catchall {:try_start_1f .. :try_end_20} :catchall_1e

    throw v1
.end method

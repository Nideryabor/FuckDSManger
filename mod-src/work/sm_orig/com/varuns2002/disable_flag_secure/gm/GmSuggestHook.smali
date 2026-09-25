.class public final Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSuggestHook.java"


# static fields
.field static sCache:Ljava/util/List;

.field static sDbg:I

.field static sHit:I

.field static sHitF:I

.field static sInfo:Ljava/lang/StringBuilder;

.field static sLast:I

.field static sLastF:I

.field static sLastNote:Ljava/lang/String;

.field static sPeak:Ljava/lang/String;

.field static sStat:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method public static build()Ljava/util/List;
    .registers 10

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sCache:Ljava/util/List;

    if-eqz v0, :cond_5

    return-object v0

    :cond_5
    const/4 v0, 0x0

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_d

    return-object v0

    :cond_d
    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->on(Landroid/content/Context;)Z

    move-result v2

    if-nez v2, :cond_14

    return-object v0

    :cond_14
    :try_start_14
    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "g56"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v5

    const/4 v6, 0x0

    :goto_2c
    if-ge v6, v5, :cond_43

    invoke-interface {v4, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    const/16 v8, 0x2329

    add-int/2addr v8, v6

    invoke-static {v2, v8, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->make(Ljava/lang/Class;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v8

    if-eqz v8, :cond_40

    invoke-interface {v3, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_40
    add-int/lit8 v6, v6, 0x1

    goto :goto_2c

    :cond_43
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v6

    const-string v7, "suggest.build"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "[\u5efa\u8bae] build \u6a21\u677f="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " \u9020\u51fa="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    if-nez v6, :cond_6b

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->dumpCtors(Ljava/lang/Class;)V

    goto :goto_6e

    :cond_6b
    sput-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sCache:Ljava/util/List;

    move-object v0, v3
    :try_end_6e
    .catchall {:try_start_14 .. :try_end_6e} :catchall_6f

    :goto_6e
    return-object v0

    :catchall_6f
    move-exception v1

    const-string v2, "suggest build FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object v0
.end method

.method static buildMut(Ljava/util/List;)Ljava/util/List;
    .registers 6

    const/4 v0, 0x0

    :try_start_1
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->buildMut2(Ljava/util/List;)Ljava/util/List;

    move-result-object v0
    :try_end_5
    .catchall {:try_start_1 .. :try_end_5} :catchall_6

    return-object v0

    :catchall_6
    move-exception v1

    const-string v2, "buildMut \u5185\u90e8\u629b\u5f02\u5e38\uff08\u5806\u6808\u89c1\u65e5\u5fd7\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-object v0
.end method

.method static buildMut2(Ljava/util/List;)Ljava/util/List;
    .registers 14

    const/4 v0, 0x0

    sget v11, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sDbg:I

    const/4 v12, 0x1

    if-eq v11, v12, :cond_c

    sput v12, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sDbg:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->probeDirect()Ljava/util/List;

    move-result-object v11

    :cond_c
    const-string v11, "suggest.bm"

    const-string v12, "[\u5efa\u8bae] buildMut2 \u8fdb\u5165\uff08\u5165\u53e3\u65e5\u5fd7\uff1b\u80fd\u51fa\u73b0\u5c31\u8bf4\u660e\u771f\u88ab\u8c03\u7528\u4e86\uff09"

    invoke-static {v11, v12}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p0, :cond_1bc

    const-string v11, "suggest.null"

    const-string v12, "[\u5efa\u8bae] buildMut2\uff1a\u5217\u8868\u975e\u7a7a\uff0c\u7ee7\u7eed\u5904\u7406"

    invoke-static {v11, v12}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v11

    const-string v12, "\u8fdb\u5165 buildMut \u5bbf\u4e3b="

    invoke-static {v11}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v12, v11}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;->sCtx:Landroid/content/Context;

    if-nez v1, :cond_35

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    :cond_35
    if-nez v1, :cond_45

    const-string v2, "suggest.noctx"

    const-string v3, "[\u5efa\u8bae] buildMut \u9000\u51fa\uff1a\u62ff\u4e0d\u5230 Context\uff08sCtx/app() \u5747\u7a7a\uff09"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "\u9000\u51fa:\u62ff\u4e0d\u5230Context"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    goto/16 :goto_1bc

    :cond_45
    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->on(Landroid/content/Context;)Z

    move-result v2

    if-nez v2, :cond_59

    const-string v2, "suggest.sw"

    const-string v3, "[\u5efa\u8bae] buildMut \u9000\u51fa\uff1a\u603b\u5f00\u5173\u662f\u5173\u7684"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "\u9000\u51fa:\u603b\u5f00\u5173\u5173"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    goto/16 :goto_1bc

    :cond_59
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->hasText()Z

    move-result v2

    if-nez v2, :cond_65

    const-string v2, "\u8f93\u5165\u6846\u6709\u5b57"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    goto :goto_6a

    :cond_65
    const-string v2, "\u8f93\u5165\u6846\u7a7a(\u4e0d\u518d\u9000\u51fa)"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    :goto_6a
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v4

    const/4 v2, 0x1

    if-ge v4, v2, :cond_f2

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "g56"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v4

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->count(Landroid/content/Context;)I

    move-result v5

    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6}, Ljava/util/ArrayList;-><init>()V

    const/4 v7, 0x0

    :goto_8d
    if-ge v7, v5, :cond_c6

    rem-int v8, v7, v4

    invoke-interface {v3, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v8

    const/4 v9, 0x3

    new-array v9, v9, [Ljava/lang/Object;

    const/4 v10, 0x0

    const/16 v11, 0x2329

    add-int/2addr v11, v7

    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    aput-object v11, v9, v10

    const/4 v10, 0x1

    const/4 v11, 0x0

    aput-object v11, v9, v10

    const/4 v10, 0x2

    aput-object v8, v9, v10

    invoke-static {v2, v9}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    const-string v10, "a"

    const/16 v11, 0x2329

    add-int/2addr v11, v7

    invoke-static {v9, v10, v11}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->putInt(Ljava/lang/Object;Ljava/lang/String;I)Z

    const-string v10, "c"

    invoke-static {v9, v10, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v10, "d"

    const/4 v11, 0x0

    invoke-static {v9, v10, v11}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    invoke-interface {v6, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v7, v7, 0x1

    goto :goto_8d

    :cond_c6
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v7

    if-gtz v7, :cond_cd

    goto :goto_e4

    :cond_cd
    const/4 v7, 0x0

    invoke-interface {v6, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    invoke-static {v7}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->dumpObj(Ljava/lang/Object;)V

    const-string v7, "\u76f4\u8fde\u6784\u9020\u6210\u529f\uff083 \u53c2\uff09"

    invoke-static {v7}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->noteOk(Ljava/lang/String;)V

    const-string v7, "suggest.direct"

    const-string v8, "[\u5efa\u8bae] \u76f4\u8fde g56(int,Integer,String) \u6784\u9020\u6210\u529f"

    invoke-static {v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v6

    goto/16 :goto_1bc

    :goto_e4
    const-string v2, "\u9000\u51fa:\u5bbf\u4e3b\u5217\u8868\u7a7a\u4e14\u81ea\u5efa\u5931\u8d25"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    const-string v2, "suggest.empty"

    const-string v3, "[\u5efa\u8bae] buildMut \u9000\u51fa\uff1a\u5bbf\u4e3b\u5217\u8868\u4e3a\u7a7a\u4e14\u81ea\u5efa\u5931\u8d25\uff08\u770b suggest build FAIL \u65e5\u5fd7\uff09"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_1bc

    :cond_f2
    const/4 v2, 0x0

    invoke-interface {p0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "[\u5efa\u8bae] \u5bbf\u4e3b\u539f\u578b "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    const-string v11, "suggest.raw"

    invoke-static {v11, v12}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v2

    const/16 v11, 0x8

    if-le v2, v11, :cond_11f

    const/16 v2, 0x8

    :cond_11f
    const/4 v11, 0x1

    if-lt v2, v11, :cond_1bc

    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    const/4 v6, 0x0

    :goto_128
    if-ge v6, v2, :cond_181

    invoke-interface {p0, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    if-eqz v7, :cond_17e

    invoke-interface {v3, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v9

    const-string v10, "g56"

    invoke-static {v10, v9}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v9

    const/4 v10, 0x3

    new-array v10, v10, [Ljava/lang/Object;

    const/4 v11, 0x0

    const/16 v12, 0x2329

    add-int/2addr v12, v6

    invoke-static {v12}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    aput-object v12, v10, v11

    const/4 v11, 0x1

    const/4 v12, 0x0

    aput-object v12, v10, v11

    const/4 v11, 0x2

    aput-object v8, v10, v11

    invoke-static {v9, v10}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    const-string v10, "b"

    invoke-static {v7, v10}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v10

    if-eqz v10, :cond_165

    const-string v11, "b"

    invoke-static {v9, v11, v10}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    :cond_165
    const-string v10, "c"

    invoke-static {v9, v10, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v10, "d"

    const/4 v11, 0x0

    invoke-static {v9, v10, v11}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v10, "a"

    const/16 v11, 0x9

    add-int/2addr v11, v6

    invoke-static {v9, v10, v11}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->putInt(Ljava/lang/Object;Ljava/lang/String;I)Z

    invoke-static {v9}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->dumpObj(Ljava/lang/Object;)V

    invoke-interface {v5, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_17e
    add-int/lit8 v6, v6, 0x1

    goto :goto_128

    :cond_181
    invoke-interface {v5}, Ljava/util/List;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_1b6

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "[\u5efa\u8bae] \u6539\u9020 n="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, " \u9996\u6761="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v7, 0x0

    invoke-interface {v5, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    invoke-static {v7}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const-string v7, "suggest.mut"

    invoke-static {v7, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1b6
    const-string v6, "\u5df2\u63a5\u7ba1\u5217\u8868"

    invoke-static {v6}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->noteOk(Ljava/lang/String;)V

    move-object v0, v5

    :cond_1bc
    :goto_1bc
    return-object v0
.end method

.method public static clear()V
    .registers 1

    const/4 v0, 0x0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sCache:Ljava/util/List;

    return-void
.end method

.method static dumpCtors(Ljava/lang/Class;)V
    .registers 8

    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[\u5efa\u8bae] g56 \u6784\u9020\u5668 \u2192 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_10
    if-ge v3, v2, :cond_23

    aget-object v4, v1, v3

    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \uff5c "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_10

    :cond_23
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "suggest.ctors"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2c
    .catchall {:try_start_0 .. :try_end_2c} :catchall_2d

    return-void

    :catchall_2d
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method static dumpObj(Ljava/lang/Object;)V
    .registers 8

    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v3, 0x0

    :goto_e
    array-length v4, v1

    if-ge v3, v4, :cond_46

    aget-object v4, v1, v3

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    invoke-virtual {v4}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ":"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    invoke-static {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " | "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    :cond_46
    const-string v3, "suggest.fields"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "[\u5efa\u8bae] g56 \u5b57\u6bb5 \u2192 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
    :try_end_61
    .catchall {:try_start_0 .. :try_end_61} :catchall_61

    :catchall_61
    move-exception v0

    const-string v1, "suggest.fields"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[\u5efa\u8bae] \u5b57\u6bb5 dump \u5931\u8d25\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static forceVis([Ljava/lang/Object;)V
    .registers 6

    if-nez p0, :cond_3

    return-void

    :cond_3
    :try_start_3
    array-length v0, p0

    const/4 v1, 0x6

    if-lt v0, v1, :cond_12

    const/4 v1, 0x4

    aget-object v2, p0, v1

    instance-of v3, v2, Ljava/lang/Boolean;

    if-eqz v3, :cond_12

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    aput-object v3, p0, v1

    :cond_12
    const/4 v1, 0x0

    aget-object v2, p0, v1

    if-nez v2, :cond_18

    return-void

    :cond_18
    const/4 v1, 0x1

    new-array v3, v1, [Ljava/lang/Object;

    const/4 v4, 0x0

    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    aput-object p0, v3, v4

    const-string v4, "b"

    invoke-static {v2, v4}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_2d

    const-string p0, "setValue"

    invoke-static {v4, p0, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2d
    const-string v4, "c1"

    invoke-static {v2, v4, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v4, "i1"

    invoke-static {v2, v4, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_37
    .catchall {:try_start_3 .. :try_end_37} :catchall_38

    return-void

    :catchall_38
    move-exception v0

    const-string v1, "suggest.vis"

    const-string v2, "[\u5efa\u8bae] \u53ef\u89c1\u6027\u5f3a\u5236\u5931\u8d25\uff08eb6/dm0 \u7ed3\u6784\u53d8\u4e86\uff1f\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static hasText()Z
    .registers 5

    const/4 v0, 0x0

    :try_start_1
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmSeeHook;->sLast:Ljava/lang/String;

    if-nez v1, :cond_1a

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;->sState:Ljava/lang/Object;

    if-eqz v1, :cond_24

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    const-string v3, "b"

    invoke-static {v1, v3, v2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_24

    instance-of v2, v1, Ljava/lang/String;

    if-eqz v2, :cond_24

    check-cast v1, Ljava/lang/String;

    :cond_1a
    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_25

    :cond_24
    return v0

    :cond_25
    const/4 v0, 0x1

    return v0
    :try_end_27
    .catchall {:try_start_1 .. :try_end_27} :catchall_27

    :catchall_27
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return v0
.end method

.method public static infoText()Ljava/lang/String;
    .registers 4

    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u6700\u540e\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sStat:Ljava/lang/String;

    if-nez v1, :cond_10

    const-string v1, "(\u8fd8\u6ca1\u8dd1\u5230\u4efb\u4f55\u5173\u952e\u70b9)"

    :cond_10
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n\u6700\u4f18\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sPeak:Ljava/lang/String;

    if-nez v1, :cond_1e

    const-string v1, "(\u8fd8\u6ca1\u6709\u6210\u529f\u8fc7)"

    :cond_1e
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n\u2014 \u5386\u53f2 \u2014\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sInfo:Ljava/lang/StringBuilder;

    if-nez v1, :cond_2d

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;

    :cond_2d
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_32
    .catchall {:try_start_0 .. :try_end_32} :catchall_32

    :catchall_32
    move-exception v0

    const-string v0, "(\u8bfb\u53d6\u5931\u8d25)"

    return-object v0
.end method

.method static make(Ljava/lang/Class;ILjava/lang/String;)Ljava/lang/Object;
    .registers 12

    const/4 v0, 0x0

    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_7
    if-ge v3, v2, :cond_1f

    aget-object v4, v1, v3

    invoke-virtual {v4}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    array-length v6, v5

    const/4 v7, 0x3

    if-lt v6, v7, :cond_14

    goto :goto_1c

    :cond_14
    invoke-static {v4, p1, p2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->tryCtor(Ljava/lang/reflect/Constructor;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v6

    if-nez v6, :cond_1c

    move-object v0, v6

    goto :goto_1f

    :cond_1c
    :goto_1c
    add-int/lit8 v3, v3, 0x1

    goto :goto_7

    :cond_1f
    :goto_1f
    if-nez v0, :cond_22

    return-object v0

    :cond_22
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->dumpCtors(Ljava/lang/Class;)V

    return-object v0
.end method

.method public static note(Ljava/lang/String;)V
    .registers 4

    :try_start_0
    if-eqz p0, :cond_2f

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLastNote:Ljava/lang/String;

    if-eqz v0, :cond_c

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2f

    :cond_c
    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLastNote:Ljava/lang/String;

    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sStat:Ljava/lang/String;

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sInfo:Ljava/lang/StringBuilder;

    if-nez v0, :cond_1b

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sInfo:Ljava/lang/StringBuilder;

    :cond_1b
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    const/16 v2, 0x3e8

    if-le v1, v2, :cond_2f

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->setLength(I)V

    :cond_2f
    return-void
    :try_end_30
    .catchall {:try_start_0 .. :try_end_30} :catchall_30

    :catchall_30
    move-exception v0

    return-void
.end method

.method public static noteOk(Ljava/lang/String;)V
    .registers 2

    :try_start_0
    if-eqz p0, :cond_4

    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sPeak:Ljava/lang/String;

    :cond_4
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    return-void
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_8

    :catchall_8
    move-exception v0

    return-void
.end method

.method static probeDirect()Ljava/util/List;
    .registers 12

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "g56"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v3

    const/4 v6, 0x0

    invoke-interface {v3, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v6

    const/4 v7, 0x3

    new-array v7, v7, [Ljava/lang/Object;

    const/4 v8, 0x0

    const/16 v9, 0x2329

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    aput-object v9, v7, v8

    const/4 v8, 0x1

    const/4 v9, 0x0

    aput-object v9, v7, v8

    const/4 v8, 0x2

    aput-object v6, v7, v8

    invoke-static {v2, v7}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    const-string v7, "a"

    const/16 v8, 0x2329

    invoke-static {v9, v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->putInt(Ljava/lang/Object;Ljava/lang/String;I)Z

    const-string v7, "c"

    invoke-static {v9, v7, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v7, "d"

    const/4 v8, 0x0

    invoke-static {v9, v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    invoke-interface {v5, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string v7, "suggest.probe"

    const-string v8, "[\u5efa\u8bae] \u63a2\u9488\uff1ag56 \u6784\u9020\u6210\u529f\uff08\u672a\u629b\u5f02\u5e38\uff09"

    invoke-static {v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object v5
.end method

.method static put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z
    .registers 4

    :try_start_0
    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const/4 v0, 0x1

    return v0
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    :catchall_5
    move-exception v0

    const-string p0, "suggest.set"

    const-string p1, "[\u5efa\u8bae] \u5b57\u6bb5\u5199\u5165\u5931\u8d25\uff08\u5b57\u6bb5\u540d/\u7c7b\u578b\u53d8\u4e86\uff1f\uff09"

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    return v0
.end method

.method static putInt(Ljava/lang/Object;Ljava/lang/String;I)Z
    .registers 4

    :try_start_0
    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V

    const/4 v0, 0x1

    return v0
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    :catchall_5
    move-exception v0

    const/4 v0, 0x0

    return v0
.end method

.method static report(I)V
    .registers 5

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sHit:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sHit:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_15

    const-string v1, "suggest.hit"

    const-string v2, "[\u5efa\u8bae] \u63d0\u793a\u8bcd\u5bb9\u5668\u547d\u4e2d\uff08yb5.e/f\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "e \u547d\u4e2d\uff08\u9996\u6b21\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    :cond_15
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLast:I

    if-ne v0, p0, :cond_1a

    return-void

    :cond_1a
    sput p0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLast:I

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[\u5efa\u8bae] \u5bbf\u4e3b\u5217\u8868 list="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method static reportF(I)V
    .registers 5

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sHitF:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sHitF:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_15

    const-string v1, "suggest.hitF"

    const-string v2, "[\u5efa\u8bae] yb5.f \u547d\u4e2d\uff08\u5217\u8868\u884c\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "f \u547d\u4e2d\uff08\u9996\u6b21\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->note(Ljava/lang/String;)V

    :cond_15
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLastF:I

    if-ne v0, p0, :cond_1a

    return-void

    :cond_1a
    sput p0, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->sLastF:I

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[\u5efa\u8bae] f \u5217\u8868="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method static str(Ljava/lang/Object;)Ljava/lang/String;
    .registers 2

    if-eqz p0, :cond_8

    :try_start_2
    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_7
    .catchall {:try_start_2 .. :try_end_7} :catchall_7

    :catchall_7
    move-exception v0

    :cond_8
    const-string v0, "?"

    return-object v0
.end method

.method static tryCtor(Ljava/lang/reflect/Constructor;ILjava/lang/String;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    invoke-virtual {p0}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v1

    array-length v1, v1

    const/4 v2, 0x3

    if-ne v1, v2, :cond_1f

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x1

    const/4 v3, 0x0

    aput-object v3, v1, v2

    const/4 v2, 0x2

    aput-object p2, v1, v2

    goto :goto_39

    :cond_1f
    const/4 v1, 0x4

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    const/4 v3, 0x7

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x2

    const-string v3, "default"

    aput-object v3, v1, v2

    const/4 v2, 0x3

    aput-object p2, v1, v2

    :goto_39
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const-string v2, "a"

    invoke-static {v1, v2, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->putInt(Ljava/lang/Object;Ljava/lang/String;I)Z

    const-string v2, "c"

    invoke-static {v1, v2, p2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v2, "d"

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->put(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)Z

    const-string v2, "c"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {p2, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_77

    move-object v0, v1
    :try_end_5a
    .catchall {:try_start_1 .. :try_end_5a} :catchall_5b

    goto :goto_9c

    :catchall_5b
    move-exception v1

    const-string v2, "suggest.ctorX"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[\u5efa\u8bae] \u6784\u9020\u629b\u5f02\u5e38\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_9c

    :cond_77
    const-string v2, "suggest.ctorV"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[\u5efa\u8bae] \u9020\u5b8c\u5b57\u6bb5c="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->str(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \u671f\u671b="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "suggest.ctorV"

    invoke-static {v4, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    :goto_9c
    return-object v0
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_2a

    const/4 v1, 0x0

    :goto_5
    array-length v3, v0

    if-ge v1, v3, :cond_2a

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/util/List;

    if-eqz v3, :cond_27

    check-cast v2, Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->reportF(I)V

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestHook;->buildMut(Ljava/util/List;)Ljava/util/List;

    move-result-object v4

    if-eqz v4, :cond_2a

    aput-object v4, v0, v1

    const-string v3, "suggest.on"

    const-string v4, "[\u5efa\u8bae] \u5217\u8868\u5df2\u63a5\u7ba1\uff08buildMut\uff09"

    invoke-static {v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_2a

    :cond_27
    add-int/lit8 v1, v1, 0x1

    goto :goto_5
    :try_end_2a
    .catchall {:try_start_0 .. :try_end_2a} :catchall_2b

    :cond_2a
    :goto_2a
    return-void

    :catchall_2b
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

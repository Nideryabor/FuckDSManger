.class public final Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmMmkvHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method static dump(Ljava/lang/String;)V
    .registers 9

    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[mmkv] \u6837\u672c len="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u5f00\u5173="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->isOn(Landroid/content/Context;)Z

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " \u542bfalse="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->FALSE:Ljava/lang/String;

    invoke-virtual {p0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " \u542btrue="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->TRUE:Ljava/lang/String;

    invoke-virtual {p0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const/16 v2, 0xa0

    if-lt v0, v2, :cond_49

    const/4 v2, 0x0

    const/16 v3, 0xa0

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    goto :goto_4a

    :cond_49
    move-object v2, p0

    :goto_4a
    const-string v3, " \u524d160="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "mmkv.sample"

    invoke-static {v3, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_5b
    .catchall {:try_start_0 .. :try_end_5b} :catchall_5c

    return-void

    :catchall_5c
    move-exception v0

    return-void
.end method

.method static handle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    if-eqz p0, :cond_53

    if-eqz p1, :cond_53

    const-string v1, "kv_remote_settings_model_configs_v1"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_53

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->dump(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v2

    if-eqz v2, :cond_25

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->isOn(Landroid/content/Context;)Z

    move-result v3

    if-eqz v3, :cond_1d

    goto :goto_2d

    :cond_1d
    const-string v4, "mmkv.off"

    const-string v5, "[mmkv] \u8df3\u8fc7\uff1a\u6a21\u578b\u5207\u6362\u5f00\u5173\u672a\u5f00"

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_53

    :cond_25
    const-string v4, "mmkv.noctx"

    const-string v5, "[mmkv] \u8df3\u8fc7\uff1a\u62ff\u4e0d\u5230 Context"

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_53

    :goto_2d
    const-string v3, "\"switchable\"\\s*:\\s*false"

    const-string v4, "\"switchable\":true"

    invoke-virtual {p1, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_45

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->fix(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_4c

    :cond_45
    const-string v4, "[mmkv] switchable false\u2192true \u5df2\u66ff\u6362"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    move-object v0, v3

    goto :goto_53

    :cond_4c
    const-string v4, "mmkv.same"

    const-string v5, "[mmkv] \u8df3\u8fc7\uff1a\u503c\u91cc\u6ca1\u6709 switchable:false"

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_53
    .catchall {:try_start_1 .. :try_end_53} :catchall_54

    :cond_53
    :goto_53
    return-object v0

    :catchall_54
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method static rows(Landroid/content/Context;)Ljava/util/List;
    .registers 10

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->templates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_40

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-lt v1, v2, :cond_40

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    const/4 v4, 0x0

    :goto_13
    const/16 v5, 0x8

    if-ge v4, v5, :cond_3f

    rem-int v6, v4, v1

    invoke-interface {v0, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    const/4 v5, 0x3

    new-array v5, v5, [Ljava/lang/String;

    const/4 v7, 0x0

    add-int/lit8 v8, v4, 0x9

    invoke-static {v8}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v5, v7

    const/4 v7, 0x1

    const/4 v8, 0x4

    if-lt v4, v8, :cond_32

    const-string v8, "image"

    goto :goto_34

    :cond_32
    const-string v8, "file"

    :goto_34
    aput-object v8, v5, v7

    const/4 v7, 0x2

    aput-object v6, v5, v7

    invoke-interface {v3, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_13

    :cond_3f
    return-object v3

    :cond_40
    const/4 v0, 0x0

    return-object v0
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 7

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_2b

    array-length v1, v0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_2b

    const/4 v1, 0x0

    aget-object v1, v0, v1

    instance-of v2, v1, Ljava/lang/String;

    if-eqz v2, :cond_2b

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :cond_2b

    check-cast v2, Ljava/lang/String;

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->handle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_2b

    invoke-virtual {p1, v3}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v0, "mmkv.k"

    const-string v1, "[\u5efa\u8bae] \u5df2\u63a5\u7ba1\u3010\u8bfb\u53d6\u3011\u8fd4\u56de\u503c\uff1aprompt_feature \u6362\u6210\u6a21\u677f\u6c60"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_0 .. :try_end_2b} :catchall_2c

    :cond_2b
    return-void

    :catchall_2c
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 7

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_28

    array-length v1, v0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_28

    const/4 v1, 0x0

    aget-object v2, v0, v1

    const/4 v1, 0x1

    aget-object v3, v0, v1

    instance-of v1, v2, Ljava/lang/String;

    if-eqz v1, :cond_28

    instance-of v1, v3, Ljava/lang/String;

    if-eqz v1, :cond_28

    check-cast v2, Ljava/lang/String;

    check-cast v3, Ljava/lang/String;

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->handle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_28

    const/4 v1, 0x1

    aput-object v3, v0, v1

    const-string v0, "[mmkv\u5199] \u5bbf\u4e3b\u5199\u76d8\u503c\u5df2\u88ab\u66ff\u6362\uff08\u843d\u76d8\u5373\u6211\u4eec\u7684\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_28
    .catchall {:try_start_0 .. :try_end_28} :catchall_29

    :cond_28
    return-void

    :catchall_29
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

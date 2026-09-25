.class public final Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;
.super Ljava/lang/Object;
.source "GmCallDialog.java"

# interfaces
.implements Landroid/view/View$OnLongClickListener;


# static fields
.field static sAct:Landroid/app/Activity;

.field static sAo1:Ljava/lang/Object;

.field static sAsr:Ljava/lang/String;

.field static sCcomp:Ljava/lang/Object;

.field static sCmodel:Ljava/lang/Object;

.field static sCtor:Ljava/lang/Object;

.field static sCwr:Ljava/lang/Object;

.field static sDlg:Landroid/app/Dialog;

.field static sHookInfo:Ljava/lang/String;

.field static sInt:Landroid/widget/Button;

.field static sLast:Ljava/lang/String;

.field static sNewA:Ljava/lang/Object;

.field static sPairA:Ljava/lang/Object;

.field static sPairY:Ljava/lang/Object;

.field static sRec:Ljava/lang/Object;

.field static sSame:I

.field static sSeeA:Ljava/lang/Object;

.field static sSpk:Landroid/widget/Button;

.field static sSpkOn:Z

.field static sStat:Landroid/widget/TextView;

.field static sText:Landroid/widget/TextView;

.field static sThink:Z

.field static sThinkAt:J

.field static sYp1:Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static aiRole(Ljava/lang/Object;)Ljava/lang/String;
    .registers 4

    :try_start_0
    const-string v0, "D"

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_10

    check-cast v0, Ljava/lang/String;

    return-object v0

    :cond_10
    const/4 v0, 0x0

    return-object v0
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_12

    :catchall_12
    const/4 v0, 0x0

    return-object v0
.end method

.method static aiText(Ljava/lang/Object;)Ljava/lang/String;
    .registers 4

    :try_start_0
    const-string v0, "l"

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_10

    check-cast v0, Ljava/lang/String;

    return-object v0

    :cond_10
    const/4 v0, 0x0

    return-object v0
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_12

    :catchall_12
    const/4 v0, 0x0

    return-object v0
.end method

.method public static apply(ILjava/lang/String;)V
    .registers 6

    const/4 v0, 0x2

    if-ne p0, v0, :cond_34

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    if-eqz v0, :cond_45

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "\n\ud83e\udd16 "

    invoke-virtual {v1, v2}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v2

    if-gez v2, :cond_1c

    const/4 v3, 0x0

    invoke-virtual {v1, v3, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    :cond_1c
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n\ud83e\udd16 "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :cond_34
    if-eqz p0, :cond_3e

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    if-eqz v0, :cond_45

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :cond_3e
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    if-eqz v0, :cond_45

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_45
    return-void
.end method

.method public static applyAiText(Ljava/lang/String;Ljava/lang/String;)V
    .registers 6

    :try_start_0
    if-nez p0, :cond_54

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_54

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAsr:Ljava/lang/String;

    if-nez v0, :cond_12

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_54

    :cond_12
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sLast:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_54

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sLast:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSame:I

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    if-eqz v0, :cond_29

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sput-wide v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThinkAt:J

    :cond_29
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[\u901a\u8bdd][AI] \u6293\u5230\u56de\u590d \u6e90="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " \u957f\u5ea6="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u5185\u5bb9="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stream(Ljava/lang/String;)V
    :try_end_54
    .catchall {:try_start_0 .. :try_end_54} :catchall_54

    :catchall_54
    :cond_54
    return-void
.end method

.method static arrOfColl(Ljava/lang/Object;)[Ljava/lang/Object;
    .registers 4

    :try_start_0
    if-nez p0, :cond_f

    const-string v0, "toArray"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->methodOf(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, [Ljava/lang/Object;

    if-eqz v1, :cond_f

    check-cast v0, [Ljava/lang/Object;

    return-object v0

    :cond_f
    const/4 v0, 0x0

    return-object v0
    :try_end_11
    .catchall {:try_start_0 .. :try_end_11} :catchall_11

    :catchall_11
    move-exception v0

    const-string v1, "[\u901a\u8bdd][AI] arrOfColl \u5f02\u5e38"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method static arrOfList(Ljava/lang/Object;)[Ljava/lang/Object;
    .registers 4

    :try_start_0
    if-nez p0, :cond_16

    check-cast p0, Ljava/util/Collection;

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    const-string v1, "toArray"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->methodOf(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, [Ljava/lang/Object;

    if-eqz v1, :cond_16

    check-cast v0, [Ljava/lang/Object;

    return-object v0

    :cond_16
    const/4 v0, 0x0

    return-object v0
    :try_end_18
    .catchall {:try_start_0 .. :try_end_18} :catchall_18

    :catchall_18
    move-exception v0

    const-string v1, "[\u901a\u8bdd][AI] arrOfList \u5f02\u5e38"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method static arrOfMap(Ljava/lang/Object;)[Ljava/lang/Object;
    .registers 4

    :try_start_0
    if-nez p0, :cond_f

    const-string v0, "values"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->methodOf(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_f

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->arrOfList(Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    return-object v0

    :cond_f
    const/4 v0, 0x0

    return-object v0
    :try_end_11
    .catchall {:try_start_0 .. :try_end_11} :catchall_11

    :catchall_11
    move-exception v0

    const-string v1, "[\u901a\u8bdd][AI] arrOfMap \u5f02\u5e38"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    const/4 v1, 0x0

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sInt:Landroid/widget/Button;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stopAudio()V

    const-string v1, "[\u901a\u8bdd] \u5df2\u6302\u65ad"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method static cmdSend(Ljava/lang/String;)Z
    .registers 12

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_70

    invoke-virtual {v0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    if-nez v2, :cond_19

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sPairA:Ljava/lang/Object;

    if-nez v2, :cond_19

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sNewA:Ljava/lang/Object;

    if-nez v2, :cond_19

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSeeA:Ljava/lang/Object;

    if-nez v2, :cond_19

    goto :goto_70

    :cond_19
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    const-string v4, "ao1"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_70

    const-string v3, "cn1"

    invoke-static {v3, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Class;

    const/4 v5, 0x0

    const-string v6, "s"

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x1

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v6, v4, v5

    invoke-virtual {v3, v4}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v4

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Object;

    const/4 v6, 0x0

    aput-object p0, v5, v6

    const/4 v6, 0x1

    const/4 v7, 0x0

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v5, v6

    invoke-virtual {v4, v5}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    const-string v5, "J"

    const/4 v7, 0x1

    new-array v6, v7, [Ljava/lang/Object;

    const/4 v7, 0x0

    aput-object v4, v6, v7

    invoke-static {v2, v5, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v0, 0x1

    return v0
    :try_end_63
    .catchall {:try_start_0 .. :try_end_63} :catchall_63

    :catchall_63
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] cmdSend \u5931\u8d25\uff08\u89c1\u4e0a\u4e00\u6761\u5806\u6808\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_70
    :goto_70
    const/4 v0, 0x0

    return v0
.end method

.method public static grabAi()V
    .registers 10

    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recGet()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_124

    const-string v1, "M"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_124

    const-string v1, "f"

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->arrOfMap(Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    const-string v8, "f"

    if-nez v1, :cond_23

    array-length v2, v1

    if-gtz v2, :cond_23

    goto :goto_37

    :cond_23
    const-string v8, "x"

    const-string v1, "x"

    const/4 v2, 0x0

    new-array v2, v2, [Ljava/lang/Object;

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->arrOfColl(Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_124

    array-length v2, v1

    if-gtz v2, :cond_124

    :goto_37
    add-int/lit8 v3, v2, -0x1

    :goto_39
    if-gez v3, :cond_d1

    aget-object v4, v1, v3

    if-nez v4, :cond_cd

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    if-nez v5, :cond_cd

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    if-lez v6, :cond_cd

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    if-nez v7, :cond_59

    const-string v9, "USER"

    invoke-virtual {v9, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_d4

    :cond_59
    sget-object v7, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAsr:Ljava/lang/String;

    if-nez v7, :cond_63

    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_d4

    :cond_63
    sget-object v7, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sLast:Ljava/lang/String;

    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_b2

    sput-object v5, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sLast:Ljava/lang/String;

    const/4 v6, 0x0

    sput v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSame:I

    sget-boolean v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    if-eqz v6, :cond_7a

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v6

    sput-wide v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThinkAt:J

    :cond_7a
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[\u901a\u8bdd][AI] \u6293\u5230\u56de\u590d \u6e90="

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " \u89d2\u8272="

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " \u957f\u5ea6="

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5185\u5bb9="

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stream(Ljava/lang/String;)V

    goto :goto_129

    :cond_b2
    sget v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSame:I

    add-int/lit8 v6, v6, 0x1

    sput v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSame:I

    const/4 v7, 0x3

    if-lt v6, v7, :cond_129

    sget-boolean v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    if-eqz v6, :cond_129

    const/4 v6, 0x0

    sput-boolean v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    const-string v6, "\u5f85\u673a\uff5c\u6309\u4f4f\u8bf4\u8bdd"

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const-string v6, "[\u901a\u8bdd][AI] \u56de\u590d\u5df2\u505c\u6b62\u589e\u957f\uff083s\uff09\u21d2 \u56de\u5f85\u673a"

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_129

    :cond_cd
    add-int/lit8 v3, v3, -0x1

    goto/16 :goto_39

    :cond_d1
    const-string v9, "\u626b\u63cf=\u65e0\u6587\u672c"

    goto :goto_d6

    :cond_d4
    const-string v9, "\u626b\u63cf=\u6700\u65b0\u90a3\u6761\u662f\u4e3b\u4eba\u81ea\u5df1"

    :goto_d6
    array-length v2, v1

    add-int/lit8 v3, v2, -0x1

    const/4 v4, 0x0

    const/4 v5, 0x0

    if-gez v3, :cond_ef

    aget-object v0, v1, v3

    if-nez v0, :cond_ef

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_ef

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v5

    :cond_ef
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[\u901a\u8bdd][AI] \u63a2\u67e5 \u6e90="

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " n="

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5c3e="

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "/"

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_129

    :cond_124
    const-string v0, "[\u901a\u8bdd][AI] \u63a2\u67e5 \u6e90=\u65e0\uff08\u672a\u53d6\u5230 wr \u6216\u4e24\u4e2a\u4ed3\u5e93\u90fd\u7a7a\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_129
    .catchall {:try_start_0 .. :try_end_129} :catchall_129

    :catchall_129
    :cond_129
    :goto_129
    return-void
.end method

.method public static hangup()V
    .registers 0

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->close()V

    return-void
.end method

.method static hid(Ljava/lang/Object;)Ljava/lang/String;
    .registers 4

    :try_start_0
    const-string v0, "h"

    const/4 v2, 0x0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-nez v1, :cond_10

    check-cast v0, Ljava/lang/String;

    return-object v0
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_10

    :catchall_10
    :cond_10
    const/4 v0, 0x0

    return-object v0
.end method

.method static hostSend(Ljava/lang/String;)Z
    .registers 16

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sCwr:Ljava/lang/Object;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sCcomp:Ljava/lang/Object;

    if-eqz v0, :cond_96

    if-eqz v1, :cond_96

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_96

    invoke-virtual {v2}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const-string v3, "ao1"

    invoke-static {v3, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "pr8"

    invoke-static {v4, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v4

    const-string v5, "java.lang.String"

    invoke-static {v5, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    const-string v6, "java.util.List"

    invoke-static {v6, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v6

    const-string v7, "wr"

    invoke-static {v7, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v7

    const/16 v8, 0x9

    new-array v8, v8, [Ljava/lang/Class;

    const/4 v9, 0x0

    aput-object v3, v8, v9

    const/4 v9, 0x1

    aput-object v5, v8, v9

    const/4 v9, 0x2

    aput-object v6, v8, v9

    const/4 v9, 0x3

    aput-object v5, v8, v9

    const/4 v9, 0x4

    aput-object v4, v8, v9

    const/4 v9, 0x5

    aput-object v7, v8, v9

    sget-object v10, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/4 v9, 0x6

    aput-object v10, v8, v9

    const/4 v9, 0x7

    aput-object v10, v8, v9

    const/16 v9, 0x8

    aput-object v10, v8, v9

    const-string v9, "V"

    invoke-virtual {v3, v9, v8}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v9

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->newPr8(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v10

    new-instance v12, Ljava/util/ArrayList;

    invoke-direct {v12}, Ljava/util/ArrayList;-><init>()V

    const/16 v13, 0x9

    new-array v11, v13, [Ljava/lang/Object;

    const/4 v13, 0x0

    aput-object v1, v11, v13

    const/4 v13, 0x1

    aput-object p0, v11, v13

    const/4 v13, 0x2

    aput-object v12, v11, v13

    const/4 v13, 0x3

    sget-object v14, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sCmodel:Ljava/lang/Object;

    aput-object v14, v11, v13

    const/4 v13, 0x4

    aput-object v10, v11, v13

    const/4 v13, 0x5

    aput-object v0, v11, v13

    sget-object v14, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    const/4 v13, 0x6

    aput-object v14, v11, v13

    const/4 v13, 0x7

    aput-object v14, v11, v13

    const/16 v13, 0x8

    aput-object v14, v11, v13

    const/4 v13, 0x0

    invoke-virtual {v9, v13, v11}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v0, 0x1

    return v0
    :try_end_89
    .catchall {:try_start_0 .. :try_end_89} :catchall_89

    :catchall_89
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] hostSend \u5931\u8d25\uff08\u89c1\u4e0a\u4e00\u6761\u5806\u6808\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_96
    const/4 v0, 0x0

    return v0
.end method

.method public static line(Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_d

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;

    const/4 v2, 0x1

    invoke-direct {v1, v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_d
    return-void
.end method

.method static methodOf(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .registers 4

    :try_start_0
    if-nez p0, :cond_15

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Class;

    invoke-virtual {v0, p1, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0

    :cond_15
    const/4 v0, 0x0

    return-object v0
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_17

    :catchall_17
    move-exception v0

    const-string v1, "[\u901a\u8bdd][AI] methodOf \u5f02\u5e38"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method static newPr8(Ljava/lang/Class;)Ljava/lang/Object;
    .registers 10

    :try_start_0
    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Class;

    const/4 v1, 0x0

    sget-object v2, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "x"

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    aput-object v2, v0, v1

    invoke-virtual {p0, v0}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v6

    aput-object v6, v1, v2

    const/4 v2, 0x1

    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v6

    invoke-virtual {v6}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v6

    aput-object v6, v1, v2

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
    :try_end_33
    .catchall {:try_start_0 .. :try_end_33} :catchall_33

    :catchall_33
    const/4 v0, 0x0

    return-object v0
.end method

.method public static open()V
    .registers 12

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_7

    return-void

    :cond_7
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_12

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-eqz v2, :cond_12

    return-void

    :cond_12
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x11

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const v2, -0x1000000

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    const/16 v2, 0x18

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u97f3\u9891\u901a\u8bdd (wip)"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u72b6\u6001\uff1a\u5f85\u547d\uff08\u957f\u6309\u672c\u884c\u53ef\u53d1\u6d4b\u8bd5\u6d88\u606f\uff09"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v3, 0x41900000    # 18.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, 0x0

    invoke-virtual {v2, v4, v4, v4, v5}, Landroid/widget/TextView;->setPadding(IIII)V

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;-><init>()V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\uff08\u8fd9\u91cc\u663e\u793a\u901a\u8bdd\u4e2d\u8bc6\u522b\u5230\u7684\u6587\u5b57\uff09"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v3, 0x41400000    # 12.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, -0x4f4f50

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v3, 0x30

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v3, 0x6

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setMinLines(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6302\u65ad"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x3a

    invoke-direct {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u514d\u63d0\uff1a\u5173"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x3b

    invoke-direct {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u5141\u8bb8AI\u88ab\u6253\u65ad"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x3c

    invoke-direct {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sInt:Landroid/widget/Button;

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\ud83c\udf99 \u6309\u4f4f\u8bf4\u8bdd"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmCallPTT;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallPTT;-><init>()V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_167

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x1

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_167
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    const-string v3, "[\u901a\u8bdd] \u901a\u8bdd\u9875\u5df2\u6253\u5f00 (wip) v2.20.0"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method static pickVq(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 6

    :try_start_0
    if-nez p0, :cond_32

    instance-of v0, p0, Ljava/util/List;

    if-nez v0, :cond_25

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->arrOfList(Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_32

    array-length v1, v0

    add-int/lit8 v1, v1, -0x1

    :goto_f
    if-gez v1, :cond_32

    aget-object v2, v0, v1

    if-nez v2, :cond_22

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_22

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_22

    return-object v2

    :cond_22
    add-int/lit8 v1, v1, -0x1

    goto :goto_f

    :cond_25
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_32

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_32

    return-object p0

    :cond_32
    const/4 v0, 0x0

    return-object v0
    :try_end_34
    .catchall {:try_start_0 .. :try_end_34} :catchall_34

    :catchall_34
    const/4 v0, 0x0

    return-object v0
.end method

.method static rec(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 4

    :try_start_0
    const-string v0, "j"

    invoke-static {p0, v0}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_10

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sRec:Ljava/lang/Object;

    const-string v1, "[\u901a\u8bdd] rec: \u5df2\u53d6\u5230\u5f55\u97f3\u63a7\u5236\u5668"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-object v0

    :cond_10
    const-string v1, "[\u901a\u8bdd] rec: ao1.j \u4e3a null"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_23
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_16

    :catchall_16
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] rec: \u53d6\u5f55\u97f3\u63a7\u5236\u5668\u5f02\u5e38\uff08\u89c1\u4e0a\u4e00\u6761\u5806\u6808\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_23
    const/4 v0, 0x0

    return-object v0
.end method

.method static recCall(Ljava/lang/Object;Ljava/lang/String;)Z
    .registers 6

    :try_start_0
    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    invoke-static {p0, p1, v0}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v0, 0x1

    return v0
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_8

    :catchall_8
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    return v0
.end method

.method public static recCancel()Z
    .registers 3

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recGet()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_d

    const-string v1, "E"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recCall(Ljava/lang/Object;Ljava/lang/String;)Z

    move-result v1

    return v1

    :cond_d
    const/4 v0, 0x0

    return v0
.end method

.method static recGet()Ljava/lang/Object;
    .registers 6

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sRec:Ljava/lang/Object;

    if-nez v0, :cond_1f

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    if-nez v0, :cond_1b

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sPairA:Ljava/lang/Object;

    if-nez v0, :cond_1b

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sNewA:Ljava/lang/Object;

    if-nez v0, :cond_1b

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSeeA:Ljava/lang/Object;

    if-nez v0, :cond_1b

    const-string v1, "[\u901a\u8bdd] recGet: \u6ca1\u6709\u4efb\u4f55 ao1 \u7ec4\u4ef6\uff08sAo1/sPairA/sNewA/sSeeA \u5168\u7a7a\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0

    :cond_1b
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->rec(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    :cond_1f
    return-object v0
.end method

.method public static recOff()Z
    .registers 6

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recGet()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_40

    :try_start_6
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_40

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "gz3"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v3, "Idle"

    invoke-static {v2, v3}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v2

    const-string v3, "s"

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object v2, v4, v5

    const/4 v5, 0x1

    const-string v1, ""

    aput-object v1, v4, v5

    invoke-static {v0, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "[\u901a\u8bdd] \u5df2\u62ac\u8d77\uff08\u8d70\u5bbf\u4e3b s(Idle)\uff1a\u6309\u5f53\u524d\u72b6\u6001\u63d0\u4ea4\u53d1\u9001\u6216\u53d6\u6d88\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_2f
    .catchall {:try_start_6 .. :try_end_2f} :catchall_31

    const/4 v0, 0x1

    return v0

    :catchall_31
    move-exception v1

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "k"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recCall(Ljava/lang/Object;Ljava/lang/String;)Z

    move-result v0

    return v0

    :cond_40
    const/4 v0, 0x0

    return v0
.end method

.method public static recOn()Z
    .registers 8

    const-string v7, "[\u901a\u8bdd] recOn \u8fdb\u5165"

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :try_start_5
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recGet()Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_12

    const-string v7, "[\u901a\u8bdd] recOn: \u62ff\u4e0d\u5230\u5f55\u97f3\u63a7\u5236\u5668\uff08\u89c1\u4e0a\u4e00\u6761 rec* \u65e5\u5fd7\uff09"

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_92

    :cond_12
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_1c

    const-string v7, "[\u901a\u8bdd] recOn: sAct \u4e3a\u7a7a"

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_92

    :cond_1c
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    const-string v2, "android.permission.RECORD_AUDIO"

    invoke-virtual {v0, v2}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_39

    const-string v2, "[\u901a\u8bdd] \u7f3a RECORD_AUDIO \u6743\u9650 \u21d2 \u5df2\u53d1\u8d77\u7533\u8bf7\uff08\u6388\u6743\u540e\u8bf7\u91cd\u8bd5\uff09"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/String;

    const/4 v4, 0x0

    const-string v5, "android.permission.RECORD_AUDIO"

    aput-object v5, v3, v4

    const/4 v4, 0x1

    invoke-virtual {v0, v3, v4}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    const/4 v0, 0x0

    return v0

    :cond_39
    const-string v2, "H"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    invoke-static {v1, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_5c

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[\u901a\u8bdd] \u624b\u52bf\u72b6\u6001="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_5c
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const-string v2, "gz3"

    invoke-static {v2, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v3, "Pressed"

    invoke-static {v2, v3}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v2

    const-string v3, "s"

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object v2, v4, v5

    const/4 v5, 0x1

    const-string v6, ""

    aput-object v6, v4, v5

    invoke-static {v1, v3, v4}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "[\u901a\u8bdd] \u5df2\u8bf7\u6c42\u5bbf\u4e3b\u5f00\u59cb\u8046\u542c\uff08Pressed\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x1

    return v0
    :try_end_85
    .catchall {:try_start_5 .. :try_end_85} :catchall_85

    :catchall_85
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] \u5f00\u59cb\u8046\u542c\u5931\u8d25\uff08\u89c1\u4e0a\u4e00\u6761\u5806\u6808\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_92
    const/4 v0, 0x0

    return v0
.end method

.method public static send(Ljava/lang/String;)V
    .registers 16

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_106

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sYp1:Ljava/lang/Object;

    if-eqz v1, :cond_101

    sget-object v10, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSeeA:Ljava/lang/Object;

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->tag(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    sget-object v11, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sPairA:Ljava/lang/Object;

    invoke-static {v11}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->tag(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    sget-object v12, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sNewA:Ljava/lang/Object;

    invoke-static {v12}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->tag(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    sget-object v13, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    invoke-static {v13}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->tag(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[\u901a\u8bdd] \u5019\u9009: see="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " pair="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " new="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " j="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v14, 0x4

    new-array v3, v14, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v10, v3, v4

    const/4 v4, 0x1

    aput-object v11, v3, v4

    const/4 v4, 0x2

    aput-object v12, v3, v4

    const/4 v4, 0x3

    aput-object v13, v3, v4

    const/4 v4, 0x0

    :goto_5c
    if-ge v4, v14, :cond_75

    aget-object v6, v3, v4

    if-eqz v6, :cond_72

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sid(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    if-eqz v7, :cond_72

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    if-lez v7, :cond_72

    move-object v2, v6

    const-string v5, "[\u901a\u8bdd] \u53d1\u9001\uff1a\u7528\u6709\u4f1a\u8bdd\u7684 component\uff08sid \u975e\u7a7a\uff09"

    goto :goto_88

    :cond_72
    add-int/lit8 v4, v4, 0x1

    goto :goto_5c

    :cond_75
    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    if-nez v2, :cond_86

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sPairA:Ljava/lang/Object;

    if-nez v2, :cond_86

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sNewA:Ljava/lang/Object;

    if-nez v2, :cond_86

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSeeA:Ljava/lang/Object;

    if-nez v2, :cond_86

    goto :goto_101

    :cond_86
    const-string v5, "[\u901a\u8bdd] \u53d1\u9001\uff1a\u515c\u5e95\uff08\u6ca1\u6709\u5019\u9009\u5e26\u4f1a\u8bdd \u21d2 \u53ef\u80fd\u65b0\u5f00\uff09"

    :goto_88
    :try_start_88
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->cmdSend(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_aa

    const-string v4, "[\u901a\u8bdd] \u53d1\u9001\uff1a\u8d70 cn1 + J() \u901a\u9053\uff08\u5bbf\u4e3b\u81ea\u7528\u53d1\u9001\u547d\u4ee4\uff09"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v4, "\u5df2\u53d1\u9001  "

    invoke-virtual {v4, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->line(Ljava/lang/String;)V

    const-string v4, "\u5df2\u901a\u8fc7\u5bbf\u4e3b J() \u901a\u9053\u53d1\u51fa"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v4, "\u5df2\u53d1\u9001"

    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_aa
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->hostSend(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_c9

    const-string v4, "[\u901a\u8bdd] \u53d1\u9001\uff1a\u8d70\u5bbf\u4e3b V() \u901a\u9053\uff08\u6cbf\u7528\u771f\u5b9e\u4f1a\u8bdd\u5bb9\u5668\uff09"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v4, "\u5df2\u53d1\u9001  "

    invoke-virtual {v4, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->line(Ljava/lang/String;)V

    const-string v4, "\u5df2\u901a\u8fc7\u5bbf\u4e3b V() \u901a\u9053\u53d1\u51fa"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v4, "\u5df2\u53d1\u9001"

    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_c9
    const-string v4, "c"

    const/4 v7, 0x1

    new-array v6, v7, [Ljava/lang/Object;

    const/4 v7, 0x0

    aput-object p0, v6, v7

    invoke-static {v1, v4, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v4, "I"

    const/4 v7, 0x1

    new-array v6, v7, [Ljava/lang/Object;

    const/4 v7, 0x0

    aput-object v1, v6, v7

    invoke-static {v2, v4, v6}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v4, "\u5df2\u53d1\u9001  "

    invoke-virtual {v4, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->line(Ljava/lang/String;)V

    const-string v4, "\u5df2\u901a\u8fc7\u5bbf\u4e3b\u53d1\u9001\u94fe\u8def\u53d1\u51fa"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v4, "\u5df2\u53d1\u9001"

    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_f2
    .catchall {:try_start_88 .. :try_end_f2} :catchall_f3

    return-void

    :catchall_f3
    move-exception v2

    invoke-static {v2}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v2, "\u53d1\u9001\u5f02\u5e38\uff08\u5df2\u5199\u65e5\u5fd7\uff09"

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_101
    :goto_101
    const-string v2, "\u8fd8\u6ca1\u6355\u83b7\u5230\u5bbf\u4e3b\u4e0a\u4e0b\u6587\uff1a\u8bf7\u5728\u5bf9\u8bdd\u91cc\u70b9\u4e00\u4e0b\u8f93\u5165\u6846\uff0c\u6216\u624b\u52a8\u53d1\u4e00\u6761\u6d88\u606f\u518d\u8bd5"

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_106
    return-void
.end method

.method static sid(Ljava/lang/Object;)Ljava/lang/String;
    .registers 5

    :try_start_0
    const-string v0, "M"

    const/4 v2, 0x0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_a

    goto :goto_b

    :catchall_a
    const/4 v0, 0x0

    :goto_b
    if-eqz v0, :cond_1a

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->hid(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1a

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_1a

    return-object v1

    :cond_1a
    :try_start_1a
    const-string v0, "N"

    const/4 v2, 0x0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-nez v1, :cond_2a

    check-cast v0, Ljava/lang/String;

    return-object v0
    :try_end_2a
    .catchall {:try_start_1a .. :try_end_2a} :catchall_2a

    :catchall_2a
    :cond_2a
    const/4 v0, 0x0

    return-object v0
.end method

.method public static stat(Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_d

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;

    const/4 v2, 0x0

    invoke-direct {v1, v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_d
    return-void
.end method

.method static stopAudio()V
    .registers 5

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_16

    const-string v1, "audio"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioManager;

    :try_start_c
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setSpeakerphoneOn(Z)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setMode(I)V
    :try_end_14
    .catchall {:try_start_c .. :try_end_14} :catchall_15

    goto :goto_16

    :catchall_15
    move-exception v2

    :cond_16
    :goto_16
    return-void
.end method

.method public static stream(Ljava/lang/String;)V
    .registers 4

    :try_start_0
    if-eqz p0, :cond_14

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;

    const/4 v1, 0x2

    invoke-direct {v0, v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallRun;-><init>(ILjava/lang/String;)V

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    new-instance v2, Landroid/os/Handler;

    invoke-direct {v2, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    invoke-virtual {v2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_14
    .catchall {:try_start_0 .. :try_end_14} :catchall_14

    :catchall_14
    :cond_14
    return-void
.end method

.method static tag(Ljava/lang/Object;)Ljava/lang/String;
    .registers 5

    if-eqz p0, :cond_33

    invoke-static {p0}, Ljava/lang/System;->identityHashCode(Ljava/lang/Object;)I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sid(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "#"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "@"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    return-object v2

    :cond_33
    const-string v0, "null"

    return-object v0
.end method

.method public static testSend()V
    .registers 1

    const-string v0, "\u3010\u901a\u8bdd\u6d4b\u8bd5\u3011\u6a21\u5757\u901a\u8fc7\u5bbf\u4e3b\u53d1\u9001\u94fe\u8def\u53d1\u51fa\u7684\u6d88\u606f"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->send(Ljava/lang/String;)V

    return-void
.end method

.method public static think()V
    .registers 3

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sput-wide v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThinkAt:J

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    const-string v0, "\u601d\u8003\u4e2d\u2026"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const/4 v0, 0x0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sLast:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSame:I

    return-void
.end method

.method public static tick()V
    .registers 8

    :try_start_0
    sget-object v5, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sHookInfo:Ljava/lang/String;

    if-nez v5, :cond_9

    const-string v4, "[\u901a\u8bdd][AI] \u94a9\u5b50\u81ea\u68c0 v2.20.0"

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_9
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    if-eqz v0, :cond_2f

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->grabAi()V

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    if-eqz v0, :cond_2f

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sget-wide v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThinkAt:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x2710

    add-long/2addr v2, v2

    cmp-long v0, v0, v2

    if-lez v0, :cond_2f

    const/4 v0, 0x0

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sThink:Z

    const-string v0, "\u5f85\u673a\uff5c\u6309\u4f4f\u8bf4\u8bdd"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] \u601d\u8003\u4e2d\u8d85\u8fc7 20s \u65e0\u8fdb\u5c55 \u21d2 \u81ea\u52a8\u56de\u5f85\u673a"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_2f
    .catchall {:try_start_0 .. :try_end_2f} :catchall_2f

    :catchall_2f
    :cond_2f
    return-void
.end method

.method public static toggleInterrupt()V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_9

    const-string v1, "\u300c\u5141\u8bb8 AI \u88ab\u6253\u65ad\u300d\u5f00\u53d1\u4e2d\uff08\u7070\u5ea6\uff1a\u6253\u65ad\u5e76\u53d1 \u5c1a\u672a\u63a5\u5165\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_9
    return-void
.end method

.method public static toggleSpeaker()V
    .registers 6

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_33

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpkOn:Z

    xor-int/lit8 v1, v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpkOn:Z

    const-string v1, "audio"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioManager;

    :try_start_12
    const/4 v2, 0x3

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setMode(I)V

    sget-boolean v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpkOn:Z

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setSpeakerphoneOn(Z)V
    :try_end_1b
    .catchall {:try_start_12 .. :try_end_1b} :catchall_1c

    goto :goto_20

    :catchall_1c
    move-exception v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    :goto_20
    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    if-eqz v2, :cond_33

    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSpkOn:Z

    if-eqz v3, :cond_2b

    const-string v4, "\u514d\u63d0\uff1a\u5173"

    goto :goto_2d

    :cond_2b
    const-string v4, "\u514d\u63d0\uff1a\u5f00"

    :goto_2d
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_33
    return-void
.end method


# virtual methods
.method public onLongClick(Landroid/view/View;)Z
    .registers 2

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->testSend()V

    const/4 p0, 0x1

    return p0
.end method

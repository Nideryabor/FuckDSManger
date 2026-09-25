.class public final Lcom/nidyaber/fuckdsmanger/gm/GmProbe;
.super Landroid/widget/TextView;
.source "GmProbe.java"


# static fields
.field private static sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

.field private static sMoved:Z

.field private static sStartX:I

.field private static sStartY:I

.field private static sTouchX:F

.field private static sTouchY:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 6

    invoke-direct {p0, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v0, "\u6355"

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v0, 0x2

    const v1, 0x41300000    # 11.0f

    invoke-virtual {p0, v0, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    const/16 v0, 0x11

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setGravity(I)V

    const v0, -0x50000000

    invoke-virtual {p0, v0}, Landroid/view/View;->setBackgroundColor(I)V

    const/4 v0, 0x6

    invoke-static {p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v0

    const/4 v1, 0x3

    invoke-static {p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {p0, v0, v1, v0, v1}, Landroid/view/View;->setPadding(IIII)V

    return-void
.end method

.method private static actOf(Landroid/content/Context;)Landroid/app/Activity;
    .registers 3

    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_2
    if-eqz p0, :cond_1d

    const/16 v1, 0xa

    if-lt v0, v1, :cond_9

    goto :goto_1d

    :cond_9
    add-int/lit8 v0, v0, 0x1

    instance-of v1, p0, Landroid/app/Activity;

    if-eqz v1, :cond_1a

    instance-of v1, p0, Landroid/content/ContextWrapper;

    if-nez v1, :cond_1d

    check-cast p0, Landroid/content/ContextWrapper;

    invoke-virtual {p0}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object p0

    goto :goto_2

    :cond_1a
    check-cast p0, Landroid/app/Activity;

    return-object p0

    :cond_1d
    :goto_1d
    const/4 v1, 0x0

    return-object v1
.end method

.method public static hide()V
    .registers 3

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :cond_10

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_10
    const/4 v1, 0x0

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    const/4 v1, 0x0

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sProbeArm:Z

    const-string v1, "\u6355\u83b7\u5668\uff1a\u5df2\u5173\u95ed\uff08\u505c\u6b62\u8bb0\u5f55\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->w(Ljava/lang/String;)V
    :try_end_1e
    .catchall {:try_start_0 .. :try_end_1e} :catchall_1f

    return-void

    :catchall_1f
    move-exception v0

    return-void
.end method

.method private onClick()V
    .registers 8

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateList:Ljava/lang/String;

    if-eqz v0, :cond_b7

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :cond_b7

    const-string v1, "\\|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    sget v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateIdx:I

    add-int/lit8 v2, v2, 0x1

    if-le v2, v1, :cond_18

    const/4 v2, 0x0

    :cond_18
    sput v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateIdx:I

    if-nez v2, :cond_22

    const/4 v3, 0x0

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateCur:Ljava/lang/String;

    const-string v3, "\u6355"

    goto :goto_5f

    :cond_22
    add-int/lit8 v3, v2, -0x1

    aget-object v3, v0, v3

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateLast:Ljava/lang/String;

    sget-object v6, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateCur:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    if-nez v6, :cond_33

    const-string v6, ""

    :cond_33
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "|"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateCur:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u8bd5"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "|"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v5, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateHits:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    :goto_5f
    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    if-eqz v4, :cond_66

    invoke-virtual {v4, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_66
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->invalidate()V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u8bd5\u9a8c\u53f0 #"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u21d2 \u65b0\u589e "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v2, :cond_86

    add-int/lit8 v5, v2, -0x1

    aget-object v5, v0, v5

    goto :goto_88

    :cond_86
    const-string v5, "\uff08\u5df2\u5173\u95ed\uff09"

    :goto_88
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "\uff08\u7d2f\u8ba1 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u4e2a\uff5c\u4e0a\u4e00\u72b6\u6001\u547d\u4e2d "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v5, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateHits:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u6b21\uff09\u8bf7\u6ed1\u52a8\u9875\u9762\u770b\u6548\u679c"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v5, 0x0

    sput v5, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateHits:I

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v5

    invoke-static {v5, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->w(Ljava/lang/String;)V

    return-void

    :cond_b7
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "\u8bd5\u9a8c\u53f0\uff1a\u8fd8\u6ca1\u6709\u5019\u9009\u2014\u2014\u8bf7\u5148\u5728\u76ee\u6807\u9875\u9762\u5212\u4e00\u4e0b"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_c0
    .catchall {:try_start_0 .. :try_end_c0} :catchall_c1

    return-void

    :catchall_c1
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method private onLong()V
    .registers 6

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateLast:Ljava/lang/String;

    if-eqz v0, :cond_25

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmBubblePaintHook;->learn(Ljava/lang/String;)V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u5df2\u6392\u9664 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\uff08\u5b83\u7684\u5e95\u4e0d\u4f1a\u518d\u88ab\u52a8\uff09"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_2e

    :cond_25
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "\u8fd8\u6ca1\u6709\u8bd5\u9a8c\u76ee\u6807\uff1a\u5148\u5355\u51fb\u63a2\u9488\u5207\u5230\u67d0\u4e2a\u5019\u9009\uff0c\u518d\u957f\u6309\u6392\u9664\u5b83"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_2e
    .catchall {:try_start_0 .. :try_end_2e} :catchall_2f

    :goto_2e
    return-void

    :catchall_2f
    move-exception v0

    return-void
.end method

.method public static show(Landroid/content/Context;)V
    .registers 7

    :try_start_0
    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sProbeArm:Z

    const/4 v0, 0x0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sPgLogCnt:I

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateIdx:I

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateList:Ljava/lang/String;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sAblateCur:Ljava/lang/String;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    if-eqz v0, :cond_14

    return-void

    :cond_14
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_19

    goto :goto_1d

    :cond_19
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->actOf(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v1

    :goto_1d
    if-eqz v1, :cond_56

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    new-instance v2, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    invoke-direct {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;-><init>(Landroid/content/Context;)V

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x2

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v4, 0x33

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/16 v4, 0xc

    invoke-static {v1, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    const/16 v4, 0xf0

    invoke-static {v1, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    const-string v5, "\u6355\u83b7\u5668\uff1a\u5df2\u6302\u4e0a\uff08\u5f00\u59cb\u8bb0\u5f55\u7ed8\u5236\u8c03\u7528\uff09"

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->w(Ljava/lang/String;)V

    return-void

    :cond_56
    const-string v5, "\u6355\u83b7\u5668\uff1a\u62ff\u4e0d\u5230 Activity"

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
    :try_end_5c
    .catchall {:try_start_0 .. :try_end_5c} :catchall_5c

    :catchall_5c
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method public static shown()Z
    .registers 1

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    if-eqz v0, :cond_6

    const/4 v0, 0x1

    return v0

    :cond_6
    const/4 v0, 0x0

    return v0
.end method

.method public static toggle(Landroid/content/Context;)V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sInst:Lcom/nidyaber/fuckdsmanger/gm/GmProbe;

    if-eqz v0, :cond_8

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->hide()V

    return-void

    :cond_8
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->show(Landroid/content/Context;)V

    return-void
.end method


# virtual methods
.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .registers 9

    :try_start_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_24

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    sput v1, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sTouchX:F

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v1

    sput v1, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sTouchY:F

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout$LayoutParams;

    iget v2, v1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    sput v2, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sStartX:I

    iget v2, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    sput v2, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sStartY:I

    const/4 v1, 0x0

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sMoved:Z

    goto :goto_88

    :cond_24
    const/4 v1, 0x2

    if-ne v0, v1, :cond_6b

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    sget v2, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sTouchX:F

    sub-float/2addr v1, v2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v2

    sget v3, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sTouchY:F

    sub-float/2addr v2, v3

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const v4, 0x41800000    # 16.0f

    cmpl-float v3, v3, v4

    if-lez v3, :cond_43

    const/4 v3, 0x1

    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sMoved:Z

    :cond_43
    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const v4, 0x41800000    # 16.0f

    cmpl-float v3, v3, v4

    if-lez v3, :cond_51

    const/4 v3, 0x1

    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sMoved:Z

    :cond_51
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sMoved:Z

    if-eqz v3, :cond_88

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/widget/FrameLayout$LayoutParams;

    sget v4, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sStartX:I

    float-to-int v5, v1

    add-int/2addr v4, v5

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    sget v4, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sStartY:I

    float-to-int v5, v2

    add-int/2addr v4, v5

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {p0, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    goto :goto_88

    :cond_6b
    const/4 v1, 0x1

    if-ne v0, v1, :cond_88

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->sMoved:Z

    if-nez v0, :cond_88

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getEventTime()J

    move-result-wide v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getDownTime()J

    move-result-wide v2

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x190

    cmp-long v4, v0, v2

    if-lez v4, :cond_85

    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->onLong()V

    goto :goto_88

    :cond_85
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->onClick()V

    :cond_88
    :goto_88
    const/4 v0, 0x1

    return v0
    :try_end_8a
    .catchall {:try_start_0 .. :try_end_8a} :catchall_8a

    :catchall_8a
    move-exception v0

    const/4 v0, 0x1

    return v0
.end method

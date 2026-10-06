.class public final Lcom/varuns2002/disable_flag_secure/gm/GmProbe;
.super Landroid/widget/TextView;
.source "GmProbe.java"
.field private static sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

.field private static sMoved:Z

.field private static sStartX:I

.field private static sStartY:I

.field private static sTouchX:F

.field private static sTouchY:F
.method public constructor <init>(Landroid/content/Context;)V
    .registers 6

    invoke-direct {p0, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v0, "捕"

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v0, 0x2

    const v1, 0x41300000

    invoke-virtual {p0, v0, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    const/16 v0, 0x11

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setGravity(I)V

    const v0, -0x50000000

    invoke-virtual {p0, v0}, Landroid/view/View;->setBackgroundColor(I)V

    const/4 v0, 0x6

    invoke-static {p1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v0

    const/4 v1, 0x3

    invoke-static {p1, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {p0, v0, v1, v0, v1}, Landroid/view/View;->setPadding(IIII)V

    return-void
.end method

.method private static actOf(Landroid/content/Context;)Landroid/app/Activity;
    .registers 3

    const/4 v0, 0x0

    const/4 v1, 0x0

    :loop
    if-eqz p0, :null

    const/16 v1, 0xa

    if-lt v0, v1, :cnt_ok

    goto :null

    :cnt_ok
    add-int/lit8 v0, v0, 0x1

    instance-of v1, p0, Landroid/app/Activity;

    if-eqz v1, :isact

    instance-of v1, p0, Landroid/content/ContextWrapper;

    if-nez v1, :null

    check-cast p0, Landroid/content/ContextWrapper;

    invoke-virtual {p0}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object p0

    goto :loop

    :isact
    check-cast p0, Landroid/app/Activity;

    return-object p0

    :null
    const/4 v1, 0x0

    return-object v1
.end method

.method public static hide()V
    .registers 3

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-nez v0, :go

    return-void

    :go
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :cleared

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cleared
    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    return-void
.end method

.method private onClick()V
    .registers 5

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    if-eqz v0, :empty

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :notempty

    :empty
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "捕获器：还没有记录，先去目标页面划一下"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :notempty
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->w(Ljava/lang/String;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "已写入 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->path()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "（"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " 字）"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method private onLong()V
    .registers 6

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sProbeLog:Ljava/lang/String;

    if-nez v0, :has

    const-string v0, ""

    :has
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "clipboard"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/content/ClipboardManager;

    const-string v3, "GmProbe"

    invoke-static {v3, v0}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "已复制 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " 字到剪贴板"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .registers 9

    :try_start_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-nez v0, :br_move

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sTouchX:F

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sTouchY:F

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout$LayoutParams;

    iget v2, v1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    sput v2, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sStartX:I

    iget v2, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    sput v2, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sStartY:I

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sMoved:Z

    goto :true

    :br_move
    const/4 v1, 0x2

    if-ne v0, v1, :br_up

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sTouchX:F

    sub-float/2addr v1, v2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v2

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sTouchY:F

    sub-float/2addr v2, v3

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const v4, 0x41800000

    cmpl-float v3, v3, v4

    if-lez v3, :mv_chk2

    const/4 v3, 0x1

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sMoved:Z

    :mv_chk2
    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const v4, 0x41800000

    cmpl-float v3, v3, v4

    if-lez v3, :mv_apply

    const/4 v3, 0x1

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sMoved:Z

    :mv_apply
    sget-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sMoved:Z

    if-eqz v3, :true

    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/widget/FrameLayout$LayoutParams;

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sStartX:I

    float-to-int v5, v1

    add-int/2addr v4, v5

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sStartY:I

    float-to-int v5, v2

    add-int/2addr v4, v5

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {p0, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    goto :true

    :br_up
    const/4 v1, 0x1

    if-ne v0, v1, :true

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sMoved:Z

    if-eqz v0, :true

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getEventTime()J

    move-result-wide v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getDownTime()J

    move-result-wide v2

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x190

    cmp-long v4, v0, v2

    if-lez v4, :short_tap

    invoke-direct {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->onLong()V

    goto :true

    :short_tap
    invoke-direct {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->onClick()V

    :true
    const/4 v0, 0x1

    return v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    move-exception v0

    const/4 v0, 0x1

    return v0
.end method

.method public static show(Landroid/content/Context;)V
    .registers 7

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v0, :go

    return-void

    :go
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :fallback

    goto :have

    :fallback
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->actOf(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v1

    :have

    if-eqz v1, :nofail

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    invoke-direct {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;-><init>(Landroid/content/Context;)V

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x2

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v4, 0x33

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    const/16 v4, 0xc

    invoke-static {v1, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    const/16 v4, 0xf0

    invoke-static {v1, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    const-string v5, "捕获器：已挂上"

    invoke-static {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    :nofail
    const-string v5, "捕获器：拿不到 Activity"

    invoke-static {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method public static shown()Z
    .registers 1

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v0, :no

    const/4 v0, 0x1

    return v0

    :no
    const/4 v0, 0x0

    return v0
.end method

.method public static toggle(Landroid/content/Context;)V
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v0, :show

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->hide()V

    return-void

    :show
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->show(Landroid/content/Context;)V

    return-void
.end method

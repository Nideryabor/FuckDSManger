// ===== GmCallBtn (NL 2.13.0) =====
.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;
.super Ljava/lang/Object;
.source "GmCallBtn.java"
.implements Landroid/view/View$OnTouchListener;
.field static sAct:Landroid/app/Activity;

.field static sDownX:I

.field static sDownY:I

.field static sMoved:Z

.field static sStartX:I

.field static sStartY:I

.field static sView:Landroid/widget/TextView;

.field static sX:I

.field static sY:I
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static hide()V
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    if-eqz v0, :ret

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :a

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :a
    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    :ret
    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 9

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-eqz v0, :down

    const/4 v1, 0x2

    if-eq v0, v1, :move

    const/4 v1, 0x1

    if-eq v0, v1, :up

    const/4 v0, 0x0

    return v0

    :down
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    float-to-int v1, v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sDownX:I

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result v1

    float-to-int v1, v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sDownY:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartX:I

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartY:I

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sMoved:Z

    const/4 v1, 0x1

    return v1

    :move
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    float-to-int v1, v1

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sDownX:I

    sub-int/2addr v1, v2

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartX:I

    add-int/2addr v1, v2

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result v2

    float-to-int v2, v2

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sDownY:I

    sub-int/2addr v2, v3

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartY:I

    add-int/2addr v2, v3

    sput v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartX:I

    sub-int v3, v1, v3

    invoke-static {v3}, Ljava/lang/Math;->abs(I)I

    move-result v3

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sStartY:I

    sub-int v4, v2, v4

    invoke-static {v4}, Ljava/lang/Math;->abs(I)I

    move-result v4

    add-int/2addr v3, v4

    const/16 v4, 0x14

    if-gt v3, v4, :mv

    const/4 v3, 0x1

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sMoved:Z

    :mv
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->place()V

    const/4 v1, 0x1

    return v1

    :up
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->place()V

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sMoved:Z

    if-eqz v1, :click

    const-string v1, "[通话] 悬浮钮拖动结束"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v1, 0x1

    return v1

    :click
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->open()V

    const/4 v1, 0x1

    return v1
.end method

.method static place()V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    if-eqz v0, :ret

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    if-eqz v1, :ret

    check-cast v1, Landroid/widget/FrameLayout$LayoutParams;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v3, v4, v4}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :ret
    return-void
.end method

.method public static show(Landroid/app/Activity;)V
    .registers 16

    if-eqz p0, :ret

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sAct:Landroid/app/Activity;

    if-ne v1, p0, :mk

    if-nez v0, :ret

    :mk
    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sAct:Landroid/app/Activity;

    :try_start_0
    if-eqz v0, :norem

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :norem

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :norem
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :ret

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    if-nez v4, :hx

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v8

    invoke-virtual {v8}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v8

    iget v5, v8, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v6, v8, Landroid/util/DisplayMetrics;->heightPixels:I

    const/16 v7, 0x44

    invoke-static {p0, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v7

    sub-int/2addr v5, v7

    sput v5, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    mul-int/lit8 v6, v6, 0x2

    div-int/lit8 v6, v6, 0x3

    sput v6, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    :hx
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "🎧"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v2, 0x41a00000

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v2, 0x11

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v2, -0x1

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v3, -0x34000000

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 v3, 0x16

    invoke-static {p0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/16 v2, 0x2c

    invoke-static {p0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v4, 0x33

    invoke-virtual {v3, v4}, Landroid/widget/FrameLayout$LayoutParams;->setGravity(I)V

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    sget v5, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    const/4 v6, 0x0

    invoke-virtual {v3, v4, v5, v6, v6}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    invoke-virtual {v0, v1, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1}, Landroid/widget/TextView;->bringToFront()V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    const-string v0, "[通话] 悬浮钮已挂上宿主聊天页"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    :ret
    return-void
.end method


// ===== GmCallHook (NL 2.13.0) =====
.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallHook.java"
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-nez v0, :ret

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    const-string v1, "ao1"

    const-string v2, "[通话] 已捕获发送入口（ao1）"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    :ret
    return-void
.end method

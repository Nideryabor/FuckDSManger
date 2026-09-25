.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;
.super Ljava/lang/Object;
.source "GmCallBtn.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# static fields
.field static sAct:Landroid/app/Activity;

.field static sDownX:I

.field static sDownY:I

.field static sFail:I

.field static sMoved:Z

.field static sPop:Landroid/widget/PopupWindow;

.field static sStartX:I

.field static sStartY:I

.field static sView:Landroid/widget/TextView;

.field static sX:I

.field static sY:I


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensure(Landroid/app/Activity;)V
    .registers 4

    if-eqz p0, :cond_29

    invoke-virtual {p0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_29

    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_29

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sAct:Landroid/app/Activity;

    if-ne v0, p0, :cond_26

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    if-eqz v0, :cond_26

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sPop:Landroid/widget/PopupWindow;

    if-eqz v1, :cond_20

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sFail:I

    const/4 v2, 0x3

    if-ge v1, v2, :cond_29

    goto :goto_26

    :cond_20
    invoke-virtual {v1}, Landroid/widget/PopupWindow;->isShowing()Z

    move-result v2

    if-eqz v2, :cond_29

    :cond_26
    :goto_26
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->show(Landroid/app/Activity;)V

    :cond_29
    return-void
.end method

.method public static hide()V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sPop:Landroid/widget/PopupWindow;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/widget/PopupWindow;->dismiss()V

    :cond_7
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    if-eqz v0, :cond_16

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eqz v1, :cond_16

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_16
    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sPop:Landroid/widget/PopupWindow;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sView:Landroid/widget/TextView;

    return-void
.end method

.method static place()V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sPop:Landroid/widget/PopupWindow;

    if-eqz v0, :cond_12

    invoke-virtual {v0}, Landroid/widget/PopupWindow;->isShowing()Z

    move-result v1

    if-eqz v1, :cond_12

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    const/4 v3, -0x1

    invoke-virtual {v0, v1, v2, v3, v3}, Landroid/widget/PopupWindow;->update(IIII)V

    :cond_12
    return-void
.end method

.method static pop(Landroid/view/View;Landroid/widget/TextView;I)Z
    .registers 8

    :try_start_0
    new-instance v0, Landroid/widget/PopupWindow;

    invoke-direct {v0, p1, p2, p2}, Landroid/widget/PopupWindow;-><init>(Landroid/view/View;II)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/PopupWindow;->setClippingEnabled(Z)V

    invoke-virtual {v0, v1}, Landroid/widget/PopupWindow;->setOutsideTouchable(Z)V

    invoke-virtual {v0, v1}, Landroid/widget/PopupWindow;->setFocusable(Z)V

    const/16 v1, 0x33

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sX:I

    sget v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sY:I

    invoke-virtual {v0, p0, v1, v2, v3}, Landroid/widget/PopupWindow;->showAtLocation(Landroid/view/View;III)V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sPop:Landroid/widget/PopupWindow;

    const/4 v0, 0x0

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sFail:I

    const/4 v0, 0x1

    return v0
    :try_end_1f
    .catchall {:try_start_0 .. :try_end_1f} :catchall_1f

    :catchall_1f
    move-exception v0

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "[\u901a\u8bdd] PopupWindow \u5931\u8d25 \u21d2 \u56de\u9000 DecorView"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sFail:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sFail:I

    const/4 v0, 0x0

    return v0
.end method

.method public static show(Landroid/app/Activity;)V
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->hide()V

    const-string v0, "[\u901a\u8bdd] \u60ac\u6d6e\u94ae"

    const-string p0, "\u5df2\u505c\u7528\uff08\u97f3\u9891\u901a\u8bdd\u8f6c wip\uff09"

    invoke-static {v0, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 9

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-eqz v0, :cond_e

    const/4 v1, 0x2

    if-eq v0, v1, :cond_2e

    const/4 v1, 0x1

    if-eq v0, v1, :cond_65

    const/4 v0, 0x0

    return v0

    :cond_e
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

    const-string v1, "[\u901a\u8bdd] \u60ac\u6d6e\u94ae\u6309\u4e0b"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v1, 0x1

    return v1

    :cond_2e
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

    if-le v3, v4, :cond_60

    const/4 v3, 0x1

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sMoved:Z

    :cond_60
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->place()V

    const/4 v1, 0x1

    return v1

    :cond_65
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->place()V

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallBtn;->sMoved:Z

    if-eqz v1, :cond_73

    const-string v1, "[\u901a\u8bdd] \u60ac\u6d6e\u94ae\u62d6\u52a8\u7ed3\u675f\uff08\u4e0d\u89e6\u53d1\u70b9\u51fb\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v1, 0x1

    return v1

    :cond_73
    const-string v1, "[\u901a\u8bdd] \u60ac\u6d6e\u94ae\u70b9\u51fb \u2192 \u5f00\u901a\u8bdd\u9875"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->open()V

    const/4 v1, 0x1

    return v1
.end method

.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;
.super Ljava/lang/Object;
.source "GmBgDialog.java"


# static fields
.field static sAct:Landroid/app/Activity;

.field static sDlg:Landroid/app/Dialog;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static act()Landroid/app/Activity;
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    return-object v0
.end method

.method public static alphaDown()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_18

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, -0x5

    if-gez v1, :cond_f

    const/4 v1, 0x0

    :cond_f
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setAlpha(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_18
    return-void
.end method

.method public static alphaUp()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_2e

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, 0x5

    const/16 v2, 0x64

    if-lt v1, v2, :cond_12

    const/16 v1, 0x64

    :cond_12
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v2

    const/4 v3, 0x2

    if-ne v2, v3, :cond_25

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dirMul(Landroid/content/Context;)Z

    move-result v2

    if-nez v2, :cond_25

    const/16 v2, 0x46

    if-gt v1, v2, :cond_25

    const/16 v1, 0x46

    :cond_25
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setAlpha(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_2e
    return-void
.end method

.method public static camBack()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setCam(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.method public static camFront()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setCam(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    return-void
.end method

.method public static cropDown()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1b

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->crop(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, -0x19

    const/16 v2, 0x64

    if-ge v1, v2, :cond_12

    const/16 v1, 0x64

    :cond_12
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setCrop(Landroid/content/Context;I)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->refit()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_1b
    return-void
.end method

.method public static cropUp()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1b

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->crop(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, 0x19

    const/16 v2, 0x12c

    if-le v1, v2, :cond_12

    const/16 v1, 0x12c

    :cond_12
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setCrop(Landroid/content/Context;I)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->refit()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_1b
    return-void
.end method

.method public static dirAuto()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_15

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setDir(Landroid/content/Context;I)V

    const-string v1, "\u6df7\u5408\u65b9\u5411\uff1a\u81ea\u52a8\uff08\u8ddf\u968f\u7cfb\u7edf\u663c\u591c\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_15
    return-void
.end method

.method public static dirDark()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_15

    const/4 v1, 0x2

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setDir(Landroid/content/Context;I)V

    const-string v1, "\u6df7\u5408\u65b9\u5411\uff1a\u6df1\u8272\u5e95\uff08SCREEN\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_15
    return-void
.end method

.method public static dirLight()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_15

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setDir(Landroid/content/Context;I)V

    const-string v1, "\u6df7\u5408\u65b9\u5411\uff1a\u6d45\u8272\u5e95\uff08MULTIPLY\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_15
    return-void
.end method

.method public static gradNext()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_19

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->grad(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, 0x1

    const/4 v2, 0x4

    if-lt v1, v2, :cond_10

    const/4 v1, 0x0

    :cond_10
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setGrad(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_19
    return-void
.end method

.method public static gradPrev()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_18

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->grad(Landroid/content/Context;)I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    if-gez v1, :cond_f

    const/4 v1, 0x3

    :cond_f
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setGrad(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_18
    return-void
.end method

.method public static open()V
    .registers 12

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_5aa

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_10

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-nez v2, :cond_5aa

    :cond_10
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->sDlg:Landroid/app/Dialog;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 v3, 0x18

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u4fee\u6539\u80cc\u666f"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v4, v4, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u8499\u5c42=\u534a\u900f\u660e\u53e0\u52a0\uff1b\u6df7\u5408=\u5e95\u56fe\u6df7\u8fdb\u754c\u9762\uff1b\u6444\u50cf\u5934=\u5b9e\u65f6\u53d6\u666f\u5f53\u5e95\u56fe"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41200000    # 10.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, 0x0

    invoke-virtual {v2, v4, v5, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "\u5f00\u542f\u80cc\u666f"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41800000    # 16.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Switch;

    invoke-direct {v3, v0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->isOn(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/Switch;->setChecked(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmBgSwitch;

    invoke-direct {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmBgSwitch;-><init>()V

    invoke-virtual {v3, v4}, Landroid/widget/CompoundButton;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, 0x1

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u56fe\u7247"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x1c

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6e10\u53d8"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x1d

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6444\u50cf\u5934"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2a

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u9009\u62e9\u56fe\u7247"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x1e

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6444\u50cf\u5934\u65b9\u5411"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41600000    # 14.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u540e\u7f6e"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2b

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u524d\u7f6e"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2c

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u65cb\u8f6c "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->rot(Landroid/content/Context;)I

    move-result v5

    if-ltz v5, :cond_22b

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "\u00b0"

    goto :goto_22d

    :cond_22b
    const-string v5, "\u81ea\u52a8"

    :goto_22d
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2d

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u2212"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2e

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u88c1\u5207 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->crop(Landroid/content/Context;)I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "%"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41800000    # 16.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\uff0b"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x2f

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, 0x1

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u2039"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x1f

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u6e10\u53d8\u6837\u5f0f "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->grad(Landroid/content/Context;)I

    move-result v5

    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " / 4"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41800000    # 16.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u203a"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x20

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, 0x1

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u2212"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x21

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u900f\u660e\u5ea6 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "%"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41800000    # 16.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\uff0b"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x22

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/TextView;

    invoke-direct {v3, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6df7\u5408\u65b9\u5411"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41600000    # 14.0f

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u81ea\u52a8"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x27

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6d45\u8272\u5e95"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x28

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6df1\u8272\u5e95"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x29

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, 0x1

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/view/View;

    invoke-direct {v2, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, 0x1

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u8499\u5c42\uff08\u76d6\u5728\u4e0a\u5c42\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x24

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u5e95\u56fe\uff08\u5728\u5185\u5bb9\u540e\u9762\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x25

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u6df7\u5408\uff08\u771f\u80cc\u666f\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x26

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v3, "\u8fd4\u56de"

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v4, 0x23

    invoke-direct {v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->sDlg:Landroid/app/Dialog;

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_5a7

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_5a7
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    :cond_5aa
    return-void
.end method

.method public static pickBg()V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_20

    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    const-string v2, "android.intent.action.GET_CONTENT"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v1

    const-string v2, "image/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pick()V

    const v2, 0x435a

    invoke-virtual {v0, v1, v2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    :cond_20
    return-void
.end method

.method public static refresh()V
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->close()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->open()V

    return-void
.end method

.method public static rotNext()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1e

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->rot(Landroid/content/Context;)I

    move-result v1

    if-ltz v1, :cond_14

    add-int/lit8 v1, v1, 0x5a

    const/16 v2, 0x168

    if-ge v1, v2, :cond_15

    const/4 v1, -0x1

    goto :goto_15

    :cond_14
    const/4 v1, 0x0

    :cond_15
    :goto_15
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setRot(Landroid/content/Context;I)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->refit()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_1e
    return-void
.end method

.method public static setModeCam()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_24

    const/4 v1, 0x2

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setMode(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v1

    if-eqz v1, :cond_14

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setPos(Landroid/content/Context;I)V

    :cond_14
    const/16 v1, 0x28

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setAlpha(Landroid/content/Context;I)V

    const-string v1, "\u6444\u50cf\u5934\u53d6\u666f\u5df2\u9009\u4e2d\uff08\u4f4d\u7f6e\u2192\u8499\u5c42\uff0c\u900f\u660e\u5ea6 40%\uff09\uff1b\u82e5\u5f39\u6743\u9650\u6846\u8bf7\u5148\u5141\u8bb8"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_24
    return-void
.end method

.method public static setModeGrad()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setMode(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.method public static setModeImg()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setMode(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.method public static setPosBehind()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setPos(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.method public static setPosMix()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_22

    const/4 v1, 0x2

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setPos(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dirMul(Landroid/content/Context;)Z

    move-result v1

    const/16 v2, 0x5c

    if-eqz v1, :cond_14

    const/16 v2, 0x37

    :cond_14
    invoke-static {v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setAlpha(Landroid/content/Context;I)V

    const-string v1, "\u6df7\u5408\u6a21\u5f0f\uff1a\u900f\u660e\u5ea6\u5df2\u8bbe\u4e3a\u63a8\u8350\u503c\uff08\u6d45\u8272 55% / \u6df1\u8272 92%\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_22
    return-void
.end method

.method public static setPosOverlay()V
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_10

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setPos(Landroid/content/Context;I)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->refresh()V

    :cond_10
    return-void
.end method

.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;
.super Ljava/lang/Object;
.source "GmSuggestDialog.java"


# static fields
.field static sAct:Landroid/app/Activity;

.field static sAiBtn:Landroid/widget/Button;

.field static sAiOn:Z

.field static sCnt:Landroid/widget/EditText;

.field static sDlg:Landroid/app/Dialog;

.field static sOn:Z

.field static sSw:Landroid/widget/Button;

.field static sTxt:Landroid/widget/EditText;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    return-void
.end method

.method static et(Landroid/content/Context;IF)Landroid/widget/EditText;
    .registers 7

    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const/high16 v1, 0x41200000    # 10.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v1, 0x6

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    if-lez p1, :cond_26

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    goto :goto_2d

    :cond_26
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x0

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3, p2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    :goto_2d
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method static fill()V
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->on(Landroid/content/Context;)Z

    move-result v1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sOn:Z

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->aiOn(Landroid/content/Context;)Z

    move-result v1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiOn:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sync()V

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sCnt:Landroid/widget/EditText;

    if-eqz v1, :cond_23

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->count(Landroid/content/Context;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    :cond_23
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sTxt:Landroid/widget/EditText;

    if-eqz v1, :cond_2e

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->text(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    :cond_2e
    return-void
.end method

.method static htv(Landroid/content/Context;Ljava/lang/String;I)Landroid/widget/TextView;
    .registers 7

    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v1, 0x41200000    # 10.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v1, 0x4

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    if-lez p2, :cond_29

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    goto :goto_32

    :cond_29
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x0

    const/4 v3, -0x2

    const/high16 p0, 0x3f800000    # 1.0f

    invoke-direct {v1, v2, v3, p0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    :goto_32
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static open()V
    .registers 12

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAct:Landroid/app/Activity;

    const-string v1, "[\u8bbe\u7f6e] \u56de\u590d\u5efa\u8bae\u754c\u9762\uff1a\u6253\u5f00\u8bf7\u6c42"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-nez v0, :cond_c

    return-void

    :cond_c
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_17

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-eqz v2, :cond_17

    return-void

    :cond_17
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sDlg:Landroid/app/Dialog;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 v3, 0x18

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u56de\u590d\u5efa\u8bae"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v4, v4, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u6a21\u677f\u6c60\u6bcf\u884c\u4e00\u6761\uff0c\u70b9\u6309\u94ae\u5373\u53d1\u9001\u3002\n\u3010AI \u751f\u6210\u3011\u5f00\u542f\u540e\u81ea\u52a8\u8bfb\u53d6\u5f53\u524d\u5bf9\u8bdd\u4e0a\u4e0b\u6587\uff0c\u5411 DS \u5355\u72ec\u53d1\u4e00\u6b21\u8bf7\u6c42\u751f\u6210\u9884\u56de\u590d\uff0c\u586b\u5145\u5230\u4e0b\u9762\u90a3\u6392\u6309\u94ae\uff08\u4e0d\u53d1\u9001\u6d88\u606f\u3001\u4e0d\u5165\u804a\u5929\u8bb0\u5f55\uff09\u3002\n\u3010\u8bca\u65ad NL v2.12.9\u3011\n"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->infoText()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41200000    # 10.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, 0x0

    invoke-virtual {v2, v4, v5, v4, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v4, 0x37

    invoke-direct {v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sSw:Landroid/widget/Button;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v4, 0x38

    invoke-direct {v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiBtn:Landroid/widget/Button;

    const-string v3, "AI \u751f\u6210 (wip)\uff1a\u5df2\u5173\u95ed"

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v3, "\u663e\u793a\u6570\u91cf"

    const/16 v4, 0x48

    invoke-static {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->htv(Landroid/content/Context;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v3, 0x60

    const/4 v4, 0x0

    invoke-static {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->et(Landroid/content/Context;IF)Landroid/widget/EditText;

    move-result-object v3

    const/4 v4, 0x2

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setInputType(I)V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sCnt:Landroid/widget/EditText;

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v3, "\u6a21\u677f\u6c60\uff08\u6bcf\u884c\u4e00\u6761\uff09"

    const/4 v4, 0x0

    invoke-static {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->htv(Landroid/content/Context;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/EditText;

    invoke-direct {v2, v0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const/high16 v3, 0x41200000    # 10.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x6

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    const/16 v3, 0x30

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v3, 0x5

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setMinLines(I)V

    const v3, 0x20001

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setInputType(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/16 v5, 0x60

    invoke-static {v0, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sTxt:Landroid/widget/EditText;

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x8

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "\u4fdd\u5b58"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x34

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

    const-string v4, "\u6062\u590d\u9ed8\u8ba4"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x35

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

    const-string v4, "\u8fd4\u56de"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v5, 0x36

    invoke-direct {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sDlg:Landroid/app/Dialog;

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_1ce

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_1ce
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->fill()V

    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method static pick(Ljava/lang/String;)I
    .registers 3

    const/4 v0, 0x0

    :try_start_1
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    move v0, v1
    :try_end_6
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_6} :catch_7

    goto :goto_8

    :catch_7
    move-exception v1

    :goto_8
    return v0
.end method

.method public static reset()V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->restore(Landroid/content/Context;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->clear()V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->fill()V

    const-string v1, "\u5df2\u6062\u590d\u9ed8\u8ba4\u6a21\u677f"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static save()V
    .registers 12

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    const-string v3, "[\u8bbe\u7f6e] \u56de\u590d\u5efa\u8bae\uff1a\u4fdd\u5b58"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sTxt:Landroid/widget/EditText;

    if-eqz v1, :cond_19

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->setText(Landroid/content/Context;Ljava/lang/String;)V

    :cond_19
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sCnt:Landroid/widget/EditText;

    if-eqz v1, :cond_2c

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->pick(Ljava/lang/String;)I

    move-result v2

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->setCount(Landroid/content/Context;I)V

    :cond_2c
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sOn:Z

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->setOn(Landroid/content/Context;Z)V

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiOn:Z

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->setAi(Landroid/content/Context;Z)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestHook;->clear()V

    const-string v1, "\u5df2\u4fdd\u5b58\uff08\u804a\u5929\u9875\u5373\u65f6\u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static sync()V
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sSw:Landroid/widget/Button;

    if-nez v0, :cond_5

    return-void

    :cond_5
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sOn:Z

    if-eqz v1, :cond_c

    const-string v1, "\u603b\u5f00\u5173\uff1a\u5df2\u5f00\u542f"

    goto :goto_e

    :cond_c
    const-string v1, "\u603b\u5f00\u5173\uff1a\u5df2\u5173\u95ed"

    :goto_e
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiBtn:Landroid/widget/Button;

    if-eqz v0, :cond_21

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiOn:Z

    if-eqz v1, :cond_1c

    const-string v1, "AI \u751f\u6210 (wip)\uff1a\u5df2\u5f00\u542f"

    goto :goto_1e

    :cond_1c
    const-string v1, "AI \u751f\u6210 (wip)\uff1a\u5df2\u5173\u95ed"

    :goto_1e
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    :cond_21
    return-void
.end method

.method public static toggle()V
    .registers 2

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sOn:Z

    xor-int/lit8 v0, v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sOn:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sync()V

    return-void
.end method

.method public static toggleAi()V
    .registers 2

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiOn:Z

    xor-int/lit8 v0, v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAiOn:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sync()V

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_22

    :try_start_d
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestAi;->probe(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_14
    .catchall {:try_start_d .. :try_end_14} :catchall_15

    goto :goto_22

    :catchall_15
    move-exception v1

    invoke-static {v1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "AI \u63a2\u6d4b\u5f02\u5e38\uff08\u5df2\u5199\u65e5\u5fd7\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_22
    :goto_22
    return-void
.end method

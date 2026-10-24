.class public final Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;
.super Ljava/lang/Object;
.source "GmHelloDialog.java"


# static fields
.field static sAct:Landroid/app/Activity;

.field static sBox:Landroid/widget/LinearLayout;

.field static sDlg:Landroid/app/Dialog;

.field static sIds:Ljava/util/ArrayList;

.field static sTexts:Ljava/util/ArrayList;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addNew()V
    .registers 4

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->nextId()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\u65b0\u62db\u547c\u8bed"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->addRow(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static addRow(Ljava/lang/String;Ljava/lang/String;)V
    .registers 8

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_3e

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sBox:Landroid/widget/LinearLayout;

    if-eqz v1, :cond_3e

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    if-eqz v2, :cond_3e

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x30

    const/4 v3, 0x0

    invoke-static {v0, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->et(Landroid/content/Context;IF)Landroid/widget/EditText;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    const/4 v3, 0x0

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-static {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->et(Landroid/content/Context;IF)Landroid/widget/EditText;

    move-result-object v3

    invoke-virtual {v3, p1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sTexts:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sBox:Landroid/widget/LinearLayout;

    invoke-virtual {v4, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :cond_3e
    return-void
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    return-void
.end method

.method static collect()Ljava/util/List;
    .registers 10

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sTexts:Ljava/util/ArrayList;

    if-eqz v1, :cond_4b

    const/4 v2, 0x0

    :goto_a
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v2, v3, :cond_4b

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/widget/EditText;

    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_48

    const/4 v6, 0x2

    new-array v7, v6, [Ljava/lang/String;

    const/4 v6, 0x0

    invoke-virtual {v4}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    aput-object v8, v7, v6

    const/4 v6, 0x1

    aput-object v5, v7, v6

    invoke-virtual {v0, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_48
    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    :cond_4b
    return-object v0
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

    const/4 v1, 0x4

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setSingleLine(Z)V

    if-lez p1, :cond_2a

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    goto :goto_31

    :cond_2a
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x0

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3, p2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    :goto_31
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static fill()V
    .registers 8

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sBox:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_34

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_34

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    if-eqz v2, :cond_34

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    invoke-virtual {v2}, Ljava/util/ArrayList;->clear()V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sTexts:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->clear()V

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->items(Landroid/content/Context;)Ljava/util/List;

    move-result-object v3

    const/4 v4, 0x0

    :goto_1c
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v5

    if-ge v4, v5, :cond_34

    invoke-interface {v3, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Ljava/lang/String;

    const/4 v6, 0x0

    aget-object v6, v5, v6

    const/4 v7, 0x1

    aget-object v7, v5, v7

    invoke-static {v6, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->addRow(Ljava/lang/String;Ljava/lang/String;)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_1c

    :cond_34
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

.method static nextId()Ljava/lang/String;
    .registers 8

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    if-eqz v0, :cond_2f

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_6
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v2, v3, :cond_28

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v4

    if-le v4, v1, :cond_25

    move v1, v4

    :cond_25
    add-int/lit8 v2, v2, 0x1

    goto :goto_6

    :cond_28
    add-int/lit8 v1, v1, 0x1

    invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_2f
    const-string v0, "12"

    return-object v0
.end method

.method public static open()V
    .registers 10

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_1a5

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_10

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-nez v2, :cond_1a5

    :cond_10
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sDlg:Landroid/app/Dialog;

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

    const-string v3, "\u62db\u547c\u7528\u8bed"

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

    const-string v4, "\u65b0\u4f1a\u8bdd\u5f00\u5c4f\u62db\u547c\u8bed\u3002\u6e05\u7a7a\u300c\u62db\u547c\u8bed\u300d\u5373\u5220\u9664\u8be5\u6761\uff1b\u65b0\u589e\u6761\u76ee\u4f1a\u81ea\u52a8\u52a0\u5165\u6240\u6709\u65f6\u6bb5\u3002\n\u5b58\u50a8\u952e\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->find(Landroid/content/Context;)Ljava/lang/String;

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

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/4 v3, 0x4

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v3, v3, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const-string v4, "ID"

    const/16 v5, 0x30

    invoke-static {v0, v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->htv(Landroid/content/Context;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const-string v4, "\u62db\u547c\u8bed"

    const/4 v5, 0x0

    invoke-static {v0, v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->htv(Landroid/content/Context;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sBox:Landroid/widget/LinearLayout;

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sIds:Ljava/util/ArrayList;

    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sTexts:Ljava/util/ArrayList;

    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v3, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    const/16 v6, 0xd2

    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v6

    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v3, "\uff0b \u6dfb\u52a0\u4e00\u884c"

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmClick;

    const/16 v4, 0x1a

    invoke-direct {v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

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

    const/16 v5, 0x17

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

    const/16 v5, 0x18

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

    const/16 v5, 0x19

    invoke-direct {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sDlg:Landroid/app/Dialog;

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_19f

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_19f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->fill()V

    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    :cond_1a5
    return-void
.end method

.method public static reset()V
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_f

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->restore(Landroid/content/Context;)V

    const-string v1, "\u5df2\u6062\u590d\u9ed8\u8ba4\uff0c\u91cd\u542f App \u751f\u6548"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->fill()V

    :cond_f
    return-void
.end method

.method public static save()V
    .registers 5

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_17

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHelloDialog;->collect()Ljava/util/List;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->build(Ljava/util/List;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->put(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmHello;->apply(Landroid/content/Context;Ljava/lang/String;)Z

    const-string v3, "\u5df2\u4fdd\u5b58\uff0c\u91cd\u542f App \u751f\u6548"

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_17
    return-void
.end method

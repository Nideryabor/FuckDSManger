.class public final Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;
.super Ljava/lang/Object;
.source "GmAboutUi.java"


# static fields
.field private static sDlg:Landroid/app/Dialog;


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static close()V
    .registers 1

    .line 94
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_7

    :catchall_7
    :cond_7
    const/4 v0, 0x0

    .line 95
    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->sDlg:Landroid/app/Dialog;

    return-void
.end method

.method static synthetic lambda$openInner$0(Landroid/view/View;)V
    .registers 1

    .line 41
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->close()V

    return-void
.end method

.method public static open()V
    .registers 1

    .line 26
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->openInner()V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_4

    return-void

    :catchall_4
    move-exception v0

    .line 28
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->report(Ljava/lang/Throwable;)V

    return-void
.end method

.method private static openInner()V
    .registers 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    .line 33
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    .line 35
    :cond_5
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->close()V

    .line 36
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    .line 37
    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    .line 39
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->column(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v3

    .line 40
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v4

    const/16 v5, 0x1c

    invoke-static {v0, v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 41
    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi$0;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi$0;-><init>()V

    const-string v6, "\u5173\u4e8e"

    invoke-static {v0, v6, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->topBar(Landroid/content/Context;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/LinearLayout;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v4, 0x170

    const v6, -0x2c1c03

    .line 43
    invoke-static {v0, v4, v6, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->box(Landroid/content/Context;III)Landroid/widget/LinearLayout;

    move-result-object v4

    .line 44
    new-instance v6, Landroid/view/View;

    invoke-direct {v6, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 45
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v7

    const/16 v8, 0x14

    invoke-static {v0, v7, v8}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v7

    invoke-virtual {v6, v7}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/16 v7, 0xc8

    .line 46
    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v7

    .line 47
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v8, v7, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 48
    iput v2, v8, Landroid/widget/LinearLayout$LayoutParams;->gravity:I

    const/16 v2, 0x38

    .line 49
    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    iput v2, v8, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 50
    invoke-virtual {v6, v8}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 51
    invoke-virtual {v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 52
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 53
    const-string v6, "FDM-100%\u7531DS\u9b3c\u8111\u53d1\u52a8\u7684\u795e\u79d8\u6a21\u5757"

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v6, 0x41b00000    # 22.0f

    .line 54
    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 55
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const v6, -0xfbe1b7

    .line 56
    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v6, 0x11

    .line 57
    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 58
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/high16 v8, 0x3f800000    # 1.0f

    const/4 v9, 0x0

    invoke-direct {v6, v7, v9, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v6}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v6, 0x10

    .line 59
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v8

    const/16 v10, 0x18

    invoke-static {v0, v10}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v11

    invoke-virtual {v2, v7, v9, v8, v11}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 60
    invoke-virtual {v4, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 61
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 62
    invoke-static {v0, v10}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->space(Landroid/content/Context;I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/16 v2, 0x13c

    .line 64
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v4

    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->box(Landroid/content/Context;III)Landroid/widget/LinearLayout;

    move-result-object v2

    .line 65
    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 66
    const-string v5, "\u81f4\u8c22\n\n\u5c3c\u5f97\u4e9a\u4f2f(DS\u9a71\u52a8\u7248)\uff1a\u6240\u6709\u7684\u6838\u5fc3\u4ee3\u7801\u90fd\u662fTa\u5199\u7684\nlsposed\uff1a\u63d0\u4f9b\u4e86 hook \u53ca\u6ce8\u5165\ntoken\uff1a\u8bb8\u591a\u90fd\u88ab\u5c3c\u5f97\u4e9a\u4f2f\u5f53\u591c\u5bb5\u4e86\nm3e-canvas\uff08\u672c\u9879\u76ee\u7684 UI \u8bbe\u8ba1/\u5b9e\u73b0\u53c2\u8003\uff09\n\u9879\u76ee\u5730\u5740\uff1ahttps://github.com/lnkiai/m3e-canvas\n\u25a0\u795e\uff1a\u6211\u4e5f\u4e0d\u77e5\u9053\u600e\u4e48\u4f1a\u6709\u8fd9\u4e2a\u3002"

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v5, 0x41500000    # 13.0f

    .line 73
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextSize(F)V

    .line 74
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v5

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v5, 0x0

    const v7, 0x3fb33333    # 1.4f

    .line 75
    invoke-virtual {v4, v5, v7}, Landroid/widget/TextView;->setLineSpacing(FF)V

    .line 76
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v10

    invoke-virtual {v4, v5, v7, v8, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 77
    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 78
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 79
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->space(Landroid/content/Context;I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 81
    invoke-static {v1, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    const/16 v2, 0x12c

    .line 84
    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->setMinimumWidth(I)V

    .line 85
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 86
    invoke-virtual {v1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v2

    .line 87
    new-instance v3, Landroid/graphics/drawable/ColorDrawable;

    invoke-direct {v3, v9}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {v2, v3}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 88
    iget v3, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v3, v3

    const v4, 0x3f6b851f    # 0.92f

    mul-float/2addr v3, v4

    float-to-int v3, v3

    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-float v0, v0

    const v4, 0x3f5c28f6    # 0.86f

    mul-float/2addr v0, v4

    float-to-int v0, v0

    invoke-virtual {v2, v3, v0}, Landroid/view/Window;->setLayout(II)V

    .line 89
    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    .line 90
    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->sDlg:Landroid/app/Dialog;

    return-void
.end method

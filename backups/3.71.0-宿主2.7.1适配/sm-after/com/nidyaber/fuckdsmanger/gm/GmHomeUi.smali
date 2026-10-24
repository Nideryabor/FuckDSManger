.class public final Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;
.super Ljava/lang/Object;
.source "GmHomeUi.java"


# static fields
.field private static sDlg:Landroid/app/Dialog;


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static close()V
    .registers 1

    .line 99
    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_7

    :catchall_7
    :cond_7
    const/4 v0, 0x0

    .line 100
    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->sDlg:Landroid/app/Dialog;

    return-void
.end method

.method static synthetic lambda$openInner$0(Landroid/view/View;)V
    .registers 1

    .line 52
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDialog;->open()V

    return-void
.end method

.method static synthetic lambda$openInner$1(ILandroid/view/View;)V
    .registers 2

    if-eqz p0, :cond_14

    const/4 p1, 0x1

    if-eq p0, p1, :cond_10

    const/4 p1, 0x2

    if-eq p0, p1, :cond_c

    .line 69
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDumpDialog;->open()V

    return-void

    .line 68
    :cond_c
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvDialog;->open()V

    return-void

    .line 67
    :cond_10
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBeautyDialog;->open()V

    return-void

    .line 66
    :cond_14
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmChatDialog;->open()V

    return-void
.end method

.method static synthetic lambda$openInner$2(Landroid/view/View;)V
    .registers 2

    .line 82
    invoke-virtual {p0}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p0

    .line 83
    instance-of v0, p0, Ljava/lang/Integer;

    if-eqz v0, :cond_14

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_14

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmAboutUi;->open()V

    :cond_14
    return-void
.end method

.method public static open()V
    .registers 1

    .line 32
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->openInner()V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_4

    return-void

    :catchall_4
    move-exception v0

    .line 34
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->report(Ljava/lang/Throwable;)V

    .line 35
    :try_start_8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmMenuDialog;->open()V
    :try_end_b
    .catchall {:try_start_8 .. :try_end_b} :catchall_b

    :catchall_b
    return-void
.end method

.method private static openInner()V
    .registers 14
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    .line 40
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    .line 42
    :cond_5
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->close()V

    .line 43
    new-instance v8, Landroid/app/Dialog;

    invoke-direct {v8, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    .line 44
    invoke-virtual {v8, v1}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    .line 46
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->column(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v9

    .line 47
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v1

    const/16 v2, 0x1c

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 48
    const-string v1, "FuckDSManger"

    const/4 v10, 0x0

    invoke-static {v0, v1, v10}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->topBar(Landroid/content/Context;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/LinearLayout;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 50
    const-string v1, "\u6838\u5fc3\u306e\u529f\u80fd"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->sectionLabel(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 51
    new-instance v7, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$0;

    invoke-direct {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$0;-><init>()V

    const-string v1, "\u270e"

    const-string v2, "\u7070\u5ea6\u9009\u9879\u7ba1\u7406"

    const-string v3, "\u67e5\u770b\u5bbf\u4e3b\u9690\u85cf\u8bbe\u7f6e(\u5c0f\u5fc3\u5c01\u53f7)"

    const/4 v4, 0x1

    const/4 v5, 0x0

    const/4 v6, 0x1

    invoke-static/range {v0 .. v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->listRow(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZIILandroid/view/View$OnClickListener;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 54
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->divider(Landroid/content/Context;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 55
    const-string v1, "\u9644\u52a0\u306e\u529f\u80fd"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->sectionLabel(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 57
    const-string v1, "\u8fc7\u68c0"

    const-string v2, "\u8c03\u8bd5"

    const-string v3, "\u804a\u5929"

    const-string v4, "\u7f8e\u5316"

    filled-new-array {v3, v4, v1, v2}, [Ljava/lang/String;

    move-result-object v11

    .line 58
    const-string v1, "\u2714"

    const-string v2, "\u2699"

    const-string v3, "\u2709"

    const-string v4, "\u263a"

    filled-new-array {v3, v4, v1, v2}, [Ljava/lang/String;

    move-result-object v12

    .line 59
    const-string v1, "\u5982\u679cds\u538b\u529broot\u8bbe\u5907/\u53d1\u73b0lsp\uff0c\u70b9\u6211"

    const-string v2, "\u5982\u679c\u6ca1bug\uff0c\u91cc\u9762\u7684\u4e1c\u897f\u522b\u4e71\u52a8"

    filled-new-array {v10, v10, v1, v2}, [Ljava/lang/String;

    move-result-object v10

    const/4 v13, 0x0

    move v5, v13

    :goto_7c
    const/4 v6, 0x4

    if-ge v5, v6, :cond_ad

    .line 64
    aget-object v1, v12, v5

    aget-object v2, v11, v5

    aget-object v3, v10, v5

    new-instance v7, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$1;

    invoke-direct {v7, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$1;-><init>(I)V

    const/4 v4, 0x1

    invoke-static/range {v0 .. v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->listRow(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZIILandroid/view/View$OnClickListener;)Landroid/view/View;

    move-result-object v1

    .line 72
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v3, 0x48

    .line 73
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    const/4 v4, -0x1

    invoke-direct {v2, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    if-lez v5, :cond_a4

    const/4 v3, 0x3

    .line 74
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 75
    :cond_a4
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 76
    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v5, v5, 0x1

    goto :goto_7c

    :cond_ad
    const/16 v1, 0x8

    .line 79
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->space(Landroid/content/Context;I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 80
    const-string v1, "\u9996\u9875"

    const-string v2, "\u5173\u4e8e"

    filled-new-array {v1, v2}, [Ljava/lang/String;

    move-result-object v1

    const-string v2, "\u2302"

    const-string v3, "\u24d8"

    filled-new-array {v2, v3}, [Ljava/lang/String;

    move-result-object v2

    new-instance v3, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$2;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi$2;-><init>()V

    invoke-static {v0, v1, v2, v13, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->navBar(Landroid/content/Context;[Ljava/lang/String;[Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/LinearLayout;

    move-result-object v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 86
    invoke-static {v8, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    const/16 v1, 0x12c

    .line 89
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-virtual {v9, v1}, Landroid/widget/LinearLayout;->setMinimumWidth(I)V

    .line 90
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 91
    invoke-virtual {v8}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v1

    .line 92
    new-instance v2, Landroid/graphics/drawable/ColorDrawable;

    invoke-direct {v2, v13}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {v1, v2}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 93
    iget v2, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v2, v2

    const v3, 0x3f6b851f    # 0.92f

    mul-float/2addr v2, v3

    float-to-int v2, v2

    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-float v0, v0

    const v3, 0x3f5c28f6    # 0.86f

    mul-float/2addr v0, v3

    float-to-int v0, v0

    invoke-virtual {v1, v2, v0}, Landroid/view/Window;->setLayout(II)V

    .line 94
    invoke-virtual {v8}, Landroid/app/Dialog;->show()V

    .line 95
    sput-object v8, Lcom/nidyaber/fuckdsmanger/gm/GmHomeUi;->sDlg:Landroid/app/Dialog;

    return-void
.end method

.method static report(Ljava/lang/Throwable;)V
    .registers 7

    .line 105
    :try_start_0
    const-string v0, "FDM-UI"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    .line 107
    :catchall_5
    :try_start_5
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_a

    goto :goto_77

    .line 109
    :cond_a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 110
    invoke-virtual {p0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v2

    const/4 v3, 0x0

    .line 111
    :goto_1c
    array-length v4, v2

    const/4 v5, 0x2

    invoke-static {v5, v4}, Ljava/lang/Math;->min(II)I

    move-result v4

    if-ge v3, v4, :cond_31

    const-string v4, "\n"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v4, v2, v3

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;
    :try_end_2e
    .catchall {:try_start_5 .. :try_end_2e} :catchall_77

    add-int/lit8 v3, v3, 0x1

    goto :goto_1c

    :cond_31
    const/4 v2, 0x1

    .line 113
    :try_start_32
    new-instance v3, Ljava/io/File;

    const/4 v4, 0x0

    invoke-virtual {v0, v4}, Landroid/app/Activity;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v4

    const-string v5, "fdm-ui-crash.txt"

    invoke-direct {v3, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 114
    new-instance v4, Ljava/io/PrintWriter;

    new-instance v5, Ljava/io/FileWriter;

    invoke-direct {v5, v3, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    invoke-direct {v4, v5}, Ljava/io/PrintWriter;-><init>(Ljava/io/Writer;)V

    .line 115
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "=== "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v5, Ljava/util/Date;

    invoke-direct {v5}, Ljava/util/Date;-><init>()V

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, " ==="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 116
    invoke-virtual {p0, v4}, Ljava/lang/Throwable;->printStackTrace(Ljava/io/PrintWriter;)V

    .line 117
    invoke-virtual {v4}, Ljava/io/PrintWriter;->close()V
    :try_end_6c
    .catchall {:try_start_32 .. :try_end_6c} :catchall_6c

    .line 119
    :catchall_6c
    :try_start_6c
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V
    :try_end_77
    .catchall {:try_start_6c .. :try_end_77} :catchall_77

    :catchall_77
    :goto_77
    return-void
.end method

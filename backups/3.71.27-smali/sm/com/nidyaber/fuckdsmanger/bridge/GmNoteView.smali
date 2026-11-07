.class final Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;
.super Landroid/widget/FrameLayout;
.source "GmNoteView.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;
    }
.end annotation


# static fields
.field private static final BALL_D:I = 0x36

.field private static final BALL_IS_BALL:I = 0x1

.field private static final CARD_W:I = 0xfa

.field private static final C_BTN:I = -0x22d4d4d5

.field private static final C_SUB:I = -0x66e4e4e5

.field private static final C_TXT:I = -0xe4e4e5

.field private static final HANDLE:I = 0x0

.field private static final TEXT_H:I = 0x96


# instance fields
.field private final act:Landroid/app/Activity;

.field private ball:Landroid/widget/TextView;

.field private card:Landroid/widget/LinearLayout;

.field private counter:Landroid/widget/TextView;

.field private edit:Landroid/widget/EditText;

.field private editing:Z


# direct methods
.method constructor <init>(Landroid/app/Activity;)V
    .registers 3

    .line 75
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const/4 v0, 0x0

    .line 72
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    .line 76
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->act:Landroid/app/Activity;

    .line 77
    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setClipChildren(Z)V

    .line 78
    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setClipToPadding(Z)V

    .line 79
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->buildCard()V

    .line 80
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->buildBall()V

    .line 81
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    return-void
.end method

.method static synthetic access$000(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->doAdd()V

    return-void
.end method

.method static synthetic access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    return-void
.end method

.method static synthetic access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->doDel()V

    return-void
.end method

.method static synthetic access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->doMin()V

    return-void
.end method

.method static synthetic access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)Z
    .registers 1

    .line 49
    iget-boolean p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    return p0
.end method

.method static synthetic access$500(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->beginEdit()V

    return-void
.end method

.method static synthetic access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->endEdit()V

    return-void
.end method

.method static synthetic access$700(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 1

    .line 49
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->clamp()V

    return-void
.end method

.method private applyLook()V
    .registers 8

    .line 280
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 281
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->cfgBg(Landroid/content/Context;)I

    move-result v1

    .line 282
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->cfgAlpha(Landroid/content/Context;)I

    move-result v2

    const/4 v3, 0x0

    if-gez v2, :cond_10

    move v2, v3

    :cond_10
    const/16 v4, 0xff

    if-le v2, v4, :cond_15

    move v2, v4

    :cond_15
    const v5, 0xffffff

    and-int/2addr v1, v5

    and-int/2addr v2, v4

    shl-int/lit8 v2, v2, 0x18

    or-int/2addr v1, v2

    .line 287
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 288
    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 289
    invoke-virtual {v2, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v3, 0x41600000    # 14.0f

    .line 290
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/high16 v3, 0x3f800000    # 1.0f

    .line 291
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    and-int/2addr v5, v1

    const/high16 v6, 0x33000000

    or-int/2addr v5, v6

    invoke-virtual {v2, v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 292
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    invoke-virtual {v4, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 294
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v4, 0x1

    .line 295
    invoke-virtual {v2, v4}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 296
    invoke-virtual {v2, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 297
    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v1

    invoke-virtual {v2, v1, v5}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 298
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 300
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->cfgSize(Landroid/content/Context;)I

    move-result v0

    int-to-float v0, v0

    const/4 v1, 0x2

    invoke-virtual {p0, v1, v0}, Landroid/widget/EditText;->setTextSize(IF)V

    return-void
.end method

.method private beginEdit()V
    .registers 4

    const/4 v0, 0x1

    .line 338
    :try_start_1
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    .line 339
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setFocusableInTouchMode(Z)V

    .line 340
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setFocusable(Z)V

    .line 341
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setCursorVisible(Z)V

    .line 342
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->requestFocus()Z

    .line 343
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-interface {v1}, Landroid/text/Editable;->length()I

    move-result v1

    if-ltz v1, :cond_28

    .line 344
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v2, v1}, Landroid/widget/EditText;->setSelection(I)V

    .line 346
    :cond_28
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "input_method"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/inputmethod/InputMethodManager;

    if-eqz v1, :cond_3b

    .line 347
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, p0, v0}, Landroid/view/inputmethod/InputMethodManager;->showSoftInput(Landroid/view/View;I)Z
    :try_end_3b
    .catchall {:try_start_1 .. :try_end_3b} :catchall_3c

    :cond_3b
    return-void

    :catchall_3c
    move-exception p0

    .line 349
    const-string v0, "\u3010GmNote\u3011\u8fdb\u7f16\u8f91\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private buildBall()V
    .registers 6

    .line 173
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 174
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    .line 175
    const-string v2, "\u25a4"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 176
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const/4 v2, 0x2

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 177
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const v2, -0xe4e4e5

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 178
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const/16 v2, 0x11

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V

    .line 179
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setIncludeFontPadding(Z)V

    .line 180
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const-string v2, "\u4fbf\u7b7e"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 181
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    const/16 v2, 0x8

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 183
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;

    const/4 v3, 0x1

    invoke-direct {v2, p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;I)V

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 184
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v3, 0x42580000    # 54.0f

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v0

    invoke-direct {v2, v4, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method private buildCard()V
    .registers 12

    .line 87
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 88
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    const/4 v2, 0x1

    .line 89
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 90
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    const/high16 v3, 0x41000000    # 8.0f

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    const/high16 v5, 0x40800000    # 4.0f

    invoke-static {v0, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v5

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v3

    invoke-virtual {v1, v4, v5, v6, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 93
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    .line 94
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v4, 0x10

    .line 95
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 97
    const-string v4, "\u2261"

    const/4 v5, 0x0

    invoke-direct {p0, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 98
    const-string v6, "\u62d6\u52a8"

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 99
    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setClickable(Z)V

    .line 100
    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;

    invoke-direct {v6, p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;I)V

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    const/high16 v6, 0x41f00000    # 30.0f

    .line 101
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    const/high16 v7, 0x41d00000    # 26.0f

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v8

    invoke-direct {p0, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 103
    new-instance v4, Landroid/view/View;

    invoke-direct {v4, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 104
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v8, 0x3f800000    # 1.0f

    invoke-direct {v6, v3, v2, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 106
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$1;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v6, "\uff0b"

    invoke-direct {p0, v6, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 108
    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v8

    invoke-direct {p0, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    .line 106
    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 110
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v6, "\u2039"

    invoke-direct {p0, v6, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    const/high16 v6, 0x41b00000    # 22.0f

    .line 112
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v8

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v9

    invoke-direct {p0, v8, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v8

    .line 110
    invoke-virtual {v1, v4, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 114
    const-string v4, "1/1"

    invoke-direct {p0, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    iput-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->counter:Landroid/widget/TextView;

    const/4 v8, 0x2

    const/high16 v9, 0x41300000    # 11.0f

    .line 115
    invoke-virtual {v4, v8, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 116
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->counter:Landroid/widget/TextView;

    const v8, -0x66e4e4e5

    invoke-virtual {v4, v8}, Landroid/widget/TextView;->setTextColor(I)V

    .line 117
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->counter:Landroid/widget/TextView;

    const/high16 v9, 0x42080000    # 34.0f

    invoke-static {v0, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v9

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v10

    invoke-direct {p0, v9, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v9

    invoke-virtual {v1, v4, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 119
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$3;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v9, "\u203a"

    invoke-direct {p0, v9, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 121
    invoke-static {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v9

    invoke-direct {p0, v6, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    .line 119
    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 123
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$4;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$4;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v6, "\uff0d"

    invoke-direct {p0, v6, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 125
    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v9

    invoke-direct {p0, v6, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    .line 123
    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 127
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$5;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$5;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v6, "\u25a3"

    invoke-direct {p0, v6, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 129
    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v9

    invoke-direct {p0, v6, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    .line 127
    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 131
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$6;

    invoke-direct {v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$6;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    const-string v6, "\u2715"

    invoke-direct {p0, v6, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v4

    .line 133
    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v7

    invoke-direct {p0, v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->lp(II)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v6

    .line 131
    invoke-virtual {v1, v4, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 135
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v9, -0x2

    invoke-direct {v6, v7, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 139
    new-instance v1, Landroid/widget/EditText;

    invoke-direct {v1, v0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    .line 140
    invoke-virtual {v1, v5}, Landroid/widget/EditText;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 141
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const v4, 0x800033

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setGravity(I)V

    .line 142
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const/high16 v4, 0x40c00000    # 6.0f

    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    invoke-virtual {v1, v3, v4, v3, v3}, Landroid/widget/EditText;->setPadding(IIII)V

    .line 143
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const v4, -0xe4e4e5

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setTextColor(I)V

    .line 144
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const-string v4, "\u70b9\u4e00\u4e0b\uff0c\u5199\u70b9\u4ec0\u4e48\u2026"

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 145
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v8}, Landroid/widget/EditText;->setHintTextColor(I)V

    .line 146
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const v4, 0xa0001

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setInputType(I)V

    .line 149
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    const v4, 0x10000001

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setImeOptions(I)V

    .line 151
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setIncludeFontPadding(Z)V

    .line 152
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v3}, Landroid/widget/EditText;->setFocusable(Z)V

    .line 153
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v3}, Landroid/widget/EditText;->setFocusableInTouchMode(Z)V

    .line 154
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v3}, Landroid/widget/EditText;->setCursorVisible(Z)V

    .line 155
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 160
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$8;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$8;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 165
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v4, 0x436a0000    # 234.0f

    .line 166
    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    const/high16 v5, 0x43160000    # 150.0f

    invoke-static {v0, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v0

    invoke-direct {v3, v4, v0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 165
    invoke-virtual {v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 168
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v1, v9, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method private clamp()V
    .registers 10

    .line 477
    :try_start_0
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    if-nez v0, :cond_9

    goto :goto_63

    .line 479
    :cond_9
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 480
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-lez v1, :cond_63

    if-gtz v0, :cond_16

    goto :goto_63

    .line 482
    :cond_16
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getWidth()I

    move-result v2

    int-to-float v2, v2

    .line 483
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getHeight()I

    move-result v3

    int-to-float v3, v3

    const/4 v4, 0x0

    cmpg-float v5, v2, v4

    if-lez v5, :cond_63

    cmpg-float v5, v3, v4

    if-gtz v5, :cond_2a

    goto :goto_63

    .line 485
    :cond_2a
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getX()F

    move-result v5

    .line 486
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getY()F

    move-result v6

    neg-float v7, v2

    const/high16 v8, 0x3f000000    # 0.5f

    mul-float/2addr v7, v8

    int-to-float v1, v1

    mul-float/2addr v2, v8

    sub-float/2addr v1, v2

    int-to-float v0, v0

    mul-float/2addr v3, v8

    sub-float/2addr v0, v3

    cmpg-float v2, v1, v7

    if-gez v2, :cond_41

    move v1, v7

    :cond_41
    cmpg-float v2, v0, v4

    if-gez v2, :cond_46

    move v0, v4

    :cond_46
    cmpg-float v2, v5, v7

    if-gez v2, :cond_4b

    move v5, v7

    :cond_4b
    cmpl-float v2, v5, v1

    if-lez v2, :cond_50

    goto :goto_51

    :cond_50
    move v1, v5

    :goto_51
    cmpg-float v2, v6, v4

    if-gez v2, :cond_56

    goto :goto_57

    :cond_56
    move v4, v6

    :goto_57
    cmpl-float v2, v4, v0

    if-lez v2, :cond_5c

    goto :goto_5d

    :cond_5c
    move v0, v4

    .line 497
    :goto_5d
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setX(F)V

    .line 498
    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setY(F)V
    :try_end_63
    .catchall {:try_start_0 .. :try_end_63} :catchall_63

    :catchall_63
    :cond_63
    :goto_63
    return-void
.end method

.method private commitEdit()V
    .registers 3

    .line 321
    :try_start_0
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    if-nez v0, :cond_5

    goto :goto_30

    :cond_5
    const/4 v0, 0x0

    .line 322
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_2a

    .line 324
    :try_start_8
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setFocusable(Z)V

    .line 325
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setFocusableInTouchMode(Z)V

    .line 326
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setCursorVisible(Z)V
    :try_end_17
    .catchall {:try_start_8 .. :try_end_17} :catchall_17

    .line 329
    :catchall_17
    :try_start_17
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setText(Ljava/lang/String;)V

    .line 330
    const-string p0, "\u3010GmNote\u3011\u843d\u76d8\u5f53\u524d\u9875\uff08\u5207\u9875/\u589e\u5220\u524d\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_29
    .catchall {:try_start_17 .. :try_end_29} :catchall_2a

    goto :goto_30

    :catchall_2a
    move-exception p0

    .line 332
    const-string v0, "\u3010GmNote\u3011\u843d\u76d8\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_30
    return-void
.end method

.method private doAdd()V
    .registers 2

    .line 387
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    .line 388
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->addItem()V

    .line 389
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    .line 390
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$11;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$11;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private doDel()V
    .registers 1

    .line 396
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    .line 397
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->delItem()V

    .line 398
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    return-void
.end method

.method private doMin()V
    .registers 4

    .line 402
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    .line 403
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "min"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setMin(Z)V

    .line 404
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    return-void
.end method

.method private endEdit()V
    .registers 3

    .line 355
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    if-nez v0, :cond_5

    goto :goto_20

    .line 356
    :cond_5
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    .line 359
    :try_start_8
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "input_method"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    if-eqz v0, :cond_20

    .line 360
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p0

    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z
    :try_end_20
    .catchall {:try_start_8 .. :try_end_20} :catchall_20

    :catchall_20
    :cond_20
    :goto_20
    return-void
.end method

.method private lp(II)Landroid/widget/LinearLayout$LayoutParams;
    .registers 3

    .line 188
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p0, p1, p2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    return-object p0
.end method

.method private mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;
    .registers 8

    .line 192
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 193
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 194
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v2, 0x41700000    # 15.0f

    .line 195
    invoke-virtual {v1, p1, v2}, Landroid/widget/TextView;->setTextSize(IF)V

    const p1, -0x22d4d4d5

    .line 196
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 p1, 0x11

    .line 197
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setGravity(I)V

    const/4 p1, 0x1

    .line 198
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setSingleLine(Z)V

    const/4 p1, 0x0

    .line 199
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setIncludeFontPadding(Z)V

    if-eqz p2, :cond_44

    const/high16 p1, 0x40000000    # 2.0f

    .line 201
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v2

    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v3

    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v4

    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result p1

    invoke-virtual {v1, v2, v3, v4, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 202
    new-instance p1, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;

    invoke-direct {p1, p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;Ljava/lang/Runnable;)V

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :cond_44
    return-object v1
.end method


# virtual methods
.method bootstrap()V
    .registers 2

    .line 219
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    .line 220
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method refreshAll()V
    .registers 7

    .line 245
    :try_start_0
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    .line 246
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->state()Lorg/json/JSONObject;

    move-result-object v0

    .line 247
    const-string v1, "min"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 248
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curIdx()I

    move-result v1

    .line 249
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->total()I

    move-result v3

    .line 251
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->counter:Landroid/widget/TextView;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "/"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 253
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curItem()Lorg/json/JSONObject;

    move-result-object v1

    .line 254
    const-string v3, "t"

    const-string v4, ""

    invoke-virtual {v1, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 258
    iget-boolean v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z

    if-eqz v3, :cond_47

    .line 261
    const-string v1, "\u3010GmNote\u3011\u26a0\ufe0f \u5237\u65b0\u65f6\u4ecd\u5728\u7f16\u8f91\u4e2d\uff08\u6709\u8c03\u7528\u70b9\u6f0f\u4e86 commitEdit\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_5c

    .line 262
    :cond_47
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_5c

    .line 263
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {v3, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 266
    :cond_5c
    :goto_5c
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->applyLook()V

    .line 268
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->card:Landroid/widget/LinearLayout;

    const/16 v3, 0x8

    if-eqz v0, :cond_67

    move v4, v3

    goto :goto_68

    :cond_67
    move v4, v2

    :goto_68
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 269
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->ball:Landroid/widget/TextView;

    if-eqz v0, :cond_70

    goto :goto_71

    :cond_70
    move v2, v3

    :goto_71
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 272
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->requestLayout()V
    :try_end_77
    .catchall {:try_start_0 .. :try_end_77} :catchall_78

    return-void

    :catchall_78
    move-exception p0

    .line 274
    const-string v0, "\u3010GmNote\u3011\u5237\u65b0\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method saveNow()V
    .registers 3

    .line 373
    :try_start_0
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V

    .line 376
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "input_method"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    if-eqz v0, :cond_1b

    .line 377
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->edit:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p0

    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z
    :try_end_1b
    .catchall {:try_start_0 .. :try_end_1b} :catchall_1b

    :catchall_1b
    :cond_1b
    return-void
.end method

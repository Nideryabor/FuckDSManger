.class public final Lcom/nidyaber/fuckdsmanger/gm/GmUi;
.super Ljava/lang/Object;
.source "GmUi.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;
    }
.end annotation


# static fields
.field public static final ACCENT:I = -0xaf840e

.field public static final ACCENT_DARK:I = -0xfbe1b7

.field public static final ACCENT_SOFT:I = -0x2c1c03


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static attach(Landroid/app/Dialog;Landroid/view/View;)V
    .registers 2

    .line 376
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sc(Landroid/app/Dialog;Landroid/view/View;)V

    return-void
.end method

.method public static box(Landroid/content/Context;III)Landroid/widget/LinearLayout;
    .registers 7

    .line 358
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    .line 359
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 360
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    .line 361
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    invoke-direct {v1, v2, p1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 360
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 362
    invoke-static {p0, p2, p3}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    return-object v0
.end method

.method public static button(Landroid/content/Context;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;
    .registers 7

    .line 194
    new-instance v0, Landroid/widget/Button;

    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    .line 195
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x0

    .line 196
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setAllCaps(Z)V

    const/4 p1, 0x2

    const/high16 v1, 0x41600000    # 14.0f

    .line 197
    invoke-virtual {v0, p1, v1}, Landroid/widget/Button;->setTextSize(IF)V

    const p1, -0xaf840e

    .line 198
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setTextColor(I)V

    .line 199
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result p1

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v1

    const/4 v2, 0x1

    const/16 v3, 0xc

    invoke-static {p0, p1, v3, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->roundStroke(Landroid/content/Context;IIII)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 200
    invoke-virtual {v0, p2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 201
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 p2, -0x1

    const/4 v1, -0x2

    invoke-direct {p1, p2, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/4 p2, 0x6

    .line 203
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    iput p0, p1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 204
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static chip(Landroid/content/Context;IZLandroid/view/View$OnClickListener;)Landroid/view/View;
    .registers 7

    .line 210
    new-instance v0, Landroid/view/View;

    invoke-direct {v0, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    const/16 v1, 0x22

    .line 211
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    .line 212
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v2, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v1, 0x8

    .line 213
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    iput v1, v2, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    .line 214
    invoke-virtual {v0, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v1, 0xa

    if-eqz p2, :cond_28

    const p2, -0xaf840e

    const/4 v2, 0x3

    .line 215
    invoke-static {p0, p1, v1, p2, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->roundStroke(Landroid/content/Context;IIII)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p0

    goto :goto_2c

    :cond_28
    invoke-static {p0, p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p0

    :goto_2c
    invoke-virtual {v0, p0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 216
    invoke-virtual {v0, p3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method

.method public static column(Landroid/content/Context;)Landroid/widget/LinearLayout;
    .registers 5

    .line 53
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    .line 54
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v1, 0x10

    .line 55
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    const/16 v2, 0x8

    .line 56
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-virtual {v0, v1, v3, v1, p0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    return-object v0
.end method

.method public static desc(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    .line 113
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 114
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v1, 0x41400000    # 12.0f

    .line 115
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 116
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x6

    .line 117
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    const/4 p1, 0x0

    invoke-virtual {v0, p1, p1, p1, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method public static divider(Landroid/content/Context;)Landroid/view/View;
    .registers 5

    .line 133
    new-instance v0, Landroid/view/View;

    invoke-direct {v0, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 134
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    .line 135
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x1

    .line 136
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    const/4 v3, -0x1

    invoke-direct {v1, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/4 v2, 0x6

    .line 137
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    iput v3, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 138
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    iput p0, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 139
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static glyph(Landroid/content/Context;Ljava/lang/String;II)Landroid/widget/TextView;
    .registers 5

    .line 274
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 275
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p0, 0x2

    int-to-float p1, p2

    .line 276
    invoke-virtual {v0, p0, p1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 277
    invoke-virtual {v0, p3}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 p0, 0x11

    .line 278
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setGravity(I)V

    return-object v0
.end method

.method public static groupBg(Landroid/content/Context;III)Landroid/graphics/drawable/GradientDrawable;
    .registers 8

    .line 225
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 226
    invoke-virtual {v0, p3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 p3, 0x1c

    .line 227
    invoke-static {p0, p3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p3

    int-to-float p3, p3

    const/16 v1, 0x8

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    if-nez p1, :cond_1a

    move v2, p3

    goto :goto_1b

    :cond_1a
    move v2, p0

    :goto_1b
    const/4 v3, 0x1

    sub-int/2addr p2, v3

    if-ne p1, p2, :cond_20

    goto :goto_21

    :cond_20
    move p3, p0

    .line 230
    :goto_21
    new-array p0, v1, [F

    const/4 p1, 0x0

    aput v2, p0, p1

    aput v2, p0, v3

    const/4 p1, 0x2

    aput v2, p0, p1

    const/4 p1, 0x3

    aput v2, p0, p1

    const/4 p1, 0x4

    aput p3, p0, p1

    const/4 p1, 0x5

    aput p3, p0, p1

    const/4 p1, 0x6

    aput p3, p0, p1

    const/4 p1, 0x7

    aput p3, p0, p1

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadii([F)V

    return-object v0
.end method

.method static synthetic lambda$navBar$0(Landroid/view/View$OnClickListener;Landroid/view/View;)V
    .registers 2

    if-eqz p0, :cond_5

    .line 349
    invoke-interface {p0, p1}, Landroid/view/View$OnClickListener;->onClick(Landroid/view/View;)V

    :cond_5
    return-void
.end method

.method public static listRow(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZIILandroid/view/View$OnClickListener;)Landroid/view/View;
    .registers 14

    .line 285
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    .line 286
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    .line 287
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 288
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v4, 0x48

    .line 289
    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, -0x1

    invoke-direct {v3, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 288
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 290
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v3

    invoke-static {p0, p5, p6, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->groupBg(Landroid/content/Context;III)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p5

    invoke-virtual {v0, p5}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 291
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p5

    const/16 p6, 0xc

    invoke-static {p0, p6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p6

    invoke-virtual {v0, p5, v1, p6, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    if-eqz p7, :cond_3a

    .line 292
    invoke-virtual {v0, p7}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :cond_3a
    const/16 p5, 0x14

    const/4 p6, 0x1

    if-eqz p1, :cond_84

    .line 295
    new-instance p7, Landroid/widget/LinearLayout;

    invoke-direct {p7, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/16 v3, 0x11

    .line 296
    invoke-virtual {p7, v3}, Landroid/widget/LinearLayout;->setGravity(I)V

    const v3, -0x2c1c03

    .line 297
    invoke-static {p0, v3, p5}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v3

    invoke-virtual {p7, v3}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 298
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v4, 0x28

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-direct {v3, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p7, v3}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v3, 0x12

    const v4, -0xaf840e

    .line 299
    invoke-static {p0, p1, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->glyph(Landroid/content/Context;Ljava/lang/String;II)Landroid/widget/TextView;

    move-result-object p1

    invoke-virtual {p7, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 300
    invoke-virtual {v0, p7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 301
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->space(Landroid/content/Context;I)Landroid/view/View;

    move-result-object p1

    new-instance p7, Landroid/widget/LinearLayout$LayoutParams;

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-direct {p7, v2, p6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p1, p7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 303
    :cond_84
    new-instance p1, Landroid/widget/LinearLayout;

    invoke-direct {p1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 304
    invoke-virtual {p1, p6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 305
    new-instance p6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 p7, -0x2

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-direct {p6, v1, p7, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p1, p6}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 306
    new-instance p6, Landroid/widget/TextView;

    invoke-direct {p6, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 307
    invoke-virtual {p6, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 p2, 0x41800000    # 16.0f

    const/4 p7, 0x2

    .line 308
    invoke-virtual {p6, p7, p2}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 309
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p2

    invoke-virtual {p6, p2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 310
    invoke-virtual {p1, p6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    if-eqz p3, :cond_cf

    .line 312
    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 313
    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 p3, 0x41500000    # 13.0f

    .line 314
    invoke-virtual {p2, p7, p3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 315
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result p3

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p3, 0x0

    const p6, 0x3fa66666    # 1.3f

    .line 316
    invoke-virtual {p2, p3, p6}, Landroid/widget/TextView;->setLineSpacing(FF)V

    .line 317
    invoke-virtual {p1, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 319
    :cond_cf
    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    if-eqz p4, :cond_e1

    .line 321
    const-string p1, "\u203a"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result p2

    invoke-static {p0, p1, p5, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->glyph(Landroid/content/Context;Ljava/lang/String;II)Landroid/widget/TextView;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :cond_e1
    return-object v0
.end method

.method public static margin(Landroid/view/View;Landroid/content/Context;IIII)V
    .registers 8

    .line 83
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 84
    instance-of v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v1, :cond_20

    .line 85
    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 86
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p2

    invoke-static {p1, p3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p3

    invoke-static {p1, p4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p4

    invoke-static {p1, p5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    invoke-virtual {v0, p2, p3, p4, p1}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    .line 87
    invoke-virtual {p0, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_20
    return-void
.end method

.method public static menu(Landroid/content/Context;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .registers 7

    .line 147
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 148
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "   \u203a"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v1, 0x41800000    # 16.0f

    .line 149
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 150
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x4

    .line 151
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    const/16 v2, 0xe

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v0, v1, v3, p1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 152
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result p1

    const/16 v1, 0xc

    invoke-static {p0, p1, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 153
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method

.method public static navBar(Landroid/content/Context;[Ljava/lang/String;[Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/LinearLayout;
    .registers 14

    .line 329
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    .line 330
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x11

    .line 331
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 332
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v4, 0x50

    .line 333
    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, -0x1

    invoke-direct {v3, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 332
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 334
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    move v3, v1

    .line 335
    :goto_25
    array-length v4, p1

    if-ge v3, v4, :cond_b1

    .line 336
    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v5, 0x1

    .line 337
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 338
    invoke-virtual {v4, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v5, 0xc

    .line 339
    invoke-static {p0, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v6

    const/4 v7, 0x6

    invoke-static {p0, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-static {p0, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {p0, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-virtual {v4, v6, v8, v5, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    if-ne v3, p3, :cond_50

    const v5, -0x2c1c03

    goto :goto_51

    :cond_50
    move v5, v1

    :goto_51
    const/16 v6, 0x10

    .line 340
    invoke-static {p0, v5, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 341
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v5, v1, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 342
    aget-object v5, p2, v3

    if-ne v3, p3, :cond_6d

    const v6, -0xaf840e

    goto :goto_71

    :cond_6d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v6

    :goto_71
    const/16 v7, 0x14

    invoke-static {p0, v5, v7, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->glyph(Landroid/content/Context;Ljava/lang/String;II)Landroid/widget/TextView;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 343
    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 344
    aget-object v6, p1, v3

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v6, 0x2

    const/high16 v7, 0x41400000    # 12.0f

    .line 345
    invoke-virtual {v5, v6, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    if-ne v3, p3, :cond_91

    .line 346
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v6

    goto :goto_95

    :cond_91
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v6

    :goto_95
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 347
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 349
    new-instance v5, Lcom/nidyaber/fuckdsmanger/gm/GmUi$0;

    invoke-direct {v5, p4}, Lcom/nidyaber/fuckdsmanger/gm/GmUi$0;-><init>(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 350
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setTag(Ljava/lang/Object;)V

    .line 351
    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_25

    :cond_b1
    return-object v0
.end method

.method public static pad(Landroid/view/View;Landroid/content/Context;I)V
    .registers 3

    .line 77
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    .line 78
    invoke-virtual {p0, p1, p1, p1, p1}, Landroid/view/View;->setPadding(IIII)V

    return-void
.end method

.method public static round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;
    .registers 4

    .line 62
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 63
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 64
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    return-object v0
.end method

.method public static roundStroke(Landroid/content/Context;IIII)Landroid/graphics/drawable/GradientDrawable;
    .registers 5

    .line 70
    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p1

    .line 71
    invoke-static {p0, p4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-virtual {p1, p0, p3}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    return-object p1
.end method

.method public static sectionLabel(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .registers 5

    .line 264
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 265
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v1, 0x41800000    # 16.0f

    .line 266
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 267
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x4

    .line 268
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    const/4 v1, 0x6

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    const/16 v2, 0x8

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    const/4 v2, 0x0

    invoke-virtual {v0, p1, v1, v2, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method public static space(Landroid/content/Context;I)Landroid/view/View;
    .registers 5

    .line 93
    new-instance v0, Landroid/view/View;

    invoke-direct {v0, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 94
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, 0x1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-direct {v1, v2, p0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

.method public static switchRow(Landroid/content/Context;Ljava/lang/String;ZLandroid/widget/CompoundButton$OnCheckedChangeListener;)Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;
    .registers 10

    .line 160
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    .line 161
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    .line 162
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/4 v2, 0x4

    .line 163
    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    const/4 v4, 0x6

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v0, v3, v5, v2, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 165
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 166
    invoke-virtual {v2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v3, 0x41700000    # 15.0f

    .line 167
    invoke-virtual {v2, p1, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 168
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p1

    invoke-virtual {v2, p1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 169
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-direct {p1, v1, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, p1}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 171
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 173
    new-instance p1, Landroid/widget/Switch;

    invoke-direct {p1, p0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    .line 174
    invoke-virtual {p1, p2}, Landroid/widget/Switch;->setChecked(Z)V

    if-eqz p3, :cond_53

    .line 175
    invoke-virtual {p1, p3}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 176
    :cond_53
    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 178
    new-instance p0, Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;

    invoke-direct {p0, v0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;-><init>(Landroid/widget/LinearLayout;Landroid/widget/Switch;)V

    return-object p0
.end method

.method public static text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    .line 123
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 124
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v1, 0x41500000    # 13.0f

    .line 125
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 126
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p0, 0x1

    .line 127
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setTextIsSelectable(Z)V

    return-object v0
.end method

.method public static title(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    .line 102
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 103
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v1, 0x41880000    # 17.0f

    .line 104
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 105
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 106
    invoke-virtual {v0}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object p1

    const/4 v1, 0x1

    invoke-virtual {p1, v1}, Landroid/text/TextPaint;->setFakeBoldText(Z)V

    const/16 p1, 0xa

    .line 107
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p1

    const/4 v1, 0x4

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result p0

    const/4 v1, 0x0

    invoke-virtual {v0, v1, p1, v1, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method public static topBar(Landroid/content/Context;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/LinearLayout;
    .registers 9

    .line 236
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    .line 237
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    .line 238
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v3, 0x40

    .line 239
    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    .line 240
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {v4, v5, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v3, 0x4

    .line 241
    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v0, v3, v1, v2, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    if-eqz p2, :cond_5e

    const/16 v2, 0x16

    .line 243
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v3

    const-string v4, "\u2190"

    invoke-static {p0, v4, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->glyph(Landroid/content/Context;Ljava/lang/String;II)Landroid/widget/TextView;

    move-result-object v2

    const/16 v3, 0x11

    .line 244
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    .line 245
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v4, 0x30

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {p0, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-direct {v3, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 246
    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const/16 p2, 0x18

    .line 247
    invoke-static {p0, v1, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->round(Landroid/content/Context;II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p2

    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 248
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    goto :goto_71

    .line 250
    :cond_5e
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUi;->space(Landroid/content/Context;I)Landroid/view/View;

    move-result-object p2

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v3, 0xc

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    const/4 v4, 0x1

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p2, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 252
    :goto_71
    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 253
    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x2

    const/high16 v2, 0x41b00000    # 22.0f

    .line 254
    invoke-virtual {p2, p1, v2}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 255
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result p0

    invoke-virtual {p2, p0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 256
    invoke-virtual {p2}, Landroid/widget/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroid/text/TextPaint;->setFakeBoldText(Z)V

    .line 257
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    const/4 p1, -0x2

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-direct {p0, v1, p1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p2, p0}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 258
    invoke-virtual {v0, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v0
.end method

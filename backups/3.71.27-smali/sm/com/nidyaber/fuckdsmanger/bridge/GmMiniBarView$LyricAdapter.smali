.class final Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;
.super Landroid/widget/BaseAdapter;
.source "GmMiniBarView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "LyricAdapter"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method private constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 796
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;)V
    .registers 3

    .line 796
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    return-void
.end method


# virtual methods
.method public getCount()I
    .registers 1

    .line 799
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .registers 3

    if-ltz p1, :cond_19

    .line 804
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-ge p1, v0, :cond_19

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    return-object p0

    :cond_19
    const/4 p0, 0x0

    return-object p0
.end method

.method public getItemId(I)J
    .registers 2

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .registers 9

    .line 814
    iget-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p3

    .line 816
    instance-of v0, p2, Landroid/widget/TextView;

    const/4 v1, -0x1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_10

    .line 817
    check-cast p2, Landroid/widget/TextView;

    goto :goto_38

    .line 819
    :cond_10
    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 820
    invoke-virtual {p2, v2}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 821
    sget-object p3, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    const/16 p3, 0x10

    .line 822
    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setGravity(I)V

    .line 823
    invoke-virtual {p2, v3}, Landroid/widget/TextView;->setIncludeFontPadding(Z)V

    .line 824
    invoke-virtual {p2, v3, v3, v3, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 825
    new-instance p3, Landroid/widget/AbsListView$LayoutParams;

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 v4, 0x41e00000    # 28.0f

    .line 826
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v0

    invoke-direct {p3, v1, v0}, Landroid/widget/AbsListView$LayoutParams;-><init>(II)V

    .line 825
    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :goto_38
    if-ltz p1, :cond_53

    .line 829
    iget-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object p3

    invoke-interface {p3}, Ljava/util/List;->size()I

    move-result p3

    if-ge p1, p3, :cond_53

    iget-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object p3

    invoke-interface {p3, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Ljava/lang/String;

    goto :goto_55

    :cond_53
    const-string p3, ""

    .line 830
    :goto_55
    invoke-virtual {p3}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_5d

    const-string p3, "\u266a"

    :cond_5d
    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 832
    iget-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F
    invoke-static {p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)F

    move-result p3

    const/high16 v0, 0x3f000000    # 0.5f

    cmpl-float p3, p3, v0

    if-lez p3, :cond_6d

    goto :goto_6e

    :cond_6d
    move v2, v3

    .line 833
    :goto_6e
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I

    move-result p0

    const/4 p3, 0x2

    const/4 v0, 0x0

    if-ne p1, p0, :cond_98

    if-eqz v2, :cond_7d

    const/high16 p0, 0x41880000    # 17.0f

    goto :goto_7f

    :cond_7d
    const/high16 p0, 0x41700000    # 15.0f

    .line 835
    :goto_7f
    invoke-virtual {p2, p3, p0}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 836
    sget-object p0, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p2, p0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    if-eqz v2, :cond_8a

    goto :goto_8d

    :cond_8a
    const v1, -0xb05701

    .line 838
    :goto_8d
    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p0, 0x40400000    # 3.0f

    const/high16 p1, -0x74000000

    .line 839
    invoke-virtual {p2, p0, v0, v0, p1}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    return-object p2

    :cond_98
    if-eqz v2, :cond_9d

    const/high16 p0, 0x41500000    # 13.0f

    goto :goto_9f

    :cond_9d
    const/high16 p0, 0x41480000    # 12.5f

    .line 841
    :goto_9f
    invoke-virtual {p2, p3, p0}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 842
    sget-object p0, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {p2, p0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    if-eqz v2, :cond_ad

    const p0, -0x4f000001

    goto :goto_b0

    :cond_ad
    const p0, -0x750a0806

    .line 843
    :goto_b0
    invoke-virtual {p2, p0}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p0, 0x40000000    # 2.0f

    const/high16 p1, 0x66000000

    .line 844
    invoke-virtual {p2, p0, v0, v0, p1}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    return-object p2
.end method

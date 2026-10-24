.class public final Lcom/nidyaber/fuckdsmanger/gm/GmRadiusClick;
.super Ljava/lang/Object;
.source "GmRadiusClick.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 6

    :try_start_0
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v0

    instance-of v3, v0, Ljava/lang/Integer;

    if-eqz v3, :cond_15

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->applyRadius(Landroid/content/Context;I)V
    :try_end_15
    .catchall {:try_start_0 .. :try_end_15} :catchall_16

    :cond_15
    return-void

    :catchall_16
    move-exception v0

    return-void
.end method

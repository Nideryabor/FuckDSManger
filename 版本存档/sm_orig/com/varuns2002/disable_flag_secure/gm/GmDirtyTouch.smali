.class public final Lcom/varuns2002/disable_flag_secure/gm/GmDirtyTouch;
.super Ljava/lang/Object;
.source "GmDirtyTouch.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 4

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_9

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->markDirty()V

    :cond_9
    const/4 v0, 0x0

    return v0
.end method

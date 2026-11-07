.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;
.super Ljava/lang/Object;
.source "GmGlassInstall.java"

# interfaces
.implements Landroid/view/Choreographer$FrameCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->startAnim()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field t0:J

.field final synthetic val$ch:Landroid/view/Choreographer;


# direct methods
.method constructor <init>(Landroid/view/Choreographer;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 135
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;->val$ch:Landroid/view/Choreographer;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 136
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;->t0:J

    return-void
.end method


# virtual methods
.method public doFrame(J)V
    .registers 5

    .line 141
    :try_start_0
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$000()Landroid/app/Activity;

    move-result-object p1

    if-eqz p1, :cond_16

    .line 142
    invoke-virtual {p1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p2

    if-nez p2, :cond_d

    goto :goto_16

    .line 143
    :cond_d
    invoke-virtual {p1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p1

    goto :goto_17

    :cond_16
    :goto_16
    const/4 p1, 0x0

    :goto_17
    if-eqz p1, :cond_1c

    .line 144
    invoke-virtual {p1}, Landroid/view/View;->postInvalidateOnAnimation()V

    .line 145
    :cond_1c
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    iget-wide v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;->t0:J

    sub-long/2addr p1, v0

    const-wide/16 v0, 0x4b0

    cmp-long p1, p1, v0

    if-gez p1, :cond_35

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->moving()Z

    move-result p1

    if-eqz p1, :cond_35

    .line 146
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;->val$ch:Landroid/view/Choreographer;

    invoke-virtual {p1, p0}, Landroid/view/Choreographer;->postFrameCallback(Landroid/view/Choreographer$FrameCallback;)V
    :try_end_34
    .catchall {:try_start_0 .. :try_end_34} :catchall_35

    return-void

    :catchall_35
    :cond_35
    const/4 p0, 0x0

    .line 151
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAnimating:Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$202(Z)Z

    return-void
.end method

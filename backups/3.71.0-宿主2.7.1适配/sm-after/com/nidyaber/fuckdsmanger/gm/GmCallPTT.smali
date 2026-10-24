.class public final Lcom/nidyaber/fuckdsmanger/gm/GmCallPTT;
.super Ljava/lang/Object;
.source "GmCallPTT.java"

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
    .registers 5

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-eqz v0, :cond_1e

    const/4 v1, 0x1

    if-ne v0, v1, :cond_17

    const-string p0, "[\u901a\u8bdd] PTT \u62ac\u8d77"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string p0, "\u8bc6\u522b\u4e2d\u2026"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recOff()Z

    goto :goto_2b

    :cond_17
    const/4 v1, 0x3

    if-ne v0, v1, :cond_2b

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recCancel()Z

    goto :goto_2b

    :cond_1e
    const-string p0, "[\u901a\u8bdd] PTT \u6309\u4e0b"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string p0, "\u8046\u542c\u4e2d\u2026"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->recOn()Z

    :cond_2b
    :goto_2b
    const/4 v0, 0x1

    return v0
.end method

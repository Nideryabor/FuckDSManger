.class public final Lcom/nidyaber/fuckdsmanger/gm/GmBgSwitch;
.super Ljava/lang/Object;
.source "GmBgSwitch.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 6

    invoke-virtual {p1}, Landroid/widget/CompoundButton;->getContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_2e

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmBg;->setOn(Landroid/content/Context;Z)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmBg;->ensure(Landroid/content/Context;)V

    if-eqz p2, :cond_29

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v1

    if-nez v1, :cond_1a

    const-string v1, "\u80cc\u666f\u5df2\u5f00\u542f\uff08\u56fe\u7247\u6a21\u5f0f\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_1a
    const/4 v2, 0x2

    if-ne v1, v2, :cond_23

    const-string v1, "\u80cc\u666f\u5df2\u5f00\u542f\uff08\u6444\u50cf\u5934\u53d6\u666f\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_23
    const-string v1, "\u80cc\u666f\u5df2\u5f00\u542f\uff08\u6e10\u53d8\u6a21\u5f0f\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_29
    const-string v1, "\u80cc\u666f\u5df2\u5173\u95ed"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_2e
    return-void
.end method

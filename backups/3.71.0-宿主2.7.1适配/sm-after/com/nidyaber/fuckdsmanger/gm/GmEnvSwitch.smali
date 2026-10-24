.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnvSwitch;
.super Ljava/lang/Object;
.source "GmEnvSwitch.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvSwitch;->m:I

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 6

    invoke-virtual {p1}, Landroid/widget/CompoundButton;->getContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_3f

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvSwitch;->m:I

    if-nez v1, :cond_1b

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->setOn(Landroid/content/Context;Z)V

    if-eqz p2, :cond_15

    const-string v1, "\u73af\u5883\u4f2a\u88c5\u5df2\u5f00\u542f\uff1aroot / \u6a21\u5757\u75d5\u8ff9\u5df2\u9690\u85cf"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_15
    const-string v1, "\u73af\u5883\u4f2a\u88c5\u5df2\u5173\u95ed"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_1b
    const/4 v2, 0x1

    if-ne v1, v2, :cond_2f

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->setApi(Landroid/content/Context;Z)V

    if-eqz p2, :cond_29

    const-string v1, "\u7cfb\u7edf API \u4f2a\u88c5\u5df2\u5f00\u542f"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_29
    const-string v1, "\u7cfb\u7edf API \u4f2a\u88c5\u5df2\u5173\u95ed"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_3f

    :cond_2f
    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->setOn(Landroid/content/Context;Z)V

    if-eqz p2, :cond_3a

    const-string v1, "\u8bbe\u5907\u8eab\u4efd\u4f2a\u88c5\u5df2\u5f00\u542f\uff08\u91cd\u542f\u5bbf\u4e3b\u540e\u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_3a
    const-string v1, "\u8bbe\u5907\u8eab\u4efd\u4f2a\u88c5\u5df2\u5173\u95ed\uff08\u91cd\u542f\u5bbf\u4e3b\u540e\u6062\u590d\u771f\u5b9e\u503c\uff09"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_3f
    :goto_3f
    return-void
.end method

.class public final Lcom/nidyaber/fuckdsmanger/gm/GmAvatarSwitch;
.super Ljava/lang/Object;
.source "GmAvatarSwitch.java"

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

    if-eqz v0, :cond_16

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->setOn(Landroid/content/Context;Z)V

    if-eqz p2, :cond_11

    const-string v1, "\u5df2\u5f00\u542f\uff1a\u70b9\u4e0b\u65b9\u201c\u9009\u62e9\u56fe\u7247\u201d\u8bbe\u7f6e\u52a9\u624b\u5934\u50cf"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_11
    const-string v1, "\u5df2\u5173\u95ed\uff0c\u6062\u590d\u9ed8\u8ba4\u52a9\u624b\u5934\u50cf"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_16
    return-void
.end method

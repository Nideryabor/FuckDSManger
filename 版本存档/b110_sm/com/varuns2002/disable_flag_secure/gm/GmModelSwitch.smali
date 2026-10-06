.class public final Lcom/varuns2002/disable_flag_secure/gm/GmModelSwitch;
.super Ljava/lang/Object;
.source "GmModelSwitch.java"

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

    if-eqz v0, :cond_1f

    invoke-static {v0, p2}, Lcom/varuns2002/disable_flag_secure/gm/GmModel;->setOn(Landroid/content/Context;Z)Z

    move-result v1

    if-nez v1, :cond_12

    const-string v1, "\u4fee\u6539\u5931\u8d25\uff1a\u672a\u627e\u5230\u6a21\u578b\u914d\u7f6e\uff0c\u8bf7\u5148\u5728 App \u5185\u6253\u5f00\u4e00\u6b21\u8bbe\u7f6e\u9875"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_12
    if-eqz p2, :cond_1a

    const-string v1, "\u6a21\u578b\u5207\u6362\u5df2\u542f\u7528\uff1a\u53ef\u5728\u4f1a\u8bdd\u4e2d\u5207\u5230\u4e13\u5bb6\u6a21\u5f0f / \u8bc6\u56fe\u6a21\u5f0f\uff08\u91cd\u542f App \u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_1a
    const-string v1, "\u6a21\u578b\u5207\u6362\u5df2\u7981\u7528\uff08\u91cd\u542f App \u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_1f
    return-void
.end method

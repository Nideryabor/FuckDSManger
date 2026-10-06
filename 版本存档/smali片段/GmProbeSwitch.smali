.class public final Lcom/varuns2002/disable_flag_secure/gm/GmProbeSwitch;
.super Ljava/lang/Object;
.source "GmProbeSwitch.java"
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 5

    invoke-virtual {p1}, Landroid/widget/CompoundButton;->getContext()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :go

    return-void

    :go
    if-eqz p2, :off

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->show(Landroid/content/Context;)V

    const-string v1, "元素捕获器已开启：拖到目标元素上，单击写日志 / 长按复制"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :off
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->hide()V

    const-string v1, "元素捕获器已关闭"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
